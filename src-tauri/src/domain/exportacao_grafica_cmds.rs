//! Comandos para exportação gráfica da árvore genealógica (PNG, SVG, etc.).

use std::fs;
use std::path::Path;

use crate::domain::erros::{ErroDominio, Resultado};

use tauri::State;
use crate::domain::seguranca::EstadoSeguranca;

/// Grava uma sequência de bytes binários em disco no caminho especificado.
/// Usado para exportação de PNG gerado no Canvas do frontend.
#[tauri::command]
pub async fn salvar_arquivo_bytes(
    caminho: String,
    bytes: Vec<u8>,
    ticket_autorizacao: Option<String>,
    seguranca: State<'_, EstadoSeguranca>,
) -> Resultado<()> {
    crate::domain::seguranca::autorizar_acao_sensivel(&seguranca, None, ticket_autorizacao.as_deref()).await?;
    salvar_bytes(&caminho, bytes)
}

pub fn salvar_bytes(caminho: &str, bytes: Vec<u8>) -> Resultado<()> {
    let path = Path::new(caminho);
    if let Some(parent) = path.parent() {
        if !parent.as_os_str().is_empty() {
            fs::create_dir_all(parent).map_err(|e| {
                ErroDominio::Persistencia(format!(
                    "Falha ao criar diretório de destino {}: {}",
                    parent.display(),
                    e
                ))
            })?;
        }
    }

    fs::write(path, bytes).map_err(|e| {
        ErroDominio::Persistencia(format!(
            "Falha ao salvar arquivo em {}: {}",
            path.display(),
            e
        ))
    })?;

    Ok(())
}

/// Grava uma string de texto em disco no caminho especificado.
/// Usado para exportação direta de SVG vetorial puro.
#[tauri::command]
pub async fn salvar_arquivo_texto(
    caminho: String,
    conteudo: String,
    ticket_autorizacao: Option<String>,
    seguranca: State<'_, EstadoSeguranca>,
) -> Resultado<()> {
    crate::domain::seguranca::autorizar_acao_sensivel(&seguranca, None, ticket_autorizacao.as_deref()).await?;
    salvar_texto(&caminho, &conteudo)
}

pub fn salvar_texto(caminho: &str, conteudo: &str) -> Resultado<()> {
    let path = Path::new(caminho);
    if let Some(parent) = path.parent() {
        if !parent.as_os_str().is_empty() {
            fs::create_dir_all(parent).map_err(|e| {
                ErroDominio::Persistencia(format!(
                    "Falha ao criar diretório de destino {}: {}",
                    parent.display(),
                    e
                ))
            })?;
        }
    }

    fs::write(path, conteudo.as_bytes()).map_err(|e| {
        ErroDominio::Persistencia(format!(
            "Falha ao salvar arquivo de texto em {}: {}",
            path.display(),
            e
        ))
    })?;

    Ok(())
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn salva_arquivo_texto_com_sucesso() {
        let dir = std::env::temp_dir().join("teste_exportacao_grafica");
        let arq = dir.join("teste.svg");
        let conteudo = "<svg><rect width=\"100\" height=\"100\" /></svg>";

        let res = salvar_texto(&arq.to_string_lossy(), conteudo);
        assert!(res.is_ok());

        let lido = fs::read_to_string(&arq).unwrap();
        assert_eq!(lido, conteudo);

        let _ = fs::remove_file(&arq);
        let _ = fs::remove_dir(&dir);
    }

    #[test]
    fn salva_arquivo_bytes_com_sucesso() {
        let dir = std::env::temp_dir().join("teste_exportacao_grafica_bin");
        let arq = dir.join("teste.png");
        let bytes = vec![0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

        let res = salvar_bytes(&arq.to_string_lossy(), bytes.clone());
        assert!(res.is_ok());

        let lido = fs::read(&arq).unwrap();
        assert_eq!(lido, bytes);

        let _ = fs::remove_file(&arq);
        let _ = fs::remove_dir(&dir);
    }
}
