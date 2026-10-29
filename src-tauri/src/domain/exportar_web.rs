//! Exportação do acervo público para o portal web.
//!
//! POR QUE ISTO EXISTE EM RUST
//!
//! A exportação era feita por `scripts/exportar_acervo_web.py`, que abre o
//! acervo com o `sqlite3` da biblioteca padrão do Python. Desde a v1.2.0 o
//! acervo é cifrado com SQLCipher, e aquele `sqlite3` não abre banco cifrado:
//! o script parou de funcionar e ninguém percebeu, porque ele falha ao ler,
//! não ao escrever.
//!
//! Reconstruir o acervo fora do programa também não resolve. As migrations e
//! os seeds versionados produzem 92 árvores; as outras 5 — Família Imperial
//! do Brasil, Presidentes do Brasil, Casa Real de Davi e mais duas — são
//! inseridas por código em `semente_publica.rs`, não por SQL. Quem exporta
//! precisa ser quem tem o acervo montado.
//!
//! Aqui dentro as duas coisas já existem: a chave do acervo e o SQLCipher
//! compilado junto. O comando despeja exatamente o mesmo formato JSON que o
//! `acervo/app.js` do site já consome — mudar o formato quebraria o portal.
//!
//! O QUE ESTE COMANDO NÃO FAZ
//!
//! Não redimensiona retratos. O script Python usava Pillow para reduzir a
//! 600px e recomprimir em JPEG 85, e trazer um codec de imagem para dentro do
//! binário por causa disso engordaria o instalador de todo mundo para atender
//! uma tarefa que só o mantenedor do acervo roda. As fotos são copiadas como
//! estão, e o relatório diz quantos bytes foram copiados para a decisão de
//! otimizar ficar visível.

use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

use serde::Serialize;
use serde_json::{json, Value};
use sqlx::{Row, SqlitePool};

use crate::domain::erros::{ErroDominio, Resultado};

#[derive(Debug, Clone, Serialize)]
pub struct RelatorioExportacao {
    pub destino: String,
    pub arvores: usize,
    pub pessoas: usize,
    pub unioes: usize,
    pub linhas_tempo: usize,
    pub fotos_copiadas: usize,
    pub fotos_ausentes: usize,
    pub bytes_de_midia: u64,
    /// Avisos que não impedem a exportação mas o mantenedor precisa ver.
    pub avisos: Vec<String>,
}

/// Nome do arquivo dentro de `midia/`, a partir do caminho guardado no banco.
///
/// O banco guarda caminho relativo (`midia/uuid.jpg`), mas já houve registro
/// com separador de Windows. O site espera sempre `midia/<arquivo>`.
fn nome_do_arquivo(caminho: &str) -> Option<String> {
    caminho
        .rsplit(|c| c == '/' || c == '\\')
        .next()
        .filter(|s| !s.is_empty())
        .map(|s| s.to_string())
}

fn escrever_json(caminho: &Path, valor: &Value) -> Resultado<()> {
    let texto = serde_json::to_string_pretty(valor)
        .map_err(|e| ErroDominio::Validacao(format!("Falha ao serializar JSON: {}", e)))?;
    fs::write(caminho, texto)
        .map_err(|e| ErroDominio::Validacao(format!("Falha ao escrever {:?}: {}", caminho, e)))?;
    Ok(())
}

