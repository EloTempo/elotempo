//! Gerenciador de Modelos GGUF Sob Demanda e Cliente HTTP Local (`127.0.0.1`).
//!
//! Mantém o instalador principal do EloTempo leve (~5 MB) e permite que o usuário:
//! 1. Baixe sob demanda modelos quantizados `.gguf` (`Qwen 2.5 1.5B` ou `Qwen 2.5 3B`)
//!    diretamente para a pasta `<app_data_dir>/ia_local/models/`.
//! 2. Importe um arquivo `.gguf` já existente no computador.
//! 3. Inicie/pare o servidor local (`llama-server`) ou conecte-se a uma instância
//!    local compatível com a API OpenAI (`127.0.0.1:8080` ou `127.0.0.1:11434`).

use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Child, Command, Stdio};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Arc;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpStream;
use tokio::sync::Mutex;
use tokio::time::{timeout, Duration};

use crate::domain::erros::{ErroDominio, Resultado};
use super::{InfoModeloCatalogo, StatusIaLocal};

/// Catálogo oficial de modelos GGUF recomendados para o EloTempo.
///
/// A URL aponta para uma **revisao fixa**, nao para `main`: `main` e uma
/// referencia movel, e o arquivo pode mudar na origem sem que o programa
/// perceba. Com a revisao presa, o `sha256_esperado` continua valendo.
///
/// Para atualizar um modelo, troque a revisao E o hash juntos -- um sem o
/// outro faz todo download falhar na verificacao.
pub fn catalogo_modelos_padrao() -> Vec<InfoModeloCatalogo> {
    vec![
        InfoModeloCatalogo {
            id: "qwen2.5-1.5b-q4_k_m".to_string(),
            nome: "Qwen 2.5 1.5B Instruct (Q4_K_M) — Ultraleve".to_string(),
            arquivo: "qwen2.5-1.5b-instruct-q4_k_m.gguf".to_string(),
            url_download: "https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/91cad51170dc346986eccefdc2dd33a9da36ead9/qwen2.5-1.5b-instruct-q4_k_m.gguf".to_string(),
            sha256_esperado: "6a1a2eb6d15622bf3c96857206351ba97e1af16c30d7a74ee38970e434e9407e".to_string(),
            tamanho_bytes_estimado: 1_117_320_736,
            ram_recomendada_gb: 2,
            descricao: "Ideal para qualquer computador (inclusive sem placa de vídeo). Excelente velocidade para consultas no acervo e extração de árvores.".to_string(),
            instalado: false,
            tamanho_em_disco: 0,
        },
        InfoModeloCatalogo {
            id: "qwen2.5-3b-q4_k_m".to_string(),
            nome: "Qwen 2.5 3B Instruct (Q4_K_M) — Equilibrado".to_string(),
            arquivo: "qwen2.5-3b-instruct-q4_k_m.gguf".to_string(),
            url_download: "https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF/resolve/7dabda4d13d513e3e842b20f0d435c732f172cbe/qwen2.5-3b-instruct-q4_k_m.gguf".to_string(),
            sha256_esperado: "626b4a6678b86442240e33df819e00132d3ba7dddfe1cdc4fbb18e0a9615c62d".to_string(),
            tamanho_bytes_estimado: 2_104_932_768,
            ram_recomendada_gb: 4,
            descricao: "Maior capacidade de estruturação para textos biográficos longos e árvores multigeracionais complexas.".to_string(),
            instalado: false,
            tamanho_em_disco: 0,
        },
    ]
}

/// Estado compartilhado do gerenciador de IA Local.
pub struct EstadoIaLocal {
    pub pasta_ia: PathBuf,
    pub endpoint_local: Mutex<String>,
    pub modelo_ativo_id: Mutex<Option<String>>,
    pub processo_servidor: Mutex<Option<Child>>,
    pub download_em_andamento: Arc<AtomicBool>,
    pub download_cancelado: Arc<AtomicBool>,
    pub download_modelo_id: Mutex<Option<String>>,
    pub download_bytes_atuais: Arc<AtomicU64>,
    pub download_bytes_totais: Arc<AtomicU64>,
    pub ultimo_erro_download: Arc<Mutex<Option<String>>>,
}

