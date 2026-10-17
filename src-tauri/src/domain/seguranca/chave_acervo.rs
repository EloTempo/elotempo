//! Gerenciamento de Chave Mestra de Criptografia do Acervo (SQLCipher)
//!
//! Garante que o arquivo `acervo.sqlite` seja sempre criado e mantido 100%
//! criptografado em repouso no disco com AES-256 via SQLCipher.
//!
//! A chave mestra de 256 bits é gerada de forma criptograficamente segura
//! na primeira execução e persistida com proteção no diretório de dados do app.

use std::fs;
use std::path::Path;
use rand::RngCore;
use sha2::{Digest, Sha256};
use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::seguranca::criptografia::{
    cifrar_payload, decifrar_payload, TAMANHO_CHAVE, TAMANHO_NONCE,
};

pub const NOME_ARQUIVO_CHAVE: &str = "acervo.key";
pub const TAMANHO_CHAVE_ACERVO: usize = 32;
const HEADER_KEY_ENVELOPE: &[u8; 15] = b"ELOTEMPO_KEY_V1";
const PEPPER_INTERNO: &[u8] = b"EloTempo::SQLCipher::EnvelopeKey::2026::LocalFirstSecurity";

/// Deriva a Key Encryption Key (KEK) local vinculada ao ambiente do usuário.
fn derivar_kek_local() -> [u8; TAMANHO_CHAVE] {
    let mut hasher = Sha256::new();
    hasher.update(PEPPER_INTERNO);
    if let Ok(user) = std::env::var("USERNAME").or_else(|_| std::env::var("USER")) {
        hasher.update(user.as_bytes());
    }
    if let Ok(comp) = std::env::var("COMPUTERNAME").or_else(|_| std::env::var("HOSTNAME")) {
        hasher.update(comp.as_bytes());
    }
    let resultado = hasher.finalize();
    let mut kek = [0u8; TAMANHO_CHAVE];
    kek.copy_from_slice(&resultado);
    kek
}

/// Obtém a chave mestra de 256 bits do acervo para o SQLCipher.
/// Se a chave ainda não existir, gera uma nova de alta entropia e persiste envelopada com AES-256-GCM.
pub fn obter_ou_criar_chave_acervo(pasta_dados: &Path) -> Resultado<[u8; TAMANHO_CHAVE_ACERVO]> {
    let caminho_chave = pasta_dados.join(NOME_ARQUIVO_CHAVE);
    let kek = derivar_kek_local();

    if caminho_chave.exists() {
        let bytes = fs::read(&caminho_chave)
            .map_err(|e| ErroDominio::Persistencia(format!("Falha ao ler chave do acervo: {e}")))?;

        // Formato envelopado AES-256-GCM: [15 bytes header][12 bytes nonce][48 bytes payload+tag]
        let min_len = HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE + TAMANHO_CHAVE_ACERVO;
        if bytes.len() >= min_len && &bytes[..HEADER_KEY_ENVELOPE.len()] == HEADER_KEY_ENVELOPE {
            let mut nonce = [0u8; TAMANHO_NONCE];
            let inicio_nonce = HEADER_KEY_ENVELOPE.len();
            let fim_nonce = inicio_nonce + TAMANHO_NONCE;
            nonce.copy_from_slice(&bytes[inicio_nonce..fim_nonce]);

            let cifrado = &bytes[fim_nonce..];
            if let Ok(decifrado) = decifrar_payload(cifrado, &kek, &nonce) {
                if decifrado.len() == TAMANHO_CHAVE_ACERVO {
                    let mut chave = [0u8; TAMANHO_CHAVE_ACERVO];
                    chave.copy_from_slice(&decifrado);
                    return Ok(chave);
                }
            }
        } else if bytes.len() == TAMANHO_CHAVE_ACERVO {
            // Retrocompatibilidade: chave bruta de 32 bytes
            let mut chave = [0u8; TAMANHO_CHAVE_ACERVO];
            chave.copy_from_slice(&bytes);
            return Ok(chave);
        }
    }

    // Gerar nova chave criptográfica de 256 bits (CSPRNG)
    let mut nova_chave = [0u8; TAMANHO_CHAVE_ACERVO];
    rand::thread_rng().fill_bytes(&mut nova_chave);

    // Envelopar com AES-256-GCM antes de salvar em disco
    let (cifrado, nonce) = cifrar_payload(&nova_chave, &kek)?;
    let mut envelope = Vec::with_capacity(HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE + cifrado.len());
    envelope.extend_from_slice(HEADER_KEY_ENVELOPE);
    envelope.extend_from_slice(&nonce);
    envelope.extend_from_slice(&cifrado);

    fs::write(&caminho_chave, &envelope)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao persistir chave do acervo: {e}")))?;

    Ok(nova_chave)
}

