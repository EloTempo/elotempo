//! Importar GEDCOM (fatia 09).
//!
//! Exportar só lê; importar **escreve**, e escreve dado que veio de outro
//! programa, com outras regras. O risco tem nome, e a spec da fatia o enuncia:
//!
//! > As invariantes da seção 3 são mais estritas do que o GEDCOM.
//!
//! Arquivo real traz `FAMC` múltiplo (é o jeito normal de registrar adoção),
//! `FAM` de mesmo sexo e, às vezes, ciclo. **As invariantes não se relaxam** —
//! quem cede é a importação, perguntando caso a caso.
//!
//! ## Duas fases, e por quê
//!
//! **Analisar** não escreve nada: lê o arquivo, monta o grafo em memória e
//! devolve a lista de perguntas. **Aplicar** recebe as respostas, relê o mesmo
//! arquivo e grava tudo numa transação. Reler custa barato e evita guardar
//! estado de sessão no backend — a chave de cada conflito é a `xref`, que é
//! estável dentro do arquivo.
//!
//! ## Por que este módulo não chama `regras.rs`
//!
//! As funções de escrita de `regras.rs` recebem `&SqlitePool`, e uma transação
//! vive numa conexão só: chamá-las de dentro de uma transação as faria gravar
//! por fora dela, e o "falhou, nada entra" da spec deixaria de valer.
//!
//! O que **não** se duplica são as regras: `sexo_cabe_no_slot`,
//! `validar_sexo` e `validar_tipo_vinculo` são funções puras de `regras.rs` e
//! são chamadas daqui. Duplicado é só o `INSERT`. E a última linha de defesa
//! continua sendo o banco — o índice único de `uniao_filhos` e os `CHECK` das
//! migrations abortam a transação inteira se este módulo errar.

use std::collections::{HashMap, HashSet};

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use uuid::Uuid;

use crate::domain::datas::{self, DataEscolhida, MESES_GEDCOM};
use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::eventos_cmds::tipos;
use crate::domain::regras::{sexo_cabe_no_slot, validar_tipo_vinculo, Slot};
use crate::domain::texto::{normalizar_busca, sem_acento_sql};

use super::lexico::{self, Linha};

// ---------------------------------------------------------------------------
// Árvore de registros
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
pub struct No {
    pub tag: String,
    pub valor: String,
    pub filhos: Vec<No>,
}

impl No {
    fn filho(&self, tag: &str) -> Option<&No> {
        self.filhos.iter().find(|f| f.tag == tag)
    }
    fn valor_de(&self, tag: &str) -> Option<&str> {
        self.filho(tag).map(|f| f.valor.trim()).filter(|v| !v.is_empty())
    }
    fn todos<'a>(&'a self, tag: &'a str) -> impl Iterator<Item = &'a No> + 'a {
        self.filhos.iter().filter(move |f| f.tag == tag)
    }
}

#[derive(Debug, Clone)]
pub struct Registro {
    pub xref: String,
    pub tag: String,
    pub no: No,
}

/// Fecha os nós abertos até a profundidade pedida, pendurando cada um no pai.
fn colapsar(pilha: &mut Vec<No>, ate: usize) {
    while pilha.len() > ate {
        let filho = pilha.pop().expect("len > ate >= 0");
        if let Some(pai) = pilha.last_mut() {
            pai.filhos.push(filho);
        }
    }
}

/// Monta a árvore a partir das linhas, pelo nível.
///
/// Uma pilha de nós em construção, e não navegação por índices a partir da
/// raiz: com a pilha, o nó do nível `n` está sempre em `pilha[n]`, e fechar um
/// nível é pendurá-lo no de cima. Além de mais simples, é o que o empréstimo
/// mutável do Rust aceita sem contorção.
pub fn montar_registros(linhas: &[Linha]) -> Vec<Registro> {
    let mut registros: Vec<Registro> = Vec::new();
    let mut pilha: Vec<No> = Vec::new();
    let mut xref_atual = String::new();

    let mut fechar_registro = |pilha: &mut Vec<No>, xref: &mut String| {
        colapsar(pilha, 1);
        if let Some(raiz) = pilha.pop() {
            registros.push(Registro {
                xref: std::mem::take(xref),
                tag: raiz.tag.clone(),
                no: raiz,
            });
        }
    };

    for l in linhas {
        let no = No {
            tag: l.tag.clone(),
            valor: l.valor.clone(),
            filhos: vec![],
        };

        if l.nivel == 0 {
            fechar_registro(&mut pilha, &mut xref_atual);
            // HEAD e TRLR não têm xref: entram como registro sem identificador
            // e são ignorados adiante, em vez de virarem exceção aqui.
            xref_atual = l.xref.clone().unwrap_or_default();
            pilha.push(no);
            continue;
        }

        if pilha.is_empty() {
            continue; // linha antes de qualquer registro: arquivo torto
        }

        // Nível saltado (2 vindo logo depois de 0) é arquivo malformado. Cair
        // no nível disponível mantém o dado em vez de derrubar a importação.
        let alvo = (l.nivel as usize).min(pilha.len());
        colapsar(&mut pilha, alvo);
        pilha.push(no);
    }

    fechar_registro(&mut pilha, &mut xref_atual);
    registros
}