impl EstadoIaLocal {
    pub fn novo(pasta_dados_app: &Path) -> Self {
        let pasta_ia = pasta_dados_app.join("ia_local");
        let _ = fs::create_dir_all(pasta_ia.join("models"));
        let _ = fs::create_dir_all(pasta_ia.join("engine"));

        Self {
            pasta_ia,
            endpoint_local: Mutex::new("http://127.0.0.1:8080".to_string()),
            modelo_ativo_id: Mutex::new(None),
            processo_servidor: Mutex::new(None),
            download_em_andamento: Arc::new(AtomicBool::new(false)),
            download_cancelado: Arc::new(AtomicBool::new(false)),
            download_modelo_id: Mutex::new(None),
            download_bytes_atuais: Arc::new(AtomicU64::new(0)),
            download_bytes_totais: Arc::new(AtomicU64::new(0)),
            ultimo_erro_download: Arc::new(Mutex::new(None)),
        }
    }

    pub fn pasta_modelos(&self) -> PathBuf {
        self.pasta_ia.join("models")
    }

    pub fn pasta_motor(&self) -> PathBuf {
        self.pasta_ia.join("engine")
    }

    /// Retorna o status completo do módulo de IA Local.
    pub async fn obter_status(&self) -> StatusIaLocal {
        let mut modelos = catalogo_modelos_padrao();
        let pasta_m = self.pasta_modelos();

        for m in &mut modelos {
            let p = pasta_m.join(&m.arquivo);
            if let Ok(meta) = fs::metadata(&p) {
                if meta.is_file() && meta.len() > 10_000_000 {
                    m.instalado = true;
                    m.tamanho_em_disco = meta.len();
                }
            }
        }

        // Verifica também modelos GGUF personalizados importados pelo usuário
        if let Ok(entries) = fs::read_dir(&pasta_m) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.extension().and_then(|e| e.to_str()) == Some("gguf") {
                    let nome_arq = path
                        .file_name()
                        .and_then(|n| n.to_str())
                        .unwrap_or("")
                        .to_string();
                    if !modelos.iter().any(|m| m.arquivo == nome_arq) {
                        let tam = entry.metadata().map(|m| m.len()).unwrap_or(0);
                        if tam > 1_024 {
                            modelos.push(InfoModeloCatalogo {
                                id: format!("custom_{}", nome_arq),
                                nome: format!("Modelo Importado ({})", nome_arq),
                                arquivo: nome_arq,
                                url_download: String::new(),
                                // Arquivo que o proprio usuario trouxe: nao ha
                                // hash de catalogo para comparar, e nao ha
                                // download a conferir.
                                sha256_esperado: String::new(),
                                tamanho_bytes_estimado: tam,
                                ram_recomendada_gb: 4,
                                descricao: "Modelo GGUF importado localmente pelo usuário.".to_string(),
                                instalado: true,
                                tamanho_em_disco: tam,
                            });
                        }
                    }
                }
            }
        }

        let endpoint = self.endpoint_local.lock().await.clone();
        let servidor_respondendo = verificar_endpoint_ativo(&endpoint).await;

        let mut ativo = self.modelo_ativo_id.lock().await.clone();
        if ativo.is_none() {
            if let Some(primeiro_inst) = modelos.iter().find(|m| m.instalado) {
                ativo = Some(primeiro_inst.id.clone());
            }
        }

        let bin_motor = caminho_binario_llama_server(&self.pasta_motor());
        let motor_instalado = bin_motor.exists() || servidor_respondendo;

        let dl_andamento = self.download_em_andamento.load(Ordering::SeqCst);
        let dl_atuais = self.download_bytes_atuais.load(Ordering::SeqCst);
        let dl_totais = self.download_bytes_totais.load(Ordering::SeqCst);
        let dl_id = self.download_modelo_id.lock().await.clone();
        let erro_dl = self.ultimo_erro_download.lock().await.clone();

        StatusIaLocal {
            motor_instalado,
            servidor_online: servidor_respondendo,
            endpoint_local: endpoint,
            modelo_ativo_id: ativo,
            modelos_catalogo: modelos,
            download_em_andamento: dl_andamento,
            download_modelo_id: dl_id,
            download_bytes_atuais: dl_atuais,
            download_bytes_totais: dl_totais,
            ultimo_erro_download: erro_dl,
            pasta_modelos: pasta_m.to_string_lossy().to_string(),
        }
    }

    /// Importa um arquivo `.gguf` do computador do usuário para a pasta de modelos do EloTempo.
    pub async fn importar_gguf(&self, caminho_origem: &Path) -> Resultado<String> {
        if !caminho_origem.exists() {
            return Err(ErroDominio::Validacao(
                "O arquivo selecionado não existe.".to_string(),
            ));
        }
        let nome_arq = caminho_origem
            .file_name()
            .and_then(|n| n.to_str())
            .ok_or_else(|| ErroDominio::Validacao("Nome de arquivo inválido.".to_string()))?;

        if !nome_arq.to_lowercase().ends_with(".gguf") {
            return Err(ErroDominio::Validacao(
                "O arquivo deve possuir a extensão .gguf.".to_string(),
            ));
        }

        let destino = self.pasta_modelos().join(nome_arq);
        fs::copy(caminho_origem, &destino)
            .map_err(|e| ErroDominio::Validacao(format!("Erro ao copiar arquivo GGUF: {}", e)))?;
        let id = format!("custom_{}", nome_arq);
        *self.modelo_ativo_id.lock().await = Some(id.clone());
        Ok(id)
    }

    /// Remove um modelo `.gguf` baixado para liberar espaço em disco.
    pub async fn remover_modelo(&self, modelo_id: &str) -> Resultado<()> {
        let status = self.obter_status().await;
        if let Some(info) = status.modelos_catalogo.iter().find(|m| m.id == modelo_id) {
            let p = self.pasta_modelos().join(&info.arquivo);
            if p.exists() {
                fs::remove_file(p)
                    .map_err(|e| ErroDominio::Validacao(format!("Erro ao remover modelo: {}", e)))?;
            }
        }
        Ok(())
    }


    /// Inicia o download assíncrono sob demanda de um modelo do catálogo usando `curl` nativo do sistema.
    pub async fn iniciar_download(&self, modelo_id: &str) -> Resultado<()> {
        if self.download_em_andamento.load(Ordering::SeqCst) {
            return Err(ErroDominio::Validacao(
                "Já existe um download de modelo em andamento.".to_string(),
            ));
        }

        let catalogo = catalogo_modelos_padrao();
        let info = catalogo
            .into_iter()
            .find(|m| m.id == modelo_id)
            .ok_or_else(|| ErroDominio::Validacao(format!("Modelo desconhecido: {}", modelo_id)))?;

        let destino_parcial = self.pasta_modelos().join(format!("{}.part", info.arquivo));
        let destino_final = self.pasta_modelos().join(&info.arquivo);

        self.download_em_andamento.store(true, Ordering::SeqCst);
        self.download_cancelado.store(false, Ordering::SeqCst);
        self.download_bytes_atuais.store(0, Ordering::SeqCst);
        self.download_bytes_totais
            .store(info.tamanho_bytes_estimado, Ordering::SeqCst);
        *self.download_modelo_id.lock().await = Some(info.id.clone());
        *self.ultimo_erro_download.lock().await = None;

        let flag_andamento = Arc::clone(&self.download_em_andamento);
        let flag_cancelado = Arc::clone(&self.download_cancelado);
        let bytes_atuais = Arc::clone(&self.download_bytes_atuais);
        let erro_download = Arc::clone(&self.ultimo_erro_download);

        tokio::spawn(async move {
            let mut cmd = Command::new("curl");
            cmd.arg("-L")
                .arg("--fail")
                .arg("--silent")
                .arg("--show-error")
                .arg("-o")
                .arg(&destino_parcial)
                .arg(&info.url_download)
                .stdout(Stdio::null())
                .stderr(Stdio::piped());

            #[cfg(target_os = "windows")]
            {
                use std::os::windows::process::CommandExt;
                const CREATE_NO_WINDOW: u32 = 0x08000000;
                cmd.creation_flags(CREATE_NO_WINDOW);
            }

            // Toda saida por aqui registra o motivo em `ultimo_erro_download`.
            // Antes o processo morria calado: a barra parava em zero e a tela
            // nao tinha o que dizer, mesmo com o stderr do curl capturado e
            // jogado fora.
            let registrar = |msg: String| {
                let slot = Arc::clone(&erro_download);
                async move {
                    *slot.lock().await = Some(msg);
                }
            };

            match cmd.spawn() {
                Ok(mut child) => {
                    let mut saida = None;
                    loop {
                        if flag_cancelado.load(Ordering::SeqCst) {
                            let _ = child.kill();
                            let _ = fs::remove_file(&destino_parcial);
                            break;
                        }
                        if let Ok(meta) = fs::metadata(&destino_parcial) {
                            bytes_atuais.store(meta.len(), Ordering::SeqCst);
                        }
                        match child.try_wait() {
                            Ok(Some(status)) => {
                                saida = Some(status);
                                break;
                            }
                            Ok(None) => {
                                tokio::time::sleep(Duration::from_millis(400)).await;
                            }
                            Err(e) => {
                                registrar(format!("Falha ao acompanhar o download: {}", e)).await;
                                let _ = fs::remove_file(&destino_parcial);
                                break;
                            }
                        }
                    }

                    if let Some(status) = saida {
                        if status.success() {
                            match conferir_sha256(&destino_parcial, &info.sha256_esperado) {
                                Ok(()) => {
                                    if let Err(e) = fs::rename(&destino_parcial, &destino_final) {
                                        registrar(format!(
                                            "O modelo baixou e foi conferido, mas nao deu para grava-lo em disco: {}",
                                            e
                                        ))
                                        .await;
                                        let _ = fs::remove_file(&destino_parcial);
                                    }
                                }
                                Err(motivo) => {
                                    // Arquivo que nao bate com o hash nao fica
                                    // no disco: ele seria carregado por um
                                    // servidor de inferencia na proxima vez.
                                    let _ = fs::remove_file(&destino_parcial);
                                    registrar(motivo).await;
                                }
                            }
                        } else {
                            let detalhe = child
                                .stderr
                                .take()
                                .and_then(|mut e| {
                                    use std::io::Read;
                                    let mut buf = String::new();
                                    e.read_to_string(&mut buf).ok().map(|_| buf)
                                })
                                .unwrap_or_default();
                            let detalhe = detalhe.trim();
                            let _ = fs::remove_file(&destino_parcial);
                            registrar(if detalhe.is_empty() {
                                "O download falhou. Verifique a sua conexao e tente de novo.".to_string()
                            } else {
                                format!("O download falhou: {}", detalhe)
                            })
                            .await;
                        }
                    }
                }
                Err(e) => {
                    let _ = fs::remove_file(&destino_parcial);
                    // O curl acompanha o Windows 10+, mas nao e garantido no
                    // Linux: o .deb nao o declara como dependencia. Dizer o
                    // que falta e o que separa "nao funciona" de "instale o
                    // curl".
                    registrar(format!(
                        "Nao foi possivel iniciar o download porque o programa 'curl' nao esta                          disponivel nesta maquina ({}). No Ubuntu ou Debian, instale com:                          sudo apt install curl. Voce tambem pode baixar o arquivo .gguf por                          fora e usar o botao de importar.",
                        e
                    ))
                    .await;
                }
            }

            flag_andamento.store(false, Ordering::SeqCst);
        });

        Ok(())
    }

    pub fn cancelar_download(&self) {
        self.download_cancelado.store(true, Ordering::SeqCst);
    }

    /// Inicia o processo local `llama-server` se o binário e um modelo `.gguf` estiverem disponíveis.
    pub async fn iniciar_servidor_local(&self, modelo_id: Option<String>) -> Resultado<()> {
        let status = self.obter_status().await;
        if status.servidor_online {
            return Ok(());
        }

        let id_escolhido = modelo_id
            .or(status.modelo_ativo_id)
            .ok_or_else(|| ErroDominio::Validacao("Nenhum modelo GGUF instalado para iniciar.".to_string()))?;

        let info = status
            .modelos_catalogo
            .iter()
            .find(|m| m.id == id_escolhido && m.instalado)
            .ok_or_else(|| ErroDominio::Validacao("O modelo selecionado ainda não está instalado.".to_string()))?;

        let caminho_gguf = self.pasta_modelos().join(&info.arquivo);
        let bin = caminho_binario_llama_server(&self.pasta_motor());
        if !bin.exists() {
            return Err(ErroDominio::Validacao(
                "Binário llama-server não encontrado na pasta engine. Você pode usar um servidor local compatível (llama-server ou Ollama) em 127.0.0.1:8080.".to_string(),
            ));
        }

        let mut cmd = Command::new(&bin);
        cmd.arg("-m")
            .arg(&caminho_gguf)
            .arg("--host")
            .arg("127.0.0.1")
            .arg("--port")
            .arg("8080")
            .arg("-c")
            .arg("4096")
            .stdout(Stdio::null())
            .stderr(Stdio::null());

        #[cfg(target_os = "windows")]
        {
            use std::os::windows::process::CommandExt;
            const CREATE_NO_WINDOW: u32 = 0x08000000;
            cmd.creation_flags(CREATE_NO_WINDOW);
        }

        let child = cmd.spawn().map_err(|e| {
            ErroDominio::Validacao(format!("Falha ao iniciar llama-server: {}", e))
        })?;

        *self.processo_servidor.lock().await = Some(child);
        *self.modelo_ativo_id.lock().await = Some(id_escolhido);
        Ok(())
    }

    /// Encerra o processo filho `llama-server` para liberar memória RAM imediatamente.
    pub async fn parar_servidor_local(&self) -> Resultado<()> {
        let mut guard = self.processo_servidor.lock().await;
        if let Some(mut child) = guard.take() {
            let _ = child.kill();
            let _ = child.wait();
        }
        Ok(())
    }
}

