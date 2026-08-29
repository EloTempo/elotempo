use serde::{Deserialize, Serialize};
use std::fmt;

/// Erros de domínio.
///
/// São tipados, e não `String`, por dois motivos: o frontend pode reagir ao
/// `codigo` sem depender do texto em português, e os testes podem afirmar
/// *qual* invariante foi violada em vez de comparar mensagens.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "codigo", content = "detalhe")]
pub enum ErroDominio {
    /// A pessoa referenciada não existe no acervo.
    PessoaNaoEncontrada(String),
    /// A união referenciada não existe no acervo.
    UniaoNaoEncontrada(String),

    /// Seção 3: "exatamente um slot masculino e um feminino".
    SlotIncompativel {
        slot: String,
        pessoa_id: String,
        sexo: String,
    },

    /// Seção 3: "uma pessoa pertence a no máximo uma união como filho".
    FilhoJaTemUniao {
        pessoa_id: String,
        uniao_existente: String,
    },

    /// Seção 3: filhos ancoram na união, e ninguém é filho de si mesmo nem
    /// do próprio descendente.
    CicloGenealogico {
        pessoa_id: String,
        motivo: String,
    },

    /// Trocar o sexo de alguém que já ocupa um slot quebraria a união.
    SexoTravadoPorUniao {
        pessoa_id: String,
        uniao_id: String,
        slot: String,
    },

    /// Apagar deixaria uma união sem um dos lados. A união é sempre binária.
    PessoaEmUso {
        pessoa_id: String,
        motivo: String,
    },

    /// Valor fora do domínio permitido (sexo, tipo de vínculo, etc.).
    ValorInvalido { campo: String, valor: String },

    /// Falha vinda do SQLite. Nunca carrega SQL nem dado do usuário.
    Persistencia(String),
}

impl fmt::Display for ErroDominio {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use ErroDominio::*;
        match self {
            PessoaNaoEncontrada(id) => write!(f, "Pessoa não encontrada ({id})"),
            UniaoNaoEncontrada(id) => write!(f, "União não encontrada ({id})"),
            SlotIncompativel { slot, sexo, .. } => write!(
                f,
                "O slot {slot} não aceita uma pessoa de sexo '{sexo}'. \
                 A união tem sempre um slot masculino e um feminino; quando o sexo \
                 é desconhecido, use um placeholder."
            ),
            FilhoJaTemUniao { uniao_existente, .. } => write!(
                f,
                "Esta pessoa já é filha da união {uniao_existente}. \
                 Cada pessoa se liga a no máximo uma união como filho — desvincule da \
                 anterior antes de anexar a outra."
            ),
            CicloGenealogico { motivo, .. } => write!(f, "Ligação impossível: {motivo}"),
            SexoTravadoPorUniao { uniao_id, slot, .. } => write!(
                f,
                "Não dá para mudar o sexo: esta pessoa ocupa o slot {slot} da união {uniao_id}. \
                 Desfaça a união antes, ou troque o ocupante do slot."
            ),
            PessoaEmUso { motivo, .. } => write!(f, "Não é possível excluir: {motivo}"),
            ValorInvalido { campo, valor } => {
                write!(f, "Valor inválido para {campo}: '{valor}'")
            }
            Persistencia(msg) => write!(f, "Erro ao acessar o acervo: {msg}"),
        }
    }
}

impl std::error::Error for ErroDominio {}

impl From<sqlx::Error> for ErroDominio {
    fn from(e: sqlx::Error) -> Self {
        ErroDominio::Persistencia(e.to_string())
    }
}

pub type Resultado<T> = Result<T, ErroDominio>;
