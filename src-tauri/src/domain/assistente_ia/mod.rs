//! Assistente de IA Local Sob Demanda + Pipeline Neuro-Simbólico (EloTempo).
//!
//! Opera estritamente no **Cenário A (Grounded QA & Extração Verificada)**:
//! - Só responde perguntas cujos fatos estejam presentes no banco SQLCipher ou na conversa atual.
//! - Se a informação não estiver no banco nem no texto enviado no chat, aciona o
//!   **Portão de Abstenção** e informa transparentemente que não possui esses dados.
//! - Permite estruturar e criar novas **Árvores Genealógicas** e **Linhas do Tempo**
//!   a partir de textos colados pelo usuário, auditando cada nome e data pelo
//!   verificador **Quote-and-Verify** antes de apresentar o card de confirmação.

pub mod algoritmos_ml;
pub mod executor;
pub mod gerenciador_modelo;
pub mod recuperador;

use std::path::PathBuf;
use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::State;

use crate::domain::erros::{ErroDominio, Resultado};
use algoritmos_ml::{
    auditar_ancoragem_arvore, auditar_ancoragem_linha_tempo, avaliar_portao_abstencao,
    classificar_intencao, extrair_arvore_de_texto, extrair_linha_tempo_de_texto, IntencaoUsuario,
};
use executor::executar_proposta_confirmada;
pub use gerenciador_modelo::EstadoIaLocal;
use gerenciador_modelo::{chamar_llm_local_chat, verificar_endpoint_ativo};
use recuperador::{recuperar_contexto_acervo, vincular_pessoas_existentes};

