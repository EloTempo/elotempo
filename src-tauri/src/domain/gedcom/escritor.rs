//! Emissão de linhas GEDCOM (fatia 08).
//!
//! A gramática de linha é simples — `nível [xref] tag [valor]` — e é
//! justamente por isso que o parser não foi comprado (ver a spec da fatia 09).
//! O que exige cuidado não é a forma, são três regras de escape que, se
//! esquecidas, produzem arquivo que outro programa recusa sem dizer por quê.

use crate::domain::datas::{Qualificador, MESES_GEDCOM};

/// Monta o texto de um arquivo GEDCOM, linha a linha.
#[derive(Default)]
pub struct Escritor {
    linhas: Vec<String>,
}

impl Escritor {
    pub fn novo() -> Self {
        Self::default()
    }

    /// Uma linha sem valor: `1 GEDC`.
    pub fn tag(&mut self, nivel: u8, tag: &str) {
        self.linhas.push(format!("{nivel} {tag}"));
    }

    /// Uma linha com valor, já escapado e quebrado em `CONT` se preciso.
    pub fn campo(&mut self, nivel: u8, tag: &str, valor: &str) {
        let limpo = limpar(valor);
        if limpo.is_empty() {
            return;
        }

        let mut partes = limpo.split('\n');
        let primeira = partes.next().unwrap_or("");
        self.linhas.push(format!("{nivel} {tag} {}", escapar(primeira)));

        // Quebra de linha dentro de um valor vira CONT no nível seguinte. Sem
        // isso, uma minibiografia de dois parágrafos quebraria o arquivo.
        for resto in partes {
            self.linhas.push(format!("{} CONT {}", nivel + 1, escapar(resto)));
        }
    }

    /// Só emite se houver valor. Evita `campo` dentro de `if let` em toda parte.
    pub fn campo_opcional(&mut self, nivel: u8, tag: &str, valor: Option<&str>) {
        if let Some(v) = valor {
            self.campo(nivel, tag, v);
        }
    }

    /// Abertura de registro: `0 @I1@ INDI`.
    pub fn registro(&mut self, xref: &str, tag: &str) {
        self.linhas.push(format!("0 @{xref}@ {tag}"));
    }

    /// Referência a outro registro: `1 HUSB @I3@`.
    pub fn referencia(&mut self, nivel: u8, tag: &str, xref: &str) {
        self.linhas.push(format!("{nivel} {tag} @{xref}@"));
    }

    pub fn finalizar(mut self) -> String {
        self.linhas.push("0 TRLR".to_string());
        // GEDCOM termina cada linha com quebra, inclusive a última.
        format!("{}\n", self.linhas.join("\n"))
    }

    #[cfg(test)]
    pub fn texto_parcial(&self) -> String {
        self.linhas.join("\n")
    }
}

/// Tira o que não pode aparecer numa linha GEDCOM.
///
/// `\r` some (arquivos vindos do Windows), e os demais caracteres de controle
/// também — um `\t` perdido numa nota não quebra o arquivo, mas um `\0` sim.
fn limpar(valor: &str) -> String {
    valor
        .replace("\r\n", "\n")
        .replace('\r', "\n")
        .chars()
        .filter(|c| *c == '\n' || !c.is_control())
        .collect::<String>()
        .trim()
        .to_string()
}

/// Escapa a arroba inicial.
///
/// Em GEDCOM, `@` abre uma referência (`@I1@`). Um valor que **começa** com `@`
/// — raro, mas acontece em endereço de e-mail colado numa nota — precisa vir
/// dobrado, senão o leitor tenta interpretá-lo como ponteiro.
fn escapar(valor: &str) -> String {
    if valor.starts_with('@') {
        format!("@{valor}")
    } else {
        valor.to_string()
    }
}

/// Monta o valor de um `DATE` a partir do que o acervo guarda.
///
/// Devolve `None` quando não há nada a afirmar — data desconhecida é ausência
/// de `DATE`, não um `DATE` vazio.
pub fn data_gedcom(
    qualificador: &str,
    dia: Option<i64>,
    mes: Option<i64>,
    ano_inicio: Option<i64>,
    ano_fim: Option<i64>,
) -> Option<String> {
    let mes_abrev = |m: i64| -> Option<&'static str> {
        (1..=12).contains(&m).then(|| MESES_GEDCOM[(m - 1) as usize])
    };

    // O núcleo: o que se sabe da data, do mais preciso ao menos.
    let nucleo = |ano: i64| -> String {
        match (dia, mes.and_then(mes_abrev)) {
            (Some(d), Some(m)) if (1..=31).contains(&d) => format!("{d} {m} {ano}"),
            (_, Some(m)) => format!("{m} {ano}"),
            _ => ano.to_string(),
        }
    };

    match qualificador {
        "exata" => ano_inicio.map(nucleo),
        // Aproximada, anterior e posterior guardam só o ano: dia e mês não
        // acompanham um qualificador que nega precisão.
        "cerca_de" => {
            // `ano_inicio` do aproximado é a margem, não o ano dito. O ano
            // original é o meio do intervalo.
            match (ano_inicio, ano_fim) {
                (Some(de), Some(ate)) => Some(format!("ABT {}", (de + ate) / 2)),
                (Some(a), None) | (None, Some(a)) => Some(format!("ABT {a}")),
                _ => None,
            }
        }
        "antes_de" => ano_fim.map(|a| format!("BEF {a}")),
        "apos" => ano_inicio.map(|a| format!("AFT {a}")),
        "intervalo" => match (ano_inicio, ano_fim) {
            (Some(de), Some(ate)) => Some(format!("BET {de} AND {ate}")),
            (Some(a), None) => Some(format!("AFT {a}")),
            (None, Some(a)) => Some(format!("BEF {a}")),
            _ => None,
        },
        _ => None,
    }
}

