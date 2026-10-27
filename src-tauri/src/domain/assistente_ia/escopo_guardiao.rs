//! Estágio 0 — Guardião de Domínio, Escopo e Anti-Treinamento do EloTempo.
//!
//! Garante duas invariantes fundamentais exigidas pelo usuário:
//! 1. **Filtro Pré-Processamento de Pertinência ao EloTempo**: antes de executar buscas
//!    pesadas ou acionar o modelo de LLM local, verifica se o pedido do usuário refere-se
//!    exclusivamente aos **dados armazenados no banco SQLCipher** ou aos **recursos e tipos
//!    de informação do EloTempo**. Pedidos fora de escopo (inclusive perguntas-armadilha que
//!    usam palavras como "árvore", "família", "raiz" ou "vovó" fora do contexto genealógico)
//!    são rejeitados em `< 1 ms`.
//! 2. **Proibição Estrita de Conhecimento de Treinamento**: audita qualquer texto gerado
//!    pela LLM local contra o dossiê recuperado do banco (`auditar_resposta_contra_dossie`),
//!    impedindo que datas ou informações do pré-treinamento do modelo vazem para a resposta.

use std::collections::HashSet;
use sqlx::{Row, SqlitePool};

use crate::domain::erros::Resultado;
use crate::domain::texto::sem_acento;
use super::algoritmos_ml::{
    detectar_data_invalida_na_pergunta, extrair_anos_do_texto, extrair_intervalo_seculo_ou_periodo,
    extrair_nome_alvo_consulta_pessoa, radical_pt, tokenizar_significativo,
};

/// Resultado da verificação pré-processamento do Guardião de Escopo.
#[derive(Debug, Clone)]
pub struct DecisaoEscopo {
    pub permitido: bool,
    pub motivo_bloqueio: Option<String>,
}

