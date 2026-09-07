//! Marcadores e Anotações da Linha do Tempo (Fatia Estúdio / NLE Markers).
//!
//! Permite ao usuário fixar marcos de interesse com anotações/comentários e cores,
//! que funcionam como pontos magnéticos de Snap na timeline.

use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use tauri::State;

use crate::domain::erros::{ErroDominio, Resultado};

#[derive(Debug, Clone, Serialize, Deserialize, FromRow, PartialEq)]
pub struct MarcadorLinhaTempo {
    pub id: String,
    pub ano: i64,
    pub titulo: String,
    pub comentario: Option<String>,
    pub cor: String,
    pub arvore_id: Option<String>,
    pub criado_em: String,
}

#[derive(Debug, Deserialize, Default)]
pub struct NovoMarcadorInput {
    pub ano: i64,
    pub titulo: String,
    pub comentario: Option<String>,
    pub cor: Option<String>,
    pub arvore_id: Option<String>,
}

#[derive(Debug, Deserialize, Default)]
pub struct EdicaoMarcadorInput {
    pub id: String,
    pub ano: i64,
    pub titulo: String,
    pub comentario: Option<String>,
    pub cor: Option<String>,
}

#[tauri::command]
pub async fn listar_marcadores(
    db: State<'_, SqlitePool>,
    arvore_id: Option<String>,
) -> Resultado<Vec<MarcadorLinhaTempo>> {
    let marcadores = match arvore_id {
        Some(aid) => {
            sqlx::query_as::<_, MarcadorLinhaTempo>(
                r#"
                SELECT id, ano, titulo, comentario, cor, arvore_id, criado_em
                FROM marcadores_linha_tempo
                WHERE arvore_id = ? OR arvore_id IS NULL
                ORDER BY ano ASC, criado_em ASC
                "#,
            )
            .bind(aid)
            .fetch_all(&*db)
            .await?
        }
        None => {
            sqlx::query_as::<_, MarcadorLinhaTempo>(
                r#"
                SELECT id, ano, titulo, comentario, cor, arvore_id, criado_em
                FROM marcadores_linha_tempo
                ORDER BY ano ASC, criado_em ASC
                "#,
            )
            .fetch_all(&*db)
            .await?
        }
    };

    Ok(marcadores)
}

#[tauri::command]
pub async fn criar_marcador(
    novo: NovoMarcadorInput,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    let titulo = novo.titulo.trim();
    if titulo.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "titulo".into(),
            valor: "vazio".into(),
        });
    }

    let id = uuid::Uuid::new_v4().to_string();
    let cor = novo.cor.unwrap_or_else(|| "azul".into());

    sqlx::query(
        r#"
        INSERT INTO marcadores_linha_tempo (id, ano, titulo, comentario, cor, arvore_id)
        VALUES (?, ?, ?, ?, ?, ?)
        "#,
    )
    .bind(&id)
    .bind(novo.ano)
    .bind(titulo)
    .bind(novo.comentario.as_deref())
    .bind(&cor)
    .bind(novo.arvore_id.as_deref())
    .execute(&*db)
    .await?;

    Ok(id)
}

#[tauri::command]
pub async fn atualizar_marcador(
    edicao: EdicaoMarcadorInput,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let titulo = edicao.titulo.trim();
    if titulo.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "titulo".into(),
            valor: "vazio".into(),
        });
    }

    let cor = edicao.cor.unwrap_or_else(|| "azul".into());

    sqlx::query(
        r#"
        UPDATE marcadores_linha_tempo
        SET ano = ?, titulo = ?, comentario = ?, cor = ?
        WHERE id = ?
        "#,
    )
    .bind(edicao.ano)
    .bind(titulo)
    .bind(edicao.comentario.as_deref())
    .bind(&cor)
    .bind(&edicao.id)
    .execute(&*db)
    .await?;

    Ok(())
}

#[tauri::command]
pub async fn deletar_marcador(
    id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    sqlx::query("DELETE FROM marcadores_linha_tempo WHERE id = ?")
        .bind(&id)
        .execute(&*db)
        .await?;

    Ok(())
}
