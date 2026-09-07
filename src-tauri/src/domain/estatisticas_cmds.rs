//! Estatísticas e demografia da família (Fatia 11, Seção 7 da Especificação).
//!
//! Todas as agregações refletem o conjunto filtrado (ou todo o acervo se nenhum
//! filtro for passado): "o filtro alimenta a estatística".

use serde::Serialize;
use sqlx::{FromRow, SqlitePool};
use tauri::State;

use crate::domain::busca_cmds::{montar_condicoes, FiltrosBusca, Valor};
use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;

#[derive(Debug, Clone, Serialize, PartialEq)]
pub struct ContagemItem {
    pub chave: String,
    pub rotulo: String,
    pub contagem: i64,
    pub percentual: f64,
}

#[derive(Debug, Clone, Serialize, PartialEq)]
pub struct EstatisticasAcervo {
    pub total_pessoas: i64,
    pub total_vivas: i64,
    pub total_falecidas: i64,
    pub total_com_nascimento: i64,
    pub idade_media_falecimento: Option<f64>,
    pub ano_mais_antigo: Option<i64>,
    pub ano_mais_recente: Option<i64>,

    pub distribuicao_sexo: Vec<ContagemItem>,
    pub distribuicao_situacao: Vec<ContagemItem>,
    pub distribuicao_decadas: Vec<ContagemItem>,
    pub distribuicao_sobrenomes: Vec<ContagemItem>,
    pub distribuicao_cidades: Vec<ContagemItem>,
    pub distribuicao_paises: Vec<ContagemItem>,
    pub distribuicao_religioes: Vec<ContagemItem>,
    pub distribuicao_profissoes: Vec<ContagemItem>,
    pub distribuicao_escolaridade: Vec<ContagemItem>,
}

#[derive(FromRow)]
struct LinhaGeral {
    total: i64,
    vivas: i64,
    falecidas: i64,
    com_nascimento: i64,
    ano_antigo: Option<i64>,
    ano_recente: Option<i64>,
    media_idade: Option<f64>,
}

#[derive(FromRow)]
struct LinhaAgrupamento {
    chave: Option<String>,
    quantas: i64,
}

fn calc_pct(parte: i64, total: i64) -> f64 {
    if total <= 0 {
        0.0
    } else {
        ((parte as f64 / total as f64) * 1000.0).round() / 10.0
    }
}

fn rotulo_sexo(s: &str) -> &'static str {
    match s {
        "M" => "Masculino",
        "F" => "Feminino",
        "X" => "Outro / Não binário",
        _ => "Não informado",
    }
}

#[tauri::command]
pub async fn calcular_estatisticas(
    filtros: Option<FiltrosBusca>,
    db: State<'_, SqlitePool>,
) -> Resultado<EstatisticasAcervo> {
    let f = filtros.unwrap_or_default();
    calcular(&db, &f).await
}

