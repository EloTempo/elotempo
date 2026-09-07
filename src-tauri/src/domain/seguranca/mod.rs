//! Sistema de Segurança, Criptografia e Modo Híbrido (Elotempo)

pub mod cofre;
pub mod comandos;
pub mod criptografia;
pub mod gatekeeper;
pub mod migracao;

pub use cofre::{carregar_config_seguranca, salvar_config_seguranca, ConfigSeguranca, EstadoSeguranca};
pub use comandos::*;
pub use gatekeeper::autorizar_acao_sensivel;