/// Converte o qualificador do banco no enum, para quem precisar.
pub fn qualificador_de(texto: &str) -> Qualificador {
    match texto {
        "cerca_de" => Qualificador::CercaDe,
        "antes_de" => Qualificador::AntesDe,
        "apos" => Qualificador::Apos,
        "intervalo" => Qualificador::Intervalo,
        "exata" => Qualificador::Exata,
        _ => Qualificador::Desconhecida,
    }
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn emite_linha_simples() {
        let mut e = Escritor::novo();
        e.tag(1, "GEDC");
        e.campo(2, "VERS", "7.0");
        assert_eq!(e.texto_parcial(), "1 GEDC\n2 VERS 7.0");
    }

    #[test]
    fn o_arquivo_termina_em_trlr_com_quebra() {
        let mut e = Escritor::novo();
        e.tag(0, "HEAD");
        let texto = e.finalizar();
        assert!(texto.ends_with("0 TRLR\n"));
    }

    #[test]
    fn registro_e_referencia_usam_arroba() {
        let mut e = Escritor::novo();
        e.registro("I1", "INDI");
        e.referencia(1, "FAMC", "F2");
        assert_eq!(e.texto_parcial(), "0 @I1@ INDI\n1 FAMC @F2@");
    }

    #[test]
    fn valor_vazio_nao_vira_linha() {
        // Um `1 NOTE` sem valor é lixo no arquivo.
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "");
        e.campo(1, "NOTE", "   ");
        e.campo_opcional(1, "NOTE", None);
        assert_eq!(e.texto_parcial(), "");
    }

    #[test]
    fn quebra_de_linha_vira_cont() {
        // Uma minibiografia de dois parágrafos quebraria o arquivo sem isto.
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "Primeiro parágrafo.\nSegundo parágrafo.");
        assert_eq!(
            e.texto_parcial(),
            "1 NOTE Primeiro parágrafo.\n2 CONT Segundo parágrafo."
        );
    }

    #[test]
    fn quebra_do_windows_tambem_vira_cont() {
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "Uma\r\nDuas");
        assert_eq!(e.texto_parcial(), "1 NOTE Uma\n2 CONT Duas");
    }

    #[test]
    fn arroba_inicial_e_dobrada() {
        // Senão o leitor tenta interpretar o valor como ponteiro.
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "@casa era o apelido");
        assert_eq!(e.texto_parcial(), "1 NOTE @@casa era o apelido");
    }

    #[test]
    fn arroba_no_meio_fica_como_esta() {
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "escreva para joao@exemplo.com");
        assert!(e.texto_parcial().contains("joao@exemplo.com"));
    }

    #[test]
    fn caractere_de_controle_e_removido() {
        let mut e = Escritor::novo();
        e.campo(1, "NOTE", "Ana\u{0}Maria");
        assert_eq!(e.texto_parcial(), "1 NOTE AnaMaria");
    }

    // ---------- Datas ----------

    #[test]
    fn data_exata_completa_sai_com_mes_em_ingles() {
        assert_eq!(
            data_gedcom("exata", Some(12), Some(3), Some(1945), Some(1945)),
            Some("12 MAR 1945".into())
        );
    }

    #[test]
    fn data_exata_sem_dia_sai_com_mes_e_ano() {
        assert_eq!(
            data_gedcom("exata", None, Some(3), Some(1945), Some(1945)),
            Some("MAR 1945".into())
        );
    }

    #[test]
    fn data_exata_so_com_ano() {
        assert_eq!(
            data_gedcom("exata", None, None, Some(1945), Some(1945)),
            Some("1945".into())
        );
    }

    #[test]
    fn aproximada_volta_ao_ano_dito_e_nao_a_margem() {
        // O acervo guarda 1885–1895 para "cerca de 1890". O GEDCOM quer
        // `ABT 1890` — o ano que a pessoa escreveu, não o intervalo derivado.
        assert_eq!(
            data_gedcom("cerca_de", None, None, Some(1885), Some(1895)),
            Some("ABT 1890".into())
        );
    }

    #[test]
    fn anterior_e_posterior() {
        assert_eq!(
            data_gedcom("antes_de", None, None, None, Some(1914)),
            Some("BEF 1914".into())
        );
        assert_eq!(
            data_gedcom("apos", None, None, Some(1900), None),
            Some("AFT 1900".into())
        );
    }

    #[test]
    fn intervalo_usa_bet_and() {
        assert_eq!(
            data_gedcom("intervalo", None, None, Some(1902), Some(1904)),
            Some("BET 1902 AND 1904".into())
        );
    }

    #[test]
    fn data_desconhecida_nao_emite_nada() {
        // Ausência de DATE, não DATE vazio.
        assert_eq!(data_gedcom("desconhecida", None, None, None, None), None);
        assert_eq!(data_gedcom("exata", None, None, None, None), None);
    }

    #[test]
    fn dia_invalido_nao_contamina_a_data() {
        assert_eq!(
            data_gedcom("exata", Some(45), Some(3), Some(1945), Some(1945)),
            Some("MAR 1945".into()),
            "dia 45 é descartado, o mês continua"
        );
    }

    #[test]
    fn os_doze_meses_saem_na_abreviacao_certa() {
        for (mes, esperado) in [(1, "JAN"), (2, "FEB"), (3, "MAR"), (12, "DEC")] {
            let r = data_gedcom("exata", None, Some(mes), Some(2000), Some(2000)).unwrap();
            assert!(r.starts_with(esperado), "mês {mes} virou {r}");
        }
    }
}
