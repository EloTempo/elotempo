//! Léxico do GEDCOM: bytes → texto → linhas (fatia 09).
//!
//! Duas etapas que parecem uma só e não são.
//!
//! **Decodificar.** O 7.0 é UTF-8 sempre. O 5.5.1 pode vir em ANSEL, UTF-8,
//! UTF-16 ou Windows-1252 (declarado como `ANSI`), e é exatamente aqui que um
//! acervo brasileiro se estraga em silêncio: "Conceição" mal decodificado não
//! dá erro, vira lixo — e só se descobre meses depois, quando a busca não acha
//! mais ninguém.
//!
//! **Analisar.** A gramática de linha é simples: `nível [@xref@] TAG [valor]`.
//! O que não é simples é `CONC`/`CONT`, que partem um valor longo em várias
//! linhas: `CONT` emenda com quebra de linha, `CONC` emenda sem nada. Tratá-los
//! como tags de verdade encheria a árvore de nós falsos.

use crate::domain::erros::{ErroDominio, Resultado};

/// Uma linha já normalizada.
#[derive(Debug, Clone, PartialEq)]
pub struct Linha {
    pub nivel: u8,
    /// O identificador do registro, sem as arrobas: `I1`, `F3`.
    pub xref: Option<String>,
    pub tag: String,
    pub valor: String,
}

impl Linha {
    /// O valor lido como ponteiro (`@I1@` → `I1`), se for um.
    pub fn como_ponteiro(&self) -> Option<&str> {
        let v = self.valor.trim();
        if v.len() >= 3 && v.starts_with('@') && v.ends_with('@') {
            Some(&v[1..v.len() - 1])
        } else {
            None
        }
    }
}

// ---------------------------------------------------------------------------
// Codificação
// ---------------------------------------------------------------------------

/// Windows-1252 difere do Latin-1 só na faixa 0x80–0x9F. Fora dela, byte é
/// ponto de código, e é por isso que a tabela tem 32 entradas em vez de 256.
const CP1252_ALTO: [char; 32] = [
    '\u{20AC}', '\u{FFFD}', '\u{201A}', '\u{0192}', '\u{201E}', '\u{2026}', '\u{2020}', '\u{2021}',
    '\u{02C6}', '\u{2030}', '\u{0160}', '\u{2039}', '\u{0152}', '\u{FFFD}', '\u{017D}', '\u{FFFD}',
    '\u{FFFD}', '\u{2018}', '\u{2019}', '\u{201C}', '\u{201D}', '\u{2022}', '\u{2013}', '\u{2014}',
    '\u{02DC}', '\u{2122}', '\u{0161}', '\u{203A}', '\u{0153}', '\u{FFFD}', '\u{017E}', '\u{0178}',
];

/// Diacríticos combinantes do ANSEL, na faixa 0xE0–0xFE.
///
/// **No ANSEL o acento vem ANTES da letra**, ao contrário do Unicode. "José"
/// chega como `J o s E2 e`. Quem ler byte a byte sem saber disso produz "JosÉ2e"
/// ou perde o acento — e é o modo de falha que a fatia 09 avisa que precisa de
/// teste próprio.
fn ansel_combinante(byte: u8) -> Option<char> {
    Some(match byte {
        0xE0 => '\u{0309}', // gancho acima
        0xE1 => '\u{0300}', // grave
        0xE2 => '\u{0301}', // agudo
        0xE3 => '\u{0302}', // circunflexo
        0xE4 => '\u{0303}', // til
        0xE5 => '\u{0304}', // mácron
        0xE6 => '\u{0306}', // breve
        0xE7 => '\u{0307}', // ponto acima
        0xE8 => '\u{0308}', // trema
        0xE9 => '\u{030C}', // cáron
        0xEA => '\u{030A}', // anel acima
        0xEB => '\u{FE20}', // ligadura, metade esquerda
        0xEC => '\u{FE21}', // ligadura, metade direita
        0xED => '\u{0315}', // vírgula acima à direita
        0xEE => '\u{030B}', // duplo agudo
        0xEF => '\u{0310}', // candrabindu
        0xF0 => '\u{0327}', // cedilha
        0xF1 => '\u{0328}', // ogonek
        0xF2 => '\u{0323}', // ponto abaixo
        0xF3 => '\u{0324}', // trema abaixo
        0xF4 => '\u{0325}', // anel abaixo
        0xF5 => '\u{0333}', // duplo sublinhado
        0xF6 => '\u{0332}', // sublinhado
        0xF7 => '\u{0326}', // vírgula abaixo
        0xF8 => '\u{031C}', // meio anel à esquerda
        0xF9 => '\u{032E}', // breve abaixo
        0xFA => '\u{FE22}', // til duplo, metade esquerda
        0xFB => '\u{FE23}', // til duplo, metade direita
        0xFE => '\u{0313}', // vírgula acima
        _ => return None,
    })
}

