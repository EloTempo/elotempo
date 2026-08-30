//! Busca multicritério (fatia 06, seção 7).
//!
//! A consulta é montada conforme os filtros ativos, mas **nenhum valor entra
//! por interpolação**: só a estrutura do SQL varia, e todo dado vai por bind.
//! É a diferença entre montar uma query e abrir uma porta.

use serde::{Deserialize, Serialize};
use sqlx::{Sqlite, SqlitePool};
use tauri::State;

use crate::commands::tree_cmds::PessoaNode;
use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;
use crate::domain::texto::normalizar_busca;

#[derive(Debug, Default, Deserialize)]
pub struct FiltrosBusca {
    /// Nome, sobrenome, ou qualquer nome de `nomes_pessoa`.
    pub texto: Option<String>,
    /// Só o sobrenome — para agrupar linhagem.
    pub sobrenome: Option<String>,
    /// Local do **nascimento**, não de qualquer evento (ver a spec da fatia).
    pub local_id: Option<String>,
    pub pais_id: Option<String>,
    /// 1940 casa com quem nasceu entre 1940 e 1949.
    pub decada: Option<i64>,
    pub religiao: Option<String>,
    pub profissao: Option<String>,
    pub idioma: Option<String>,
    pub escolaridade: Option<String>,
    /// `Some(true)` = só vivas; `Some(false)` = só falecidas; `None` = ambas.
    pub apenas_vivas: Option<bool>,
    pub incluir_placeholders: bool,
}

/// Um valor que existe no acervo, com quantas pessoas o têm.
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct OpcaoDeFiltro {
    pub valor: String,
    pub rotulo: String,
    pub quantas: i64,
}

/// O que os seletores devem oferecer — só o que existe de fato.
#[derive(Debug, Serialize, Default)]
pub struct OpcoesDeFiltro {
    pub religioes: Vec<OpcaoDeFiltro>,
    pub profissoes: Vec<OpcaoDeFiltro>,
    pub idiomas: Vec<OpcaoDeFiltro>,
    pub escolaridade: Vec<OpcaoDeFiltro>,
    pub decadas: Vec<OpcaoDeFiltro>,
    pub paises: Vec<OpcaoDeFiltro>,
    pub locais: Vec<OpcaoDeFiltro>,
}

/// Colunas que o `PessoaNode` espera. Repetidas aqui porque a busca precisa
/// devolver exatamente o mesmo formato que a árvore e a lista lateral usam.
fn colunas_do_no() -> String {
    format!(
        r#"
        p.id, p.nome, p.sobrenome, p.sexo, p.is_vivo, p.is_placeholder,
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
        EXISTS(SELECT 1 FROM religioes_pessoa r WHERE r.pessoa_id = p.id) AS tem_religiao
        "#,
        nascimento = tipos::NASCIMENTO,
        falecimento = tipos::FALECIMENTO,
    )
}

/// Valor a vincular, na ordem em que os `?` aparecem no SQL montado.
enum Valor {
    Texto(String),
    Numero(i64),
}