/// Termos e padrões inequívocos que indicam tentativa de burlar regras, perguntas-armadilha
/// ou assuntos sem relação com o EloTempo.
///
/// Regras para esta tabela:
/// 1. Nunca inclua palavras isoladas ou expressões curtas que aparecem em narrativas familiares
///    ou notas de transcrição (ex.: "compilar", "derivada de", "no word", "no excel", "aja como",
///    "fora do banco", "uma piada").
/// 2. O casamento é feito por fronteira de palavras (`contem_padrao_com_fronteira`), nunca por
///    substring solta no meio de outra palavra.
const PADROES_FORA_DE_ESCOPO: &[&str] = &[
    // 1. Tentativas de jailbreak / prompt injection / uso de conhecimento de treinamento
    "ignore as instrucoes",
    "ignore todas as instrucoes",
    "ignore as regras",
    "esqueca as instrucoes",
    "esqueca as regras",
    "use seu conhecimento",
    "conhecimento de treinamento",
    "mesmo sem estar no banco",
    "finja que voce",
    "system prompt",
    "modo desenvolvedor",
    "chatgpt",
    "openai",
    // 2. Armadilhas com a palavra "árvore", "raiz", "família", "pai", "vovó" em outros domínios
    "arvore binaria",
    "arvores binarias",
    "arvore de decisao",
    "arvores de decisao",
    "arvore avl",
    "arvore rubro",
    "arvore b+",
    "arvore geradora",
    "arvore sintatica",
    "arvore de diretorio",
    "arvore de natal",
    "podar arvore",
    "plantar arvore",
    "plantar uma arvore",
    "cortar uma arvore",
    "raiz quadrada",
    "raiz cubica",
    "bolo da vovo",
    "receita da vovo",
    "receita de familia",
    "piada sobre familia",
    "piada de familia",
    "pai da aviacao",
    "pai da computacao",
    "pai da medicina",
    "como funciona um aviao",
    // 3. Programação, código, TI, aplicativos de escritório e hardware
    "codigo em python",
    "script em python",
    "codigo em javascript",
    "codigo em rust",
    "codigo em java",
    "codigo em c++",
    "inverter uma arvore",
    "escreva um codigo",
    "faca um programa",
    "como programar",
    "funcao recursiva",
    "algoritmo de ordenacao",
    "machine learning",
    "deep learning",
    "rede neural",
    "redes neurais",
    "docker",
    "kubernetes",
    "react component",
    "planilha no excel",
    "criar uma planilha",
    "editar uma foto no photoshop",
    "editar foto no photoshop",
    "como usar o photoshop",
    "instalar o windows",
    "formatar o pc",
    "placa de video",
    "qual pc devo comprar",
    "qual celular comprar",
    // 4. Culinária e receitas
    "receita de bolo",
    "receita de pao",
    "receita culinaria",
    "modo de preparo",
    "ingredientes para",
    "quantos ovos leva",
    "gramas de farinha",
    "ml de leite",
    "colher de sopa",
    "xicara de cha",
    "forno pre-aquecido",
    "como cozinhar",
    "como fazer arroz",
    "como fazer feijao",
    "como fazer bolo",
    "como fazer brigadeiro",
    "como fazer pudim",
    "como fazer lasanha",
    "como fazer pizza",
    "calorias de",
    "dieta para emagrecer",
    // 5. Clima, esportes, loteria, finanças, impostos, horóscopo, piadas
    "previsao do tempo",
    "vai chover",
    "temperatura hoje",
    "cotacao do dolar",
    "cotacao do euro",
    "preco do bitcoin",
    "criptomoeda",
    "bolsa de valores",
    "taxa selic",
    "imposto de renda",
    "declarar heranca",
    "salario minimo",
    "mega sena",
    "lotofacil",
    "numeros da sorte",
    "horoscopo",
    "mapa astral",
    "signo de aries",
    "signo de touro",
    "signo de gemeos",
    "signo de cancer",
    "signo de leao",
    "signo de virgem",
    "signo de libra",
    "signo de escorpiao",
    "signo de sagitario",
    "signo de capricornio",
    "signo de aquario",
    "signo de peixes",
    "conte uma piada",
    "me conta uma piada",
    "me conte uma piada",
    "placar do jogo",
    "campeonato brasileiro",
    "copa do mundo",
    "champions league",
    "libertadores da america",
    "quem vai ganhar",
    // 6. Matemática, física, química, biologia e geografia geral fora do acervo
    "resolva a equacao",
    "equacao de segundo grau",
    "calcular a derivada",
    "calcule a derivada",
    "calcular a integral",
    "calcule a integral",
    "formula de bhaskara",
    "teorema de pitagoras",
    "hipotenusa",
    "logaritmo",
    "tabela periodica",
    "fotossintese",
    "velocidade da luz",
    "distancia da terra",
    "sistema solar",
    "buraco negro",
    "buracos negros",
    "aquecimento global",
    "efeito estufa",
    "qual e a capital da",
    "qual a capital da",
    "qual e a capital do",
    "qual a capital do",
    "qual o maior rio",
    "qual a maior montanha",
    "qual o maior pais",
    "quantos habitantes tem",
    // 7. Medicina, direito comercial e tradução genérica
    "qual remedio tomar",
    "bula do remedio",
    "sintomas de gripe",
    "sintomas de dengue",
    "dor de cabeca",
    "traduza para o ingles",
    "traduza para o espanhol",
    "traduza esta frase",
    "como se diz em ingles",
    "escreva um email comercial",
    "contrato de aluguel",
    "curriculo profissional",
];

