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

/// Deriva a Key Encryption Key (KEK) portável para envelopamento do `acervo.key`.
/// Não vincula ao nome da máquina nem do usuário do sistema operacional para que
/// o acervo possa ser copiado, restaurado em backup ou levado a outro computador
/// sem se tornar ilegível.
fn derivar_kek_portavel() -> [u8; TAMANHO_CHAVE] {
    let mut hasher = Sha256::new();
    hasher.update(PEPPER_INTERNO);
    let resultado = hasher.finalize();
    let mut kek = [0u8; TAMANHO_CHAVE];
    kek.copy_from_slice(&resultado);
    kek
}

/// Deriva a KEK legada (releases 1.2.0 e 1.3.0), que concatenava USERNAME e COMPUTERNAME.
/// Mantida como fallback de leitura para abrir chaves criadas naquelas versões e
/// regravá-las de forma portável.
fn derivar_kek_legada_ambiente(usuario: Option<&str>, computador: Option<&str>) -> [u8; TAMANHO_CHAVE] {
    let mut hasher = Sha256::new();
    hasher.update(PEPPER_INTERNO);
    if let Some(u) = usuario {
        hasher.update(u.as_bytes());
    }
    if let Some(c) = computador {
        hasher.update(c.as_bytes());
    }
    let resultado = hasher.finalize();
    let mut kek = [0u8; TAMANHO_CHAVE];
    kek.copy_from_slice(&resultado);
    kek
}

fn derivar_kek_legada_atual() -> [u8; TAMANHO_CHAVE] {
    let user = std::env::var("USERNAME").or_else(|_| std::env::var("USER")).ok();
    let comp = std::env::var("COMPUTERNAME").or_else(|_| std::env::var("HOSTNAME")).ok();
    derivar_kek_legada_ambiente(user.as_deref(), comp.as_deref())
}

fn empacotar_envelope(chave: &[u8; TAMANHO_CHAVE_ACERVO], kek: &[u8; TAMANHO_CHAVE]) -> Resultado<Vec<u8>> {
    let (cifrado, nonce) = cifrar_payload(chave, kek)?;
    let mut envelope = Vec::with_capacity(HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE + cifrado.len());
    envelope.extend_from_slice(HEADER_KEY_ENVELOPE);
    envelope.extend_from_slice(&nonce);
    envelope.extend_from_slice(&cifrado);
    Ok(envelope)
}

/// Obtém a chave mestra de 256 bits do acervo para o SQLCipher.
///
/// Regra crítica de integridade (Zero Data Loss):
/// Se `acervo.key` já existir no disco, **jamais** é sobrescrito por uma chave
/// nova aleatória em caso de falha de decifragem. Se não for possível decifrar
/// `acervo.key`, retorna erro explícito preservando o arquivo intacto no disco.
pub fn obter_ou_criar_chave_acervo(pasta_dados: &Path) -> Resultado<[u8; TAMANHO_CHAVE_ACERVO]> {
    let caminho_chave = pasta_dados.join(NOME_ARQUIVO_CHAVE);
    let kek_portavel = derivar_kek_portavel();

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

            // 1. Tenta decifrar com a KEK portável (padrão 1.4.0+)
            if let Ok(decifrado) = decifrar_payload(cifrado, &kek_portavel, &nonce) {
                if decifrado.len() == TAMANHO_CHAVE_ACERVO {
                    let mut chave = [0u8; TAMANHO_CHAVE_ACERVO];
                    chave.copy_from_slice(&decifrado);
                    return Ok(chave);
                }
            }

            // 2. Fallback: tenta decifrar com a KEK legada da máquina atual (1.2.0 / 1.3.0)
            let kek_legada = derivar_kek_legada_atual();
            if let Ok(decifrado) = decifrar_payload(cifrado, &kek_legada, &nonce) {
                if decifrado.len() == TAMANHO_CHAVE_ACERVO {
                    let mut chave = [0u8; TAMANHO_CHAVE_ACERVO];
                    chave.copy_from_slice(&decifrado);
                    // Migra transparentemente o envelope para o formato portável
                    if let Ok(novo_envelope) = empacotar_envelope(&chave, &kek_portavel) {
                        let _ = fs::write(&caminho_chave, &novo_envelope);
                    }
                    return Ok(chave);
                }
            }

            // Se chegou aqui, `acervo.key` existe mas não pôde ser decifrado.
            // NUNCA sobrescrever `acervo.key`!
            return Err(ErroDominio::Persistencia(
                "Não foi possível decifrar o arquivo de chave 'acervo.key'. Por segurança, a chave existente foi preservada intacta para evitar perda de dados (ela pode ter sido gerada em versão anterior vinculada a outro nome de computador ou usuário)."
                    .into(),
            ));
        } else if bytes.len() == TAMANHO_CHAVE_ACERVO {
            // Retrocompatibilidade: chave bruta de 32 bytes
            let mut chave = [0u8; TAMANHO_CHAVE_ACERVO];
            chave.copy_from_slice(&bytes);
            return Ok(chave);
        } else {
            return Err(ErroDominio::Persistencia(
                "O arquivo 'acervo.key' existe mas está em um formato irreconhecível ou incompleto. Por segurança, o arquivo foi preservado intacto."
                    .into(),
            ));
        }
    }

    // Se `acervo.key` não existe, mas `acervo.sqlite` já existe e está cifrado,
    // também recusamos gerar chave nova silenciosa (pois ela não abriria o banco).
    let caminho_sqlite = pasta_dados.join("acervo.sqlite");
    if caminho_sqlite.exists() && !eh_sqlite_texto_claro(&caminho_sqlite) {
        if let Ok(meta) = fs::metadata(&caminho_sqlite) {
            if meta.len() > 0 {
                return Err(ErroDominio::Persistencia(
                    "O banco 'acervo.sqlite' está criptografado, mas o arquivo 'acervo.key' não foi encontrado na pasta de dados."
                        .into(),
                ));
            }
        }
    }

    // Gerar nova chave criptográfica de 256 bits (CSPRNG)
    let mut nova_chave = [0u8; TAMANHO_CHAVE_ACERVO];
    rand::thread_rng().fill_bytes(&mut nova_chave);

    // Envelopar com a KEK portável antes de salvar em disco
    let envelope = empacotar_envelope(&nova_chave, &kek_portavel)?;

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

