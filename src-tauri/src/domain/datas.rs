//! Interpretação de datas genealógicas.
//!
//! O usuário digita o que sabe — "1945", "cerca de 1890", "antes da guerra"
//! não é data, mas "antes de 1914" é. O texto original **nunca** é perdido:
//! fica em `eventos.data_texto` e é o que aparece na tela.
//!
//! O que este módulo produz é o par `(ano_inicio, ano_fim)` que torna a data
//! ordenável e plotável — sem o qual o relatório da seção 6 ("do mais antigo ao
//! mais recente") e o eixo da linha do tempo da seção 8 não têm como funcionar.
//!
//! Regra transversal da seção 2.5: data nunca é obrigatória. Texto que não
//! rende ano nenhum é `Desconhecida`, e isso é um resultado válido, não um erro.

use serde::{Deserialize, Serialize};

/// Margem adotada para datas aproximadas, em anos para cada lado.
/// Cinco anos é a convenção genealógica usual para "cerca de".
const MARGEM_APROXIMACAO: i32 = 5;

/// Anos fora desta faixa são ruído de digitação, não data.
const ANO_MIN: i32 = 1000;
const ANO_MAX: i32 = 2200;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Qualificador {
    Exata,
    CercaDe,
    AntesDe,
    Apos,
    Intervalo,
    Desconhecida,
}

