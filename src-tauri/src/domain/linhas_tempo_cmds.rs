//! Linhas do tempo — a gaveta (fatia 07, seção 8).
//!
//! Duas naturezas de linha convivem no mesmo eixo:
//!
//! - **Contexto**: pré-criadas, versionadas em migration, somente leitura. Não
//!   há nenhum comando aqui que as altere, e os gatilhos da migration 013
//!   recusam `UPDATE`/`DELETE` mesmo que alguém tente por baixo.
//! - **Pessoal**: derivada dos eventos da pessoa. **Não é tabela** — a seção 8
//!   já sugere que seja uma view, e duplicar eventos criaria duas verdades para
//!   o mesmo fato.

use serde::Serialize;
use sqlx::{Row, SqlitePool};
use tauri::State;

use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;

/// Quantas linhas de contexto podem ficar ativas ao mesmo tempo.
///
/// A seção 8 prevê configurar isto até 10; enquanto não houver tela de
/// configurações, fica constante. A vida da pessoa selecionada **não** ocupa
/// vaga — é o que faz a gaveta responder "o que aconteceu enquanto ele viveu"
/// em vez de só "o que aconteceu".
pub const LIMITE_DE_CAMADAS: usize = 3;

/// Até quantos anos se presume que alguém possa ter vivido, quando não há data
/// de falecimento.
///
/// Existe por causa de um caso que os testes pegaram: quem nasceu em 1930 e
/// está sem data de morte **estava vivo em 1930** — dizer o contrário é
/// absurdo. Mas a mesma pessoa não pode ser dada como viva em 2020.
///
/// O limite resolve os dois: dentro dele, presume-se vivo; fora, silêncio. É
/// generoso de propósito — errar incluindo alguém que morreu aos 80 é menos
/// grave do que apagar da tela quem estava lá.
const IDADE_MAXIMA_PRESUMIDA: i64 = 105;

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct LinhaDeContexto {
    pub id: String,
    pub categoria: String,
    pub titulo: String,
    pub fonte_referencia: Option<String>,
    /// Quantos marcos de alta relevância — os que a gaveta mostra.
    pub marcos_alta: i64,
    pub marcos_total: i64,
    pub ano_min: Option<i64>,
    pub ano_max: Option<i64>,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct Marco {
    pub id: String,
    pub linha_id: String,
    /// O texto original — "c. 1695", "1580–1640". É o que se lê no detalhe.
    pub data_periodo_texto: String,
    pub titulo: String,
    pub descricao: Option<String>,
    pub relevancia: Option<String>,
    pub fonte_especifica: Option<String>,
    pub ano_inicio: Option<i64>,
    pub ano_fim: Option<i64>,
}

#[derive(Debug, Serialize)]
pub struct MarcoPessoal {
    pub tipo: String,
    /// O que o usuário escreveu. O ano derivado só posiciona no eixo.
    pub data_texto: Option<String>,
    pub local: Option<String>,
    pub ano: Option<i64>,
}

#[derive(Debug, Serialize)]
pub struct LinhaPessoal {
    pub pessoa_id: String,
    pub nome: String,
    pub ano_nascimento: Option<i64>,
    pub ano_falecimento: Option<i64>,
    pub is_vivo: bool,
    pub marcos: Vec<MarcoPessoal>,
}

/// Resultado do destaque "quem estava vivo".
#[derive(Debug, Serialize, Default)]
pub struct QuemEstavaVivo {
    pub ids: Vec<String>,
    /// Quantas pessoas não puderam ser avaliadas por falta de ano de
    /// nascimento. A gaveta **diz** esse número em vez de calar: sumir em
    /// silêncio faria o usuário concluir que o antepassado não viveu naquela
    /// época, quando o programa apenas não sabe.
    pub sem_data_de_nascimento: i64,
}

/// As linhas de contexto disponíveis, com o que a gaveta precisa para
/// oferecê-las: quantos marcos tem cada uma e que período cobre.
#[tauri::command]
pub async fn listar_linhas_de_contexto(
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<LinhaDeContexto>> {
    Ok(sqlx::query_as::<_, LinhaDeContexto>(
        "SELECT l.id, l.categoria, l.titulo, l.fonte_referencia,
                COALESCE(SUM(e.relevancia = 'alta'), 0) AS marcos_alta,
                COUNT(e.id) AS marcos_total,
                MIN(e.ano_inicio) AS ano_min,
                MAX(COALESCE(e.ano_fim, e.ano_inicio)) AS ano_max
         FROM linhas_tempo l
         LEFT JOIN eventos_linha e ON e.linha_id = l.id
         WHERE l.is_contexto = 1
         GROUP BY l.id
         ORDER BY l.categoria, l.titulo",
    )
    .fetch_all(&*db)
    .await?)
}

/// Os marcos das linhas ativas dentro da janela visível.
///
/// Um marco entra quando **se sobrepõe** à janela, não quando cabe nela: um
/// intervalo que começa antes e termina depois do recorte é justamente o que
/// mais interessa — o Estado Novo visto de dentro de 1940.
#[tauri::command]
pub async fn buscar_marcos(
    linha_ids: Vec<String>,
    ano_de: Option<i64>,
    ano_ate: Option<i64>,
    apenas_alta: Option<bool>,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Marco>> {
    if linha_ids.is_empty() {
        return Ok(vec![]);
    }

    let marcadores = vec!["?"; linha_ids.len()].join(",");
    let so_alta = apenas_alta.unwrap_or(true);

    let mut sql = format!(
        "SELECT id, linha_id, data_periodo_texto, titulo, descricao, relevancia,
                fonte_especifica, ano_inicio, ano_fim
         FROM eventos_linha
         WHERE linha_id IN ({marcadores})"
    );

    if so_alta {
        sql.push_str(" AND relevancia = 'alta'");
    }
    // Sobreposição: fim >= janela_de E início <= janela_ate.
    if ano_de.is_some() {
        sql.push_str(" AND COALESCE(ano_fim, ano_inicio) >= ?");
    }
    if ano_ate.is_some() {
        sql.push_str(" AND ano_inicio <= ?");
    }
    sql.push_str(" ORDER BY ano_inicio, titulo");

    let mut q = sqlx::query_as::<_, Marco>(&sql);
    for id in &linha_ids {
        q = q.bind(id);
    }
    if let Some(de) = ano_de {
        q = q.bind(de);
    }
    if let Some(ate) = ano_ate {
        q = q.bind(ate);
    }

    Ok(q.fetch_all(&*db).await?)
}

/// A linha pessoal: a faixa da vida e os eventos sobre ela.
#[tauri::command]
pub async fn montar_linha_pessoal(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<LinhaPessoal> {
    let pessoa = sqlx::query("SELECT nome, sobrenome, is_vivo FROM pessoas WHERE id = ?")
        .bind(&pessoa_id)
        .fetch_optional(&*db)
        .await?
        .ok_or_else(|| {
            crate::domain::erros::ErroDominio::PessoaNaoEncontrada(pessoa_id.clone())
        })?;

    let nome: String = pessoa.try_get("nome")?;
    let sobrenome: Option<String> = pessoa.try_get("sobrenome")?;
    let is_vivo: bool = pessoa.try_get("is_vivo")?;

    let sql = format!(
        "SELECT e.tipo_evento, e.data_texto, e.ano_inicio,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || p.nome END) AS local
         FROM eventos e
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         WHERE e.pessoa_id = ?
         ORDER BY (e.ano_inicio IS NULL), e.ano_inicio"
    );

    let linhas = sqlx::query(&sql)
        .bind(&pessoa_id)
        .fetch_all(&*db)
        .await?;

    let mut marcos = Vec::with_capacity(linhas.len());
    let mut ano_nascimento = None;
    let mut ano_falecimento = None;

    for l in linhas {
        let tipo: String = l.try_get("tipo_evento")?;
        let ano: Option<i64> = l.try_get("ano_inicio")?;

        if tipo == tipos::NASCIMENTO && ano_nascimento.is_none() {
            ano_nascimento = ano;
        }
        if tipo == tipos::FALECIMENTO && ano_falecimento.is_none() {
            ano_falecimento = ano;
        }

        marcos.push(MarcoPessoal {
            tipo,
            data_texto: l.try_get("data_texto")?,
            local: l.try_get("local")?,
            ano,
        });
    }

    Ok(LinhaPessoal {
        pessoa_id,
        nome: match sobrenome {
            Some(s) if !s.trim().is_empty() => format!("{nome} {s}"),
            _ => nome,
        },
        ano_nascimento,
        ano_falecimento,
        is_vivo,
        marcos,
    })
}

/// Quem estava vivo no período — o destaque na árvore.
///
/// A regra, por extenso: a pessoa estava viva no ano `A` se **nasceu até `A`**
/// e uma das três vale:
///
/// 1. faleceu em `A` ou depois;
/// 2. não há ano de falecimento e ela está marcada como viva;
/// 3. não há ano de falecimento nenhum, mas `A` cai dentro de
///    [`IDADE_MAXIMA_PRESUMIDA`] anos do nascimento.
///
/// A terceira existe porque a regra sem ela era estrita demais: quem nasceu em
/// 1930 e não tem data de morte registrada estava vivo em 1930, e o programa
/// não pode fingir que não sabe disso.
///
/// Para um intervalo, basta ter estado viva em qualquer parte dele.
#[tauri::command]
pub async fn quem_estava_vivo(
    ano_inicio: i64,
    ano_fim: Option<i64>,
    db: State<'_, SqlitePool>,
) -> Resultado<QuemEstavaVivo> {
    let fim = ano_fim.unwrap_or(ano_inicio);

    let sql = format!(
        r#"
        WITH datas AS (
            SELECT p.id, p.is_vivo,
                   (SELECT e.ano_inicio FROM eventos e
                     WHERE e.pessoa_id = p.id AND e.tipo_evento = '{nasc}'
                     ORDER BY e.ano_inicio LIMIT 1) AS nasceu,
                   (SELECT e.ano_inicio FROM eventos e
                     WHERE e.pessoa_id = p.id AND e.tipo_evento = '{falec}'
                     ORDER BY e.ano_inicio LIMIT 1) AS faleceu
            FROM pessoas p
            WHERE p.is_placeholder = 0
        )
        SELECT id FROM datas
         WHERE nasceu IS NOT NULL
           AND nasceu <= ?2
           AND (
                faleceu >= ?1
                OR (faleceu IS NULL AND is_vivo = 1)
                OR (faleceu IS NULL AND ?1 <= nasceu + ?3)
               )
        "#,
        nasc = tipos::NASCIMENTO,
        falec = tipos::FALECIMENTO,
    );

    let ids: Vec<String> = sqlx::query_scalar(&sql)
        .bind(ano_inicio)
        .bind(fim)
        .bind(IDADE_MAXIMA_PRESUMIDA)
        .fetch_all(&*db)
        .await?;

    let sem_data: i64 = sqlx::query_scalar(&format!(
        "SELECT COUNT(*) FROM pessoas p
          WHERE p.is_placeholder = 0
            AND NOT EXISTS (SELECT 1 FROM eventos e
                             WHERE e.pessoa_id = p.id
                               AND e.tipo_evento = '{nasc}'
                               AND e.ano_inicio IS NOT NULL)",
        nasc = tipos::NASCIMENTO
    ))
    .fetch_one(&*db)
    .await?;

    Ok(QuemEstavaVivo {
        ids,
        sem_data_de_nascimento: sem_data,
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

    async fn pessoa(pool: &SqlitePool, nome: &str, vivo: bool) -> String {
        regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: None,
                sexo: "U".into(),
                minibiografia: None,
                is_vivo: vivo,
                foto_url: None,
            },
        )
        .await
        .unwrap()
    }

    async fn evento(pool: &SqlitePool, pessoa_id: &str, tipo: &str, texto: &str, ano: i64) {
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio)
             VALUES (?,?,?,?,'exata',?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(pessoa_id)
        .bind(tipo)
        .bind(texto)
        .bind(ano)
        .execute(pool)
        .await
        .unwrap();
    }

    // ---------- Conteúdo semeado ----------

    #[tokio::test]
    async fn as_quatro_linhas_de_contexto_estao_semeadas() {
        let pool = pool_de_teste().await;
        let linhas: Vec<String> =
            sqlx::query_scalar("SELECT titulo FROM linhas_tempo WHERE is_contexto = 1 ORDER BY id")
                .fetch_all(&pool)
                .await
                .unwrap();

        assert_eq!(linhas.len(), 4, "{linhas:?}");
        assert!(linhas.contains(&"História do Brasil".to_string()));
        assert!(linhas.contains(&"Presidentes da República".to_string()));
        assert!(linhas.contains(&"A moeda de cada época".to_string()));
        assert!(linhas.contains(&"Tecnologias de acesso público".to_string()));
    }

    #[tokio::test]
    async fn a_moeda_cobre_a_vida_toda_sem_buraco() {
        // Intervalos contíguos: o fim de um padrão é o começo do seguinte.
        // Um buraco aqui significaria uma época sem dinheiro, o que não houve.
        let pool = pool_de_teste().await;
        let periodos: Vec<(i64, i64)> = sqlx::query_as(
            "SELECT ano_inicio, ano_fim FROM eventos_linha
             WHERE linha_id = 'lt-moeda' ORDER BY ano_inicio",
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert!(periodos.len() >= 9);
        for par in periodos.windows(2) {
            let (_, fim_anterior) = par[0];
            let (inicio_seguinte, _) = par[1];
            assert_eq!(
                fim_anterior, inicio_seguinte,
                "buraco ou sobreposição entre {fim_anterior} e {inicio_seguinte}"
            );
        }
    }

    #[tokio::test]
    async fn marcos_incertos_ficam_fora_da_gaveta() {
        // A salvaguarda editorial: o que não foi conferido entra como 'media'
        // e não sobe à gaveta, que só mostra 'alta'.
        let pool = pool_de_teste().await;
        let media: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM eventos_linha WHERE linha_id='lt-tecnologia' AND relevancia='media'",
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert!(media > 0, "as tecnologias não conferidas deveriam estar em 'media'");
    }

    // ---------- Somente leitura ----------

    #[tokio::test]
    async fn o_banco_recusa_alterar_um_marco_de_contexto() {
        let pool = pool_de_teste().await;
        let r = sqlx::query("UPDATE eventos_linha SET titulo = 'adulterado' WHERE id = 'br-1888'")
            .execute(&pool)
            .await;
        assert!(r.is_err(), "o gatilho da migration 013 deveria ter recusado");
    }

    #[tokio::test]
    async fn o_banco_recusa_apagar_um_marco_de_contexto() {
        let pool = pool_de_teste().await;
        let r = sqlx::query("DELETE FROM eventos_linha WHERE id = 'br-1888'")
            .execute(&pool)
            .await;
        assert!(r.is_err());
    }

    #[tokio::test]
    async fn o_banco_recusa_apagar_a_propria_linha_de_contexto() {
        let pool = pool_de_teste().await;
        let r = sqlx::query("DELETE FROM linhas_tempo WHERE id = 'lt-brasil'")
            .execute(&pool)
            .await;
        assert!(r.is_err());
    }

    // ---------- Quem estava vivo ----------

    async fn vivos(pool: &SqlitePool, de: i64, ate: Option<i64>) -> QuemEstavaVivo {
        let fim = ate.unwrap_or(de);
        let sql = format!(
            r#"WITH datas AS (
                SELECT p.id, p.is_vivo,
                  (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id=p.id AND e.tipo_evento='{n}' ORDER BY e.ano_inicio LIMIT 1) AS nasceu,
                  (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id=p.id AND e.tipo_evento='{f}' ORDER BY e.ano_inicio LIMIT 1) AS faleceu
                FROM pessoas p WHERE p.is_placeholder = 0)
               SELECT id FROM datas
                WHERE nasceu IS NOT NULL AND nasceu <= ?2
                  AND (faleceu >= ?1
                       OR (faleceu IS NULL AND is_vivo = 1)
                       OR (faleceu IS NULL AND ?1 <= nasceu + ?3))"#,
            n = tipos::NASCIMENTO,
            f = tipos::FALECIMENTO
        );
        let ids: Vec<String> = sqlx::query_scalar(&sql)
            .bind(de)
            .bind(fim)
            .bind(IDADE_MAXIMA_PRESUMIDA)
            .fetch_all(pool)
            .await
            .unwrap();
        let sem: i64 = sqlx::query_scalar(&format!(
            "SELECT COUNT(*) FROM pessoas p WHERE p.is_placeholder=0
              AND NOT EXISTS (SELECT 1 FROM eventos e WHERE e.pessoa_id=p.id
                               AND e.tipo_evento='{n}' AND e.ano_inicio IS NOT NULL)",
            n = tipos::NASCIMENTO
        ))
        .fetch_one(pool)
        .await
        .unwrap();
        QuemEstavaVivo { ids, sem_data_de_nascimento: sem }
    }

    #[tokio::test]
    async fn quem_viveu_no_ano_e_destacado() {
        let pool = pool_de_teste().await;

        let bisavo = pessoa(&pool, "Bisavô", false).await;
        evento(&pool, &bisavo, tipos::NASCIMENTO, "1912", 1912).await;
        evento(&pool, &bisavo, tipos::FALECIMENTO, "1980", 1980).await;

        let tataravo = pessoa(&pool, "Tataravô", false).await;
        evento(&pool, &tataravo, tipos::NASCIMENTO, "1850", 1850).await;
        evento(&pool, &tataravo, tipos::FALECIMENTO, "1910", 1910).await;

        // Revolução de 30: o bisavô tinha 18 anos; o tataravô já morrera.
        let r = vivos(&pool, 1930, None).await;
        assert_eq!(r.ids, vec![bisavo.clone()]);

        // Em 1900 era o contrário.
        let r = vivos(&pool, 1900, None).await;
        assert_eq!(r.ids, vec![tataravo]);
    }

    #[tokio::test]
    async fn o_intervalo_pega_quem_viveu_em_qualquer_parte_dele() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Nasceu no meio", false).await;
        evento(&pool, &p, tipos::NASCIMENTO, "1943", 1943).await;
        evento(&pool, &p, tipos::FALECIMENTO, "2001", 2001).await;

        // Estado Novo, 1937–1945: ele nasceu em 1943, dentro do período.
        let r = vivos(&pool, 1937, Some(1945)).await;
        assert_eq!(r.ids, vec![p]);
    }

    #[tokio::test]
    async fn quem_esta_vivo_sem_data_de_morte_entra() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Viva", true).await;
        evento(&pool, &p, tipos::NASCIMENTO, "1990", 1990).await;

        let r = vivos(&pool, 2020, None).await;
        assert_eq!(r.ids, vec![p]);
    }

    #[tokio::test]
    async fn falecido_sem_ano_de_morte_nao_e_dado_como_vivo_um_seculo_depois() {
        // is_vivo = 0 e sem evento de falecimento: não dá para afirmar que
        // estava vivo em 2020, 120 anos depois de nascer. Melhor omitir.
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Falecido sem data", false).await;
        evento(&pool, &p, tipos::NASCIMENTO, "1900", 1900).await;

        let r = vivos(&pool, 2020, None).await;
        assert!(r.ids.is_empty(), "120 anos passa do limite presumido");
    }

    /// A regra que os testes corrigiram.
    ///
    /// A primeira versão exigia ano de falecimento ou `is_vivo`, e com isso
    /// apagava da tela quem nasceu em 1930 quando se clicava num marco de 1930.
    /// Dizer que essa pessoa não estava viva no ano em que nasceu é absurdo.
    #[tokio::test]
    async fn sem_data_de_morte_presume_se_vivo_dentro_de_uma_vida_plausivel() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Sem data de morte", false).await;
        evento(&pool, &p, tipos::NASCIMENTO, "1930", 1930).await;

        // No ano do próprio nascimento: obviamente vivo.
        assert_eq!(vivos(&pool, 1930, None).await.ids.len(), 1);
        // Aos 50: plausível.
        assert_eq!(vivos(&pool, 1980, None).await.ids.len(), 1);
        // Aos 106: passa do limite, e o programa se cala em vez de afirmar.
        assert!(vivos(&pool, 2036, None).await.ids.is_empty());
    }

    #[tokio::test]
    async fn antes_de_nascer_ninguem_esta_vivo() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisneto", true).await;
        evento(&pool, &p, tipos::NASCIMENTO, "1990", 1990).await;

        assert!(vivos(&pool, 1930, None).await.ids.is_empty());
    }

    #[tokio::test]
    async fn quem_nao_tem_nascimento_e_contado_e_nao_calado() {
        let pool = pool_de_teste().await;
        pessoa(&pool, "Sem data A", false).await;
        pessoa(&pool, "Sem data B", false).await;
        let com = pessoa(&pool, "Com data", false).await;
        evento(&pool, &com, tipos::NASCIMENTO, "1930", 1930).await;

        let r = vivos(&pool, 1930, None).await;
        assert_eq!(r.ids.len(), 1);
        assert_eq!(
            r.sem_data_de_nascimento, 2,
            "a gaveta precisa dizer quantos ficaram de fora"
        );
    }

    #[tokio::test]
    async fn placeholders_nunca_entram_no_destaque() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", false).await;
        evento(&pool, &mae, tipos::NASCIMENTO, "1900", 1900).await;
        regras::criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let r = vivos(&pool, 1920, None).await;
        assert_eq!(r.ids, vec![mae]);
        assert_eq!(r.sem_data_de_nascimento, 0, "o placeholder não conta nem como omitido");
    }

    // ---------- Janela e sobreposição ----------

    #[tokio::test]
    async fn intervalo_que_atravessa_a_janela_e_incluido() {
        // O Estado Novo (1937–1945) tem de aparecer numa janela de 1940–1941:
        // é justamente o contexto de quem viveu ali dentro.
        let pool = pool_de_teste().await;
        let achados: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM eventos_linha
              WHERE linha_id = 'lt-brasil' AND relevancia = 'alta'
                AND COALESCE(ano_fim, ano_inicio) >= 1940 AND ano_inicio <= 1941",
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert!(achados.contains(&"Estado Novo".to_string()), "{achados:?}");
    }

    #[tokio::test]
    async fn a_janela_recorta_o_que_esta_fora() {
        let pool = pool_de_teste().await;
        let achados: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM eventos_linha
              WHERE linha_id = 'lt-brasil'
                AND COALESCE(ano_fim, ano_inicio) >= 1900 AND ano_inicio <= 1950",
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert!(!achados.contains(&"Lei Áurea".to_string()), "1888 está fora da janela");
        assert!(achados.contains(&"Revolução de 1930".to_string()));
    }

    // ---------- Linha pessoal ----------

    #[tokio::test]
    async fn a_linha_pessoal_preserva_o_texto_da_data() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Bisavô", false).await;
        evento(&pool, &p, tipos::NASCIMENTO, "cerca de 1912", 1907).await;

        let linhas = sqlx::query(
            "SELECT tipo_evento, data_texto, ano_inicio FROM eventos WHERE pessoa_id = ?",
        )
        .bind(&p)
        .fetch_all(&pool)
        .await
        .unwrap();

        let texto: String = linhas[0].try_get("data_texto").unwrap();
        assert_eq!(texto, "cerca de 1912", "o eixo usa o ano, a tela usa o texto");
    }
}
