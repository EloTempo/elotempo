//! Módulo de fusão de pessoas duplicadas (Merge) e detecção inteligente de duplicatas.

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::Pessoa;
use crate::domain::regras;
use crate::domain::texto::normalizar_busca;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ResumoFusao {
    pub id_mestre: String,
    pub nome_mestre: String,
    pub unioes_afetadas: usize,
    pub eventos_transferidos: usize,
    pub documentos_transferidos: usize,
    pub nomes_transferidos: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CandidatoDuplicata {
    pub pessoa_a: Pessoa,
    pub pessoa_b: Pessoa,
    pub score: u32,
    pub motivo: String,
}

/// Executa a fusão atômica de duas pessoas no banco SQLite.
/// A `pessoa_absorver` é totalmente incorporada à `pessoa_mestre` e depois excluída.
pub async fn executar_fusao(
    pool: &SqlitePool,
    id_mestre: &str,
    id_absorver: &str,
) -> Resultado<ResumoFusao> {
    if id_mestre == id_absorver {
        return Err(ErroDominio::ValorInvalido {
            campo: "id_absorver".into(),
            valor: "Não é possível fundir uma pessoa consigo mesma.".into(),
        });
    }

    // 1. Carrega ambos os registros para validação
    let mestre: Pessoa = sqlx::query_as("SELECT * FROM pessoas WHERE id = ?")
        .bind(id_mestre)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| ErroDominio::PessoaNaoEncontrada(id_mestre.into()))?;

    let absorver: Pessoa = sqlx::query_as("SELECT * FROM pessoas WHERE id = ?")
        .bind(id_absorver)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| ErroDominio::PessoaNaoEncontrada(id_absorver.into()))?;

    // 2. Previne ciclos: não pode fundir se uma é ancestral/descendente direta da outra
    if regras::e_ancestral(pool, id_mestre, id_absorver).await?
        || regras::e_ancestral(pool, id_absorver, id_mestre).await?
    {
        return Err(ErroDominio::CicloGenealogico {
            pessoa_id: id_absorver.into(),
            motivo: "Não é permitido fundir pessoas que possuem relação direta de ascendência ou descendência (pais e filhos/netos).".into(),
        });
    }

    let mut tx = pool.begin().await?;

    // 3. Atualiza dados de identidade do mestre caso estejam vazios e a absorvida possua
    let novo_sobrenome = match (&mestre.sobrenome, &absorver.sobrenome) {
        (Some(s), _) if !s.trim().is_empty() => mestre.sobrenome.clone(),
        (_, Some(s)) if !s.trim().is_empty() => Some(s.clone()),
        _ => mestre.sobrenome.clone(),
    };

    let nova_bio = match (&mestre.minibiografia, &absorver.minibiografia) {
        (Some(b), _) if !b.trim().is_empty() => mestre.minibiografia.clone(),
        (_, Some(b)) if !b.trim().is_empty() => Some(b.clone()),
        _ => mestre.minibiografia.clone(),
    };

    let nova_foto = mestre.foto_url.clone().or_else(|| absorver.foto_url.clone());
    let eh_publico = mestre.is_publico || absorver.is_publico;
    let nova_cat = mestre.categoria.clone().or_else(|| absorver.categoria.clone());

    sqlx::query(
        "UPDATE pessoas
         SET sobrenome = ?, minibiografia = ?, foto_url = ?, is_publico = ?, categoria = ?
         WHERE id = ?",
    )
    .bind(&novo_sobrenome)
    .bind(&nova_bio)
    .bind(&nova_foto)
    .bind(eh_publico)
    .bind(&nova_cat)
    .bind(id_mestre)
    .execute(&mut *tx)
    .await?;

    // 4. Filiação de Origem (Pais):
    // Se o mestre não tinha pais e a pessoa absorvida tinha, o mestre herda a filiação
    let pais_mestre: Option<(String, String)> = sqlx::query_as(
        "SELECT uniao_id, tipo_vinculo FROM uniao_filhos WHERE pessoa_id = ? LIMIT 1",
    )
    .bind(id_mestre)
    .fetch_optional(&mut *tx)
    .await?;

    let pais_absorver: Option<(String, String)> = sqlx::query_as(
        "SELECT uniao_id, tipo_vinculo FROM uniao_filhos WHERE pessoa_id = ? LIMIT 1",
    )
    .bind(id_absorver)
    .fetch_optional(&mut *tx)
    .await?;

    if let Some((uniao_pais_abs, _tipo_vinc)) = pais_absorver {
        if pais_mestre.is_none() {
            // Transfere a filiação para o mestre
            sqlx::query(
                "UPDATE uniao_filhos SET pessoa_id = ? WHERE pessoa_id = ? AND uniao_id = ?",
            )
            .bind(id_mestre)
            .bind(id_absorver)
            .bind(&uniao_pais_abs)
            .execute(&mut *tx)
            .await?;
        } else {
            // O mestre já tem pais. Se for a mesma união, remove a de absorver; se for diferente, remove para não criar 2 origens
            sqlx::query("DELETE FROM uniao_filhos WHERE pessoa_id = ?")
                .bind(id_absorver)
                .execute(&mut *tx)
                .await?;
        }
    }

    // 5. Uniões e Cônjuges:
    // Identifica todas as uniões onde 'absorver' participa
    let unioes_absorver = sqlx::query(
        "SELECT id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota FROM unioes
         WHERE slot_masculino_id = ?1 OR slot_feminino_id = ?1",
    )
    .bind(id_absorver)
    .fetch_all(&mut *tx)
    .await?;

    let mut unioes_afetadas = 0;

    for row in unioes_absorver {
        unioes_afetadas += 1;
        let uid: String = row.get("id");
        let masc: String = row.get("slot_masculino_id");
        let fem: String = row.get("slot_feminino_id");

        let conjuge_id = if masc == id_absorver { fem.clone() } else { masc.clone() };

        // Se o cônjuge da união era o próprio mestre (ex.: cadastradas como casadas por engano):
        if conjuge_id == id_mestre {
            // Remove união reflexiva
            sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = ?")
                .bind(&uid)
                .execute(&mut *tx)
                .await?;
            sqlx::query("DELETE FROM eventos WHERE uniao_id = ?")
                .bind(&uid)
                .execute(&mut *tx)
                .await?;
            sqlx::query("DELETE FROM unioes WHERE id = ?")
                .bind(&uid)
                .execute(&mut *tx)
                .await?;
            continue;
        }

        // Verifica se o mestre já possui união com esse mesmo cônjuge
        let uniao_existente_mestre: Option<String> = sqlx::query_scalar(
            "SELECT id FROM unioes
             WHERE (slot_masculino_id = ?1 AND slot_feminino_id = ?2)
                OR (slot_masculino_id = ?2 AND slot_feminino_id = ?1)
             LIMIT 1",
        )
        .bind(id_mestre)
        .bind(&conjuge_id)
        .fetch_optional(&mut *tx)
        .await?;

        if let Some(uid_existente) = uniao_existente_mestre {
            // 5a. Ambos já tinham união com o mesmo cônjuge!
            // Move os filhos para a união existente. Como pessoa_id é UNIQUE,
            // UPDATE OR IGNORE transfere com segurança os que só estavam em uid.
            sqlx::query("UPDATE OR IGNORE uniao_filhos SET uniao_id = ? WHERE uniao_id = ?")
                .bind(&uid_existente)
                .bind(&uid)
                .execute(&mut *tx)
                .await?;

            // Move eventos da união
            sqlx::query("UPDATE eventos SET uniao_id = ? WHERE uniao_id = ?")
                .bind(&uid_existente)
                .bind(&uid)
                .execute(&mut *tx)
                .await?;

            // Remove a união duplicada (e eventuais sobras)
            sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = ?")
                .bind(&uid)
                .execute(&mut *tx)
                .await?;
            sqlx::query("DELETE FROM unioes WHERE id = ?")
                .bind(&uid)
                .execute(&mut *tx)
                .await?;
        } else {
            // 5b. O mestre não tinha união com este cônjuge: reaproveita a união transferindo o slot
            if masc == id_absorver {
                sqlx::query("UPDATE unioes SET slot_masculino_id = ? WHERE id = ?")
                    .bind(id_mestre)
                    .bind(&uid)
                    .execute(&mut *tx)
                    .await?;
            } else {
                sqlx::query("UPDATE unioes SET slot_feminino_id = ? WHERE id = ?")
                    .bind(id_mestre)
                    .bind(&uid)
                    .execute(&mut *tx)
                    .await?;
            }
        }
    }

    // 6. Nomes:
    // Se o nome de absorver for diferente do mestre, registra como nome alternativo ('outro')
    let mut nomes_transferidos = 0;
    let nome_abs_completo = format!(
        "{}{}",
        absorver.nome,
        absorver
            .sobrenome
            .as_ref()
            .map(|s| format!(" {}", s))
            .unwrap_or_default()
    );
    let nome_mes_completo = format!(
        "{}{}",
        mestre.nome,
        mestre
            .sobrenome
            .as_ref()
            .map(|s| format!(" {}", s))
            .unwrap_or_default()
    );

    if normalizar_busca(&nome_abs_completo) != normalizar_busca(&nome_mes_completo) {
        let nid = format!("nome_{}", Uuid::new_v4());
        sqlx::query(
            "INSERT OR IGNORE INTO nomes_pessoa (id, pessoa_id, nome, sobrenome, tipo, ordem)
             VALUES (?, ?, ?, ?, 'outro', 99)",
        )
        .bind(&nid)
        .bind(id_mestre)
        .bind(&absorver.nome)
        .bind(&absorver.sobrenome)
        .execute(&mut *tx)
        .await?;
        nomes_transferidos += 1;
    }

    // Transfere outros nomes variantes da pessoa absorvida
    let res_nomes = sqlx::query("UPDATE nomes_pessoa SET pessoa_id = ? WHERE pessoa_id = ?")
        .bind(id_mestre)
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;
    nomes_transferidos += res_nomes.rows_affected() as usize;

    // 7. Eventos de vida
    let res_eventos = sqlx::query("UPDATE eventos SET pessoa_id = ? WHERE pessoa_id = ?")
        .bind(id_mestre)
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;
    let eventos_transferidos = res_eventos.rows_affected() as usize;

    // 8. Documentos e Fotos
    let res_docs = sqlx::query("UPDATE documento_vinculos SET pessoa_id = ? WHERE pessoa_id = ?")
        .bind(id_mestre)
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;
    let documentos_transferidos = res_docs.rows_affected() as usize;

    // 9. Atributos de vida em lista
    for tabela in [
        "apelidos_pessoa",
        "nacionalidades_pessoa",
        "religioes_pessoa",
        "escolaridade_pessoa",
        "profissoes_pessoa",
        "idiomas_pessoa",
    ] {
        sqlx::query(&format!("UPDATE {tabela} SET pessoa_id = ? WHERE pessoa_id = ?"))
            .bind(id_mestre)
            .bind(id_absorver)
            .execute(&mut *tx)
            .await?;
    }

    // 10. Participações em marcos
    sqlx::query(
        "UPDATE OR IGNORE marco_participantes SET pessoa_id = ? WHERE pessoa_id = ?",
    )
    .bind(id_mestre)
    .bind(id_absorver)
    .execute(&mut *tx)
    .await?;

    sqlx::query("DELETE FROM marco_participantes WHERE pessoa_id = ?")
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;

    // 11. Árvores e Raízes
    sqlx::query("UPDATE arvores SET raiz_pessoa_id = ? WHERE raiz_pessoa_id = ?")
        .bind(id_mestre)
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;

    sqlx::query(
        "UPDATE OR IGNORE arvore_membros SET pessoa_id = ? WHERE pessoa_id = ?",
    )
    .bind(id_mestre)
    .bind(id_absorver)
    .execute(&mut *tx)
    .await?;

    sqlx::query("DELETE FROM arvore_membros WHERE pessoa_id = ?")
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;

    // 12. Exclusão final do registro absorvido
    sqlx::query("DELETE FROM pessoas WHERE id = ?")
        .bind(id_absorver)
        .execute(&mut *tx)
        .await?;

    tx.commit().await?;

    let nome_completo_mestre = format!(
        "{}{}",
        mestre.nome,
        novo_sobrenome.map(|s| format!(" {}", s)).unwrap_or_default()
    );

    Ok(ResumoFusao {
        id_mestre: id_mestre.to_string(),
        nome_mestre: nome_completo_mestre,
        unioes_afetadas,
        eventos_transferidos,
        documentos_transferidos,
        nomes_transferidos,
    })
}