pub async fn calcular(pool: &SqlitePool, filtros: &FiltrosBusca) -> Resultado<EstatisticasAcervo> {
    let (condicoes, valores) = montar_condicoes(filtros);

    let onde = if condicoes.is_empty() {
        String::new()
    } else {
        format!("WHERE {}", condicoes.join(" AND "))
    };

    // 1. Totais gerais e indicadores numéricos
    let sql_geral = format!(
        r#"WITH filtradas AS (
            SELECT p.id, p.is_vivo
            FROM pessoas p
            {onde}
        )
        SELECT
            COUNT(f.id) AS total,
            COALESCE(SUM(CASE WHEN f.is_vivo = 1 THEN 1 ELSE 0 END), 0) AS vivas,
            COALESCE(SUM(CASE WHEN f.is_vivo = 0 THEN 1 ELSE 0 END), 0) AS falecidas,
            COUNT(DISTINCT CASE WHEN en.ano_inicio IS NOT NULL THEN f.id END) AS com_nascimento,
            MIN(en.ano_inicio) AS ano_antigo,
            MAX(en.ano_inicio) AS ano_recente,
            AVG(CASE
                WHEN ef.ano_inicio IS NOT NULL AND en.ano_inicio IS NOT NULL AND ef.ano_inicio >= en.ano_inicio
                THEN (ef.ano_inicio - en.ano_inicio)
                ELSE NULL
            END) AS media_idade
        FROM filtradas f
        LEFT JOIN eventos en ON en.pessoa_id = f.id AND en.tipo_evento = '{nasc}'
        LEFT JOIN eventos ef ON ef.pessoa_id = f.id AND ef.tipo_evento = '{falec}'"#,
        nasc = tipos::NASCIMENTO,
        falec = tipos::FALECIMENTO,
    );

    let mut q_geral = sqlx::query_as::<sqlx::Sqlite, LinhaGeral>(&sql_geral);
    for v in &valores {
        q_geral = match v {
            Valor::Texto(s) => q_geral.bind(s),
            Valor::Numero(n) => q_geral.bind(n),
        };
    }

    let geral = q_geral.fetch_one(pool).await?;
    let total = geral.total;

    // 2. Distribuição de Situação (Vivas x Falecidas)
    let distribuicao_situacao = vec![
        ContagemItem {
            chave: "vivas".into(),
            rotulo: "Vivas".into(),
            contagem: geral.vivas,
            percentual: calc_pct(geral.vivas, total),
        },
        ContagemItem {
            chave: "falecidas".into(),
            rotulo: "Falecidas".into(),
            contagem: geral.falecidas,
            percentual: calc_pct(geral.falecidas, total),
        },
    ];

    // 3. Distribuição de Sexo
    let sql_sexo = format!(
        r#"WITH filtradas AS (
            SELECT p.sexo
            FROM pessoas p
            {onde}
        )
        SELECT COALESCE(sexo, 'U') AS chave, COUNT(*) AS quantas
        FROM filtradas
        GROUP BY chave
        ORDER BY quantas DESC"#
    );
    let mut q_sexo = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_sexo);
    for v in &valores {
        q_sexo = match v {
            Valor::Texto(s) => q_sexo.bind(s),
            Valor::Numero(n) => q_sexo.bind(n),
        };
    }
    let linhas_sexo = q_sexo.fetch_all(pool).await?;
    let distribuicao_sexo = linhas_sexo
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_else(|| "U".into());
            let rot = rotulo_sexo(&ch).to_string();
            ContagemItem {
                chave: ch,
                rotulo: rot,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 4. Distribuição por Décadas de Nascimento
    let sql_decadas = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            CAST(((e.ano_inicio / 10) * 10) AS TEXT) AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN eventos e ON e.pessoa_id = f.id AND e.tipo_evento = '{nasc}'
        WHERE e.ano_inicio IS NOT NULL
        GROUP BY chave
        ORDER BY CAST(chave AS INTEGER) ASC"#,
        nasc = tipos::NASCIMENTO,
    );
    let mut q_decadas = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_decadas);
    for v in &valores {
        q_decadas = match v {
            Valor::Texto(s) => q_decadas.bind(s),
            Valor::Numero(n) => q_decadas.bind(n),
        };
    }
    let linhas_decadas = q_decadas.fetch_all(pool).await?;
    let distribuicao_decadas = linhas_decadas
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            let rot = if let Ok(num) = ch.parse::<i64>() {
                if num < 0 {
                    format!("{} a.C.", num.abs())
                } else {
                    format!("Anos {}", num)
                }
            } else {
                ch.clone()
            };
            ContagemItem {
                chave: ch,
                rotulo: rot,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 5. Distribuição por Sobrenomes (Top 12)
    let sql_sobrenomes = format!(
        r#"WITH filtradas AS (
            SELECT p.sobrenome
            FROM pessoas p
            {onde}
        )
        SELECT
            TRIM(sobrenome) AS chave,
            COUNT(*) AS quantas
        FROM filtradas
        WHERE sobrenome IS NOT NULL AND TRIM(sobrenome) <> ''
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 12"#
    );
    let mut q_sobrenomes = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_sobrenomes);
    for v in &valores {
        q_sobrenomes = match v {
            Valor::Texto(s) => q_sobrenomes.bind(s),
            Valor::Numero(n) => q_sobrenomes.bind(n),
        };
    }
    let linhas_sobrenomes = q_sobrenomes.fetch_all(pool).await?;
    let distribuicao_sobrenomes = linhas_sobrenomes
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 6. Distribuição por Cidades de Nascimento (Top 12)
    let sql_cidades = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            COALESCE(l.nome, 'Não informado') AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN eventos e ON e.pessoa_id = f.id AND e.tipo_evento = '{nasc}'
        LEFT JOIN locais l ON l.id = e.local_id
        WHERE e.local_id IS NOT NULL
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 12"#,
        nasc = tipos::NASCIMENTO,
    );
    let mut q_cidades = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_cidades);
    for v in &valores {
        q_cidades = match v {
            Valor::Texto(s) => q_cidades.bind(s),
            Valor::Numero(n) => q_cidades.bind(n),
        };
    }
    let linhas_cidades = q_cidades.fetch_all(pool).await?;
    let distribuicao_cidades = linhas_cidades
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 7. Distribuição por Países de Nacionalidade (Top 10)
    let sql_paises = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            n.pais_id AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN nacionalidades_pessoa n ON n.pessoa_id = f.id
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 10"#
    );
    let mut q_paises = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_paises);
    for v in &valores {
        q_paises = match v {
            Valor::Texto(s) => q_paises.bind(s),
            Valor::Numero(n) => q_paises.bind(n),
        };
    }
    let linhas_paises = q_paises.fetch_all(pool).await?;
    let distribuicao_paises = linhas_paises
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 8. Religiões
    let sql_religioes = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            r.denominacao AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN religioes_pessoa r ON r.pessoa_id = f.id
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 10"#
    );
    let mut q_religioes = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_religioes);
    for v in &valores {
        q_religioes = match v {
            Valor::Texto(s) => q_religioes.bind(s),
            Valor::Numero(n) => q_religioes.bind(n),
        };
    }
    let linhas_religioes = q_religioes.fetch_all(pool).await?;
    let distribuicao_religioes = linhas_religioes
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 9. Profissões
    let sql_profissoes = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            pr.ocupacao AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN profissoes_pessoa pr ON pr.pessoa_id = f.id
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 10"#
    );
    let mut q_profissoes = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_profissoes);
    for v in &valores {
        q_profissoes = match v {
            Valor::Texto(s) => q_profissoes.bind(s),
            Valor::Numero(n) => q_profissoes.bind(n),
        };
    }
    let linhas_profissoes = q_profissoes.fetch_all(pool).await?;
    let distribuicao_profissoes = linhas_profissoes
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    // 10. Escolaridade
    let sql_escolaridade = format!(
        r#"WITH filtradas AS (
            SELECT p.id
            FROM pessoas p
            {onde}
        )
        SELECT
            esc.nivel AS chave,
            COUNT(DISTINCT f.id) AS quantas
        FROM filtradas f
        JOIN escolaridade_pessoa esc ON esc.pessoa_id = f.id
        GROUP BY chave
        ORDER BY quantas DESC, chave ASC
        LIMIT 10"#
    );
    let mut q_escolaridade = sqlx::query_as::<sqlx::Sqlite, LinhaAgrupamento>(&sql_escolaridade);
    for v in &valores {
        q_escolaridade = match v {
            Valor::Texto(s) => q_escolaridade.bind(s),
            Valor::Numero(n) => q_escolaridade.bind(n),
        };
    }
    let linhas_escolaridade = q_escolaridade.fetch_all(pool).await?;
    let distribuicao_escolaridade = linhas_escolaridade
        .into_iter()
        .map(|r| {
            let ch = r.chave.unwrap_or_default();
            ContagemItem {
                chave: ch.clone(),
                rotulo: ch,
                contagem: r.quantas,
                percentual: calc_pct(r.quantas, total),
            }
        })
        .collect();

    Ok(EstatisticasAcervo {
        total_pessoas: total,
        total_vivas: geral.vivas,
        total_falecidas: geral.falecidas,
        total_com_nascimento: geral.com_nascimento,
        idade_media_falecimento: geral.media_idade.map(|m| (m * 10.0).round() / 10.0),
        ano_mais_antigo: geral.ano_antigo,
        ano_mais_recente: geral.ano_recente,
        distribuicao_sexo,
        distribuicao_situacao,
        distribuicao_decadas,
        distribuicao_sobrenomes,
        distribuicao_cidades,
        distribuicao_paises,
        distribuicao_religioes,
        distribuicao_profissoes,
        distribuicao_escolaridade,
    })
}

