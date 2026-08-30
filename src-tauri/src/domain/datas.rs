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

/// Meses por extenso, na ordem. O índice 0 é janeiro.
pub const MESES: [&str; 12] = [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro",
];

/// Abreviações de mês que o GEDCOM exige — três letras, em inglês.
pub const MESES_GEDCOM: [&str; 12] = [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC",
];

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct DataInterpretada {
    pub qualificador: Qualificador,
    pub ano_inicio: Option<i32>,
    pub ano_fim: Option<i32>,
    /// Só existem quando vieram estruturados ou puderam ser lidos com certeza
    /// do texto. Nunca são adivinhados.
    pub dia_inicio: Option<i32>,
    pub mes_inicio: Option<i32>,
}

/// Uma data escolhida nas listas da interface.
///
/// Chega estruturada em vez de digitada, que era a fonte do problema: com
/// listas suspensas o programa **sabe** o dia e o mês, em vez de tentar
/// deduzi-los de texto livre.
#[derive(Debug, Clone, Default, Deserialize)]
pub struct DataEscolhida {
    pub qualificador: Option<String>,
    pub dia: Option<i32>,
    pub mes: Option<i32>,
    pub ano: Option<i32>,
    /// Só no qualificador `intervalo`.
    pub ano_fim: Option<i32>,
    /// Para o que a estrutura não comporta: "na época da guerra".
    pub texto_livre: Option<String>,
}

/// Compõe o texto que o usuário vai ler, a partir do que ele escolheu.
///
/// `data_texto` continua sendo a verdade exibida (seção 2.5). O que mudou é
/// que agora ela é composta do que se escolheu, em vez de digitada e depois
/// interpretada.
pub fn compor_texto(escolha: &DataEscolhida) -> String {
    if let Some(livre) = escolha.texto_livre.as_ref().map(|t| t.trim()) {
        if !livre.is_empty() {
            return livre.to_string();
        }
    }

    let Some(ano) = escolha.ano else {
        return String::new();
    };

    // Dia e mês só valem com ano; e dia só vale com mês, senão "12 de 1945"
    // não quer dizer nada.
    let nucleo = match (escolha.dia, escolha.mes) {
        (Some(d), Some(m)) if (1..=12).contains(&m) => {
            format!("{d} de {} de {ano}", MESES[(m - 1) as usize])
        }
        (_, Some(m)) if (1..=12).contains(&m) => {
            format!("{} de {ano}", MESES[(m - 1) as usize])
        }
        _ => ano.to_string(),
    };

    match escolha.qualificador.as_deref() {
        Some("cerca_de") => format!("cerca de {nucleo}"),
        Some("antes_de") => format!("antes de {nucleo}"),
        Some("apos") => format!("após {nucleo}"),
        Some("intervalo") => match escolha.ano_fim {
            Some(fim) => format!("entre {ano} e {fim}"),
            None => nucleo,
        },
        _ => nucleo,
    }
}

/// Converte a escolha da interface no que vai para as colunas derivadas.
pub fn a_partir_da_escolha(escolha: &DataEscolhida) -> DataInterpretada {
    // Sem ano, não há o que posicionar no eixo — nem que haja texto livre.
    let Some(ano) = escolha.ano else {
        // O texto livre ainda pode trazer um ano ("na virada de 1900").
        return escolha
            .texto_livre
            .as_deref()
            .map(interpretar)
            .unwrap_or_else(DataInterpretada::desconhecida);
    };

    let qualificador = match escolha.qualificador.as_deref() {
        Some("cerca_de") => Qualificador::CercaDe,
        Some("antes_de") => Qualificador::AntesDe,
        Some("apos") => Qualificador::Apos,
        Some("intervalo") => Qualificador::Intervalo,
        Some("exata") => Qualificador::Exata,
        _ => Qualificador::Exata,
    };

    // Dia e mês só acompanham uma data exata: "cerca de 12 de março de 1890"
    // afirma uma precisão que o "cerca de" nega.
    let exata = qualificador == Qualificador::Exata;
    let mes = escolha.mes.filter(|m| exata && (1..=12).contains(m));
    let dia = escolha.dia.filter(|d| exata && mes.is_some() && (1..=31).contains(d));

    let (ano_inicio, ano_fim) = match qualificador {
        Qualificador::CercaDe => (
            Some((ano - MARGEM_APROXIMACAO).max(ANO_MIN)),
            Some((ano + MARGEM_APROXIMACAO).min(ANO_MAX)),
        ),
        Qualificador::AntesDe => (None, Some(ano)),
        Qualificador::Apos => (Some(ano), None),
        Qualificador::Intervalo => (Some(ano), escolha.ano_fim.or(Some(ano))),
        _ => (Some(ano), Some(ano)),
    };

    DataInterpretada {
        qualificador,
        ano_inicio,
        ano_fim,
        dia_inicio: dia,
        mes_inicio: mes,
    }
}

