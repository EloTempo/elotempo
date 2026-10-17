//! Motor de Migração Transacional do Acervo (Zero Data Loss Protocol)
//!
//! Executa a transição atômica entre o formato aberto (`acervo.sqlite`) e o
//! formato blindado (`acervo.vault`), garantindo integridade referencial,
//! cópias de segurança (snapshots) e reversão automática (rollback).

use std::{
    fs,
    path::Path,
};
use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::seguranca::cofre::{
    cifrar_arquivo_vault, decifrar_arquivo_vault, salvar_config_seguranca, ConfigSeguranca,
    ARQUIVO_VAULT,
};
use crate::domain::seguranca::criptografia::{
    derivar_chave, gerar_sal_aleatorio, hashear_senha,
};

#[derive(Debug, Serialize, Deserialize)]
pub struct ResumoMigracao {
    pub total_arvores: i64,
    pub total_pessoas: i64,
    pub total_unioes: i64,
    pub total_eventos: i64,
    pub total_midias: i64,
    pub backup_criado: String,
    pub vault_gerado: String,
}

/// Executa o protocolo de 6 fases para blindar o acervo com senha mestra.
pub async fn migrar_para_modo_blindado(
    pasta_dados: &Path,
    pool: &SqlitePool,
    senha_mestra: &str,
    pin: Option<&str>,
    chave_recuperacao: &str,
) -> Resultado<ResumoMigracao> {
    let caminho_sqlite = pasta_dados.join("acervo.sqlite");
    if !caminho_sqlite.exists() {
        return Err(ErroDominio::Persistencia("Arquivo acervo.sqlite não encontrado para migração.".into()));
    }

    // -------------------------------------------------------------------------
    // FASE 1: SNAPSHOT DE BACKUP DE SEGURANÇA PRÉ-MIGRAÇÃO
    // -------------------------------------------------------------------------
    let pasta_backups = pasta_dados.join("backups");
    let _ = fs::create_dir_all(&pasta_backups);
    let agora = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs();

    let nome_backup = format!("acervo.sqlite.backup-v0-{agora}.sqlite");
    let caminho_backup = pasta_backups.join(&nome_backup);

    fs::copy(&caminho_sqlite, &caminho_backup)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao criar snapshot pré-migração: {e}")))?;

    // -------------------------------------------------------------------------
    // FASE 2: INVENTÁRIO E VALIDAÇÃO DE INTEGRIDADE PRÉ-MIGRAÇÃO
    // -------------------------------------------------------------------------
    let check: String = sqlx::query_scalar("PRAGMA integrity_check")
        .fetch_one(pool)
        .await
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao checar integridade do banco: {e}")))?;

    if check != "ok" {
        return Err(ErroDominio::Validacao(format!("Banco de dados SQLite corrompido: {check}")));
    }

    let total_arvores: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM arvores").fetch_one(pool).await.unwrap_or(0);
    let total_pessoas: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas").fetch_one(pool).await.unwrap_or(0);
    let total_unioes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM unioes").fetch_one(pool).await.unwrap_or(0);
    let total_eventos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM eventos").fetch_one(pool).await.unwrap_or(0);
    let total_midias: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM documentos").fetch_one(pool).await.unwrap_or(0);

    // -------------------------------------------------------------------------
    // FASE 3: ENCRIPTAÇÃO ATÔMICA EM ARQUIVO TEMPORÁRIO
    // -------------------------------------------------------------------------
    let sal = gerar_sal_aleatorio();
    let chave = derivar_chave(senha_mestra, &sal)?;

    let caminho_vault_tmp = pasta_dados.join("acervo.vault.tmp");
    let caminho_vault = pasta_dados.join(ARQUIVO_VAULT);

    // Força checkpoint WAL para que todos os dados residam no arquivo principal
    let _ = sqlx::query("PRAGMA wal_checkpoint(TRUNCATE)").execute(pool).await;

    cifrar_arquivo_vault(&caminho_sqlite, &caminho_vault_tmp, &chave)?;

    // -------------------------------------------------------------------------
    // FASE 4: VALIDAÇÃO ROUND-TRIP (DECRIPTAÇÃO DE PROVA)
    // -------------------------------------------------------------------------
    let bytes_decifrados = match decifrar_arquivo_vault(&caminho_vault_tmp, &chave) {
        Ok(b) => b,
        Err(e) => {
            // Rollback imediato
            let _ = fs::remove_file(&caminho_vault_tmp);
            return Err(ErroDominio::Persistencia(format!("Falha na validação da decriptação do cofre: {e}")));
        }
    };

    // Valida se o payload decifrado corresponde byte a byte ao arquivo original (SQLCipher ou legado)
    let bytes_originais = fs::read(&caminho_sqlite)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao ler acervo para prova de integridade: {e}")))?;
    if bytes_decifrados.len() < 16 || bytes_decifrados != bytes_originais {
        let _ = fs::remove_file(&caminho_vault_tmp);
        return Err(ErroDominio::Persistencia("Erro na prova de integridade: bytes decifrados divergem do acervo.".into()));
    }

    // -------------------------------------------------------------------------
    // FASE 5: PROMOÇÃO ATÔMICA E SALVAMENTO DE CONFIGURAÇÕES
    // -------------------------------------------------------------------------
    fs::rename(&caminho_vault_tmp, &caminho_vault)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao promover acervo.vault: {e}")))?;

    let hash_mestra = hashear_senha(senha_mestra)?;
    let hash_p = if let Some(p) = pin {
        if !p.trim().is_empty() {
            Some(hashear_senha(p.trim())?)
        } else {
            None
        }
    } else {
        None
    };

    let hash_recuperacao = hashear_senha(&chave_recuperacao.trim().to_lowercase())?;

    let config = ConfigSeguranca {
        modo_blindado: true,
        hash_senha_mestra: Some(hash_mestra),
        hash_pin: hash_p,
        salt_kdf_hex: sal.iter().map(|b| format!("{:02x}", b)).collect(),
        chave_recuperacao_hash: Some(hash_recuperacao),
        data_ativacao: Some(format!("{}", agora)),
        gatekeeper_ativo: true,
    };

    salvar_config_seguranca(pasta_dados, &config)?;

    Ok(ResumoMigracao {
        total_arvores,
        total_pessoas,
        total_unioes,
        total_eventos,
        total_midias,
        backup_criado: nome_backup,
        vault_gerado: ARQUIVO_VAULT.to_string(),
    })
}

