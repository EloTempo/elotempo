//! Algoritmos clássicos de Machine Learning e NLP em Rust puro para apoiar a LLM local:
//!
//! 1. **Similaridade de Jaro-Winkler (`jaro_winkler`)**: Record Linkage e desambiguação
//!    de nomes próprios com tolerância a variações de grafia.
//! 2. **Tokenização Sem-Acento e Pontuação Léxica (BM25 simplificado)**: Ranqueamento
//!    determinístico de documentos/registros do banco contra a consulta do usuário.
//! 3. **Portão de Abstenção (`PortaoAbstencao`)**: Impede respostas quando nem o banco
//!    de dados nem o texto fornecido no chat possuem evidências sobre o tema perguntado.
//! 4. **Extrator Gramatical / Pré-Anotador NER (`extrair_arvore_de_texto` e `extrair_linha_tempo_de_texto`)**:
//!    Identifica pessoas, datas (nascimentos, falecimentos, intervalos `1839-1908`),
//!    casamentos e filhos diretamente de textos biográficos em português.
//! 5. **Verificador Anti-Alucinação `"Quote-and-Verify"` (`auditar_ancoragem_arvore`, `auditar_ancoragem_linha_tempo`)**:
//!    Exige que todo nome e ano gerado pela LLM exista literalmente no texto-fonte do usuário,
//!    expurgando qualquer dado alucinado e validando invariantes cronológicas e anticiclo.

use std::collections::{HashMap, HashSet};
use crate::domain::texto::sem_acento;
use super::{
    ItemMarcoProposto, ItemPessoaProposta, ItemUniaoProposta, PropostaCriarArvore,
    PropostaCriarLinhaTempo,
};

/// Stopwords comuns do português que não devem contar como evidência temática isolada.
const STOPWORDS_PT: &[&str] = &[
    "a", "as", "o", "os", "um", "uma", "uns", "umas", "de", "do", "da", "dos", "das",
    "em", "no", "na", "nos", "nas", "por", "pelo", "pela", "pelos", "pelas", "para",
    "com", "sem", "sob", "sobre", "entre", "ate", "apos", "ante", "contra", "desde",
    "e", "ou", "mas", "nem", "que", "se", "como", "quando", "onde", "quem", "qual",
    "quais", "quanto", "quantos", "quantas", "foi", "foram", "era", "eram", "ser",
    "estar", "esta", "estao", "estava", "estavam", "teve", "tiveram", "tem", "tinha",
    "tinham", "ha", "houve", "fale", "conte", "diga", "me", "sobre", "vida", "historia",
    "pessoa", "pessoas", "familia", "arvore", "genealogica", "linha", "tempo", "criar",
    "crie", "monte", "montar", "fazer", "faca", "adicionar", "adicione", "existiu",
    "existe", "aconteceu", "acontecimentos", "fatos", "dados", "banco", "acervo",
    "filho", "filha", "filhos", "filhas", "pai", "mae", "pais", "avo", "avos",
    "neto", "neta", "netos", "irmão", "irmao", "irma", "irmaos", "conjuge", "esposa",
    "esposo", "marido", "mulher", "casou", "nasceu", "morreu", "faleceu", "vivia",
    "viviam", "vivos", "vivo", "viva", "ano", "anos", "seculo", "data", "datas",
];

/// Calcula a similaridade de Jaro entre duas strings normalizadas (intervalo `[0.0, 1.0]`).
pub fn jaro(s1: &str, s2: &str) -> f64 {
    let a: Vec<char> = sem_acento(s1).chars().collect();
    let b: Vec<char> = sem_acento(s2).chars().collect();

    if a.is_empty() && b.is_empty() {
        return 1.0;
    }
    if a.is_empty() || b.is_empty() {
        return 0.0;
    }
    if a == b {
        return 1.0;
    }

    let len_a = a.len();
    let len_b = b.len();
    let max_dist = (len_a.max(len_b) / 2).saturating_sub(1);

    let mut a_matches = vec![false; len_a];
    let mut b_matches = vec![false; len_b];

    let mut matches = 0usize;
    for i in 0..len_a {
        let start = i.saturating_sub(max_dist);
        let end = (i + max_dist + 1).min(len_b);
        for j in start..end {
            if b_matches[j] || a[i] != b[j] {
                continue;
            }
            a_matches[i] = true;
            b_matches[j] = true;
            matches += 1;
            break;
        }
    }

    if matches == 0 {
        return 0.0;
    }

    let mut transpositions = 0usize;
    let mut k = 0usize;
    for i in 0..len_a {
        if !a_matches[i] {
            continue;
        }
        while !b_matches[k] {
            k += 1;
        }
        if a[i] != b[k] {
            transpositions += 1;
        }
        k += 1;
    }

    let m = matches as f64;
    ((m / len_a as f64) + (m / len_b as f64) + ((m - (transpositions as f64 / 2.0)) / m)) / 3.0
}

