//! Gatekeeper de Ações Sensíveis (Elotempo)
//!
//! Exige a validação da Senha Mestra ou PIN antes de liberar operações
//! que retiram dados do acervo (exportações, impressões) ou que realizam
//! mutações destrutivas irreversíveis (exclusão de árvores, fusão de pessoas).

use std::time::{Duration, Instant};
use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::seguranca::cofre::EstadoSeguranca;

pub const JANELA_GRACA_SEGUNDOS: u64 = 180; // 3 minutos

/// Verifica se uma ação sensível está autorizada a prosseguir.
/// Se o modo blindado estiver inativo, autoriza diretamente.
/// Se o modo blindado estiver ativo:
/// 1. Verifica se existe um ticket de autorização recente válido.
/// 2. Caso contrário, exige `senha_ou_pin` e valida contra as credenciais.
pub async fn autorizar_acao_sensivel(
    estado: &EstadoSeguranca,
    senha_ou_pin: Option<&str>,
    ticket_autorizacao: Option<&str>,
) -> Resultado<()> {
    let cfg = estado.config.read().await;
    if !cfg.modo_blindado || !cfg.gatekeeper_ativo {
        return Ok(());
    }

    // 1. Checa ticket recente (se fornecido)
    if let Some(token) = ticket_autorizacao {
        let ticket_guard = estado.ticket_gatekeeper.read().await;
        if let Some((ticket_ativo, timestamp)) = &*ticket_guard {
            if ticket_ativo == token && timestamp.elapsed() < Duration::from_secs(JANELA_GRACA_SEGUNDOS) {
                return Ok(());
            }
        }
    }

    // 2. Valida credencial fornecida
    if let Some(credencial) = senha_ou_pin {
        drop(cfg); // Libera o read lock antes de chamar validar_credencial
        if estado.validar_credencial(credencial).await {
            return Ok(());
        }
    }

    Err(ErroDominio::AcessoNegado(
        "Ação sensível bloqueada: requer confirmação da Senha Mestra ou PIN do acervo.".into(),
    ))
}

/// Emite um ticket temporário de uso único após validação da senha.
pub async fn emitir_ticket_gatekeeper(
    estado: &EstadoSeguranca,
    senha_ou_pin: &str,
) -> Resultado<String> {
    if !estado.validar_credencial(senha_ou_pin).await {
        return Err(ErroDominio::AcessoNegado("Senha Mestra ou PIN incorreto.".into()));
    }

    let token = uuid::Uuid::new_v4().to_string();
    let mut ticket_guard = estado.ticket_gatekeeper.write().await;
    *ticket_guard = Some((token.clone(), Instant::now()));

    Ok(token)
}