#[tauri::command]
pub async fn buscar_pessoas_filtrado(
    filtros: FiltrosBusca,
    limite: Option<i64>,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<PessoaNode>> {
    buscar(&db, &filtros, limite.unwrap_or(200)).await
}

pub async fn buscar(
    pool: &SqlitePool,
    filtros: &FiltrosBusca,
    limite: i64,
) -> Resultado<Vec<PessoaNode>> {
    let limite = limite.clamp(1, 1000);

    let mut condicoes: Vec<String> = Vec::new();
    let mut valores: Vec<Valor> = Vec::new();

    if !filtros.incluir_placeholders {
        condicoes.push("p.is_placeholder = 0".into());
    }

    // Texto: nome de exibição, sobrenome, ou qualquer nome que a pessoa teve.
    if let Some(t) = texto_util(&filtros.texto) {
        condicoes.push(
            "(p.nome LIKE ? COLLATE NOCASE
              OR COALESCE(p.sobrenome,'') LIKE ? COLLATE NOCASE
              OR EXISTS (SELECT 1 FROM nomes_pessoa n
                          WHERE n.pessoa_id = p.id
                            AND (n.nome LIKE ? COLLATE NOCASE
                                 OR COALESCE(n.sobrenome,'') LIKE ? COLLATE NOCASE)))"
                .into(),
        );
        let padrao = format!("%{t}%");
        for _ in 0..4 {
            valores.push(Valor::Texto(padrao.clone()));
        }
    }

    if let Some(s) = texto_util(&filtros.sobrenome) {
        condicoes.push("COALESCE(p.sobrenome,'') LIKE ? COLLATE NOCASE".into());
        valores.push(Valor::Texto(format!("%{s}%")));
    }

    // Cidade = local do nascimento. Ver a decisão declarada na spec da fatia.
    if let Some(local) = texto_util(&filtros.local_id) {
        condicoes.push(format!(
            "EXISTS (SELECT 1 FROM eventos e
                      WHERE e.pessoa_id = p.id
                        AND e.tipo_evento = '{}'
                        AND e.local_id = ?)",
            tipos::NASCIMENTO
        ));
        valores.push(Valor::Texto(local));
    }

    if let Some(pais) = texto_util(&filtros.pais_id) {
        condicoes.push(
            "EXISTS (SELECT 1 FROM nacionalidades_pessoa n
                      WHERE n.pessoa_id = p.id AND n.pais_id = ?)"
                .into(),
        );
        valores.push(Valor::Texto(pais));
    }

    // Década sai de `ano_inicio`, derivado na gravação — nunca do texto livre.
    if let Some(decada) = filtros.decada {
        condicoes.push(format!(
            "EXISTS (SELECT 1 FROM eventos e
                      WHERE e.pessoa_id = p.id
                        AND e.tipo_evento = '{}'
                        AND e.ano_inicio BETWEEN ? AND ?)",
            tipos::NASCIMENTO
        ));
        valores.push(Valor::Numero(decada));
        valores.push(Valor::Numero(decada + 9));
    }

    // Os quatro atributos de lista seguem o mesmo molde.
    for (valor, tabela, coluna) in [
        (&filtros.religiao, "religioes_pessoa", "denominacao"),
        (&filtros.profissao, "profissoes_pessoa", "ocupacao"),
        (&filtros.idioma, "idiomas_pessoa", "idioma"),
        (&filtros.escolaridade, "escolaridade_pessoa", "nivel"),
    ] {
        if let Some(v) = texto_util(valor) {
            // `tabela` e `coluna` são constantes do próprio código, nunca do
            // usuário — interpolá-las é seguro. O valor vai por bind.
            condicoes.push(format!(
                "EXISTS (SELECT 1 FROM {tabela} t
                          WHERE t.pessoa_id = p.id AND t.{coluna} = ?)"
            ));
            valores.push(Valor::Texto(v));
        }
    }

    if let Some(vivas) = filtros.apenas_vivas {
        condicoes.push("p.is_vivo = ?".into());
        valores.push(Valor::Numero(if vivas { 1 } else { 0 }));
    }

    let onde = if condicoes.is_empty() {
        String::new()
    } else {
        format!("WHERE {}", condicoes.join(" AND "))
    };

    let sql = format!(
        "SELECT {colunas}
         FROM pessoas p
         {onde}
         ORDER BY p.sobrenome COLLATE NOCASE, p.nome COLLATE NOCASE
         LIMIT ?",
        colunas = colunas_do_no(),
    );

    let mut q = sqlx::query_as::<Sqlite, PessoaNode>(&sql);
    for v in &valores {
        q = match v {
            Valor::Texto(s) => q.bind(s),
            Valor::Numero(n) => q.bind(n),
        };
    }
    q = q.bind(limite);

    Ok(q.fetch_all(pool).await?)
}

fn texto_util(valor: &Option<String>) -> Option<String> {
    valor
        .as_ref()
        .map(|v| v.trim().to_string())
        .filter(|v| !v.is_empty())
}

