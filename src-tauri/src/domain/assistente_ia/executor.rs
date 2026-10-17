//! Executor transacional de ações propostas pelo Assistente IA.
//!
//! Recebe uma `PropostaAcaoIa` já auditada pelo verificador Quote-and-Verify
//! e confirmada pelo usuário na interface ("Human-in-the-Loop") e grava todas
//! as entidades em uma transação atômica no SQLCipher.

use std::collections::HashMap;
use sqlx::SqlitePool;
use uuid::Uuid;

use crate::domain::arvores_cmds::sincronizar_membros_arvore;
use crate::domain::erros::{ErroDominio, Resultado};
use super::{PropostaAcaoIa, PropostaCriarArvore, PropostaCriarLinhaTempo, ResultadoExecucaoIa};

/// Executa uma proposta confirmada pelo usuário no banco de dados.
pub async fn executar_proposta_confirmada(
    pool: &SqlitePool,
    proposta: PropostaAcaoIa,
) -> Resultado<ResultadoExecucaoIa> {
    match proposta {
        PropostaAcaoIa::CriarArvore(arvore) => executar_criar_arvore_db(pool, arvore).await,
        PropostaAcaoIa::CriarLinhaTempo(linha) => executar_criar_linha_tempo_db(pool, linha).await,
    }
}

