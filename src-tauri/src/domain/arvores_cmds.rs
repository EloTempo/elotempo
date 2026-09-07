//! Múltiplas árvores nomeadas e conexões entre elas (Fatia 12, Seção 5 da Especificação).
//!
//! Uma árvore é uma visão nomeada e enraizada do grafo familiar comum.
//! Apagar uma árvore nunca apaga pessoas ou uniões do acervo.

use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use tauri::State;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::default_tipo_tempo;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow, PartialEq)]
pub struct ArvoreInfo {
    pub id: String,
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    pub raiz_pessoa_nome: Option<String>,
    pub total_membros: i64,
    pub data_criacao: Option<String>,
    pub data_modificacao: Option<String>,
    #[serde(default)]
    pub is_publico: bool,
    pub categoria: Option<String>,
    pub pais: Option<String>,
    pub periodo: Option<String>,
    #[serde(default = "default_tipo_tempo")]
    pub tipo_tempo: String,
}

#[derive(Debug, Deserialize, Default)]
pub struct NovaArvoreInput {
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    #[serde(default)]
    pub categoria: Option<String>,
    #[serde(default)]
    pub pais: Option<String>,
    #[serde(default)]
    pub periodo: Option<String>,
    #[serde(default)]
    pub tipo_tempo: Option<String>,
}

#[derive(Debug, Deserialize, Default)]
pub struct AtualizarArvoreInput {
    pub id: String,
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    #[serde(default)]
    pub categoria: Option<String>,
    #[serde(default)]
    pub pais: Option<String>,
    #[serde(default)]
    pub periodo: Option<String>,
    #[serde(default)]
    pub tipo_tempo: Option<String>,
}

/// Garante que haja pelo menos uma árvore no banco se o acervo estiver iniciado.
pub async fn garantir_arvore_padrao(pool: &SqlitePool) -> Resultado<()> {
    let contagem: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM arvores")
        .fetch_one(pool)
        .await?;

    if contagem.0 == 0 {
        // Encontra a primeira pessoa não placeholder para servir de raiz, se houver
        let primeira: Option<(String,)> = sqlx::query_as(
            "SELECT id FROM pessoas WHERE is_placeholder = 0 ORDER BY data_criacao ASC LIMIT 1",
        )
        .fetch_optional(pool)
        .await?;

        let arvore_id = uuid::Uuid::new_v4().to_string();
        let raiz_id = primeira.map(|p| p.0);

        sqlx::query(
            "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id)
             VALUES (?, 'Árvore Principal', 'Árvore genealógica principal do acervo', ?)",
        )
        .bind(&arvore_id)
        .bind(&raiz_id)
        .execute(pool)
        .await?;

        if let Some(ref rid) = raiz_id {
            let _ = sqlx::query(
                "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
                 VALUES (?, ?, NULL)",
            )
            .bind(&arvore_id)
            .bind(rid)
            .execute(pool)
            .await;
        }
    }

    Ok(())
}

#[tauri::command]
pub async fn listar_arvores(db: State<'_, SqlitePool>) -> Resultado<Vec<ArvoreInfo>> {
    listar(&db).await
}

pub async fn listar(pool: &SqlitePool) -> Resultado<Vec<ArvoreInfo>> {
    garantir_arvore_padrao(pool).await?;

    let sql = r#"
        SELECT
            a.id,
            a.nome,
            a.descricao,
            a.raiz_pessoa_id,
            CASE
                WHEN p.id IS NOT NULL THEN p.nome || ' ' || COALESCE(p.sobrenome, '')
                ELSE NULL
            END AS raiz_pessoa_nome,
            (SELECT COUNT(DISTINCT am.pessoa_id) FROM arvore_membros am WHERE am.arvore_id = a.id) AS total_membros,
            strftime('%Y-%m-%d %H:%M:%S', a.data_criacao) AS data_criacao,
            strftime('%Y-%m-%d %H:%M:%S', a.data_modificacao) AS data_modificacao,
            a.is_publico,
            a.categoria,
            a.pais,
            a.periodo,
            a.tipo_tempo
        FROM arvores a
        LEFT JOIN pessoas p ON p.id = a.raiz_pessoa_id
        ORDER BY a.is_publico ASC, a.data_criacao ASC
    "#;

    let arvores = sqlx::query_as::<sqlx::Sqlite, ArvoreInfo>(sql)
        .fetch_all(pool)
        .await?;

    Ok(arvores)
}

#[tauri::command]
pub async fn obter_arvore(id: String, db: State<'_, SqlitePool>) -> Resultado<ArvoreInfo> {
    obter(&db, &id).await
}

