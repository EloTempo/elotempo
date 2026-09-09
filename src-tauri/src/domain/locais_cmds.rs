//! Locais: municípios brasileiros e cidades estrangeiras (fatia 04).
//!
//! Municípios vêm do seed do IBGE (migration 009) e são identificados pelo
//! `codigo_ibge` — a chave estável que a seção 2.4 exige. Nome de cidade muda
//! com o tempo; o código, não.
//!
//! Cidade estrangeira é texto livre: só o país é padronizado. Ela vira linha em
//! `locais` no momento do uso para que o agrupamento por país da seção 7 tenha
//! do que se agarrar.

use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::State;
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::texto::normalizar_busca;

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Local {
    pub id: String,
    pub nome: String,
    pub uf: Option<String>,
    pub pais_id: String,
    /// Nulo para cidades no exterior — lá só o país é padronizado.
    pub codigo_ibge: Option<String>,
    /// Nome do país, para a interface não precisar de outra consulta.
    pub pais_nome: String,
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
}

/// Autocomplete de local.
///
/// Busca na coluna sem acento: quem digita "sao paulo" tem de achar
/// "São Paulo". Prefixo vem antes de "contém" porque quem digita "campos"
/// quer "Campos dos Goytacazes" antes de "Bom Jesus", ainda que os dois casem.
#[tauri::command]
pub async fn buscar_locais(
    termo: String,
    limite: Option<i64>,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Local>> {
    let limite = limite.unwrap_or(20).clamp(1, 100);
    let normalizado = normalizar_busca(&termo);

    if normalizado.is_empty() {
        return Ok(vec![]);
    }

    let contem = format!("%{normalizado}%");
    let comeca = format!("{normalizado}%");

    Ok(sqlx::query_as::<_, Local>(
        "SELECT l.id, l.nome, l.uf, l.pais_id, l.codigo_ibge, p.nome AS pais_nome, l.latitude, l.longitude
         FROM locais l
         JOIN paises p ON p.id = l.pais_id
         WHERE l.nome_busca LIKE ?1
         ORDER BY (l.nome_busca LIKE ?2) DESC,
                  -- Brasil e Portugal primeiro: principais fluxos genealógicos dos acervos.
                  (l.pais_id <> 'br' AND l.pais_id <> 'pt'),
                  (l.pais_id <> 'br'),
                  length(l.nome),
                  l.nome
         LIMIT ?3",
    )
    .bind(&contem)
    .bind(&comeca)
    .bind(limite)
    .fetch_all(&*db)
    .await?)
}

#[tauri::command]
pub async fn obter_local(id: String, db: State<'_, SqlitePool>) -> Resultado<Local> {
    obter_local_interno(&db, &id).await
}

/// Registra (ou reaproveita) uma cidade no exterior.
///
/// Se alguém já tiver digitado "Lisboa, Portugal", a segunda vez devolve a
/// mesma linha em vez de criar uma duplicata — é o que o índice único parcial
/// da migration 012 garante, e o que faz a estatística por país fechar.
#[tauri::command]
pub async fn registrar_local_estrangeiro(
    nome: String,
    pais_id: String,
    latitude: Option<f64>,
    longitude: Option<f64>,
    db: State<'_, SqlitePool>,
) -> Resultado<Local> {
    let nome = nome.trim().to_string();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: "informe a cidade".into(),
        });
    }

    let pais_existe: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM paises WHERE id = ?")
        .bind(&pais_id)
        .fetch_one(&*db)
        .await?;
    if pais_existe == 0 {
        return Err(ErroDominio::ValorInvalido {
            campo: "pais_id".into(),
            valor: pais_id,
        });
    }

    let busca = normalizar_busca(&nome);

    let ja_existe: Option<(String, Option<f64>, Option<f64>)> = sqlx::query_as(
        "SELECT id, latitude, longitude FROM locais WHERE pais_id = ? AND nome_busca = ? AND codigo_ibge IS NULL",
    )
    .bind(&pais_id)
    .bind(&busca)
    .fetch_optional(&*db)
    .await?;

    let id = match ja_existe {
        Some((existente_id, lat_existente, lon_existente)) => {
            // Se já existia mas não tinha latitude/longitude, e agora foram fornecidas, atualiza
            if (lat_existente.is_none() || lon_existente.is_none()) && latitude.is_some() && longitude.is_some() {
                let _ = sqlx::query(
                    "UPDATE locais SET latitude = COALESCE(latitude, ?), longitude = COALESCE(longitude, ?) WHERE id = ?"
                )
                .bind(latitude)
                .bind(longitude)
                .bind(&existente_id)
                .execute(&*db)
                .await;
            }
            existente_id
        }
        None => {
            let novo = Uuid::new_v4().to_string();
            sqlx::query(
                "INSERT INTO locais (id, nome, uf, pais_id, codigo_ibge, latitude, longitude, nome_busca)
                 VALUES (?, ?, NULL, ?, NULL, ?, ?, ?)",
            )
            .bind(&novo)
            .bind(&nome)
            .bind(&pais_id)
            .bind(latitude)
            .bind(longitude)
            .bind(&busca)
            .execute(&*db)
            .await?;
            novo
        }
    };

    obter_local_interno(&db, &id).await
}