/// Cria uma árvore genealógica completa com pessoas, eventos, placeholders, uniões e filhos
/// em uma única transação atômica.
pub async fn executar_criar_arvore_db(
    pool: &SqlitePool,
    proposta: PropostaCriarArvore,
) -> Resultado<ResultadoExecucaoIa> {
    if proposta.pessoas.is_empty() {
        return Err(ErroDominio::Validacao(
            "A proposta de árvore não contém nenhuma pessoa válida.".to_string(),
        ));
    }

    let mut tx = pool.begin().await?;
    let mut mapa_refs: HashMap<String, String> = HashMap::new();
    let mut mapa_sexo: HashMap<String, String> = HashMap::new();
    let mut pessoas_criadas = 0usize;
    let mut avisos: Vec<String> = Vec::new();

    // 1. Insere (ou vincula se pessoa_existente_id estiver presente) todas as pessoas
    for p in &proposta.pessoas {
        let sexo_valido = match p.sexo.as_str() {
            "M" | "F" | "X" | "U" => p.sexo.clone(),
            _ => "U".to_string(),
        };

        let real_id = if let Some(ref existente_id) = p.pessoa_existente_id {
            existente_id.clone()
        } else {
            let pid = Uuid::new_v4().to_string();
            let is_vivo = p.ano_falecimento.is_none()
                && p.ano_nascimento.map(|a| a >= 1935).unwrap_or(false);

            sqlx::query(
                "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
                 VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?)",
            )
            .bind(&pid)
            .bind(p.nome.trim())
            .bind(p.sobrenome.as_deref().map(str::trim))
            .bind(&sexo_valido)
            .bind(p.minibiografia.as_deref())
            .bind(is_vivo)
            .bind(proposta.categoria.as_deref().unwrap_or("Pessoal"))
            .execute(&mut *tx)
            .await?;

            // Evento de nascimento
            if let Some(ano_n) = p.ano_nascimento {
                let eid = Uuid::new_v4().to_string();
                let txt = if ano_n < 0 {
                    format!("{} a.C.", ano_n.abs())
                } else {
                    ano_n.to_string()
                };
                sqlx::query(
                    "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                     VALUES (?, ?, 'nascimento', ?, ?, 'exata', ?)",
                )
                .bind(&eid)
                .bind(&pid)
                .bind(ano_n)
                .bind(ano_n)
                .bind(&txt)
                .execute(&mut *tx)
                .await?;
            }

            // Evento de falecimento
            if let Some(ano_m) = p.ano_falecimento {
                let eid = Uuid::new_v4().to_string();
                let txt = if ano_m < 0 {
                    format!("{} a.C.", ano_m.abs())
                } else {
                    ano_m.to_string()
                };
                sqlx::query(
                    "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                     VALUES (?, ?, 'falecimento', ?, ?, 'exata', ?)",
                )
                .bind(&eid)
                .bind(&pid)
                .bind(ano_m)
                .bind(ano_m)
                .bind(&txt)
                .execute(&mut *tx)
                .await?;
            }

            pessoas_criadas += 1;
            pid
        };

        mapa_refs.insert(p.ref_id.clone(), real_id);
        mapa_sexo.insert(p.ref_id.clone(), sexo_valido);
    }

    // 2. Insere as uniões e os vínculos de filhos (criando placeholders se faltar um dos genitores)
    let mut unioes_criadas = 0usize;
    let mut ids_unioes_criadas = Vec::new();

    for u in &proposta.unioes {
        let mut slot_masc: Option<String> = u
            .pai_ref
            .as_ref()
            .and_then(|r| mapa_refs.get(r).cloned());
        let mut slot_fem: Option<String> = u
            .mae_ref
            .as_ref()
            .and_then(|r| mapa_refs.get(r).cloned());

        if slot_masc.is_none() && slot_fem.is_none() {
            continue;
        }

        // Garante que se o pai_ref tinha sexo F e mae_ref estava vazia, ajusta os slots conforme a regra do banco
        if let Some(ref pref) = u.pai_ref {
            if mapa_sexo.get(pref).map(|s| s.as_str()) == Some("F") && slot_fem.is_none() {
                slot_fem = slot_masc.take();
            }
        }
        if let Some(ref mref) = u.mae_ref {
            if mapa_sexo.get(mref).map(|s| s.as_str()) == Some("M") && slot_masc.is_none() {
                slot_masc = slot_fem.take();
            }
        }

        // Cria placeholder masculino se necessário (invariante: toda união tem os 2 slots preenchidos)
        let id_masculino = match slot_masc {
            Some(id) => id,
            None => {
                let ph_id = Uuid::new_v4().to_string();
                sqlx::query(
                    "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
                     VALUES (?, 'Desconhecido', NULL, 'M', 0, 1, 0)",
                )
                .bind(&ph_id)
                .execute(&mut *tx)
                .await?;
                ph_id
            }
        };

        // Cria placeholder feminino se necessário
        let id_feminino = match slot_fem {
            Some(id) => id,
            None => {
                let ph_id = Uuid::new_v4().to_string();
                sqlx::query(
                    "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
                     VALUES (?, 'Desconhecida', NULL, 'F', 0, 1, 0)",
                )
                .bind(&ph_id)
                .execute(&mut *tx)
                .await?;
                ph_id
            }
        };

        if id_masculino == id_feminino {
            continue;
        }

        let uniao_id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES (?, ?, ?, 'casamento')",
        )
        .bind(&uniao_id)
        .bind(&id_masculino)
        .bind(&id_feminino)
        .execute(&mut *tx)
        .await?;

        if let Some(ano_c) = u.ano_casamento {
            let eid = Uuid::new_v4().to_string();
            let txt = ano_c.to_string();
            sqlx::query(
                "INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'casamento', ?, ?, 'exata', ?)",
            )
            .bind(&eid)
            .bind(&uniao_id)
            .bind(ano_c)
            .bind(ano_c)
            .bind(&txt)
            .execute(&mut *tx)
            .await?;
        }

        for (ordem, f_ref) in u.filhos_refs.iter().enumerate() {
            if let Some(filho_id) = mapa_refs.get(f_ref) {
                if filho_id != &id_masculino && filho_id != &id_feminino {
                    // A fase de analise ja impede o mesmo filho em duas unioes
                    // DESTA proposta, mas ela nao conhece o banco. Quando o
                    // record linkage casa com alguem que ja esta no acervo e
                    // ja tem pais, a invariante 1 derruba o vinculo -- e, com
                    // `INSERT OR IGNORE`, derrubava em silencio, depois de o
                    // usuario ter aprovado um card que o prometia.
                    let ja_tem_pais: Option<(String,)> =
                        sqlx::query_as("SELECT uniao_id FROM uniao_filhos WHERE pessoa_id = ?")
                            .bind(filho_id)
                            .fetch_optional(&mut *tx)
                            .await?;

                    if ja_tem_pais.is_some() {
                        let nome = proposta
                            .pessoas
                            .iter()
                            .find(|p| &p.ref_id == f_ref)
                            .map(|p| p.nome.trim().to_string())
                            .unwrap_or_else(|| f_ref.clone());
                        avisos.push(format!(
                            "{} já constava no acervo com pais registrados, então esse vínculo de filiação não foi criado. Cada pessoa tem um único par de pais.",
                            nome
                        ));
                        continue;
                    }

                    sqlx::query(
                        "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
                         VALUES (?, ?, 'biologico', ?)",
                    )
                    .bind(&uniao_id)
                    .bind(filho_id)
                    .bind((ordem + 1) as i64)
                    .execute(&mut *tx)
                    .await?;
                }
            }
        }

        ids_unioes_criadas.push(uniao_id);
        unioes_criadas += 1;
    }

    // 3. Cria o registro da Árvore e vincula todos os membros
    let arvore_id = Uuid::new_v4().to_string();
    let raiz_id = mapa_refs
        .get(&proposta.raiz_ref)
        .cloned()
        .or_else(|| proposta.pessoas.first().and_then(|p| mapa_refs.get(&p.ref_id).cloned()));

    sqlx::query(
        "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, tipo_tempo)
         VALUES (?, ?, ?, ?, 0, ?, 'real')",
    )

    .bind(&arvore_id)
    .bind(proposta.nome_arvore.trim())
    .bind(proposta.descricao.as_deref())
    .bind(&raiz_id)
    .bind(proposta.categoria.as_deref().unwrap_or("Pessoal"))
    .execute(&mut *tx)
    .await?;

    for pid in mapa_refs.values() {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, ?, NULL)",
        )
        .bind(&arvore_id)
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    for uid in &ids_unioes_criadas {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, NULL, ?)",
        )
        .bind(&arvore_id)
        .bind(uid)
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;

    // Sincroniza quaisquer placeholders criados na árvore
    let _ = sincronizar_membros_arvore(pool, &arvore_id, raiz_id.as_deref()).await;

    Ok(ResultadoExecucaoIa {
        tipo: "arvore".to_string(),
        entidade_id: arvore_id,
        raiz_pessoa_id: raiz_id,
        titulo: proposta.nome_arvore,
        itens_criados: pessoas_criadas + unioes_criadas,
        mensagem: format!(
            "Árvore criada com sucesso contendo {} pessoa(s) e {} união(ões).",
            pessoas_criadas, unioes_criadas
        ),
        avisos,
    })
}