// ============================================================================
// ESTRUTURAS DE DADOS (SERIALIZÁVEIS PARA O FRONTEND)
// ============================================================================

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InfoModeloCatalogo {
    pub id: String,
    pub nome: String,
    pub arquivo: String,
    pub url_download: String,
    /// SHA-256 do arquivo publicado, em minusculas. O download so e aceito se
    /// bater: um .gguf de 1 GB vindo da rede vira entrada de um servidor de
    /// inferencia, e conferir o que chegou e barato perto disso.
    pub sha256_esperado: String,
    pub tamanho_bytes_estimado: u64,
    pub ram_recomendada_gb: u32,
    pub descricao: String,
    pub instalado: bool,
    pub tamanho_em_disco: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StatusIaLocal {
    pub motor_instalado: bool,
    pub servidor_online: bool,
    pub endpoint_local: String,
    pub modelo_ativo_id: Option<String>,
    pub modelos_catalogo: Vec<InfoModeloCatalogo>,
    pub download_em_andamento: bool,
    pub download_modelo_id: Option<String>,
    pub download_bytes_atuais: u64,
    pub download_bytes_totais: u64,
    pub ultimo_erro_download: Option<String>,
    pub pasta_modelos: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct CitacaoAcervoIa {
    pub tipo: String,
    pub id: String,
    pub titulo: String,
    pub detalhe: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ItemPessoaProposta {
    pub ref_id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub ano_nascimento: Option<i64>,
    pub ano_falecimento: Option<i64>,
    pub minibiografia: Option<String>,
    pub trecho_evidencia: String,
    pub pessoa_existente_id: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ItemUniaoProposta {
    pub pai_ref: Option<String>,
    pub mae_ref: Option<String>,
    pub ano_casamento: Option<i64>,
    pub filhos_refs: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct PropostaCriarArvore {
    pub nome_arvore: String,
    pub descricao: Option<String>,
    pub categoria: Option<String>,
    pub raiz_ref: String,
    pub pessoas: Vec<ItemPessoaProposta>,
    pub unioes: Vec<ItemUniaoProposta>,
    pub ancoragem_verificada: bool,
    pub alertas_auditoria: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ItemMarcoProposto {
    pub titulo: String,
    pub ano_inicio: i64,
    pub ano_fim: Option<i64>,
    pub data_periodo_texto: String,
    pub descricao: Option<String>,
    pub relevancia: String,
    pub trecho_evidencia: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct PropostaCriarLinhaTempo {
    pub titulo_linha: String,
    pub categoria: String,
    pub fonte_referencia: Option<String>,
    pub marcos: Vec<ItemMarcoProposto>,
    pub ancoragem_verificada: bool,
    pub alertas_auditoria: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(tag = "tipo_acao", content = "dados")]
pub enum PropostaAcaoIa {
    #[serde(rename = "criar_arvore")]
    CriarArvore(PropostaCriarArvore),
    #[serde(rename = "criar_linha_tempo")]
    CriarLinhaTempo(PropostaCriarLinhaTempo),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RespostaAssistenteIa {
    pub resposta_markdown: String,
    pub abstencao: bool,
    pub confianca: f64,
    pub modo_execucao: String,
    pub citacoes: Vec<CitacaoAcervoIa>,
    pub proposta_acao: Option<PropostaAcaoIa>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ResultadoExecucaoIa {
    pub tipo: String,
    pub entidade_id: String,
    pub raiz_pessoa_id: Option<String>,
    pub titulo: String,
    pub itens_criados: usize,
    pub mensagem: String,
    /// O que a prevista prometia e o banco recusou. Fica vazio no caso normal.
    /// Existe porque o usuario aprova um card com os vinculos listados: se um
    /// deles cai na hora de gravar, calar seria entregar uma arvore diferente
    /// da que ele confirmou.
    #[serde(default)]
    pub avisos: Vec<String>,
}

// ============================================================================
// LÓGICA CENTRAL DE PROCESSAMENTO DE CONSULTA / EXTRAÇÃO
// ============================================================================

const SYSTEM_PROMPT_CENARIO_A: &str = "\
Você é o Assistente Genealógico e Histórico oficial do software EloTempo. \
REGRA ABSOLUTA DE SEGURANÇA FACTUAL: \
1. Responda EXCLUSIVAMENTE com base nos REGISTROS VERIFICADOS DO ACERVO fornecidos abaixo. \
2. NUNCA use conhecimento externo nem invente datas, locais, parentescos ou biografias. \
3. Se a informação solicitada não constar explicitamente nos registros abaixo, diga claramente que o acervo não possui essa informação. \
4. Responda em português claro, elegante e objetivo.";

/// Processa uma mensagem enviada ao Assistente IA sobre o banco `pool`,
/// opcionalmente utilizando o `endpoint_llm` local se estiver ativo.
pub async fn processar_mensagem_assistente_db(
    pool: &SqlitePool,
    mensagem: &str,
    endpoint_llm: Option<&str>,
) -> Resultado<RespostaAssistenteIa> {
    let msg_trim = mensagem.trim();
    if msg_trim.is_empty() {
        return Err(ErroDominio::Validacao(
            "Digite uma pergunta ou cole um texto para o assistente analisar.".to_string(),
        ));
    }

    let intencao = classificar_intencao(msg_trim);

    match intencao {
        IntencaoUsuario::CriarArvoreDeTexto => {
            processar_intencao_criar_arvore(pool, msg_trim, endpoint_llm).await
        }
        IntencaoUsuario::CriarLinhaTempoDeTexto => {
            processar_intencao_criar_linha_tempo(msg_trim, endpoint_llm).await
        }
        IntencaoUsuario::ConsultarAcervo => {
            processar_intencao_consulta(pool, msg_trim, endpoint_llm).await
        }
    }
}

async fn processar_intencao_criar_arvore(
    pool: &SqlitePool,
    texto_usuario: &str,
    endpoint_llm: Option<&str>,
) -> Resultado<RespostaAssistenteIa> {
    // 1. Roda o pré-anotador NER / extrator gramatical determinístico no texto do usuário
    let mut proposta_opt = extrair_arvore_de_texto(texto_usuario);
    let mut usou_llm = false;

    // 2. Se houver um servidor LLM local online, solicita refinamento em JSON estruturado
    if let Some(ep) = endpoint_llm {
        if verificar_endpoint_ativo(ep).await {
            let prompt_json = format!(
                "Extraia uma árvore genealógica ESTRITAMENTE a partir do texto abaixo. \
                 NÃO invente nenhuma pessoa nem data que não esteja escrita no texto.\n\n\
                 TEXTO DO USUÁRIO:\n{}",
                texto_usuario
            );
            let sys_json = "Retorne APENAS um objeto JSON válido com os campos: \
                {\"nome_arvore\": string, \"descricao\": string, \"categoria\": \"Pessoal\", \
                 \"raiz_ref\": \"@p1\", \
                 \"pessoas\": [{\"ref_id\": \"@p1\", \"nome\": string, \"sobrenome\": string|null, \"sexo\": \"M\"|\"F\", \"ano_nascimento\": number|null, \"ano_falecimento\": number|null, \"trecho_evidencia\": string}], \
                 \"unioes\": [{\"pai_ref\": string|null, \"mae_ref\": string|null, \"ano_casamento\": number|null, \"filhos_refs\": [string]}]}";

            if let Some(json_str) = chamar_llm_local_chat(ep, sys_json, &prompt_json, true).await {
                if let Ok(mut prop_llm) = serde_json::from_str::<PropostaCriarArvore>(&json_str) {
                    auditar_ancoragem_arvore(&mut prop_llm, texto_usuario);
                    if !prop_llm.pessoas.is_empty() {
                        proposta_opt = Some(prop_llm);
                        usou_llm = true;
                    }
                }
            }
        }
    }

    match proposta_opt {
        Some(mut proposta) => {
            // Executa Record Linkage com Jaro-Winkler para detectar duplicatas no banco
            vincular_pessoas_existentes(pool, &mut proposta).await?;

            let qtd_pessoas = proposta.pessoas.len();
            let qtd_unioes = proposta.unioes.len();
            let qtd_existentes = proposta
                .pessoas
                .iter()
                .filter(|p| p.pessoa_existente_id.is_some())
                .count();

            let mut texto_resp = format!(
                "Preparei a estrutura da árvore **{}** a partir dos dados que você forneceu no chat:\n\n\
                 - **{} pessoa(s)** identificada(s) e verificada(s) no texto;\n\
                 - **{} união(ões) familiar(es)** estruturada(s);\n\
                 - **Verificador Quote-and-Verify**: 100% dos nomes e datas foram conferidos contra o seu texto original.",
                proposta.nome_arvore, qtd_pessoas, qtd_unioes
            );

            if qtd_existentes > 0 {
                texto_resp.push_str(&format!(
                    "\n- **Record Linkage (Jaro-Winkler)**: {} pessoa(s) já existente(s) no seu acervo foi(foram) reconhecida(s) para evitar duplicação.",
                    qtd_existentes
                ));
            }

            texto_resp.push_str("\n\nRevise o cartão abaixo e clique em **Confirmar e Criar no Acervo** para gravar a árvore.");

            Ok(RespostaAssistenteIa {
                resposta_markdown: texto_resp,
                abstencao: false,
                confianca: 0.96,
                modo_execucao: if usou_llm {
                    "LLM Local + Auditoria Quote-and-Verify".to_string()
                } else {
                    "Motor Neuro-Simbólico Rust + Quote-and-Verify".to_string()
                },
                citacoes: Vec::new(),
                proposta_acao: Some(PropostaAcaoIa::CriarArvore(proposta)),
            })
        }
        None => Ok(RespostaAssistenteIa {
            resposta_markdown: "Não consegui identificar nomes próprios e relações familiares suficientes na sua mensagem para montar uma árvore.\n\n\
                Por segurança (Cenário A), **o assistente não inventa árvores sem dados fornecidos por você**. \
                Envie um texto descrevendo os membros da família (ex.: *\"Crie uma árvore: Giuseppe Rossi (1882-1950) casou-se em 1905 com Teresa Bianchi (1885-1962) e tiveram os filhos Luigi Rossi (1906) e Anna Rossi (1908).\"*)."
                .to_string(),
            abstencao: true,
            confianca: 0.0,
            modo_execucao: "Portão de Abstenção (Dados Insuficientes no Chat)".to_string(),
            citacoes: Vec::new(),
            proposta_acao: None,
        }),
    }
}

async fn processar_intencao_criar_linha_tempo(
    texto_usuario: &str,
    endpoint_llm: Option<&str>,
) -> Resultado<RespostaAssistenteIa> {
    let mut proposta_opt = extrair_linha_tempo_de_texto(texto_usuario);
    let mut usou_llm = false;

    if let Some(ep) = endpoint_llm {
        if verificar_endpoint_ativo(ep).await {
            let prompt_json = format!(
                "Extraia uma linha do tempo ESTRITAMENTE a partir dos eventos e anos presentes no texto abaixo. \
                 NÃO invente nenhum ano nem evento que não esteja no texto.\n\n\
                 TEXTO DO USUÁRIO:\n{}",
                texto_usuario
            );
            let sys_json = "Retorne APENAS um objeto JSON válido com os campos: \
                {\"titulo_linha\": string, \"categoria\": \"História & Cronologia\", \
                 \"marcos\": [{\"titulo\": string, \"ano_inicio\": number, \"ano_fim\": number|null, \"data_periodo_texto\": string, \"descricao\": string, \"relevancia\": \"alta\", \"trecho_evidencia\": string}]}";

            if let Some(json_str) = chamar_llm_local_chat(ep, sys_json, &prompt_json, true).await {
                if let Ok(mut prop_llm) = serde_json::from_str::<PropostaCriarLinhaTempo>(&json_str) {
                    auditar_ancoragem_linha_tempo(&mut prop_llm, texto_usuario);
                    if !prop_llm.marcos.is_empty() {
                        proposta_opt = Some(prop_llm);
                        usou_llm = true;
                    }
                }
            }
        }
    }

    match proposta_opt {
        Some(proposta) => {
            let qtd = proposta.marcos.len();
            let texto_resp = format!(
                "Preparei a linha do tempo **{}** com **{} marco(s) cronológico(s)** extraído(s) e verificado(s) a partir do seu texto.\n\n\
                 Confira os eventos abaixo e clique em **Confirmar e Criar no Acervo** para adicioná-la ao Estúdio de Linhas do Tempo.",
                proposta.titulo_linha, qtd
            );

            Ok(RespostaAssistenteIa {
                resposta_markdown: texto_resp,
                abstencao: false,
                confianca: 0.96,
                modo_execucao: if usou_llm {
                    "LLM Local + Auditoria Quote-and-Verify".to_string()
                } else {
                    "Motor Neuro-Simbólico Rust + Quote-and-Verify".to_string()
                },
                citacoes: Vec::new(),
                proposta_acao: Some(PropostaAcaoIa::CriarLinhaTempo(proposta)),
            })
        }
        None => Ok(RespostaAssistenteIa {
            resposta_markdown: "Para criar uma linha do tempo com segurança (sem inventar datas externas), inclua os anos e acontecimentos no próprio texto da mensagem.\n\n\
                *Exemplo: \"Crie uma linha do tempo da família: Em 1895 chegada ao porto de Santos; Em 1912 compra da fazenda em Campinas; Em 1934 fundação da tipografia.\"*".to_string(),
            abstencao: true,
            confianca: 0.0,
            modo_execucao: "Portão de Abstenção (Datas Ausentes no Chat)".to_string(),
            citacoes: Vec::new(),
            proposta_acao: None,
        }),
    }
}

async fn processar_intencao_consulta(
    pool: &SqlitePool,
    pergunta: &str,
    endpoint_llm: Option<&str>,
) -> Resultado<RespostaAssistenteIa> {
    let dossie = recuperar_contexto_acervo(pool, pergunta).await?;
    let decisao = avaliar_portao_abstencao(pergunta, dossie.melhor_score, dossie.total_fatos);

    if decisao.deve_abster {
        return Ok(RespostaAssistenteIa {
            resposta_markdown: decisao.motivo.unwrap_or_else(|| {
                "Não encontrei informações sobre isso no banco de dados nem na conversa atual.".to_string()
            }),
            abstencao: true,
            confianca: decisao.confianca_maxima,
            modo_execucao: "Portão de Abstenção (Cenário A)".to_string(),
            citacoes: Vec::new(),
            proposta_acao: None,
        });
    }

    // Se houver uma LLM local online, sintetiza a resposta estritamente sobre o dossiê recuperado
    if let Some(ep) = endpoint_llm {
        if verificar_endpoint_ativo(ep).await {
            let user_prompt = format!(
                "REGISTROS VERIFICADOS DO ACERVO ELOTEMPO:\n{}\n\n\
                 PERGUNTA DO USUÁRIO: {}\n\n\
                 Responda apenas com base nos registros acima:",
                dossie.contexto_markdown, pergunta
            );

            if let Some(resposta_llm) =
                chamar_llm_local_chat(ep, SYSTEM_PROMPT_CENARIO_A, &user_prompt, false).await
            {
                if !resposta_llm.is_empty() {
                    return Ok(RespostaAssistenteIa {
                        resposta_markdown: resposta_llm,
                        abstencao: false,
                        confianca: dossie.melhor_score,
                        modo_execucao: "LLM Local + RAG Determinístico SQLCipher".to_string(),
                        citacoes: dossie.citacoes,
                        proposta_acao: None,
                    });
                }
            }
        }
    }

    Ok(RespostaAssistenteIa {
        resposta_markdown: dossie.sintese_deterministica,
        abstencao: false,
        confianca: dossie.melhor_score,
        modo_execucao: "Motor Neuro-Simbólico Determinístico (SQLCipher + Jaro-Winkler)".to_string(),
        citacoes: dossie.citacoes,
        proposta_acao: None,
    })
}

// ============================================================================
// COMANDOS TAURI EXPOSTOS AO FRONTEND
// ============================================================================

#[tauri::command]
pub async fn obter_status_ia_local(
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<StatusIaLocal> {
    Ok(estado_ia.obter_status().await)
}

#[tauri::command]
pub async fn iniciar_download_modelo_ia(
    modelo_id: String,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<()> {
    estado_ia.iniciar_download(&modelo_id).await
}

#[tauri::command]
pub async fn cancelar_download_modelo_ia(
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<()> {
    estado_ia.cancelar_download();
    Ok(())
}

#[tauri::command]
pub async fn importar_modelo_gguf_local(
    caminho: String,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<String> {
    estado_ia.importar_gguf(&PathBuf::from(caminho)).await
}

#[tauri::command]
pub async fn remover_modelo_ia(
    modelo_id: String,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<()> {
    estado_ia.remover_modelo(&modelo_id).await
}

/// O endpoint do motor de IA precisa ser da propria maquina.
///
/// Cada pergunta ao assistente leva nomes, datas e parentescos da familia no
/// corpo da requisicao. Apontar isso para um host remoto mandaria o acervo
/// inteiro para fora, em silencio, contra a promessa da secao 1 da
/// especificacao e contra o que o site anuncia. O campo na tela se chama
/// "endpoint local"; quem colar uma URL de fora nao esperaria esse efeito.
///
/// Aceita so laco de retorno: `127.0.0.0/8`, `::1` e o nome `localhost`.
fn validar_endpoint_local(endpoint: &str) -> Resultado<String> {
    let limpo = endpoint.trim();
    if limpo.is_empty() {
        return Err(ErroDominio::Validacao(
            "Informe o endereço do motor de IA, por exemplo http://127.0.0.1:8080".to_string(),
        ));
    }

    let sem_proto = limpo
        .trim_start_matches("http://")
        .trim_start_matches("https://");
    let autoridade = sem_proto.split('/').next().unwrap_or("");

    // IPv6 vem entre colchetes: [::1]:8080
    let host = if let Some(fim) = autoridade.find(']') {
        autoridade
            .trim_start_matches('[')
            .get(..fim.saturating_sub(1))
            .unwrap_or("")
            .to_string()
    } else {
        autoridade.split(':').next().unwrap_or("").to_string()
    };

    let eh_local = host.eq_ignore_ascii_case("localhost")
        || host == "::1"
        || host == "0:0:0:0:0:0:0:1"
        || host
            .parse::<std::net::Ipv4Addr>()
            .map(|ip| ip.is_loopback())
            .unwrap_or(false);

    if !eh_local {
        return Err(ErroDominio::Validacao(format!(
            "O EloTempo só conversa com um motor de IA na sua própria máquina.              \"{}\" é um endereço externo, e usá-lo enviaria os nomes e as datas da              sua família para fora do computador. Use 127.0.0.1 ou localhost.",
            host
        )));
    }

    Ok(limpo.to_string())
}

#[tauri::command]
pub async fn configurar_endpoint_ia_local(
    endpoint: String,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<StatusIaLocal> {
    let validado = validar_endpoint_local(&endpoint)?;
    *estado_ia.endpoint_local.lock().await = validado;
    Ok(estado_ia.obter_status().await)
}

#[tauri::command]
pub async fn iniciar_motor_ia_local(
    modelo_id: Option<String>,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<StatusIaLocal> {
    estado_ia.iniciar_servidor_local(modelo_id).await?;
    Ok(estado_ia.obter_status().await)
}

#[tauri::command]
pub async fn parar_motor_ia_local(
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<StatusIaLocal> {
    estado_ia.parar_servidor_local().await?;
    Ok(estado_ia.obter_status().await)
}

#[tauri::command]
pub async fn consultar_assistente_ia(
    mensagem: String,
    db: State<'_, SqlitePool>,
    estado_ia: State<'_, EstadoIaLocal>,
) -> Resultado<RespostaAssistenteIa> {
    let ep = estado_ia.endpoint_local.lock().await.clone();
    processar_mensagem_assistente_db(&db, &mensagem, Some(&ep)).await
}

#[tauri::command]
pub async fn executar_proposta_ia(
    proposta: PropostaAcaoIa,
    db: State<'_, SqlitePool>,
) -> Resultado<ResultadoExecucaoIa> {
    executar_proposta_confirmada(&db, proposta).await
}

// ============================================================================
// SUÍTE DE TESTES AUTOMATIZADOS (GARANTIA DE SEGURANÇA E CONFIABILIDADE)
// ============================================================================

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    /// O acervo nao pode sair da maquina por um campo de texto.
    ///
    /// Cada pergunta ao assistente carrega nomes e datas da familia. Se o
    /// endpoint pudesse apontar para fora, o produto deixaria de cumprir a
    /// promessa que esta no site e na secao 1 da especificacao -- e deixaria
    /// de cumpri-la em silencio, que e o pior jeito.
    #[test]
    fn endpoint_da_ia_so_aceita_a_propria_maquina() {
        for aceito in [
            "http://127.0.0.1:8080",
            "http://localhost:11434",
            "http://LOCALHOST:8080/v1",
            "http://127.1.2.3:8080",
            "http://[::1]:8080",
            "127.0.0.1:8080",
        ] {
            assert!(
                validar_endpoint_local(aceito).is_ok(),
                "deveria aceitar endereco local: {}",
                aceito
            );
        }

        for recusado in [
            "http://servidor-qualquer.com:8080",
            "https://api.openai.com/v1",
            "http://192.168.0.10:8080",
            "http://10.0.0.5:8080",
            "http://127.0.0.1.evil.com:8080",
            "",
            "   ",
        ] {
            assert!(
                validar_endpoint_local(recusado).is_err(),
                "deveria recusar endereco nao-local: {:?}",
                recusado
            );
        }
    }

    async fn banco_em_memoria() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations")
            .run(&pool)
            .await
            .expect("migrations");
        pool
    }

    #[test]
    fn jaro_winkler_reconhece_variacoes_de_grafia_e_rejeita_nomes_distintos() {
        let score_alto = algoritmos_ml::jaro_winkler("Joaquim Maria Machado", "Joaquim M. Machado");
        assert!(score_alto > 0.88, "score esperado > 0.88, obteve {}", score_alto);

        let score_acento = algoritmos_ml::jaro_winkler("D. João VI de Bragança", "D. Joao VI de Braganca");
        assert!((score_acento - 1.0).abs() < 1e-6);

        let score_baixo = algoritmos_ml::jaro_winkler("Machado de Assis", "Getúlio Vargas");
        assert!(score_baixo < 0.55, "score esperado < 0.55, obteve {}", score_baixo);
    }

    #[tokio::test]
    async fn portao_de_abstencao_bloqueia_perguntas_fora_do_banco_e_do_chat() {
        let pool = banco_em_memoria().await;

        // Insere apenas D. Pedro II no banco
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder)
             VALUES ('p_pedro2', 'D. Pedro II', 'de Bragança', 'M', 'Segundo Imperador do Brasil.', 0, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        // Pergunta sobre alguém que NÃO existe no banco nem no chat ("Gengis Khan")
        let resp = processar_mensagem_assistente_db(
            &pool,
            "Quem foram os filhos de Gengis Khan na Mongólia?",
            None,
        )
        .await
        .expect("resposta do assistente");

        assert!(resp.abstencao, "Deveria acionar o Portão de Abstenção para entidade inexistente");
        assert!(resp.citacoes.is_empty());
        assert!(resp.resposta_markdown.contains("Não encontrei informações"));
    }

    #[tokio::test]
    async fn responde_com_precisao_e_citacoes_sobre_pessoas_do_acervo() {
        let pool = banco_em_memoria().await;

        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder)
             VALUES
             ('p_pedro2', 'D. Pedro II', 'de Bragança', 'M', 'Imperador do Brasil entre 1840 e 1889.', 0, 0),
             ('p_teresa', 'Teresa Cristina', 'das Duas Sicílias', 'F', 'Imperatriz consorte.', 0, 0),
             ('p_isabel', 'Princesa Isabel', 'de Bragança', 'F', 'Assinou a Lei Áurea em 1888.', 0, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES
             ('e1', 'p_pedro2', 'nascimento', 1825, 1825, 'exata', '1825'),
             ('e2', 'p_pedro2', 'falecimento', 1891, 1891, 'exata', '1891'),
             ('e3', 'p_isabel', 'nascimento', 1846, 1846, 'exata', '1846')",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES ('u_imperial', 'p_pedro2', 'p_teresa', 'casamento')",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES ('u_imperial', 'p_isabel', 'biologico', 1)",
        )
        .execute(&pool)
        .await
        .unwrap();

        let resp = processar_mensagem_assistente_db(
            &pool,
            "Quem foram os filhos e a esposa de D. Pedro II?",
            None,
        )
        .await
        .expect("resposta do assistente");

        assert!(!resp.abstencao);
        assert!(resp.resposta_markdown.contains("D. Pedro II"));
        assert!(resp.resposta_markdown.contains("Teresa Cristina"));
        assert!(resp.resposta_markdown.contains("Princesa Isabel de Bragança (1846)"));
        assert!(!resp.citacoes.is_empty());

    }

    #[tokio::test]
    async fn extrai_proposta_de_arvore_a_partir_de_texto_do_usuario() {
        let pool = banco_em_memoria().await;

        let texto = "Crie uma árvore genealógica: Giuseppe Rossi (1882-1954) casou-se em 1905 com Teresa Bianchi (1885-1960). Tiveram os filhos Luigi Rossi (1906) e Anna Rossi (1908).";
        let resp = processar_mensagem_assistente_db(&pool, texto, None)
            .await
            .expect("resposta com proposta");

        assert!(!resp.abstencao);
        let proposta = match resp.proposta_acao.expect("deve conter proposta_acao") {
            PropostaAcaoIa::CriarArvore(a) => a,
            _ => panic!("esperava PropostaAcaoIa::CriarArvore"),
        };

        assert!(proposta.ancoragem_verificada);
        assert_eq!(proposta.pessoas.len(), 4);
        assert_eq!(proposta.pessoas[0].nome, "Giuseppe");
        assert_eq!(proposta.pessoas[0].ano_nascimento, Some(1882));
        assert_eq!(proposta.pessoas[0].ano_falecimento, Some(1954));
        assert_eq!(proposta.unioes.len(), 1);
        assert_eq!(proposta.unioes[0].ano_casamento, Some(1905));
        assert_eq!(proposta.unioes[0].filhos_refs.len(), 2);
    }

    #[test]
    fn quote_and_verify_remove_pessoas_e_anos_alucinados_nao_presentes_no_texto() {
        let texto_original = "Crie uma árvore: João Silva (1910-1980) casou com Maria Souza (1915).";

        let mut proposta_contaminada = PropostaCriarArvore {
            nome_arvore: "Família Silva".to_string(),
            descricao: None,
            categoria: Some("Pessoal".to_string()),
            raiz_ref: "@p1".to_string(),
            pessoas: vec![
                ItemPessoaProposta {
                    ref_id: "@p1".to_string(),
                    nome: "João".to_string(),
                    sobrenome: Some("Silva".to_string()),
                    sexo: "M".to_string(),
                    ano_nascimento: Some(1910),
                    ano_falecimento: Some(1980),
                    minibiografia: None,
                    trecho_evidencia: "João Silva (1910-1980)".to_string(),
                    pessoa_existente_id: None,
                },
                ItemPessoaProposta {
                    ref_id: "@p2".to_string(),
                    nome: "Maria".to_string(),
                    sobrenome: Some("Souza".to_string()),
                    sexo: "F".to_string(),
                    ano_nascimento: Some(1915),
                    // Ano 1999 NÃO existe no texto_original -> deve ser anulado!
                    ano_falecimento: Some(1999),
                    minibiografia: None,
                    trecho_evidencia: "Maria Souza (1915)".to_string(),
                    pessoa_existente_id: None,
                },
                ItemPessoaProposta {
                    ref_id: "@p_alucinado".to_string(),
                    // Nome " Napoleão " NÃO existe no texto_original -> deve ser expurgado!
                    nome: "Napoleão".to_string(),
                    sobrenome: Some("Bonaparte".to_string()),
                    sexo: "M".to_string(),
                    ano_nascimento: Some(1769),
                    ano_falecimento: None,
                    minibiografia: None,
                    trecho_evidencia: "Alucinação".to_string(),
                    pessoa_existente_id: None,
                },
            ],
            unioes: vec![ItemUniaoProposta {
                pai_ref: Some("@p1".to_string()),
                mae_ref: Some("@p2".to_string()),
                ano_casamento: Some(1935), // 1935 NÃO está no texto -> deve ser anulado!
                filhos_refs: vec!["@p_alucinado".to_string()],
            }],
            ancoragem_verificada: false,
            alertas_auditoria: Vec::new(),
        };

        algoritmos_ml::auditar_ancoragem_arvore(&mut proposta_contaminada, texto_original);

        assert_eq!(proposta_contaminada.pessoas.len(), 2, "A pessoa alucinada Napoleão deve ser removida");
        let maria = proposta_contaminada.pessoas.iter().find(|p| p.nome == "Maria").unwrap();
        assert_eq!(maria.ano_nascimento, Some(1915));
        assert_eq!(maria.ano_falecimento, None, "O ano 1999 alucinado deve ser anulado");
        assert_eq!(proposta_contaminada.unioes[0].ano_casamento, None, "O ano de casamento 1935 alucinado deve ser anulado");
        assert!(proposta_contaminada.unioes[0].filhos_refs.is_empty());
        assert!(!proposta_contaminada.alertas_auditoria.is_empty());
    }

    #[tokio::test]
    async fn record_linkage_identifica_pessoa_ja_existente_no_banco_sem_duplicar() {
        let pool = banco_em_memoria().await;

        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES ('id_giuseppe_existente', 'Giuseppe', 'Rossi', 'M', 0, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES ('ev_g1', 'id_giuseppe_existente', 'nascimento', 1882, 1882, 'exata', '1882')",
        )
        .execute(&pool)
        .await
        .unwrap();

        let texto = "Crie uma árvore: Giuseppe Rossi (1882-1954) casou-se com Teresa Bianchi (1885).";
        let resp = processar_mensagem_assistente_db(&pool, texto, None)
            .await
            .unwrap();

        let proposta = match resp.proposta_acao.unwrap() {
            PropostaAcaoIa::CriarArvore(a) => a,
            _ => panic!("esperava árvore"),
        };

        let giuseppe = proposta.pessoas.iter().find(|p| p.nome == "Giuseppe").unwrap();
        assert_eq!(
            giuseppe.pessoa_existente_id.as_deref(),
            Some("id_giuseppe_existente"),
            "O Record Linkage deve vincular Giuseppe Rossi ao ID existente no banco"
        );
    }

    #[tokio::test]
    async fn executor_transacional_cria_arvore_completa_e_integra_no_sqlite() {
        let pool = banco_em_memoria().await;

        let texto = "Crie uma árvore: Martinho Prado (1811-1891) casou-se em 1838 com Veridiana Silva (1825-1910). Tiveram os filhos Antonio Prado (1840) e Caio Prado (1843).";
        let resp = processar_mensagem_assistente_db(&pool, texto, None)
            .await
            .unwrap();

        let proposta = resp.proposta_acao.expect("proposta gerada");
        let resultado = executar_proposta_confirmada(&pool, proposta)
            .await
            .expect("execução transacional da árvore");

        assert_eq!(resultado.tipo, "arvore");
        assert!(resultado.raiz_pessoa_id.is_some());

        let grafo = crate::commands::tree_cmds::buscar_grafo_arvore_db(
            &pool,
            &resultado.raiz_pessoa_id.unwrap(),
            Some(4),
            Some(4),
        )
        .await
        .expect("grafo da árvore criada");


        assert_eq!(grafo.nodes.len(), 4, "Todos os 4 membros da família devem estar conectados no grafo");
        assert_eq!(grafo.unions.len(), 1, "Deve haver 1 união conectando pais e filhos");
    }

    #[tokio::test]
    async fn executor_transacional_cria_linha_do_tempo_completa_no_sqlite() {
        let pool = banco_em_memoria().await;

        let texto = "Crie uma linha do tempo:\n- Em 1808 chegada da corte portuguesa ao Rio de Janeiro.\n- Em 1822 proclamação da Independência do Brasil.\n- Em 1889 proclamação da República.";
        let resp = processar_mensagem_assistente_db(&pool, texto, None)
            .await
            .unwrap();

        let proposta = resp.proposta_acao.expect("proposta de linha do tempo");
        let resultado = executar_proposta_confirmada(&pool, proposta)
            .await
            .expect("execução transacional da linha do tempo");

        assert_eq!(resultado.tipo, "linha_tempo");
        assert_eq!(resultado.itens_criados, 3);

        let qtd_marcos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM eventos_linha WHERE linha_id = ?")
            .bind(&resultado.entidade_id)
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(qtd_marcos, 3);
    }
}
