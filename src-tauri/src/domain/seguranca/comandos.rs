//! Comandos IPC do Tauri para o Sistema de Segurança e Modo Híbrido

use std::path::PathBuf;
use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::{AppHandle, Manager, State};

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::seguranca::cofre::{carregar_config_seguranca, salvar_config_seguranca, EstadoSeguranca};
use crate::domain::seguranca::criptografia::{
    gerar_frase_recuperacao, hashear_senha, validar_frase_recuperacao,
    verificar_senha,
};
use crate::domain::seguranca::gatekeeper::emitir_ticket_gatekeeper;
use crate::domain::seguranca::migracao::{
    migrar_para_modo_blindado, reverter_para_modo_aberto, ResumoMigracao,
};

#[derive(Debug, Serialize, Deserialize)]
pub struct StatusSegurancaDto {
    pub modo_blindado: bool,
    pub bloqueado: bool,
    pub tem_pin: bool,
    pub data_ativacao: Option<String>,
    pub gatekeeper_ativo: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ChaveRecuperacaoDto {
    pub palavras: String,
}

fn obter_pasta_dados(app: &AppHandle) -> Resultado<PathBuf> {
    app.path()
        .app_data_dir()
        .map_err(|e| ErroDominio::Persistencia(format!("Pasta de dados do app inacessível: {e}")))
}

#[tauri::command]
pub async fn obter_status_seguranca(
    estado: State<'_, EstadoSeguranca>,
) -> Result<StatusSegurancaDto, ErroDominio> {
    let cfg = estado.config.read().await;
    let desb = *estado.desbloqueado.read().await;

    Ok(StatusSegurancaDto {
        modo_blindado: cfg.modo_blindado,
        bloqueado: cfg.modo_blindado && !desb,
        tem_pin: cfg.hash_pin.is_some(),
        data_ativacao: cfg.data_ativacao.clone(),
        gatekeeper_ativo: cfg.gatekeeper_ativo,
    })
}

#[tauri::command]
pub fn gerar_chave_recuperacao() -> Result<ChaveRecuperacaoDto, ErroDominio> {
    let (palavras, _) = gerar_frase_recuperacao();
    Ok(ChaveRecuperacaoDto { palavras })
}

#[tauri::command]
pub async fn ativar_modo_blindado(
    senha_mestra: String,
    pin: Option<String>,
    chave_recuperacao: String,
    app: AppHandle,
    pool: State<'_, SqlitePool>,
    estado: State<'_, EstadoSeguranca>,
) -> Result<ResumoMigracao, ErroDominio> {
    if senha_mestra.trim().len() < 6 {
        return Err(ErroDominio::Validacao(
            "A Senha Mestra deve possuir no mínimo 6 caracteres.".into(),
        ));
    }

    // Valida previamente a chave de 24 palavras
    validar_frase_recuperacao(&chave_recuperacao)?;

    let pasta_dados = obter_pasta_dados(&app)?;
    let resumo = migrar_para_modo_blindado(
        &pasta_dados,
        &pool,
        &senha_mestra,
        pin.as_deref(),
        &chave_recuperacao,
    )
    .await?;

    // Atualiza estado em memória
    let nova_cfg = carregar_config_seguranca(&pasta_dados);
    {
        let mut cfg = estado.config.write().await;
        *cfg = nova_cfg.clone();
    }
    {
        let mut desb = estado.desbloqueado.write().await;
        *desb = true;
    }

    Ok(resumo)
}

#[tauri::command]
pub async fn desativar_modo_blindado(
    senha_confirmacao: String,
    app: AppHandle,
    estado: State<'_, EstadoSeguranca>,
) -> Result<(), ErroDominio> {
    let pasta_dados = obter_pasta_dados(&app)?;
    let cfg = estado.config.read().await.clone();

    reverter_para_modo_aberto(&pasta_dados, &senha_confirmacao, &cfg).await?;

    let nova_cfg = carregar_config_seguranca(&pasta_dados);
    {
        let mut c = estado.config.write().await;
        *c = nova_cfg;
    }
    {
        let mut desb = estado.desbloqueado.write().await;
        *desb = true;
    }

    Ok(())
}

#[tauri::command]
pub async fn desbloquear_acervo(
    senha_ou_pin: String,
    estado: State<'_, EstadoSeguranca>,
) -> Result<(), ErroDominio> {
    if !estado.validar_credencial(&senha_ou_pin).await {
        return Err(ErroDominio::AcessoNegado(
            "Senha Mestra ou PIN incorreto.".into(),
        ));
    }

    let mut desb = estado.desbloqueado.write().await;
    *desb = true;

    Ok(())
}

#[tauri::command]
pub async fn bloquear_acervo(
    estado: State<'_, EstadoSeguranca>,
) -> Result<(), ErroDominio> {
    estado.bloquear().await;
    Ok(())
}

#[tauri::command]
pub async fn validar_senha_gatekeeper(
    senha_ou_pin: String,
    estado: State<'_, EstadoSeguranca>,
) -> Result<String, ErroDominio> {
    emitir_ticket_gatekeeper(&estado, &senha_ou_pin).await
}

#[tauri::command]
pub async fn recuperar_acervo_com_chave(
    chave_recuperacao: String,
    nova_senha: String,
    app: AppHandle,
    estado: State<'_, EstadoSeguranca>,
) -> Result<(), ErroDominio> {
    if nova_senha.trim().len() < 6 {
        return Err(ErroDominio::Validacao(
            "A nova Senha Mestra deve possuir no mínimo 6 caracteres.".into(),
        ));
    }

    validar_frase_recuperacao(&chave_recuperacao)?;

    let pasta_dados = obter_pasta_dados(&app)?;
    let mut cfg = estado.config.read().await.clone();

    let hash_armazenado = cfg
        .chave_recuperacao_hash
        .as_ref()
        .ok_or_else(|| ErroDominio::Validacao("Nenhuma chave de recuperação cadastrada.".into()))?;

    if !verificar_senha(&chave_recuperacao.trim().to_lowercase(), hash_armazenado) {
        return Err(ErroDominio::AcessoNegado(
            "Chave de Recuperação incorreta.".into(),
        ));
    }

    // Atualiza a senha mestra
    cfg.hash_senha_mestra = Some(hashear_senha(&nova_senha)?);
    cfg.hash_pin = None; // Invalida PIN anterior para segurança

    salvar_config_seguranca(&pasta_dados, &cfg)?;

    {
        let mut c = estado.config.write().await;
        *c = cfg;
    }
    {
        let mut desb = estado.desbloqueado.write().await;
        *desb = true;
    }

    Ok(())
}