/// Verifica se `padrao` ocorre em `texto` respeitando fronteiras de palavras (caracteres
/// não-alfanuméricos ou extremidades da string). Isso impede que um padrão case no meio
/// de uma palavra ou nome próprio.
fn contem_padrao_com_fronteira(texto: &str, padrao: &str) -> bool {
    let padrao = padrao.trim();
    if padrao.is_empty() {
        return false;
    }
    let mut inicio_busca = 0;
    while let Some(pos_rel) = texto.get(inicio_busca..).and_then(|s| s.find(padrao)) {
        let idx = inicio_busca + pos_rel;
        let fim = idx + padrao.len();

        let antes_ok = if idx == 0 {
            true
        } else {
            texto
                .get(..idx)
                .and_then(|s| s.chars().next_back())
                .map(|c| !c.is_alphanumeric())
                .unwrap_or(true)
        };

        let depois_ok = if fim >= texto.len() {
            true
        } else {
            texto
                .get(fim..)
                .and_then(|s| s.chars().next())
                .map(|c| !c.is_alphanumeric())
                .unwrap_or(true)
        };

        if antes_ok && depois_ok {
            return true;
        }
        inicio_busca = idx + 1;
        while inicio_busca < texto.len() && !texto.is_char_boundary(inicio_busca) {
            inicio_busca += 1;
        }
    }
    false
}

/// Substantivos nucleares exclusivos do domínio do EloTempo (genealogia, cronologia e registros do acervo).
/// Nota: verbos genéricos ("criar", "editar", "mostrar") NÃO entram sozinhos aqui para evitar falsos positivos
/// como "como criar uma planilha" ou "como editar uma foto".
const SUBSTANTIVOS_NUCLEARES_ELOTEMPO: &[&str] = &[
    "elotempo", "acervo", "catalogo", "arvore", "arvores", "genealogia",
    "genealogica", "genealogicas", "linhagem", "linhagens", "familia", "familias",
    "pessoa", "pessoas", "personalidade", "personalidades", "personagem", "personagens",
    "membro", "membros", "individuo", "individuos", "cadastro", "cadastros",
    "ficha", "registro", "registros", "parentesco", "parente", "parentes",
    "ancestral", "ancestrais", "antepassado", "antepassados", "descendente", "descendentes",
    "geracao", "geracoes", "pai", "mae", "pais", "filho", "filha", "filhos", "filhas",
    "irmao", "irma", "irmaos", "irmas", "avo", "avos", "bisavo", "bisavos", "trisavo",
    "tetravo", "neto", "neta", "netos", "netas", "bisneto", "bisneta", "tio", "tia",
    "sobrinho", "sobrinha", "primo", "prima", "primos", "primas", "conjuge", "conjuges",
    "esposo", "esposa", "marido", "uniao", "unioes", "casamento", "casou", "casaram",
    "viuvo", "viuva", "nascimento", "nasceu", "nascido", "nascida", "falecimento",
    "faleceu", "morreu", "obito", "batismo", "batizado", "sepultamento", "sepultado",
    "imigracao", "imigrou", "emigrou", "desembarque", "longevo", "seculo",
    "linha do tempo", "linhas do tempo", "timeline", "cronologia", "marco historico",
    "marcos historicos", "biografia", "minibiografia", "profissao", "profissoes",
    "ocupacao", "obra cultural", "obras culturais", "escolaridade", "religiao",
    "religioes", "idioma", "idiomas", "apelido", "apelidos", "cognome", "sobrenome",
    "sobrenomes", "nacionalidade", "nacionalidades", "citacao", "citacoes", "certidao",
    "duplicata", "duplicatas", "incompleto", "incompletos", "entrevista guiada",
    "passo a passo", "monarquia", "monarquias", "dinastia", "dinastias", "imperador",
    "imperadores", "imperatriz", "imperatrizes", "farao", "faraos",
];

/// Verifica, antes de qualquer processamento pesado ou chamada à LLM, se a mensagem do usuário
/// está estritamente relacionada com o conteúdo armazenado no EloTempo ou com os recursos do EloTempo.
/// Verdadeiro quando a mensagem inteira é uma conta, e não texto com números.
///
/// "2 + 2" e "145 * 89" são contas. "João Silva *1890 +1965" não é: tem letras,
/// e letras são o que separa uma expressão aritmética de uma data genealógica.
fn eh_expressao_aritmetica_pura(texto: &str) -> bool {
    const SIMBOLOS: &str = " +-*/=x().,%^:";
    let tem_digito = texto.chars().any(|c| c.is_ascii_digit());
    let tem_operador = texto.chars().any(|c| "+-*/=x^%".contains(c));
    let so_simbolos = texto
        .chars()
        .all(|c| c.is_ascii_digit() || SIMBOLOS.contains(c));
    tem_digito && tem_operador && so_simbolos
}

