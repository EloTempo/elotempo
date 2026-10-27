//! Algoritmos clássicos de Machine Learning e NLP em Rust puro para apoiar a LLM local:
//!
//! 1. **Similaridade de Jaro-Winkler (`jaro_winkler`)**: Record Linkage e desambiguação
//!    de nomes próprios com tolerância a variações de grafia.
//! 2. **Tokenização Sem-Acento e Pontuação Léxica (BM25 simplificado)**: Ranqueamento
//!    determinístico de documentos/registros do banco contra a consulta do usuário.
//! 3. **Portão de Abstenção (`PortaoAbstencao`)**: Impede respostas quando nem o banco
//!    de dados nem o texto fornecido no chat possuem evidências sobre o tema perguntado.
//! 4. **Extrator Gramatical / Pré-Anotador NER (`extrair_arvore_de_texto`, `extrair_linha_tempo_de_texto`, `extrair_rascunho_pessoa_de_texto`)**:
//!    Identifica pessoas (inclusive em minúsculas ou com dados parciais), datas,
//!    casamentos, parentescos, atributos e marcos diretamente de textos em português.
//! 5. **Verificador Anti-Alucinação `"Quote-and-Verify"` (`auditar_ancoragem_arvore`, `auditar_ancoragem_linha_tempo`)**:
//!    Exige que todo nome e ano gerado pela LLM exista literalmente no texto-fonte do usuário,
//!    expurgando qualquer dado alucinado e validando invariantes cronológicas e anticiclo.

use std::collections::{HashMap, HashSet};
use crate::domain::texto::sem_acento;
use super::{
    ContextoConversaIa, ItemMarcoProposto, ItemPessoaProposta, ItemUniaoProposta,
    PropostaCriarArvore, PropostaCriarLinhaTempo, RascunhoCadastroPessoaIa,
};

/// Stopwords comuns e palavras de enquadramento de consulta que não devem diluir o tema pesquisado.
const STOPWORDS_PT: &[&str] = &[
    "a", "as", "o", "os", "um", "uma", "uns", "umas", "de", "do", "da", "dos", "das",
    "em", "no", "na", "nos", "nas", "por", "pelo", "pela", "pelos", "pelas", "para",
    "com", "sem", "sob", "sobre", "entre", "ate", "apos", "ante", "contra", "desde",
    "e", "ou", "mas", "nem", "que", "se", "como", "quando", "onde", "quem", "qual",
    "quais", "quanto", "quantos", "quantas", "foi", "foram", "era", "eram", "ser",
    "sao", "eh", "estar", "esta", "estao", "estava", "estavam", "teve", "tiveram",
    "tem", "tinha", "tinham", "ha", "houve", "possui", "possuem", "fale", "falar",
    "conte", "contar", "diga", "dizer", "me", "nos", "seu", "sua", "seus", "suas",
    "meu", "minha", "meus", "minhas", "este", "esta", "esse", "essa", "isso", "isto",
    "aqui", "ali", "la", "ai", "mais", "menos", "muito", "muitos", "muita", "muitas",
    "pouco", "poucos", "bem", "ja", "ainda", "so", "apenas", "tambem", "todos", "todas",
    "tudo", "algum", "alguma", "alguns", "algumas", "alguem", "ninguem", "chamado",
    "chamada", "chama", "voce", "conhece", "conhecer", "vida", "historia", "historias",
    "historico", "historicos", "historica", "historicas", "pessoa", "pessoas",
    "personalidade", "personalidades", "figura", "figuras", "personagem", "personagens",
    "individuo", "individuos", "membro", "membros", "integrante", "integrantes",
    "nome", "nomes", "familia", "familias", "arvore", "arvores", "genealogica",
    "genealogicas", "genealogia", "linhagem", "linhagens", "linha", "linhas", "tempo",
    "criar", "crie", "monte", "montar", "fazer", "faca", "adicionar", "adicione",
    "existiu", "existem", "existe", "aconteceu", "acontecimentos", "fatos", "dados",
    "banco", "acervo", "programa", "sistema", "aplicativo", "elotempo", "base",
    "catalogo", "lista", "relacao", "resumo", "informacao", "informacoes", "detalhe",
    "detalhes", "salvo", "salvos", "salva", "salvas", "cadastrado", "cadastrados",
    "cadastrada", "cadastradas", "registrado", "registrados", "registrada", "registradas",
    "listado", "listados", "listada", "listadas", "disponivel", "disponiveis",
    "presente", "presentes", "incluido", "incluidos", "incluida", "incluidas",
    "consta", "constam", "mostrar", "mostre", "listar", "liste", "exibir", "exiba",
    "apresente", "apresentar", "saber", "ver", "quero", "gostaria", "pode",
    "poderia", "explicar", "explique", "descreva", "resuma", "famoso", "famosos",
    "famosa", "famosas", "importante", "importantes", "ilustre", "ilustres", "notavel",
    "notaveis", "grande", "grandes", "principal", "principais", "filho", "filha",
    "filhos", "filhas", "pai", "mae", "pais", "avo", "avos", "neto", "neta", "netos",
    "irmao", "irma", "irmaos", "conjuge", "esposa", "esposo", "marido", "casou",
    "nasceu", "nascido", "nascida", "morreu", "faleceu", "falecido", "falecida",
    "vivia", "viviam", "vivos", "vivo", "viva", "ano", "anos", "seculo", "sec",
    "data", "datas", "periodo", "epoca", "categoria", "categorias", "grupo", "grupos",
    "tipo", "tipos", "dom", "dona", "d", "abrir", "abra", "ficha", "registro",
    "cadastro", "editar", "edite", "alterar", "altere", "por", "volta", "cerca", "aprox",
    "aproximadamente", "decada", "janeiro", "fevereiro", "marco", "abril", "maio",
    "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro",
];

const TITULOS_HONORIFICOS: &[&str] = &[
    "d", "dom", "dona", "rei", "rainha", "principe", "princesa", "imperador", "imperatriz",
];

/// Normaliza um nome ou pergunta removendo acentos, pontuação e títulos honoríficos (`D.`, `Dom`, `Dona`, `Rei`)
/// para comparação exata por palavras inteiras.
pub fn normalizar_nome_busca_ia(texto: &str) -> String {
    let norm = sem_acento(texto);
    norm.split(|c: char| !c.is_alphanumeric())
        .map(str::trim)
        .filter(|t| !t.is_empty() && !TITULOS_HONORIFICOS.contains(t))
        .collect::<Vec<&str>>()
        .join(" ")
}

/// Verifica se `frase` ocorre dentro de `texto` respeitando fronteiras de palavras
/// (evita que `"pedro i"` dê falso positivo dentro de `"pedro ii"`).
pub fn contem_frase_exata(texto: &str, frase: &str) -> bool {
    let t_words: Vec<&str> = texto.split_whitespace().collect();
    let f_words: Vec<&str> = frase.split_whitespace().collect();
    if f_words.is_empty() || f_words.len() > t_words.len() {
        return false;
    }
    t_words.windows(f_words.len()).any(|janela| janela == f_words.as_slice())
}

/// Extrai o radical morfológico aproximado de uma palavra em português (sem acento),
/// permitindo que `"brasileiros"` case com `"brasil"`, `"cientistas"` com `"ciencia"`, etc.
pub fn radical_pt(palavra: &str) -> String {
    let p = sem_acento(palavra);
    let p = p.trim();
    if p.len() <= 4 {
        return p.to_string();
    }
    for sufixo in &["brasileiros", "brasileiras", "brasileiro", "brasileira"] {
        if p == *sufixo {
            return "brasil".to_string();
        }
    }
    for sufixo in &["portugueses", "portuguesas", "portuguesa", "portugues"] {
        if p == *sufixo {
            return "portug".to_string();
        }
    }
    for sufixo in &["italianos", "italianas", "italiano", "italiana"] {
        if p == *sufixo {
            return "itali".to_string();
        }
    }
    for sufixo in &[
        "amentos", "imentos", "amento", "imento", "adores", "adoras", "ico", "ica", "icos", "icas",
        "istas", "ista", "dores", "doras", "ioneiros", "ioneiras", "eiros", "eiras", "eiro", "eira",
        "ores", "oras", "ais", "eis", "ois", "oes", "aes", "es", "os", "as", "s",
    ] {
        if p.chars().count() > sufixo.len() + 3 {
            if let Some(stem) = p.strip_suffix(sufixo) {
                return stem.to_string();
            }
        }
    }
    p.to_string()
}

