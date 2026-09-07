//! Módulo Criptográfico do Elotempo (Argon2id + AES-256-GCM + BIP-39)
//!
//! Fornece derivação de chave de alta resistência contra GPUs (Argon2id),
//! cifra autenticada de dados em repouso (AES-256-GCM) e geração de
//! chave física de recuperação de 24 palavras (padrão mnemônico).

use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use argon2::{
    password_hash::{rand_core::OsRng, PasswordHash, PasswordHasher, PasswordVerifier, SaltString},
    Argon2,
};
use rand::RngCore;

use crate::domain::erros::{ErroDominio, Resultado};

/// Comprimento padrão da chave simétrica AES-256 (32 bytes = 256 bits).
pub const TAMANHO_CHAVE: usize = 32;

/// Comprimento padrão do nonce AES-256-GCM (12 bytes = 96 bits).
pub const TAMANHO_NONCE: usize = 12;

/// Comprimento do sal criptográfico (16 bytes = 128 bits).
pub const TAMANHO_SAL: usize = 16;

/// Gera bytes aleatórios criptograficamente seguros (CSPRNG).
pub fn gerar_sal_aleatorio() -> [u8; TAMANHO_SAL] {
    let mut sal = [0u8; TAMANHO_SAL];
    rand::thread_rng().fill_bytes(&mut sal);
    sal
}

/// Deriva uma chave simétrica de 256 bits a partir de uma senha e de um sal
/// utilizando o algoritmo Argon2id com parâmetros de memória e custo.
pub fn derivar_chave(senha: &str, sal: &[u8]) -> Resultado<[u8; TAMANHO_CHAVE]> {
    let mut chave = [0u8; TAMANHO_CHAVE];
    let argon2 = Argon2::default();

    argon2
        .hash_password_into(senha.as_bytes(), sal, &mut chave)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao derivar chave criptográfica: {e}")))?;

    Ok(chave)
}

/// Gera o hash seguro de uma senha (com sal embutido no padrão PHC)
/// para armazenamento e validação posterior.
pub fn hashear_senha(senha: &str) -> Resultado<String> {
    let salt = SaltString::generate(&mut OsRng);
    let argon2 = Argon2::default();

    let password_hash = argon2
        .hash_password(senha.as_bytes(), &salt)
        .map_err(|e| ErroDominio::Persistencia(format!("Falha ao gerar hash da senha: {e}")))?
        .to_string();

    Ok(password_hash)
}

/// Valida se uma senha fornecida confere com o hash PHC armazenado.
pub fn verificar_senha(senha: &str, hash_str: &str) -> bool {
    let parsed_hash = match PasswordHash::new(hash_str) {
        Ok(h) => h,
        Err(_) => return false,
    };

    Argon2::default()
        .verify_password(senha.as_bytes(), &parsed_hash)
        .is_ok()
}

/// Cifra um payload de bytes utilizando AES-256-GCM.
/// Retorna o ciphertext com tag de autenticação e o nonce de 12 bytes.
pub fn cifrar_payload(dados: &[u8], chave: &[u8; TAMANHO_CHAVE]) -> Resultado<(Vec<u8>, [u8; TAMANHO_NONCE])> {
    let cipher = Aes256Gcm::new_from_slice(chave)
        .map_err(|e| ErroDominio::Persistencia(format!("Chave de cifra inválida: {e}")))?;

    let mut nonce_bytes = [0u8; TAMANHO_NONCE];
    rand::thread_rng().fill_bytes(&mut nonce_bytes);
    let nonce = Nonce::from_slice(&nonce_bytes);

    let ciphertext = cipher
        .encrypt(nonce, dados)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao criptografar dados: {e}")))?;

    Ok((ciphertext, nonce_bytes))
}

/// Decifra um payload cifrado utilizando AES-256-GCM com validação de integridade.
/// Se os dados ou a chave tiverem sido adulterados, retorna erro de validação.
pub fn decifrar_payload(
    cifrado: &[u8],
    chave: &[u8; TAMANHO_CHAVE],
    nonce_bytes: &[u8; TAMANHO_NONCE],
) -> Resultado<Vec<u8>> {
    let cipher = Aes256Gcm::new_from_slice(chave)
        .map_err(|e| ErroDominio::Persistencia(format!("Chave de decifra inválida: {e}")))?;

    let nonce = Nonce::from_slice(nonce_bytes);

    let plaintext = cipher
        .decrypt(nonce, cifrado)
        .map_err(|_| ErroDominio::AcessoNegado("Falha na autenticação dos dados: senha incorreta ou arquivo corrompido.".into()))?;

    Ok(plaintext)
}

// -----------------------------------------------------------------------------
// CHAVE DE RECUPERAÇÃO FÍSICA DE 24 PALAVRAS (Padrão BIP-39)
// -----------------------------------------------------------------------------

include!("palavras_bip39.rs");