async fn obter_local_interno(pool: &SqlitePool, id: &str) -> Resultado<Local> {
    sqlx::query_as::<_, Local>(
        "SELECT l.id, l.nome, l.uf, l.pais_id, l.codigo_ibge, p.nome AS pais_nome, l.latitude, l.longitude
         FROM locais l JOIN paises p ON p.id = l.pais_id
         WHERE l.id = ?",
    )
    .bind(id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| ErroDominio::ValorInvalido {
        campo: "locais.id".into(),
        valor: id.to_string(),
    })
}

#[cfg(test)]
mod testes {
    use super::*;
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

    /// Reproduz o que `buscar_locais` faz, sem a casca do Tauri.
    async fn buscar(pool: &SqlitePool, termo: &str) -> Vec<String> {
        let n = normalizar_busca(termo);
        sqlx::query_scalar::<_, String>(
            "SELECT l.nome FROM locais l
             WHERE l.nome_busca LIKE ?1
             ORDER BY (l.nome_busca LIKE ?2) DESC, (l.pais_id <> 'br'), length(l.nome), l.nome
             LIMIT 10",
        )
        .bind(format!("%{n}%"))
        .bind(format!("{n}%"))
        .fetch_all(pool)
        .await
        .unwrap()
    }

    #[tokio::test]
    async fn o_seed_do_ibge_esta_carregado() {
        let pool = pool_de_teste().await;
        let total: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM locais WHERE pais_id = 'br'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total > 5000, "esperava ~5.571 municípios, achei {total}");
    }

    #[tokio::test]
    async fn a_migration_preencheu_nome_busca_de_todos() {
        let pool = pool_de_teste().await;
        let sem: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM locais WHERE nome_busca IS NULL OR nome_busca = ''",
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(sem, 0, "{sem} municípios ficaram sem nome_busca");
    }

    /// O ponto da fatia: buscar sem acento tem de achar o nome acentuado.
    #[tokio::test]
    async fn busca_sem_acento_encontra_o_municipio() {
        let pool = pool_de_teste().await;

        for (digitado, esperado) in [
            ("sao paulo", "São Paulo"),
            ("brasilia", "Brasília"),
            ("vitoria", "Vitória"),
            ("goiania", "Goiânia"),
            ("florianopolis", "Florianópolis"),
        ] {
            let achados = buscar(&pool, digitado).await;
            assert!(
                achados.iter().any(|n| n == esperado),
                "digitando '{digitado}' esperava achar '{esperado}', achei {achados:?}"
            );
        }
    }

    #[tokio::test]
    async fn busca_com_acento_tambem_funciona() {
        // Quem digita certo não pode ser punido por isso.
        let pool = pool_de_teste().await;
        let achados = buscar(&pool, "São Paulo").await;
        assert!(achados.iter().any(|n| n == "São Paulo"), "{achados:?}");
    }

    #[tokio::test]
    async fn a_normalizacao_do_rust_bate_com_a_da_migration() {
        // Se as duas divergirem, a busca erra em silêncio. Compara o que a
        // migration gravou com o que o Rust produziria para o mesmo nome.
        let pool = pool_de_teste().await;
        let amostra: Vec<(String, String)> = sqlx::query_as(
            "SELECT nome, nome_busca FROM locais WHERE pais_id = 'br' ORDER BY nome LIMIT 300",
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        for (nome, gravado) in amostra {
            assert_eq!(
                gravado,
                crate::domain::texto::sem_acento(&nome),
                "divergência em '{nome}'"
            );
        }
    }

    #[tokio::test]
    async fn prefixo_vem_antes_de_contem() {
        let pool = pool_de_teste().await;
        let achados = buscar(&pool, "campos").await;
        let primeiro = achados.first().expect("deveria achar algo");
        assert!(
            crate::domain::texto::sem_acento(primeiro).starts_with("campos"),
            "o primeiro resultado deveria começar com 'campos', veio '{primeiro}'"
        );
    }

    #[tokio::test]
    async fn cidade_estrangeira_nao_duplica() {
        let pool = pool_de_teste().await;

        let inserir = |nome: &'static str| {
            let pool = pool.clone();
            async move {
                let busca = normalizar_busca(nome);
                let ja: Option<String> = sqlx::query_scalar(
                    "SELECT id FROM locais WHERE pais_id='pt' AND nome_busca=? AND codigo_ibge IS NULL",
                )
                .bind(&busca)
                .fetch_optional(&pool)
                .await
                .unwrap();

                match ja {
                    Some(id) => id,
                    None => {
                        let id = Uuid::new_v4().to_string();
                        sqlx::query(
                            "INSERT INTO locais (id,nome,uf,pais_id,codigo_ibge,nome_busca)
                             VALUES (?,?,NULL,'pt',NULL,?)",
                        )
                        .bind(&id)
                        .bind(nome)
                        .bind(&busca)
                        .execute(&pool)
                        .await
                        .unwrap();
                        id
                    }
                }
            }
        };

        let primeira = inserir("MinhaVilaTeste").await;
        let segunda = inserir("minhavilateste").await; // caixa diferente
        assert_eq!(primeira, segunda, "a mesma vila não pode virar dois lugares");

        let quantas: i64 =
            sqlx::query_scalar("SELECT COUNT(*) FROM locais WHERE pais_id = 'pt' AND nome_busca = 'minhavilateste'")
                .fetch_one(&pool)
                .await
                .unwrap();
        assert_eq!(quantas, 1);
    }

    #[tokio::test]
    async fn concelhos_portugueses_e_cidades_mundiais_estao_disponiveis_com_coordenadas() {
        let pool = pool_de_teste().await;

        // Concelhos de Portugal essenciais
        for concelho in ["Lisboa", "Porto", "Coimbra", "Braga", "Faro", "Cascais", "Sintra"] {
            let res: Option<(String, Option<f64>, Option<f64>)> = sqlx::query_as(
                "SELECT nome, latitude, longitude FROM locais WHERE pais_id = 'pt' AND nome = ?",
            )
            .bind(concelho)
            .fetch_optional(&pool)
            .await
            .unwrap();

            assert!(res.is_some(), "Concelho de Portugal '{concelho}' deve estar cadastrado");
            let (nome, lat, lon) = res.unwrap();
            assert_eq!(nome, concelho);
            assert!(lat.is_some(), "Latitude de '{concelho}' não pode ser nula");
            assert!(lon.is_some(), "Longitude de '{concelho}' não pode ser nula");
        }

        // Cidades mundiais
        for cidade in ["Roma", "Paris", "Madrid"] {
            let res: Option<(String, Option<f64>, Option<f64>)> = sqlx::query_as(
                "SELECT nome, latitude, longitude FROM locais WHERE nome = ?",
            )
            .bind(cidade)
            .fetch_optional(&pool)
            .await
            .unwrap();

            assert!(res.is_some(), "Cidade mundial '{cidade}' deve estar cadastrada");
            let (nome, lat, lon) = res.unwrap();
            assert_eq!(nome, cidade);
            assert!(lat.is_some(), "Latitude de '{cidade}' não pode ser nula");
            assert!(lon.is_some(), "Longitude de '{cidade}' não pode ser nula");
        }
    }

    #[tokio::test]
    async fn municipio_carrega_uf_e_codigo_ibge() {
        let pool = pool_de_teste().await;
        let linha: Option<(String, Option<String>, Option<String>)> = sqlx::query_as(
            "SELECT nome, uf, codigo_ibge FROM locais WHERE nome_busca = 'sao paulo' AND uf = 'SP'",
        )
        .fetch_optional(&pool)
        .await
        .unwrap();

        let (nome, uf, ibge) = linha.expect("São Paulo deveria estar no seed");
        assert_eq!(nome, "São Paulo");
        assert_eq!(uf.as_deref(), Some("SP"));
        assert!(ibge.is_some(), "município do IBGE precisa de código");
    }

    #[tokio::test]
    async fn busca_vazia_nao_devolve_o_acervo_inteiro() {
        assert_eq!(normalizar_busca("   "), "");
    }
}