/// Expande a pergunta do usuário em termos e radicais semânticos para busca temática no acervo.
pub fn expandir_termos_semanticos_consulta(pergunta: &str) -> Vec<String> {
    let norm = sem_acento(pergunta);
    let tokens = tokenizar_significativo(pergunta);
    let mut termos: Vec<String> = Vec::new();

    for t in &tokens {
        if !termos.contains(t) {
            termos.push(t.clone());
        }
        let rad = radical_pt(t);
        if rad.len() >= 4 && !termos.contains(&rad) {
            termos.push(rad);
        }
    }

    let grupos: &[(&[&str], &[&str])] = &[
        (
            &["brasil", "brasileir", "independencia", "imperio do brasil", "republica"],
            &["brasil", "brasileir", "historia e sociedade brasileira", "familia imperial do brasil", "presidentes historicos do brasil", "independencia"],
        ),
        (
            &["portugal", "portugues", "lusitan", "avis", "braganca"],
            &["portugal", "portugues", "casa real de portugal", "braganca", "avis"],
        ),
        (
            &["monarquia", "monarca", "rei", "reis", "rainha", "rainhas", "imperador", "imperadores", "imperatriz", "principe", "princesa", "real", "reais", "imperial", "dinastia", "trono", "coroa"],
            &["monarquias e casas reais", "rei ", "rainha", "imperador", "imperatriz", "principe", "princesa", "dinastia"],
        ),
        (
            &["presidente", "presidentes", "politico", "politicos", "politica", "estadista", "estadistas", "governante", "governantes", "lider", "lideres", "lideranca", "chefe de estado", "ditador", "ministro", "diplomata"],
            &["chefes de estado e liderancas politicas", "presidente", "estadista", "primeiro-ministro", "chanceler", "diplomata", "governador", "senador"],
        ),
        (
            &["cientista", "cientistas", "ciencia", "ciencias", "cientifico", "fisico", "fisica", "quimico", "quimica", "biologo", "biologia", "naturalista", "inventor", "inventores", "pesquisador", "nobel", "evolucao", "radioatividade"],
            &["ciencia, artes e pensamento", "cientista", "fisic", "quimic", "naturalista", "biolog", "nobel", "radioatividade", "evolucao", "mineralogista"],
        ),
        (
            &["escritor", "escritores", "escritora", "escritoras", "literatura", "literario", "literaria", "poeta", "poetas", "poetisa", "romancista", "dramaturgo", "autor", "autores", "livro", "livros", "romance", "poesia"],
            &["literatura", "escritor", "poet", "romancista", "dramaturg", "ensaista", "cronista", "historiador", "livro"],
        ),
        (
            &["musico", "musicos", "musica", "musical", "compositor", "compositores", "maestro", "organista", "cravista", "barroco", "sinfonia", "opera", "artista", "artistas", "arte", "artes", "pintor", "mecenas"],
            &["ciencia, artes e pensamento", "compositor", "musica", "organista", "barroc", "sinfonia", "opera", "artes", "mecenas"],
        ),
        (
            &["empreendedor", "empreendedores", "empresario", "empresarios", "industrial", "industriais", "pioneiro", "pioneiros", "banqueiro", "magnata", "fortuna", "negocios", "cafeicultor"],
            &["grandes empreendedores e pioneiros", "industrial", "empresari", "banqueir", "pioneir", "empreendedor", "cafeicultor", "filantrop"],
        ),
        (
            &["biblia", "biblico", "biblica", "biblicos", "biblicas", "antigo testamento", "novo testamento", "evangelho", "patriarca", "patriarcas", "profeta", "profetas", "israel", "juda", "hebreu"],
            &["tradicao biblica", "patriarca", "israel", "juda", "rei de israel", "profeta", "levita", "evangelho"],
        ),
        (
            &["ficcao", "ficticio", "ficticia", "ficticios", "ficticias", "personagens literarios", "cultura pop", "cinema", "serie", "star wars", "game of thrones", "poderoso chefao", "cem anos de solidao", "tempo e o vento"],
            &["genealogias literarias e ficcionais", "ficticio", "macondo", "corleone", "skywalker", "lannister", "targaryen", "cambara", "karamazov", "compson"],
        ),
        (
            &["antiguidade", "antigo", "antigos", "farao", "faraos", "egito", "egipcio", "egipcios", "filosofo", "filosofos", "filosofia", "confucio", "oriente"],
            &["antiguidade e dinastias historicas", "farao", "egito", "dinastia", "confucio", "filosof"],
        ),
    ];

    for (gatilhos, expansoes) in grupos {
        let acionado = gatilhos.iter().any(|g| {
            norm.contains(g) || tokens.iter().any(|t| t == g || radical_pt(t) == radical_pt(g))
        });
        if acionado {
            for exp in *expansoes {
                let s = exp.to_string();
                if !termos.contains(&s) {
                    termos.push(s);
                }
            }
        }
    }

    termos
}

/// Verifica se uma palavra normalizada é um algarismo romano regnal/geracional (`"i"` a `"xx"`).
pub fn eh_algarismo_romano(s: &str) -> bool {
    matches!(
        s.trim(),
        "i" | "ii" | "iii" | "iv" | "v" | "vi" | "vii" | "viii" | "ix" | "x"
            | "xi" | "xii" | "xiii" | "xiv" | "xv" | "xvi" | "xvii" | "xviii" | "xix" | "xx"
    )
}

/// Distância de edição Damerau-Levenshtein (inserção, remoção, substituição e transposição adjacente).
pub fn distancia_edicao(s1: &str, s2: &str) -> usize {
    let a: Vec<char> = sem_acento(s1).chars().collect();
    let b: Vec<char> = sem_acento(s2).chars().collect();
    let n = a.len();
    let m = b.len();
    if n == 0 {
        return m;
    }
    if m == 0 {
        return n;
    }
    let mut dp = vec![vec![0usize; m + 1]; n + 1];
    for i in 0..=n {
        dp[i][0] = i;
    }
    for j in 0..=m {
        dp[0][j] = j;
    }
    for i in 1..=n {
        for j in 1..=m {
            let cost = if a[i - 1] == b[j - 1] { 0 } else { 1 };
            dp[i][j] = (dp[i - 1][j] + 1)
                .min(dp[i][j - 1] + 1)
                .min(dp[i - 1][j - 1] + cost);
            if i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1] {
                dp[i][j] = dp[i][j].min(dp[i - 2][j - 2] + cost);
            }
        }
    }
    dp[n][m]
}

/// Similaridade especializada para tokens de nomes próprios em português:
/// - Algarismos romanos (`"i"`, `"ii"`, `"iii"`) exigem igualdade estrita (`"i"` != `"ii"`).
/// - Impede falsos positivos morfológicos entre nomes masculinos/femininos (`"paulo"` != `"paula"`, `"mario"` != `"maria"`)
///   e entre sobrenomes patronímicos e prenomes (`"fernandes"` != `"fernanda"`).
/// - Aceita erros reais de digitação (distância de edição <= 1 em nomes curtos ou <= 2 em nomes longos, ex.:
///   `"pedo"` <-> `"pedro"`, `"asis"` <-> `"assis"`, `"varga"` <-> `"vargas"`, `"einsten"` <-> `"einstein"`, `"izabel"` <-> `"isabel"`).
pub fn similaridade_token_nome_pt(buscado: &str, candidato: &str) -> f64 {
    let b = sem_acento(buscado);
    let c = sem_acento(candidato);
    let b = b.trim();
    let c = c.trim();

    if b.is_empty() || c.is_empty() {
        return 0.0;
    }
    if b == c {
        return 1.0;
    }
    if eh_algarismo_romano(b) || eh_algarismo_romano(c) {
        return 0.0;
    }

    let chars_b: Vec<char> = b.chars().collect();
    let chars_c: Vec<char> = c.chars().collect();

    // Bloqueia oposição de gênero no final da mesma raiz ("mario"/"maria", "paulo"/"paula", "fernando"/"fernanda")
    if chars_b.len() >= 4 && chars_c.len() >= 4 && chars_b.len() == chars_c.len() {
        let stem_b = &chars_b[..chars_b.len() - 1];
        let stem_c = &chars_c[..chars_c.len() - 1];
        let fim_b = chars_b[chars_b.len() - 1];
        let fim_c = chars_c[chars_c.len() - 1];
        if stem_b == stem_c && ((fim_b == 'o' && fim_c == 'a') || (fim_b == 'a' && fim_c == 'o')) {
            return 0.0;
        }
    }

    // Bloqueia confusão entre sobrenome patronímico ("fernandes", "henriques", "rodrigues") e prenome ("fernanda", "henrique")
    let b_pat = b.ends_with("es") || b.ends_with("ez");
    let c_pat = c.ends_with("es") || c.ends_with("ez");
    if b_pat != c_pat {
        let outro = if b_pat { c } else { b };
        if outro.ends_with('a') || outro.ends_with('o') {
            return 0.0;
        }
    }

    // Nomes distintos que diferem apenas pelo sufixo feminino "-a" ("gabriel" vs "gabriela", "rafael" vs "rafaela", "daniel" vs "daniela")
    if (b.ends_with("el") && c == format!("{}a", b)) || (c.ends_with("el") && b == format!("{}a", c)) {
        return 0.0;
    }

    let dist = distancia_edicao(b, c);
    let max_len = chars_b.len().max(chars_c.len());
    let limite_dist = if max_len <= 4 {
        1
    } else if max_len <= 7 {
        1
    } else {
        2
    };

    if dist > limite_dist {
        return 0.0;
    }

    jaro_winkler(b, c)
}