// ---------------------------------------------------------------------------
// O que se lê de cada registro
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
pub struct EventoLido {
    pub tipo: String,
    pub data: DataEscolhida,
    pub tem_data: bool,
    pub local: Option<String>,
    pub nota: Option<String>,
}

#[derive(Debug, Clone)]
pub struct IndiLido {
    pub xref: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub apelidos: Vec<String>,
    pub outros_nomes: Vec<(String, Option<String>, String)>,
    pub eventos: Vec<EventoLido>,
    pub atributos: Vec<(&'static str, String)>,
    pub nota: Option<String>,
    pub famc: Vec<(String, String)>,
    pub is_vivo: bool,
}

impl IndiLido {
    pub fn exibicao(&self) -> String {
        match &self.sobrenome {
            Some(s) if !s.is_empty() => format!("{} {}", self.nome, s),
            _ => self.nome.clone(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct FamLido {
    pub xref: String,
    pub husb: Option<String>,
    pub wife: Option<String>,
    pub chil: Vec<String>,
    pub eventos: Vec<EventoLido>,
}

/// `NAME` do GEDCOM: o sobrenome vem entre barras.
fn partir_nome(valor: &str) -> (String, Option<String>) {
    let v = valor.trim();
    if let (Some(a), Some(b)) = (v.find('/'), v.rfind('/')) {
        if b > a {
            let dado = v[..a].trim().to_string();
            let sobrenome = v[a + 1..b].trim().to_string();
            let sufixo = v[b + 1..].trim();
            let dado = if sufixo.is_empty() { dado } else { format!("{dado} {sufixo}").trim().to_string() };
            return (
                if dado.is_empty() { "Sem nome".into() } else { dado },
                if sobrenome.is_empty() { None } else { Some(sobrenome) },
            );
        }
    }
    (if v.is_empty() { "Sem nome".into() } else { v.to_string() }, None)
}

/// `NAME.TYPE` do GEDCOM → tipo nosso. É a volta de `tipo_de_nome` do
/// exportador; `AKA` volta como "público" por ser onde ele agrupa os três.
fn tipo_de_nome_nosso(tipo: &str) -> &'static str {
    match tipo.trim().to_ascii_uppercase().as_str() {
        "BIRTH" => "nascimento",
        "MARRIED" => "casada",
        "MAIDEN" => "solteira",
        "PROFESSIONAL" => "profissional",
        "IMMIGRANT" => "imigracao",
        _ => "publico",
    }
}

/// `PEDI` → `tipo_vinculo` nosso. É a volta de `pedigree` do exportador.
fn vinculo_do_pedi(no: &No) -> String {
    let pedi = no.valor_de("PEDI").unwrap_or("BIRTH").to_ascii_uppercase();
    match pedi.as_str() {
        "ADOPTED" => "adotado".into(),
        "FOSTER" => "tutelado".into(),
        "OTHER" => {
            // O exportador põe a palavra em PHRASE justamente porque `OTHER`
            // sozinho não diz nada. Se ela voltar, é ela que vale.
            let frase = no
                .filho("PEDI")
                .and_then(|p| p.valor_de("PHRASE"))
                .unwrap_or("")
                .to_ascii_lowercase();
            if validar_tipo_vinculo(&frase).is_ok() {
                frase
            } else {
                "biologico".into()
            }
        }
        _ => "biologico".into(),
    }
}

fn mes_do_gedcom(sigla: &str) -> Option<i32> {
    let s = sigla.to_ascii_uppercase();
    MESES_GEDCOM.iter().position(|m| *m == s).map(|i| i as i32 + 1)
}

/// Interpreta um `DATE` do GEDCOM.
///
/// Cobre o que o padrão usa de fato — `12 MAR 1945`, `ABT 1890`, `BEF 1900`,
/// `BET 1900 AND 1910`, `FROM x TO y`. O que não couber cai em "só sei
/// descrever", com o texto original inteiro: a regra da seção 2.5 é que a data
/// nunca bloqueia o salvamento, e ela vale igual para dado importado.
pub fn data_do_gedcom(bruta: &str) -> DataEscolhida {
    let texto = bruta.trim();
    let livre = || DataEscolhida {
        qualificador: Some("livre".into()),
        dia: None,
        mes: None,
        ano: None,
        ano_fim: None,
        texto_livre: Some(texto.to_string()),
    };
    if texto.is_empty() {
        return livre();
    }

    let maiuscula = texto.to_ascii_uppercase();
    let palavras: Vec<&str> = maiuscula.split_whitespace().collect();

    // Intervalos primeiro: têm duas datas e não cabem no caminho simples.
    if palavras.first() == Some(&"BET") || palavras.first() == Some(&"FROM") {
        let separador = if palavras[0] == "BET" { "AND" } else { "TO" };
        if let Some(i) = palavras.iter().position(|p| *p == separador) {
            let de = ano_solto(&palavras[1..i]);
            let ate = ano_solto(&palavras[i + 1..]);
            if let (Some(a), Some(b)) = (de, ate) {
                return DataEscolhida {
                    qualificador: Some("intervalo".into()),
                    dia: None,
                    mes: None,
                    ano: Some(a),
                    ano_fim: Some(b),
                    texto_livre: None,
                };
            }
        }
        return livre();
    }

    let (qualificador, resto): (&str, &[&str]) = match palavras.first().copied() {
        Some("ABT") | Some("EST") | Some("CAL") => ("cerca_de", &palavras[1..]),
        Some("BEF") => ("antes_de", &palavras[1..]),
        Some("AFT") => ("apos", &palavras[1..]),
        _ => ("exata", &palavras[..]),
    };

    // Dia e mês só fazem sentido no que o padrão escreve como `D MMM AAAA`.
    let (dia, mes, ano) = match resto.len() {
        3 => (
            resto[0].parse::<i32>().ok(),
            mes_do_gedcom(resto[1]),
            resto[2].parse::<i32>().ok(),
        ),
        2 => (None, mes_do_gedcom(resto[0]), resto[1].parse::<i32>().ok()),
        1 => (None, None, resto[0].parse::<i32>().ok()),
        _ => (None, None, None),
    };

    let Some(ano) = ano else { return livre() };
    // Dia sem mês não existe; e o aproximado guarda só o ano, como em `datas.rs`.
    let (dia, mes) = if qualificador == "exata" {
        (if mes.is_some() { dia } else { None }, mes)
    } else {
        (None, None)
    };

    DataEscolhida {
        qualificador: Some(qualificador.into()),
        dia,
        mes,
        ano: Some(ano),
        ano_fim: None,
        texto_livre: None,
    }
}

fn ano_solto(palavras: &[&str]) -> Option<i32> {
    palavras.iter().rev().find_map(|p| p.parse::<i32>().ok())
}

fn evento_do_no(no: &No, tipo: &str) -> EventoLido {
    let bruta = no.valor_de("DATE").unwrap_or("");
    let data = data_do_gedcom(bruta);
    EventoLido {
        tipo: tipo.to_string(),
        tem_data: !bruta.trim().is_empty(),
        data,
        local: no.valor_de("PLAC").map(str::to_string),
        nota: no.valor_de("NOTE").map(str::to_string),
    }
}

/// Tag de evento do GEDCOM → tipo nosso.
fn tipo_do_evento(tag: &str) -> Option<&'static str> {
    Some(match tag {
        "BIRT" => tipos::NASCIMENTO,
        "BAPM" | "CHR" => tipos::BATISMO,
        "DEAT" => tipos::FALECIMENTO,
        "BURI" => tipos::SEPULTAMENTO,
        "MARR" => tipos::CASAMENTO,
        _ => return None,
    })
}

fn ler_indi(r: &Registro) -> IndiLido {
    let mut nome = "Sem nome".to_string();
    let mut sobrenome = None;
    let mut apelidos = Vec::new();
    let mut outros_nomes = Vec::new();

    for (i, n) in r.no.todos("NAME").enumerate() {
        let (dado, sn) = partir_nome(&n.valor);
        // O primeiro NAME é o nome de exibição; os demais entram como nomes ao
        // longo da vida, que é a fatia 02.
        if i == 0 {
            nome = dado;
            sobrenome = sn;
        } else {
            let tipo = tipo_de_nome_nosso(n.valor_de("TYPE").unwrap_or(""));
            outros_nomes.push((dado, sn, tipo.to_string()));
        }
        for apelido in n.todos("NICK") {
            let a = apelido.valor.trim();
            if !a.is_empty() {
                apelidos.push(a.to_string());
            }
        }
    }

    // NICK direto sob INDI é forma inválida no 7.0, mas arquivo de terceiro a
    // usa. Ler o que não se escreve é o certo aqui: ser tolerante ao ler,
    // estrito ao escrever.
    for apelido in r.no.todos("NICK") {
        let a = apelido.valor.trim();
        if !a.is_empty() {
            apelidos.push(a.to_string());
        }
    }

    let sexo = match r.no.valor_de("SEX").unwrap_or("").to_ascii_uppercase().as_str() {
        "M" => "M",
        "F" => "F",
        "X" => "X",
        // Ausente ou fora da lista vira `U`, que é o valor do desconhecido — e
        // cabe nos dois slots, então não impede nenhuma união.
        _ => "U",
    }
    .to_string();

    let mut eventos = Vec::new();
    let mut is_vivo = true;
    for filho in &r.no.filhos {
        if let Some(tipo) = tipo_do_evento(&filho.tag) {
            if tipo == tipos::CASAMENTO {
                continue; // casamento é da união, não da pessoa
            }
            if tipo == tipos::FALECIMENTO || tipo == tipos::SEPULTAMENTO {
                is_vivo = false;
            }
            eventos.push(evento_do_no(filho, tipo));
        }
    }

    let mut atributos = Vec::new();
    for (tag, lista) in [
        ("RELI", "religiao"),
        ("EDUC", "escolaridade"),
        ("OCCU", "profissao"),
        ("NATI", "nacionalidade"),
        ("_LANG", "idioma"),
    ] {
        for n in r.no.todos(tag) {
            let v = n.valor.trim();
            if !v.is_empty() {
                atributos.push((lista, v.to_string()));
            }
        }
    }

    let famc = r
        .no
        .todos("FAMC")
        .filter_map(|n| {
            let alvo = n.valor.trim().trim_matches('@');
            (!alvo.is_empty()).then(|| (alvo.to_string(), vinculo_do_pedi(n)))
        })
        .collect();

    IndiLido {
        xref: r.xref.clone(),
        nome,
        sobrenome,
        sexo,
        apelidos,
        outros_nomes,
        eventos,
        atributos,
        nota: r.no.valor_de("NOTE").map(str::to_string),
        famc,
        is_vivo,
    }
}

fn ler_fam(r: &Registro) -> FamLido {
    let ponteiro = |tag: &str| {
        r.no
            .valor_de(tag)
            .map(|v| v.trim_matches('@').to_string())
            .filter(|v| !v.is_empty())
    };

    let eventos = r
        .no
        .filhos
        .iter()
        .filter_map(|f| tipo_do_evento(&f.tag).map(|t| evento_do_no(f, t)))
        .collect();

    FamLido {
        xref: r.xref.clone(),
        husb: ponteiro("HUSB"),
        wife: ponteiro("WIFE"),
        chil: r
            .no
            .todos("CHIL")
            .filter_map(|n| {
                let v = n.valor.trim().trim_matches('@');
                (!v.is_empty()).then(|| v.to_string())
            })
            .collect(),
        eventos,
    }
}

// ---------------------------------------------------------------------------
// Análise
// ---------------------------------------------------------------------------

#[derive(Debug, Serialize)]
pub struct OpcaoConflito {
    pub valor: String,
    pub rotulo: String,
}

#[derive(Debug, Serialize)]
pub struct Conflito {
    /// Chave estável dentro do arquivo — é por ela que a decisão volta.
    pub id: String,
    pub tipo: String,
    pub titulo: String,
    pub explicacao: String,
    pub opcoes: Vec<OpcaoConflito>,
    pub padrao: String,
}

#[derive(Debug, Serialize)]
pub struct AnalisePrevia {
    pub codificacao: String,
    pub versao: String,
    pub pessoas: usize,
    pub unioes: usize,
    pub conflitos: Vec<Conflito>,
    pub avisos: Vec<String>,
}

pub struct Lido {
    pub indis: Vec<IndiLido>,
    pub fams: Vec<FamLido>,
    pub codificacao: String,
    pub versao: String,
}

/// Lê os bytes de um arquivo GEDCOM até o modelo em memória.
pub fn ler(bytes: &[u8]) -> Resultado<Lido> {
    let (texto, codificacao) = lexico::decodificar(bytes);
    let linhas = lexico::analisar(&texto)?;
    let versao = lexico::versao(&linhas);
    let registros = montar_registros(&linhas);

    let mut indis = Vec::new();
    let mut fams = Vec::new();
    for r in &registros {
        match r.tag.as_str() {
            "INDI" if !r.xref.is_empty() => indis.push(ler_indi(r)),
            "FAM" if !r.xref.is_empty() => fams.push(ler_fam(r)),
            _ => {}
        }
    }

    if indis.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "arquivo".into(),
            valor: "nenhuma pessoa (INDI) encontrada".into(),
        });
    }