#[cfg(test)]
mod testes {
    use super::*;

    /// Jamais sobrescreve `acervo.key` se a decifragem falhar (ex.: chave criada
    /// na 1.2.0/1.3.0 em outra máquina com outro nome de computador).
    ///
    /// Antes desta correção, `obter_ou_criar_chave_acervo` caía no ramo de criação
    /// e gravava uma chave aleatória nova por cima de `acervo.key`, destruindo de
    /// forma irreversível a única chave capaz de abrir `acervo.sqlite`.
    #[test]
    fn nunca_sobrescreve_acervo_key_quando_kek_nao_decifra() {
        let temp_dir = std::env::temp_dir().join(format!(
            "elotempo_key_preserve_{}",
            uuid::Uuid::new_v4()
        ));
        fs::create_dir_all(&temp_dir).unwrap();
        let caminho_chave = temp_dir.join(NOME_ARQUIVO_CHAVE);

        // Simula uma chave criada na v1.2.0/1.3.0 num computador chamado "PC-ANTIGO"
        let chave_original: [u8; TAMANHO_CHAVE_ACERVO] = [0x42; TAMANHO_CHAVE_ACERVO];
        let kek_pc_antigo = derivar_kek_legada_ambiente(Some("usuario_antigo"), Some("PC-ANTIGO-123"));
        let envelope_original = empacotar_envelope(&chave_original, &kek_pc_antigo).unwrap();
        fs::write(&caminho_chave, &envelope_original).unwrap();

        // Tenta abrir na máquina atual (onde o nome do computador é diferente):
        // DEVE recusar com erro e preservar `acervo.key` byte a byte!
        let resultado = obter_ou_criar_chave_acervo(&temp_dir);
        assert!(
            resultado.is_err(),
            "deveria recusar abrir quando acervo.key não pode ser decifrado"
        );

        let bytes_apos = fs::read(&caminho_chave).unwrap();
        assert_eq!(
            bytes_apos, envelope_original,
            "CRÍTICO: acervo.key foi modificado ou sobrescrito após falha de decifragem!"
        );

        // E se voltarmos ao nome antigo, a chave original continua lá e abre intacta!
        let nonce = &bytes_apos[HEADER_KEY_ENVELOPE.len()..HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE];
        let cifrado = &bytes_apos[HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE..];
        let mut nonce_arr = [0u8; TAMANHO_NONCE];
        nonce_arr.copy_from_slice(nonce);
        let recuperada = decifrar_payload(cifrado, &kek_pc_antigo, &nonce_arr).unwrap();
        assert_eq!(recuperada.as_slice(), &chave_original);

        let _ = fs::remove_dir_all(&temp_dir);
    }

    /// Chaves geradas a partir de agora usam envelope portável (independente de
    /// COMPUTERNAME / USERNAME) e chaves legadas da mesma máquina migram sozinhas
    /// para o envelope portável na primeira leitura.
    #[test]
    fn chave_nova_e_portavel_e_chave_legada_da_mesma_maquina_migra_para_portavel() {
        let temp_dir = std::env::temp_dir().join(format!(
            "elotempo_key_migr_{}",
            uuid::Uuid::new_v4()
        ));
        fs::create_dir_all(&temp_dir).unwrap();
        let caminho_chave = temp_dir.join(NOME_ARQUIVO_CHAVE);

        // Simula chave legada (1.2.0/1.3.0) criada NESTA mesma máquina
        let chave_legada: [u8; TAMANHO_CHAVE_ACERVO] = [0x7A; TAMANHO_CHAVE_ACERVO];
        let kek_legada_desta_maquina = derivar_kek_legada_atual();
        let env_legado = empacotar_envelope(&chave_legada, &kek_legada_desta_maquina).unwrap();
        fs::write(&caminho_chave, &env_legado).unwrap();

        // Ao abrir, reconhece pelo fallback legado e migra o arquivo para a KEK portável
        let lida = obter_ou_criar_chave_acervo(&temp_dir).unwrap();
        assert_eq!(lida, chave_legada);

        // Agora o arquivo em disco já abre direto com a KEK portável (mesmo se mudar de PC depois)
        let bytes_migrados = fs::read(&caminho_chave).unwrap();
        let mut nonce_arr = [0u8; TAMANHO_NONCE];
        nonce_arr.copy_from_slice(
            &bytes_migrados[HEADER_KEY_ENVELOPE.len()..HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE],
        );
        let cifrado = &bytes_migrados[HEADER_KEY_ENVELOPE.len() + TAMANHO_NONCE..];
        let decifrado_portavel =
            decifrar_payload(cifrado, &derivar_kek_portavel(), &nonce_arr).unwrap();
        assert_eq!(decifrado_portavel.as_slice(), &chave_legada);

        let _ = fs::remove_dir_all(&temp_dir);
    }
}