/// Detecta se a pergunta contém uma data de calendário impossível (ex.: `"32/15/1890"`, `"31/02/1900"`)
/// ou um ano absurdo (ex.: `"ano 99999"`), retornando uma mensagem explicativa amigável.
pub fn detectar_data_invalida_na_pergunta(pergunta: &str) -> Option<String> {
    let norm = sem_acento(pergunta);

    // 1. Verifica padrões DD/MM/AAAA ou DD-MM-AAAA
    for palavra in norm.split_whitespace() {
        let limpo = palavra.trim_matches(|c: char| !c.is_ascii_digit() && c != '/' && c != '-');
        let sep = if limpo.contains('/') {
            Some('/')
        } else if limpo.matches('-').count() == 2 {
            Some('-')
        } else {
            None
        };

        if let Some(s) = sep {
            let partes: Vec<&str> = limpo.split(s).collect();
            if partes.len() == 3
                && partes.iter().all(|p| !p.is_empty() && p.chars().all(|c| c.is_ascii_digit()))
            {
                if let (Ok(d), Ok(m), Ok(a)) = (
                    partes[0].parse::<i64>(),
                    partes[1].parse::<i64>(),
                    partes[2].parse::<i64>(),
                ) {
                    if !(1..=12).contains(&m) || !(1..=31).contains(&d) {
                        return Some(format!(
                            "A data informada (**{}**) não existe no calendário (o dia deve estar entre 1 e 31 e o mês entre 1 e 12). Informe uma data ou ano válido para pesquisar no EloTempo.",
                            limpo
                        ));
                    }
                    let max_dias_mes = match m {
                        2 => {
                            let bissexto = (a % 4 == 0 && a % 100 != 0) || (a % 400 == 0);
                            if bissexto { 29 } else { 28 }
                        }
                        4 | 6 | 9 | 11 => 30,
                        _ => 31,
                    };
                    if d > max_dias_mes {
                        return Some(format!(
                            "A data informada (**{}**) não é válida no calendário (o mês {:02} possui no máximo {} dias nesse ano).",
                            limpo, m, max_dias_mes
                        ));
                    }
                    if !(1..=2150).contains(&a) {
                        return Some(format!(
                            "O ano informado na data (**{}**) está fora do intervalo histórico válido.",
                            limpo
                        ));
                    }
                }
            }
        }
    }

    // 2. Verifica "ano 99999" ou números de 5+ dígitos logo após "ano", "em", "nascido em"
    let toks: Vec<&str> = norm
        .split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .collect();
    for i in 0..toks.len() {
        if let Ok(num) = toks[i].parse::<i64>() {
            if num > 2200 {
                let ant = if i > 0 { toks[i - 1] } else { "" };
                if matches!(ant, "ano" | "em" | "de" | "nascido" | "nasceu" | "faleceu" | "morreu") {
                    return Some(format!(
                        "O ano informado (**{}**) é inválido ou está no futuro distante. Informe um ano histórico válido (ex.: `1822`, `1889`, `1500 a.C.`).",
                        num
                    ));
                }
            }
        }
    }

    None
}

/// Detecta se a pergunta menciona um século, década, intervalo de anos ou data aproximada (`"por volta de 1825"`)
/// e retorna `(ano_inicio, ano_fim, rotulo)`.
pub fn extrair_intervalo_seculo_ou_periodo(pergunta: &str) -> Option<(i64, i64, String)> {
    let norm = sem_acento(pergunta);
    let mapa_seculos: &[(&[&str], i64, i64, &str)] = &[
        (&["seculo xxi", "sec xxi", "seculo 21", "sec 21"], 2001, 2100, "Século XXI"),
        (&["seculo xx", "sec xx", "seculo 20", "sec 20"], 1901, 2000, "Século XX"),
        (&["seculo xix", "sec xix", "seculo 19", "sec 19"], 1801, 1900, "Século XIX"),
        (&["seculo xviii", "sec xviii", "seculo 18", "sec 18"], 1701, 1800, "Século XVIII"),
        (&["seculo xvii", "sec xvii", "seculo 17", "sec 17"], 1601, 1700, "Século XVII"),
        (&["seculo xvi", "sec xvi", "seculo 16", "sec 16"], 1501, 1600, "Século XVI"),
        (&["seculo xv", "sec xv", "seculo 15", "sec 15"], 1401, 1500, "Século XV"),
        (&["idade media", "medieval", "medievais"], 476, 1453, "Idade Média"),
        (&["renascimento", "renascentista"], 1400, 1650, "Renascimento"),
        (&["antiguidade", "mundo antigo", "antes de cristo", " a.c"], -4000, 476, "Antiguidade"),
    ];

    for (padroes, ini, fim, rotulo) in mapa_seculos {
        if padroes.iter().any(|p| norm.contains(p)) {
            return Some((*ini, *fim, (*rotulo).to_string()));
        }
    }

    let anos = extrair_anos_do_texto(pergunta);

    // Intervalo explícito: "entre 1800 e 1850", "de 1820 a 1890", "1800-1850"
    if anos.len() >= 2 && anos[1] > anos[0] && (anos[1] - anos[0]) <= 500 {
        if norm.contains("entre ") || norm.contains("de ") || norm.contains("ate ") || norm.contains('-') {
            return Some((
                anos[0],
                anos[1],
                format!("Período {}–{}", anos[0], anos[1]),
            ));
        }
    }

    // Década: "década de 1880", "anos 1880"
    if let Some(&ano) = anos.first() {
        if (norm.contains("decada") || norm.contains("anos ")) && ano >= 1000 && ano % 10 == 0 {
            return Some((ano, ano + 9, format!("Década de {}", ano)));
        }
        // Data aproximada / mal definida: "por volta de 1825", "cerca de 1825", "aprox 1825", "~1825"
        if norm.contains("por volta")
            || norm.contains("cerca de")
            || norm.contains("aprox")
            || pergunta.contains('~')
        {
            return Some((ano - 3, ano + 3, format!("Por volta de {} (±3 anos)", ano)));
        }
    }

    None
}

/// Verifica se a pergunta pede um panorama, catálogo, estatísticas ou listagem geral do acervo.
pub fn eh_consulta_catalogo_acervo(pergunta: &str) -> bool {
    let norm = sem_acento(pergunta);
    if norm.contains("quantas pessoas")
        || norm.contains("quantas arvores")
        || norm.contains("estatisticas")
        || norm.contains("resumo do acervo")
        || norm.contains("total de pessoas")
        || norm.contains("quais arvores")
        || norm.contains("quais sao as arvores")
        || norm.contains("quais familias")
        || norm.contains("quais sao as familias")
        || norm.contains("quais categorias")
        || norm.contains("quais linhas do tempo")
        || norm.contains("o que tem no acervo")
        || norm.contains("o que ha no acervo")
        || norm.contains("o que esta salvo")
    {
        return true;
    }

    if extrair_nome_alvo_consulta_pessoa(pergunta).is_some() {
        return false;
    }

    let tokens = tokenizar_significativo(pergunta);
    let anos = extrair_anos_do_texto(pergunta);
    tokens.is_empty()
        && anos.is_empty()
        && (norm.contains("acervo")
            || norm.contains("banco")
            || norm.contains("elotempo")
            || norm.contains("arvore")
            || norm.contains("familia")
            || norm.contains("personalidade")
            || norm.contains("pessoa")
            || norm.contains("cadastrad")
            || norm.contains("salv"))
}