/// Letras próprias do ANSEL, que não são diacrítico nem ASCII.
fn ansel_letra(byte: u8) -> Option<char> {
    Some(match byte {
        0xA1 => 'Ł',
        0xA2 => 'Ø',
        0xA3 => 'Đ',
        0xA4 => 'Þ',
        0xA5 => 'Æ',
        0xA6 => 'Œ',
        0xA7 => 'ʹ',
        0xA8 => '·',
        0xA9 => '♭',
        0xAA => '®',
        0xAB => '±',
        0xAC => 'Ŋ',
        0xAD => 'ŋ',
        0xAE => 'ʼ',
        0xB0 => 'ʻ',
        0xB1 => 'ł',
        0xB2 => 'ø',
        0xB3 => 'đ',
        0xB4 => 'þ',
        0xB5 => 'æ',
        0xB6 => 'œ',
        0xB7 => 'ʺ',
        0xB8 => 'ı',
        0xB9 => '£',
        0xBA => 'ð',
        0xC0 => '°',
        0xC1 => 'ℓ',
        0xC2 => '℗',
        0xC3 => '©',
        0xC4 => '♯',
        0xC5 => '¿',
        0xC6 => '¡',
        _ => return None,
    })
}

/// Junta base + combinante numa letra só, quando existe.
///
/// Vale para o que aparece em nome brasileiro, espanhol e italiano. O que não
/// estiver aqui sai decomposto — que continua sendo Unicode correto e legível,
/// só não normalizado. Melhor isso do que perder o acento.
fn compor(base: char, marca: char) -> Option<char> {
    Some(match (base, marca) {
        ('a', '\u{0300}') => 'à', ('a', '\u{0301}') => 'á', ('a', '\u{0302}') => 'â',
        ('a', '\u{0303}') => 'ã', ('a', '\u{0308}') => 'ä',
        ('A', '\u{0300}') => 'À', ('A', '\u{0301}') => 'Á', ('A', '\u{0302}') => 'Â',
        ('A', '\u{0303}') => 'Ã', ('A', '\u{0308}') => 'Ä',
        ('e', '\u{0300}') => 'è', ('e', '\u{0301}') => 'é', ('e', '\u{0302}') => 'ê',
        ('e', '\u{0308}') => 'ë',
        ('E', '\u{0300}') => 'È', ('E', '\u{0301}') => 'É', ('E', '\u{0302}') => 'Ê',
        ('E', '\u{0308}') => 'Ë',
        ('i', '\u{0300}') => 'ì', ('i', '\u{0301}') => 'í', ('i', '\u{0302}') => 'î',
        ('i', '\u{0308}') => 'ï',
        ('I', '\u{0300}') => 'Ì', ('I', '\u{0301}') => 'Í', ('I', '\u{0302}') => 'Î',
        ('I', '\u{0308}') => 'Ï',
        ('o', '\u{0300}') => 'ò', ('o', '\u{0301}') => 'ó', ('o', '\u{0302}') => 'ô',
        ('o', '\u{0303}') => 'õ', ('o', '\u{0308}') => 'ö',
        ('O', '\u{0300}') => 'Ò', ('O', '\u{0301}') => 'Ó', ('O', '\u{0302}') => 'Ô',
        ('O', '\u{0303}') => 'Õ', ('O', '\u{0308}') => 'Ö',
        ('u', '\u{0300}') => 'ù', ('u', '\u{0301}') => 'ú', ('u', '\u{0302}') => 'û',
        ('u', '\u{0308}') => 'ü',
        ('U', '\u{0300}') => 'Ù', ('U', '\u{0301}') => 'Ú', ('U', '\u{0302}') => 'Û',
        ('U', '\u{0308}') => 'Ü',
        ('c', '\u{0327}') => 'ç', ('C', '\u{0327}') => 'Ç',
        ('n', '\u{0303}') => 'ñ', ('N', '\u{0303}') => 'Ñ',
        ('y', '\u{0301}') => 'ý', ('Y', '\u{0301}') => 'Ý',
        _ => return None,
    })
}

