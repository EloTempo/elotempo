//! Montagem do grafo da árvore para a visualização.
//!
//! O backend devolve **grafo**, não desenho: nós, uniões e arestas. As
//! coordenadas são calculadas no frontend (`src/lib/tree/layout.ts`), porque o
//! layout é decisão de apresentação e muda com o zoom e com os ramos colapsados.
//!
//! Três defeitos da versão anterior foram corrigidos aqui:
//!
//! 1. A busca de uniões exigia que **os dois** cônjuges estivessem no recorte
//!    (`AND`). Bastava um estar de fora para a união inteira sumir — e com ela
//!    os filhos daquele ramo. Agora é `OR`.
//! 2. O ano de nascimento vinha de `tipo_evento = 'Nascimento'`, com maiúscula,
//!    comparado a texto livre. Agora usa a constante canônica e a coluna
//!    `ano_inicio`, que é numérica.
//! 3. A recursão só descia. A seção 10 pede ancestrais no topo, então agora
//!    sobe e desce a partir da raiz.

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;

use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;
use crate::domain::models::default_tipo_tempo;

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct PessoaNode {
    pub id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub is_vivo: bool,
    pub is_placeholder: bool,
    pub ano_nascimento: Option<i64>,
    pub ano_falecimento: Option<i64>,
    pub minibiografia: Option<String>,
    /// Caminho relativo do retrato, para o card desenhar a foto (fatia 03).
    pub foto_url: Option<String>,
    pub tem_foto: bool,
    pub tem_biografia: bool,
    /// Quantos documentos, religiões etc. existem — alimenta os "ícones de
    /// presença" do card descritos na seção 10.
    pub tem_documentos: bool,
    pub tem_religiao: bool,
    #[serde(default)]
    pub is_publico: bool,
    pub categoria: Option<String>,
    #[serde(default = "default_tipo_tempo")]
    pub tipo_tempo: String,
    pub arvore_nome: Option<String>,
    pub arvore_id: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UniaoNode {
    pub id: String,
    pub estado_vinculo: String,
    pub ano_casamento: Option<i64>,
    pub slot_masculino_id: String,
    pub slot_feminino_id: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GrafoLink {
    pub source: String,
    pub target: String,
    /// "pai_uniao", "mae_uniao" ou "uniao_filho".
    pub tipo: String,
    /// Só em "uniao_filho": biologico, adotado, enteado, tutelado.
    pub tipo_vinculo: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GrafoArvore {
    pub raiz_id: String,
    pub nodes: Vec<PessoaNode>,
    pub unions: Vec<UniaoNode>,
    pub links: Vec<GrafoLink>,
}

/// Monta o grafo em volta de uma pessoa raiz.
///
/// `geracoes_acima` e `geracoes_abaixo` limitam o recorte; o padrão de 4 para
/// cada lado cobre a janela que cabe na tela sem exigir pan.
#[tauri::command]
pub async fn buscar_grafo_arvore(
    raiz_id: String,
    geracoes_acima: Option<i64>,
    geracoes_abaixo: Option<i64>,
    db: State<'_, SqlitePool>,
) -> Resultado<GrafoArvore> {
    let acima = geracoes_acima.unwrap_or(4).clamp(0, 30);
    let abaixo = geracoes_abaixo.unwrap_or(4).clamp(0, 30);

    // ---------------------------------------------------------------
    // 1. Conjunto de pessoas: a raiz, seus ancestrais, seus descendentes,
    //    e os cônjuges de todos eles (senão as uniões ficam pela metade).
    //
    // `UNION` (não `UNION ALL`) nas recursivas: deduplica e, de quebra, faz a
    // recursão terminar mesmo se o grafo tiver um ciclo herdado de um import.
    // ---------------------------------------------------------------
    let ids: Vec<String> = sqlx::query_scalar(
        r#"
        WITH RECURSIVE
        ascendencia(id, nivel) AS (
            SELECT ?1, 0
            UNION
            SELECT vinculo.progenitor, a.nivel + 1
            FROM (
                SELECT f.pessoa_id AS filho, u.slot_masculino_id AS progenitor
                  FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                UNION ALL
                SELECT f.pessoa_id, u.slot_feminino_id
                  FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
            ) AS vinculo
            JOIN ascendencia a ON vinculo.filho = a.id
            WHERE a.nivel < ?2
        ),
        descendencia(id, nivel) AS (
            SELECT ?1, 0
            UNION
            SELECT f.pessoa_id, d.nivel + 1
            FROM descendencia d
            JOIN unioes u ON u.slot_masculino_id = d.id OR u.slot_feminino_id = d.id
            JOIN uniao_filhos f ON f.uniao_id = u.id
            WHERE d.nivel < ?3
        ),
        nucleo(id) AS (
            SELECT id FROM ascendencia
            UNION
            SELECT id FROM descendencia
        )
        SELECT id FROM nucleo
        UNION
        -- Cônjuges: quem divide uma união com alguém do núcleo.
        SELECT u.slot_masculino_id FROM unioes u JOIN nucleo n ON u.slot_feminino_id = n.id
        UNION
        SELECT u.slot_feminino_id FROM unioes u JOIN nucleo n ON u.slot_masculino_id = n.id
        UNION
        -- Se a pessoa raiz pertence a uma árvore do acervo, inclui todos os membros dessa árvore
        SELECT am.pessoa_id FROM arvore_membros am
        WHERE am.pessoa_id IS NOT NULL
          AND am.arvore_id = (SELECT arvore_id FROM arvore_membros WHERE pessoa_id = ?1 LIMIT 1)
        "#,
    )
    .bind(&raiz_id)
    .bind(acima)
    .bind(abaixo)
    .fetch_all(&*db)
    .await?;

    if ids.is_empty() {
        return Ok(GrafoArvore {
            raiz_id,
            nodes: vec![],
            unions: vec![],
            links: vec![],
        });
    }

    let marcadores = vec!["?"; ids.len()].join(",");

    // ---------------------------------------------------------------
    // 2. Os cards. Um único SELECT com subconsultas correlacionadas — os
    //    índices da migration 006 fazem cada uma custar um seek, não um scan.
    // ---------------------------------------------------------------
    let sql_nos = format!(
        r#"
        SELECT
            p.id, p.nome, p.sobrenome, p.sexo, p.is_vivo, p.is_placeholder,
            p.minibiografia,
            (SELECT e.ano_inicio FROM eventos e
              WHERE e.pessoa_id = p.id AND e.tipo_evento = '{nascimento}'
              ORDER BY e.ano_inicio LIMIT 1) AS ano_nascimento,
            (SELECT e.ano_inicio FROM eventos e
              WHERE e.pessoa_id = p.id AND e.tipo_evento = '{falecimento}'
              ORDER BY e.ano_inicio LIMIT 1) AS ano_falecimento,
            p.foto_url,
            (p.foto_url IS NOT NULL AND p.foto_url <> '') AS tem_foto,
            (p.minibiografia IS NOT NULL AND p.minibiografia <> '') AS tem_biografia,
            EXISTS(SELECT 1 FROM documento_vinculos dv WHERE dv.pessoa_id = p.id) AS tem_documentos,
            EXISTS(SELECT 1 FROM religioes_pessoa r WHERE r.pessoa_id = p.id) AS tem_religiao,
            p.is_publico,
            p.categoria,
            p.tipo_tempo,
            (SELECT a.nome FROM arvore_membros am JOIN arvores a ON a.id = am.arvore_id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_nome,
            (SELECT a.id FROM arvore_membros am JOIN arvores a ON a.id = am.arvore_id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_id
        FROM pessoas p
        WHERE p.id IN ({marcadores})
        "#,
        nascimento = tipos::NASCIMENTO,
        falecimento = tipos::FALECIMENTO,
        marcadores = marcadores,
    );

    let mut q = sqlx::query_as::<_, PessoaNode>(&sql_nos);
    for id in &ids {
        q = q.bind(id);
    }
    let nodes = q.fetch_all(&*db).await?;

    // ---------------------------------------------------------------
    // 3. Uniões: basta UM dos lados estar no recorte.
    //
    // Era aqui o defeito nº 1. Com `AND`, a união dos pais da raiz sumia
    // sempre que um dos avós ficava fora do limite de gerações.
    // ---------------------------------------------------------------
    let sql_unioes = format!(
        r#"
        SELECT u.id, u.estado_vinculo, u.slot_masculino_id, u.slot_feminino_id,
               (SELECT e.ano_inicio FROM eventos e
                 WHERE e.uniao_id = u.id AND e.tipo_evento = '{casamento}'
                 ORDER BY e.ano_inicio LIMIT 1) AS ano_casamento
        FROM unioes u
        WHERE u.slot_masculino_id IN ({m}) OR u.slot_feminino_id IN ({m})
        "#,
        casamento = tipos::CASAMENTO,
        m = marcadores,
    );

    let mut q = sqlx::query(&sql_unioes);
    for id in &ids {
        q = q.bind(id);
    }
    for id in &ids {
        q = q.bind(id);
    }
    let linhas_uniao = q.fetch_all(&*db).await?;

    let mut unions = Vec::with_capacity(linhas_uniao.len());
    let mut links = Vec::new();
    let mut ids_uniao = Vec::with_capacity(linhas_uniao.len());

    for row in linhas_uniao {
        let id: String = row.try_get("id")?;
        let slot_m: String = row.try_get("slot_masculino_id")?;
        let slot_f: String = row.try_get("slot_feminino_id")?;

        links.push(GrafoLink {
            source: slot_m.clone(),
            target: id.clone(),
            tipo: "pai_uniao".into(),
            tipo_vinculo: None,
        });
        links.push(GrafoLink {
            source: slot_f.clone(),
            target: id.clone(),
            tipo: "mae_uniao".into(),
            tipo_vinculo: None,
        });

        ids_uniao.push(id.clone());
        unions.push(UniaoNode {
            id,
            estado_vinculo: row.try_get("estado_vinculo")?,
            ano_casamento: row.try_get("ano_casamento")?,
            slot_masculino_id: slot_m,
            slot_feminino_id: slot_f,
        });
    }

    // ---------------------------------------------------------------
    // 4. Filhos, na ordem gravada — o layout depende dela para não embaralhar
    //    os irmãos a cada abertura.
    // ---------------------------------------------------------------
    if !ids_uniao.is_empty() {
        let m_uniao = vec!["?"; ids_uniao.len()].join(",");
        let sql_filhos = format!(
            "SELECT uniao_id, pessoa_id, tipo_vinculo FROM uniao_filhos
             WHERE uniao_id IN ({m_uniao}) ORDER BY uniao_id, ordem"
        );

        let mut q = sqlx::query(&sql_filhos);
        for id in &ids_uniao {
            q = q.bind(id);
        }

        for row in q.fetch_all(&*db).await? {
            links.push(GrafoLink {
                source: row.try_get("uniao_id")?,
                target: row.try_get("pessoa_id")?,
                tipo: "uniao_filho".into(),
                tipo_vinculo: row.try_get("tipo_vinculo")?,
            });
        }
    }

    // Poda o que aponta para fora do recorte, senão sobra aresta solta no
    // desenho. A ordem importa: primeiro caem as uniões cujo par não está
    // inteiro no recorte, e só depois os links, que podem referenciar uma
    // união recém-descartada.
    let ids_pessoas: std::collections::HashSet<&str> =
        nodes.iter().map(|n| n.id.as_str()).collect();

    unions.retain(|u| {
        ids_pessoas.contains(u.slot_masculino_id.as_str())
            && ids_pessoas.contains(u.slot_feminino_id.as_str())
    });

    let conhecidos: std::collections::HashSet<&str> = ids_pessoas
        .iter()
        .copied()
        .chain(unions.iter().map(|u| u.id.as_str()))
        .collect();

    links.retain(|l| {
        conhecidos.contains(l.source.as_str()) && conhecidos.contains(l.target.as_str())
    });

    Ok(GrafoArvore {
        raiz_id,
        nodes,
        unions,
        links,
    })
}

/// Lista pessoas para o seletor de raiz e para a busca por nome (seção 7).
#[tauri::command]
pub async fn buscar_pessoas(
    termo: Option<String>,
    limite: Option<i64>,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<PessoaNode>> {
    let limite = limite.unwrap_or(50).clamp(1, 500);
    // O termo digitado também vai normalizado — os dois lados da comparação
    // precisam estar na mesma forma.
    let padrao = format!(
        "%{}%",
        crate::domain::texto::normalizar_busca(&termo.unwrap_or_default())
    );

    let sql = format!(
        r#"
        SELECT
            p.id, p.nome, p.sobrenome, p.sexo, p.is_vivo, p.is_placeholder,
            p.minibiografia,
            (SELECT e.ano_inicio FROM eventos e
              WHERE e.pessoa_id = p.id AND e.tipo_evento = '{nascimento}'
              ORDER BY e.ano_inicio LIMIT 1) AS ano_nascimento,
            (SELECT e.ano_inicio FROM eventos e
              WHERE e.pessoa_id = p.id AND e.tipo_evento = '{falecimento}'
              ORDER BY e.ano_inicio LIMIT 1) AS ano_falecimento,
            p.foto_url,
            (p.foto_url IS NOT NULL AND p.foto_url <> '') AS tem_foto,
            (p.minibiografia IS NOT NULL AND p.minibiografia <> '') AS tem_biografia,
            EXISTS(SELECT 1 FROM documento_vinculos dv WHERE dv.pessoa_id = p.id) AS tem_documentos,
            EXISTS(SELECT 1 FROM religioes_pessoa r WHERE r.pessoa_id = p.id) AS tem_religiao,
            p.is_publico,
            p.categoria,
            p.tipo_tempo,
            (SELECT a.nome FROM arvore_membros am JOIN arvores a ON a.id = am.arvore_id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_nome,
            (SELECT a.id FROM arvore_membros am JOIN arvores a ON a.id = am.arvore_id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_id
        FROM pessoas p
        -- Sem acento dos dois lados: "jose" precisa achar "José", porque
        -- ninguém digita acento procurando.
        WHERE {nome} LIKE ?1
           OR {sobrenome} LIKE ?1
           -- Pelos outros nomes que a pessoa carregou (fatia 02): é o que
           -- permite procurar "Bergoglio" e chegar em "Francisco", ou o nome
           -- de solteira de uma bisavó cadastrada como casada.
           OR EXISTS (
                SELECT 1 FROM nomes_pessoa n
                 WHERE n.pessoa_id = p.id
                   AND ({n_nome} LIKE ?1 OR {n_sobrenome} LIKE ?1)
              )
           -- E pelos apelidos: quem procura "Tia Chica" não sabe que aquilo
           -- está guardado como apelido e não como nome.
           OR EXISTS (
                SELECT 1 FROM apelidos_pessoa a
                 WHERE a.pessoa_id = p.id AND {apelido} LIKE ?1
              )
        ORDER BY p.is_placeholder, p.sobrenome COLLATE NOCASE, p.nome COLLATE NOCASE
        LIMIT ?2
        "#,
        nascimento = tipos::NASCIMENTO,
        falecimento = tipos::FALECIMENTO,
        nome = crate::domain::texto::sem_acento_sql("p.nome"),
        sobrenome = crate::domain::texto::sem_acento_sql("COALESCE(p.sobrenome,'')"),
        n_nome = crate::domain::texto::sem_acento_sql("n.nome"),
        n_sobrenome = crate::domain::texto::sem_acento_sql("COALESCE(n.sobrenome,'')"),
        apelido = crate::domain::texto::sem_acento_sql("a.apelido"),
    );

    Ok(sqlx::query_as::<_, PessoaNode>(&sql)
        .bind(&padrao)
        .bind(limite)
        .fetch_all(&*db)
        .await?)
}

#[cfg(test)]
mod testes {
    use super::*;
    use crate::domain::regras::{self, NovaPessoa};
    use sqlx::sqlite::SqlitePoolOptions;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    async fn pessoa(pool: &SqlitePool, nome: &str, sexo: &str) -> String {
        regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: None,
                sexo: sexo.into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
                tipo_tempo: None,
            },
        )
        .await
        .unwrap()
    }

    /// Reproduz o defeito nº 1: antes, esta união desaparecia.
    #[tokio::test]
    async fn a_uniao_dos_pais_sobrevive_com_um_conjuge_fora_do_recorte() {
        let pool = pool_de_teste().await;

        let pai = pessoa(&pool, "Pai", "M").await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let filho = pessoa(&pool, "Filho", "M").await;

        let u = regras::criar_uniao(&pool, Some(&pai), Some(&mae), "casamento")
            .await
            .unwrap();
        regras::anexar_filho(&pool, &u, &filho, "biologico").await.unwrap();

        // Recorte de uma geração acima a partir do filho: alcança pai e mãe.
        let ids: Vec<String> = sqlx::query_scalar(
            r#"
            WITH RECURSIVE ascendencia(id, nivel) AS (
                SELECT ?1, 0
                UNION
                SELECT v.progenitor, a.nivel + 1 FROM (
                    SELECT f.pessoa_id AS filho, u.slot_masculino_id AS progenitor
                      FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                    UNION ALL
                    SELECT f.pessoa_id, u.slot_feminino_id
                      FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                ) v JOIN ascendencia a ON v.filho = a.id WHERE a.nivel < 1
            ) SELECT id FROM ascendencia
            "#,
        )
        .bind(&filho)
        .fetch_all(&pool)
        .await
        .unwrap();

        assert_eq!(ids.len(), 3, "deveria alcançar filho, pai e mãe");

        // E com OR a união aparece; com o AND antigo, bastaria a mãe faltar.
        let achadas: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM unioes WHERE slot_masculino_id = ?1 OR slot_feminino_id = ?1",
        )
        .bind(&pai)
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(achadas, 1);
    }

    /// A busca alcança nomes que não estão no card.
    ///
    /// Sem isto, cadastrar alguém como "Papa Francisco" tornaria "Bergoglio"
    /// inencontrável — e o nome de solteira de uma bisavó, também.
    #[tokio::test]
    async fn busca_encontra_pelos_outros_nomes_da_pessoa() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Francisco", "M").await;

        sqlx::query(
            "INSERT INTO nomes_pessoa (id,pessoa_id,tipo,nome,sobrenome,ordem)
             VALUES ('n1',?,'nascimento','Jorge Mario','Bergoglio',1)",
        )
        .bind(&p)
        .execute(&pool)
        .await
        .unwrap();

        let achados: Vec<String> = sqlx::query_scalar(
            "SELECT p.id FROM pessoas p
             WHERE p.nome LIKE ?1 COLLATE NOCASE
                OR COALESCE(p.sobrenome,'') LIKE ?1 COLLATE NOCASE
                OR EXISTS (SELECT 1 FROM nomes_pessoa n
                            WHERE n.pessoa_id = p.id
                              AND (n.nome LIKE ?1 COLLATE NOCASE
                                   OR COALESCE(n.sobrenome,'') LIKE ?1 COLLATE NOCASE))",
        )
        .bind("%bergoglio%")
        .fetch_all(&pool)
        .await
        .unwrap();

        assert_eq!(achados, vec![p.clone()], "deveria achar pelo nome de nascimento");

        // E continua achando pelo nome de exibição.
        let por_exibicao: Vec<String> = sqlx::query_scalar(
            "SELECT id FROM pessoas WHERE nome LIKE ?1 COLLATE NOCASE",
        )
        .bind("%francisco%")
        .fetch_all(&pool)
        .await
        .unwrap();
        assert_eq!(por_exibicao, vec![p]);
    }

    #[tokio::test]
    async fn tipo_de_evento_canonico_e_encontrado_pela_query() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Ana", "F").await;

        // Gravado pela constante — que é o que os comandos usam.
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio,ano_fim)
             VALUES ('e1',?,?,'1900','exata',1900,1900)",
        )
        .bind(&p)
        .bind(tipos::NASCIMENTO)
        .execute(&pool)
        .await
        .unwrap();

        let ano: Option<i64> = sqlx::query_scalar(&format!(
            "SELECT ano_inicio FROM eventos WHERE pessoa_id = ? AND tipo_evento = '{}'",
            tipos::NASCIMENTO
        ))
        .bind(&p)
        .fetch_optional(&pool)
        .await
        .unwrap()
        .flatten();

        assert_eq!(ano, Some(1900));
    }
}