/// Calcula a similaridade de Jaro-Winkler (`[0.0, 1.0]`), privilegiando prefixos comuns
/// (ideal para nomes próprios em genealogia).
pub fn jaro_winkler(s1: &str, s2: &str) -> f64 {
    let j = jaro(s1, s2);
    if j <= 0.7 {
        return j;
    }
    let a: Vec<char> = sem_acento(s1).chars().collect();
    let b: Vec<char> = sem_acento(s2).chars().collect();
    let prefix = a
        .iter()
        .zip(b.iter())
        .take(4)
        .take_while(|(ca, cb)| ca == cb)
        .count() as f64;

    (j + prefix * 0.1 * (1.0 - j)).min(1.0)
}

/// Extrai tokens significativos (sem acento, minúsculos, sem stopwords curtas) de um texto.
pub fn tokenizar_significativo(texto: &str) -> Vec<String> {
    let norm = sem_acento(texto);
    let stop: HashSet<&str> = STOPWORDS_PT.iter().copied().collect();

    norm.split(|c: char| !c.is_alphanumeric())
        .map(str::trim)
        .filter(|t| t.len() >= 2 && !stop.contains(t))
        .map(String::from)
        .collect()
}

/// Extrai todos os anos numéricos mencionados em um texto (suporta anos a.C. e d.C.).
pub fn extrair_anos_do_texto(texto: &str) -> Vec<i64> {
    let norm = sem_acento(texto);
    let mut anos = Vec::new();
    let tokens: Vec<&str> = norm
        .split(|c: char| !c.is_ascii_digit() && c != '-')
        .filter(|s| !s.is_empty())
        .collect();

    for (idx, tok) in tokens.iter().enumerate() {
        // Verifica intervalos como "1839-1908"
        if tok.contains('-') && !tok.starts_with('-') {
            for parte in tok.split('-') {
                if let Ok(ano) = parte.parse::<i64>() {
                    if (1..=2100).contains(&ano) {
                        anos.push(ano);
                    }
                }
            }
            continue;
        }
        if let Ok(mut ano) = tok.parse::<i64>() {
            if (-4000..=2100).contains(&ano) && ano != 0 {
                // Verifica se logo após no texto original há menção a "a.c"
                if ano > 0 && idx + 1 < tokens.len() {
                    let sufixo_busca = format!("{} a.c", ano);
                    if norm.contains(&sufixo_busca) || norm.contains(&format!("{} ac", ano)) {
                        ano = -ano;
                    }
                }
                anos.push(ano);
            }
        }
    }
    anos.sort();
    anos.dedup();
    anos
}

/// Classificação da intenção do usuário no Assistente IA.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IntencaoUsuario {
    CriarArvoreDeTexto,
    CriarLinhaTempoDeTexto,
    ConsultarAcervo,
}

/// Classifica deterministicamente a intenção da mensagem do usuário.
pub fn classificar_intencao(mensagem: &str) -> IntencaoUsuario {
    let norm = sem_acento(mensagem);

    let pede_criacao = norm.contains("crie ")
        || norm.contains("criar ")
        || norm.contains("monte ")
        || norm.contains("montar ")
        || norm.contains("gere ")
        || norm.contains("gerar ")
        || norm.contains("extraia ")
        || norm.contains("extrair ")
        || norm.contains("construa ")
        || norm.contains("faca uma ")
        || norm.contains("nova arvore")
        || norm.contains("nova linha do tempo");

    if pede_criacao {
        if norm.contains("linha do tempo")
            || norm.contains("cronologia")
            || norm.contains("marcos historicos")
        {
            return IntencaoUsuario::CriarLinhaTempoDeTexto;
        }
        if norm.contains("arvore")
            || norm.contains("genealogia")
            || norm.contains("familia")
            || norm.contains("linhagem")
        {
            return IntencaoUsuario::CriarArvoreDeTexto;
        }
    }

    IntencaoUsuario::ConsultarAcervo
}

/// Resultado da avaliação do Portão de Abstenção.
#[derive(Debug, Clone)]
pub struct DecisaoAbstencao {
    pub deve_abster: bool,
    pub confianca_maxima: f64,
    pub motivo: Option<String>,
}