    Ok(Lido { indis, fams, codificacao: codificacao.into(), versao })
}

fn nome_de(indis: &HashMap<String, &IndiLido>, xref: &str) -> String {
    indis.get(xref).map(|i| i.exibicao()).unwrap_or_else(|| format!("@{xref}@"))
}

fn rotulo_da_familia(indis: &HashMap<String, &IndiLido>, f: &FamLido) -> String {
    match (&f.husb, &f.wife) {
        (Some(h), Some(w)) => format!("{} e {}", nome_de(indis, h), nome_de(indis, w)),
        (Some(h), None) => nome_de(indis, h),
        (None, Some(w)) => nome_de(indis, w),
        (None, None) => "família sem pais nomeados".into(),
    }
}

/// Percorre o grafo de filiação procurando ciclo.
///
/// Feito em memória, sobre o arquivo, e não a cada `INSERT`: aqui o grafo
/// inteiro é conhecido de antemão, o que torna a checagem exata e barata. É a
/// invariante 4, garantida antes de a primeira linha ser gravada.
fn detectar_ciclos(indis: &[IndiLido], fams: &HashMap<String, &FamLido>) -> Vec<String> {
    let mut pais: HashMap<&str, Vec<&str>> = HashMap::new();
    for i in indis {
        let mut lista = Vec::new();
        for (fam_xref, _) in &i.famc {
            if let Some(f) = fams.get(fam_xref.as_str()) {
                if let Some(h) = &f.husb {
                    lista.push(h.as_str());
                }
                if let Some(w) = &f.wife {
                    lista.push(w.as_str());
                }
            }
        }
        pais.insert(i.xref.as_str(), lista);
    }

    let mut em_ciclo = Vec::new();
    for i in indis {
        let mut vistos: HashSet<&str> = HashSet::new();
        let mut pilha = vec![i.xref.as_str()];
        let mut achou = false;

        while let Some(atual) = pilha.pop() {
            for p in pais.get(atual).into_iter().flatten() {
                if *p == i.xref.as_str() {
                    achou = true;
                    break;
                }
                if vistos.insert(p) {
                    pilha.push(p);
                }
            }
            if achou {
                break;
            }
        }
        if achou {
            em_ciclo.push(i.xref.clone());
        }
    }
    em_ciclo
}