pub async fn verificar_escopo_elotempo(
    pool: &SqlitePool,
    mensagem: &str,
    tem_contexto_conversa: bool,
) -> Resultado<DecisaoEscopo> {
    let norm = sem_acento(mensagem);
    let norm_trim = norm.trim();

    if norm_trim.is_empty() {
        return Ok(DecisaoEscopo {
            permitido: false,
            motivo_bloqueio: Some(
                "Digite uma pergunta sobre o acervo ou peça para criar/editar um registro no EloTempo."
                    .to_string(),
            ),
        });
    }

    // 1. Bloqueio imediato para padrões explícitos fora de escopo, perguntas-armadilha ou jailbreaks
    for padrao in PADROES_FORA_DE_ESCOPO {
        if contem_padrao_com_fronteira(norm_trim, padrao) {
            return Ok(DecisaoEscopo {
                permitido: false,
                motivo_bloqueio: Some(mensagem_recusa_fora_de_escopo()),
            });
        }
    }

    // 2. Bloqueia expressões matemáticas ("quanto é 145 * 89", "2 + 2", "100 / 5")
    //
    // Barrar a simples PRESENÇA de `+`, `*` ou `=` era caro demais: esses três
    // são a taquigrafia genealógica clássica -- `*` nasceu, `+` faleceu,
    // `=` casou-se --, usada em quase toda genealogia publicada. Como este
    // guardião roda no Estágio 0, antes de tudo, colar "João Silva *1890
    // +1965" para criar uma árvore era recusado como pergunta de matemática.
    //
    // Exigir dígito-operador-dígito também não resolve: "1890 +1965" casa.
    // O que distingue uma conta é a mensagem ser SÓ a conta, sem prosa.
    if eh_expressao_aritmetica_pura(norm_trim)
        || ((norm_trim.starts_with("quanto e ")
            || norm_trim.starts_with("calcule ")
            || norm_trim.starts_with("calcular ")
            || norm_trim.starts_with("resolva "))
            && norm_trim.chars().any(|c| c.is_ascii_digit()))
    {
        return Ok(DecisaoEscopo {
            permitido: false,
            motivo_bloqueio: Some(mensagem_recusa_fora_de_escopo()),
        });
    }

    // 3. Verifica se a mensagem contém uma data impossível/inválida (ex.: "32/15/1890", "31/02/1900", "ano 99999")
    if let Some(msg_data_invalida) = detectar_data_invalida_na_pergunta(mensagem) {
        return Ok(DecisaoEscopo {
            permitido: false,
            motivo_bloqueio: Some(msg_data_invalida),
        });
    }

    // 4. Se há uma conversa em andamento (ex.: entrevista guiada ou pergunta de continuação com pronomes)
    if tem_contexto_conversa && eh_continuacao_conversacional(norm_trim) {
        return Ok(DecisaoEscopo {
            permitido: true,
            motivo_bloqueio: None,
        });
    }

    // 5. Se a pergunta consulta ou pede cadastro de um nome próprio de pessoa (ex.: "Quem foi...", "Existe alguém...")
    if extrair_nome_alvo_consulta_pessoa(mensagem).is_some() {
        return Ok(DecisaoEscopo {
            permitido: true,
            motivo_bloqueio: None,
        });
    }

    // 6. Verifica se contém substantivos nucleares dos recursos/tipos de dados do EloTempo
    if contem_substantivo_nuclear_elotempo(norm_trim) {
        return Ok(DecisaoEscopo {
            permitido: true,
            motivo_bloqueio: None,
        });
    }

    // 7. Verifica se menciona anos históricos ou séculos acompanhados de contexto biográfico/histórico ou dados do banco
    if (!extrair_anos_do_texto(mensagem).is_empty()
        || extrair_intervalo_seculo_ou_periodo(mensagem).is_some())
        && (norm_trim.contains("quem")
            || norm_trim.contains("quais")
            || norm_trim.contains("aconteceu")
            || norm_trim.contains("ocorreu")
            || norm_trim.contains("evento")
            || norm_trim.contains("marco")
            || norm_trim.contains("entre ")
            || norm_trim.contains("decada")
            || norm_trim.contains("seculo")
            || norm_trim.contains("sec ")
            || norm_trim.contains("por volta")
            || norm_trim.contains("cerca de")
            || norm_trim.contains("aprox"))
    {
        return Ok(DecisaoEscopo {
            permitido: true,
            motivo_bloqueio: None,
        });
    }

    // 8. Sondagem rápida no índice de dados armazenados no SQLCipher (nomes, obras, locais, países, profissões, etc.)
    if mensagem_menciona_dado_armazenado(pool, mensagem).await? {
        return Ok(DecisaoEscopo {
            permitido: true,
            motivo_bloqueio: None,
        });
    }

    // 9. Não pertence nem aos recursos/tipos de informação do EloTempo nem aos dados armazenados no banco!
    Ok(DecisaoEscopo {
        permitido: false,
        motivo_bloqueio: Some(mensagem_recusa_fora_de_escopo()),
    })
}