fn de_ansel(bytes: &[u8]) -> String {
    let mut saida = String::with_capacity(bytes.len());
    // Podem vir dois diacríticos para a mesma letra; a pilha segura os dois.
    let mut pendentes: Vec<char> = Vec::new();

    for &b in bytes {
        if let Some(marca) = ansel_combinante(b) {
            pendentes.push(marca);
            continue;
        }

        let base = if b < 0x80 {
            b as char
        } else if let Some(c) = ansel_letra(b) {
            c
        } else {
            '\u{FFFD}'
        };

        if pendentes.is_empty() {
            saida.push(base);
            continue;
        }

        // Uma marca que compõe vira letra única; o resto fica decomposto.
        let mut atual = base;
        let mut sobraram: Vec<char> = Vec::new();
        for marca in pendentes.drain(..) {
            match compor(atual, marca) {
                Some(c) => atual = c,
                None => sobraram.push(marca),
            }
        }
        saida.push(atual);
        saida.extend(sobraram);
    }

    // Diacrítico solto no fim do arquivo: não some, mas não inventa letra.
    saida.extend(pendentes);
    saida
}

fn de_cp1252(bytes: &[u8]) -> String {
    bytes
        .iter()
        .map(|&b| match b {
            0x80..=0x9F => CP1252_ALTO[(b - 0x80) as usize],
            _ => b as char,
        })
        .collect()
}

fn de_utf16(bytes: &[u8], big_endian: bool) -> String {
    let unidades: Vec<u16> = bytes
        .chunks_exact(2)
        .map(|par| {
            if big_endian {
                u16::from_be_bytes([par[0], par[1]])
            } else {
                u16::from_le_bytes([par[0], par[1]])
            }
        })
        .collect();
    String::from_utf16_lossy(&unidades)
}

/// Lê o `1 CHAR` do cabeçalho sem depender da codificação.
///
/// Circular por natureza: para saber a codificação é preciso ler o arquivo, e
/// para ler o arquivo é preciso a codificação. A saída é que a tag e o valor de
/// `CHAR` são ASCII em todas as codificações que nos interessam, então basta
/// varrer os primeiros bytes tratando-os como ASCII.
fn declaracao_de_char(bytes: &[u8]) -> Option<String> {
    let inicio = &bytes[..bytes.len().min(4096)];
    let texto: String = inicio
        .iter()
        .map(|&b| if b < 0x80 { b as char } else { ' ' })
        .collect();

    for linha in texto.lines() {
        let l = linha.trim();
        if let Some(resto) = l.strip_prefix("1 CHAR ") {
            return Some(resto.trim().to_ascii_uppercase());
        }
    }
    None
}

/// O texto do arquivo e o nome da codificação usada, para o resumo dizer.
///
/// A ordem importa: BOM manda mais do que `CHAR`, porque BOM é fato e `CHAR` é
/// declaração — e arquivo com declaração errada existe.
pub fn decodificar(bytes: &[u8]) -> (String, &'static str) {
    if bytes.starts_with(&[0xEF, 0xBB, 0xBF]) {
        return (String::from_utf8_lossy(&bytes[3..]).into_owned(), "UTF-8");
    }
    if bytes.starts_with(&[0xFF, 0xFE]) {
        return (de_utf16(&bytes[2..], false), "UTF-16");
    }
    if bytes.starts_with(&[0xFE, 0xFF]) {
        return (de_utf16(&bytes[2..], true), "UTF-16");
    }

    match declaracao_de_char(bytes).as_deref() {
        Some("ANSEL") => (de_ansel(bytes), "ANSEL"),
        Some("UTF-8") | Some("UTF8") => (String::from_utf8_lossy(bytes).into_owned(), "UTF-8"),
        Some("ANSI") | Some("WINDOWS-1252") | Some("CP1252") => (de_cp1252(bytes), "Windows-1252"),
        // ASCII é subconjunto de UTF-8; declarado ou não, o caminho é o mesmo.
        _ => match std::str::from_utf8(bytes) {
            Ok(s) => (s.to_string(), "UTF-8"),
            // Não sendo UTF-8 válido, Windows-1252 é o palpite que mais acerta
            // em arquivo de origem brasileira. Nunca falha: todo byte tem
            // correspondente, e é por isso que ele é o último recurso.
            Err(_) => (de_cp1252(bytes), "Windows-1252"),
        },
    }
}

