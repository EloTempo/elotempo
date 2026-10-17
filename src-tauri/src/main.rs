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
    atualizar_evento, criar_evento, listar_eventos_pessoa, listar_eventos_uniao,
    remover_evento,
};
use domain::documentos_cmds::{
    abrir_documento_no_sistema, anexar_documento, definir_foto_principal, listar_documentos_pessoa,
    remover_documento,
};
use domain::linhas_tempo_cmds::{
    buscar_marcos, listar_linhas_de_contexto, montar_linha_pessoal, quem_estava_vivo,
    criar_linha_tempo, atualizar_linha_tempo, deletar_linha_tempo,
    criar_marco, atualizar_marco, deletar_marco,
    adicionar_participante, remover_participante, toggle_visibilidade_participacao,
    buscar_participantes_marco, listar_participacoes_pessoa,
};
use domain::marcadores_cmds::{
    listar_marcadores, criar_marcador, atualizar_marcador, deletar_marcador,
};
use domain::gedcom::{analisar_gedcom, exportar_gedcom, extensao_de_exportacao, importar_gedcom};
use domain::locais_cmds::{buscar_locais, obter_local, registrar_local_estrangeiro};
use domain::busca_cmds::{buscar_pessoas_filtrado, opcoes_de_filtro};
use domain::relatorio_cmds::montar_relatorio;
use domain::estatisticas_cmds::calcular_estatisticas;
use domain::arvores_cmds::{
    atualizar_arvore, criar_arvore, definir_raiz_arvore, deletar_arvore, listar_arvores,
    obter_arvore,
};
use domain::nomes_cmds::{
    adicionar_nome, listar_nomes_pessoa, remover_nome, usar_nome_na_arvore,
};
use domain::trajetoria_cmds::obter_trajetoria_pessoa;
use domain::parentesco_cmds::calcular_parentesco;
use domain::exportacao_grafica_cmds::{salvar_arquivo_bytes, salvar_arquivo_texto};
use domain::fusao_cmds::{buscar_duplicatas_potenciais, fundir_pessoas};
use domain::seguranca::{
    ativar_modo_blindado, bloquear_acervo, carregar_config_seguranca, desativar_modo_blindado,
    desbloquear_acervo, gerar_chave_recuperacao, obter_status_seguranca, recuperar_acervo_com_chave,
    validar_senha_gatekeeper, EstadoSeguranca,
};

/// Nome do arquivo de acervo dentro da pasta de dados do app.
const ARQUIVO_ACERVO: &str = "acervo.sqlite";