fn mensagem_recusa_fora_de_escopo() -> String {
    "Este pedido **não está relacionado às informações armazenadas nem aos recursos do EloTempo**.\n\n\
     Por diretriz de segurança e fidelidade, o Assistente IA Local **não responde perguntas de conhecimento geral externo** e atua exclusivamente para:\n\
     - **Pesquisar informações gravadas no banco de dados** (pessoas, árvores, parentescos, eventos, locais, profissões, obras, escolaridade, linhas do tempo e fontes);\n\
     - **Criar e editar registros** de pessoas, parentescos, árvores genealógicas e linhas do tempo no EloTempo."
        .to_string()
}

fn eh_continuacao_conversacional(norm: &str) -> bool {
    let gatilhos_continuacao = [
        "ele", "ela", "dele", "dela", "deles", "delas", "nele", "nela",
        "esse", "essa", "este", "esta", "mesmo", "mesma", "sim", "nao",
        "abrir", "abra", "arvore", "linha", "ficha", "registro", "continuar",
        "proximo", "proxima", "salvar",
    ];
    gatilhos_continuacao.iter().any(|g| {
        norm == *g
            || norm.contains(&format!(" {} ", g))
            || norm.starts_with(&format!("{} ", g))
            || norm.ends_with(&format!(" {}", g))
    })
}

fn contem_substantivo_nuclear_elotempo(norm: &str) -> bool {
    let palavras_msg: Vec<&str> = norm
        .split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .collect();

    for termo in SUBSTANTIVOS_NUCLEARES_ELOTEMPO {
        if termo.contains(' ') {
            if norm.contains(termo) {
                return true;
            }
        } else {
            let rad_termo = radical_pt(termo);
            if palavras_msg.iter().any(|p| {
                *p == *termo || (rad_termo.len() >= 4 && radical_pt(p) == rad_termo)
            }) {
                return true;
            }
        }
    }

    // Perguntas sobre obras/livros/fontes/locais/países/profissões especificamente no acervo/banco
    let termos_contextuais = [
        "obra", "obras", "livro", "livros", "autor", "autores", "escritor", "escritores",
        "cientista", "cientistas", "musico", "musicos", "compositor", "compositores",
        "presidente", "presidentes", "politico", "politicos", "empreendedor", "empreendedores",
        "pioneiro", "pioneiros", "local", "locais", "cidade", "cidades", "pais", "paises",
        "fonte", "fontes", "documento", "documentos", "evento", "eventos", "marco", "marcos",
        "historia", "biografia", "biblia", "biblico", "biblicos", "patriarca", "patriarcas",
        "ficcao", "ficticio", "ficticios", "antiguidade", "mulher", "mulheres", "antiga", "antigo",
    ];
    let mencao_contextual = termos_contextuais.iter().any(|tc| {
        let rad = radical_pt(tc);
        palavras_msg
            .iter()
            .any(|p| *p == *tc || (rad.len() >= 4 && radical_pt(p) == rad))
    });

    if mencao_contextual
        && (norm.contains("quais")
            || norm.contains("quem")
            || norm.contains("quantos")
            || norm.contains("quantas")
            || norm.contains("existe")
            || norm.contains("tem ")
            || norm.contains("registrad")
            || norm.contains("cadastrad")
            || norm.contains("salvo")
            || norm.contains("banco")
            || norm.contains("acervo")
            || norm.contains("elotempo"))
    {
        return true;
    }

    false
}