/// Exporta o acervo público inteiro para a pasta `acervo/` de um site.
///
/// `destino` é a pasta `acervo` do repositório do site. O comando escreve
/// `dados/catalogo_arvores.json`, `dados/arvores/<id>.json`,
/// `dados/linhas_tempo.json`, `dados/estatisticas.json` e copia os retratos
/// para `midia/`.
pub async fn exportar_acervo_para(
    db: &SqlitePool,
    destino: &Path,
    pasta_midia_origem: &Path,
) -> Resultado<RelatorioExportacao> {
    let dados = destino.join("dados");
    let arvores_dir = dados.join("arvores");
    let midia_dir = destino.join("midia");
    for p in [&dados, &arvores_dir, &midia_dir] {
        fs::create_dir_all(p)
            .map_err(|e| ErroDominio::Validacao(format!("Falha ao criar {:?}: {}", p, e)))?;
    }

    let mut avisos: Vec<String> = Vec::new();

    // ---------------------------------------------------------------- locais
    let mut locais: HashMap<String, String> = HashMap::new();
    for r in sqlx::query("SELECT id, nome FROM locais").fetch_all(db).await? {
        locais.insert(r.get::<String, _>("id"), r.get::<String, _>("nome"));
    }

    // ----------------------------------------------------------------- obras
    let mut obras: HashMap<String, Vec<Value>> = HashMap::new();
    for r in sqlx::query(
        "SELECT id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id
         FROM obras_culturais ORDER BY ano ASC",
    )
    .fetch_all(db)
    .await?
    {
        let pid: String = r.get("pessoa_id");
        let local_id: Option<String> = r.get("local_id");
        let local_nome = local_id.as_ref().and_then(|l| locais.get(l)).cloned();
        obras.entry(pid).or_default().push(json!({
            "id": r.get::<String, _>("id"),
            "categoria": r.get::<Option<String>, _>("categoria"),
            "titulo": r.get::<Option<String>, _>("titulo"),
            "subtipo": r.get::<Option<String>, _>("subtipo"),
            "ano": r.get::<Option<i64>, _>("ano"),
            "ano_fim": r.get::<Option<i64>, _>("ano_fim"),
            "detalhes": r.get::<Option<String>, _>("detalhes"),
            "local_id": local_id,
            "local_nome": local_nome,
        }));
    }

    // --------------------------------------------------------------- idiomas
    let mut idiomas: HashMap<String, Vec<String>> = HashMap::new();
    for r in sqlx::query("SELECT pessoa_id, idioma FROM idiomas_pessoa ORDER BY id")
        .fetch_all(db)
        .await?
    {
        idiomas
            .entry(r.get::<String, _>("pessoa_id"))
            .or_default()
            .push(r.get::<String, _>("idioma"));
    }

    // --------------------------------------------------------------- eventos
    let mut eventos: HashMap<String, Vec<Value>> = HashMap::new();
    for r in sqlx::query(
        "SELECT id, pessoa_id, tipo_evento, data_texto, ano_inicio, ano_fim,
                data_qualificador, local_id
         FROM eventos ORDER BY ano_inicio ASC",
    )
    .fetch_all(db)
    .await?
    {
        // Evento de união não tem pessoa_id e não entra na ficha de ninguém.
        let pid: Option<String> = r.get("pessoa_id");
        let Some(pid) = pid else { continue };
        let local_id: Option<String> = r.get("local_id");
        let local_nome = local_id.as_ref().and_then(|l| locais.get(l)).cloned();
        eventos.entry(pid).or_default().push(json!({
            "id": r.get::<String, _>("id"),
            "tipo_evento": r.get::<String, _>("tipo_evento"),
            "data_texto": r.get::<Option<String>, _>("data_texto"),
            "ano_inicio": r.get::<Option<i64>, _>("ano_inicio"),
            "ano_fim": r.get::<Option<i64>, _>("ano_fim"),
            "qualificador": r.get::<Option<String>, _>("data_qualificador"),
            "local_id": local_id,
            "local_nome": local_nome,
        }));
    }

    // --------------------------------------------------------------- árvores
    let linhas_arvores = sqlx::query(
        "SELECT id, nome, descricao, raiz_pessoa_id, categoria, pais, periodo, tipo_tempo
         FROM arvores WHERE is_publico = 1 ORDER BY categoria, nome",
    )
    .fetch_all(db)
    .await?;

    let mut catalogo: Vec<Value> = Vec::new();
    let mut fotos_necessarias: Vec<String> = Vec::new();
    let mut total_pessoas = 0usize;
    let mut total_unioes = 0usize;

    for arv in &linhas_arvores {
        let aid: String = arv.get("id");
        let tipo_tempo_arvore: Option<String> = arv.get("tipo_tempo");
        let raiz_id: Option<String> = arv.get("raiz_pessoa_id");

        let membros_raw = sqlx::query(
            "SELECT DISTINCT p.id, p.nome, p.sobrenome, p.sexo, p.minibiografia, p.is_vivo,
                    p.is_placeholder, p.foto_url, p.categoria, p.tipo_tempo
             FROM arvore_membros am
             JOIN pessoas p ON am.pessoa_id = p.id
             WHERE am.arvore_id = ? AND p.is_publico = 1
             ORDER BY p.nome",
        )
        .bind(&aid)
        .fetch_all(db)
        .await?;

        let mut membros: Vec<Value> = Vec::new();
        let mut raiz_info: Option<Value> = None;

        for m in &membros_raw {
            let pid: String = m.get("id");
            let nome: String = m.get("nome");
            let sobrenome: Option<String> = m.get("sobrenome");
            let nome_completo = match &sobrenome {
                Some(s) if !s.trim().is_empty() => format!("{} {}", nome.trim(), s.trim()),
                _ => nome.trim().to_string(),
            };

            let evs = eventos.get(&pid).cloned().unwrap_or_default();
            let achar = |tipos: &[&str]| -> Option<Value> {
                evs.iter()
                    .find(|e| {
                        e.get("tipo_evento")
                            .and_then(|t| t.as_str())
                            .map(|t| tipos.contains(&t))
                            .unwrap_or(false)
                    })
                    .cloned()
            };
            let nasc = achar(&["nascimento"]);
            let falec = achar(&["falecimento", "morte"]);
            let campo = |ev: &Option<Value>, c: &str| -> Value {
                ev.as_ref()
                    .and_then(|e| e.get(c).cloned())
                    .unwrap_or(Value::Null)
            };

            let foto_bruta: Option<String> = m.get("foto_url");
            let foto_web = foto_bruta.as_deref().and_then(nome_do_arquivo).map(|f| {
                fotos_necessarias.push(f.clone());
                format!("midia/{}", f)
            });

            let p_data = json!({
                "id": pid,
                "nome": nome,
                "sobrenome": sobrenome,
                "nome_completo": nome_completo,
                "sexo": m.get::<Option<String>, _>("sexo"),
                "minibiografia": m.get::<Option<String>, _>("minibiografia"),
                "is_vivo": m.get::<i64, _>("is_vivo") != 0,
                "is_placeholder": m.get::<i64, _>("is_placeholder") != 0,
                "foto_url": foto_web,
                "tipo_tempo": m.get::<Option<String>, _>("tipo_tempo").or_else(|| tipo_tempo_arvore.clone()),
                "categoria": m.get::<Option<String>, _>("categoria"),
                "ano_nascimento": campo(&nasc, "ano_inicio"),
                "ano_falecimento": campo(&falec, "ano_inicio"),
                "data_nascimento_texto": campo(&nasc, "data_texto"),
                "data_falecimento_texto": campo(&falec, "data_texto"),
                "local_nascimento": campo(&nasc, "local_nome"),
                "local_falecimento": campo(&falec, "local_nome"),
                "obras": obras.get(&pid).cloned().unwrap_or_default(),
                "idiomas": idiomas.get(&pid).cloned().unwrap_or_default(),
                "eventos": evs,
            });

            if Some(&pid) == raiz_id.as_ref() {
                raiz_info = Some(p_data.clone());
            }
            membros.push(p_data);
        }

        // Sem raiz declarada, o site usa o primeiro membro -- é o que o portal
        // ja fazia, e mudar isso trocaria a capa de varias linhagens.
        if raiz_info.is_none() {
            raiz_info = membros.first().cloned();
        }

        let unioes_raw = sqlx::query(
            "SELECT DISTINCT u.id, u.slot_masculino_id, u.slot_feminino_id,
                    u.estado_vinculo, u.nota
             FROM unioes u
             LEFT JOIN pessoas pm ON pm.id = u.slot_masculino_id
             LEFT JOIN pessoas pf ON pf.id = u.slot_feminino_id
             WHERE (
                    u.slot_masculino_id IN (SELECT am.pessoa_id FROM arvore_membros am JOIN pessoas p ON p.id = am.pessoa_id WHERE am.arvore_id = ? AND p.is_publico = 1)
                 OR u.slot_feminino_id IN (SELECT am.pessoa_id FROM arvore_membros am JOIN pessoas p ON p.id = am.pessoa_id WHERE am.arvore_id = ? AND p.is_publico = 1)
             )
               AND (u.slot_masculino_id IS NULL OR pm.is_publico = 1)
               AND (u.slot_feminino_id IS NULL OR pf.is_publico = 1)",
        )
        .bind(&aid)
        .bind(&aid)
        .fetch_all(db)
        .await?;

        let mut unioes: Vec<Value> = Vec::new();
        for u in &unioes_raw {
            let uid: String = u.get("id");
            let filhos_raw = sqlx::query(
                "SELECT uf.pessoa_id, uf.tipo_vinculo, uf.ordem
                 FROM uniao_filhos uf
                 JOIN pessoas p ON p.id = uf.pessoa_id
                 WHERE uf.uniao_id = ? AND p.is_publico = 1
                 ORDER BY uf.ordem ASC",
            )
            .bind(&uid)
            .fetch_all(db)
            .await?;
            let filhos: Vec<Value> = filhos_raw
                .iter()
                .map(|f| {
                    json!({
                        "pessoa_id": f.get::<String, _>("pessoa_id"),
                        "tipo_vinculo": f.get::<Option<String>, _>("tipo_vinculo"),
                        "ordem": f.get::<Option<i64>, _>("ordem"),
                    })
                })
                .collect();

            unioes.push(json!({
                "id": uid,
                "masculino_id": u.get::<Option<String>, _>("slot_masculino_id"),
                "feminino_id": u.get::<Option<String>, _>("slot_feminino_id"),
                "estado_vinculo": u.get::<Option<String>, _>("estado_vinculo"),
                "nota": u.get::<Option<String>, _>("nota"),
                "filhos": filhos,
            }));
        }

        if membros.is_empty() {
            avisos.push(format!(
                "A árvore '{}' não tem nenhum membro em arvore_membros e saiu vazia.",
                aid
            ));
        }

        total_pessoas += membros.len();
        total_unioes += unioes.len();

        let detalhe = json!({
            "id": aid,
            "nome": arv.get::<String, _>("nome"),
            "descricao": arv.get::<Option<String>, _>("descricao"),
            "categoria": arv.get::<Option<String>, _>("categoria"),
            "pais": arv.get::<Option<String>, _>("pais"),
            "periodo": arv.get::<Option<String>, _>("periodo"),
            "tipo_tempo": tipo_tempo_arvore,
            "raiz_pessoa_id": raiz_id,
            "total_membros": membros.len(),
            "total_unioes": unioes.len(),
            "membros": membros,
            "unioes": unioes,
        });
        escrever_json(&arvores_dir.join(format!("{}.json", aid)), &detalhe)?;

        let total_obras: usize = detalhe["membros"]
            .as_array()
            .map(|ms| {
                ms.iter()
                    .map(|m| m["obras"].as_array().map(|o| o.len()).unwrap_or(0))
                    .sum()
            })
            .unwrap_or(0);
        let nomes_busca: Vec<Value> = detalhe["membros"]
            .as_array()
            .map(|ms| ms.iter().map(|m| m["nome_completo"].clone()).collect())
            .unwrap_or_default();

        catalogo.push(json!({
            "id": detalhe["id"],
            "nome": detalhe["nome"],
            "descricao": detalhe["descricao"],
            "categoria": detalhe["categoria"],
            "pais": detalhe["pais"],
            "periodo": detalhe["periodo"],
            "tipo_tempo": detalhe["tipo_tempo"],
            "total_membros": detalhe["total_membros"],
            "total_obras": total_obras,
            "membros_busca": nomes_busca,
            "raiz": raiz_info.as_ref().map(|r| json!({
                "id": r["id"],
                "nome": r["nome_completo"],
                "foto_url": r["foto_url"],
                "ano_nascimento": r["ano_nascimento"],
                "ano_falecimento": r["ano_falecimento"],
            })),
        }));
    }

    escrever_json(&dados.join("catalogo_arvores.json"), &json!(catalogo))?;

    // --------------------------------------------------- linhas do tempo
    let mapa_categorias: HashMap<&str, &str> = HashMap::from([
        ("historia", "História do Brasil"),
        ("moeda", "Moedas & Economia"),
        ("politica", "Poder e Governo"),
        ("tecnologia", "Tecnologia e Inovação"),
        ("projeto", "História Geral"),
    ]);

    let lts = sqlx::query(
        "SELECT id, categoria, titulo, is_contexto, escopo, icone, fonte_referencia
         FROM linhas_tempo WHERE is_contexto = 1",
    )
    .fetch_all(db)
    .await?;

    let mut linhas: Vec<Value> = Vec::new();
    for lt in &lts {
        let lid: String = lt.get("id");
        let marcos_raw = sqlx::query(
            "SELECT id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim
             FROM eventos_linha WHERE linha_id = ? ORDER BY ano_inicio ASC",
        )
        .bind(&lid)
        .fetch_all(db)
        .await?;
        let marcos: Vec<Value> = marcos_raw
            .iter()
            .map(|e| {
                json!({
                    "id": e.get::<String, _>("id"),
                    "data_periodo_texto": e.get::<Option<String>, _>("data_periodo_texto"),
                    "titulo": e.get::<Option<String>, _>("titulo"),
                    "descricao": e.get::<Option<String>, _>("descricao"),
                    "relevancia": e.get::<Option<String>, _>("relevancia"),
                    "ano_inicio": e.get::<Option<i64>, _>("ano_inicio"),
                    "ano_fim": e.get::<Option<i64>, _>("ano_fim"),
                })
            })
            .collect();

        let cat: Option<String> = lt.get("categoria");
        let cat_exibida = cat
            .as_deref()
            .and_then(|c| mapa_categorias.get(c).copied().map(|s| s.to_string()))
            .or_else(|| cat.clone());

        linhas.push(json!({
            "id": lid,
            "categoria": cat_exibida,
            "titulo": lt.get::<Option<String>, _>("titulo"),
            "is_contexto": lt.get::<i64, _>("is_contexto") != 0,
            "escopo": lt.get::<Option<String>, _>("escopo"),
            "icone": lt.get::<Option<String>, _>("icone"),
            "fonte_referencia": lt.get::<Option<String>, _>("fonte_referencia"),
            "total_marcos": marcos.len(),
            "marcos": marcos,
        }));
    }
    escrever_json(&dados.join("linhas_tempo.json"), &json!(linhas))?;

    // ------------------------------------------------------------ retratos
    let mut fotos_copiadas = 0usize;
    let mut fotos_ausentes = 0usize;
    let mut bytes_de_midia = 0u64;
    fotos_necessarias.sort();
    fotos_necessarias.dedup();

    for arquivo in &fotos_necessarias {
        let origem = pasta_midia_origem.join(arquivo);
        let alvo = midia_dir.join(arquivo);
        if !origem.exists() {
            fotos_ausentes += 1;
            continue;
        }
        // Só recopia se mudou: a pasta tem dezenas de MB e a maioria das
        // execuções muda poucas fotos.
        let precisa = match (fs::metadata(&origem), fs::metadata(&alvo)) {
            (Ok(o), Ok(a)) => o.len() != a.len(),
            _ => true,
        };
        if precisa {
            fs::copy(&origem, &alvo).map_err(|e| {
                ErroDominio::Validacao(format!("Falha ao copiar {}: {}", arquivo, e))
            })?;
        }
        if let Ok(meta) = fs::metadata(&alvo) {
            bytes_de_midia += meta.len();
        }
        fotos_copiadas += 1;
    }

    if fotos_ausentes > 0 {
        avisos.push(format!(
            "{} retrato(s) referenciado(s) no acervo não foram encontrados em {:?} e ficaram de fora.",
            fotos_ausentes, pasta_midia_origem
        ));
    }

    // -------------------------------------------------------- estatísticas
    let total_obras: i64 = sqlx::query(
        "SELECT COUNT(*) AS n
         FROM obras_culturais oc
         JOIN pessoas p ON p.id = oc.pessoa_id
         WHERE p.is_publico = 1",
    )
    .fetch_one(db)
    .await?
    .get("n");

    escrever_json(
        &dados.join("estatisticas.json"),
        &json!({
            "total_arvores": catalogo.len(),
            "total_pessoas": total_pessoas,
            "total_unioes": total_unioes,
            "total_obras": total_obras,
            "total_linhas_tempo": linhas.len(),
        }),
    )?;

    Ok(RelatorioExportacao {
        destino: destino.display().to_string(),
        arvores: catalogo.len(),
        pessoas: total_pessoas,
        unioes: total_unioes,
        linhas_tempo: linhas.len(),
        fotos_copiadas,
        fotos_ausentes,
        bytes_de_midia,
        avisos,
    })
}