/// Gera uma frase mnemônica física de 24 palavras a partir de 256 bits de entropia.
pub fn gerar_frase_recuperacao() -> (String, Vec<u8>) {
    let mut entropia = [0u8; 32];
    rand::thread_rng().fill_bytes(&mut entropia);

    let mut palavras = Vec::with_capacity(24);
    // 24 palavras = 264 bits (256 bits de entropia + 8 bits de checksum sha256).
    use sha2::{Digest, Sha256};
    let mut hasher = Sha256::new();
    hasher.update(&entropia);
    let hash = hasher.finalize();
    let checksum = hash[0];

    let mut bits = Vec::with_capacity(264);
    for byte in &entropia {
        for i in (0..8).rev() {
            bits.push((byte >> i) & 1 == 1);
        }
    }
    for i in (0..8).rev() {
        bits.push((checksum >> i) & 1 == 1);
    }

    for chunk in bits.chunks(11) {
        let mut idx = 0usize;
        for bit in chunk {
            idx = (idx << 1) | (*bit as usize);
        }
        palavras.push(LISTA_PALAVRAS_BIP39[idx % 2048]);
    }

    (palavras.join(" "), entropia.to_vec())
}

/// Valida se uma frase de 24 palavras é válida e recupera os bytes de entropia.
pub fn validar_frase_recuperacao(frase: &str) -> Resultado<Vec<u8>> {
    let palavras: Vec<&str> = frase
        .split_whitespace()
        .map(|s| s.trim())
        .filter(|s| !s.is_empty())
        .collect();

    if palavras.len() != 24 {
        return Err(ErroDominio::Validacao(
            format!("A Chave de Recuperação deve conter exatamente 24 palavras (recebidas: {}).", palavras.len())
        ));
    }

    let mut indices = Vec::with_capacity(24);
    for p in &palavras {
        let p_lower = p.to_lowercase();
        match LISTA_PALAVRAS_BIP39.binary_search(&p_lower.as_str()) {
            Ok(idx) => indices.push(idx),
            Err(_) => return Err(ErroDominio::Validacao(format!("Palavra desconhecida na Chave de Recuperação: '{p}'."))),
        }
    }

    let mut bits = Vec::with_capacity(264);
    for idx in indices {
        for i in (0..11).rev() {
            bits.push((idx >> i) & 1 == 1);
        }
    }

    let mut entropia = Vec::with_capacity(32);
    for chunk in bits[..256].chunks(8) {
        let mut byte = 0u8;
        for bit in chunk {
            byte = (byte << 1) | (*bit as u8);
        }
        entropia.push(byte);
    }

    // Valida checksum
    use sha2::{Digest, Sha256};
    let mut hasher = Sha256::new();
    hasher.update(&entropia);
    let hash = hasher.finalize();
    let checksum_esperado = hash[0];

    let mut checksum_lido = 0u8;
    for bit in &bits[256..264] {
        checksum_lido = (checksum_lido << 1) | (*bit as u8);
    }

    if checksum_esperado != checksum_lido {
        return Err(ErroDominio::Validacao(
            "Checksum inválido. Verifique se as palavras foram digitadas na ordem correta.".into()
        ));
    }

    Ok(entropia)
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn deriva_chave_reproduzivel_com_mesmo_sal() {
        let sal = [42u8; TAMANHO_SAL];
        let k1 = derivar_chave("SenhaMestraSegura123!", &sal).unwrap();
        let k2 = derivar_chave("SenhaMestraSegura123!", &sal).unwrap();
        assert_eq!(k1, k2);

        let k3 = derivar_chave("OutraSenha", &sal).unwrap();
        assert_ne!(k1, k3);
    }

    #[test]
    fn hashear_e_verificar_senha() {
        let senha = "MinhaFamiliaSegura@2026";
        let hash = hashear_senha(senha).unwrap();
        assert!(verificar_senha(senha, &hash));
        assert!(!verificar_senha("SenhaErrada", &hash));
    }

    #[test]
    fn cifra_e_decifra_round_trip() {
        let sal = gerar_sal_aleatorio();
        let chave = derivar_chave("ChaveTeste99!", &sal).unwrap();
        let dados_originais = b"Conteudo secreto de teste para o Elotempo";

        let (cifrado, nonce) = cifrar_payload(dados_originais, &chave).unwrap();
        assert_ne!(dados_originais.as_slice(), cifrado.as_slice());

        let decifrado = decifrar_payload(&cifrado, &chave, &nonce).unwrap();
        assert_eq!(dados_originais.as_slice(), decifrado.as_slice());
    }

    #[test]
    fn decifra_rejeita_chave_errada() {
        let sal = gerar_sal_aleatorio();
        let chave_certa = derivar_chave("ChaveCerta!", &sal).unwrap();
        let chave_errada = derivar_chave("ChaveErrada!", &sal).unwrap();
        let dados = b"Dados ultraconfidenciais";

        let (cifrado, nonce) = cifrar_payload(dados, &chave_certa).unwrap();
        let resultado = decifrar_payload(&cifrado, &chave_errada, &nonce);
        assert!(resultado.is_err());
    }

    #[test]
    fn frase_recuperacao_gera_e_valida_24_palavras() {
        let (frase, entropia) = gerar_frase_recuperacao();
        let palavras: Vec<&str> = frase.split_whitespace().collect();
        assert_eq!(palavras.len(), 24);

        let entropia_recuperada = validar_frase_recuperacao(&frase).unwrap();
        assert_eq!(entropia, entropia_recuperada);
    }
}