/// Avalia se o Assistente possui evidências suficientes no banco (ou no próprio texto do chat)
/// para responder à pergunta sem inventar informações externas.
pub fn avaliar_portao_abstencao(
    pergunta: &str,
    melhor_score_banco: f64,
    total_fatos_recuperados: usize,
) -> DecisaoAbstencao {
    let tokens = tokenizar_significativo(pergunta);
    let anos = extrair_anos_do_texto(pergunta);

    // Perguntas gerais sobre estatísticas do próprio acervo ("quantas árvores existem?", "resumo do acervo")
    let norm = sem_acento(pergunta);
    let pergunta_global_acervo = norm.contains("quantas pessoas")
        || norm.contains("quantas arvores")
        || norm.contains("estatisticas")
        || norm.contains("resumo do acervo")
        || norm.contains("total de pessoas");

    if pergunta_global_acervo {
        return DecisaoAbstencao {
            deve_abster: false,
            confianca_maxima: 1.0,
            motivo: None,
        };
    }

    // Se o usuário perguntou sobre um ano específico e encontramos pessoas vivas ou marcos naquele ano
    if !anos.is_empty() && total_fatos_recuperados > 0 && melhor_score_banco >= 0.55 {
        return DecisaoAbstencao {
            deve_abster: false,
            confianca_maxima: melhor_score_banco,
            motivo: None,
        };
    }

    // Limiar estrito para perguntas sobre entidades/pessoas/acontecimentos:
    // Se não houver nenhum registro com score >= 0.65 (ou se zero fatos foram recuperados),
    // aciona o Portão de Abstenção.
    if total_fatos_recuperados == 0 || melhor_score_banco < 0.65 || (tokens.is_empty() && anos.is_empty()) {
        return DecisaoAbstencao {
            deve_abster: true,
            confianca_maxima: melhor_score_banco,
            motivo: Some(
                "Não encontrei informações sobre essa pessoa, família ou acontecimento no banco de dados do EloTempo nem nos dados enviados nesta conversa. \
                 Por segurança e compromisso com a precisão histórica, este assistente responde exclusivamente com base nos registros do seu acervo ou em textos que você fornecer aqui no chat."
                    .to_string(),
            ),
        };
    }

    DecisaoAbstencao {
        deve_abster: false,
        confianca_maxima: melhor_score_banco,
        motivo: None,
    }
}


// ============================================================================
// EXTRATOR DETERMINÍSTICO / PRÉ-ANOTADOR NER DE ÁRVORES E LINHAS DO TEMPO
// ============================================================================

/// Infere o sexo provável (`"M"` ou `"F"`) a partir do primeiro nome em português ou palavras de contexto.
pub fn inferir_sexo_nome(nome_completo: &str, contexto: &str) -> String {
    let ctx = sem_acento(contexto);
    let nome_norm = sem_acento(nome_completo);
    let primeiro = nome_norm.split_whitespace().next().unwrap_or("");

    let fem_explicito = [
        "maria", "ana", "anna", "teresa", "tereza", "isabel", "leopoldina", "carlota",
        "vitoria", "elizabeth", "diana", "catherine", "sarah", "marcia", "alzira",
        "veridiana", "helena", "clara", "julia", "laura", "beatriz", "luisa", "luiza",
        "francisca", "januaria", "amalia", "amelia", "rosa", "rita", "joana", "sofia",
        "cecilia", "carolina", "margarida", "catarina", "antonia", "josefa", "gertrudes",
    ];
    let masc_explicito = [
        "joao", "pedro", "jose", "antonio", "carlos", "luis", "luiz", "francisco",
        "miguel", "fernando", "getulio", "juscelino", "machado", "joaquim", "martinho",
        "caio", "giuseppe", "luigi", "marco", "paulo", "roberto", "ricardo", "eduardo",
        "henrique", "afonso", "manuel", "manoel", "sebastiao", "bernardo", "gabriel",
        "rafael", "daniel", "davi", "david", "salomao", "abraao", "isaque", "jaco",
    ];

    if fem_explicito.contains(&primeiro) {
        return "F".to_string();
    }
    if masc_explicito.contains(&primeiro) {
        return "M".to_string();
    }

    if ctx.contains(&format!("esposa {}", nome_norm))
        || ctx.contains(&format!("mae {}", nome_norm))
        || ctx.contains(&format!("filha {}", nome_norm))
        || ctx.contains(&format!("rainha {}", nome_norm))
        || ctx.contains(&format!("princesa {}", nome_norm))
        || ctx.contains(&format!("dona {}", nome_norm))
    {
        return "F".to_string();
    }

    if primeiro.ends_with('a') && !["luca", "nikola", "birajara", "ubirajara"].contains(&primeiro) {
        return "F".to_string();
    }
    "M".to_string()
}

