//! Fotos e documentos anexados a uma pessoa (fatia 03).
//!
//! O arquivo escolhido pelo usuário é **copiado** para
//! `<pasta de dados>/midia/`, com nome gerado. O original nunca é tocado nem
//! referenciado: o usuário pode apagar, mover ou renomear o que está em
//! Downloads sem quebrar o acervo.
//!
//! No banco guarda-se só o **caminho relativo**. Caminho absoluto quebraria ao
//! copiar a pasta para outra máquina — e portabilidade é princípio da seção 1.

use std::path::{Path, PathBuf};

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::{Manager, State};
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};

/// Subpasta da mídia dentro da pasta de dados do app.
/// Espelha o escopo do `assetProtocol` em tauri.conf.json — se um mudar, o
/// outro tem de mudar junto, senão as imagens param de carregar.
pub const PASTA_MIDIA: &str = "midia";

/// Extensões aceitas, agrupadas pelo que a interface faz com cada uma.
const EXTENSOES_IMAGEM: [&str; 6] = ["jpg", "jpeg", "png", "webp", "gif", "bmp"];
const EXTENSOES_DOCUMENTO: [&str; 5] = ["pdf", "txt", "md", "rtf", "odt"];

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Documento {
    pub id: String,
    pub caminho_relativo: String,
    /// "imagem" ou "documento" — o que decide se a ficha mostra miniatura.
    pub tipo_midia: String,
    pub tamanho_bytes: Option<i64>,
    pub data_documento: Option<String>,
    pub titulo: Option<String>,
    pub descricao: Option<String>,
    pub nome_original: Option<String>,
}

/// Classifica pela extensão. Sem extensão conhecida, entra como documento —
/// melhor guardar e mostrar como anexo genérico do que recusar o arquivo.
fn classificar(extensao: &str) -> &'static str {
    let e = extensao.to_lowercase();
    if EXTENSOES_IMAGEM.contains(&e.as_str()) {
        "imagem"
    } else if EXTENSOES_DOCUMENTO.contains(&e.as_str()) {
        "documento"
    } else {
        "documento"
    }
}

fn pasta_de_midia(app: &tauri::AppHandle) -> Resultado<PathBuf> {
    let base = app
        .path()
        .app_data_dir()
        .map_err(|e| ErroDominio::Persistencia(format!("pasta de dados indisponível: {e}")))?;
    let pasta = base.join(PASTA_MIDIA);
    std::fs::create_dir_all(&pasta)
        .map_err(|e| ErroDominio::Persistencia(format!("não foi possível criar {PASTA_MIDIA}: {e}")))?;
    Ok(pasta)
}

#[derive(Debug, Deserialize)]
pub struct NovoDocumento {
    pub pessoa_id: String,
    /// Caminho absoluto do arquivo de origem, vindo do seletor.
    pub caminho_origem: String,
    pub titulo: Option<String>,
    pub data_documento: Option<String>,
    pub descricao: Option<String>,
}