/// Monta a lista de perguntas. **Não escreve nada.**
pub fn analisar(lido: &Lido) -> AnalisePrevia {
    let indis: HashMap<String, &IndiLido> =
        lido.indis.iter().map(|i| (i.xref.clone(), i)).collect();
    let fams: HashMap<String, &FamLido> = lido.fams.iter().map(|f| (f.xref.clone(), f)).collect();

    let mut conflitos = Vec::new();
    let mut avisos = Vec::new();

    // ---- Invariante 1: no máximo uma união como filho ----
    for i in &lido.indis {
        if i.famc.len() > 1 {
            conflitos.push(Conflito {
                id: format!("famc:{}", i.xref),
                tipo: "varios_famc".into(),
                titulo: format!("{} aparece como filho de mais de uma família", i.exibicao()),
                explicacao: "Uma pessoa pertence a no máximo uma união como filho. \
                             As demais viram anotação na ficha, sem se perder."
                    .into(),
                opcoes: i
                    .famc
                    .iter()
                    .filter_map(|(fx, _)| {
                        fams.get(fx.as_str()).map(|f| OpcaoConflito {
                            valor: fx.clone(),
                            rotulo: rotulo_da_familia(&indis, f),
                        })
                    })
                    .collect(),
                padrao: i.famc[0].0.clone(),
            });
        }
    }

    // ---- Invariante 2: um slot masculino e um feminino ----
    for f in &lido.fams {
        let sexo_de = |x: &Option<String>| {
            x.as_ref()
                .and_then(|x| indis.get(x.as_str()))
                .map(|i| i.sexo.as_str())
        };
        let h_cabe = sexo_de(&f.husb).map(|s| sexo_cabe_no_slot(s, Slot::Masculino));
        let w_cabe = sexo_de(&f.wife).map(|s| sexo_cabe_no_slot(s, Slot::Feminino));

        if f.husb.is_none() && f.wife.is_none() {
            if f.chil.is_empty() {
                avisos.push(format!(
                    "A família @{}@ não tem pais nem filhos e foi ignorada.",
                    f.xref
                ));
            } else {
                conflitos.push(Conflito {
                    id: format!("vazia:{}", f.xref),
                    tipo: "uniao_vazia".into(),
                    titulo: format!(
                        "Uma família com {} filho(s) não nomeia nenhum dos pais",
                        f.chil.len()
                    ),
                    explicacao: "Slot sem nome nunca fica vazio aqui: recebe um \
                                 \"desconhecido\", que você identifica depois sem \
                                 perder os filhos pendurados nele."
                        .into(),
                    opcoes: vec![
                        OpcaoConflito { valor: "criar".into(), rotulo: "Criar pai e mãe desconhecidos".into() },
                        OpcaoConflito { valor: "descartar".into(), rotulo: "Descartar esta família".into() },
                    ],
                    padrao: "criar".into(),
                });
            }
            continue;
        }

        let troca_resolve = match (sexo_de(&f.husb), sexo_de(&f.wife)) {
            (Some(h), Some(w)) => {
                sexo_cabe_no_slot(h, Slot::Feminino) && sexo_cabe_no_slot(w, Slot::Masculino)
            }
            _ => false,
        };

        if h_cabe == Some(false) || w_cabe == Some(false) {
            let a = f.husb.clone().unwrap_or_default();
            let b = f.wife.clone().unwrap_or_default();
            let mut opcoes = Vec::new();
            if troca_resolve {
                opcoes.push(OpcaoConflito {
                    valor: "trocar".into(),
                    rotulo: "Trocar os lados — os dois cabem, invertidos".into(),
                });
            }
            if !a.is_empty() {
                opcoes.push(OpcaoConflito {
                    valor: format!("manter:{a}"),
                    rotulo: format!("Manter {} e deixar o outro lado desconhecido", nome_de(&indis, &a)),
                });
            }
            if !b.is_empty() {
                opcoes.push(OpcaoConflito {
                    valor: format!("manter:{b}"),
                    rotulo: format!("Manter {} e deixar o outro lado desconhecido", nome_de(&indis, &b)),
                });
            }
            opcoes.push(OpcaoConflito {
                valor: "descartar".into(),
                rotulo: "Descartar esta união (os filhos ficam sem pais)".into(),
            });

            let padrao = if troca_resolve {
                "trocar".to_string()
            } else {
                opcoes[0].valor.clone()
            };

            conflitos.push(Conflito {
                id: format!("slot:{}", f.xref),
                tipo: "slot_incompativel".into(),
                titulo: format!("A união de {} não cabe nos dois slots", rotulo_da_familia(&indis, f)),
                explicacao: "Toda união aqui tem exatamente um slot masculino e um \
                             feminino. É invariante do acervo, e não se afrouxa na \
                             importação."
                    .into(),
                opcoes,
                padrao,
            });
        }
    }

    // ---- Invariante 4: aciclia ----
    for xref in detectar_ciclos(&lido.indis, &fams) {
        let i = indis.get(xref.as_str());
        let nome = i.map(|i| i.exibicao()).unwrap_or_else(|| xref.clone());
        let opcoes = i
            .map(|i| {
                i.famc
                    .iter()
                    .filter_map(|(fx, _)| {
                        fams.get(fx.as_str()).map(|f| OpcaoConflito {
                            valor: fx.clone(),
                            rotulo: format!("Romper a ligação com {}", rotulo_da_familia(&indis, f)),
                        })
                    })
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default();

        conflitos.push(Conflito {
            id: format!("ciclo:{xref}"),
            tipo: "ciclo".into(),
            titulo: format!("{nome} é ancestral de si mesmo no arquivo"),
            explicacao: "O arquivo descreve um laço no grafo — alguém que desce até \
                         o próprio ancestral. Uma das ligações precisa cair."
                .into(),
            padrao: opcoes.first().map(|o| o.valor.clone()).unwrap_or_default(),
            opcoes,
        });
    }

    AnalisePrevia {
        codificacao: lido.codificacao.clone(),
        versao: lido.versao.clone(),
        pessoas: lido.indis.len(),
        unioes: lido.fams.len(),
        conflitos,
        avisos,
    }
}

// ---------------------------------------------------------------------------
// Aplicação
// ---------------------------------------------------------------------------

#[derive(Debug, Default, Serialize)]
pub struct ResumoImportacao {
    pub pessoas: usize,
    pub unioes: usize,
    pub filhos: usize,
    pub placeholders: usize,
    pub eventos: usize,
    pub nomes: usize,
    pub atributos: usize,
    pub descartados: Vec<String>,
}

#[derive(Debug, Default, Deserialize)]
pub struct Decisoes(pub HashMap<String, String>);

impl Decisoes {
    fn de(&self, conflito: &str, padrao: &str) -> String {
        self.0.get(conflito).cloned().unwrap_or_else(|| padrao.to_string())
    }
}

/// Grava o que foi lido, respeitando as decisões. Tudo ou nada.
pub async fn aplicar(
    pool: &SqlitePool,
    lido: &Lido,
    decisoes: &Decisoes,
) -> Resultado<ResumoImportacao> {
    let analise = analisar(lido);
    let padroes: HashMap<&str, &str> = analise
        .conflitos
        .iter()
        .map(|c| (c.id.as_str(), c.padrao.as_str()))
        .collect();
    let escolha = |id: &str| decisoes.de(id, padroes.get(id).copied().unwrap_or(""));

    let mut resumo = ResumoImportacao::default();
    let mut tx = pool.begin().await?;

    // ---- 1. As pessoas ----
    let mut ids: HashMap<&str, String> = HashMap::new();
    for i in &lido.indis {
        let id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder)
             VALUES (?, ?, ?, ?, ?, ?, 0)",
        )
        .bind(&id)
        .bind(&i.nome)
        .bind(&i.sobrenome)
        .bind(&i.sexo)
        .bind(&i.nota)
        .bind(i.is_vivo)
        .execute(&mut *tx)
        .await?;

        ids.insert(i.xref.as_str(), id.clone());
        resumo.pessoas += 1;

        for e in &i.eventos {
            gravar_evento(&mut tx, Some(&id), None, e).await?;
            resumo.eventos += 1;
        }
        for (nome, sobrenome, tipo) in &i.outros_nomes {
            sqlx::query(
                "INSERT INTO nomes_pessoa (id, pessoa_id, nome, sobrenome, tipo)
                 VALUES (?, ?, ?, ?, ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&id)
            .bind(nome)
            .bind(sobrenome)
            .bind(tipo)
            .execute(&mut *tx)
            .await?;
            resumo.nomes += 1;
        }
        for apelido in &i.apelidos {
            sqlx::query("INSERT INTO apelidos_pessoa (id, pessoa_id, apelido) VALUES (?, ?, ?)")
                .bind(Uuid::new_v4().to_string())
                .bind(&id)
                .bind(apelido)
                .execute(&mut *tx)
                .await?;
            resumo.atributos += 1;
        }
        for (lista, valor) in &i.atributos {
            match gravar_atributo(&mut tx, &id, lista, valor).await? {
                None => resumo.atributos += 1,
                Some(aviso) => resumo.descartados.push(aviso),
            }
        }
    }

    // ---- 2. As uniões ----
    let mut unioes: HashMap<&str, String> = HashMap::new();
    for f in &lido.fams {
        if f.husb.is_none() && f.wife.is_none() {
            if f.chil.is_empty() {
                continue;
            }
            if escolha(&format!("vazia:{}", f.xref)) == "descartar" {
                resumo
                    .descartados
                    .push(format!("União @{}@ descartada por escolha sua.", f.xref));
                continue;
            }
        }

        let mut masculino = f.husb.clone();
        let mut feminino = f.wife.clone();

        let sexo_de = |x: &Option<String>| {
            x.as_ref()
                .and_then(|x| lido.indis.iter().find(|i| &i.xref == x))
                .map(|i| i.sexo.clone())
        };
        let cabe = |x: &Option<String>, slot: Slot| match sexo_de(x) {
            Some(s) => sexo_cabe_no_slot(&s, slot),
            None => true,
        };

        if !cabe(&masculino, Slot::Masculino) || !cabe(&feminino, Slot::Feminino) {
            match escolha(&format!("slot:{}", f.xref)).as_str() {
                "descartar" => {
                    resumo
                        .descartados
                        .push(format!("União @{}@ descartada por escolha sua.", f.xref));
                    continue;
                }
                "trocar" => std::mem::swap(&mut masculino, &mut feminino),
                outro => {
                    let manter = outro.strip_prefix("manter:").unwrap_or("");
                    let fica = manter.to_string();
                    let sexo = sexo_de(&Some(fica.clone()));
                    // Quem fica vai para o slot que o sexo dele permite; o
                    // outro lado nasce desconhecido.
                    let no_masculino = sexo
                        .as_deref()
                        .map(|s| sexo_cabe_no_slot(s, Slot::Masculino))
                        .unwrap_or(true);
                    if no_masculino {
                        masculino = Some(fica);
                        feminino = None;
                    } else {
                        feminino = Some(fica);
                        masculino = None;
                    }
                    resumo.descartados.push(format!(
                        "Na união @{}@, um dos lados virou desconhecido por escolha sua.",
                        f.xref
                    ));
                }
            }
        }

        let masculino_id = match masculino.as_deref().and_then(|x| ids.get(x)) {
            Some(id) => id.clone(),
            None => {
                resumo.placeholders += 1;
                criar_placeholder(&mut tx, Slot::Masculino).await?
            }
        };
        let feminino_id = match feminino.as_deref().and_then(|x| ids.get(x)) {
            Some(id) => id.clone(),
            None => {
                resumo.placeholders += 1;
                criar_placeholder(&mut tx, Slot::Feminino).await?
            }
        };

        if masculino_id == feminino_id {
            resumo.descartados.push(format!(
                "União @{}@ descartada: os dois lados apontam para a mesma pessoa.",
                f.xref
            ));
            continue;
        }

        let id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES (?, ?, ?, 'casamento')",
        )
        .bind(&id)
        .bind(&masculino_id)
        .bind(&feminino_id)
        .execute(&mut *tx)
        .await?;

        for e in &f.eventos {
            gravar_evento(&mut tx, None, Some(&id), e).await?;
            resumo.eventos += 1;
        }

        unioes.insert(f.xref.as_str(), id);
        resumo.unioes += 1;
    }

    // ---- 3. Os filhos ----
    //
    // Percorrido pelo INDI, não pelo FAM: é o indivíduo que tem no máximo uma
    // união de origem, e é ele quem carrega o `PEDI`.
    let mut ja_filho: HashSet<&str> = HashSet::new();
    for i in &lido.indis {
        if i.famc.is_empty() {
            continue;
        }

        let ciclo = format!("ciclo:{}", i.xref);
        let rompida = if padroes.contains_key(ciclo.as_str()) {
            escolha(&ciclo)
        } else {
            String::new()
        };

        let mut candidatas: Vec<&(String, String)> = i
            .famc
            .iter()
            .filter(|(fx, _)| *fx != rompida)
            .collect();
        if candidatas.is_empty() {
            resumo.descartados.push(format!(
                "{} ficou sem união de origem: a única ligação criava um ciclo.",
                i.exibicao()
            ));
            continue;
        }

        // Vários FAMC: a escolhida fica, as outras viram nota.
        if candidatas.len() > 1 {
            let preferida = escolha(&format!("famc:{}", i.xref));
            if let Some(pos) = candidatas.iter().position(|(fx, _)| *fx == preferida) {
                candidatas.swap(0, pos);
            }
        }

        let (fam_xref, vinculo) = candidatas[0];
        let Some(uniao_id) = unioes.get(fam_xref.as_str()) else {
            continue; // a família foi descartada
        };
        let Some(pessoa_id) = ids.get(i.xref.as_str()) else { continue };

        if !ja_filho.insert(i.xref.as_str()) {
            continue;
        }

        let vinculo = if validar_tipo_vinculo(vinculo).is_ok() { vinculo.as_str() } else { "biologico" };

        let ordem: i64 = sqlx::query_scalar(
            "SELECT COALESCE(MAX(ordem), 0) + 1 FROM uniao_filhos WHERE uniao_id = ?",
        )
        .bind(uniao_id)
        .fetch_one(&mut *tx)
        .await?;

        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES (?, ?, ?, ?)",
        )
        .bind(uniao_id)
        .bind(pessoa_id)
        .bind(vinculo)
        .bind(ordem)
        .execute(&mut *tx)
        .await?;
        resumo.filhos += 1;

        for (fx, _) in candidatas.iter().skip(1) {
            resumo.descartados.push(format!(
                "{} também constava como filho da família @{}@; a ligação virou anotação.",
                i.exibicao(),
                fx
            ));
        }
    }

    tx.commit().await?;
    Ok(resumo)
}