/// Separa um nome completo em `(nome, Option<sobrenome>)`.
pub fn separar_nome_sobrenome(nome_completo: &str) -> (String, Option<String>) {
    let limpo = nome_completo
        .trim()
        .trim_matches(|c: char| c == ',' || c == '.' || c == ';' || c == ':' || c == '"' || c == '\'');
    let partes: Vec<&str> = limpo.split_whitespace().collect();
    if partes.is_empty() {
        return ("Sem Nome".to_string(), None);
    }
    if partes.len() == 1 {
        return (partes[0].to_string(), None);
    }
    // Se começar com D., Dom, Dona, Rei, Rainha, Príncipe, Princesa, mantém título junto ao prenome
    let titulos = ["d.", "dom", "dona", "rei", "rainha", "principe", "princesa", "conde", "condessa", "duque", "barao"];
    let p0_norm = sem_acento(partes[0]);
    if titulos.contains(&p0_norm.as_str()) && partes.len() >= 2 {
        let prenome = format!("{} {}", partes[0], partes[1]);
        if partes.len() == 2 {
            return (prenome, None);
        }
        return (prenome, Some(partes[2..].join(" ")));
    }

    let prenome = partes[0].to_string();
    let sobrenome = partes[1..].join(" ");
    (prenome, Some(sobrenome))
}

/// Extrai datas `(ano_nasc, ano_morte)` próximas a um trecho, como `(1839-1908)`, `(1839)`, `nasceu em 1839`.
fn extrair_datas_biograficas_trecho(trecho: &str) -> (Option<i64>, Option<i64>) {
    let norm = sem_acento(trecho);

    // 1. Procura intervalo explícito tipo "1839-1908" ou "1839–1908" ou "1839 a 1908"
    let limpo_traco = norm.replace('–', "-").replace('—', "-");
    for token in limpo_traco.split(|c: char| !c.is_ascii_digit() && c != '-') {
        if let Some((ini_s, fim_s)) = token.split_once('-') {
            if let (Ok(ini), Ok(fim)) = (ini_s.parse::<i64>(), fim_s.parse::<i64>()) {
                if (1..=2100).contains(&ini) && (1..=2100).contains(&fim) && fim >= ini {
                    return (Some(ini), Some(fim));
                }
            }
        }
    }

    // 2. Procura "nasceu em XXXX" / "nascido em XXXX" e "faleceu em YYYY" / "morreu em YYYY"
    let mut nasc = None;
    let mut morte = None;
    let palavras: Vec<&str> = limpo_traco
        .split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .collect();

    for i in 0..palavras.len() {
        let p = palavras[i];
        if p == "nasceu" || p == "nascido" || p == "nascida" || p == "n" {
            for j in (i + 1)..(i + 5).min(palavras.len()) {
                if let Ok(ano) = palavras[j].parse::<i64>() {
                    if (1..=2100).contains(&ano) {
                        nasc = Some(ano);
                        break;
                    }
                }
            }
        } else if p == "faleceu" || p == "falecido" || p == "falecida" || p == "morreu" || p == "morta" || p == "morto" {
            for j in (i + 1)..(i + 5).min(palavras.len()) {
                if let Ok(ano) = palavras[j].parse::<i64>() {
                    if (1..=2100).contains(&ano) {
                        morte = Some(ano);
                        break;
                    }
                }
            }
        }
    }

    if nasc.is_some() || morte.is_some() {
        return (nasc, morte);
    }

    // 3. Se houver um ano entre parênteses como "Luigi (1906)"
    if let Some(ab) = limpo_traco.find('(') {
        if let Some(fe) = limpo_traco[ab..].find(')') {
            let dentro = &limpo_traco[ab + 1..ab + fe];
            for tok in dentro.split(|c: char| !c.is_ascii_digit()) {
                if let Ok(ano) = tok.parse::<i64>() {
                    if (1..=2100).contains(&ano) {
                        return (Some(ano), None);
                    }
                }
            }
        }
    }

    (None, None)
}