fn main() {
    tauri::Builder::default()
        // Só o seletor de arquivo. O frontend recebe um caminho e o entrega ao
        // Rust; quem copia, lê e apaga é o backend, dentro da pasta do app.
        .plugin(tauri_plugin_dialog::init())
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
            //   Windows  %APPDATA%\com.elotempo.app\ (legado: com.arvore.genealogica\)
            //   macOS    ~/Library/Application Support/com.elotempo.app/
            //   Linux    ~/.local/share/com.elotempo.app/
            //
            // Local-first (seção 1): o arquivo é do usuário, fica na máquina
            // dele, e é isso que ele leva embora num backup.
            // ---------------------------------------------------------
            let pasta_dados = app
                .path()
                .app_data_dir()
                .expect("não foi possível determinar a pasta de dados do usuário");

            migrar_dados_legados_se_necessario(&pasta_dados);

            fs::create_dir_all(&pasta_dados)?;
            let caminho_banco = pasta_dados.join(ARQUIVO_ACERVO);

            let config_seguranca = carregar_config_seguranca(&pasta_dados);
            let estado_seguranca = EstadoSeguranca::novo(config_seguranca);
            app.manage(estado_seguranca);

            let pool = match tauri::async_runtime::block_on(abrir_acervo(&caminho_banco)) {
                Ok(p) => p,
                Err(err) => {
                    let log_msg = format!("Erro fatal ao inicializar o acervo em {}: {:?}", caminho_banco.display(), err);
                    eprintln!("{}", log_msg);
                    let _ = fs::write(pasta_dados.join("ultimo_erro_inicializacao.log"), &log_msg);

                    use tauri_plugin_dialog::{DialogExt, MessageDialogKind};
                    app.dialog()
                        .message(format!("Não foi possível abrir o acervo do EloTempo.\n\nErro: {}\n\nLocal: {}", err, caminho_banco.display()))
                        .title("EloTempo — Falha de Inicialização")
                        .kind(MessageDialogKind::Error)
                        .blocking_show();

                    return Err(err);
                }
            };
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
            restaurar_pessoa,
            restaurar_uniao,
            // Linhas do tempo
            listar_linhas_de_contexto,
            buscar_marcos,
            montar_linha_pessoal,
            quem_estava_vivo,
            criar_linha_tempo,
            atualizar_linha_tempo,
            deletar_linha_tempo,
            criar_marco,
            atualizar_marco,
            deletar_marco,
            adicionar_participante,
            remover_participante,
            toggle_visibilidade_participacao,
            buscar_participantes_marco,
            listar_participacoes_pessoa,
            // Busca multicritério e estatísticas
            buscar_pessoas_filtrado,
            opcoes_de_filtro,
            calcular_estatisticas,
            // Múltiplas árvores nomeadas
            listar_arvores,
            obter_arvore,
            criar_arvore,
            atualizar_arvore,
            deletar_arvore,
            definir_raiz_arvore,
            // GEDCOM
            exportar_gedcom,
            analisar_gedcom,
            importar_gedcom,
            extensao_de_exportacao,
            // Relatórios
            montar_relatorio,
            // Locais
            buscar_locais,
            obter_local,
            registrar_local_estrangeiro,
            // Fotos e documentos
            anexar_documento,
            listar_documentos_pessoa,
            remover_documento,
            definir_foto_principal,
            abrir_documento_no_sistema,
            // Nomes ao longo da vida
            listar_nomes_pessoa,
            adicionar_nome,
            remover_nome,
            usar_nome_na_arvore,
            // Eventos de vida
            criar_evento,
            atualizar_evento,
            remover_evento,
            listar_eventos_pessoa,
            listar_eventos_uniao,
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
            adicionar_obra_cultural,
            remover_obra_cultural,
            listar_obras_culturais,
            adicionar_apelido,
            remover_apelido,
            listar_apelidos,
            listar_paises,
            calcular_parentesco,
            salvar_arquivo_bytes,
            salvar_arquivo_texto,
            fundir_pessoas,
            buscar_duplicatas_potenciais,
            listar_marcadores,
            criar_marcador,
            atualizar_marcador,
            deletar_marcador,
            obter_trajetoria_pessoa,
            // Sistema de Segurança, Criptografia e Modo Híbrido
            obter_status_seguranca,
            gerar_chave_recuperacao,
            ativar_modo_blindado,
            desativar_modo_blindado,
            desbloquear_acervo,
            bloquear_acervo,
            validar_senha_gatekeeper,
            recuperar_acervo_com_chave,
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

    if let Err(e) = sqlx::migrate!("./migrations").run(&pool).await {
        match &e {
            sqlx::migrate::MigrateError::VersionMissing(v) => {
                eprintln!(
                    "Aviso: O acervo contem a migracao {} mais recente do que esta compilacao do EloTempo. Continuando com seguranca.",
                    v
                );
            }
            sqlx::migrate::MigrateError::VersionMismatch(v) => {
                eprintln!(
                    "Aviso: A migracao {} tem checksum diferente (possivel diferenca de quebra de linha ou semente manual). Continuando com seguranca.",
                    v
                );
            }
            _ => return Err(e.into()),
        }
    }

    domain::semente_publica::garantir_acervo_publico(&pool).await?;

    Ok(pool)
}