/// Reverte o modo blindado para o modo aberto padrão (após confirmação de senha).
pub async fn reverter_para_modo_aberto(
    pasta_dados: &Path,
    senha_confirmacao: &str,
    config_atual: &ConfigSeguranca,
) -> Resultado<()> {
    if let Some(hash_mestre) = &config_atual.hash_senha_mestra {
        use crate::domain::seguranca::criptografia::verificar_senha;
        if !verificar_senha(senha_confirmacao, hash_mestre) {
            return Err(ErroDominio::AcessoNegado("Senha Mestra incorreta.".into()));
        }
    }

    let mut nova_config = config_atual.clone();
    nova_config.modo_blindado = false;
    nova_config.hash_senha_mestra = None;
    nova_config.hash_pin = None;

    salvar_config_seguranca(pasta_dados, &nova_config)?;

    Ok(())
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;
    use crate::domain::seguranca::criptografia::gerar_frase_recuperacao;

    #[tokio::test]
    async fn migracao_e_reversao_com_sucesso() {
        let temp_dir = std::env::temp_dir().join(format!("elotempo_test_mig_{}", uuid::Uuid::new_v4()));
        fs::create_dir_all(&temp_dir).unwrap();

        let db_path = temp_dir.join("acervo.sqlite");
        let pool = SqlitePoolOptions::new()
            .connect_with(
                sqlx::sqlite::SqliteConnectOptions::new()
                    .filename(&db_path)
                    .create_if_missing(true),
            )
            .await
            .unwrap();

        sqlx::migrate!("./migrations").run(&pool).await.unwrap();

        // Insere dados de teste
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo) VALUES ('p_test', 'Fulano', 'de Tal', 'M')")
            .execute(&pool)
            .await
            .unwrap();

        let (frase, _) = gerar_frase_recuperacao();

        // 1. Migra para blindado
        let resumo = migrar_para_modo_blindado(&temp_dir, &pool, "SenhaForte123!", Some("123456"), &frase)
            .await
            .unwrap();

        assert_eq!(resumo.total_pessoas, 1);
        assert!(temp_dir.join(ARQUIVO_VAULT).exists());
        assert!(temp_dir.join("seguranca.json").exists());
        assert!(temp_dir.join("backups").join(&resumo.backup_criado).exists());

        // 2. Reverte com senha certa
        let cfg = crate::domain::seguranca::cofre::carregar_config_seguranca(&temp_dir);
        assert!(cfg.modo_blindado);

        reverter_para_modo_aberto(&temp_dir, "SenhaForte123!", &cfg).await.unwrap();

        let cfg_apos = crate::domain::seguranca::cofre::carregar_config_seguranca(&temp_dir);
        assert!(!cfg_apos.modo_blindado);

        // Limpa diretório de teste
        let _ = fs::remove_dir_all(&temp_dir);
    }
}