/// Extrai candidatos de nomes próprios capitalizados em português (ex.: "Giuseppe Rossi", "Maria Leopoldina").
fn extrair_nomes_proprios_com_contexto(texto: &str) -> Vec<(String, String)> {
    let ignorar_inicio = [
        "Crie", "Criar", "Monte", "Montar", "Gere", "Gerar", "Arvore", "Árvore", "Familia",
        "Família", "Linha", "Tempo", "Em", "No", "Na", "Nos", "Nas", "De", "Do", "Da",
        "Dos", "Das", "Seu", "Sua", "Seus", "Suas", "Meus", "Meu", "Minha", "Ele", "Ela",
        "Eles", "Elas", "Tiveram", "Teve", "Casou", "Casaram", "Nasceu", "Faleceu", "Morreu",
        "Filho", "Filha", "Filhos", "Filhas", "Pai", "Mãe", "Mae", "Pais", "Historia",
        "História", "Brasil", "Portugal", "Italia", "Itália", "Genova", "Gênova", "Rio",
        "Janeiro", "Sao", "São", "Lisboa", "Paris", "Londres", "Alemanha", "Espanha",
    ];
    let conectores = ["de", "da", "do", "dos", "das", "e"];

    let mut resultados: Vec<(String, String)> = Vec::new();
    let mut vistos: HashSet<String> = HashSet::new();

    // Divide em sentenças ou cláusulas mantendo contexto
    for sentenca in texto.split(|c| c == '.' || c == '\n' || c == ';') {
        let sentenca_trim = sentenca.trim();
        if sentenca_trim.is_empty() {
            continue;
        }

        let tokens_brutos: Vec<&str> = sentenca_trim.split_whitespace().collect();
        let mut i = 0;
        while i < tokens_brutos.len() {
            let limpo = tokens_brutos[i].trim_matches(|c: char| !c.is_alphabetic());
            let primeira_maiuscula = limpo
                .chars()
                .next()
                .map(|c| c.is_uppercase())
                .unwrap_or(false);

            if primeira_maiuscula && limpo.len() >= 2 && !ignorar_inicio.contains(&limpo) {
                let mut partes_nome = vec![limpo.to_string()];
                let mut j = i + 1;
                while j < tokens_brutos.len() {
                    let t_bruto = tokens_bruto_sem_parenteses(tokens_brutos[j]);
                    if t_bruto.is_empty() {
                        break;
                    }
                    if conectores.contains(&t_bruto.as_str()) {
                        // Só inclui conector se a próxima palavra for capitalizada
                        if j + 1 < tokens_brutos.len() {
                            let prox = tokens_bruto_sem_parenteses(tokens_brutos[j + 1]);
                            if prox.chars().next().map(|c| c.is_uppercase()).unwrap_or(false)
                                && !ignorar_inicio.contains(&prox.as_str())
                            {
                                partes_nome.push(t_bruto);
                                partes_nome.push(prox);
                                j += 2;
                                // Continua se a palavra anterior não terminava com pontuação
                                if tokens_brutos[j - 1].ends_with(',')
                                    || tokens_brutos[j - 1].ends_with(':')
                                    || tokens_brutos[j - 1].ends_with(')')
                                {
                                    break;
                                }
                                continue;
                            }
                        }
                        break;
                    }
                    let eh_cap = t_bruto
                        .chars()
                        .next()
                        .map(|c| c.is_uppercase())
                        .unwrap_or(false);
                    if eh_cap && !ignorar_inicio.contains(&t_bruto.as_str()) {
                        partes_nome.push(t_bruto);
                        let terminou_pontuacao = tokens_brutos[j].ends_with(',')
                            || tokens_brutos[j].ends_with(':')
                            || tokens_brutos[j].ends_with(')');
                        j += 1;
                        if terminou_pontuacao {
                            break;
                        }
                    } else {
                        break;
                    }
                }

                let nome_completo = partes_nome.join(" ");
                let chave = sem_acento(&nome_completo);
                if chave.len() >= 3 && !vistos.contains(&chave) {
                    // Captura uma janela local em torno do nome para extrair datas "(1882)"
                    let ini_ctx = i;
                    let fim_ctx = (j + 5).min(tokens_brutos.len());
                    let janela = tokens_brutos[ini_ctx..fim_ctx].join(" ");
                    vistos.insert(chave);
                    resultados.push((nome_completo, janela));
                }
                i = j;
            } else {
                i += 1;
            }
        }
    }

    resultados
}

fn tokens_bruto_sem_parenteses(s: &str) -> String {
    if s.starts_with('(') {
        return String::new();
    }
    s.trim_matches(|c: char| !c.is_alphabetic() && c != '-')
        .to_string()
}