/// Comando Tauri: exporta o acervo público para a pasta escolhida.
///
/// O frontend escolhe a pasta por `dialog`; quem escreve é o Rust, dentro das
/// regras da capability. Continua valendo: nada de `fs:` na capability.
#[tauri::command]
pub async fn exportar_acervo_web(
    destino: String,
    app: tauri::AppHandle,
    db: tauri::State<'_, SqlitePool>,
) -> Resultado<RelatorioExportacao> {
    use tauri::Manager;

    let caminho = PathBuf::from(&destino);
    if !caminho.is_dir() {
        return Err(ErroDominio::Validacao(format!(
            "A pasta de destino não existe: {}",
            destino
        )));
    }

    let midia = app
        .path()
        .app_data_dir()
        .map_err(|e| ErroDominio::Validacao(format!("Pasta de dados indisponível: {}", e)))?
        .join(crate::domain::documentos_cmds::PASTA_MIDIA);

    exportar_acervo_para(&db, &caminho, &midia).await
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    /// O acervo público inteiro atravessa a exportação sem perder árvore.
    ///
    /// Este teste existe por causa de um erro de diagnóstico concreto: ao
    /// tentar reconstruir o acervo só a partir das migrations e dos seeds
    /// versionados, saem 92 árvores. As outras cinco -- Família Imperial do
    /// Brasil, Presidentes do Brasil, Casa Real de Davi entre elas -- são
    /// inseridas por código em `semente_publica.rs`, não por SQL. Quem
    /// exporta tem de ser quem rodou `garantir_acervo_publico`, e é isso que
    /// a asserção abaixo prende: o número de arquivos escritos bate com o que
    /// o banco diz ter, seja ele qual for.
    #[tokio::test]
    async fn exporta_todas_as_arvores_publicas_que_o_banco_tem() {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations").run(&pool).await.expect("migrations");
        crate::domain::semente_publica::garantir_acervo_publico(&pool)
            .await
            .expect("semente do acervo público");

        let esperado: i64 = sqlx::query("SELECT COUNT(*) AS n FROM arvores WHERE is_publico = 1")
            .fetch_one(&pool)
            .await
            .expect("contagem")
            .get("n");
        assert!(esperado > 0, "o acervo público não foi semeado");

        let destino = std::env::temp_dir().join(format!(
            "elotempo_export_{}",
            uuid::Uuid::new_v4()
        ));
        std::fs::create_dir_all(&destino).expect("pasta de teste");
        let midia_vazia = destino.join("origem_inexistente");

        let rel = exportar_acervo_para(&pool, &destino, &midia_vazia)
            .await
            .expect("exportação");

        assert_eq!(
            rel.arvores as i64, esperado,
            "o catálogo exportado tem {} árvores, mas o banco tem {}",
            rel.arvores, esperado
        );

        // O catálogo e os arquivos individuais contam a mesma história.
        let catalogo: Vec<serde_json::Value> = serde_json::from_str(
            &std::fs::read_to_string(destino.join("dados/catalogo_arvores.json")).unwrap(),
        )
        .unwrap();
        assert_eq!(catalogo.len(), rel.arvores);

        for entrada in &catalogo {
            let id = entrada["id"].as_str().expect("id no catálogo");
            let arquivo = destino.join("dados/arvores").join(format!("{}.json", id));
            assert!(arquivo.exists(), "faltou o arquivo da árvore '{}'", id);
        }

        // As cinco que vêm do Rust, e não do SQL, precisam estar no pacote:
        // são elas que sumiriam numa exportação feita fora do programa.
        for id in ["arv_imperial_brasil", "arv_presidentes_brasil", "arv_biblica_david"] {
            assert!(
                catalogo.iter().any(|c| c["id"] == id),
                "a árvore '{}', inserida por código, não foi exportada",
                id
            );
        }

        std::fs::remove_dir_all(&destino).ok();
    }

    /// Casamento é evento da união, e não entra na ficha de ninguém.
    ///
    /// A consulta de eventos varre a tabela inteira; sem o filtro de
    /// `pessoa_id` nulo, o casamento entraria na lista de eventos de uma
    /// pessoa arbitrária e apareceria na página dela no site.
    #[tokio::test]
    async fn evento_de_uniao_nao_entra_na_ficha_de_pessoa() {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations").run(&pool).await.expect("migrations");

        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
             VALUES ('p_m', 'Antonio', 'Silva', 'M', 0, 0, 1),
                    ('p_f', 'Maria', 'Souza', 'F', 0, 0, 1)",
        )
        .execute(&pool)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES ('u1', 'p_m', 'p_f', 'casamento')",
        )
        .execute(&pool)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_texto)
             VALUES ('ev_cas', 'u1', 'casamento', 1890, 1890, '1890')",
        )
        .execute(&pool)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO arvores (id, nome, raiz_pessoa_id, is_publico)
             VALUES ('a1', 'Teste', 'p_m', 1)",
        )
        .execute(&pool)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO arvore_membros (arvore_id, pessoa_id) VALUES ('a1','p_m'),('a1','p_f')",
        )
        .execute(&pool)
        .await
        .unwrap();

        let destino = std::env::temp_dir().join(format!("elotempo_ev_{}", uuid::Uuid::new_v4()));
        std::fs::create_dir_all(&destino).unwrap();
        exportar_acervo_para(&pool, &destino, &destino.join("sem_midia"))
            .await
            .expect("exportação");

        let arvore: serde_json::Value = serde_json::from_str(
            &std::fs::read_to_string(destino.join("dados/arvores/a1.json")).unwrap(),
        )
        .unwrap();

        for membro in arvore["membros"].as_array().unwrap() {
            let eventos = membro["eventos"].as_array().unwrap();
            assert!(
                !eventos.iter().any(|e| e["tipo_evento"] == "casamento"),
                "o casamento da união entrou na ficha de {}",
                membro["nome_completo"]
            );
        }

        // E a união em si carrega o casal e sobrevive à exportação.
        assert_eq!(arvore["unioes"].as_array().unwrap().len(), 1);

        std::fs::remove_dir_all(&destino).ok();
    }

    /// Vincular uma pessoa pessoal (`is_publico = 0`) a uma figura histórica
    /// (`is_publico = 1`) jamais pode vazar a família do usuário na exportação
    /// do acervo público para o site.
    #[tokio::test]
    async fn familia_pessoal_vinculada_a_figura_publica_nao_vaza_na_exportacao() {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations").run(&pool).await.expect("migrations");

        // Figura pública curada + árvore pública
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
             VALUES ('pub_machado', 'Machado', 'de Assis', 'M', 0, 0, 1),
                    ('pub_carolina', 'Carolina', 'Novais', 'F', 0, 0, 1),
                    ('usr_vovo', 'Antepassado', 'DaFamilia', 'M', 0, 0, 0),
                    ('usr_vivo', 'Usuario', 'VivoDaFamilia', 'M', 1, 0, 0)",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO arvores (id, nome, raiz_pessoa_id, is_publico)
             VALUES ('arv_pub_machado', 'Machado de Assis', 'pub_machado', 1)",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES ('u_pub', 'pub_machado', 'pub_carolina', 'casamento')",
        )
        .execute(&pool)
        .await
        .unwrap();

        // Mesmo que `usr_vovo` e `usr_vivo` tenham sido ligados na união e até inseridos em `arvore_membros`
        // da árvore pública, a exportação pública DEVE filtrá-los!
        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES ('u_pub', 'usr_vovo', 'biologico', 1)",
        )
        .execute(&pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO arvore_membros (arvore_id, pessoa_id)
             VALUES ('arv_pub_machado', 'pub_machado'),
                    ('arv_pub_machado', 'pub_carolina'),
                    ('arv_pub_machado', 'usr_vovo'),
                    ('arv_pub_machado', 'usr_vivo')",
        )
        .execute(&pool)
        .await
        .unwrap();

        // Sincronizar também não deve puxar pessoas privadas para dentro de árvore pública
        crate::domain::arvores_cmds::sincronizar_membros_arvore(
            &pool,
            "arv_pub_machado",
            Some("pub_machado"),
        )
        .await
        .unwrap();

        let destino = std::env::temp_dir().join(format!(
            "elotempo_no_leak_{}",
            uuid::Uuid::new_v4()
        ));
        std::fs::create_dir_all(&destino).unwrap();
        let rel = exportar_acervo_para(&pool, &destino, &destino.join("sem_midia"))
            .await
            .expect("exportação");

        assert_eq!(
            rel.pessoas, 2,
            "apenas as 2 figuras públicas devem sair na exportação"
        );

        let arvore_json =
            std::fs::read_to_string(destino.join("dados/arvores/arv_pub_machado.json")).unwrap();
        let catalogo_json =
            std::fs::read_to_string(destino.join("dados/catalogo_arvores.json")).unwrap();

        assert!(
            !arvore_json.contains("usr_vovo")
                && !arvore_json.contains("DaFamilia")
                && !arvore_json.contains("usr_vivo")
                && !arvore_json.contains("VivoDaFamilia"),
            "CRÍTICO: dados da família do usuário vazaram no JSON da árvore pública: {arvore_json}"
        );
        assert!(
            !catalogo_json.contains("DaFamilia") && !catalogo_json.contains("VivoDaFamilia"),
            "CRÍTICO: nomes da família do usuário vazaram em catalogo_arvores.json"
        );

        std::fs::remove_dir_all(&destino).ok();
    }
}
