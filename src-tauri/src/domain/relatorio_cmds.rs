//! Montagem do relatório (fatia 05).
//!
//! Reúne, numa chamada, tudo que o documento impresso precisa. As consultas são
//! **em lote**: uma por tabela, com os resultados casados em memória. A versão
//! ingênua — uma consulta de atributos por pessoa — faria centenas de idas ao
//! banco para um acervo de porte médio.
//!
//! A ordenação segue a seção 6 na leitura declarada em
//! `Instruções/fatias/05-relatorios.md`: geração, depois ano de nascimento,
//! depois nome. Quem não tem ano vai ao fim da própria geração e **nunca some**.

use std::collections::HashMap;

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;

use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;

#[derive(Debug, Clone, Serialize)]
pub struct EventoRelatorio {
    pub tipo: String,
    /// O texto que o usuário escreveu. Nunca o ano derivado — regra da spec.
    pub data_texto: Option<String>,
    pub local: Option<String>,
    pub nota: Option<String>,
}

#[derive(Debug, Clone, Serialize)]
pub struct UniaoRelatorio {
    pub conjuge: String,
    pub estado_vinculo: String,
    pub data_texto: Option<String>,
    pub filhos: Vec<String>,
}

#[derive(Debug, Clone, Serialize)]
pub struct EntradaRelatorio {
    pub id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub is_vivo: bool,
    pub is_placeholder: bool,
    pub foto_url: Option<String>,
    pub minibiografia: Option<String>,
    pub geracao: i64,
    pub ano_nascimento: Option<i64>,

    pub nascimento: Option<EventoRelatorio>,
    pub falecimento: Option<EventoRelatorio>,
    pub outros_eventos: Vec<EventoRelatorio>,

    pub outros_nomes: Vec<String>,
    pub apelidos: Vec<String>,
    pub nacionalidades: Vec<String>,
    pub religioes: Vec<String>,
    pub escolaridade: Vec<String>,
    pub profissoes: Vec<String>,
    pub idiomas: Vec<String>,

    pub pais: Vec<String>,
    pub unioes: Vec<UniaoRelatorio>,
}

#[derive(Debug, Serialize)]
pub struct Relatorio {
    pub entradas: Vec<EntradaRelatorio>,
    pub total: usize,
    /// Quantas pessoas foram omitidas por estarem vivas.
    pub omitidas_vivas: usize,
}

#[derive(Debug, Deserialize)]
pub struct OpcoesRelatorio {
    /// `None` = acervo inteiro. `Some(id)` = a árvore em volta dessa pessoa.
    pub raiz_id: Option<String>,
    pub ocultar_vivas: bool,
    /// Placeholders são nós técnicos; no papel viram "Desconhecido" e poluem.
    pub incluir_placeholders: bool,
}

/// Nome completo, com o cuidado de não imprimir "Desconhecido" sem contexto.
fn nome_de(nome: &str, sobrenome: Option<&str>) -> String {
    match sobrenome {
        Some(s) if !s.trim().is_empty() => format!("{nome} {s}"),
        _ => nome.to_string(),
    }
}

/// Agrupa linhas `(pessoa_id, valor)` num mapa de listas.
fn agrupar(linhas: Vec<(String, String)>) -> HashMap<String, Vec<String>> {
    let mut mapa: HashMap<String, Vec<String>> = HashMap::new();
    for (pessoa_id, valor) in linhas {
        mapa.entry(pessoa_id).or_default().push(valor);
    }
    mapa
}

#[tauri::command]
pub async fn montar_relatorio(
    opcoes: OpcoesRelatorio,
    db: State<'_, SqlitePool>,
) -> Resultado<Relatorio> {
    montar(&db, &opcoes).await
}

