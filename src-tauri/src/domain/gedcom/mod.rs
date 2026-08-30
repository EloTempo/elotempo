//! GEDCOM — o formato de transporte (seção 4).
//!
//! "O SQLite é o formato de trabalho; o GEDCOM é o de transporte/backup."
//! Este módulo cobre a exportação (fatia 08). A importação está planejada em
//! `Instruções/fatias/09-gedcom-importacao.md`.

pub mod escritor;
pub mod exportador;

use std::io::Write;
use std::path::Path;

use serde::Serialize;
use sqlx::SqlitePool;
use tauri::{Manager, State};

use crate::domain::documentos_cmds::PASTA_MIDIA;
use crate::domain::erros::{ErroDominio, Resultado};
pub use exportador::OpcoesExportacao;

#[derive(Debug, Serialize)]
pub struct ResumoExportacao {
    pub caminho: String,
    pub pessoas: usize,
    pub unioes: usize,
    pub arquivos_de_midia: usize,
    pub vivas_ocultadas: usize,
    /// `true` quando saiu como GEDZip em vez de `.ged` solto.
    pub empacotado: bool,
}

/// Exporta o acervo para GEDCOM 7.0.
///
/// Com mídia, sai um GEDZip: o zip com o `.ged` e a pasta de mídia, como a
/// seção 4 determina. É o que faz as fotos viajarem junto — um `.ged` com
/// referências a arquivos que ficaram para trás seria pior do que nenhum.
#[tauri::command]
pub async fn exportar_gedcom(
    caminho: String,
    opcoes: OpcoesExportacao,
    app: tauri::AppHandle,
    db: State<'_, SqlitePool>,
) -> Resultado<ResumoExportacao> {
    let exportacao = exportador::montar(&db, &opcoes).await?;

    let destino = Path::new(&caminho);
    let empacotar = opcoes.incluir_midia && !exportacao.midia.is_empty();

    if empacotar {
        empacotar_gedzip(&app, destino, &exportacao)?;
    } else {
        std::fs::write(destino, exportacao.texto.as_bytes())
            .map_err(|e| ErroDominio::Persistencia(format!("falha ao gravar o arquivo: {e}")))?;
    }

    Ok(ResumoExportacao {
        caminho,
        pessoas: exportacao.pessoas,
        unioes: exportacao.unioes,
        arquivos_de_midia: if empacotar { exportacao.midia.len() } else { 0 },
        vivas_ocultadas: exportacao.vivas_ocultadas,
        empacotado: empacotar,
    })
}

/// Monta o zip com o `.ged` e os arquivos de mídia referenciados.
fn empacotar_gedzip(
    app: &tauri::AppHandle,
    destino: &Path,
    exportacao: &exportador::Exportacao,
) -> Resultado<()> {
    let base = app
        .path()
        .app_data_dir()
        .map_err(|e| ErroDominio::Persistencia(format!("pasta de dados indisponível: {e}")))?;

    let arquivo = std::fs::File::create(destino)
        .map_err(|e| ErroDominio::Persistencia(format!("falha ao criar o pacote: {e}")))?;
    let mut zip = zip::ZipWriter::new(arquivo);
    let opcoes_zip: zip::write::FileOptions<'_, ()> =
        zip::write::FileOptions::default().compression_method(zip::CompressionMethod::Deflated);

    let erro = |e: zip::result::ZipError| ErroDominio::Persistencia(format!("falha no pacote: {e}"));

    // O nome do .ged dentro do pacote acompanha o nome do arquivo escolhido.
    let nome_ged = destino
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("acervo");

    zip.start_file(format!("{nome_ged}.ged"), opcoes_zip)
        .map_err(erro)?;
    zip.write_all(exportacao.texto.as_bytes())
        .map_err(|e| ErroDominio::Persistencia(format!("falha ao escrever no pacote: {e}")))?;

    for relativo in &exportacao.midia {
        let origem = base.join(relativo);

        // Confere que o caminho não escapou da pasta de dados antes de ler —
        // mesmo cuidado que a exclusão de documentos toma.
        if !origem.starts_with(&base) || !origem.is_file() {
            continue;
        }

        let bytes = match std::fs::read(&origem) {
            Ok(b) => b,
            // Um arquivo que sumiu do disco não impede o resto de sair. O
            // .ged continua referenciando; quem receber vê a referência
            // quebrada, o que é mais honesto do que exportação nenhuma.
            Err(_) => continue,
        };

        zip.start_file(relativo.replace('\\', "/"), opcoes_zip)
            .map_err(erro)?;
        zip.write_all(&bytes)
            .map_err(|e| ErroDominio::Persistencia(format!("falha ao empacotar mídia: {e}")))?;
    }

    zip.finish().map_err(erro)?;
    Ok(())
}