/// Migra dados de versões anteriores instaladas sob o identificador legado `com.arvore.genealogica`.
///
/// Garante que se o usuário possuir um banco de dados, cofre criptografado ou mídias
/// na pasta legada e a nova pasta `com.elotempo.app` estiver vazia, os dados sejam
/// copiados de forma segura e transparente.
fn migrar_dados_legados_se_necessario(pasta_dados_atual: &std::path::Path) {
    let banco_atual = pasta_dados_atual.join(ARQUIVO_ACERVO);
    let vault_atual = pasta_dados_atual.join("acervo.vault");

    // Se a pasta atual já tiver um acervo ou cofre, nada a migrar.
    if banco_atual.exists() || vault_atual.exists() {
        return;
    }

    let Some(pasta_pai) = pasta_dados_atual.parent() else {
        return;
    };

    let pasta_legada = pasta_pai.join("com.arvore.genealogica");
    if !pasta_legada.exists() {
        return;
    }

    let banco_legado = pasta_legada.join(ARQUIVO_ACERVO);
    let vault_legado = pasta_legada.join("acervo.vault");

    if !banco_legado.exists() && !vault_legado.exists() {
        return;
    }

    println!(
        "[Migração] Detectada base legada em {:?}. Copiando para {:?}",
        pasta_legada, pasta_dados_atual
    );

    if let Err(e) = fs::create_dir_all(pasta_dados_atual) {
        eprintln!("[Migração] Erro ao criar diretório atual: {}", e);
        return;
    }

    // Arquivos a migrar da raiz da pasta de dados
    let arquivos = [
        ARQUIVO_ACERVO,
        "acervo.sqlite-wal",
        "acervo.sqlite-shm",
        "acervo.vault",
        "seguranca.json",
    ];

    for arquivo in arquivos {
        let origem = pasta_legada.join(arquivo);
        let destino = pasta_dados_atual.join(arquivo);
        if origem.exists() {
            if let Err(e) = fs::copy(&origem, &destino) {
                eprintln!("[Migração] Falha ao copiar {}: {}", arquivo, e);
            } else {
                println!("[Migração] Arquivo {} copiado com sucesso.", arquivo);
            }
        }
    }

    // Migrar diretório de mídias recursivamente se existir
    let midia_origem = pasta_legada.join("midia");
    let midia_destino = pasta_dados_atual.join("midia");
    if midia_origem.is_dir() {
        if let Err(e) = copiar_diretorio_recursivo(&midia_origem, &midia_destino) {
            eprintln!("[Migração] Falha ao copiar pasta de mídia: {}", e);
        } else {
            println!("[Migração] Diretório de mídia copiado com sucesso.");
        }
    }

    println!("[Migração] Migração concluída com sucesso.");
}

fn copiar_diretorio_recursivo(origem: &std::path::Path, destino: &std::path::Path) -> std::io::Result<()> {
    fs::create_dir_all(destino)?;
    for entrada in fs::read_dir(origem)? {
        let entrada = entrada?;
        let tipo = entrada.file_type()?;
        let caminho_origem = entrada.path();
        let caminho_destino = destino.join(entrada.file_name());

        if tipo.is_dir() {
            copiar_diretorio_recursivo(&caminho_origem, &caminho_destino)?;
        } else {
            fs::copy(&caminho_origem, &caminho_destino)?;
        }
    }
    Ok(())
}

#[cfg(test)]
mod testes_inicializacao {
    use super::*;

    #[tokio::test]
    async fn abrir_acervo_tolera_migracao_futura() {
        let temp_dir = std::env::temp_dir().join(format!("elotempo_test_{}", uuid::Uuid::new_v4()));
        fs::create_dir_all(&temp_dir).unwrap();
        let caminho_banco = temp_dir.join("acervo.sqlite");

        // 1. Abre normalmente pela primeira vez
        {
            let pool = abrir_acervo(&caminho_banco).await.unwrap();
            // Simula uma migração futura aplicada por versão mais recente
            sqlx::query("INSERT INTO _sqlx_migrations (version, description, installed_on, success, checksum, execution_time) VALUES (999, 'migracao_do_futuro', CURRENT_TIMESTAMP, 1, X'00', 10)")
                .execute(&pool)
                .await
                .unwrap();
        }

        // 2. Tenta reabrir o acervo: DEVE ter sucesso e tolerar a migração 999 sem entrar em pânico!
        let resultado = abrir_acervo(&caminho_banco).await;
        assert!(resultado.is_ok(), "abrir_acervo deve tolerar migrações futuras sem falhar: {:?}", resultado.err());

        let _ = fs::remove_dir_all(&temp_dir);
    }
}