/// Cria uma Linha do Tempo completa com todos os seus marcos históricos em uma transação atômica.
pub async fn executar_criar_linha_tempo_db(
    pool: &SqlitePool,
    proposta: PropostaCriarLinhaTempo,
) -> Resultado<ResultadoExecucaoIa> {
    if proposta.marcos.is_empty() {
        return Err(ErroDominio::Validacao(
            "A proposta de linha do tempo não contém nenhum marco válido.".to_string(),
        ));
    }

    let mut tx = pool.begin().await?;
    let linha_id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO linhas_tempo (id, categoria, titulo, fonte_referencia, is_contexto, is_bloqueada)
         VALUES (?, ?, ?, ?, 0, 0)",
    )
    .bind(&linha_id)
    .bind(proposta.categoria.trim())
    .bind(proposta.titulo_linha.trim())
    .bind(proposta.fonte_referencia.as_deref())
    .execute(&mut *tx)
    .await?;

    let mut marcos_criados = 0usize;
    for m in &proposta.marcos {
        let mid = Uuid::new_v4().to_string();
        let relevancia = match m.relevancia.as_str() {
            "alta" | "media" | "baixa" => m.relevancia.as_str(),
            _ => "alta",
        };
        sqlx::query(
            "INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        )
        .bind(&mid)
        .bind(&linha_id)
        .bind(&m.data_periodo_texto)
        .bind(m.titulo.trim())
        .bind(m.descricao.as_deref())
        .bind(relevancia)
        .bind(m.ano_inicio)
        .bind(m.ano_fim.or(Some(m.ano_inicio)))
        .execute(&mut *tx)
        .await?;

        marcos_criados += 1;
    }

    tx.commit().await?;

    Ok(ResultadoExecucaoIa {
        tipo: "linha_tempo".to_string(),
        entidade_id: linha_id,
        raiz_pessoa_id: None,
        titulo: proposta.titulo_linha,
        itens_criados: marcos_criados,
        mensagem: format!(
            "Linha do tempo criada com sucesso contendo {} marco(s) cronológico(s).",
            marcos_criados
        ),
        avisos: Vec::new(),
    })
}