pub async fn obter(pool: &SqlitePool, id: &str) -> Resultado<ArvoreInfo> {
    let sql = r#"
        SELECT
            a.id,
            a.nome,
            a.descricao,
            a.raiz_pessoa_id,
            CASE
                WHEN p.id IS NOT NULL THEN p.nome || ' ' || COALESCE(p.sobrenome, '')
                ELSE NULL
            END AS raiz_pessoa_nome,
            (SELECT COUNT(DISTINCT am.pessoa_id) FROM arvore_membros am WHERE am.arvore_id = a.id) AS total_membros,
            strftime('%Y-%m-%d %H:%M:%S', a.data_criacao) AS data_criacao,
            strftime('%Y-%m-%d %H:%M:%S', a.data_modificacao) AS data_modificacao,
            a.is_publico,
            a.categoria,
            a.pais,
            a.periodo,
            a.tipo_tempo
        FROM arvores a
        LEFT JOIN pessoas p ON p.id = a.raiz_pessoa_id
        WHERE a.id = ?
    "#;

    let arvore = sqlx::query_as::<sqlx::Sqlite, ArvoreInfo>(sql)
        .bind(id)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| ErroDominio::ArvoreNaoEncontrada(id.to_string()))?;

    Ok(arvore)
}

#[tauri::command]
pub async fn criar_arvore(
    dados: NovaArvoreInput,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    criar(&db, dados).await
}

pub async fn criar(pool: &SqlitePool, dados: NovaArvoreInput) -> Resultado<ArvoreInfo> {
    let nome = dados.nome.trim();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: "O nome da árvore não pode ser vazio.".into(),
        });
    }

    let id = uuid::Uuid::new_v4().to_string();

    // Se informou raiz, confere se a pessoa existe
    if let Some(ref rid) = dados.raiz_pessoa_id {
        let existe: Option<(String,)> =
            sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
                .bind(rid)
                .fetch_optional(pool)
                .await?;
        if existe.is_none() {
            return Err(ErroDominio::PessoaNaoEncontrada(rid.clone()));
        }
    }

    let tipo_tempo = dados.tipo_tempo.as_deref().unwrap_or("real");

    sqlx::query(
        "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, categoria, pais, periodo, tipo_tempo)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(&id)
    .bind(nome)
    .bind(&dados.descricao)
    .bind(&dados.raiz_pessoa_id)
    .bind(&dados.categoria)
    .bind(&dados.pais)
    .bind(&dados.periodo)
    .bind(tipo_tempo)
    .execute(pool)
    .await?;

    if let Some(ref rid) = dados.raiz_pessoa_id {
        let _ = sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES (?, ?, NULL)",
        )
        .bind(&id)
        .bind(rid)
        .execute(pool)
        .await;
    }

    obter(pool, &id).await
}

#[tauri::command]
pub async fn atualizar_arvore(
    dados: AtualizarArvoreInput,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    atualizar(&db, dados).await
}

pub async fn atualizar(pool: &SqlitePool, dados: AtualizarArvoreInput) -> Resultado<ArvoreInfo> {
    let nome = dados.nome.trim();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: "O nome da árvore não pode ser vazio.".into(),
        });
    }

    // Confere se a árvore existe
    let atual = obter(pool, &dados.id).await?;
    let tipo_tempo = dados.tipo_tempo.as_deref().unwrap_or(&atual.tipo_tempo);

    // Se alterou raiz, confere se a nova raiz existe
    if let Some(ref rid) = dados.raiz_pessoa_id {
        let existe: Option<(String,)> =
            sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
                .bind(rid)
                .fetch_optional(pool)
                .await?;
        if existe.is_none() {
            return Err(ErroDominio::PessoaNaoEncontrada(rid.clone()));
        }
    }

    sqlx::query(
        "UPDATE arvores
         SET nome = ?, descricao = ?, raiz_pessoa_id = ?, categoria = ?, pais = ?, periodo = ?, tipo_tempo = ?, data_modificacao = CURRENT_TIMESTAMP
         WHERE id = ?",
    )
    .bind(nome)
    .bind(&dados.descricao)
    .bind(&dados.raiz_pessoa_id)
    .bind(&dados.categoria)
    .bind(&dados.pais)
    .bind(&dados.periodo)
    .bind(tipo_tempo)
    .bind(&dados.id)
    .execute(pool)
    .await?;

    if let Some(ref rid) = dados.raiz_pessoa_id {
        let _ = sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES (?, ?, NULL)",
        )
        .bind(&dados.id)
        .bind(rid)
        .execute(pool)
        .await;
    }

    obter(pool, &dados.id).await
}

#[tauri::command]
pub async fn deletar_arvore(
    id: String,
    ticket_autorizacao: Option<String>,
    db: State<'_, SqlitePool>,
    seguranca: State<'_, crate::domain::seguranca::EstadoSeguranca>,
) -> Resultado<()> {
    crate::domain::seguranca::autorizar_acao_sensivel(&seguranca, None, ticket_autorizacao.as_deref()).await?;
    deletar(&db, &id).await
}

