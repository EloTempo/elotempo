//! Sistema de Segurança, Criptografia e Modo Híbrido (Elotempo)

pub mod chave_acervo;
pub mod cofre;
pub mod comandos;
pub mod criptografia;
pub mod gatekeeper;
pub mod migracao;
#[cfg(test)]
pub mod sqlcipher_test;

pub use cofre::{carregar_config_seguranca, salvar_config_seguranca, ConfigSeguranca, EstadoSeguranca};
pub use comandos::*;
pub use gatekeeper::autorizar_acao_sensivel;