/// Copia o arquivo para a pasta de mídia e registra o vínculo com a pessoa.
#[tauri::command]
pub async fn anexar_documento(
    novo: NovoDocumento,
    app: tauri::AppHandle,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    let origem = Path::new(&novo.caminho_origem);

    if !origem.is_file() {
        return Err(ErroDominio::ValorInvalido {
            campo: "caminho_origem".into(),
            valor: "o arquivo não existe ou não é um arquivo".into(),
        });
    }

    let existe: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE id = ?")
        .bind(&novo.pessoa_id)
        .fetch_one(&*db)
        .await?;
    if existe == 0 {
        return Err(ErroDominio::PessoaNaoEncontrada(novo.pessoa_id));
    }

    let extensao = origem
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
        .to_lowercase();
    let tipo_midia = classificar(&extensao);

    let nome_original = origem
        .file_name()
        .and_then(|n| n.to_str())
        .map(|s| s.to_string());

    let id = Uuid::new_v4().to_string();
    let nome_destino = if extensao.is_empty() {
        id.clone()
    } else {
        format!("{id}.{extensao}")
    };

    let pasta = pasta_de_midia(&app)?;
    let destino = pasta.join(&nome_destino);

    std::fs::copy(origem, &destino)
        .map_err(|e| ErroDominio::Persistencia(format!("falha ao copiar o arquivo: {e}")))?;

    let tamanho = std::fs::metadata(&destino).ok().map(|m| m.len() as i64);

    // Caminho relativo à pasta de dados, com barra normal: é o que sobrevive a
    // uma cópia do acervo entre máquinas e entre sistemas.
    let caminho_relativo = format!("{PASTA_MIDIA}/{nome_destino}");

    let gravacao = async {
        sqlx::query(
            "INSERT INTO documentos
               (id, caminho_relativo, tipo_midia, tamanho_bytes, data_documento,
                titulo, descricao, nome_original)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        )
        .bind(&id)
        .bind(&caminho_relativo)
        .bind(tipo_midia)
        .bind(tamanho)
        .bind(novo.data_documento.as_deref().map(str::trim).filter(|s| !s.is_empty()))
        .bind(novo.titulo.as_deref().map(str::trim).filter(|s| !s.is_empty()))
        .bind(novo.descricao.as_deref().map(str::trim).filter(|s| !s.is_empty()))
        .bind(&nome_original)
        .execute(&*db)
        .await?;

        sqlx::query(
            "INSERT INTO documento_vinculos (id, documento_id, pessoa_id) VALUES (?, ?, ?)",
        )
        .bind(Uuid::new_v4().to_string())
        .bind(&id)
        .bind(&novo.pessoa_id)
        .execute(&*db)
        .await?;

        Ok::<(), ErroDominio>(())
    }
    .await;

    // Se o banco recusou, o arquivo copiado não pode ficar para trás.
    if let Err(erro) = gravacao {
        let _ = std::fs::remove_file(&destino);
        return Err(erro);
    }

    Ok(id)
}