/// Verifica se o usuário pediu explicitamente para abrir a Árvore ou a Linha do Tempo na tela.
pub fn usuario_pediu_abertura_explicita_visualizacao(mensagem: &str) -> (bool, bool) {
    let norm = sem_acento(mensagem);
    let verbos_abrir = ["abra ", "abrir ", "mostre na ", "mostrar na ", "exiba na ", "ver na ", "ir para "];
    let tem_verbo = verbos_abrir.iter().any(|v| norm.contains(v));
    let abrir_arvore = tem_verbo && (norm.contains("arvore") || norm.contains("genealogia") || norm.contains("grafo"));
    let abrir_timeline = tem_verbo && (norm.contains("linha do tempo") || norm.contains("timeline") || norm.contains("cronologia"));
    (abrir_arvore, abrir_timeline)
}

/// Resolve referências pronominais (`"ele"`, `"ela"`, `"dele"`, `"dela"`, `"essa pessoa"`)
/// enriquecendo a mensagem com o nome da última pessoa em foco na conversa quando necessário.
pub fn expandir_mensagem_com_contexto(mensagem: &str, ctx: &ContextoConversaIa) -> String {
    let norm = sem_acento(mensagem);
    let palavras: Vec<&str> = norm
        .split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .collect();

    let pronomes_pessoa = ["ele", "ela", "dele", "dela", "nele", "nela"];
    let usa_pronome = palavras.iter().any(|p| pronomes_pessoa.contains(p))
        || norm.contains("essa pessoa")
        || norm.contains("este cadastro")
        || norm.contains("esse registro");

    let candidatos_nomes = extrair_nomes_proprios_com_contexto(mensagem);
    if usa_pronome && candidatos_nomes.is_empty() && extrair_nome_alvo_consulta_pessoa(mensagem).is_none() {
        if let Some(ref ultima_pessoa) = ctx.ultima_pessoa_nome {
            return format!("{} (referente a {})", mensagem, ultima_pessoa);
        }
    }

    if (norm.contains("essa arvore") || norm.contains("esta arvore") || norm.contains("nessa arvore"))
        && candidatos_nomes.is_empty()
    {
        if let Some(ref ultima_arv) = ctx.ultima_arvore_nome {
            return format!("{} (árvore {})", mensagem, ultima_arv);
        }
    }

    if (norm.contains("essa linha") || norm.contains("esta linha") || norm.contains("nessa linha do tempo"))
        && candidatos_nomes.is_empty()
    {
        if let Some(ref ultima_linha) = ctx.ultima_linha_titulo {
            return format!("{} (linha do tempo {})", mensagem, ultima_linha);
        }
    }

    mensagem.to_string()
}

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

    let mut k = 0usize;
    let mut transpositions = 0usize;
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
    let t = (transpositions as f64) / 2.0;
    ((m / len_a as f64) + (m / len_b as f64) + ((m - t) / m)) / 3.0
}

/// Similaridade de Jaro-Winkler (`p = 0.1`, prefixo até 4 caracteres).
pub fn jaro_winkler(s1: &str, s2: &str) -> f64 {
    let j = jaro(s1, s2);
    if j <= 0.7 {
        return j;
    }
    let a = sem_acento(s1);
    let b = sem_acento(s2);
    let prefix_len = a
        .chars()
        .zip(b.chars())
        .take(4)
        .take_while(|(ca, cb)| ca == cb)
        .count() as f64;

    (j + prefix_len * 0.1 * (1.0 - j)).min(1.0)
}

/// Extrai tokens significativos (sem acento, minúsculos, sem stopwords, preservando algarismos romanos).
pub fn tokenizar_significativo(texto: &str) -> Vec<String> {
    let norm = sem_acento(texto);
    let mut vistos = HashSet::new();
    let mut resultado = Vec::new();

    for parte in norm.split(|c: char| !c.is_alphanumeric()) {
        let p = parte.trim();
        if p.is_empty() {
            continue;
        }
        if p.len() < 2 && !eh_algarismo_romano(p) {
            continue;
        }
        if STOPWORDS_PT.contains(&p) {
            continue;
        }
        if p.chars().all(|c| c.is_ascii_digit()) {
            continue;
        }
        if vistos.insert(p.to_string()) {
            resultado.push(p.to_string());
        }
    }
    resultado
}

/// Extrai anos históricos mencionados no texto (suporta anos d.C., anos `a.C.` e datas `DD/MM/AAAA`),
/// ignorando dias/meses (`12/10/1798` -> `1798`) e quantidades não-cronológicas (`500 gramas`).
pub fn extrair_anos_do_texto(texto: &str) -> Vec<i64> {
    let norm = sem_acento(texto);
    let mut anos = Vec::new();

    // 1. Trata datas compostas DD/MM/AAAA ou DD-MM-AAAA extraindo apenas o AAAA
    let mut texto_sem_datas_compostas = norm.clone();
    for palavra in norm.split_whitespace() {
        let limpo = palavra.trim_matches(|c: char| !c.is_ascii_digit() && c != '/' && c != '-');
        let sep = if limpo.contains('/') {
            Some('/')
        } else if limpo.matches('-').count() == 2 {
            Some('-')
        } else {
            None
        };
        if let Some(s) = sep {
            let partes: Vec<&str> = limpo.split(s).collect();
            if partes.len() == 3 {
                if let (Ok(d), Ok(m), Ok(a)) = (
                    partes[0].parse::<i64>(),
                    partes[1].parse::<i64>(),
                    partes[2].parse::<i64>(),
                ) {
                    if (1..=31).contains(&d) && (1..=12).contains(&m) && (100..=2150).contains(&a) {
                        anos.push(a);
                        texto_sem_datas_compostas = texto_sem_datas_compostas.replace(limpo, " ");
                    }
                }
            }
        }
    }

    let tokens: Vec<&str> = texto_sem_datas_compostas
        .split(|c: char| !c.is_alphanumeric() && c != '-')
        .filter(|s| !s.is_empty())
        .collect();

    let unidades_medida = [
        "gramas", "g", "kg", "quilos", "ml", "litros", "metros", "km", "cm",
        "ovos", "xicaras", "colheres", "reais", "dolares", "porcento",
        "janeiro", "fevereiro", "marco", "abril", "maio", "junho",
        "julho", "agosto", "setembro", "outubro", "novembro", "dezembro",
    ];

    for (i, tok) in tokens.iter().enumerate() {
        for sub in tok.split('-') {
            if sub.is_empty() {
                continue;
            }
            if let Ok(mut ano) = sub.parse::<i64>() {
                let ant = if i > 0 { tokens[i - 1] } else { "" };
                let prox = tokens.get(i + 1).copied().unwrap_or("");
                let prox2 = tokens.get(i + 2).copied().unwrap_or("");

                // Ignora dia do mês como "12 de outubro" ou quantidades como "500 gramas"
                if unidades_medida.contains(&prox)
                    || (prox == "de" && unidades_medida.contains(&prox2))
                {
                    continue;
                }

                let eh_ac = prox == "ac"
                    || (prox == "a" && prox2 == "c")
                    || norm.contains(&format!("{} a.c", ano))
                    || norm.contains(&format!("{} ac", ano));

                // Números pequenos (1..99) só são anos se vierem após "ano" ou seguidos de "a.C." / "d.C."
                if (1..100).contains(&ano) && !eh_ac && ant != "ano" && prox != "dc" {
                    continue;
                }

                if (1..=2150).contains(&ano) {
                    if eh_ac {
                        ano = -ano;
                    }
                    anos.push(ano);
                }
            }
        }
    }
    anos.sort();
    anos.dedup();
    anos
}

