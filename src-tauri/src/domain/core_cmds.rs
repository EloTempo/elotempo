//! Comandos Tauri do núcleo genealógico.
//!
//! São cascas finas: validação e regra moram em `regras.rs`, que não depende do
//! Tauri e por isso pode ser testado contra um banco em memória. O que sobra
//! aqui é traduzir argumentos e devolver o erro tipado ao frontend.
//!
//! Os `id` são gerados no Rust, não no frontend. Um identificador estável é
//! responsabilidade de quem guarda o dado.

use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::State;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::Pessoa;
use crate::domain::regras::{self, NovaPessoa};

#[derive(Debug, Deserialize)]
pub struct NovaPessoaDto {
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub minibiografia: Option<String>,
    pub is_vivo: bool,
    pub foto_url: Option<String>,
}

#[tauri::command]
pub async fn criar_pessoa(
    nova: NovaPessoaDto,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    regras::criar_pessoa(
        &db,
        NovaPessoa {
            nome: nova.nome,
            sobrenome: nova.sobrenome,
            sexo: nova.sexo,
            minibiografia: nova.minibiografia,
            is_vivo: nova.is_vivo,
            foto_url: nova.foto_url,
        },
    )
    .await
}

#[tauri::command]
pub async fn obter_pessoa(id: String, db: State<'_, SqlitePool>) -> Resultado<Pessoa> {
    regras::buscar_pessoa(&db, &id).await
}

/// Pais, cônjuges e filhos de uma pessoa — o que o painel de conexões mostra.
#[tauri::command]
pub async fn obter_conexoes_pessoa(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<regras::ConexoesPessoa> {
    regras::buscar_conexoes(&db, &pessoa_id).await
}

#[tauri::command]
pub async fn atualizar_pessoa(pessoa: Pessoa, db: State<'_, SqlitePool>) -> Resultado<()> {
    regras::atualizar_pessoa(&db, &pessoa).await
}

#[tauri::command]
pub async fn remover_pessoa(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    regras::remover_pessoa(&db, &id).await
}

/// Promove um placeholder a pessoa real, preservando os filhos já ligados.
#[tauri::command]
pub async fn promover_placeholder(
    pessoa_id: String,
    nome: String,
    sobrenome: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    regras::promover_placeholder(&db, &pessoa_id, &nome, sobrenome.as_deref()).await
}

/// Cria a união. Passar `null` num slot faz o backend criar o placeholder —
/// é assim que se cadastra um filho conhecendo só um dos pais.
#[tauri::command]
pub async fn criar_uniao(
    slot_masculino_id: Option<String>,
    slot_feminino_id: Option<String>,
    estado_vinculo: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    let estado = estado_vinculo.unwrap_or_else(|| "nao_informado".to_string());
    regras::criar_uniao(
        &db,
        slot_masculino_id.as_deref(),
        slot_feminino_id.as_deref(),
        &estado,
    )
    .await
}

#[derive(Debug, Serialize, Deserialize)]
pub struct AtualizacaoUniao {
    pub id: String,
    pub estado_vinculo: String,
    pub nota: Option<String>,
}

#[tauri::command]
pub async fn atualizar_uniao(
    uniao: AtualizacaoUniao,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let afetadas = sqlx::query("UPDATE unioes SET estado_vinculo = ?, nota = ? WHERE id = ?")
        .bind(&uniao.estado_vinculo)
        .bind(&uniao.nota)
        .bind(&uniao.id)
        .execute(&*db)
        .await?
        .rows_affected();

    if afetadas == 0 {
        return Err(ErroDominio::UniaoNaoEncontrada(uniao.id));
    }
    Ok(())
}

/// Remove a união. Os vínculos de filho caem junto (ON DELETE CASCADE), mas as
/// pessoas permanecem — inclusive os placeholders, que ficam órfãos de
/// propósito: apagá-los aqui poderia levar embora um ancestral real que alguém
/// tinha acabado de promover.
#[tauri::command]
pub async fn remover_uniao(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    let afetadas = sqlx::query("DELETE FROM unioes WHERE id = ?")
        .bind(&id)
        .execute(&*db)
        .await?
        .rows_affected();

    if afetadas == 0 {
        return Err(ErroDominio::UniaoNaoEncontrada(id));
    }
    Ok(())
}

#[tauri::command]
pub async fn anexar_filho(
    uniao_id: String,
    pessoa_id: String,
    tipo_vinculo: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let tipo = tipo_vinculo.unwrap_or_else(|| "biologico".to_string());
    regras::anexar_filho(&db, &uniao_id, &pessoa_id, &tipo).await
}

#[tauri::command]
pub async fn desvincular_filho(pessoa_id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    regras::desvincular_filho(&db, &pessoa_id).await
}