pub async fn montar(pool: &SqlitePool, opcoes: &OpcoesRelatorio) -> Resultado<Relatorio> {
    // -----------------------------------------------------------------
    // 1. Quem entra
    // -----------------------------------------------------------------
    let ids: Vec<String> = match &opcoes.raiz_id {
        None => sqlx::query_scalar("SELECT id FROM pessoas")
            .fetch_all(pool)
            .await?,
        Some(raiz) => {
            sqlx::query_scalar(
                r#"
                WITH RECURSIVE
                acima(id) AS (
                    SELECT ?1
                    UNION
                    SELECT v.progenitor FROM (
                        SELECT f.pessoa_id AS filho, u.slot_masculino_id AS progenitor
                          FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                        UNION ALL
                        SELECT f.pessoa_id, u.slot_feminino_id
                          FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                    ) v JOIN acima a ON v.filho = a.id
                ),
                abaixo(id) AS (
                    SELECT ?1
                    UNION
                    SELECT f.pessoa_id FROM abaixo d
                    JOIN unioes u ON u.slot_masculino_id = d.id OR u.slot_feminino_id = d.id
                    JOIN uniao_filhos f ON f.uniao_id = u.id
                ),
                nucleo(id) AS (SELECT id FROM acima UNION SELECT id FROM abaixo)
                SELECT id FROM nucleo
                UNION
                SELECT u.slot_masculino_id FROM unioes u JOIN nucleo n ON u.slot_feminino_id = n.id
                UNION
                SELECT u.slot_feminino_id FROM unioes u JOIN nucleo n ON u.slot_masculino_id = n.id
                "#,
            )
            .bind(raiz)
            .fetch_all(pool)
            .await?
        }
    };

    if ids.is_empty() {
        return Ok(Relatorio { entradas: vec![], total: 0, omitidas_vivas: 0 });
    }

    let marcadores = vec!["?"; ids.len()].join(",");

    // -----------------------------------------------------------------
    // 2. As pessoas
    // -----------------------------------------------------------------
    let sql_pessoas = format!(
        "SELECT id, nome, sobrenome, sexo, is_vivo, is_placeholder, foto_url, minibiografia
         FROM pessoas WHERE id IN ({marcadores})"
    );
    let mut q = sqlx::query(&sql_pessoas);
    for id in &ids {
        q = q.bind(id);
    }
    let linhas = q.fetch_all(pool).await?;

    let mut entradas: Vec<EntradaRelatorio> = Vec::with_capacity(linhas.len());
    let mut omitidas_vivas = 0usize;

    for l in linhas {
        let is_vivo: bool = l.try_get("is_vivo")?;
        let is_placeholder: bool = l.try_get("is_placeholder")?;

        if opcoes.ocultar_vivas && is_vivo {
            omitidas_vivas += 1;
            continue;
        }
        if !opcoes.incluir_placeholders && is_placeholder {
            continue;
        }

        entradas.push(EntradaRelatorio {
            id: l.try_get("id")?,
            nome: l.try_get("nome")?,
            sobrenome: l.try_get("sobrenome")?,
            sexo: l.try_get("sexo")?,
            is_vivo,
            is_placeholder,
            foto_url: l.try_get("foto_url")?,
            minibiografia: l.try_get("minibiografia")?,
            geracao: 0,
            ano_nascimento: None,
            nascimento: None,
            falecimento: None,
            outros_eventos: vec![],
            outros_nomes: vec![],
            apelidos: vec![],
            nacionalidades: vec![],
            religioes: vec![],
            escolaridade: vec![],
            profissoes: vec![],
            idiomas: vec![],
            pais: vec![],
            unioes: vec![],
        });
    }

    // -----------------------------------------------------------------
    // 3. Eventos, com o local já resolvido
    // -----------------------------------------------------------------
    let sql_eventos = format!(
        "SELECT e.pessoa_id, e.tipo_evento, e.data_texto, e.ano_inicio, e.nota,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || p.nome END) AS local
         FROM eventos e
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         WHERE e.pessoa_id IN ({marcadores})
         ORDER BY (e.ano_inicio IS NULL), e.ano_inicio"
    );
    let mut q = sqlx::query(&sql_eventos);
    for id in &ids {
        q = q.bind(id);
    }

    let mut eventos: HashMap<String, Vec<(String, EventoRelatorio, Option<i64>)>> = HashMap::new();
    for l in q.fetch_all(pool).await? {
        let pessoa_id: String = l.try_get("pessoa_id")?;
        let tipo: String = l.try_get("tipo_evento")?;
        let ano: Option<i64> = l.try_get("ano_inicio")?;
        eventos.entry(pessoa_id).or_default().push((
            tipo.clone(),
            EventoRelatorio {
                tipo,
                data_texto: l.try_get("data_texto")?,
                local: l.try_get("local")?,
                nota: l.try_get("nota")?,
            },
            ano,
        ));
    }

    // -----------------------------------------------------------------
    // 4. Atributos, um lote por tabela
    // -----------------------------------------------------------------
    async fn lote(
        pool: &SqlitePool,
        sql: &str,
        ids: &[String],
    ) -> Resultado<HashMap<String, Vec<String>>> {
        let mut q = sqlx::query_as::<_, (String, String)>(sql);
        for id in ids {
            q = q.bind(id);
        }
        Ok(agrupar(q.fetch_all(pool).await?))
    }

    let apelidos = lote(
        pool,
        &format!("SELECT pessoa_id, apelido FROM apelidos_pessoa WHERE pessoa_id IN ({marcadores})"),
        &ids,
    )
    .await?;

    let religioes = lote(
        pool,
        &format!(
            "SELECT pessoa_id, denominacao || COALESCE(' (' || periodo || ')','')
             FROM religioes_pessoa WHERE pessoa_id IN ({marcadores})"
        ),
        &ids,
    )
    .await?;

    let profissoes = lote(
        pool,
        &format!(
            "SELECT pessoa_id, ocupacao || COALESCE(' — ' || empregador_local,'')
                                        || COALESCE(' (' || periodo || ')','')
             FROM profissoes_pessoa WHERE pessoa_id IN ({marcadores})"
        ),
        &ids,
    )
    .await?;

    let escolaridade = lote(
        pool,
        &format!(
            "SELECT pessoa_id, nivel || COALESCE(' — ' || instituicao,'')
                                     || COALESCE(' (' || periodo || ')','')
             FROM escolaridade_pessoa WHERE pessoa_id IN ({marcadores})"
        ),
        &ids,
    )
    .await?;

    let idiomas = lote(
        pool,
        &format!("SELECT pessoa_id, idioma FROM idiomas_pessoa WHERE pessoa_id IN ({marcadores})"),
        &ids,
    )
    .await?;

    let nacionalidades = lote(
        pool,
        &format!(
            "SELECT n.pessoa_id, p.nome FROM nacionalidades_pessoa n
             JOIN paises p ON p.id = n.pais_id WHERE n.pessoa_id IN ({marcadores})"
        ),
        &ids,
    )
    .await?;

    let outros_nomes = lote(
        pool,
        &format!(
            "SELECT pessoa_id,
                    TRIM(COALESCE(prefixo || ' ','') || nome ||
                         COALESCE(' ' || sufixo,'') || COALESCE(' ' || sobrenome,''))
                    || ' (' || tipo || ')'
             FROM nomes_pessoa WHERE pessoa_id IN ({marcadores}) ORDER BY ordem"
        ),
        &ids,
    )
    .await?;

    // -----------------------------------------------------------------
    // 5. Parentesco: pais, uniões e filhos
    // -----------------------------------------------------------------
    let sql_pais = format!(
        "SELECT f.pessoa_id,
                pm.nome AS pai_nome, pm.sobrenome AS pai_sobrenome, pm.is_placeholder AS pai_ph,
                pf.nome AS mae_nome, pf.sobrenome AS mae_sobrenome, pf.is_placeholder AS mae_ph
         FROM uniao_filhos f
         JOIN unioes u ON u.id = f.uniao_id
         JOIN pessoas pm ON pm.id = u.slot_masculino_id
         JOIN pessoas pf ON pf.id = u.slot_feminino_id
         WHERE f.pessoa_id IN ({marcadores})"
    );
    let mut q = sqlx::query(&sql_pais);
    for id in &ids {
        q = q.bind(id);
    }

    let mut pais: HashMap<String, Vec<String>> = HashMap::new();
    for l in q.fetch_all(pool).await? {
        let pessoa_id: String = l.try_get("pessoa_id")?;
        let mut lista = Vec::new();

        let pai_ph: bool = l.try_get("pai_ph")?;
        if !pai_ph {
            lista.push(nome_de(
                &l.try_get::<String, _>("pai_nome")?,
                l.try_get::<Option<String>, _>("pai_sobrenome")?.as_deref(),
            ));
        }
        let mae_ph: bool = l.try_get("mae_ph")?;
        if !mae_ph {
            lista.push(nome_de(
                &l.try_get::<String, _>("mae_nome")?,
                l.try_get::<Option<String>, _>("mae_sobrenome")?.as_deref(),
            ));
        }
        pais.insert(pessoa_id, lista);
    }

    // Uniões da pessoa, com cônjuge e ano de casamento.
    let sql = format!(
        "SELECT u.id, u.estado_vinculo, u.slot_masculino_id, u.slot_feminino_id,
                pm.nome AS m_nome, pm.sobrenome AS m_sobrenome, pm.is_placeholder AS m_ph,
                pf.nome AS f_nome, pf.sobrenome AS f_sobrenome, pf.is_placeholder AS f_ph,
                (SELECT e.data_texto FROM eventos e
                  WHERE e.uniao_id = u.id AND e.tipo_evento = '{casamento}' LIMIT 1) AS data_texto
         FROM unioes u
         JOIN pessoas pm ON pm.id = u.slot_masculino_id
         JOIN pessoas pf ON pf.id = u.slot_feminino_id
         WHERE u.slot_masculino_id IN ({marcadores}) OR u.slot_feminino_id IN ({marcadores})",
        casamento = tipos::CASAMENTO
    );

    let mut q = sqlx::query(&sql);
    for id in &ids {
        q = q.bind(id);
    }
    for id in &ids {
        q = q.bind(id);
    }
    let linhas_uniao = q.fetch_all(pool).await?;

    // Filhos por união, num lote só.
    let ids_uniao: Vec<String> = linhas_uniao
        .iter()
        .map(|l| l.try_get::<String, _>("id").unwrap_or_default())
        .collect();

    let mut filhos_por_uniao: HashMap<String, Vec<String>> = HashMap::new();
    if !ids_uniao.is_empty() {
        let m = vec!["?"; ids_uniao.len()].join(",");
        let sql = format!(
            "SELECT f.uniao_id, p.nome, p.sobrenome FROM uniao_filhos f
             JOIN pessoas p ON p.id = f.pessoa_id
             WHERE f.uniao_id IN ({m}) ORDER BY f.ordem"
        );
        let mut q = sqlx::query(&sql);
        for id in &ids_uniao {
            q = q.bind(id);
        }
        for l in q.fetch_all(pool).await? {
            let uniao_id: String = l.try_get("uniao_id")?;
            filhos_por_uniao.entry(uniao_id).or_default().push(nome_de(
                &l.try_get::<String, _>("nome")?,
                l.try_get::<Option<String>, _>("sobrenome")?.as_deref(),
            ));
        }
    }

    let mut unioes_por_pessoa: HashMap<String, Vec<UniaoRelatorio>> = HashMap::new();
    for l in linhas_uniao {
        let uniao_id: String = l.try_get("id")?;
        let masculino: String = l.try_get("slot_masculino_id")?;
        let feminino: String = l.try_get("slot_feminino_id")?;
        let filhos = filhos_por_uniao.get(&uniao_id).cloned().unwrap_or_default();

        let m_ph: bool = l.try_get("m_ph")?;
        let f_ph: bool = l.try_get("f_ph")?;
        let nome_m = if m_ph {
            "Desconhecido".to_string()
        } else {
            nome_de(
                &l.try_get::<String, _>("m_nome")?,
                l.try_get::<Option<String>, _>("m_sobrenome")?.as_deref(),
            )
        };
        let nome_f = if f_ph {
            "Desconhecida".to_string()
        } else {
            nome_de(
                &l.try_get::<String, _>("f_nome")?,
                l.try_get::<Option<String>, _>("f_sobrenome")?.as_deref(),
            )
        };

        let estado: String = l.try_get("estado_vinculo")?;
        let data: Option<String> = l.try_get("data_texto")?;

        // Cada lado vê o outro como cônjuge.
        unioes_por_pessoa
            .entry(masculino)
            .or_default()
            .push(UniaoRelatorio {
                conjuge: nome_f.clone(),
                estado_vinculo: estado.clone(),
                data_texto: data.clone(),
                filhos: filhos.clone(),
            });
        unioes_por_pessoa
            .entry(feminino)
            .or_default()
            .push(UniaoRelatorio {
                conjuge: nome_m,
                estado_vinculo: estado,
                data_texto: data,
                filhos,
            });
    }

    // -----------------------------------------------------------------
    // 6. Gerações — a chave primária da ordenação
    // -----------------------------------------------------------------
    let geracoes = calcular_geracoes(pool).await?;

    // -----------------------------------------------------------------
    // 7. Casar tudo e ordenar
    // -----------------------------------------------------------------
    for e in &mut entradas {
        e.geracao = *geracoes.get(&e.id).unwrap_or(&0);

        if let Some(lista) = eventos.remove(&e.id) {
            for (tipo, evento, ano) in lista {
                if tipo == tipos::NASCIMENTO && e.nascimento.is_none() {
                    e.ano_nascimento = ano;
                    e.nascimento = Some(evento);
                } else if tipo == tipos::FALECIMENTO && e.falecimento.is_none() {
                    e.falecimento = Some(evento);
                } else {
                    e.outros_eventos.push(evento);
                }
            }
        }

        e.apelidos = apelidos.get(&e.id).cloned().unwrap_or_default();
        e.religioes = religioes.get(&e.id).cloned().unwrap_or_default();
        e.profissoes = profissoes.get(&e.id).cloned().unwrap_or_default();
        e.escolaridade = escolaridade.get(&e.id).cloned().unwrap_or_default();
        e.idiomas = idiomas.get(&e.id).cloned().unwrap_or_default();
        e.nacionalidades = nacionalidades.get(&e.id).cloned().unwrap_or_default();
        e.outros_nomes = outros_nomes.get(&e.id).cloned().unwrap_or_default();
        e.pais = pais.get(&e.id).cloned().unwrap_or_default();
        e.unioes = unioes_por_pessoa.get(&e.id).cloned().unwrap_or_default();
    }

    // Geração, depois ano, depois nome. Quem não tem ano vai ao fim da própria
    // geração — perto de quem viveu junto dele — e nunca some da lista.
    entradas.sort_by(|a, b| {
        a.geracao
            .cmp(&b.geracao)
            .then(match (a.ano_nascimento, b.ano_nascimento) {
                (Some(x), Some(y)) => x.cmp(&y),
                (Some(_), None) => std::cmp::Ordering::Less,
                (None, Some(_)) => std::cmp::Ordering::Greater,
                (None, None) => std::cmp::Ordering::Equal,
            })
            .then_with(|| a.nome.to_lowercase().cmp(&b.nome.to_lowercase()))
    });

    Ok(Relatorio {
        total: entradas.len(),
        entradas,
        omitidas_vivas,
    })
}