/// Palavras temáticas, de categorias, profissões, lugares ou objetos que NÃO são nomes próprios de uma pessoa.
const PALAVRAS_TEMATICAS_NAO_PESSOA: &[&str] = &[
    "brasil", "brasileiro", "brasileira", "brasileiros", "brasileiras", "portugal",
    "portugues", "portuguesa", "portugueses", "italia", "italiano", "italiana",
    "alemanha", "franca", "inglaterra", "espanha", "egito", "israel", "argentina",
    "europa", "america", "oriente", "macondo", "monarquia", "monarquias", "monarca",
    "monarcas", "imperadores", "imperatrizes", "reis", "rainhas", "princesas",
    "principes", "dinastia", "dinastias", "presidente", "presidentes", "politico",
    "politicos", "estadista", "estadistas", "cientista", "cientistas", "ciencia",
    "ciencias", "naturalista", "fisico", "quimico", "biologo", "nobel", "evolucao",
    "radioatividade", "escritor", "escritores", "escritora", "escritoras", "literatura",
    "poeta", "poetas", "romancista", "autor", "autores", "livro", "livros", "obra",
    "obras", "romance", "musica", "musico", "musicos", "compositor", "compositores",
    "barroco", "arte", "artes", "artista", "artistas", "empreendedor", "empreendedores",
    "empresario", "empresarios", "industrial", "pioneiro", "pioneiros", "banqueiro",
    "biblia", "biblico", "biblica", "biblicos", "patriarca", "patriarcas", "profeta",
    "profetas", "ficcao", "ficticio", "ficticia", "ficticios", "literario", "literarios",
    "cinema", "serie", "antiguidade", "farao", "faraos", "filosofo", "filosofos",
    "mulher", "mulheres", "homem", "homens", "feminina", "femininas", "masculino",
    "antigo", "antiga", "antigos", "longevo", "longeva", "velho", "velha", "incompleto",
    "incompletos", "duplicata", "duplicatas", "qualidade", "estatistica", "estatisticas",
    "profissao", "profissoes", "escolaridade", "religiao", "religioes", "idioma",
    "idiomas", "fonte", "fontes", "documento", "documentos", "certidao", "marco",
    "marcos", "evento", "eventos", "imperial", "real", "reais", "familia", "familias",
    "arvore", "arvores", "linha", "linhas", "tempo", "seculo", "sec", "decada",
    "penicilina", "lampada", "telefone", "bastilha", "independencia", "republica",
    "corte", "lei", "aurea", "guerra", "revolucao", "planilha", "computador",
];

/// Identifica quando a pergunta ou comando do usuário refere-se a uma **pessoa específica pelo nome**
/// (ex.: `"Existe alguém cadastrado com o nome de Gabriel Fernandes?"`, `"Quem foi Machado de Asis?"`,
/// `"Quando Dom Pedro I nasceu?"`, `"Tem cadastro de Pedro Henrique Oliveira?"`, `"Ana Paula Ferreira está cadastrada?"`)
/// e retorna o nome próprio devidamente limpo e capitalizado (`Some("Gabriel Fernandes")`).
/// Retorna `None` se for uma pergunta temática/analítica (`"Quem foram os cientistas do século XIX?"`).
pub fn extrair_nome_alvo_consulta_pessoa(pergunta: &str) -> Option<String> {
    let norm = sem_acento(pergunta);
    let norm_trim = norm.trim();

    // Ignora perguntas de parentesco entre 2 pessoas ("qual o parentesco entre X e Y") ou criação de árvores/linhas
    if (norm_trim.contains("parentesco") && norm_trim.contains(" entre "))
        || norm_trim.contains("relacao entre ")
        || norm_trim.contains("linha do tempo")
        || norm_trim.contains("arvore genealogica")
        || norm_trim.contains("uma arvore")
        || norm_trim.contains("entrevista guiada")
        || norm_trim.contains("cadastros incompletos")
    {
        return None;
    }

    // 1. Gatilhos explícitos onde o nome da pessoa vem APÓS a expressão
    let gatilhos_pos = [
        "cadastrado com o nome de ",
        "cadastrada com o nome de ",
        "registrado com o nome de ",
        "registrada com o nome de ",
        "com o nome de ",
        "com nome de ",
        "pelo nome de ",
        "sob o nome de ",
        "alguem chamado ",
        "alguem chamada ",
        "pessoa chamada ",
        "chamado ",
        "chamada ",
        "criar um cadastro para ",
        "criar cadastro para ",
        "criar cadastro de ",
        "crie um cadastro para ",
        "crie o cadastro de ",
        "fazer cadastro de ",
        "fazer um cadastro para ",
        "novo cadastro de ",
        "novo cadastro para ",
        "cadastrar nova pessoa: ",
        "cadastrar nova pessoa ",
        "cadastrar pessoa: ",
        "cadastrar pessoa ",
        "nova pessoa: ",
        "novo cadastro: ",
        "quero cadastrar o ",
        "quero cadastrar a ",
        "quero cadastrar ",
        "cadastro de ",
        "cadastro do ",
        "cadastro da ",
        "registro de ",
        "registro do ",
        "registro da ",
        "ficha de ",
        "ficha do ",
        "ficha da ",
        "adicionar informacoes sobre o ",
        "adicionar informacoes sobre a ",
        "adicionar informacoes sobre ",
        "adicionar informacoes de ",
        "adicionar dados de ",
        "informacoes sobre o ",
        "informacoes sobre a ",
        "informacoes sobre ",
        "informacoes de ",
        "informacoes do ",
        "informacoes da ",
        "dados sobre o ",
        "dados sobre a ",
        "dados sobre ",
        "dados de ",
        "dados do ",
        "dados da ",
        "filhos e a esposa de ",
        "filhos e esposa de ",
        "esposa e os filhos de ",
        "esposa e filhos de ",
        "quem foram os filhos de ",
        "quem sao os filhos de ",
        "quais os filhos de ",
        "filhos de ",
        "filhos do ",
        "filhos da ",
        "quem foram os pais de ",
        "quais os pais de ",
        "pais de ",
        "pais do ",
        "pais da ",
        "quem foi o pai de ",
        "pai de ",
        "pai do ",
        "pai da ",
        "quem foi a mae de ",
        "mae de ",
        "mae do ",
        "mae da ",
        "esposa de ",
        "esposa do ",
        "marido de ",
        "marido da ",
        "conjuge de ",
        "conjuge do ",
        "conjuge da ",
        "gere uma biografia de ",
        "gere uma minibiografia de ",
        "escreva uma biografia de ",
        "biografia de ",
        "biografia do ",
        "biografia da ",
        "minibiografia de ",
        "obras de ",
        "obra de ",
        "livros de ",
        "livro de ",
        "profissao de ",
        "quem foi o ",
        "quem foi a ",
        "quem foi ",
        "quem era o ",
        "quem era a ",
        "quem era ",
        "quem e o ",
        "quem e a ",
        "quem e ",
        "quando nasceu o ",
        "quando nasceu a ",
        "quando nasceu ",
        "onde nasceu o ",
        "onde nasceu a ",
        "onde nasceu ",
        "quando morreu o ",
        "quando morreu a ",
        "quando morreu ",
        "quando faleceu o ",
        "quando faleceu a ",
        "quando faleceu ",
        "me fale sobre o ",
        "me fale sobre a ",
        "me fale sobre ",
        "fale sobre o ",
        "fale sobre a ",
        "fale sobre ",
        "voce conhece o ",
        "voce conhece a ",
        "voce conhece ",
        "conhece o ",
        "conhece a ",
        "cadastrar o ",
        "cadastrar a ",
        "cadastrar ",
        "cadastre o ",
        "cadastre a ",
        "cadastre ",
    ];

    for g in gatilhos_pos {
        if let Some(pos) = norm_trim.find(g) {
            if let Some(resto) = norm_trim.get(pos + g.len()..) {
                if let Some(nome_limpo) = limpar_e_validar_sequencia_nome_pessoa(resto) {
                    return Some(nome_limpo);
                }
            }
        }
    }

    // 2. Padrões onde o nome da pessoa vem ANTES do verbo:
    //    Ex.: "Quando Dom Pedro I nasceu?", "Onde Machado de Assis nasceu?",
    //         "Ana Paula Ferreira está cadastrada?", "Gabriel Fernandes consta no banco?"
    let sufixos_verbo = [
        " nasceu",
        " morreu",
        " faleceu",
        " casou",
        " viveu",
        " esta cadastrad",
        " esta registrad",
        " consta no",
        " consta na",
        " existe no",
        " existe na",
        " tem cadastro",
        " tem registro",
    ];
    for suf in sufixos_verbo {
        if let Some(pos) = norm_trim.find(suf) {
            if let Some(antes) = norm_trim.get(..pos) {
                let antes_sem_interrogativo = antes
                    .trim_start_matches("quando ")
                    .trim_start_matches("onde ")
                    .trim_start_matches("como ")
                    .trim_start_matches("se ")
                    .trim_start_matches("por que ")
                    .trim_start_matches("quem ")
                    .trim_start_matches("quais ")
                    .trim_start_matches("qual ")
                    .trim_start_matches("o ")
                    .trim_start_matches("a ")
                    .trim();
                if !matches!(antes_sem_interrogativo, "" | "quem" | "quais" | "qual" | "quando" | "onde" | "como") {
                    if let Some(nome_limpo) = limpar_e_validar_sequencia_nome_pessoa(antes_sem_interrogativo) {
                        return Some(nome_limpo);
                    }
                }
            }
        }
    }

    None
}