fn caminho_binario_llama_server(pasta_motor: &Path) -> PathBuf {
    #[cfg(target_os = "windows")]
    {
        pasta_motor.join("llama-server.exe")
    }
    #[cfg(not(target_os = "windows"))]
    {
        pasta_motor.join("llama-server")
    }
}

fn extrair_host_porta(endpoint: &str) -> (String, u16) {
    let sem_proto = endpoint
        .trim()
        .trim_start_matches("http://")
        .trim_start_matches("https://");
    let host_port = sem_proto.split('/').next().unwrap_or("127.0.0.1:8080");
    if let Some((h, p)) = host_port.split_once(':') {
        let porta = p.parse::<u16>().unwrap_or(8080);
        (h.to_string(), porta)
    } else {
        (host_port.to_string(), 8080)
    }
}

/// Verifica rapidamente via TCP se há um motor de inferência local escutando na porta configurada.
pub async fn verificar_endpoint_ativo(endpoint: &str) -> bool {
    let (host, porta) = extrair_host_porta(endpoint);
    let addr = format!("{}:{}", host, porta);
    timeout(Duration::from_millis(250), TcpStream::connect(&addr))
        .await
        .map(|r| r.is_ok())
        .unwrap_or(false)
}

/// Envia uma requisição `/v1/chat/completions` para a LLM local via HTTP/1.1 sobre `TcpStream`
/// com temperatura `0.1` (alta determinicidade) e instruções de sistema restritas ao Cenário A.
pub async fn chamar_llm_local_chat(
    endpoint: &str,
    system_prompt: &str,
    user_prompt: &str,
    forcar_json: bool,
) -> Option<String> {
    let (host, porta) = extrair_host_porta(endpoint);
    let addr = format!("{}:{}", host, porta);

    let mut stream = timeout(Duration::from_millis(800), TcpStream::connect(&addr))
        .await
        .ok()?
        .ok()?;

    let mut payload = serde_json::json!({
        "messages": [
            { "role": "system", "content": system_prompt },
            { "role": "user", "content": user_prompt }
        ],
        "temperature": 0.1,
        "max_tokens": 900,
        "stream": false
    });

    if forcar_json {
        payload["response_format"] = serde_json::json!({ "type": "json_object" });
    }

    let body = serde_json::to_string(&payload).ok()?;
    let request = format!(
        "POST /v1/chat/completions HTTP/1.1\r\n\
         Host: {}:{}\r\n\
         Content-Type: application/json\r\n\
         Content-Length: {}\r\n\
         Connection: close\r\n\r\n\
         {}",
        host,
        porta,
        body.len(),
        body
    );

    timeout(Duration::from_secs(5), stream.write_all(request.as_bytes()))
        .await
        .ok()?
        .ok()?;

    let mut buffer = Vec::new();
    timeout(Duration::from_secs(25), stream.read_to_end(&mut buffer))
        .await
        .ok()?
        .ok()?;

    let resposta_bruta = String::from_utf8_lossy(&buffer);
    let (_, json_body) = resposta_bruta.split_once("\r\n\r\n")?;

    // Lida tanto com corpo direto quanto com Transfer-Encoding: chunked simples
    let inicio_json = json_body.find('{')?;
    let fim_json = json_body.rfind('}')?;
    let fatia_json = &json_body[inicio_json..=fim_json];

    let parsed: serde_json::Value = serde_json::from_str(fatia_json).ok()?;
    parsed["choices"]
        .get(0)?
        .get("message")?
        .get("content")?
        .as_str()
        .map(|s| s.trim().to_string())
}