/// Extensão sugerida conforme haja mídia a levar junto.
#[tauri::command]
pub async fn extensao_de_exportacao(
    incluir_midia: bool,
    db: State<'_, SqlitePool>,
) -> Resultado<String> {
    if !incluir_midia {
        return Ok("ged".into());
    }
    let tem: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM documentos")
        .fetch_one(&*db)
        .await?;
    Ok(if tem > 0 { "gdz".into() } else { "ged".into() })
}

/// Deixa `PASTA_MIDIA` visível para quem lê este módulo — os caminhos dentro
/// do pacote são relativos a ela.
#[allow(dead_code)]
const _PASTA: &str = PASTA_MIDIA;

#[cfg(test)]
mod testes {
    use super::exportador::{montar, OpcoesExportacao};
    use crate::domain::regras::{self, NovaPessoa};
    use sqlx::sqlite::SqlitePoolOptions;
    use sqlx::SqlitePool;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    async fn pessoa(pool: &SqlitePool, nome: &str, sobrenome: &str, sexo: &str, vivo: bool) -> String {
        regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: Some(sobrenome.into()),
                sexo: sexo.into(),
                minibiografia: None,
                is_vivo: vivo,
                foto_url: None,
            },
        )
        .await
        .unwrap()
    }

    async fn evento(
        pool: &SqlitePool,
        pessoa_id: &str,
        tipo: &str,
        texto: &str,
        qual: &str,
        dia: Option<i64>,
        mes: Option<i64>,
        ano_de: Option<i64>,
        ano_ate: Option<i64>,
    ) {
        sqlx::query(
            "INSERT INTO eventos
               (id,pessoa_id,tipo_evento,data_texto,data_qualificador,
                dia_inicio,mes_inicio,ano_inicio,ano_fim)
             VALUES (?,?,?,?,?,?,?,?,?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(pessoa_id)
        .bind(tipo)
        .bind(texto)
        .bind(qual)
        .bind(dia)
        .bind(mes)
        .bind(ano_de)
        .bind(ano_ate)
        .execute(pool)
        .await
        .unwrap();
    }

    fn opcoes() -> OpcoesExportacao {
        OpcoesExportacao::default()
    }

    #[tokio::test]
    async fn acervo_vazio_gera_arquivo_valido() {
        let pool = pool_de_teste().await;
        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.starts_with("0 HEAD"));
        assert!(r.texto.contains("2 VERS 7.0"));
        assert!(r.texto.ends_with("0 TRLR\n"));
        assert_eq!(r.pessoas, 0);
    }

    #[tokio::test]
    async fn uma_pessoa_volta_completa() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Joaquim", "Ferreira", "M", false).await;
        evento(&pool, &p, "nascimento", "12 de março de 1945", "exata",
               Some(12), Some(3), Some(1945), Some(1945)).await;

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("0 @I1@ INDI"));
        assert!(r.texto.contains("1 NAME Joaquim /Ferreira/"));
        assert!(r.texto.contains("1 SEX M"));
        assert!(r.texto.contains("1 BIRT"));
        assert!(r.texto.contains("2 DATE 12 MAR 1945"), "{}", r.texto);
    }

    /// O critério que motivou a migration 015.
    #[tokio::test]
    async fn a_data_sai_com_dia_e_mes_e_nao_so_o_ano() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Ana", "Silva", "F", false).await;
        evento(&pool, &p, "nascimento", "12 de março de 1945", "exata",
               Some(12), Some(3), Some(1945), Some(1945)).await;

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("2 DATE 12 MAR 1945"));
        assert!(!r.texto.contains("2 DATE 1945"), "perdeu dia e mês");
    }

    #[tokio::test]
    async fn texto_que_o_date_nao_alcanca_vai_para_nota() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisavô", "Lima", "M", false).await;
        evento(&pool, &p, "nascimento", "na época da guerra", "desconhecida",
               None, None, None, None).await;

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(!r.texto.contains("2 DATE"), "não há data a afirmar");
        assert!(
            r.texto.contains("na época da guerra"),
            "o que o usuário escreveu não pode sumir: {}",
            r.texto
        );
    }

    #[tokio::test]
    async fn data_aproximada_volta_ao_ano_dito() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Tataravó", "Souza", "F", false).await;
        // "cerca de 1890" é guardado como 1885–1895.
        evento(&pool, &p, "nascimento", "cerca de 1890", "cerca_de",
               None, None, Some(1885), Some(1895)).await;

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("2 DATE ABT 1890"), "{}", r.texto);
        // E como o DATE reproduz o que foi dito, não precisa de nota.
        assert!(!r.texto.contains("Data como registrada"));
    }

    #[tokio::test]
    async fn placeholder_nao_vira_indi_e_o_husb_e_omitido() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Maria", "Santos", "F", false).await;
        regras::criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert_eq!(r.pessoas, 1, "só a mãe é pessoa de verdade");
        assert!(r.texto.contains("0 @F1@ FAM"));
        assert!(r.texto.contains("1 WIFE @I1@"));
        assert!(!r.texto.contains("1 HUSB"), "o placeholder não tem INDI a apontar");
        assert!(!r.texto.contains("Desconhecido"));
    }

    #[tokio::test]
    async fn familia_completa_sai_com_husb_wife_e_chil() {
        let pool = pool_de_teste().await;
        let pai = pessoa(&pool, "Pai", "Costa", "M", false).await;
        let mae = pessoa(&pool, "Mãe", "Lima", "F", false).await;
        let filho = pessoa(&pool, "Filho", "Costa", "M", false).await;
        let u = regras::criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u, &filho, "biologico").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("1 HUSB @I1@"));
        assert!(r.texto.contains("1 WIFE @I2@"));
        assert!(r.texto.contains("1 CHIL @I3@"));
        assert!(r.texto.contains("1 FAMC @F1@"), "o filho aponta de volta");
        assert!(r.texto.contains("1 FAMS @F1@"), "os pais apontam para a união");
    }

    #[tokio::test]
    async fn vinculo_nao_biologico_sai_com_pedi() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "Adotiva", "F", false).await;
        let filho = pessoa(&pool, "Filho", "Adotado", "M", false).await;
        let u = regras::criar_uniao(&pool, None, Some(&mae), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u, &filho, "adotado").await.unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("2 PEDI ADOPTED"), "{}", r.texto);
    }

    #[tokio::test]
    async fn ocultar_vivas_tira_os_dados_e_mantem_o_parentesco() {
        let pool = pool_de_teste().await;
        let pai = pessoa(&pool, "Pai", "Falecido", "M", false).await;
        let mae = pessoa(&pool, "Mãe", "Viva", "F", true).await;
        let filho = pessoa(&pool, "Filho", "Vivo", "M", true).await;

        evento(&pool, &mae, "nascimento", "1960", "exata", None, None, Some(1960), Some(1960)).await;

        let u = regras::criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        regras::anexar_filho(&pool, &u, &filho, "biologico").await.unwrap();

        let r = montar(
            &pool,
            &OpcoesExportacao { ocultar_vivas: true, ..Default::default() },
        )
        .await
        .unwrap();

        assert_eq!(r.vivas_ocultadas, 2);
        assert!(!r.texto.contains("1960"), "nenhuma data de pessoa viva pode sair");
        assert!(!r.texto.contains("Mãe /Viva/"), "nem o nome");
        assert!(r.texto.contains("1 NAME Viva"), "mas ela continua no arquivo");
        // E a árvore não se parte: o filho continua ligado à união.
        assert!(r.texto.contains("1 CHIL"));
        assert!(r.texto.contains("1 FAMC @F1@"));
    }

    #[tokio::test]
    async fn atributos_saem_nas_tags_da_spec() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisavó", "Ferreira", "F", false).await;

        for (sql, valor) in [
            ("INSERT INTO religioes_pessoa (id,pessoa_id,denominacao) VALUES (?,?,?)", "Católica"),
            ("INSERT INTO profissoes_pessoa (id,pessoa_id,ocupacao) VALUES (?,?,?)", "Costureira"),
            ("INSERT INTO idiomas_pessoa (id,pessoa_id,idioma) VALUES (?,?,?)", "Italiano"),
            ("INSERT INTO apelidos_pessoa (id,pessoa_id,apelido) VALUES (?,?,?)", "Dona Chica"),
        ] {
            sqlx::query(sql)
                .bind(uuid::Uuid::new_v4().to_string())
                .bind(&p)
                .bind(valor)
                .execute(&pool)
                .await
                .unwrap();
        }

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("1 RELI Católica"));
        assert!(r.texto.contains("1 OCCU Costureira"));
        assert!(r.texto.contains("1 _LANG Italiano"), "idioma não tem tag padrão");
        assert!(r.texto.contains("1 NICK Dona Chica"));
    }

    #[tokio::test]
    async fn o_escopo_por_raiz_recorta() {
        let pool = pool_de_teste().await;
        let a = pessoa(&pool, "A", "Familia1", "M", false).await;
        let b = pessoa(&pool, "B", "Familia1", "F", false).await;
        regras::criar_uniao(&pool, Some(&a), Some(&b), "casamento").await.unwrap();
        pessoa(&pool, "Z", "Familia2", "M", false).await;

        let r = montar(
            &pool,
            &OpcoesExportacao { raiz_id: Some(a), ..Default::default() },
        )
        .await
        .unwrap();

        assert_eq!(r.pessoas, 2);
        assert!(!r.texto.contains("Familia2"));
    }

    #[tokio::test]
    async fn nota_com_duas_linhas_vira_cont() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Avô", "Nota", "M", false).await;
        sqlx::query("UPDATE pessoas SET minibiografia = ? WHERE id = ?")
            .bind("Primeira linha.\nSegunda linha.")
            .bind(&p)
            .execute(&pool)
            .await
            .unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("1 NOTE Primeira linha."));
        assert!(r.texto.contains("2 CONT Segunda linha."));
    }

    #[tokio::test]
    async fn a_midia_e_listada_para_o_pacote() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Com", "Foto", "M", false).await;
        sqlx::query(
            "INSERT INTO documentos (id,caminho_relativo,tipo_midia,titulo)
             VALUES ('d1','midia/d1.jpg','imagem','Retrato')",
        )
        .execute(&pool)
        .await
        .unwrap();
        sqlx::query("INSERT INTO documento_vinculos (id,documento_id,pessoa_id) VALUES ('v1','d1',?)")
            .bind(&p)
            .execute(&pool)
            .await
            .unwrap();

        let r = montar(&pool, &opcoes()).await.unwrap();
        assert!(r.texto.contains("1 OBJE"));
        assert!(r.texto.contains("2 FILE midia/d1.jpg"));
        assert!(r.texto.contains("3 TITL Retrato"));
        assert_eq!(r.midia, vec!["midia/d1.jpg".to_string()]);
    }

    #[tokio::test]
    async fn cada_registro_tem_xref_unica() {
        let pool = pool_de_teste().await;
        for i in 0..5 {
            pessoa(&pool, &format!("P{i}"), "X", "U", false).await;
        }
        let r = montar(&pool, &opcoes()).await.unwrap();

        let xrefs: Vec<&str> = r
            .texto
            .lines()
            .filter(|l| l.starts_with("0 @"))
            .collect();
        let unicas: std::collections::HashSet<_> = xrefs.iter().collect();
        assert_eq!(xrefs.len(), unicas.len(), "xref repetida: {xrefs:?}");
    }
}