fn limpar_e_validar_sequencia_nome_pessoa(trecho_norm: &str) -> Option<String> {
    let parar_cauda = [
        "nasceu", "nascido", "nascida", "morreu", "faleceu", "falecido", "falecida",
        "casou", "casado", "casada", "viveu", "vivia", "esta", "estao", "consta",
        "existe", "tem", "foi", "era", "no", "na", "nos", "nas", "em", "banco",
        "acervo", "elotempo", "arvore", "sistema", "programa", "cadastrado",
        "cadastrada", "registrado", "registrada", "salvo", "salva", "que", "com",
        "para", "por", "ou", "ano", "seculo", "sec", "data", "hoje", "agora", "aqui",
        "professora", "professor", "historiadora", "historiador", "medica", "medico",
        "quem", "quais", "qual", "quando", "onde", "como", "quantos", "quantas",
    ];
    let artigos_iniciais = [
        "o", "a", "os", "as", "um", "uma", "algum", "alguma", "alguem", "pessoa",
        "cadastro", "registro", "ficha", "nome", "de", "do", "da", "para",
    ];
    let conectores = ["de", "da", "do", "dos", "das", "del", "di", "von", "van", "e"];

    let mut palavras_nome: Vec<&str> = Vec::new();

    for tok_bruto in trecho_norm.split(|c: char| {
        c == ',' || c == ';' || c == '(' || c == ')' || c == ':' || c == '?' || c == '!' || c == '.' || c.is_whitespace()
    }) {
        let t = tok_bruto.trim_matches(|c: char| !c.is_alphanumeric());
        if t.is_empty() {
            if !palavras_nome.is_empty() && (tok_bruto.contains(',') || tok_bruto.contains('(') || tok_bruto.contains('?')) {
                break;
            }
            continue;
        }
        // Se encontrar número (ex.: ano 1950), encerra o nome
        if t.chars().any(|c| c.is_ascii_digit()) {
            break;
        }
        if parar_cauda.contains(&t) {
            break;
        }
        if palavras_nome.is_empty() && artigos_iniciais.contains(&t) {
            continue;
        }
        // Se qualquer palavra for temática/categoria ("cientistas", "brasil", "penicilina", "bastilha"), não é nome de pessoa!
        if PALAVRAS_TEMATICAS_NAO_PESSOA.contains(&t) {
            return None;
        }

        palavras_nome.push(t);
        if palavras_nome.len() >= 6 {
            break;
        }
        if tok_bruto.ends_with(',') || tok_bruto.ends_with(';') || tok_bruto.ends_with('?') || tok_bruto.ends_with('!') {
            break;
        }
    }

    // Remove conectores soltos no final ("de", "da", "do")
    while let Some(&ult) = palavras_nome.last() {
        if conectores.contains(&ult) {
            palavras_nome.pop();
        } else {
            break;
        }
    }

    if palavras_nome.is_empty() {
        return None;
    }

    // Verifica se há pelo menos uma palavra substantiva de nome (>= 3 letras e não conector/título isolado)
    let tem_nome_substantivo = palavras_nome
        .iter()
        .any(|p| p.len() >= 3 && !conectores.contains(p) && !TITULOS_HONORIFICOS.contains(p));
    if !tem_nome_substantivo {
        return None;
    }

    Some(capitalizar_nome_pt(&palavras_nome.join(" ")))
}

/// Classificação da intenção do usuário no Assistente IA.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IntencaoUsuario {
    EntrevistaGuiada,
    CalcularParentesco,
    AuditarQualidadeAcervo,
    GerarBiografiaFactual,
    AdicionarParentesco,
    EditarLinhaTempo,
    CriarLinhaTempoDeTexto,
    CriarArvoreDeTexto,
    RegistrarOuEditarPessoa,
    ConsultarAcervo,
}

