//! Modelos compartilhados entre o domínio e a camada de comandos.
//!
//! `Evento` mora em `eventos_cmds.rs`, junto das regras de data que só fazem
//! sentido ao lado dele.

use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Pessoa {
    pub id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    /// 'M', 'F', 'X' ou 'U', conforme GEDCOM 7.0.
    pub sexo: String,
    pub minibiografia: Option<String>,
    pub is_vivo: bool,
    /// Pessoa-placeholder da seção 2.2: nó real, sexo definido, nome em aberto.
    pub is_placeholder: bool,
    pub foto_url: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Uniao {
    pub id: String,
    pub slot_masculino_id: String,
    pub slot_feminino_id: String,
    /// 'casamento', 'estavel', 'dissolvida' ou 'nao_informado'.
    pub estado_vinculo: String,
    pub nota: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct UniaoFilho {
    pub uniao_id: String,
    pub pessoa_id: String,
    /// 'biologico', 'adotado', 'enteado' ou 'tutelado' (tag GEDCOM `PEDI`).
    pub tipo_vinculo: String,
    pub ordem: Option<i64>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Pais {
    pub id: String,
    pub nome: String,
    pub codigo_iso: Option<String>,
    pub ordem_destaque: i64,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Local {
    pub id: String,
    pub nome: String,
    pub uf: Option<String>,
    pub pais_id: String,
    /// Chave estável dos municípios brasileiros. Nulo para locais no exterior,
    /// onde a cidade é texto livre (seção 2.4).
    pub codigo_ibge: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Apelido {
    pub id: String,
    pub pessoa_id: String,
    pub apelido: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Nacionalidade {
    pub id: String,
    pub pessoa_id: String,
    pub pais_id: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Religiao {
    pub id: String,
    pub pessoa_id: String,
    pub denominacao: String,
    pub periodo: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Escolaridade {
    pub id: String,
    pub pessoa_id: String,
    pub nivel: String,
    pub instituicao: Option<String>,
    pub periodo: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Profissao {
    pub id: String,
    pub pessoa_id: String,
    pub ocupacao: String,
    pub empregador_local: Option<String>,
    pub periodo: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Idioma {
    pub id: String,
    pub pessoa_id: String,
    pub idioma: String,
}