/// Profundidade geracional de cada pessoa, contada a partir de quem não tem
/// pais no acervo.
///
/// O `UNION` da recursiva deduplica e faz a consulta terminar mesmo se o grafo
/// chegar com um ciclo herdado de um import.
async fn calcular_geracoes(pool: &SqlitePool) -> Resultado<HashMap<String, i64>> {
    let linhas: Vec<(String, i64)> = sqlx::query_as(
        r#"
        WITH RECURSIVE descendencia(id, nivel) AS (
            SELECT p.id, 0 FROM pessoas p
             WHERE NOT EXISTS (SELECT 1 FROM uniao_filhos f WHERE f.pessoa_id = p.id)
            UNION
            SELECT f.pessoa_id, d.nivel + 1
              FROM descendencia d
              JOIN unioes u ON u.slot_masculino_id = d.id OR u.slot_feminino_id = d.id
              JOIN uniao_filhos f ON f.uniao_id = u.id
             WHERE d.nivel < 60
        )
        SELECT id, MAX(nivel) FROM descendencia GROUP BY id
        "#,
    )
    .fetch_all(pool)
    .await?;

    Ok(linhas.into_iter().collect())
}

#[cfg(test)]
mod testes {
    use super::*;
    use crate::domain::regras::{self, NovaPessoa};
    use sqlx::sqlite::SqlitePoolOptions;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    async fn pessoa(pool: &SqlitePool, nome: &str, sexo: &str, vivo: bool) -> String {
        regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: None,
                sexo: sexo.into(),
                minibiografia: None,
                is_vivo: vivo,
                foto_url: None,
            },
        )
        .await
        .unwrap()
    }

    async fn nascimento(pool: &SqlitePool, pessoa_id: &str, texto: &str, ano: i64) {
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio)
             VALUES (?,?,?,?,'exata',?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(pessoa_id)
        .bind(tipos::NASCIMENTO)
        .bind(texto)
        .bind(ano)
        .execute(pool)
        .await
        .unwrap();
    }

    fn opcoes() -> OpcoesRelatorio {
        OpcoesRelatorio { raiz_id: None, ocultar_vivas: false, incluir_placeholders: false }
    }

    #[tokio::test]
    async fn acervo_vazio_nao_quebra() {
        let pool = pool_de_teste().await;
        let r = montar(&pool, &opcoes()).await.unwrap();
        assert_eq!(r.total, 0);
    }

    #[tokio::test]
    async fn ordena_por_geracao_depois_ano_depois_nome() {
        let pool = pool_de_teste().await;

        let avo = pessoa(&pool, "Avô", "M", false).await;
        let avoh = pessoa(&pool, "Avó", "F", false).await;
        let pai = pessoa(&pool, "Pai", "M", false).await;
        let tia = pessoa(&pool, "Tia", "F", false).await;
        let neto = pessoa(&pool, "Neto", "M", false).await;

        nascimento(&pool, &avo, "1900", 1900).await;
        nascimento(&pool, &tia, "1928", 1928).await;
        nascimento(&pool, &pai, "1930", 1930).await;
        nascimento(&pool, &neto, "1960", 1960).await;
        // A avó fica sem data de propósito.

        let u = regras::criar_uniao(&pool, Some(&avo), Some(&avoh), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u, &pai, "biologico").await.unwrap();
        regras::anexar_filho(&pool, &u, &tia, "biologico").await.unwrap();

        let esposa = pessoa(&pool, "Esposa", "F", false).await;
        let u2 = regras::criar_uniao(&pool, Some(&pai), Some(&esposa), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u2, &neto, "biologico").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        let nomes: Vec<&str> = r.entradas.iter().map(|e| e.nome.as_str()).collect();

        // Geração 0 (avô, avó, esposa) antes da 1 (tia, pai) antes da 2 (neto).
        let pos = |n: &str| nomes.iter().position(|x| *x == n).unwrap();
        assert!(pos("Avô") < pos("Tia"), "{nomes:?}");
        assert!(pos("Pai") < pos("Neto"), "{nomes:?}");
        // Dentro da geração 1, a tia (1928) vem antes do pai (1930).
        assert!(pos("Tia") < pos("Pai"), "{nomes:?}");
        // A avó, sem data, fica no fim da geração dela — mas está lá.
        assert!(nomes.contains(&"Avó"), "ninguém pode sumir da lista");
    }

    #[tokio::test]
    async fn quem_nao_tem_data_nao_some() {
        let pool = pool_de_teste().await;
        for nome in ["Sem data A", "Sem data B", "Sem data C"] {
            pessoa(&pool, nome, "U", false).await;
        }
        let r = montar(&pool, &opcoes()).await.unwrap();
        assert_eq!(r.total, 3, "as três precisam aparecer");
    }

    #[tokio::test]
    async fn ocultar_vivas_remove_e_conta() {
        let pool = pool_de_teste().await;
        pessoa(&pool, "Falecido", "M", false).await;
        pessoa(&pool, "Vivo", "M", true).await;
        pessoa(&pool, "Viva", "F", true).await;

        let r = montar(
            &pool,
            &OpcoesRelatorio { raiz_id: None, ocultar_vivas: true, incluir_placeholders: false },
        )
        .await
        .unwrap();

        assert_eq!(r.total, 1);
        assert_eq!(r.omitidas_vivas, 2);
        assert_eq!(r.entradas[0].nome, "Falecido");
    }

    #[tokio::test]
    async fn placeholders_ficam_fora_por_padrao() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F", false).await;
        // Cria a união com pai desconhecido: nasce um placeholder.
        regras::criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert_eq!(r.total, 1, "o placeholder não deveria virar uma ficha");
        assert_eq!(r.entradas[0].nome, "Mãe");
    }

    #[tokio::test]
    async fn a_ficha_traz_pais_conjuge_e_filhos() {
        let pool = pool_de_teste().await;
        let pai = pessoa(&pool, "Pai", "M", false).await;
        let mae = pessoa(&pool, "Mãe", "F", false).await;
        let filho = pessoa(&pool, "Filho", "M", false).await;

        let u = regras::criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u, &filho, "biologico").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        let do_pai = r.entradas.iter().find(|e| e.nome == "Pai").unwrap();
        assert_eq!(do_pai.unioes.len(), 1);
        assert_eq!(do_pai.unioes[0].conjuge, "Mãe");
        assert_eq!(do_pai.unioes[0].filhos, vec!["Filho"]);

        let do_filho = r.entradas.iter().find(|e| e.nome == "Filho").unwrap();
        assert_eq!(do_filho.pais, vec!["Pai", "Mãe"]);
    }

    #[tokio::test]
    async fn o_texto_da_data_e_o_do_usuario() {
        // Regra da spec: sai "cerca de 1890", nunca o intervalo derivado.
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisavô", "M", false).await;
        nascimento(&pool, &p, "cerca de 1890", 1885).await;

        let r = montar(&pool, &opcoes()).await.unwrap();
        let e = &r.entradas[0];
        assert_eq!(e.nascimento.as_ref().unwrap().data_texto.as_deref(), Some("cerca de 1890"));
    }

    #[tokio::test]
    async fn escopo_por_raiz_recorta_o_acervo() {
        let pool = pool_de_teste().await;

        // Família A, ligada.
        let a1 = pessoa(&pool, "A1", "M", false).await;
        let a2 = pessoa(&pool, "A2", "F", false).await;
        let a3 = pessoa(&pool, "A3", "M", false).await;
        let ua = regras::criar_uniao(&pool, Some(&a1), Some(&a2), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &ua, &a3, "biologico").await.unwrap();

        // Família B, sem ligação nenhuma com a A.
        pessoa(&pool, "B1", "M", false).await;

        let r = montar(
            &pool,
            &OpcoesRelatorio {
                raiz_id: Some(a3.clone()),
                ocultar_vivas: false,
                incluir_placeholders: false,
            },
        )
        .await
        .unwrap();

        let nomes: Vec<&str> = r.entradas.iter().map(|e| e.nome.as_str()).collect();
        assert!(nomes.contains(&"A1") && nomes.contains(&"A3"), "{nomes:?}");
        assert!(!nomes.contains(&"B1"), "B1 está fora da árvore da raiz: {nomes:?}");
    }

    #[tokio::test]
    async fn atributos_entram_na_ficha() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisavó", "F", false).await;

        sqlx::query("INSERT INTO religioes_pessoa (id,pessoa_id,denominacao,periodo) VALUES ('r1',?,'Católica','desde 1920')")
            .bind(&p).execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO profissoes_pessoa (id,pessoa_id,ocupacao,empregador_local,periodo) VALUES ('pr1',?,'Costureira',NULL,NULL)")
            .bind(&p).execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO apelidos_pessoa (id,pessoa_id,apelido) VALUES ('a1',?,'Dona Chica')")
            .bind(&p).execute(&pool).await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        let e = &r.entradas[0];

        assert_eq!(e.apelidos, vec!["Dona Chica"]);
        assert_eq!(e.religioes, vec!["Católica (desde 1920)"]);
        assert_eq!(e.profissoes, vec!["Costureira"], "sem período não deve sobrar parêntese");
    }
}