impl DataInterpretada {
    pub fn desconhecida() -> Self {
        Self {
            qualificador: Qualificador::Desconhecida,
            ano_inicio: None,
            ano_fim: None,
            dia_inicio: None,
            mes_inicio: None,
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
            dia_inicio: None,
            mes_inicio: None,
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
            dia_inicio: None,
            mes_inicio: None,
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
            dia_inicio: None,
            mes_inicio: None,
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
            dia_inicio: None,
            mes_inicio: None,
        };
    }

    // Data exata: vale tentar ler dia e mês do texto. Serve ao acervo antigo,
    // anterior às listas suspensas, e à importação de GEDCOM.
    let (dia, mes) = extrair_dia_e_mes(&limpo, ano);

    DataInterpretada {
        qualificador: Qualificador::Exata,
        ano_inicio: Some(ano),
        ano_fim: Some(ano),
        dia_inicio: dia,
        mes_inicio: mes,
    }
}

/// Lê dia e mês de formatos inequívocos, e só deles.
///
/// `12/03/1945` é dia 12, mês 3 — o formato brasileiro. Nada de tentar
/// desambiguar `03/04/1945`: no Brasil é 3 de abril, e ponto. O que não for
/// claramente reconhecível devolve `None`, porque uma data errada é pior do que
/// uma data incompleta.
fn extrair_dia_e_mes(texto: &str, ano: i32) -> (Option<i32>, Option<i32>) {
    let numeros: Vec<i32> = texto
        .split(|c: char| !c.is_ascii_digit())
        .filter(|p| !p.is_empty())
        .filter_map(|p| p.parse::<i32>().ok())
        .collect();

    // Mês por extenso vem PRIMEIRO: é inequívoco, enquanto os padrões
    // numéricos abaixo são heurística. Sem esta ordem, "12 de março de 1945"
    // casava com `mm/aaaa` e virava "mês 12" — o teste pegou.
    for (indice, nome) in MESES.iter().enumerate() {
        if texto.contains(&crate::domain::texto::sem_acento(nome)) {
            let mes = Some(indice as i32 + 1);
            let dia = numeros
                .iter()
                .find(|n| (1..=31).contains(*n) && **n != ano)
                .copied();
            return (dia, mes);
        }
    }

    // dd/mm/aaaa ou d/m/aaaa — formato brasileiro, o dia vem antes.
    if numeros.len() == 3 && numeros[2] == ano {
        let (d, m) = (numeros[0], numeros[1]);
        if (1..=31).contains(&d) && (1..=12).contains(&m) {
            return (Some(d), Some(m));
        }
    }

    // mm/aaaa
    if numeros.len() == 2 && numeros[1] == ano {
        let m = numeros[0];
        if (1..=12).contains(&m) {
            return (None, Some(m));
        }
    }

    (None, None)
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

    // ---------- Data escolhida nas listas (a partir de 30/08/2026) ----------

    fn escolha(q: &str, dia: Option<i32>, mes: Option<i32>, ano: Option<i32>) -> DataEscolhida {
        DataEscolhida {
            qualificador: Some(q.into()),
            dia,
            mes,
            ano,
            ano_fim: None,
            texto_livre: None,
        }
    }

    #[test]
    fn compoe_o_texto_a_partir_do_que_foi_escolhido() {
        assert_eq!(
            compor_texto(&escolha("exata", Some(12), Some(3), Some(1945))),
            "12 de março de 1945"
        );
        assert_eq!(
            compor_texto(&escolha("exata", None, Some(3), Some(1945))),
            "março de 1945"
        );
        assert_eq!(compor_texto(&escolha("exata", None, None, Some(1945))), "1945");
        assert_eq!(
            compor_texto(&escolha("cerca_de", None, None, Some(1890))),
            "cerca de 1890"
        );
        assert_eq!(
            compor_texto(&escolha("antes_de", None, None, Some(1914))),
            "antes de 1914"
        );
        assert_eq!(compor_texto(&escolha("apos", None, None, Some(1900))), "após 1900");
    }

    #[test]
    fn intervalo_compoe_com_os_dois_anos() {
        let e = DataEscolhida {
            qualificador: Some("intervalo".into()),
            ano: Some(1902),
            ano_fim: Some(1904),
            ..Default::default()
        };
        assert_eq!(compor_texto(&e), "entre 1902 e 1904");
    }

    #[test]
    fn dia_sem_mes_nao_entra_no_texto() {
        // "12 de 1945" não quer dizer nada.
        assert_eq!(compor_texto(&escolha("exata", Some(12), None, Some(1945))), "1945");
    }

    #[test]
    fn sem_ano_o_texto_fica_vazio_e_isso_e_valido() {
        // Regra transversal da seção 2.5: a data nunca bloqueia o salvamento.
        assert_eq!(compor_texto(&escolha("exata", None, None, None)), "");
        assert_eq!(
            a_partir_da_escolha(&escolha("exata", None, None, None)).qualificador,
            Qualificador::Desconhecida
        );
    }

    #[test]
    fn texto_livre_manda_quando_existe() {
        let e = DataEscolhida {
            texto_livre: Some("na época da guerra".into()),
            ..Default::default()
        };
        assert_eq!(compor_texto(&e), "na época da guerra");
        assert_eq!(a_partir_da_escolha(&e).ano_inicio, None);
    }

    #[test]
    fn texto_livre_com_ano_ainda_posiciona_no_eixo() {
        let e = DataEscolhida {
            texto_livre: Some("na virada de 1900".into()),
            ..Default::default()
        };
        assert_eq!(a_partir_da_escolha(&e).ano_inicio, Some(1900));
    }

    #[test]
    fn dia_e_mes_so_acompanham_data_exata() {
        // "cerca de 12 de março de 1890" afirma uma precisão que o "cerca de"
        // nega. O aproximado guarda só o ano.
        let d = a_partir_da_escolha(&escolha("cerca_de", Some(12), Some(3), Some(1890)));
        assert_eq!(d.dia_inicio, None);
        assert_eq!(d.mes_inicio, None);
        assert_eq!(d.ano_inicio, Some(1885));

        let exata = a_partir_da_escolha(&escolha("exata", Some(12), Some(3), Some(1945)));
        assert_eq!(exata.dia_inicio, Some(12));
        assert_eq!(exata.mes_inicio, Some(3));
    }

    #[test]
    fn dia_invalido_e_descartado_em_vez_de_gravado() {
        let d = a_partir_da_escolha(&escolha("exata", Some(45), Some(3), Some(1945)));
        assert_eq!(d.dia_inicio, None, "dia 45 não existe");
        assert_eq!(d.mes_inicio, Some(3), "o mês continua válido");
    }

    // ---------- Leitura de dia e mês do texto (acervo antigo e import) ------

    #[test]
    fn le_dia_e_mes_do_formato_brasileiro() {
        let d = interpretar("12/03/1945");
        assert_eq!(d.dia_inicio, Some(12));
        assert_eq!(d.mes_inicio, Some(3), "no Brasil o primeiro número é o dia");
        assert_eq!(d.ano_inicio, Some(1945));
    }

    #[test]
    fn le_mes_e_ano_sem_dia() {
        let d = interpretar("03/1945");
        assert_eq!(d.dia_inicio, None);
        assert_eq!(d.mes_inicio, Some(3));
    }

    #[test]
    fn le_mes_por_extenso() {
        let d = interpretar("12 de março de 1945");
        assert_eq!(d.dia_inicio, Some(12));
        assert_eq!(d.mes_inicio, Some(3));

        let so_mes = interpretar("março de 1945");
        assert_eq!(so_mes.mes_inicio, Some(3));
        assert_eq!(so_mes.dia_inicio, None);
    }

    #[test]
    fn nao_inventa_dia_nem_mes_quando_nao_ha() {
        // Data incompleta é melhor do que data errada.
        let d = interpretar("1945");
        assert_eq!(d.dia_inicio, None);
        assert_eq!(d.mes_inicio, None);

        let confuso = interpretar("livro 5 folha 132 de 1945");
        assert_eq!(confuso.mes_inicio, None);
    }

    #[test]
    fn aproximado_no_texto_tambem_nao_carrega_dia() {
        let d = interpretar("cerca de 1890");
        assert_eq!(d.dia_inicio, None);
        assert_eq!(d.mes_inicio, None);
    }

    #[test]
    fn os_meses_do_gedcom_estao_na_ordem() {
        assert_eq!(MESES_GEDCOM[0], "JAN");
        assert_eq!(MESES_GEDCOM[2], "MAR");
        assert_eq!(MESES_GEDCOM[11], "DEC");
        assert_eq!(MESES.len(), MESES_GEDCOM.len());
        assert_eq!(MESES[2], "março");
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