// ---------------------------------------------------------------------------
// Linhas
// ---------------------------------------------------------------------------

fn partir_linha(bruta: &str) -> Option<Linha> {
    let l = bruta.trim_start_matches('\u{FEFF}').trim();
    if l.is_empty() {
        return None;
    }

    let mut resto = l;
    let nivel: u8 = {
        let fim = resto.find(' ').unwrap_or(resto.len());
        let n = resto[..fim].parse().ok()?;
        resto = resto[fim..].trim_start();
        n
    };

    let mut xref = None;
    if resto.starts_with('@') {
        // `@@` no início é valor escapado, não xref.
        if !resto.starts_with("@@") {
            if let Some(fim) = resto[1..].find('@') {
                xref = Some(resto[1..=fim].to_string());
                resto = resto[fim + 2..].trim_start();
            }
        }
    }

    let (tag, valor) = match resto.find(' ') {
        Some(i) => (&resto[..i], resto[i + 1..].to_string()),
        None => (resto, String::new()),
    };
    if tag.is_empty() {
        return None;
    }

    Some(Linha {
        nivel,
        xref,
        tag: tag.to_ascii_uppercase(),
        valor,
    })
}

/// Desfaz o escape de `@` — no GEDCOM, um arroba literal no valor vem dobrado.
fn desescapar(valor: &str) -> String {
    valor.replace("@@", "@")
}

/// Transforma o texto em linhas, resolvendo `CONC` e `CONT`.
///
/// Elas não são estrutura, são continuação: `CONT` emenda com quebra de linha,
/// `CONC` emenda direto. Deixá-las virar nós encheria a árvore de filhos falsos
/// e faria uma nota de dois parágrafos aparecer como dois campos.
pub fn analisar(texto: &str) -> Resultado<Vec<Linha>> {
    let mut linhas: Vec<Linha> = Vec::new();

    for bruta in texto.lines() {
        let Some(mut linha) = partir_linha(bruta) else {
            continue;
        };

        if linha.tag == "CONC" || linha.tag == "CONT" {
            let Some(anterior) = linhas.last_mut() else {
                // Continuação sem nada a continuar: arquivo torto. Ignorar é
                // melhor do que abortar a importação inteira por causa disso.
                continue;
            };
            if linha.tag == "CONT" {
                anterior.valor.push('\n');
            }
            anterior.valor.push_str(&desescapar(&linha.valor));
            continue;
        }

        linha.valor = desescapar(&linha.valor);
        linhas.push(linha);
    }

    if linhas.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "arquivo".into(),
            valor: "nenhuma linha GEDCOM reconhecível".into(),
        });
    }

    Ok(linhas)
}

