// Esconde o console do Windows na build de release.
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod commands;
mod domain;

use std::fs;

use sqlx::sqlite::{SqliteConnectOptions, SqlitePoolOptions};
use sqlx::SqlitePool;
use tauri::Manager;

use commands::tree_cmds::{buscar_grafo_arvore, buscar_pessoas};
use domain::atributos_cmds::*;
use domain::core_cmds::*;
use domain::eventos_cmds::{
    atualizar_evento, criar_evento, listar_eventos_pessoa, remover_evento,
};

/// Nome do arquivo de acervo dentro da pasta de dados do app.
const ARQUIVO_ACERVO: &str = "acervo.sqlite";

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            // ---------------------------------------------------------
            // Onde mora o acervo.
            //
            // Antes era "sqlite:../acervo.sqlite", relativo ao diretório de
            // trabalho do processo — o que funciona rodando `tauri dev` da
            // raiz do projeto e falha, ou grava em lugar imprevisível, num
            // programa instalado.
            //
            // `app_data_dir()` é o caminho por-usuário do sistema:
            //   Windows  %APPDATA%\com.arvore.genealogica\
            //   macOS    ~/Library/Application Support/com.arvore.genealogica/
            //   Linux    ~/.local/share/com.arvore.genealogica/
            //
            // Local-first (seção 1): o arquivo é do usuário, fica na máquina
            // dele, e é isso que ele leva embora num backup.
            // ---------------------------------------------------------
            let pasta_dados = app
                .path()
                .app_data_dir()
                .expect("não foi possível determinar a pasta de dados do usuário");

            fs::create_dir_all(&pasta_dados)?;
            let caminho_banco = pasta_dados.join(ARQUIVO_ACERVO);

            let pool = tauri::async_runtime::block_on(abrir_acervo(&caminho_banco))?;
            app.manage(pool);

            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            // Árvore e busca
            buscar_grafo_arvore,
            buscar_pessoas,
            // Núcleo genealógico
            criar_pessoa,
            obter_pessoa,
            obter_conexoes_pessoa,
            atualizar_pessoa,
            remover_pessoa,
            promover_placeholder,
            criar_uniao,
            atualizar_uniao,
            remover_uniao,
            anexar_filho,
            desvincular_filho,
            // Eventos de vida
            criar_evento,
            atualizar_evento,
            remover_evento,
            listar_eventos_pessoa,
            // Atributos de vida em lista
            adicionar_religiao,
            remover_religiao,
            listar_religioes,
            adicionar_profissao,
            remover_profissao,
            listar_profissoes,
            adicionar_idioma,
            remover_idioma,
            listar_idiomas,
            adicionar_escolaridade,
            remover_escolaridade,
            listar_escolaridade,
            adicionar_nacionalidade,
            remover_nacionalidade,
            listar_nacionalidades,
            adicionar_apelido,
            remover_apelido,
            listar_apelidos,
            listar_paises,
        ])
        .run(tauri::generate_context!())
        .expect("erro ao iniciar a aplicação");
}

/// Abre (ou cria) o acervo e aplica as migrations pendentes.
async fn abrir_acervo(caminho: &std::path::Path) -> Result<SqlitePool, Box<dyn std::error::Error>> {
    let opcoes = SqliteConnectOptions::new()
        .filename(caminho)
        .create_if_missing(true)
        // WAL: leituras não bloqueiam a escrita. Numa árvore grande, é a
        // diferença entre a interface travar ou não durante um salvamento.
        .journal_mode(sqlx::sqlite::SqliteJournalMode::Wal)
        .synchronous(sqlx::sqlite::SqliteSynchronous::Normal)
        // Explícito de propósito: o sqlx já liga por padrão, mas as cascatas
        // e os RESTRICT das migrations dependem disto e a dependência não
        // deveria ficar implícita.
        .foreign_keys(true);

    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect_with(opcoes)
        .await?;

    sqlx::migrate!("./migrations").run(&pool).await?;

    Ok(pool)
}
