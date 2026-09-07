//! Gerenciador de Cofre Criptografado e Estado de Sessão
//!
//! Controla os arquivos `seguranca.json` e `acervo.vault`, mantendo o estado
//! de bloqueio/desbloqueio e a chave da sessão ativa em memória.

use std::{
    fs,
    path::Path,
    sync::Arc,
    time::Instant,
};
use tokio::sync::RwLock;

use serde::{Deserialize, Serialize};

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::seguranca::criptografia::{
    cifrar_payload, decifrar_payload, gerar_sal_aleatorio,
    verificar_senha, TAMANHO_CHAVE, TAMANHO_NONCE,
};

pub const ARQUIVO_CONFIG_SEGURANCA: &str = "seguranca.json";
pub const ARQUIVO_VAULT: &str = "acervo.vault";
pub const MAGIC_HEADER: &[u8; 14] = b"ELOTEMPO_VAULT";

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConfigSeguranca {
    pub modo_blindado: bool,
    pub hash_senha_mestra: Option<String>,
    pub hash_pin: Option<String>,
    pub salt_kdf_hex: String,
    pub chave_recuperacao_hash: Option<String>,
    pub data_ativacao: Option<String>,
    pub gatekeeper_ativo: bool,
}

impl Default for ConfigSeguranca {
    fn default() -> Self {
        let sal = gerar_sal_aleatorio();
        Self {
            modo_blindado: false,
            hash_senha_mestra: None,
            hash_pin: None,
            salt_kdf_hex: sal.iter().map(|b| format!("{:02x}", b)).collect(),
            chave_recuperacao_hash: None,
            data_ativacao: None,
            gatekeeper_ativo: true,
        }
    }
}

/// Estado global de segurança gerenciado pelo Tauri (compartilhado entre comandos).
#[derive(Clone)]
pub struct EstadoSeguranca {
    pub config: Arc<RwLock<ConfigSeguranca>>,
    pub chave_sessao: Arc<RwLock<Option<[u8; TAMANHO_CHAVE]>>>,
    pub desbloqueado: Arc<RwLock<bool>>,
    /// Token temporário para bypass de confirmações repetidas no curto prazo (ex: 3 minutos)
    pub ticket_gatekeeper: Arc<RwLock<Option<(String, Instant)>>>,
}

impl EstadoSeguranca {
    pub fn novo(config_inicial: ConfigSeguranca) -> Self {
        let desbloqueado_inicial = !config_inicial.modo_blindado;
        Self {
            config: Arc::new(RwLock::new(config_inicial)),
            chave_sessao: Arc::new(RwLock::new(None)),
            desbloqueado: Arc::new(RwLock::new(desbloqueado_inicial)),
            ticket_gatekeeper: Arc::new(RwLock::new(None)),
        }
    }

    /// Verifica se o acervo está atualmente acessível (desbloqueado).
    pub async fn esta_desbloqueado(&self) -> bool {
        let cfg = self.config.read().await;
        if !cfg.modo_blindado {
            return true;
        }
        *self.desbloqueado.read().await
    }

    /// Bloqueia o acervo e limpa as chaves da memória.
    pub async fn bloquear(&self) {
        let cfg = self.config.read().await;
        if cfg.modo_blindado {
            let mut desb = self.desbloqueado.write().await;
            *desb = false;
            let mut ch = self.chave_sessao.write().await;
            *ch = None;
            let mut ticket = self.ticket_gatekeeper.write().await;
            *ticket = None;
        }
    }

    /// Valida uma senha ou PIN em relação ao hash armazenado.
    pub async fn validar_credencial(&self, senha_ou_pin: &str) -> bool {
        let cfg = self.config.read().await;
        if let Some(hash_mestre) = &cfg.hash_senha_mestra {
            if verificar_senha(senha_ou_pin, hash_mestre) {
                return true;
            }
        }
        if let Some(hash_p) = &cfg.hash_pin {
            if verificar_senha(senha_ou_pin, hash_p) {
                return true;
            }
        }
        false
    }
}

// -----------------------------------------------------------------------------
// OPERAÇÕES DE DISCO (IO)
// -----------------------------------------------------------------------------

pub fn carregar_config_seguranca(pasta_dados: &Path) -> ConfigSeguranca {
    let caminho = pasta_dados.join(ARQUIVO_CONFIG_SEGURANCA);
    if caminho.exists() {
        if let Ok(conteudo) = fs::read_to_string(&caminho) {
            if let Ok(cfg) = serde_json::from_str::<ConfigSeguranca>(&conteudo) {
                return cfg;
            }
        }
    }
    ConfigSeguranca::default()
}

pub fn salvar_config_seguranca(pasta_dados: &Path, config: &ConfigSeguranca) -> Resultado<()> {
    let caminho = pasta_dados.join(ARQUIVO_CONFIG_SEGURANCA);
    let json = serde_json::to_string_pretty(config)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao serializar seguranca.json: {e}")))?;

    fs::write(&caminho, json)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao gravar seguranca.json: {e}")))?;

    Ok(())
}

/// Cifra um arquivo SQLite e grava o contêiner binário `acervo.vault`.
///
/// Formato do contêiner:
/// [14 bytes Magic Header "ELOTEMPO_VAULT"]
/// [12 bytes Nonce AES-GCM]
/// [Payload cifrado com Tag GCM inclusa]
pub fn cifrar_arquivo_vault(caminho_sqlite: &Path, caminho_vault: &Path, chave: &[u8; TAMANHO_CHAVE]) -> Resultado<()> {
    let bytes_sqlite = fs::read(caminho_sqlite)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao ler arquivo SQLite original: {e}")))?;

    let (cifrado, nonce) = cifrar_payload(&bytes_sqlite, chave)?;

    let mut arquivo_final = Vec::with_capacity(MAGIC_HEADER.len() + TAMANHO_NONCE + cifrado.len());
    arquivo_final.extend_from_slice(MAGIC_HEADER);
    arquivo_final.extend_from_slice(&nonce);
    arquivo_final.extend_from_slice(&cifrado);

    fs::write(caminho_vault, &arquivo_final)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao gravar contêiner do vault: {e}")))?;

    Ok(())
}

/// Decifra um contêiner `acervo.vault` e retorna os bytes do SQLite em memória.
pub fn decifrar_arquivo_vault(caminho_vault: &Path, chave: &[u8; TAMANHO_CHAVE]) -> Resultado<Vec<u8>> {
    let bytes_vault = fs::read(caminho_vault)
        .map_err(|e| ErroDominio::Persistencia(format!("Erro ao ler arquivo de cofre: {e}")))?;

    let min_tam = MAGIC_HEADER.len() + TAMANHO_NONCE;
    if bytes_vault.len() < min_tam {
        return Err(ErroDominio::Validacao("Arquivo de cofre corrompido ou incompleto.".into()));
    }

    if &bytes_vault[..MAGIC_HEADER.len()] != MAGIC_HEADER {
        return Err(ErroDominio::Validacao("Cabeçalho do cofre inválido: formato desconhecido.".into()));
    }

    let mut nonce = [0u8; TAMANHO_NONCE];
    nonce.copy_from_slice(&bytes_vault[MAGIC_HEADER.len()..MAGIC_HEADER.len() + TAMANHO_NONCE]);

    let cifrado = &bytes_vault[MAGIC_HEADER.len() + TAMANHO_NONCE..];

    decifrar_payload(cifrado, chave, &nonce)
}
