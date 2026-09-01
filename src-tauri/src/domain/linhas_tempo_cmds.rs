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
    /// Com quem, nos eventos que pertencem a uma união.
    ///
    /// Um casamento é evento de duas vidas, e sem isto a linha de quem teve
    /// dois casamentos mostraria duas marcas idênticas. Fica vazio quando o
    /// cônjuge é placeholder: "casou com [desconhecido]" não informa nada.
    pub com: Option<String>,
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
    linha_pessoal(&db, &pessoa_id).await
}

/// O miolo de [`montar_linha_pessoal`], sem o Tauri.
///
/// Separado pela mesma razão que `regras.rs`: recebendo `&SqlitePool` em vez de
/// `State`, dá para testá-lo inteiro contra um banco em memória. Duplicar estas
/// consultas dentro do teste seria pior do que não testar — o teste passaria a
/// medir uma consulta que não é a que roda.
pub async fn linha_pessoal(db: &SqlitePool, pessoa_id: &str) -> Resultado<LinhaPessoal> {
    let pessoa_id = pessoa_id.to_string();
    let pessoa = sqlx::query("SELECT nome, sobrenome, is_vivo FROM pessoas WHERE id = ?")
        .bind(&pessoa_id)
        .fetch_optional(db)
        .await?
        .ok_or_else(|| {
            crate::domain::erros::ErroDominio::PessoaNaoEncontrada(pessoa_id.clone())
        })?;

    let nome: String = pessoa.try_get("nome")?;
    let sobrenome: Option<String> = pessoa.try_get("sobrenome")?;
    let is_vivo: bool = pessoa.try_get("is_vivo")?;

    // Os eventos da própria pessoa.
    let proprios = sqlx::query(
        "SELECT e.tipo_evento, e.data_texto, e.ano_inicio,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || p.nome END) AS local
         FROM eventos e
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         WHERE e.pessoa_id = ?",
    )
    .bind(&pessoa_id)
    .fetch_all(db)
    .await?;

    let mut marcos = Vec::with_capacity(proprios.len());
    let mut ano_nascimento = None;
    let mut ano_falecimento = None;

    for l in proprios {
        let tipo: String = l.try_get("tipo_evento")?;
        let ano: Option<i64> = l.try_get("ano_inicio")?;

        // A faixa da vida sai só dos eventos próprios: nascer e morrer não são
        // eventos de união, e derivá-los de lá abriria caminho para uma barra
        // de vida montada a partir de um casamento.
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
            com: None,
        });
    }

    // Os eventos das uniões de que a pessoa participa.
    //
    // Um casamento é evento da união — `eventos` tem `pessoa_id` E `uniao_id`,
    // com CHECK exigindo um dos dois. Consultando só por `pessoa_id`, esta
    // função deixava o casamento fora da linha dos **dois** cônjuges: o dado
    // gravado e a tela calada.
    //
    // `OR` entre os slots, nunca `AND` — o mesmo engano já fez uma união
    // inteira sumir da busca quando um dos cônjuges ficava fora do recorte.
    let de_uniao = sqlx::query(
        "SELECT e.tipo_evento, e.data_texto, e.ano_inicio,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || pa.nome END) AS local,
                CASE
                  WHEN outro.is_placeholder = 1 THEN NULL
                  ELSE TRIM(outro.nome || ' ' || COALESCE(outro.sobrenome, ''))
                END AS com
         FROM eventos e
         JOIN unioes u ON u.id = e.uniao_id
         LEFT JOIN pessoas outro
                ON outro.id = CASE WHEN u.slot_masculino_id = ?1
                                   THEN u.slot_feminino_id
                                   ELSE u.slot_masculino_id END
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises pa ON pa.id = l.pais_id
         WHERE u.slot_masculino_id = ?1 OR u.slot_feminino_id = ?1",
    )
    .bind(&pessoa_id)
    .fetch_all(db)
    .await?;

    for l in de_uniao {
        marcos.push(MarcoPessoal {
            tipo: l.try_get("tipo_evento")?,
            data_texto: l.try_get("data_texto")?,
            local: l.try_get("local")?,
            ano: l.try_get("ano_inicio")?,
            com: l.try_get("com")?,
        });
    }

    // Ordenar depois de juntar as duas origens. Quem não tem ano vai para o
    // fim: no eixo não tem onde ficar, mas continua existindo na lista.
    marcos.sort_by(|a, b| (a.ano.is_none(), a.ano).cmp(&(b.ano.is_none(), b.ano)));

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
    async fn as_linhas_de_contexto_semeadas_sao_exatamente_estas() {
        let pool = pool_de_teste().await;
        let linhas: Vec<String> =
            sqlx::query_scalar("SELECT titulo FROM linhas_tempo WHERE is_contexto = 1 ORDER BY id")
                .fetch_all(&pool)
                .await
                .unwrap();

        const ESPERADAS: [&str; 5] = [
            "História do Brasil",
            "Presidentes da República",
            "A moeda de cada época",
            "Tecnologias de acesso público",
            "Este programa",
        ];

        for titulo in ESPERADAS {
            assert!(linhas.contains(&titulo.to_string()), "falta {titulo}: {linhas:?}");
        }
        // A contagem exata é o que pega migration semeando linha a mais sem
        // querer — e, quando a próxima entrar, obriga a atualizar esta lista.
        assert_eq!(linhas.len(), ESPERADAS.len(), "{linhas:?}");
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

    // ---------- Eventos de união na linha pessoal ----------
    //
    // Um casamento pertence à união, não a um dos cônjuges. Antes destes
    // testes, `montar_linha_pessoal` consultava só por `pessoa_id` e o
    // casamento não aparecia na linha de **nenhum** dos dois.

    async fn casal(pool: &SqlitePool) -> (String, String, String) {
        let ele = regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: "Antônio".into(),
                sobrenome: Some("Silva".into()),
                sexo: "M".into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
            },
        )
        .await
        .unwrap();
        let ela = regras::criar_pessoa(
            pool,
            NovaPessoa {
                nome: "Maria".into(),
                sobrenome: Some("Souza".into()),
                sexo: "F".into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
            },
        )
        .await
        .unwrap();
        let u = regras::criar_uniao(pool, Some(&ele), Some(&ela), "casamento")
            .await
            .unwrap();
        (ele, ela, u)
    }

    async fn casamento(pool: &SqlitePool, uniao_id: &str, texto: &str, ano: i64) {
        sqlx::query(
            "INSERT INTO eventos (id,uniao_id,tipo_evento,data_texto,data_qualificador,ano_inicio)
             VALUES (?,?,?,?,'exata',?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(uniao_id)
        .bind(tipos::CASAMENTO)
        .bind(texto)
        .bind(ano)
        .execute(pool)
        .await
        .unwrap();
    }

    #[tokio::test]
    async fn o_casamento_aparece_na_linha_dos_dois_conjuges() {
        let pool = pool_de_teste().await;
        let (ele, ela, u) = casal(&pool).await;
        casamento(&pool, &u, "12 de março de 1945", 1945).await;

        for pessoa_id in [&ele, &ela] {
            let linha = linha_pessoal(&pool, pessoa_id).await.unwrap();
            let m = linha
                .marcos
                .iter()
                .find(|m| m.tipo == tipos::CASAMENTO)
                .unwrap_or_else(|| panic!("casamento faltou na linha de {pessoa_id}"));
            assert_eq!(m.data_texto.as_deref(), Some("12 de março de 1945"));
            assert_eq!(m.ano, Some(1945));
        }
    }

    #[tokio::test]
    async fn cada_conjuge_ve_o_nome_do_outro() {
        let pool = pool_de_teste().await;
        let (ele, ela, u) = casal(&pool).await;
        casamento(&pool, &u, "1945", 1945).await;

        let dele = linha_pessoal(&pool, &ele).await.unwrap();
        let dela = linha_pessoal(&pool, &ela).await.unwrap();

        assert_eq!(dele.marcos[0].com.as_deref(), Some("Maria Souza"));
        assert_eq!(dela.marcos[0].com.as_deref(), Some("Antônio Silva"));
    }

    #[tokio::test]
    async fn conjuge_placeholder_nao_vira_nome() {
        // Slot sem nome recebe placeholder (invariante 2). "Casou com
        // desconhecido" não informa nada — melhor não dizer com quem.
        let pool = pool_de_teste().await;
        let ele = pessoa(&pool, "Antônio", false).await;
        sqlx::query("UPDATE pessoas SET sexo = 'M' WHERE id = ?")
            .bind(&ele)
            .execute(&pool)
            .await
            .unwrap();
        let u = regras::criar_uniao(&pool, Some(&ele), None, "casamento")
            .await
            .unwrap();
        casamento(&pool, &u, "1945", 1945).await;

        let linha = linha_pessoal(&pool, &ele).await.unwrap();
        assert_eq!(linha.marcos[0].tipo, tipos::CASAMENTO);
        assert_eq!(linha.marcos[0].com, None);
    }

    #[tokio::test]
    async fn o_casamento_nao_inventa_faixa_de_vida() {
        // A barra da vida sai de nascimento e falecimento. Se o casamento
        // pudesse alimentá-la, quem só tem casamento registrado ganharia uma
        // vida que começa no dia do casório.
        let pool = pool_de_teste().await;
        let (ele, _ela, u) = casal(&pool).await;
        casamento(&pool, &u, "1945", 1945).await;

        let linha = linha_pessoal(&pool, &ele).await.unwrap();
        assert_eq!(linha.ano_nascimento, None);
        assert_eq!(linha.ano_falecimento, None);
        assert_eq!(linha.marcos.len(), 1);
    }

    #[tokio::test]
    async fn as_duas_origens_saem_em_ordem_cronologica() {
        let pool = pool_de_teste().await;
        let (ele, _ela, u) = casal(&pool).await;
        evento(&pool, &ele, tipos::NASCIMENTO, "1920", 1920).await;
        evento(&pool, &ele, tipos::FALECIMENTO, "1990", 1990).await;
        casamento(&pool, &u, "1945", 1945).await;

        let linha = linha_pessoal(&pool, &ele).await.unwrap();
        let anos: Vec<Option<i64>> = linha.marcos.iter().map(|m| m.ano).collect();
        assert_eq!(anos, vec![Some(1920), Some(1945), Some(1990)]);
        assert_eq!(linha.marcos[1].tipo, tipos::CASAMENTO);
    }
}
