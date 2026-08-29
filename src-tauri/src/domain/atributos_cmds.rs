//! Atributos de vida em lista (seção 2.5): religião, escolaridade, profissões,
//! idiomas, apelidos e nacionalidades.
//!
//! Todos seguem o mesmo padrão — uma entrada por item, com data/período
//! opcional. A regra transversal vale em todos: **a data nunca é obrigatória
//! para salvar**; o app grava a entrada só com o valor.

use sqlx::SqlitePool;
use tauri::State;
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::{
    Apelido, Escolaridade, Idioma, Nacionalidade, Profissao, Religiao,
};

/// Remove uma entrada de atributo pelo id.
///
/// `tabela` vem sempre de uma constante do próprio código — nunca do usuário —
/// então interpolá-la é seguro. O `id` continua sendo bind parametrizado.
async fn remover_de(pool: &SqlitePool, tabela: &'static str, id: &str) -> Resultado<()> {
    let afetadas = sqlx::query(&format!("DELETE FROM {tabela} WHERE id = ?"))
        .bind(id)
        .execute(pool)
        .await?
        .rows_affected();

    if afetadas == 0 {
        return Err(ErroDominio::ValorInvalido {
            campo: format!("{tabela}.id"),
            valor: id.to_string(),
        });
    }
    Ok(())
}

/// Confere que a pessoa existe antes de pendurar um atributo nela.
/// A FK já garante isso, mas o erro do SQLite não diz nada ao usuário.
async fn exigir_pessoa(pool: &SqlitePool, pessoa_id: &str) -> Resultado<()> {
    let existe: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE id = ?")
        .bind(pessoa_id)
        .fetch_one(pool)
        .await?;
    if existe == 0 {
        return Err(ErroDominio::PessoaNaoEncontrada(pessoa_id.to_string()));
    }
    Ok(())
}

fn texto_obrigatorio(campo: &str, valor: &str) -> Resultado<String> {
    let limpo = valor.trim();
    if limpo.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: campo.to_string(),
            valor: valor.to_string(),
        });
    }
    Ok(limpo.to_string())
}

// ---------------------------------------------------------------- Religião