/// Classifica deterministicamente a intenção da mensagem do usuário.
pub fn classificar_intencao(mensagem: &str) -> IntencaoUsuario {
    let norm = sem_acento(mensagem);
    let norm_trim = norm.trim();

    // 1. Modo Entrevista Familiar Guiada
    if norm_trim.contains("entrevista guiada")
        || norm_trim.contains("passo a passo")
        || norm_trim.contains("criar familia passo a passo")
        || norm_trim.contains("ajude a montar minha familia")
        || norm_trim.contains("comecar minha arvore do zero")
    {
        return IntencaoUsuario::EntrevistaGuiada;
    }

    // 2. Calculadora de Parentesco
    if norm_trim.contains("qual o parentesco")
        || norm_trim.contains("qual e o parentesco")
        || norm_trim.contains("calcular parentesco")
        || norm_trim.contains("calcule o parentesco")
        || norm_trim.contains("grau de parentesco")
        || (norm_trim.contains("parentesco entre ") && norm_trim.contains(" e "))
        || (norm_trim.contains("qual a relacao entre ") && norm_trim.contains(" e "))
        || (norm_trim.contains("e parente de "))
    {
        return IntencaoUsuario::CalcularParentesco;
    }

    // 3. Auditoria de Qualidade / Cadastros Incompletos / Duplicatas
    if norm_trim.contains("cadastros incompletos")
        || norm_trim.contains("registros incompletos")
        || norm_trim.contains("dados faltantes")
        || norm_trim.contains("auditar arvore")
        || norm_trim.contains("audite a arvore")
        || norm_trim.contains("analisar qualidade")
        || norm_trim.contains("analise a qualidade")
        || norm_trim.contains("verificar duplicatas")
        || norm_trim.contains("quais pessoas estao sem data")
    {
        return IntencaoUsuario::AuditarQualidadeAcervo;
    }

    // 4. Redator de Biografia Factual
    if (norm_trim.contains("gere uma biografia")
        || norm_trim.contains("gerar biografia")
        || norm_trim.contains("gere uma minibiografia")
        || norm_trim.contains("escreva uma biografia")
        || norm_trim.contains("escreva a biografia")
        || norm_trim.contains("redija uma biografia"))
        && !norm_trim.contains("arvore")
    {
        return IntencaoUsuario::GerarBiografiaFactual;
    }

    // 5. Adição explícita de Parentesco a uma pessoa ("adicione X como filho de Y", "cadastre X como esposa de Y")
    let verbos_mutacao = [
        "adicione ", "adicionar ", "cadastre ", "cadastrar ", "registre ", "registrar ",
        "inclua ", "incluir ", "vincule ", "vincular ", "conecte ", "conectar ", "defina ",
    ];
    let tem_verbo_mutacao = verbos_mutacao.iter().any(|v| norm_trim.contains(v));
    let padroes_parentesco = [
        "como filho de", "como filha de", "como conjuge de", "como esposa de",
        "como marido de", "como pai de", "como mae de", "como irmao de", "como irma de",
        "filho para ", "filha para ", "esposa para ", "marido para ", "conjuge para ",
        "pai para ", "mae para ",
    ];
    if tem_verbo_mutacao && padroes_parentesco.iter().any(|p| norm_trim.contains(p)) {
        return IntencaoUsuario::AdicionarParentesco;
    }

    // 6. Edição ou Criação de Linha do Tempo
    if norm_trim.contains("linha do tempo")
        || norm_trim.contains("cronologia")
        || norm_trim.contains("marco historico")
        || norm_trim.contains("marcos historicos")
    {
        let pede_edicao_linha = norm_trim.contains("adicione na linha")
            || norm_trim.contains("adicionar na linha")
            || norm_trim.contains("adicione o marco")
            || norm_trim.contains("adicionar marco")
            || norm_trim.contains("inclua na linha")
            || norm_trim.contains("edite a linha")
            || norm_trim.contains("editar linha")
            || norm_trim.contains("altere o marco")
            || norm_trim.contains("remova o marco");
        if pede_edicao_linha {
            return IntencaoUsuario::EditarLinhaTempo;
        }

        let pede_criacao_linha = norm_trim.contains("crie ")
            || norm_trim.contains("criar ")
            || norm_trim.contains("monte ")
            || norm_trim.contains("montar ")
            || norm_trim.contains("gere ")
            || norm_trim.contains("gerar ")
            || norm_trim.contains("extraia ")
            || norm_trim.contains("extrair ")
            || norm_trim.contains("construa ")
            || norm_trim.contains("faca uma ")
            || norm_trim.contains("nova linha");
        if pede_criacao_linha {
            return IntencaoUsuario::CriarLinhaTempoDeTexto;
        }
    }

    // 7. Registro ou Edição de Pessoa Individual (deve vir ANTES de CriarArvoreDeTexto para que
    //    "Crie um cadastro de pessoa" ou "Quero cadastrar..." nunca caia em CriarArvoreDeTexto!)
    let pede_registro_ou_edicao_pessoa = norm_trim.contains("adicionar informac")
        || norm_trim.contains("adicione informac")
        || norm_trim.contains("adicionar dados")
        || norm_trim.contains("adicione dados")
        || norm_trim.contains("adicionar pessoa")
        || norm_trim.contains("adicione pessoa")
        || norm_trim.contains("incluir pessoa")
        || norm_trim.contains("inclua pessoa")
        || norm_trim.contains("criar pessoa")
        || norm_trim.contains("crie uma pessoa")
        || norm_trim.contains("crie a pessoa")
        || norm_trim.contains("criar uma pessoa")
        || norm_trim.contains("criar cadastro")
        || norm_trim.contains("criar um cadastro")
        || norm_trim.contains("criar o cadastro")
        || norm_trim.contains("crie um cadastro")
        || norm_trim.contains("crie o cadastro")
        || norm_trim.contains("fazer cadastro")
        || norm_trim.contains("fazer um cadastro")
        || norm_trim.contains("faca um cadastro")
        || norm_trim.contains("novo cadastro")
        || norm_trim.contains("cadastrar")
        || norm_trim.contains("cadastre")
        || norm_trim.contains("nova pessoa")
        || norm_trim.contains("novo registro")
        || norm_trim.contains("registrar ")
        || norm_trim.contains("registre ")
        || norm_trim.contains("abrir ficha")
        || norm_trim.contains("abra a ficha")
        || norm_trim.contains("abrir registro")
        || norm_trim.contains("abra o registro")
        || norm_trim.contains("abrir cadastro")
        || norm_trim.contains("abra o cadastro")
        || norm_trim.contains("pagina de registro")
        || norm_trim.contains("tela de cadastro")
        || norm_trim.contains("editar ficha")
        || norm_trim.contains("edite a ficha")
        || norm_trim.contains("editar pessoa")
        || norm_trim.contains("edite a pessoa")
        || norm_trim.contains("editar registro")
        || norm_trim.contains("editar informac")
        || norm_trim.contains("editar dados")
        || norm_trim.contains("atualizar ficha")
        || norm_trim.contains("atualize a ficha")
        || norm_trim.contains("atualizar dados")
        || norm_trim.contains("atualize os dados")
        || norm_trim.contains("altere a biografia")
        || norm_trim.contains("alterar biografia")
        || norm_trim.contains("atualize a biografia")
        || norm_trim.contains("altere o nascimento")
        || norm_trim.contains("altere o ano de nascimento")
        || norm_trim.contains("altere o falecimento")
        || norm_trim.contains("adicione a profissao")
        || norm_trim.contains("adicionar profissao")
        || norm_trim.contains("adicione a obra")
        || norm_trim.contains("adicionar obra")
        || norm_trim.contains("adicione o apelido")
        || norm_trim.contains("adicionar apelido")
        || norm_trim.contains("adicione o idioma")
        || norm_trim.contains("adicione a escolaridade")
        || norm_trim.contains("adicione a religiao");

    if pede_registro_ou_edicao_pessoa
        && !norm_trim.contains("arvore genealogica")
        && !norm_trim.contains("uma arvore")
    {
        return IntencaoUsuario::RegistrarOuEditarPessoa;
    }

    // 8. Criação de Árvore Completa a partir de texto
    let pede_criacao_arvore = (norm_trim.contains("crie ")
        || norm_trim.contains("criar ")
        || norm_trim.contains("monte ")
        || norm_trim.contains("montar ")
        || norm_trim.contains("gere ")
        || norm_trim.contains("gerar ")
        || norm_trim.contains("extraia ")
        || norm_trim.contains("extrair ")
        || norm_trim.contains("construa ")
        || norm_trim.contains("faca uma ")
        || norm_trim.contains("nova arvore"))
        && (norm_trim.contains("arvore")
            || norm_trim.contains("genealogia")
            || norm_trim.contains("familia")
            || norm_trim.contains("linhagem"));

    if pede_criacao_arvore {
        return IntencaoUsuario::CriarArvoreDeTexto;
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
    let anos = extrair_anos_do_texto(pergunta);
    let seculo_ou_periodo = extrair_intervalo_seculo_ou_periodo(pergunta);

    if eh_consulta_catalogo_acervo(pergunta) {
        return DecisaoAbstencao {
            deve_abster: false,
            confianca_maxima: 1.0,
            motivo: None,
        };
    }

    if (!anos.is_empty() || seculo_ou_periodo.is_some())
        && total_fatos_recuperados > 0
        && melhor_score_banco >= 0.55
    {
        return DecisaoAbstencao {
            deve_abster: false,
            confianca_maxima: melhor_score_banco,
            motivo: None,
        };
    }

    if total_fatos_recuperados == 0 || melhor_score_banco < 0.65 {
        return DecisaoAbstencao {
            deve_abster: true,
            confianca_maxima: melhor_score_banco,
            motivo: Some(
                "Não encontrei informações sobre essa pessoa, família ou acontecimento no banco de dados do EloTempo. \
                 Por compromisso com a fidelidade do seu acervo, o assistente **não utiliza conhecimentos externos de treinamento**.\n\n\
                 Se você quiser, pode clicar no botão abaixo para **abrir a página de cadastro** e registrar essa informação no EloTempo."
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
// EXTRATOR DETERMINÍSTICO / PRÉ-ANOTADOR NER DE ÁRVORES, PESSOAS E LINHAS DO TEMPO
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
        "camila", "fernanda", "patricia", "adriana", "juliana", "mariana", "gabriela",
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
        || ctx.contains("sexo feminino")
        || ctx.contains("mulher")
        || ctx.contains("nascida")
        || ctx.contains("falecida")
    {
        return "F".to_string();
    }

    if primeiro.ends_with('a') && !["luca", "nikola", "birajara", "ubirajara"].contains(&primeiro) {
        return "F".to_string();
    }
    "M".to_string()
}

/// Capitaliza uma string de nome próprio em português (preservando conectores `"de"`, `"da"`, `"do"`, `"dos"`, `"das"`, `"e"` em minúsculas).
pub fn capitalizar_nome_pt(texto: &str) -> String {
    let conectores = ["de", "da", "do", "dos", "das", "e"];
    texto
        .split_whitespace()
        .enumerate()
        .map(|(idx, palavra)| {
            let limpo = palavra.trim();
            let minusc = limpo.to_lowercase();
            if idx > 0 && conectores.contains(&minusc.as_str()) {
                return minusc;
            }
            if matches!(minusc.as_str(), "i" | "ii" | "iii" | "iv" | "v" | "vi" | "vii" | "viii" | "ix" | "x") {
                return minusc.to_uppercase();
            }
            let mut chars = minusc.chars();
            match chars.next() {
                Some(prim) => format!("{}{}", prim.to_uppercase(), chars.as_str()),
                None => String::new(),
            }
        })
        .collect::<Vec<String>>()
        .join(" ")
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
pub fn extrair_datas_biograficas_trecho(trecho: &str) -> (Option<i64>, Option<i64>) {
    let norm = sem_acento(trecho);

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

    let mut nasc = None;
    let mut morte = None;
    let palavras: Vec<&str> = limpo_traco
        .split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .collect();

    for i in 0..palavras.len() {
        let p = palavras[i];
        if p == "nasceu" || p == "nascido" || p == "nascida" || p == "nascimento" || p == "n" {
            for j in (i + 1)..(i + 5).min(palavras.len()) {
                if let Ok(ano) = palavras[j].parse::<i64>() {
                    if (1..=2100).contains(&ano) {
                        nasc = Some(ano);
                        break;
                    }
                }
            }
        } else if p == "faleceu" || p == "falecido" || p == "falecida" || p == "falecimento" || p == "morreu" || p == "morta" || p == "morto" {
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

    if let Some(ab) = limpo_traco.find('(') {
        if let Some(apos_ab) = limpo_traco.get(ab + 1..) {
            if let Some(fe) = apos_ab.find(')') {
                if let Some(dentro) = apos_ab.get(..fe) {
                    for tok in dentro.split(|c: char| !c.is_ascii_digit()) {
                        if let Ok(ano) = tok.parse::<i64>() {
                            if (1..=2100).contains(&ano) {
                                return (Some(ano), None);
                            }
                        }
                    }
                }
            }
        }
    }

    (None, None)
}

/// Extrai candidatos de nomes próprios capitalizados em português (ex.: "Giuseppe Rossi", "Maria Leopoldina").
pub fn extrair_nomes_proprios_com_contexto(texto: &str) -> Vec<(String, String)> {
    let ignorar_inicio = [
        "Crie", "Criar", "Monte", "Montar", "Gere", "Gerar", "Arvore", "Árvore", "Familia",
        "Família", "Linha", "Tempo", "Em", "No", "Na", "Nos", "Nas", "De", "Do", "Da",
        "Dos", "Das", "Seu", "Sua", "Seus", "Suas", "Meus", "Meu", "Minha", "Ele", "Ela",
        "Eles", "Elas", "Tiveram", "Teve", "Casou", "Casaram", "Nasceu", "Faleceu", "Morreu",
        "Filho", "Filha", "Filhos", "Filhas", "Pai", "Mãe", "Mae", "Pais", "Historia",
        "História", "Brasil", "Portugal", "Italia", "Itália", "Genova", "Gênova", "Rio",
        "Janeiro", "Sao", "São", "Lisboa", "Paris", "Londres", "Alemanha", "Espanha",
        "Adicionar", "Adicione", "Cadastrar", "Cadastre", "Registrar", "Registre", "Abrir",
        "Abra", "Editar", "Edite", "Ficha", "Registro", "Informacoes", "Informações",
        "Dados", "Sobre", "Pessoa", "Nova", "Novo", "Quero", "Gostaria", "Altere", "Alterar",
        "Atualize", "Atualizar", "Cadastro", "Qual", "Quais", "Quem", "Parentesco", "Entre",
        "Existe", "Existem", "Tem", "Alguem", "Alguém", "Algum", "Alguma", "Cadastrado",
        "Cadastrada", "Registrado", "Registrada", "Voce", "Você", "Conhece", "Onde", "Quando",
        "Como", "Por", "Para", "Fale", "Conte", "Mostre", "Liste",
    ];
    let conectores = ["de", "da", "do", "dos", "das", "e"];

    let mut resultados: Vec<(String, String)> = Vec::new();
    let mut vistos: HashSet<String> = HashSet::new();

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
                        if j + 1 < tokens_brutos.len() {
                            let prox = tokens_bruto_sem_parenteses(tokens_brutos[j + 1]);
                            if prox.chars().next().map(|c| c.is_uppercase()).unwrap_or(false)
                                && !ignorar_inicio.contains(&prox.as_str())
                            {
                                partes_nome.push(t_bruto);
                                partes_nome.push(prox);
                                j += 2;
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

    let mut unioes: Vec<ItemUniaoProposta> = Vec::new();
    if pessoas.len() >= 2 {
        let p1 = &pessoas[0];
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

        let mut titulo = seg
            .trim_start_matches(|c: char| c == '-' || c == '*' || c == '•' || c.is_whitespace())
            .to_string();
        if let Some(pos_dois_pontos) = titulo.find(':') {
            if let (Some(antes), Some(depois)) =
                (titulo.get(..pos_dois_pontos), titulo.get(pos_dois_pontos + 1..))
            {
                if sem_acento(antes).contains("linha do tempo") || antes.chars().count() <= 12 {
                    titulo = depois.trim().to_string();
                }
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

pub fn auditar_ancoragem_arvore(proposta: &mut PropostaCriarArvore, texto_fonte: &str) {
    let texto_norm = sem_acento(texto_fonte);
    let anos_permitidos: HashSet<i64> = extrair_anos_do_texto(texto_fonte).into_iter().collect();
    let mut alertas = Vec::new();

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

        if !["M", "F", "X", "U"].contains(&p.sexo.as_str()) {
            p.sexo = inferir_sexo_nome(&p.nome, &p.trecho_evidencia);
        }

        if let Some(ano_n) = p.ano_nascimento {
            if !anos_permitidos.contains(&ano_n) {
                alertas.push(format!(
                    "Ano de nascimento ({}) de '{}' removido: ano não consta no texto fornecido.",
                    ano_n, p.nome
                ));
                p.ano_nascimento = None;
            }
        }

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

    if !refs_validas.contains(&proposta.raiz_ref) {
        if let Some(primeira) = proposta.pessoas.first() {
            proposta.raiz_ref = primeira.ref_id.clone();
        }
    }

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
                alertas.push(format!(
                    "Vínculo descartado: '{}' já foi registrado como filho de outra união, e cada pessoa tem um único par de pais.",
                    f_ref
                ));
                return false;
            }
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

/// Extrai dados estruturados de uma pessoa a partir de um pedido de cadastro/adição de informações
/// ou pergunta de existência no chat — funcionando inclusive quando o usuário digita em letras minúsculas
/// ou passa apenas parte das informações (ex.: `"Existe alguém cadastrado com o nome de Gabriel Fernandes?"`
/// ou `"quero criar um cadastro para joao da silva nascido em 1945"`).
pub fn extrair_rascunho_pessoa_de_texto(texto: &str) -> Option<RascunhoCadastroPessoaIa> {
    let (ano_nascimento, ano_falecimento) = extrair_datas_biograficas_trecho(texto);

    // 1. Extrator dedicado de alvo de pessoa (suporta maiúsculas, minúsculas e perguntas de existência)
    if let Some(nome_alvo) = extrair_nome_alvo_consulta_pessoa(texto) {
        let (nome, sobrenome) = separar_nome_sobrenome(&nome_alvo);
        let sexo = inferir_sexo_nome(&nome_alvo, texto);
        let minibiografia = extrair_minibiografia_apos_nome(texto, &nome_alvo);

        return Some(RascunhoCadastroPessoaIa {
            nome,
            sobrenome,
            sexo,
            ano_nascimento,
            ano_falecimento,
            minibiografia,
        });
    }

    // 2. Nomes próprios capitalizados no texto
    let candidatos = extrair_nomes_proprios_com_contexto(texto);
    if let Some((nome_completo, _)) = candidatos.into_iter().next() {
        let (nome, sobrenome) = separar_nome_sobrenome(&nome_completo);
        let sexo = inferir_sexo_nome(&nome_completo, texto);
        let minibiografia = extrair_minibiografia_apos_nome(texto, &nome_completo);

        return Some(RascunhoCadastroPessoaIa {
            nome,
            sobrenome,
            sexo,
            ano_nascimento,
            ano_falecimento,
            minibiografia,
        });
    }

    None
}

fn extrair_minibiografia_apos_nome(texto: &str, nome_completo: &str) -> Option<String> {
    if let Some(pos_nome) = texto.find(nome_completo) {
        if let Some(resto) = texto.get(pos_nome + nome_completo.len()..) {
            let limpo = resto
                .trim_start()
                .trim_start_matches(|c: char| {
                    c == '(' || c == ')' || c == '-' || c == '–' || c.is_ascii_digit() || c.is_whitespace()
                })
                .trim_start_matches(|c: char| c == ',' || c == ':' || c == '-' || c == '–' || c.is_whitespace())
                .trim();
            if limpo.len() >= 4 {
                return Some(limpo.to_string());
            }
        }
    }
    None
}