impl Qualificador {
    /// Valor gravado na coluna `eventos.data_qualificador`.
    pub fn como_str(&self) -> &'static str {
        match self {
            Qualificador::Exata => "exata",
            Qualificador::CercaDe => "cerca_de",
            Qualificador::AntesDe => "antes_de",
            Qualificador::Apos => "apos",
            Qualificador::Intervalo => "intervalo",
            Qualificador::Desconhecida => "desconhecida",
        }
    }

    /// Prefixo GEDCOM 7.0 correspondente, para a exportação.
    /// `Intervalo` vira `BET x AND y` e é montado por quem exporta.
    pub fn prefixo_gedcom(&self) -> Option<&'static str> {
        match self {
            Qualificador::Exata => None,
            Qualificador::CercaDe => Some("ABT"),
            Qualificador::AntesDe => Some("BEF"),
            Qualificador::Apos => Some("AFT"),
            Qualificador::Intervalo => Some("BET"),
            Qualificador::Desconhecida => None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct DataInterpretada {
    pub qualificador: Qualificador,
    pub ano_inicio: Option<i32>,
    pub ano_fim: Option<i32>,
}

impl DataInterpretada {
    pub fn desconhecida() -> Self {
        Self {
            qualificador: Qualificador::Desconhecida,
            ano_inicio: None,
            ano_fim: None,
        }
    }

    /// Ano usado para ordenar cronologicamente. Quem não tem ano nenhum vai
    /// para o fim da lista, nunca some — exigência explícita da seção 6.
    pub fn ano_para_ordenacao(&self) -> Option<i32> {
        self.ano_inicio.or(self.ano_fim)
    }
}

/// Interpreta o texto livre digitado pelo usuário.
///
/// Nunca falha: o pior caso é `Desconhecida`.
pub fn interpretar(texto: &str) -> DataInterpretada {
    let limpo = normalizar(texto);
    if limpo.is_empty() {
        return DataInterpretada::desconhecida();
    }

    let anos = extrair_anos(&limpo);

    // Intervalo explícito: dois anos, com ou sem palavra ligando.
    if anos.len() >= 2 {
        let (a, b) = (anos[0], anos[1]);
        let (ini, fim) = if a <= b { (a, b) } else { (b, a) };
        return DataInterpretada {
            qualificador: Qualificador::Intervalo,
            ano_inicio: Some(ini),
            ano_fim: Some(fim),
        };
    }

    let ano = match anos.first() {
        Some(a) => *a,
        // Texto sem ano algum ("na época da guerra") é memória, não data.
        None => return DataInterpretada::desconhecida(),
    };

    if tem_marca(&limpo, &["antes de", "antes", "ant.", "ant ", "bef", "<"]) {
        return DataInterpretada {
            qualificador: Qualificador::AntesDe,
            ano_inicio: None,
            ano_fim: Some(ano),
        };
    }

    if tem_marca(
        &limpo,
        &["apos", "após", "depois de", "depois", "a partir de", "aft", ">"],
    ) {
        return DataInterpretada {
            qualificador: Qualificador::Apos,
            ano_inicio: Some(ano),
            ano_fim: None,
        };
    }

    if tem_marca(
        &limpo,
        &[
            "cerca de", "cerca", "por volta de", "por volta", "aproximadamente",
            "aprox", "talvez", "provavelmente", "c.", "ca.", "ca ", "abt", "~", "?",
        ],
    ) {
        return DataInterpretada {
            qualificador: Qualificador::CercaDe,
            ano_inicio: Some((ano - MARGEM_APROXIMACAO).max(ANO_MIN)),
            ano_fim: Some((ano + MARGEM_APROXIMACAO).min(ANO_MAX)),
        };
    }

    DataInterpretada {
        qualificador: Qualificador::Exata,
        ano_inicio: Some(ano),
        ano_fim: Some(ano),
    }
}

/// Minúsculas, sem acento, espaços colapsados. Deixa a comparação de marcas
/// simples e tolerante ao que a pessoa realmente digita.
///
/// A tabela de acentos mora em `texto.rs`, que é a mesma usada pela busca de
/// municípios — duas cópias divergiriam na primeira alteração.
fn normalizar(texto: &str) -> String {
    crate::domain::texto::normalizar_busca(texto)
}

fn tem_marca(texto: &str, marcas: &[&str]) -> bool {
    marcas.iter().any(|m| texto.contains(m))
}

/// Todo grupo de exatamente 4 dígitos que caia na faixa plausível.
///
/// Quatro dígitos, e não três ou cinco, é o que separa o ano do número de
/// uma folha de livro de registro ou de um código qualquer colado junto.
fn extrair_anos(texto: &str) -> Vec<i32> {
    let mut anos = Vec::new();
    let bytes: Vec<char> = texto.chars().collect();
    let mut i = 0;

    while i < bytes.len() {
        if bytes[i].is_ascii_digit() {
            let inicio = i;
            while i < bytes.len() && bytes[i].is_ascii_digit() {
                i += 1;
            }
            let tamanho = i - inicio;
            if tamanho == 4 {
                let s: String = bytes[inicio..i].iter().collect();
                if let Ok(ano) = s.parse::<i32>() {
                    if (ANO_MIN..=ANO_MAX).contains(&ano) {
                        anos.push(ano);
                    }
                }
            }
        } else {
            i += 1;
        }
    }
    anos
}

#[cfg(test)]
mod testes {
    use super::*;

    fn q(texto: &str) -> Qualificador {
        interpretar(texto).qualificador
    }

    #[test]
    fn data_vazia_e_desconhecida_nao_erro() {
        // Regra transversal da seção 2.5: a data nunca bloqueia o salvamento.
        assert_eq!(q(""), Qualificador::Desconhecida);
        assert_eq!(q("   "), Qualificador::Desconhecida);
        assert_eq!(interpretar("").ano_inicio, None);
    }

    #[test]
    fn texto_sem_ano_nao_inventa_data() {
        assert_eq!(q("na época da guerra"), Qualificador::Desconhecida);
        assert_eq!(q("quando era menino"), Qualificador::Desconhecida);
        assert_eq!(interpretar("sem registro").ano_inicio, None);
    }

    #[test]
    fn so_o_ano() {
        let d = interpretar("1945");
        assert_eq!(d.qualificador, Qualificador::Exata);
        assert_eq!(d.ano_inicio, Some(1945));
        assert_eq!(d.ano_fim, Some(1945));
    }

    #[test]
    fn data_completa_brasileira() {
        let d = interpretar("12/03/1945");
        assert_eq!(d.qualificador, Qualificador::Exata);
        assert_eq!(d.ano_inicio, Some(1945));
    }

    #[test]
    fn mes_e_ano() {
        assert_eq!(interpretar("03/1945").ano_inicio, Some(1945));
    }

    #[test]
    fn aproximada_abre_margem_para_os_dois_lados() {
        for texto in ["cerca de 1890", "c. 1890", "por volta de 1890", "~1890", "aprox 1890"] {
            let d = interpretar(texto);
            assert_eq!(d.qualificador, Qualificador::CercaDe, "falhou em: {texto}");
            assert_eq!(d.ano_inicio, Some(1885), "falhou em: {texto}");
            assert_eq!(d.ano_fim, Some(1895), "falhou em: {texto}");
        }
    }

    #[test]
    fn antes_de_nao_tem_limite_inferior() {
        let d = interpretar("antes de 1900");
        assert_eq!(d.qualificador, Qualificador::AntesDe);
        assert_eq!(d.ano_inicio, None);
        assert_eq!(d.ano_fim, Some(1900));
    }

    #[test]
    fn apos_nao_tem_limite_superior() {
        for texto in ["após 1900", "apos 1900", "depois de 1900"] {
            let d = interpretar(texto);
            assert_eq!(d.qualificador, Qualificador::Apos, "falhou em: {texto}");
            assert_eq!(d.ano_inicio, Some(1900));
            assert_eq!(d.ano_fim, None);
        }
    }

    #[test]
    fn intervalo_com_dois_anos() {
        for texto in ["1902-1904", "entre 1902 e 1904", "de 1902 a 1904"] {
            let d = interpretar(texto);
            assert_eq!(d.qualificador, Qualificador::Intervalo, "falhou em: {texto}");
            assert_eq!(d.ano_inicio, Some(1902));
            assert_eq!(d.ano_fim, Some(1904));
        }
    }

    #[test]
    fn intervalo_invertido_e_normalizado() {
        let d = interpretar("1904-1902");
        assert_eq!(d.ano_inicio, Some(1902));
        assert_eq!(d.ano_fim, Some(1904));
    }

    #[test]
    fn numero_que_nao_e_ano_e_ignorado() {
        // Folha 132 do livro de registro não é uma data.
        assert_eq!(interpretar("livro 5 folha 132").ano_inicio, None);
        // Ano implausível também não.
        assert_eq!(interpretar("ano 12345").ano_inicio, None);
        assert_eq!(interpretar("850").ano_inicio, None);
    }

    #[test]
    fn ordenacao_usa_o_inicio_ou_cai_para_o_fim() {
        assert_eq!(interpretar("1945").ano_para_ordenacao(), Some(1945));
        // "antes de 1900" não tem início — ordena pelo teto que conhecemos.
        assert_eq!(interpretar("antes de 1900").ano_para_ordenacao(), Some(1900));
        assert_eq!(interpretar("").ano_para_ordenacao(), None);
    }

    #[test]
    fn mapeamento_gedcom() {
        assert_eq!(Qualificador::CercaDe.prefixo_gedcom(), Some("ABT"));
        assert_eq!(Qualificador::AntesDe.prefixo_gedcom(), Some("BEF"));
        assert_eq!(Qualificador::Apos.prefixo_gedcom(), Some("AFT"));
        assert_eq!(Qualificador::Exata.prefixo_gedcom(), None);
    }

    #[test]
    fn qualificadores_batem_com_o_check_da_migration_007() {
        // Se algum destes mudar, a migration 007 rejeita a gravação.
        let permitidos = [
            "exata", "cerca_de", "antes_de", "apos", "intervalo", "desconhecida",
        ];
        for q in [
            Qualificador::Exata,
            Qualificador::CercaDe,
            Qualificador::AntesDe,
            Qualificador::Apos,
            Qualificador::Intervalo,
            Qualificador::Desconhecida,
        ] {
            assert!(permitidos.contains(&q.como_str()), "{:?} fora do CHECK", q);
        }
    }
}