/// Confere o SHA-256 do arquivo baixado contra o do catalogo.
///
/// Le em blocos porque o arquivo tem entre 1 e 2 GB -- carrega-lo inteiro na
/// memoria para calcular um hash derrubaria a maquina modesta que este modelo
/// existe justamente para atender.
fn conferir_sha256(caminho: &Path, esperado: &str) -> Result<(), String> {
    use sha2::{Digest, Sha256};
    use std::io::Read;

    let mut arquivo = fs::File::open(caminho)
        .map_err(|e| format!("O arquivo baixado nao pode ser lido para conferencia: {}", e))?;

    let mut hasher = Sha256::new();
    let mut bloco = vec![0u8; 1024 * 1024];
    loop {
        let lidos = arquivo
            .read(&mut bloco)
            .map_err(|e| format!("Erro ao ler o arquivo baixado: {}", e))?;
        if lidos == 0 {
            break;
        }
        hasher.update(&bloco[..lidos]);
    }

    let obtido = hasher
        .finalize()
        .iter()
        .map(|b| format!("{:02x}", b))
        .collect::<String>();

    if obtido.eq_ignore_ascii_case(esperado) {
        Ok(())
    } else {
        Err(format!(
            "O modelo baixado nao confere com o esperado e foi descartado.              Esperado {}, obtido {}. Tente baixar de novo.",
            &esperado[..12.min(esperado.len())],
            &obtido[..12]
        ))
    }
}