/// A versão declarada no `HEAD.GEDC.VERS`.
pub fn versao(linhas: &[Linha]) -> String {
    let mut em_gedc = false;
    for l in linhas {
        if l.nivel == 0 {
            em_gedc = false;
        }
        if l.nivel == 1 && l.tag == "GEDC" {
            em_gedc = true;
            continue;
        }
        if em_gedc && l.nivel == 2 && l.tag == "VERS" {
            return l.valor.trim().to_string();
        }
        if l.nivel <= 1 && l.tag != "GEDC" {
            em_gedc = false;
        }
    }
    "desconhecida".into()
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn parte_a_linha_em_nivel_tag_e_valor() {
        let l = partir_linha("1 NAME João /Silva/").unwrap();
        assert_eq!(l.nivel, 1);
        assert_eq!(l.tag, "NAME");
        assert_eq!(l.valor, "João /Silva/");
        assert_eq!(l.xref, None);
    }

    #[test]
    fn reconhece_o_registro_e_a_xref() {
        let l = partir_linha("0 @I1@ INDI").unwrap();
        assert_eq!(l.nivel, 0);
        assert_eq!(l.xref.as_deref(), Some("I1"));
        assert_eq!(l.tag, "INDI");
        assert_eq!(l.valor, "");
    }

    #[test]
    fn le_ponteiro_no_valor() {
        let l = partir_linha("1 HUSB @I3@").unwrap();
        assert_eq!(l.como_ponteiro(), Some("I3"));
    }

    #[test]
    fn cont_emenda_com_quebra_e_conc_sem() {
        let linhas = analisar("0 @I1@ INDI\n1 NOTE primeiro\n2 CONT segundo\n2 CONC ” e mais").unwrap();
        assert_eq!(linhas.len(), 2);
        assert_eq!(linhas[1].valor, "primeiro\nsegundo” e mais");
    }

    #[test]
    fn arroba_dobrada_vira_arroba_simples() {
        let linhas = analisar("0 @I1@ INDI\n1 NOTE fulano@@exemplo").unwrap();
        assert_eq!(linhas[1].valor, "fulano@exemplo");
    }

    #[test]
    fn arquivo_sem_linha_valida_da_erro() {
        assert!(analisar("").is_err());
        assert!(analisar("isto não é gedcom\nnem isto").is_err());
    }

    #[test]
    fn le_a_versao_do_cabecalho() {
        let linhas = analisar("0 HEAD\n1 GEDC\n2 VERS 7.0\n0 TRLR").unwrap();
        assert_eq!(versao(&linhas), "7.0");
    }

    // ---------- Codificação ----------

    #[test]
    fn utf8_com_bom_perde_o_bom() {
        let mut bytes = vec![0xEF, 0xBB, 0xBF];
        bytes.extend("1 NAME José".as_bytes());
        let (texto, nome) = decodificar(&bytes);
        assert_eq!(texto, "1 NAME José");
        assert_eq!(nome, "UTF-8");
    }

    #[test]
    fn ansel_poe_o_acento_antes_da_letra() {
        // "José" em ANSEL: J o s <agudo> e
        let bytes: Vec<u8> = vec![
            b'0', b' ', b'H', b'E', b'A', b'D', b'\n',
            b'1', b' ', b'C', b'H', b'A', b'R', b' ', b'A', b'N', b'S', b'E', b'L', b'\n',
            b'1', b' ', b'N', b'A', b'M', b'E', b' ', b'J', b'o', b's', 0xE2, b'e',
        ];
        let (texto, nome) = decodificar(&bytes);
        assert_eq!(nome, "ANSEL");
        assert!(texto.ends_with("José"), "{texto}");
    }

    #[test]
    fn ansel_resolve_cedilha_e_til() {
        // "Conceição": C o n c <cedilha> c e i <til> ç a o — na prática,
        // "Concei" + til+ç... o caso real é ç e ã na mesma palavra.
        let bytes: Vec<u8> = vec![
            b'1', b' ', b'C', b'H', b'A', b'R', b' ', b'A', b'N', b'S', b'E', b'L', b'\n',
            b'1', b' ', b'N', b'A', b'M', b'E', b' ',
            b'C', b'o', b'n', b'c', b'e', b'i', 0xF0, b'c', 0xE4, b'a', b'o',
        ];
        let (texto, _) = decodificar(&bytes);
        assert!(texto.ends_with("Conceição"), "{texto}");
    }

    #[test]
    fn cp1252_salva_o_que_nao_e_utf8() {
        // "José" em Windows-1252: o 'é' é o byte 0xE9 sozinho, que não é UTF-8.
        let bytes: Vec<u8> = vec![b'1', b' ', b'N', b'A', b'M', b'E', b' ', b'J', b'o', b's', 0xE9];
        let (texto, nome) = decodificar(&bytes);
        assert_eq!(texto, "1 NAME José");
        assert_eq!(nome, "Windows-1252");
    }

    #[test]
    fn utf8_sem_bom_e_reconhecido_sozinho() {
        let (texto, nome) = decodificar("1 NAME Gonçalves".as_bytes());
        assert_eq!(texto, "1 NAME Gonçalves");
        assert_eq!(nome, "UTF-8");
    }

    #[test]
    fn bom_manda_mais_do_que_a_declaracao() {
        // Declara ANSEL mas tem BOM de UTF-8: o BOM é fato, a declaração é
        // conversa. Arquivo assim existe, e decodificar como ANSEL o destruiria.
        let mut bytes = vec![0xEF, 0xBB, 0xBF];
        bytes.extend("1 CHAR ANSEL\n1 NAME José".as_bytes());
        let (texto, nome) = decodificar(&bytes);
        assert_eq!(nome, "UTF-8");
        assert!(texto.ends_with("José"));
    }

    #[test]
    fn utf16_le_com_bom() {
        let mut bytes = vec![0xFF, 0xFE];
        for u in "1 NAME José".encode_utf16() {
            bytes.extend(u.to_le_bytes());
        }
        let (texto, nome) = decodificar(&bytes);
        assert_eq!(texto, "1 NAME José");
        assert_eq!(nome, "UTF-16");
    }
}