pub async fn deletar(pool: &SqlitePool, id: &str) -> Resultado<()> {
    // Impede exclusão de árvores públicas de referência
    let arvore = obter(pool, id).await?;
    if arvore.is_publico {
        return Err(ErroDominio::ValorInvalido {
            campo: "arvore".into(),
            valor: "Árvores históricas de referência pública não podem ser excluídas.".into(),
        });
    }

    // Não permite apagar a única árvore do acervo
    let contagem: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM arvores")
        .fetch_one(pool)
        .await?;

    if contagem.0 <= 1 {
        return Err(ErroDominio::ValorInvalido {
            campo: "arvore".into(),
            valor: "Não é possível excluir a única árvore do acervo.".into(),
        });
    }

    let resultado = sqlx::query("DELETE FROM arvores WHERE id = ?")
        .bind(id)
        .execute(pool)
        .await?;

    if resultado.rows_affected() == 0 {
        return Err(ErroDominio::ArvoreNaoEncontrada(id.to_string()));
    }

    Ok(())
}

#[tauri::command]
pub async fn definir_raiz_arvore(
    arvore_id: String,
    raiz_pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    definir_raiz(&db, &arvore_id, &raiz_pessoa_id).await
}

pub async fn definir_raiz(
    pool: &SqlitePool,
    arvore_id: &str,
    raiz_pessoa_id: &str,
) -> Resultado<ArvoreInfo> {
    // Confere se a pessoa existe
    let pessoa_existe: Option<(String,)> =
        sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
            .bind(raiz_pessoa_id)
            .fetch_optional(pool)
            .await?;
    if pessoa_existe.is_none() {
        return Err(ErroDominio::PessoaNaoEncontrada(raiz_pessoa_id.to_string()));
    }

    // Confere se a árvore existe
    let _ = obter(pool, arvore_id).await?;

    sqlx::query(
        "UPDATE arvores
         SET raiz_pessoa_id = ?, data_modificacao = CURRENT_TIMESTAMP
         WHERE id = ?",
    )
    .bind(raiz_pessoa_id)
    .bind(arvore_id)
    .execute(pool)
    .await?;

    let _ = sqlx::query(
        "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
         VALUES (?, ?, NULL)",
    )
    .bind(arvore_id)
    .bind(raiz_pessoa_id)
    .execute(pool)
    .await;

    obter(pool, arvore_id).await
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
    async fn cria_arvore_padrao_se_nenhuma_existir() {
        let pool = pool_de_teste().await;
        let lista = listar(&pool).await.unwrap();
        assert_eq!(lista.len(), 1);
        assert_eq!(lista[0].nome, "Árvore Principal");
    }

    #[tokio::test]
    async fn cria_e_atualiza_arvore_nomeada() {
        let pool = pool_de_teste().await;

        // Inserir pessoa para ser raiz
        let p_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Joaquim', 'Albuquerque', 'M', 1, 0)",
        )
        .bind(&p_id)
        .execute(&pool)
        .await
        .unwrap();

        let nova = criar(
            &pool,
            NovaArvoreInput {
                nome: "Família Albuquerque".into(),
                descricao: Some("Ramo materno".into()),
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(nova.nome, "Família Albuquerque");
        assert_eq!(nova.descricao.as_deref(), Some("Ramo materno"));
        assert_eq!(nova.raiz_pessoa_id.as_deref(), Some(p_id.as_str()));
        assert_eq!(nova.raiz_pessoa_nome.as_deref(), Some("Joaquim Albuquerque"));

        // Atualizar
        let editada = atualizar(
            &pool,
            AtualizarArvoreInput {
                id: nova.id.clone(),
                nome: "Família Albuquerque e Silva".into(),
                descricao: Some("Ramo atualizado".into()),
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(editada.nome, "Família Albuquerque e Silva");
        assert_eq!(editada.descricao.as_deref(), Some("Ramo atualizado"));
    }

    #[tokio::test]
    async fn recusar_apagar_unica_arvore() {
        let pool = pool_de_teste().await;
        let lista = listar(&pool).await.unwrap();
        assert_eq!(lista.len(), 1);

        let res = deletar(&pool, &lista[0].id).await;
        assert!(res.is_err());
    }

    #[tokio::test]
    async fn apagar_arvore_nao_apaga_as_pessoas() {
        let pool = pool_de_teste().await;

        // Inserir pessoa
        let p_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Teresa', 'Cristina', 'F', 0, 0)",
        )
        .bind(&p_id)
        .execute(&pool)
        .await
        .unwrap();

        garantir_arvore_padrao(&pool).await.unwrap();

        // Criar segunda árvore
        let a2 = criar(
            &pool,
            NovaArvoreInput {
                nome: "Árvore Imperial".into(),
                descricao: None,
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(listar(&pool).await.unwrap().len(), 2);

        // Deletar a2
        deletar(&pool, &a2.id).await.unwrap();
        assert_eq!(listar(&pool).await.unwrap().len(), 1);

        // A pessoa continua viva e salva no banco de dados!
        let pessoa_continua: Option<(String,)> =
            sqlx::query_as("SELECT nome FROM pessoas WHERE id = ?")
                .bind(&p_id)
                .fetch_optional(&pool)
                .await
                .unwrap();
        assert_eq!(pessoa_continua.unwrap().0, "Teresa");
    }
}
