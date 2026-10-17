//! Comandos de Fontes e Citações Históricas (seção 2.7).
//!
//! Permite a genealogistas e pesquisadores gerenciar fontes primárias
//! (certidões civis, registros paroquiais, censos, livros e arquivos) e
//! vincular citações probatórias a pessoas, uniões e eventos.

use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::State;
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Fonte {
    pub id: String,
    pub titulo: String,
    pub tipo: Option<String>,
    pub autor_orgao: Option<String>,
    pub data_publicacao: Option<String>,
    pub repositorio: Option<String>,
    pub referencia: Option<String>,
    pub nota: Option<String>,
    pub data_criacao: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NovaFonte {
    pub titulo: String,
    pub tipo: Option<String>,
    pub autor_orgao: Option<String>,
    pub data_publicacao: Option<String>,
    pub repositorio: Option<String>,
    pub referencia: Option<String>,
    pub nota: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct CitacaoComFonte {
    pub id: String,
    pub fonte_id: String,
    pub alvo_tipo: String,
    pub alvo_id: String,
    pub pagina_folha: Option<String>,
    pub confianca: Option<String>,
    pub transcricao: Option<String>,
    pub nota: Option<String>,
    pub fonte_titulo: String,
    pub fonte_tipo: Option<String>,
    pub fonte_autor_orgao: Option<String>,
    pub fonte_repositorio: Option<String>,
    pub fonte_referencia: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NovaCitacao {
    pub fonte_id: String,
    pub alvo_tipo: String,
    pub alvo_id: String,
    pub pagina_folha: Option<String>,
    pub confianca: Option<String>,
    pub transcricao: Option<String>,
    pub nota: Option<String>,
}

#[tauri::command]
pub async fn listar_fontes(
    pool: State<'_, SqlitePool>,
    busca: Option<String>,
) -> Result<Vec<Fonte>, String> {
    let termo = busca.unwrap_or_default().trim().to_lowercase();
    let query = if termo.is_empty() {
        "SELECT id, titulo, tipo, autor_orgao, data_publicacao, repositorio, referencia, nota, data_criacao FROM fontes ORDER BY titulo COLLATE NOCASE ASC"
    } else {
        "SELECT id, titulo, tipo, autor_orgao, data_publicacao, repositorio, referencia, nota, data_criacao FROM fontes WHERE LOWER(titulo) LIKE ? OR LOWER(repositorio) LIKE ? OR LOWER(referencia) LIKE ? ORDER BY titulo COLLATE NOCASE ASC"
    };

    let fontes = if termo.is_empty() {
        sqlx::query_as::<_, Fonte>(query).fetch_all(&*pool).await
    } else {
        let pat = format!("%{termo}%");
        sqlx::query_as::<_, Fonte>(query)
            .bind(&pat)
            .bind(&pat)
            .bind(&pat)
            .fetch_all(&*pool)
            .await
    }
    .map_err(|e| e.to_string())?;

    Ok(fontes)
}

#[tauri::command]
pub async fn obter_fonte(
    pool: State<'_, SqlitePool>,
    id: String,
) -> Result<Fonte, String> {
    sqlx::query_as::<_, Fonte>(
        "SELECT id, titulo, tipo, autor_orgao, data_publicacao, repositorio, referencia, nota, data_criacao FROM fontes WHERE id = ?"
    )
    .bind(&id)
    .fetch_optional(&*pool)
    .await
    .map_err(|e| e.to_string())?
    .ok_or_else(|| format!("Fonte não encontrada: {id}"))
}

#[tauri::command]
pub async fn criar_fonte(
    pool: State<'_, SqlitePool>,
    dados: NovaFonte,
) -> Result<Fonte, String> {
    let titulo = dados.titulo.trim();
    if titulo.is_empty() {
        return Err("O título da fonte é obrigatório.".into());
    }
    let id = format!("fnt-{}", Uuid::new_v4().simple());
    sqlx::query(
        "INSERT INTO fontes (id, titulo, tipo, autor_orgao, data_publicacao, repositorio, referencia, nota) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(titulo)
    .bind(&dados.tipo)
    .bind(&dados.autor_orgao)
    .bind(&dados.data_publicacao)
    .bind(&dados.repositorio)
    .bind(&dados.referencia)
    .bind(&dados.nota)
    .execute(&*pool)
    .await
    .map_err(|e| e.to_string())?;

    obter_fonte(pool, id).await
}

#[tauri::command]
pub async fn atualizar_fonte(
    pool: State<'_, SqlitePool>,
    id: String,
    dados: NovaFonte,
) -> Result<Fonte, String> {
    let titulo = dados.titulo.trim();
    if titulo.is_empty() {
        return Err("O título da fonte é obrigatório.".into());
    }
    sqlx::query(
        "UPDATE fontes SET titulo = ?, tipo = ?, autor_orgao = ?, data_publicacao = ?, repositorio = ?, referencia = ?, nota = ? WHERE id = ?"
    )
    .bind(titulo)
    .bind(&dados.tipo)
    .bind(&dados.autor_orgao)
    .bind(&dados.data_publicacao)
    .bind(&dados.repositorio)
    .bind(&dados.referencia)
    .bind(&dados.nota)
    .bind(&id)
    .execute(&*pool)
    .await
    .map_err(|e| e.to_string())?;

    obter_fonte(pool, id).await
}

#[tauri::command]
pub async fn remover_fonte(
    pool: State<'_, SqlitePool>,
    id: String,
) -> Result<(), String> {
    sqlx::query("DELETE FROM fontes WHERE id = ?")
        .bind(&id)
        .execute(&*pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
pub async fn listar_citacoes_do_alvo(
    pool: State<'_, SqlitePool>,
    alvo_tipo: String,
    alvo_id: String,
) -> Result<Vec<CitacaoComFonte>, String> {
    let query = "
        SELECT 
            c.id, c.fonte_id, c.alvo_tipo, c.alvo_id, c.pagina_folha, c.confianca, c.transcricao, c.nota,
            f.titulo AS fonte_titulo, f.tipo AS fonte_tipo, f.autor_orgao AS fonte_autor_orgao,
            f.repositorio AS fonte_repositorio, f.referencia AS fonte_referencia
        FROM citacoes c
        JOIN fontes f ON f.id = c.fonte_id
        WHERE c.alvo_tipo = ? AND c.alvo_id = ?
        ORDER BY f.titulo COLLATE NOCASE ASC
    ";

    let citacoes = sqlx::query_as::<_, CitacaoComFonte>(query)
        .bind(&alvo_tipo)
        .bind(&alvo_id)
        .fetch_all(&*pool)
        .await
        .map_err(|e| e.to_string())?;

    Ok(citacoes)
}

#[tauri::command]
pub async fn criar_citacao(
    pool: State<'_, SqlitePool>,
    dados: NovaCitacao,
) -> Result<CitacaoComFonte, String> {
    let id = format!("cit-{}", Uuid::new_v4().simple());
    sqlx::query(
        "INSERT INTO citacoes (id, fonte_id, alvo_tipo, alvo_id, pagina_folha, confianca, transcricao, nota) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&dados.fonte_id)
    .bind(&dados.alvo_tipo)
    .bind(&dados.alvo_id)
    .bind(&dados.pagina_folha)
    .bind(&dados.confianca)
    .bind(&dados.transcricao)
    .bind(&dados.nota)
    .execute(&*pool)
    .await
    .map_err(|e| e.to_string())?;

    let query = "
        SELECT 
            c.id, c.fonte_id, c.alvo_tipo, c.alvo_id, c.pagina_folha, c.confianca, c.transcricao, c.nota,
            f.titulo AS fonte_titulo, f.tipo AS fonte_tipo, f.autor_orgao AS fonte_autor_orgao,
            f.repositorio AS fonte_repositorio, f.referencia AS fonte_referencia
        FROM citacoes c
        JOIN fontes f ON f.id = c.fonte_id
        WHERE c.id = ?
    ";

    sqlx::query_as::<_, CitacaoComFonte>(query)
        .bind(&id)
        .fetch_optional(&*pool)
        .await
        .map_err(|e| e.to_string())?
        .ok_or_else(|| "Erro ao carregar citação recém-criada.".into())
}

#[tauri::command]
pub async fn remover_citacao(
    pool: State<'_, SqlitePool>,
    id: String,
) -> Result<(), String> {
    sqlx::query("DELETE FROM citacoes WHERE id = ?")
        .bind(&id)
        .execute(&*pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}