#[cfg(test)]
mod testes {
    use super::*;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePool::connect("sqlite::memory:").await.unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    #[tokio::test]
    async fn acervo_vazio_devolve_zeros() {
        let pool = pool_de_teste().await;
        let stats = calcular(&pool, &FiltrosBusca::default()).await.unwrap();
        assert_eq!(stats.total_pessoas, 0);
        assert_eq!(stats.total_vivas, 0);
        assert_eq!(stats.total_falecidas, 0);
        assert_eq!(stats.idade_media_falecimento, None);
    }

    #[tokio::test]
    async fn calcula_distribuicoes_e_indicadores_corretamente() {
        let pool = pool_de_teste().await;

        // Inserir pessoa 1: João Silva, M, nascido em 1940, falecido em 2000 (viveu 60 anos)
        let p1 = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'João', 'Silva', 'M', 0, 0)",
        )
        .bind(&p1)
        .execute(&pool)
        .await
        .unwrap();

        let e1_nasc = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_texto)
             VALUES (?, ?, 'nascimento', 1942, '1942')",
        )
        .bind(&e1_nasc)
        .bind(&p1)
        .execute(&pool)
        .await
        .unwrap();

        let e1_falec = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_texto)
             VALUES (?, ?, 'falecimento', 2002, '2002')",
        )
        .bind(&e1_falec)
        .bind(&p1)
        .execute(&pool)
        .await
        .unwrap();

        // Inserir pessoa 2: Maria Silva, F, nascida em 1945, viva
        let p2 = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Maria', 'Silva', 'F', 1, 0)",
        )
        .bind(&p2)
        .execute(&pool)
        .await
        .unwrap();

        let e2_nasc = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_texto)
             VALUES (?, ?, 'nascimento', 1948, '1948')",
        )
        .bind(&e2_nasc)
        .bind(&p2)
        .execute(&pool)
        .await
        .unwrap();

        // Inserir pessoa 3: Pedro Santos, M, nascido em 1975, vivo
        let p3 = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Pedro', 'Santos', 'M', 1, 0)",
        )
        .bind(&p3)
        .execute(&pool)
        .await
        .unwrap();

        let stats = calcular(&pool, &FiltrosBusca::default()).await.unwrap();
        assert_eq!(stats.total_pessoas, 3);
        assert_eq!(stats.total_vivas, 2);
        assert_eq!(stats.total_falecidas, 1);
        assert_eq!(stats.total_com_nascimento, 2); // p1 e p2 têm nascimento, p3 não
        assert_eq!(stats.ano_mais_antigo, Some(1942));
        assert_eq!(stats.ano_mais_recente, Some(1948));
        assert_eq!(stats.idade_media_falecimento, Some(60.0));

        // Sobrenomes: Silva (2), Santos (1)
        assert_eq!(stats.distribuicao_sobrenomes.len(), 2);
        assert_eq!(stats.distribuicao_sobrenomes[0].chave, "Silva");
        assert_eq!(stats.distribuicao_sobrenomes[0].contagem, 2);
        assert_eq!(stats.distribuicao_sobrenomes[0].percentual, 66.7);

        // Décadas: Anos 1940 com 2 pessoas
        assert_eq!(stats.distribuicao_decadas.len(), 1);
        assert_eq!(stats.distribuicao_decadas[0].chave, "1940");
        assert_eq!(stats.distribuicao_decadas[0].contagem, 2);

        // Filtro alimenta estatística: filtrar apenas sobrenome 'Santos'
        let mut f_santos = FiltrosBusca::default();
        f_santos.sobrenome = Some("Santos".into());
        let stats_santos = calcular(&pool, &f_santos).await.unwrap();
        assert_eq!(stats_santos.total_pessoas, 1);
        assert_eq!(stats_santos.distribuicao_sobrenomes[0].chave, "Santos");
        assert_eq!(stats_santos.distribuicao_sobrenomes[0].contagem, 1);
    }
}