#[tauri::command]
pub async fn listar_documentos_pessoa(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Documento>> {
    Ok(sqlx::query_as::<_, Documento>(
        "SELECT d.id, d.caminho_relativo, d.tipo_midia, d.tamanho_bytes, d.data_documento,
                d.titulo, d.descricao, d.nome_original
         FROM documentos d
         JOIN documento_vinculos v ON v.documento_id = d.id
         WHERE v.pessoa_id = ?
         ORDER BY d.data_criacao",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

/// Remove o registro **e o arquivo**.
///
/// Deixar o arquivo para trás encheria a pasta de mídia de lixo invisível, do
/// mesmo jeito que os placeholders enchiam o acervo antes da fatia de exclusão.
#[tauri::command]
pub async fn remover_documento(
    id: String,
    app: tauri::AppHandle,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let caminho: Option<String> =
        sqlx::query_scalar("SELECT caminho_relativo FROM documentos WHERE id = ?")
            .bind(&id)
            .fetch_optional(&*db)
            .await?;

    let caminho = caminho.ok_or_else(|| ErroDominio::ValorInvalido {
        campo: "documentos.id".into(),
        valor: id.clone(),
    })?;

    // Se este arquivo era a foto principal de alguém, o retrato tem de sair
    // junto — senão o card apontaria para um arquivo que não existe mais.
    sqlx::query("UPDATE pessoas SET foto_url = NULL WHERE foto_url = ?")
        .bind(&caminho)
        .execute(&*db)
        .await?;

    sqlx::query("DELETE FROM documentos WHERE id = ?")
        .bind(&id)
        .execute(&*db)
        .await?;

    apagar_arquivo(&app, &caminho);
    Ok(())
}

/// Apaga um arquivo da pasta de dados. Silencioso: se já não existe, tudo bem.
fn apagar_arquivo(app: &tauri::AppHandle, caminho_relativo: &str) {
    if let Ok(base) = app.path().app_data_dir() {
        let alvo = base.join(caminho_relativo);
        // Confere que o caminho não escapou da pasta de dados antes de apagar.
        if alvo.starts_with(&base) {
            let _ = std::fs::remove_file(alvo);
        }
    }
}

/// Marca uma imagem como o retrato que aparece no card e no topo da ficha.
#[tauri::command]
pub async fn definir_foto_principal(
    pessoa_id: String,
    documento_id: Option<String>,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let caminho: Option<String> = match &documento_id {
        Some(doc) => {
            let linha = sqlx::query("SELECT caminho_relativo, tipo_midia FROM documentos WHERE id = ?")
                .bind(doc)
                .fetch_optional(&*db)
                .await?
                .ok_or_else(|| ErroDominio::ValorInvalido {
                    campo: "documentos.id".into(),
                    valor: doc.clone(),
                })?;

            let tipo: String = linha.try_get("tipo_midia")?;
            if tipo != "imagem" {
                return Err(ErroDominio::ValorInvalido {
                    campo: "documento".into(),
                    valor: "só uma imagem pode ser o retrato da pessoa".into(),
                });
            }
            Some(linha.try_get("caminho_relativo")?)
        }
        // `None` limpa o retrato.
        None => None,
    };

    sqlx::query("UPDATE pessoas SET foto_url = ? WHERE id = ?")
        .bind(&caminho)
        .bind(&pessoa_id)
        .execute(&*db)
        .await?;

    Ok(())
}

/// Apaga os arquivos de mídia de uma pessoa que está sendo removida.
///
/// As linhas caem por `ON DELETE CASCADE`; os arquivos não têm quem os leve, e
/// é por isso que esta função é chamada **antes** da exclusão.
pub async fn apagar_midia_da_pessoa(
    app: &tauri::AppHandle,
    pool: &SqlitePool,
    pessoa_id: &str,
) -> Resultado<()> {
    let caminhos: Vec<String> = sqlx::query_scalar(
        "SELECT d.caminho_relativo FROM documentos d
         JOIN documento_vinculos v ON v.documento_id = d.id
         WHERE v.pessoa_id = ?",
    )
    .bind(pessoa_id)
    .fetch_all(pool)
    .await?;

    for caminho in caminhos {
        apagar_arquivo(app, &caminho);
    }
    Ok(())
}

/// Abre um arquivo no aplicativo padrão do sistema operacional (leitor de PDF, visualizador de fotos, etc.)
#[tauri::command]
pub async fn abrir_documento_no_sistema(
    caminho_relativo: String,
    app: tauri::AppHandle,
) -> Resultado<()> {
    if let Ok(base) = app.path().app_data_dir() {
        let alvo = base.join(&caminho_relativo);
        if alvo.is_file() {
            #[cfg(target_os = "windows")]
            {
                let _ = std::process::Command::new("cmd")
                    .args(["/C", "start", "", &alvo.to_string_lossy()])
                    .spawn();
            }
            #[cfg(target_os = "macos")]
            {
                let _ = std::process::Command::new("open")
                    .arg(&alvo)
                    .spawn();
            }
            #[cfg(target_os = "linux")]
            {
                let _ = std::process::Command::new("xdg-open")
                    .arg(&alvo)
                    .spawn();
            }
        }
    }
    Ok(())
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn imagens_sao_reconhecidas_pela_extensao() {
        for e in ["jpg", "JPG", "jpeg", "png", "webp", "gif"] {
            assert_eq!(classificar(e), "imagem", "falhou em {e}");
        }
    }

    #[test]
    fn pdf_e_texto_entram_como_documento() {
        for e in ["pdf", "PDF", "txt", "md"] {
            assert_eq!(classificar(e), "documento", "falhou em {e}");
        }
    }

    #[test]
    fn extensao_desconhecida_vira_documento_em_vez_de_erro() {
        // Guardar e mostrar como anexo genérico é melhor do que recusar o
        // arquivo que a pessoa quis anexar.
        assert_eq!(classificar("xyz"), "documento");
        assert_eq!(classificar(""), "documento");
    }
}