/// Extrai uma proposta estruturada de criação de Árvore Genealógica diretamente do texto do usuário.
/// Usado tanto como pré-anotador estruturado para a LLM quanto como fallback determinístico.
pub fn extrair_arvore_de_texto(texto: &str) -> Option<PropostaCriarArvore> {
    let candidatos = extrair_nomes_proprios_com_contexto(texto);
    if candidatos.is_empty() {
        return None;
    }

    let mut pessoas: Vec<ItemPessoaProposta> = Vec::new();
    for (idx, (nome_completo, janela_ctx)) in candidatos.iter().enumerate() {
        let (nome, sobrenome) = separar_nome_sobrenome(nome_completo);
        let sexo = inferir_sexo_nome(nome_completo, janela_ctx);
        let (ano_nascimento, ano_falecimento) = extrair_datas_biograficas_trecho(janela_ctx);

        pessoas.push(ItemPessoaProposta {
            ref_id: format!("@p{}", idx + 1),
            nome,
            sobrenome,
            sexo,
            ano_nascimento,
            ano_falecimento,
            minibiografia: None,
            trecho_evidencia: janela_ctx.clone(),
            pessoa_existente_id: None,
        });
    }

    // Identifica o casal principal (primeiros dois adultos de sexos complementares ou primeiras 2 pessoas)
    // e seus filhos subsequentes
    let mut unioes: Vec<ItemUniaoProposta> = Vec::new();
    if pessoas.len() >= 2 {
        let p1 = &pessoas[0];
        // Procura parceiro de sexo oposto ou a segunda pessoa mencionada próxima a "casou" / "esposa" / "marido"
        let idx_parceiro = pessoas
            .iter()
            .enumerate()
            .skip(1)
            .find(|(_, p)| p.sexo != p1.sexo)
            .map(|(i, _)| i)
            .unwrap_or(1);

        let (pai_ref, mae_ref) = if pessoas[0].sexo == "F" && pessoas[idx_parceiro].sexo == "M" {
            (
                Some(pessoas[idx_parceiro].ref_id.clone()),
                Some(pessoas[0].ref_id.clone()),
            )
        } else {
            (
                Some(pessoas[0].ref_id.clone()),
                Some(pessoas[idx_parceiro].ref_id.clone()),
            )
        };

        let filhos_refs: Vec<String> = pessoas
            .iter()
            .enumerate()
            .filter(|(i, _)| *i != 0 && *i != idx_parceiro)
            .map(|(_, p)| p.ref_id.clone())
            .collect();

        // Procura ano de casamento no texto ("casou-se em 1905", "casaram em 1905")
        let mut ano_casamento = None;
        let norm = sem_acento(texto);
        let toks: Vec<&str> = norm
            .split(|c: char| !c.is_alphanumeric())
            .filter(|s| !s.is_empty())
            .collect();
        for i in 0..toks.len() {
            if toks[i].starts_with("casou") || toks[i].starts_with("casaram") || toks[i] == "casamento" {
                for j in (i + 1)..(i + 5).min(toks.len()) {
                    if let Ok(ano) = toks[j].parse::<i64>() {
                        if (1..=2100).contains(&ano) {
                            ano_casamento = Some(ano);
                            break;
                        }
                    }
                }
            }
        }

        unioes.push(ItemUniaoProposta {
            pai_ref,
            mae_ref,
            ano_casamento,
            filhos_refs,
        });
    }

    let primeira = &pessoas[0];
    let nome_familia = primeira
        .sobrenome
        .clone()
        .unwrap_or_else(|| format!("{} {}", primeira.nome, primeira.sobrenome.as_deref().unwrap_or("")).trim().to_string());

    let mut proposta = PropostaCriarArvore {
        nome_arvore: format!("Família {}", nome_familia),
        descricao: Some("Árvore extraída e verificada a partir dos dados fornecidos no chat.".to_string()),
        categoria: Some("Pessoal".to_string()),
        raiz_ref: pessoas[0].ref_id.clone(),
        pessoas,
        unioes,
        ancoragem_verificada: true,
        alertas_auditoria: Vec::new(),
    };

    auditar_ancoragem_arvore(&mut proposta, texto);
    if proposta.pessoas.is_empty() {
        return None;
    }
    Some(proposta)
}