/// O que os seletores devem oferecer.
///
/// Só o que existe no acervo: oferecer a taxonomia inteira faria o usuário
/// escolher "Budista" num acervo sem nenhum budista e receber lista vazia —
/// o que parece defeito do programa, e não é.
#[tauri::command]
pub async fn opcoes_de_filtro(db: State<'_, SqlitePool>) -> Resultado<OpcoesDeFiltro> {
    let pool: &SqlitePool = &db;

    async fn distintos(
        pool: &SqlitePool,
        sql: &str,
    ) -> Resultado<Vec<OpcaoDeFiltro>> {
        Ok(sqlx::query_as::<_, OpcaoDeFiltro>(sql).fetch_all(pool).await?)
    }

    let religioes = distintos(
        pool,
        "SELECT denominacao AS valor, denominacao AS rotulo, COUNT(DISTINCT pessoa_id) AS quantas
         FROM religioes_pessoa GROUP BY denominacao ORDER BY quantas DESC, denominacao",
    )
    .await?;

    let profissoes = distintos(
        pool,
        "SELECT ocupacao AS valor, ocupacao AS rotulo, COUNT(DISTINCT pessoa_id) AS quantas
         FROM profissoes_pessoa GROUP BY ocupacao ORDER BY quantas DESC, ocupacao",
    )
    .await?;

    let idiomas = distintos(
        pool,
        "SELECT idioma AS valor, idioma AS rotulo, COUNT(DISTINCT pessoa_id) AS quantas
         FROM idiomas_pessoa GROUP BY idioma ORDER BY quantas DESC, idioma",
    )
    .await?;

    let escolaridade = distintos(
        pool,
        "SELECT nivel AS valor, nivel AS rotulo, COUNT(DISTINCT pessoa_id) AS quantas
         FROM escolaridade_pessoa GROUP BY nivel ORDER BY quantas DESC, nivel",
    )
    .await?;

    let paises = distintos(
        pool,
        "SELECT p.id AS valor, p.nome AS rotulo, COUNT(DISTINCT n.pessoa_id) AS quantas
         FROM nacionalidades_pessoa n JOIN paises p ON p.id = n.pais_id
         GROUP BY p.id, p.nome ORDER BY quantas DESC, p.nome",
    )
    .await?;

    let decadas = distintos(
        pool,
        &format!(
            "SELECT CAST((e.ano_inicio / 10) * 10 AS TEXT) AS valor,
                    CAST((e.ano_inicio / 10) * 10 AS TEXT) || 's' AS rotulo,
                    COUNT(DISTINCT e.pessoa_id) AS quantas
             FROM eventos e
             WHERE e.tipo_evento = '{}' AND e.ano_inicio IS NOT NULL
             GROUP BY (e.ano_inicio / 10) ORDER BY valor",
            tipos::NASCIMENTO
        ),
    )
    .await?;

    let locais = distintos(
        pool,
        &format!(
            "SELECT l.id AS valor,
                    CASE WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                         ELSE l.nome || ', ' || pa.nome END AS rotulo,
                    COUNT(DISTINCT e.pessoa_id) AS quantas
             FROM eventos e
             JOIN locais l ON l.id = e.local_id
             JOIN paises pa ON pa.id = l.pais_id
             WHERE e.tipo_evento = '{}'
             GROUP BY l.id ORDER BY quantas DESC, rotulo",
            tipos::NASCIMENTO
        ),
    )
    .await?;

    Ok(OpcoesDeFiltro {
        religioes,
        profissoes,
        idiomas,
        escolaridade,
        decadas,
        paises,
        locais,
    })
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

    async fn pessoa(pool: &SqlitePool, nome: &str, sobrenome: &str, vivo: bool) -> String {
        regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: Some(sobrenome.into()),
                sexo: "U".into(),
                minibiografia: None,
                is_vivo: vivo,
                foto_url: None,
            },
        )
        .await
        .unwrap()
    }

    async fn nasceu(pool: &SqlitePool, id: &str, ano: i64, local: Option<&str>) {
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio,local_id)
             VALUES (?,?,?,?,'exata',?,?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(id)
        .bind(tipos::NASCIMENTO)
        .bind(ano.to_string())
        .bind(ano)
        .bind(local)
        .execute(pool)
        .await
        .unwrap();
    }

    async fn religiao(pool: &SqlitePool, id: &str, denominacao: &str) {
        sqlx::query("INSERT INTO religioes_pessoa (id,pessoa_id,denominacao) VALUES (?,?,?)")
            .bind(uuid::Uuid::new_v4().to_string())
            .bind(id)
            .bind(denominacao)
            .execute(pool)
            .await
            .unwrap();
    }

    /// Um município real do seed, para os filtros de cidade.
    async fn um_municipio(pool: &SqlitePool, nome_busca: &str) -> String {
        sqlx::query_scalar("SELECT id FROM locais WHERE nome_busca = ? LIMIT 1")
            .bind(nome_busca)
            .fetch_one(pool)
            .await
            .unwrap()
    }

    #[tokio::test]
    async fn sem_filtro_devolve_o_acervo() {
        let pool = pool_de_teste().await;
        pessoa(&pool, "Ana", "Silva", false).await;
        pessoa(&pool, "Bruno", "Costa", false).await;

        let r = buscar(&pool, &FiltrosBusca::default(), 100).await.unwrap();
        assert_eq!(r.len(), 2);
    }

    #[tokio::test]
    async fn placeholders_ficam_fora_por_padrao() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "Silva", false).await;
        regras::criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let r = buscar(&pool, &FiltrosBusca::default(), 100).await.unwrap();
        assert_eq!(r.len(), 1, "o placeholder não deveria aparecer na busca");
    }

    #[tokio::test]
    async fn filtra_por_decada_de_nascimento() {
        let pool = pool_de_teste().await;
        let a = pessoa(&pool, "Quarenta", "Silva", false).await;
        let b = pessoa(&pool, "Cinquenta", "Silva", false).await;
        nasceu(&pool, &a, 1945, None).await;
        nasceu(&pool, &b, 1955, None).await;

        let r = buscar(
            &pool,
            &FiltrosBusca { decada: Some(1940), ..Default::default() },
            100,
        )
        .await
        .unwrap();

        assert_eq!(r.len(), 1);
        assert_eq!(r[0].nome, "Quarenta");
    }

    #[tokio::test]
    async fn a_decada_pega_as_pontas() {
        let pool = pool_de_teste().await;
        let inicio = pessoa(&pool, "Início", "X", false).await;
        let fim = pessoa(&pool, "Fim", "X", false).await;
        let fora = pessoa(&pool, "Fora", "X", false).await;
        nasceu(&pool, &inicio, 1940, None).await;
        nasceu(&pool, &fim, 1949, None).await;
        nasceu(&pool, &fora, 1950, None).await;

        let r = buscar(&pool, &FiltrosBusca { decada: Some(1940), ..Default::default() }, 100)
            .await
            .unwrap();
        assert_eq!(r.len(), 2, "1940 e 1949 entram, 1950 não");
    }

    /// O caso que a própria seção 7 dá como exemplo.
    #[tokio::test]
    async fn combina_decada_e_cidade() {
        let pool = pool_de_teste().await;
        let campos = um_municipio(&pool, "campos dos goytacazes").await;
        let outro = um_municipio(&pool, "macae").await;

        let certo = pessoa(&pool, "Certo", "Silva", false).await;
        let so_decada = pessoa(&pool, "Só década", "Silva", false).await;
        let so_cidade = pessoa(&pool, "Só cidade", "Silva", false).await;

        nasceu(&pool, &certo, 1945, Some(&campos)).await;
        nasceu(&pool, &so_decada, 1945, Some(&outro)).await;
        nasceu(&pool, &so_cidade, 1975, Some(&campos)).await;

        let r = buscar(
            &pool,
            &FiltrosBusca {
                decada: Some(1940),
                local_id: Some(campos),
                ..Default::default()
            },
            100,
        )
        .await
        .unwrap();

        assert_eq!(r.len(), 1, "só quem passa nos dois critérios");
        assert_eq!(r[0].nome, "Certo");
    }

    #[tokio::test]
    async fn filtra_por_religiao() {
        let pool = pool_de_teste().await;
        let a = pessoa(&pool, "Católica", "Silva", false).await;
        let b = pessoa(&pool, "Espírita", "Silva", false).await;
        religiao(&pool, &a, "Católica (Apostólica Romana)").await;
        religiao(&pool, &b, "Espírita (kardecista)").await;

        let r = buscar(
            &pool,
            &FiltrosBusca {
                religiao: Some("Espírita (kardecista)".into()),
                ..Default::default()
            },
            100,
        )
        .await
        .unwrap();

        assert_eq!(r.len(), 1);
        assert_eq!(r[0].nome, "Espírita");
    }

    #[tokio::test]
    async fn filtra_por_situacao_de_vida() {
        let pool = pool_de_teste().await;
        pessoa(&pool, "Viva", "Silva", true).await;
        pessoa(&pool, "Falecida", "Silva", false).await;

        let vivas = buscar(
            &pool,
            &FiltrosBusca { apenas_vivas: Some(true), ..Default::default() },
            100,
        )
        .await
        .unwrap();
        assert_eq!(vivas.len(), 1);
        assert_eq!(vivas[0].nome, "Viva");

        let falecidas = buscar(
            &pool,
            &FiltrosBusca { apenas_vivas: Some(false), ..Default::default() },
            100,
        )
        .await
        .unwrap();
        assert_eq!(falecidas.len(), 1);
        assert_eq!(falecidas[0].nome, "Falecida");
    }

    #[tokio::test]
    async fn o_texto_alcanca_os_outros_nomes() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Francisco", "", false).await;
        sqlx::query(
            "INSERT INTO nomes_pessoa (id,pessoa_id,tipo,nome,sobrenome,ordem)
             VALUES ('n1',?,'nascimento','Jorge Mario','Bergoglio',1)",
        )
        .bind(&p)
        .execute(&pool)
        .await
        .unwrap();

        let r = buscar(
            &pool,
            &FiltrosBusca { texto: Some("bergoglio".into()), ..Default::default() },
            100,
        )
        .await
        .unwrap();

        assert_eq!(r.len(), 1);
        assert_eq!(r[0].nome, "Francisco");
    }

    #[tokio::test]
    async fn filtros_se_acumulam_em_e_nao_em_ou() {
        let pool = pool_de_teste().await;
        let a = pessoa(&pool, "Ambos", "Silva", false).await;
        let b = pessoa(&pool, "Só um", "Costa", false).await;
        religiao(&pool, &a, "Católica").await;
        religiao(&pool, &b, "Católica").await;

        let r = buscar(
            &pool,
            &FiltrosBusca {
                sobrenome: Some("Silva".into()),
                religiao: Some("Católica".into()),
                ..Default::default()
            },
            100,
        )
        .await
        .unwrap();

        assert_eq!(r.len(), 1, "quem passa nos dois, não quem passa em algum");
        assert_eq!(r[0].nome, "Ambos");
    }

    #[tokio::test]
    async fn filtro_que_nao_acha_devolve_lista_vazia_sem_erro() {
        let pool = pool_de_teste().await;
        pessoa(&pool, "Ana", "Silva", false).await;

        let r = buscar(
            &pool,
            &FiltrosBusca { religiao: Some("Budista".into()), ..Default::default() },
            100,
        )
        .await
        .unwrap();

        assert!(r.is_empty());
    }

    #[tokio::test]
    async fn texto_com_aspas_nao_quebra_a_consulta() {
        // A consulta é montada dinamicamente; o teste existe para provar que
        // os valores vão por bind e não por interpolação.
        let pool = pool_de_teste().await;
        pessoa(&pool, "Ana", "d'Ávila", false).await;

        let r = buscar(
            &pool,
            &FiltrosBusca { texto: Some("' OR 1=1 --".into()), ..Default::default() },
            100,
        )
        .await
        .unwrap();

        assert!(r.is_empty(), "a injeção não pode devolver o acervo inteiro");

        let legitimo = buscar(
            &pool,
            &FiltrosBusca { texto: Some("d'Ávila".into()), ..Default::default() },
            100,
        )
        .await
        .unwrap();
        assert_eq!(legitimo.len(), 1, "apóstrofo legítimo tem de funcionar");
    }

    #[tokio::test]
    async fn normalizacao_de_texto_esta_disponivel_para_a_busca() {
        // Ainda não aplicada ao nome de pessoa (o acervo é pequeno e o LIKE
        // basta), mas a função é a mesma da busca de municípios.
        assert_eq!(normalizar_busca("  José  "), "jose");
    }
}