/// Comando Tauri para executar a fusão de duas pessoas.
#[tauri::command]
pub async fn fundir_pessoas(
    id_mestre: String,
    id_absorver: String,
    ticket_autorizacao: Option<String>,
    db: State<'_, SqlitePool>,
    seguranca: State<'_, crate::domain::seguranca::EstadoSeguranca>,
) -> Resultado<ResumoFusao> {
    crate::domain::seguranca::autorizar_acao_sensivel(&seguranca, None, ticket_autorizacao.as_deref()).await?;
    executar_fusao(&db, &id_mestre, &id_absorver).await
}

/// Detecta pares de pessoas com forte probabilidade de serem duplicatas no acervo.
#[tauri::command]
pub async fn buscar_duplicatas_potenciais(
    limite: usize,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<CandidatoDuplicata>> {
    let pool = &*db;

    // Busca todas as pessoas não-placeholder com seus anos de nascimento e falecimento
    let query = r#"
        SELECT 
            p.id, p.nome, p.sobrenome, p.sexo, p.minibiografia, p.is_vivo, p.is_placeholder, p.foto_url, p.is_publico, p.categoria, p.tipo_tempo,
            ev_nasc.ano_inicio AS ano_nasc,
            ev_falec.ano_inicio AS ano_falec
        FROM pessoas p
        LEFT JOIN eventos ev_nasc ON ev_nasc.pessoa_id = p.id AND ev_nasc.tipo_evento = 'nascimento'
        LEFT JOIN eventos ev_falec ON ev_falec.pessoa_id = p.id AND ev_falec.tipo_evento = 'falecimento'
        WHERE p.is_placeholder = 0
        ORDER BY p.nome, p.sobrenome
    "#;

    let rows = sqlx::query(query).fetch_all(pool).await?;

    struct ItemComparacao {
        pessoa: Pessoa,
        nome_norm: String,
        sobrenome_norm: String,
        ano_nasc: Option<i64>,
        ano_falec: Option<i64>,
    }

    let mut itens: Vec<ItemComparacao> = Vec::with_capacity(rows.len());

    for r in rows {
        let p = Pessoa {
            id: r.get("id"),
            nome: r.get("nome"),
            sobrenome: r.get("sobrenome"),
            sexo: r.get("sexo"),
            minibiografia: r.get("minibiografia"),
            is_vivo: r.get("is_vivo"),
            is_placeholder: r.get("is_placeholder"),
            foto_url: r.get("foto_url"),
            is_publico: r.get("is_publico"),
            categoria: r.get("categoria"),
            tipo_tempo: r.try_get("tipo_tempo").unwrap_or_else(|_| "real".to_string()),
        };

        let nome_norm = normalizar_busca(&p.nome);
        let sobrenome_norm = p
            .sobrenome
            .as_deref()
            .map(normalizar_busca)
            .unwrap_or_default();

        let ano_nasc: Option<i64> = r.get("ano_nasc");
        let ano_falec: Option<i64> = r.get("ano_falec");

        itens.push(ItemComparacao {
            pessoa: p,
            nome_norm,
            sobrenome_norm,
            ano_nasc,
            ano_falec,
        });
    }

    let mut candidatos: Vec<CandidatoDuplicata> = Vec::new();

    for i in 0..itens.len() {
        for j in (i + 1)..itens.len() {
            let a = &itens[i];
            let b = &itens[j];

            if a.pessoa.id == b.pessoa.id {
                continue;
            }

            // Critério 1: Mesmo primeiro nome normalizado
            let mesmo_nome = !a.nome_norm.is_empty() && a.nome_norm == b.nome_norm;
            let mesmo_sobrenome = !a.sobrenome_norm.is_empty() && a.sobrenome_norm == b.sobrenome_norm;

            if !mesmo_nome && !mesmo_sobrenome {
                continue;
            }

            let mesmo_sexo = a.pessoa.sexo == b.pessoa.sexo || a.pessoa.sexo == "U" || b.pessoa.sexo == "U";
            if !mesmo_sexo {
                continue;
            }

            let mesmo_nasc = match (a.ano_nasc, b.ano_nasc) {
                (Some(na), Some(nb)) => na == nb,
                _ => false,
            };

            let mesmo_falec = match (a.ano_falec, b.ano_falec) {
                (Some(fa), Some(fb)) => fa == fb,
                _ => false,
            };

            let mut score = 0;
            let mut motivos: Vec<String> = Vec::new();

            if mesmo_nome && mesmo_sobrenome {
                score += 60;
                motivos.push("Nome e sobrenome idênticos".to_string());
            } else if mesmo_nome {
                score += 30;
                motivos.push("Primeiro nome idêntico".to_string());
            } else if mesmo_sobrenome {
                score += 25;
                motivos.push("Mesmo sobrenome".to_string());
            }

            if mesmo_nasc {
                score += 35;
                motivos.push(format!("Ano de nascimento coincidente ({})", a.ano_nasc.unwrap()));
            }

            if mesmo_falec {
                score += 25;
                motivos.push(format!("Ano de falecimento coincidente ({})", a.ano_falec.unwrap()));
            }

            if score >= 60 {
                candidatos.push(CandidatoDuplicata {
                    pessoa_a: a.pessoa.clone(),
                    pessoa_b: b.pessoa.clone(),
                    score: score.min(100) as u32,
                    motivo: motivos.join(" • "),
                });
            }
        }
    }

    candidatos.sort_by(|a, b| b.score.cmp(&a.score));
    candidatos.truncate(limite);

    Ok(candidatos)
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    async fn banco_memoria() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations")
            .run(&pool)
            .await
            .expect("migrations aplicadas");
        pool
    }

    #[tokio::test]
    async fn recusa_fusao_consigo_mesma() {
        let pool = banco_memoria().await;
        let res = executar_fusao(&pool, "p1", "p1").await;
        assert!(res.is_err());
    }

    #[tokio::test]
    async fn funde_pessoas_simples_com_sucesso() {
        let pool = banco_memoria().await;

        // Cria pessoa 1 (mestre)
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder)
             VALUES ('p1', 'Joao', NULL, 'M', NULL, 1, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        // Cria pessoa 2 (absorver)
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder)
             VALUES ('p2', 'Joao', 'Silva', 'M', 'Bio teste', 1, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        // Adiciona evento na pessoa 2
        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador)
             VALUES ('ev1', 'p2', 'nascimento', 1950, 'exata')",
        )
        .execute(&pool)
        .await
        .unwrap();

        let resumo = executar_fusao(&pool, "p1", "p2").await.unwrap();
        assert_eq!(resumo.id_mestre, "p1");
        assert_eq!(resumo.eventos_transferidos, 1);

        // Verifica se p1 herdou o sobrenome e minibiografia de p2
        let p1: Pessoa = sqlx::query_as("SELECT * FROM pessoas WHERE id = 'p1'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(p1.sobrenome.as_deref(), Some("Silva"));
        assert_eq!(p1.minibiografia.as_deref(), Some("Bio teste"));

        // Verifica se evento foi transferido para p1
        let dono_ev: String = sqlx::query_scalar("SELECT pessoa_id FROM eventos WHERE id = 'ev1'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(dono_ev, "p1");

        // Verifica se p2 foi excluída
        let p2_existe: Option<String> =
            sqlx::query_scalar("SELECT id FROM pessoas WHERE id = 'p2'")
                .fetch_optional(&pool)
                .await
                .unwrap();
        assert!(p2_existe.is_none());
    }

    #[tokio::test]
    async fn funde_pessoas_com_unioes_duplicadas_e_filhos() {
        let pool = banco_memoria().await;

        // Pai Mestre
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('mestre', 'Carlos', 'Gomes', 'M', 1, 0)").execute(&pool).await.unwrap();
        // Pai Absorver
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('duplicata', 'Carlos', 'Gomes', 'M', 1, 0)").execute(&pool).await.unwrap();
        // Esposa
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('esposa', 'Maria', 'Gomes', 'F', 1, 0)").execute(&pool).await.unwrap();
        // Filho 1 (vinculado a mestre + esposa)
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('filho1', 'Pedro', 'Gomes', 'M', 1, 0)").execute(&pool).await.unwrap();
        // Filho 2 (vinculado a duplicata + esposa)
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('filho2', 'Ana', 'Gomes', 'F', 1, 0)").execute(&pool).await.unwrap();

        // União 1 (mestre + esposa)
        sqlx::query("INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo) VALUES ('u1', 'mestre', 'esposa', 'casamento')").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('u1', 'filho1', 'biologico', 1)").execute(&pool).await.unwrap();

        // União 2 (duplicata + esposa)
        sqlx::query("INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo) VALUES ('u2', 'duplicata', 'esposa', 'casamento')").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('u2', 'filho2', 'biologico', 1)").execute(&pool).await.unwrap();

        let resumo = executar_fusao(&pool, "mestre", "duplicata").await.unwrap();
        assert_eq!(resumo.unioes_afetadas, 1);

        // A união duplicada 'u2' deve ter sumido e os filhos devem estar todos em 'u1'
        let u2_existe: Option<String> = sqlx::query_scalar("SELECT id FROM unioes WHERE id = 'u2'").fetch_optional(&pool).await.unwrap();
        assert!(u2_existe.is_none());

        let filhos_u1: Vec<String> = sqlx::query_scalar("SELECT pessoa_id FROM uniao_filhos WHERE uniao_id = 'u1' ORDER BY pessoa_id").fetch_all(&pool).await.unwrap();
        assert_eq!(filhos_u1, vec!["filho1", "filho2"]);
    }

    #[tokio::test]
    async fn recusa_fusao_entre_pai_e_filho() {
        let pool = banco_memoria().await;

        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('pai', 'Carlos', 'Silva', 'M', 1, 0)").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('mae', 'Ana', 'Silva', 'F', 1, 0)").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder) VALUES ('filho', 'Pedro', 'Silva', 'M', 1, 0)").execute(&pool).await.unwrap();

        sqlx::query("INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo) VALUES ('u1', 'pai', 'mae', 'casamento')").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('u1', 'filho', 'biologico', 1)").execute(&pool).await.unwrap();

        let res = executar_fusao(&pool, "pai", "filho").await;
        assert!(res.is_err());
        let res2 = executar_fusao(&pool, "filho", "pai").await;
        assert!(res2.is_err());
    }
}