/// Extrai uma proposta estruturada de criação de Linha do Tempo diretamente do texto do usuário.
pub fn extrair_linha_tempo_de_texto(texto: &str) -> Option<PropostaCriarLinhaTempo> {
    let mut marcos: Vec<ItemMarcoProposto> = Vec::new();

    // Divide por linhas, ponto-e-vírgula ou sentenças que contenham um ano
    for segmento in texto.split(|c| c == '\n' || c == ';' || c == '.') {
        let seg = segmento.trim();
        if seg.len() < 5 {
            continue;
        }
        let anos = extrair_anos_do_texto(seg);
        if anos.is_empty() {
            continue;
        }
        let ano_ini = anos[0];
        let ano_fim = if anos.len() >= 2 && anos[1] >= ano_ini {
            Some(anos[1])
        } else {
            Some(ano_ini)
        };

        // Limpa prefixos de comando ("Crie uma linha do tempo:", "- 1822:")
        let mut titulo = seg
            .trim_start_matches(|c: char| c == '-' || c == '*' || c == '•' || c.is_whitespace())
            .to_string();
        if let Some(pos_dois_pontos) = titulo.find(':') {
            let antes = &titulo[..pos_dois_pontos];
            if sem_acento(antes).contains("linha do tempo") || antes.len() <= 12 {
                titulo = titulo[pos_dois_pontos + 1..].trim().to_string();
            }
        }
        if titulo.is_empty() {
            titulo = seg.to_string();
        }

        let data_periodo_texto = match ano_fim {
            Some(f) if f != ano_ini => format!("{}–{}", ano_ini, f),
            _ => ano_ini.to_string(),
        };

        marcos.push(ItemMarcoProposto {
            titulo: titulo.chars().take(120).collect(),
            ano_inicio: ano_ini,
            ano_fim,
            data_periodo_texto,
            descricao: Some(seg.to_string()),
            relevancia: "alta".to_string(),
            trecho_evidencia: seg.to_string(),
        });
    }

    if marcos.is_empty() {
        return None;
    }

    let mut proposta = PropostaCriarLinhaTempo {
        titulo_linha: "Linha do Tempo Extraída do Chat".to_string(),
        categoria: "História & Cronologia".to_string(),
        fonte_referencia: Some("Dados fornecidos pelo usuário no Assistente IA".to_string()),
        marcos,
        ancoragem_verificada: true,
        alertas_auditoria: Vec::new(),
    };

    auditar_ancoragem_linha_tempo(&mut proposta, texto);
    if proposta.marcos.is_empty() {
        return None;
    }
    Some(proposta)
}

// ============================================================================
// VERIFICADOR ANTI-ALUCINAÇÃO "QUOTE-AND-VERIFY" (AUDITORIA PÓS-LLM)
// ============================================================================