#[tauri::command]
pub async fn adicionar_religiao(
    pessoa_id: String,
    denominacao: String,
    periodo: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let denominacao = texto_obrigatorio("denominacao", &denominacao)?;
    let id = Uuid::new_v4().to_string();

    sqlx::query("INSERT INTO religioes_pessoa (id, pessoa_id, denominacao, periodo) VALUES (?,?,?,?)")
        .bind(&id)
        .bind(&pessoa_id)
        .bind(&denominacao)
        .bind(&periodo)
        .execute(&*db)
        .await?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_religiao(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "religioes_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_religioes(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Religiao>> {
    Ok(sqlx::query_as::<_, Religiao>(
        "SELECT id, pessoa_id, denominacao, periodo FROM religioes_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// --------------------------------------------------------------- Profissão

#[tauri::command]
pub async fn adicionar_profissao(
    pessoa_id: String,
    ocupacao: String,
    empregador_local: Option<String>,
    periodo: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let ocupacao = texto_obrigatorio("ocupacao", &ocupacao)?;
    let id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO profissoes_pessoa (id, pessoa_id, ocupacao, empregador_local, periodo)
         VALUES (?,?,?,?,?)",
    )
    .bind(&id)
    .bind(&pessoa_id)
    .bind(&ocupacao)
    .bind(&empregador_local)
    .bind(&periodo)
    .execute(&*db)
    .await?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_profissao(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "profissoes_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_profissoes(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Profissao>> {
    Ok(sqlx::query_as::<_, Profissao>(
        "SELECT id, pessoa_id, ocupacao, empregador_local, periodo
         FROM profissoes_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// ----------------------------------------------------------------- Idiomas

#[tauri::command]
pub async fn adicionar_idioma(
    pessoa_id: String,
    idioma: String,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let idioma = texto_obrigatorio("idioma", &idioma)?;
    let id = Uuid::new_v4().to_string();

    sqlx::query("INSERT INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES (?,?,?)")
        .bind(&id)
        .bind(&pessoa_id)
        .bind(&idioma)
        .execute(&*db)
        .await?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_idioma(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "idiomas_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_idiomas(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Idioma>> {
    Ok(sqlx::query_as::<_, Idioma>(
        "SELECT id, pessoa_id, idioma FROM idiomas_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// ------------------------------------------------------------ Escolaridade

#[tauri::command]
pub async fn adicionar_escolaridade(
    pessoa_id: String,
    nivel: String,
    instituicao: Option<String>,
    periodo: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let nivel = texto_obrigatorio("nivel", &nivel)?;
    let id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO escolaridade_pessoa (id, pessoa_id, nivel, instituicao, periodo)
         VALUES (?,?,?,?,?)",
    )
    .bind(&id)
    .bind(&pessoa_id)
    .bind(&nivel)
    .bind(&instituicao)
    .bind(&periodo)
    .execute(&*db)
    .await?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_escolaridade(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "escolaridade_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_escolaridade(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Escolaridade>> {
    Ok(sqlx::query_as::<_, Escolaridade>(
        "SELECT id, pessoa_id, nivel, instituicao, periodo
         FROM escolaridade_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// ----------------------------------------------------------- Nacionalidade

#[tauri::command]
pub async fn adicionar_nacionalidade(
    pessoa_id: String,
    pais_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let id = Uuid::new_v4().to_string();

    sqlx::query("INSERT INTO nacionalidades_pessoa (id, pessoa_id, pais_id) VALUES (?,?,?)")
        .bind(&id)
        .bind(&pessoa_id)
        .bind(&pais_id)
        .execute(&*db)
        .await
        .map_err(|e| {
            // O caso comum é país inexistente — a FK recusa, e o erro cru não
            // ajudaria ninguém.
            if e.to_string().contains("FOREIGN KEY") {
                ErroDominio::ValorInvalido {
                    campo: "pais_id".into(),
                    valor: pais_id.clone(),
                }
            } else {
                ErroDominio::from(e)
            }
        })?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_nacionalidade(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "nacionalidades_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_nacionalidades(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Nacionalidade>> {
    Ok(sqlx::query_as::<_, Nacionalidade>(
        "SELECT id, pessoa_id, pais_id FROM nacionalidades_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// ---------------------------------------------------------------- Apelidos

#[tauri::command]
pub async fn adicionar_apelido(
    pessoa_id: String,
    apelido: String,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    exigir_pessoa(&db, &pessoa_id).await?;
    let apelido = texto_obrigatorio("apelido", &apelido)?;
    let id = Uuid::new_v4().to_string();

    sqlx::query("INSERT INTO apelidos_pessoa (id, pessoa_id, apelido) VALUES (?,?,?)")
        .bind(&id)
        .bind(&pessoa_id)
        .bind(&apelido)
        .execute(&*db)
        .await?;
    Ok(id)
}

#[tauri::command]
pub async fn remover_apelido(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    remover_de(&db, "apelidos_pessoa", &id).await
}

#[tauri::command]
pub async fn listar_apelidos(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Apelido>> {
    Ok(sqlx::query_as::<_, Apelido>(
        "SELECT id, pessoa_id, apelido FROM apelidos_pessoa WHERE pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

// ------------------------------------------------------------------- Países

#[tauri::command]
pub async fn listar_paises(
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<crate::domain::models::Pais>> {
    // Ordem de destaque primeiro (seção 2.4: países de imigração no topo),
    // depois alfabética.
    Ok(sqlx::query_as::<_, crate::domain::models::Pais>(
        "SELECT id, nome, codigo_iso, ordem_destaque FROM paises ORDER BY ordem_destaque, nome",
    )
    .fetch_all(&*db)
    .await?)
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
        sqlx::query("INSERT INTO pessoas (id,nome,sexo,is_vivo,is_placeholder) VALUES ('p1','Ana','F',1,0)")
            .execute(&pool)
            .await
            .unwrap();
        pool
    }

    #[tokio::test]
    async fn atributo_sem_periodo_e_aceito() {
        // Regra transversal: a data nunca é obrigatória para salvar.
        let pool = pool_de_teste().await;
        let id = Uuid::new_v4().to_string();
        let r = sqlx::query(
            "INSERT INTO profissoes_pessoa (id,pessoa_id,ocupacao,empregador_local,periodo)
             VALUES (?,?,?,NULL,NULL)",
        )
        .bind(&id)
        .bind("p1")
        .bind("lavrador")
        .execute(&pool)
        .await;
        assert!(r.is_ok(), "{r:?}");
    }

    #[tokio::test]
    async fn idioma_duplicado_e_recusado_pelo_indice_unico() {
        let pool = pool_de_teste().await;
        for _ in 0..1 {
            sqlx::query("INSERT INTO idiomas_pessoa (id,pessoa_id,idioma) VALUES (?, 'p1','italiano')")
                .bind(Uuid::new_v4().to_string())
                .execute(&pool)
                .await
                .unwrap();
        }
        let segunda = sqlx::query("INSERT INTO idiomas_pessoa (id,pessoa_id,idioma) VALUES (?, 'p1','italiano')")
            .bind(Uuid::new_v4().to_string())
            .execute(&pool)
            .await;
        assert!(segunda.is_err(), "duplicata deveria ser recusada");
    }

    #[tokio::test]
    async fn nacionalidade_exige_pais_existente() {
        let pool = pool_de_teste().await;
        let r = sqlx::query("INSERT INTO nacionalidades_pessoa (id,pessoa_id,pais_id) VALUES (?, 'p1','pais-inventado')")
            .bind(Uuid::new_v4().to_string())
            .execute(&pool)
            .await;
        assert!(r.is_err(), "FK deveria recusar país inexistente");
    }

    #[tokio::test]
    async fn o_seed_de_paises_esta_carregado_e_ordenado() {
        let pool = pool_de_teste().await;
        let total: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM paises")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total > 150, "seed de países parece incompleto: {total}");

        let primeiro: String =
            sqlx::query_scalar("SELECT nome FROM paises ORDER BY ordem_destaque, nome LIMIT 1")
                .fetch_one(&pool)
                .await
                .unwrap();
        assert_eq!(primeiro, "Brasil");
    }
}