/// Formata a chave de 256 bits para o formato raw hexadecimal exigido pelo SQLCipher.
/// Exemplo: `"x'a1b2c3...'"` (com aspas duplas externas para o parser do SQLx).
pub fn formatar_sqlcipher_key(chave: &[u8; TAMANHO_CHAVE_ACERVO]) -> String {
    let hex: String = chave.iter().map(|b| format!("{:02x}", b)).collect();
    format!("\"x'{}'\"", hex)
}

/// Verifica se um arquivo SQLite existente está em texto claro (não criptografado).
/// Retorna `true` se o arquivo existir e começar com o cabeçalho padrão "SQLite format 3\0".
pub fn eh_sqlite_texto_claro(caminho: &Path) -> bool {
    if !caminho.exists() {
        return false;
    }

    if let Ok(bytes) = fs::read(caminho) {
        if bytes.len() >= 16 && &bytes[..16] == b"SQLite format 3\0" {
            return true;
        }
    }

    false
}

/// Migra um arquivo SQLite legado em texto claro para formato cifrado SQLCipher.
/// Se o arquivo `acervo.sqlite` for texto claro antigo, exporta-o para uma versão
/// cifrada temporária e substitui atomicamente.
pub async fn migrar_sqlite_legado_para_cifrado(
    caminho_sqlite: &Path,
    chave: &[u8; TAMANHO_CHAVE_ACERVO],
) -> Resultado<()> {
    if !eh_sqlite_texto_claro(caminho_sqlite) {
        return Ok(());
    }

    let pasta = caminho_sqlite.parent().ok_or_else(|| {
        ErroDominio::Persistencia("Caminho do acervo inválido sem pasta pai".into())
    })?;

    let caminho_tmp_cifrado = pasta.join("acervo_cifrado_migracao.tmp");
    if caminho_tmp_cifrado.exists() {
        let _ = fs::remove_file(&caminho_tmp_cifrado);
    }

    let pragma_key = formatar_sqlcipher_key(chave);

    // Abre o banco em texto claro (com create_if_missing(true) para habilitar SQLITE_OPEN_CREATE no ATTACH DATABASE)
    let opts_aberto = sqlx::sqlite::SqliteConnectOptions::new()
        .filename(caminho_sqlite)
        .create_if_missing(true);

    let pool_aberto = sqlx::sqlite::SqlitePoolOptions::new()
        .max_connections(1)
        .connect_with(opts_aberto)
        .await
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao abrir acervo legado para cifragem: {e}")))?;

    // Caminho formatado para o comando ATTACH DATABASE do SQLite (usando barras normais)
    let caminho_attach = caminho_tmp_cifrado.to_string_lossy().replace('\\', "/");
    let sql_attach = format!(
        "ATTACH DATABASE '{}' AS encrypted KEY {};",
        caminho_attach, pragma_key
    );

    sqlx::query(&sql_attach)
        .execute(&pool_aberto)
        .await
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao anexar banco para cifragem: {e}")))?;

    sqlx::query("SELECT sqlcipher_export('encrypted');")
        .execute(&pool_aberto)
        .await
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao exportar dados para SQLCipher: {e}")))?;

    sqlx::query("DETACH DATABASE encrypted;")
        .execute(&pool_aberto)
        .await
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao desanexar banco cifrado: {e}")))?;

    pool_aberto.close().await;

    // Fazer backup do original antes de substituir
    let caminho_backup_legado = pasta.join("acervo.sqlite.legado-texto-claro.bak");
    let _ = fs::copy(caminho_sqlite, &caminho_backup_legado);

    // Substituir atomicamente pelo arquivo cifrado
    fs::rename(&caminho_tmp_cifrado, caminho_sqlite)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao substituir acervo por versão cifrada: {e}")))?;

    // Deletar o backup não-cifrado para segurança
    let _ = fs::remove_file(&caminho_backup_legado);

    Ok(())
}