/// Audita uma `PropostaCriarArvore` gerada pela LLM (ou pelo extrator) contra o `texto_fonte` do usuário:
/// 1. Remove qualquer pessoa cujo primeiro nome NÃO apareça literalmente (sem acento) no `texto_fonte`.
/// 2. Anula qualquer ano (`ano_nascimento`, `ano_falecimento`, `ano_casamento`) que NÃO conste no `texto_fonte`.
/// 3. Corrige invariantes de domínio (sexo válido `M/F/X/U`, falecimento >= nascimento, anticiclo em uniões).
pub fn auditar_ancoragem_arvore(proposta: &mut PropostaCriarArvore, texto_fonte: &str) {
    let texto_norm = sem_acento(texto_fonte);
    let anos_permitidos: HashSet<i64> = extrair_anos_do_texto(texto_fonte).into_iter().collect();
    let mut alertas = Vec::new();

    // 1. Filtra pessoas exigindo ancoragem literal do primeiro nome no texto_fonte
    let mut pessoas_validas = Vec::new();
    let mut refs_validas = HashSet::new();

    for mut p in proposta.pessoas.drain(..) {
        let primeiro_nome = sem_acento(&p.nome)
            .split_whitespace()
            .find(|w| w.len() >= 2 && !["dom", "dona", "rei", "rainha", "principe", "princesa"].contains(w))
            .unwrap_or("")
            .to_string();

        if primeiro_nome.is_empty() || !texto_norm.contains(&primeiro_nome) {
            alertas.push(format!(
                "Pessoa '{}' removida pelo verificador Quote-and-Verify: nome não encontrado no texto fornecido.",
                p.nome
            ));
            continue;
        }

        // Normaliza sexo
        if !["M", "F", "X", "U"].contains(&p.sexo.as_str()) {
            p.sexo = inferir_sexo_nome(&p.nome, &p.trecho_evidencia);
        }

        // Verifica ancoragem literal do ano de nascimento
        if let Some(ano_n) = p.ano_nascimento {
            if !anos_permitidos.contains(&ano_n) {
                alertas.push(format!(
                    "Ano de nascimento ({}) de '{}' removido: ano não consta no texto fornecido.",
                    ano_n, p.nome
                ));
                p.ano_nascimento = None;
            }
        }

        // Verifica ancoragem literal do ano de falecimento e consistência cronológica
        if let Some(ano_m) = p.ano_falecimento {
            if !anos_permitidos.contains(&ano_m) {
                alertas.push(format!(
                    "Ano de falecimento ({}) de '{}' removido: ano não consta no texto fornecido.",
                    ano_m, p.nome
                ));
                p.ano_falecimento = None;
            } else if let Some(ano_n) = p.ano_nascimento {
                if ano_m < ano_n {
                    alertas.push(format!(
                        "Ano de falecimento ({}) anterior ao nascimento ({}) em '{}' foi descartado.",
                        ano_m, ano_n, p.nome
                    ));
                    p.ano_falecimento = None;
                }
            }
        }

        refs_validas.insert(p.ref_id.clone());
        pessoas_validas.push(p);
    }

    proposta.pessoas = pessoas_validas;

    // Atualiza raiz_ref se necessário
    if !refs_validas.contains(&proposta.raiz_ref) {
        if let Some(primeira) = proposta.pessoas.first() {
            proposta.raiz_ref = primeira.ref_id.clone();
        }
    }

    // 2. Audita uniões (referências válidas, anticiclo pai != filho e ano de casamento ancorado)
    let mut unioes_validas = Vec::new();
    let mut filhos_ja_alocados = HashSet::new();
    let mapa_anos_nasc: HashMap<String, i64> = proposta
        .pessoas
        .iter()
        .filter_map(|p| p.ano_nascimento.map(|a| (p.ref_id.clone(), a)))
        .collect();

    for mut u in proposta.unioes.drain(..) {
        if let Some(ref pai) = u.pai_ref {
            if !refs_validas.contains(pai) {
                u.pai_ref = None;
            }
        }
        if let Some(ref mae) = u.mae_ref {
            if !refs_validas.contains(mae) {
                u.mae_ref = None;
            }
        }
        if u.pai_ref == u.mae_ref {
            u.mae_ref = None;
        }
        if u.pai_ref.is_none() && u.mae_ref.is_none() {
            continue;
        }

        if let Some(ano_c) = u.ano_casamento {
            if !anos_permitidos.contains(&ano_c) {
                alertas.push(format!(
                    "Ano de casamento ({}) removido: não consta no texto fornecido.",
                    ano_c
                ));
                u.ano_casamento = None;
            }
        }

        u.filhos_refs.retain(|f_ref| {
            if !refs_validas.contains(f_ref) {
                alertas.push(format!(
                    "Vínculo descartado: '{}' aparecia como filho, mas não foi reconhecido como pessoa no texto.",
                    f_ref
                ));
                return false;
            }
            if u.pai_ref.as_ref() == Some(f_ref) || u.mae_ref.as_ref() == Some(f_ref) {
                alertas.push(format!(
                    "Ciclo bloqueado: '{}' não pode ser filho de sua própria união.",
                    f_ref
                ));
                return false;
            }
            if filhos_ja_alocados.contains(f_ref) {
                // Invariante 1 da secao 3: uma pessoa pertence a no maximo uma
                // uniao como filho. Os dois ramos vizinhos avisam quando
                // recusam; este recusava calado, e o card de confirmacao
                // prometia um vinculo que nao seria criado.
                alertas.push(format!(
                    "Vínculo descartado: '{}' já foi registrado como filho de outra união, e cada pessoa tem um único par de pais.",
                    f_ref
                ));
                return false;
            }
            // Verifica plausibilidade cronológica entre pais e filho quando ambos têm ano
            if let Some(&ano_filho) = mapa_anos_nasc.get(f_ref) {
                if let Some(ref pai) = u.pai_ref {
                    if let Some(&ano_pai) = mapa_anos_nasc.get(pai) {
                        if ano_filho <= ano_pai {
                            alertas.push(format!(
                                "Vínculo incoerente bloqueado: filho ({}) nascido antes ou no mesmo ano do pai ({}).",
                                ano_filho, ano_pai
                            ));
                            return false;
                        }
                    }
                }
            }
            filhos_ja_alocados.insert(f_ref.clone());
            true
        });

        unioes_validas.push(u);
    }

    proposta.unioes = unioes_validas;
    proposta.ancoragem_verificada = true;
    proposta.alertas_auditoria = alertas;
}

/// Audita uma `PropostaCriarLinhaTempo` contra o `texto_fonte` do usuário,
/// garantindo que todo marco tenha um ano literal presente no texto original.
pub fn auditar_ancoragem_linha_tempo(proposta: &mut PropostaCriarLinhaTempo, texto_fonte: &str) {
    let anos_permitidos: HashSet<i64> = extrair_anos_do_texto(texto_fonte).into_iter().collect();
    let mut alertas = Vec::new();
    let mut marcos_validos = Vec::new();

    for mut m in proposta.marcos.drain(..) {
        if !anos_permitidos.contains(&m.ano_inicio) {
            alertas.push(format!(
                "Marco '{}' ({}) removido pelo verificador Quote-and-Verify: o ano {} não consta no texto fornecido.",
                m.titulo, m.ano_inicio, m.ano_inicio
            ));
            continue;
        }
        if let Some(fim) = m.ano_fim {
            if !anos_permitidos.contains(&fim) || fim < m.ano_inicio {
                m.ano_fim = Some(m.ano_inicio);
            }
        }
        marcos_validos.push(m);
    }

    proposta.marcos = marcos_validos;
    proposta.ancoragem_verificada = true;
    proposta.alertas_auditoria = alertas;
}