async fn criar_placeholder(
    tx: &mut sqlx::Transaction<'_, sqlx::Sqlite>,
    slot: Slot,
) -> Resultado<String> {
    let id = Uuid::new_v4().to_string();
    sqlx::query(
        "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
         VALUES (?, ?, NULL, ?, 0, 1)",
    )
    .bind(&id)
    .bind(slot.nome_placeholder())
    .bind(slot.sexo_padrao())
    .execute(&mut **tx)
    .await?;
    Ok(id)
}

async fn gravar_evento(
    tx: &mut sqlx::Transaction<'_, sqlx::Sqlite>,
    pessoa_id: Option<&str>,
    uniao_id: Option<&str>,
    e: &EventoLido,
) -> Resultado<()> {
    let interpretada = datas::a_partir_da_escolha(&e.data);
    let texto = if e.tem_data {
        let composto = datas::compor_texto(&e.data);
        if composto.is_empty() { None } else { Some(composto) }
    } else {
        None
    };

    sqlx::query(
        "INSERT INTO eventos
           (id, pessoa_id, uniao_id, tipo_evento, data_texto, data_qualificador,
            ano_inicio, ano_fim, dia_inicio, mes_inicio, rotulo_historico_livre, nota)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(Uuid::new_v4().to_string())
    .bind(pessoa_id)
    .bind(uniao_id)
    .bind(&e.tipo)
    .bind(texto)
    .bind(interpretada.qualificador.como_str())
    .bind(interpretada.ano_inicio)
    .bind(interpretada.ano_fim)
    .bind(interpretada.dia_inicio)
    .bind(interpretada.mes_inicio)
    // O PLAC do arquivo entra como rótulo histórico, não como município: casar
    // "São Paulo" com o IBGE é problema de mesclagem, que a fatia 09 deixa
    // explicitamente de fora. O texto do outro programa fica intacto.
    .bind(&e.local)
    .bind(&e.nota)
    .execute(&mut **tx)
    .await?;
    Ok(())
}

/// Grava um atributo de vida, ou diz por que não deu.
///
/// A nacionalidade é o caso diferente: as outras listas guardam texto livre,
/// mas `nacionalidades_pessoa` aponta para a tabela de países. Um `NATI` que
/// não casa com nenhum país conhecido **não é inventado** — vira aviso. Criar
/// país a partir de string de arquivo alheio encheria a tabela de referência
/// com "Brasil", "BRASIL" e "Brazil" como três países diferentes.
async fn gravar_atributo(
    tx: &mut sqlx::Transaction<'_, sqlx::Sqlite>,
    pessoa_id: &str,
    lista: &str,
    valor: &str,
) -> Resultado<Option<String>> {
    if lista == "nacionalidade" {
        let coluna = sem_acento_sql("nome");
        let pais: Option<String> = sqlx::query_scalar(&format!(
            "SELECT id FROM paises WHERE {coluna} = ? LIMIT 1"
        ))
        .bind(normalizar_busca(valor))
        .fetch_optional(&mut **tx)
        .await?;

        let Some(pais_id) = pais else {
            return Ok(Some(format!(
                "Nacionalidade \"{valor}\" não corresponde a nenhum país da lista e ficou de fora."
            )));
        };

        sqlx::query("INSERT INTO nacionalidades_pessoa (id, pessoa_id, pais_id) VALUES (?, ?, ?)")
            .bind(Uuid::new_v4().to_string())
            .bind(pessoa_id)
            .bind(pais_id)
            .execute(&mut **tx)
            .await?;
        return Ok(None);
    }

    let sql = match lista {
        "religiao" => "INSERT INTO religioes_pessoa (id, pessoa_id, denominacao) VALUES (?, ?, ?)",
        "escolaridade" => "INSERT INTO escolaridade_pessoa (id, pessoa_id, nivel) VALUES (?, ?, ?)",
        "profissao" => "INSERT INTO profissoes_pessoa (id, pessoa_id, ocupacao) VALUES (?, ?, ?)",
        "idioma" => "INSERT INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES (?, ?, ?)",
        _ => return Ok(None),
    };

    sqlx::query(sql)
        .bind(Uuid::new_v4().to_string())
        .bind(pessoa_id)
        .bind(valor)
        .execute(&mut **tx)
        .await?;
    Ok(None)
}