/// Sondagem rápida para verificar se algum token da mensagem corresponde a um dado armazenado nas tabelas do EloTempo.
async fn mensagem_menciona_dado_armazenado(
    pool: &SqlitePool,
    mensagem: &str,
) -> Resultado<bool> {
    let tokens = tokenizar_significativo(mensagem);
    if tokens.is_empty() {
        return Ok(false);
    }

    let linhas = sqlx::query(
        r#"
        SELECT nome AS txt FROM pessoas WHERE is_placeholder = 0
        UNION ALL
        SELECT COALESCE(sobrenome, '') FROM pessoas WHERE is_placeholder = 0 AND sobrenome IS NOT NULL
        UNION ALL
        SELECT nome FROM arvores
        UNION ALL
        SELECT COALESCE(categoria, '') FROM arvores WHERE categoria IS NOT NULL
        UNION ALL
        SELECT titulo FROM linhas_tempo
        UNION ALL
        SELECT titulo FROM eventos_linha
        UNION ALL
        SELECT titulo FROM obras_culturais
        UNION ALL
        SELECT ocupacao FROM profissoes_pessoa
        UNION ALL
        SELECT apelido FROM apelidos_pessoa
        UNION ALL
        SELECT nome FROM locais
        UNION ALL
        SELECT nome FROM paises
        UNION ALL
        SELECT titulo FROM fontes
        UNION ALL
        SELECT COALESCE(instituicao, '') FROM escolaridade_pessoa WHERE instituicao IS NOT NULL
        UNION ALL
        SELECT denominacao FROM religioes_pessoa
        UNION ALL
        SELECT idioma FROM idiomas_pessoa
        UNION ALL
        SELECT titulo FROM marcadores_linha_tempo
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut vocab_palavras: HashSet<String> = HashSet::new();
    for r in linhas {
        if let Ok(t) = r.try_get::<String, _>("txt") {
            for w in sem_acento(&t).split(|c: char| !c.is_alphanumeric()) {
                let w = w.trim();
                if w.len() >= 3 {
                    vocab_palavras.insert(w.to_string());
                }
            }
        }
    }

    for tok in &tokens {
        if tok.len() >= 3 && vocab_palavras.contains(tok.as_str()) {
            return Ok(true);
        }
        let rad = radical_pt(tok);
        if rad.len() >= 4 && vocab_palavras.iter().any(|vp| radical_pt(vp) == rad) {
            return Ok(true);
        }
    }

    Ok(false)
}

/// Audita a resposta gerada pela LLM local contra o dossiê recuperado do banco:
/// - Se a LLM citar qualquer ano numérico que não exista no `contexto_dossie` nem na `pergunta`,
///   rejeita a resposta da LLM (retorna `None`) para impedir vazamento de dados do treinamento.
/// - Se a LLM responder com frases de negação ("não existe", "não encontrei", "não consta")
///   quando o dossiê foi enviado, retorna `None` para que o motor determinístico ou o portão de abstenção assuma.
pub fn auditar_resposta_contra_dossie(
    resposta_llm: &str,
    contexto_dossie: &str,
    pergunta: &str,
) -> Option<String> {
    let resp_trim = resposta_llm.trim();
    if resp_trim.is_empty() {
        return None;
    }

    let resp_norm = sem_acento(resp_trim);
    let padroes_negacao_llm = [
        "nao possui essa informacao",
        "nao encontrei informacoes",
        "nao encontrei nenhum",
        "nao encontrei reg",
        "nao ha registros",
        "nao ha alguem",
        "nao ha ninguem",
        "nao existe alguem",
        "nao existe ninguem",
        "nao existe registro",
        "nao existe cadastro",
        "nao consta no acervo",
        "nao consta no banco",
        "nao foi encontrad",
        "como uma ia",
        "meu treinamento",
    ];
    if padroes_negacao_llm.iter().any(|p| resp_norm.contains(p)) {
        return None;
    }

    let mut anos_permitidos: HashSet<i64> = extrair_anos_do_texto(contexto_dossie)
        .into_iter()
        .collect();
    for a in extrair_anos_do_texto(pergunta) {
        anos_permitidos.insert(a);
    }

    let anos_na_resposta = extrair_anos_do_texto(resp_trim);
    for ano_resp in anos_na_resposta {
        if ano_resp.abs() >= 100 && !anos_permitidos.contains(&ano_resp) {
            return None;
        }
    }

    Some(resp_trim.to_string())
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    async fn banco() -> SqlitePool {
        let p = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations").run(&p).await.expect("migrations");
        p
    }

    /// A taquigrafia genealógica não é conta de matemática.
    ///
    /// `*` nasceu, `+` faleceu, `=` casou-se: é a notação de quase toda
    /// genealogia publicada, e era exatamente o que o filtro de aritmética
    /// barrava. Como este guardião roda no Estágio 0, colar um texto nesse
    /// formato para criar uma árvore — o recurso de maior destaque do
    /// assistente — era recusado antes de qualquer processamento.
    #[tokio::test]
    async fn notacao_genealogica_nao_e_confundida_com_conta() {
        let p = banco().await;
        for passa in [
            "Crie uma arvore: Joao Silva *1890 +1965 casou com Maria Souza *1895",
            "Pedro Alves (1901-1980) = Ana Lima (1905-1988)",
            "Quem nasceu em *1890 na familia?",
        ] {
            let d = verificar_escopo_elotempo(&p, passa, false).await.unwrap();
            assert!(d.permitido, "bloqueou notação genealógica legítima: {passa}");
        }
    }

    /// Conta continua sendo conta, e continua barrada.
    #[tokio::test]
    async fn conta_de_matematica_continua_bloqueada() {
        let p = banco().await;
        for bloqueia in ["2 + 2", "145 * 89", "100 / 5", "quanto e 145 * 89", "calcule 7 x 8"] {
            let d = verificar_escopo_elotempo(&p, bloqueia, false).await.unwrap();
            assert!(!d.permitido, "deixou passar uma conta: {bloqueia}");
        }
    }

    /// Frases genealógicas legítimas que contêm palavras antes barradas como substring
    /// ("compilar", "derivada de", "no word", "no excel", "fora do banco", "uma piada")
    /// não podem ser bloqueadas no Estágio 0.
    #[tokio::test]
    async fn prosa_genealogica_com_palavras_ambiguas_nao_e_bloqueada() {
        let p = banco().await;
        for passa in [
            "Quero compilar os dados da familia Silva em uma arvore",
            "A linhagem dos Braganca e derivada de qual ramo portugues?",
            "Crie uma arvore com o texto que anotei no Word: Joao Silva (1910-1980), filho de Pedro Silva (1880-1950)",
            "Tenho os nomes dos bisavos anotados no Excel e quero cadastrar a familia no EloTempo",
            "Existe alguma pessoa fora do banco que preciso cadastrar na arvore?",
            "Meu avo contava uma piada nos almocos de familia: qual o cadastro dele?",
        ] {
            let d = verificar_escopo_elotempo(&p, passa, false).await.unwrap();
            assert!(
                d.permitido,
                "bloqueou frase genealógica legítima por falso positivo de substring: {passa}"
            );
        }
    }
}
