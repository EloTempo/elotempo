//! Testes da importação (fatia 09).
//!
//! Em arquivo próprio porque o de exportação já é grande, e porque o teste
//! central aqui atravessa os dois módulos: **exportar, reimportar num acervo
//! vazio e comparar**. A spec da fatia chama isso de "o teste que o exportador
//! entrega de graça", e é o mais forte que existe para os dois lados.

use sqlx::sqlite::SqlitePoolOptions;
use sqlx::{Row, SqlitePool};

use super::exportador::{montar, OpcoesExportacao};
use super::importador::{aplicar, analisar, data_do_gedcom, ler, Decisoes};
use crate::domain::datas;
use crate::domain::regras::{self, NovaPessoa};

async fn pool_de_teste() -> SqlitePool {
    let pool = SqlitePoolOptions::new()
        .max_connections(1)
        .connect("sqlite::memory:")
        .await
        .unwrap();
    sqlx::migrate!("./migrations").run(&pool).await.unwrap();
    pool
}

fn sem_decisoes() -> Decisoes {
    Decisoes(Default::default())
}

async fn importar(pool: &SqlitePool, texto: &str) -> super::importador::ResumoImportacao {
    let lido = ler(texto.as_bytes()).unwrap();
    aplicar(pool, &lido, &sem_decisoes()).await.unwrap()
}

/// Arquivo mínimo válido, com o cabeçalho que todo GEDCOM tem.
fn arquivo(corpo: &str) -> String {
    format!("0 HEAD\n1 GEDC\n2 VERS 7.0\n{corpo}\n0 TRLR\n")
}

// ---------------------------------------------------------------------------
// Datas
// ---------------------------------------------------------------------------

#[test]
fn le_a_data_completa_do_gedcom() {
    let d = data_do_gedcom("12 MAR 1945");
    assert_eq!(d.qualificador.as_deref(), Some("exata"));
    assert_eq!((d.dia, d.mes, d.ano), (Some(12), Some(3), Some(1945)));
    // E compõe de volta o texto em português, que é o que a tela mostra.
    assert_eq!(datas::compor_texto(&d), "12 de março de 1945");
}

#[test]
fn le_os_qualificadores() {
    assert_eq!(data_do_gedcom("ABT 1890").qualificador.as_deref(), Some("cerca_de"));
    assert_eq!(data_do_gedcom("BEF 1900").qualificador.as_deref(), Some("antes_de"));
    assert_eq!(data_do_gedcom("AFT 1900").qualificador.as_deref(), Some("apos"));

    let entre = data_do_gedcom("BET 1900 AND 1910");
    assert_eq!(entre.qualificador.as_deref(), Some("intervalo"));
    assert_eq!((entre.ano, entre.ano_fim), (Some(1900), Some(1910)));
}

#[test]
fn data_que_nao_se_entende_vira_texto_livre_inteiro() {
    // A seção 2.5 vale igual para dado importado: a data nunca bloqueia o
    // salvamento, e o que o outro programa escreveu não se perde.
    let d = data_do_gedcom("durante a guerra");
    assert_eq!(d.qualificador.as_deref(), Some("livre"));
    assert_eq!(d.texto_livre.as_deref(), Some("durante a guerra"));
}

#[test]
fn o_aproximado_nao_finge_saber_o_dia() {
    let d = data_do_gedcom("ABT 12 MAR 1890");
    assert_eq!(d.dia, None);
    assert_eq!(d.mes, None);
    assert_eq!(d.ano, Some(1890));
}

// ---------------------------------------------------------------------------
// Leitura
// ---------------------------------------------------------------------------

#[tokio::test]
async fn importa_pessoa_com_nome_sexo_e_datas() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME João /Silva/\n1 SEX M\n\
             1 BIRT\n2 DATE 12 MAR 1900\n2 PLAC Vila de São Salvador\n\
             1 DEAT\n2 DATE 1970",
        ),
    )
    .await;

    assert_eq!(r.pessoas, 1);
    assert_eq!(r.eventos, 2);

    let linha = sqlx::query("SELECT nome, sobrenome, sexo, is_vivo FROM pessoas")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(linha.get::<String, _>("nome"), "João");
    assert_eq!(linha.get::<String, _>("sobrenome"), "Silva");
    assert_eq!(linha.get::<String, _>("sexo"), "M");
    // Tem falecimento: não está viva, e o programa não precisa perguntar.
    assert!(!linha.get::<bool, _>("is_vivo"));

    let ev = sqlx::query(
        "SELECT data_texto, ano_inicio, dia_inicio, mes_inicio, rotulo_historico_livre
         FROM eventos WHERE tipo_evento = 'nascimento'",
    )
    .fetch_one(&pool)
    .await
    .unwrap();
    assert_eq!(ev.get::<String, _>("data_texto"), "12 de março de 1900");
    assert_eq!(ev.get::<i64, _>("ano_inicio"), 1900);
    assert_eq!(ev.get::<i64, _>("dia_inicio"), 12);
    assert_eq!(ev.get::<i64, _>("mes_inicio"), 3);
    // O PLAC do arquivo é rótulo histórico, não município: casá-lo com o IBGE
    // é mesclagem, que a fatia deixa de fora.
    assert_eq!(
        ev.get::<String, _>("rotulo_historico_livre"),
        "Vila de São Salvador"
    );
}

#[tokio::test]
async fn sexo_ausente_vira_u_e_nao_trava_nada() {
    let pool = pool_de_teste().await;
    importar(&pool, &arquivo("0 @I1@ INDI\n1 NAME Alguém //")).await;

    let sexo: String = sqlx::query_scalar("SELECT sexo FROM pessoas")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(sexo, "U", "U é o valor do desconhecido e cabe nos dois slots");
}

#[tokio::test]
async fn importa_familia_com_filhos() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Antônio /Silva/\n1 SEX M\n1 FAMS @F1@\n\
             0 @I2@ INDI\n1 NAME Maria /Souza/\n1 SEX F\n1 FAMS @F1@\n\
             0 @I3@ INDI\n1 NAME Pedro /Silva/\n1 SEX M\n1 FAMC @F1@\n\
             0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I2@\n1 CHIL @I3@\n\
             1 MARR\n2 DATE 12 MAR 1945",
        ),
    )
    .await;

    assert_eq!(r.pessoas, 3);
    assert_eq!(r.unioes, 1);
    assert_eq!(r.filhos, 1);
    assert_eq!(r.placeholders, 0);

    // O casamento ficou na união, e é o que o faz valer para os dois.
    let de_uniao: i64 =
        sqlx::query_scalar("SELECT COUNT(*) FROM eventos WHERE uniao_id IS NOT NULL")
            .fetch_one(&pool)
            .await
            .unwrap();
    assert_eq!(de_uniao, 1);
}

#[tokio::test]
async fn familia_com_um_lado_so_ganha_placeholder() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Maria /Souza/\n1 SEX F\n\
             0 @I2@ INDI\n1 NAME Pedro /Souza/\n1 SEX M\n1 FAMC @F1@\n\
             0 @F1@ FAM\n1 WIFE @I1@\n1 CHIL @I2@",
        ),
    )
    .await;

    assert_eq!(r.placeholders, 1, "o slot masculino nunca fica vazio");
    let ph: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE is_placeholder = 1")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(ph, 1);
}

#[tokio::test]
async fn le_apelidos_atributos_e_nomes_extras() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME João /Silva/\n2 NICK Joca\n\
             1 NAME Irmão /Boaventura/\n2 TYPE RELIGIOUS\n\
             1 SEX M\n1 RELI Católica\n1 OCCU Lavrador\n1 _LANG Italiano",
        ),
    )
    .await;

    assert_eq!(r.nomes, 1);
    let apelido: String = sqlx::query_scalar("SELECT apelido FROM apelidos_pessoa")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(apelido, "Joca");

    let idioma: String = sqlx::query_scalar("SELECT idioma FROM idiomas_pessoa")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(idioma, "Italiano");
}

#[tokio::test]
async fn nick_solto_sob_indi_e_aceito_na_leitura() {
    // Forma inválida no 7.0, que o exportador daqui não produz — mas arquivo
    // de terceiro produz. Tolerante ao ler, estrito ao escrever.
    let pool = pool_de_teste().await;
    importar(&pool, &arquivo("0 @I1@ INDI\n1 NAME Chica /Souza/\n1 NICK Tia Chica")).await;

    let apelido: String = sqlx::query_scalar("SELECT apelido FROM apelidos_pessoa")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(apelido, "Tia Chica");
}

// ---------------------------------------------------------------------------
// As invariantes contra arquivo hostil
// ---------------------------------------------------------------------------

#[test]
fn varios_famc_viram_pergunta() {
    let texto = arquivo(
        "0 @I1@ INDI\n1 NAME Filho /Silva/\n1 FAMC @F1@\n1 FAMC @F2@\n\
         0 @I2@ INDI\n1 NAME Antônio /Silva/\n1 SEX M\n\
         0 @I3@ INDI\n1 NAME José /Souza/\n1 SEX M\n\
         0 @F1@ FAM\n1 HUSB @I2@\n1 CHIL @I1@\n\
         0 @F2@ FAM\n1 HUSB @I3@\n1 CHIL @I1@",
    );
    let a = analisar(&ler(texto.as_bytes()).unwrap());
    let c = a.conflitos.iter().find(|c| c.tipo == "varios_famc").unwrap();
    assert_eq!(c.opcoes.len(), 2);
    assert!(c.titulo.contains("Filho Silva"), "{}", c.titulo);
}

#[tokio::test]
async fn varios_famc_gravam_uma_uniao_so_e_avisam_da_outra() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Filho /Silva/\n1 FAMC @F1@\n1 FAMC @F2@\n\
             0 @I2@ INDI\n1 NAME Antônio /Silva/\n1 SEX M\n\
             0 @I3@ INDI\n1 NAME José /Souza/\n1 SEX M\n\
             0 @F1@ FAM\n1 HUSB @I2@\n1 CHIL @I1@\n\
             0 @F2@ FAM\n1 HUSB @I3@\n1 CHIL @I1@",
        ),
    )
    .await;

    // Invariante 1: no máximo uma união como filho.
    assert_eq!(r.filhos, 1);
    let vinculos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM uniao_filhos")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(vinculos, 1);
    // Nada se perde em silêncio.
    assert!(r.descartados.iter().any(|d| d.contains("também constava")), "{:?}", r.descartados);
}

#[test]
fn familia_de_mesmo_sexo_vira_pergunta() {
    let texto = arquivo(
        "0 @I1@ INDI\n1 NAME Ana /Lima/\n1 SEX F\n\
         0 @I2@ INDI\n1 NAME Beatriz /Rocha/\n1 SEX F\n\
         0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I2@",
    );
    let a = analisar(&ler(texto.as_bytes()).unwrap());
    let c = a
        .conflitos
        .iter()
        .find(|c| c.tipo == "slot_incompativel")
        .expect("duas mulheres não cabem nos dois slots");
    // Sempre há a saída de descartar, e as de manter uma das duas.
    assert!(c.opcoes.iter().any(|o| o.valor == "descartar"));
    assert!(c.opcoes.len() >= 3, "{:?}", c.opcoes);
}

#[tokio::test]
async fn familia_de_mesmo_sexo_respeita_a_escolha() {
    let pool = pool_de_teste().await;
    let texto = arquivo(
        "0 @I1@ INDI\n1 NAME Ana /Lima/\n1 SEX F\n\
         0 @I2@ INDI\n1 NAME Beatriz /Rocha/\n1 SEX F\n\
         0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I2@",
    );
    let lido = ler(texto.as_bytes()).unwrap();

    let mut d = std::collections::HashMap::new();
    d.insert("slot:F1".to_string(), "descartar".to_string());
    let r = aplicar(&pool, &lido, &Decisoes(d)).await.unwrap();

    assert_eq!(r.unioes, 0);
    assert_eq!(r.pessoas, 2, "as pessoas entram mesmo sem a união");
    assert!(r.descartados.iter().any(|x| x.contains("descartada")));
}

#[tokio::test]
async fn lados_invertidos_sao_trocados_em_vez_de_descartados() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Maria /Souza/\n1 SEX F\n\
             0 @I2@ INDI\n1 NAME Antônio /Silva/\n1 SEX M\n\
             0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I2@",
        ),
    )
    .await;

    assert_eq!(r.unioes, 1);
    assert_eq!(r.placeholders, 0, "trocar resolve sem inventar desconhecido");

    let linha = sqlx::query(
        "SELECT pm.nome AS m, pf.nome AS f FROM unioes u
         JOIN pessoas pm ON pm.id = u.slot_masculino_id
         JOIN pessoas pf ON pf.id = u.slot_feminino_id",
    )
    .fetch_one(&pool)
    .await
    .unwrap();
    assert_eq!(linha.get::<String, _>("m"), "Antônio");
    assert_eq!(linha.get::<String, _>("f"), "Maria");
}

#[test]
fn ciclo_no_arquivo_vira_pergunta() {
    // I1 é filho de F1, cujo pai é I2; I2 é filho de F2, cujo pai é I1.
    let texto = arquivo(
        "0 @I1@ INDI\n1 NAME A /X/\n1 SEX M\n1 FAMC @F1@\n\
         0 @I2@ INDI\n1 NAME B /X/\n1 SEX M\n1 FAMC @F2@\n\
         0 @F1@ FAM\n1 HUSB @I2@\n1 CHIL @I1@\n\
         0 @F2@ FAM\n1 HUSB @I1@\n1 CHIL @I2@",
    );
    let a = analisar(&ler(texto.as_bytes()).unwrap());
    assert!(
        a.conflitos.iter().any(|c| c.tipo == "ciclo"),
        "{:?}",
        a.conflitos.iter().map(|c| &c.tipo).collect::<Vec<_>>()
    );
}

#[tokio::test]
async fn ciclo_no_arquivo_nao_entra_no_acervo() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME A /X/\n1 SEX M\n1 FAMC @F1@\n\
             0 @I2@ INDI\n1 NAME B /X/\n1 SEX M\n1 FAMC @F2@\n\
             0 @F1@ FAM\n1 HUSB @I2@\n1 CHIL @I1@\n\
             0 @F2@ FAM\n1 HUSB @I1@\n1 CHIL @I2@",
        ),
    )
    .await;

    // Invariante 4: pelo menos uma das ligações caiu, e o acervo ficou acíclico.
    assert!(r.filhos < 2, "as duas ligações não podem sobreviver juntas");
    for (filho, pai) in [("I1", "I2"), ("I2", "I1")] {
        let _ = (filho, pai);
    }
    assert!(!r.descartados.is_empty());
}

#[tokio::test]
async fn familia_sem_pais_ganha_dois_desconhecidos() {
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Órfão /Silva/\n1 SEX M\n1 FAMC @F1@\n\
             0 @F1@ FAM\n1 CHIL @I1@",
        ),
    )
    .await;

    assert_eq!(r.placeholders, 2);
    assert_eq!(r.unioes, 1);
    assert_eq!(r.filhos, 1);
}

#[tokio::test]
async fn familia_vazia_e_ignorada_com_aviso() {
    let texto = arquivo("0 @I1@ INDI\n1 NAME Só /Ele/\n0 @F1@ FAM");
    let a = analisar(&ler(texto.as_bytes()).unwrap());
    assert!(a.conflitos.is_empty());
    assert!(a.avisos.iter().any(|x| x.contains("ignorada")), "{:?}", a.avisos);
}

#[tokio::test]
async fn pedi_adotado_vira_vinculo_adotado() {
    let pool = pool_de_teste().await;
    importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME Pai /Silva/\n1 SEX M\n\
             0 @I2@ INDI\n1 NAME Filho /Silva/\n1 SEX M\n1 FAMC @F1@\n2 PEDI ADOPTED\n\
             0 @F1@ FAM\n1 HUSB @I1@\n1 CHIL @I2@",
        ),
    )
    .await;

    let vinculo: String = sqlx::query_scalar("SELECT tipo_vinculo FROM uniao_filhos")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(vinculo, "adotado");
}

#[tokio::test]
async fn arquivo_sem_pessoa_nenhuma_da_erro_em_vez_de_importar_vazio() {
    assert!(ler(arquivo("0 @F1@ FAM").as_bytes()).is_err());
}

#[tokio::test]
async fn a_mesma_pessoa_nos_dois_slots_nao_entra() {
    // Arquivo que aponta o mesmo indivíduo como marido e esposa. O sexo dele
    // não cabe nos dois slots, então o conflito resolve mantendo-o de um lado
    // e criando um desconhecido do outro — nunca ele duas vezes.
    let pool = pool_de_teste().await;
    let r = importar(
        &pool,
        &arquivo(
            "0 @I1@ INDI\n1 NAME A /X/\n1 SEX M\n\
             0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I1@",
        ),
    )
    .await;

    assert_eq!(r.unioes, 1);
    assert_eq!(r.placeholders, 1);
    let iguais: i64 =
        sqlx::query_scalar("SELECT COUNT(*) FROM unioes WHERE slot_masculino_id = slot_feminino_id")
            .fetch_one(&pool)
            .await
            .unwrap();
    assert_eq!(iguais, 0);
}

#[tokio::test]
async fn falha_no_meio_nao_deixa_acervo_pela_metade() {
    // "A importação nunca escreve fora de transação. Um acervo pela metade, com
    // metade das ligações, é pior do que nenhuma importação." (spec, seção 5)
    //
    // A falha é forçada por gatilho: as pessoas entram primeiro, a união depois.
    // Se a transação não existisse, as pessoas ficariam no acervo sem a família
    // que as liga — exatamente o meio acervo que a regra proíbe.
    let pool = pool_de_teste().await;
    sqlx::query(
        "CREATE TRIGGER falha_simulada BEFORE INSERT ON unioes
         BEGIN SELECT RAISE(ABORT, 'falha simulada'); END",
    )
    .execute(&pool)
    .await
    .unwrap();

    let texto = arquivo(
        "0 @I1@ INDI\n1 NAME A /X/\n1 SEX M\n\
         0 @I2@ INDI\n1 NAME B /Y/\n1 SEX F\n\
         0 @F1@ FAM\n1 HUSB @I1@\n1 WIFE @I2@",
    );
    let lido = ler(texto.as_bytes()).unwrap();
    assert!(aplicar(&pool, &lido, &sem_decisoes()).await.is_err());

    let pessoas: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(pessoas, 0, "as pessoas já inseridas tinham de sair junto");
}

// ---------------------------------------------------------------------------
// Ida e volta — o teste que a spec chama de mais forte
// ---------------------------------------------------------------------------

#[tokio::test]
async fn exportar_e_reimportar_devolve_a_mesma_arvore() {
    let origem = pool_de_teste().await;

    let avo = regras::criar_pessoa(
        &origem,
        NovaPessoa {
            nome: "Antônio".into(),
            sobrenome: Some("Gonçalves".into()),
            sexo: "M".into(),
            minibiografia: None,
            is_vivo: false,
            foto_url: None,
        },
    )
    .await
    .unwrap();
    let ava = regras::criar_pessoa(
        &origem,
        NovaPessoa {
            nome: "Conceição".into(),
            sobrenome: Some("Souza".into()),
            sexo: "F".into(),
            minibiografia: None,
            is_vivo: false,
            foto_url: None,
        },
    )
    .await
    .unwrap();
    let filho = regras::criar_pessoa(
        &origem,
        NovaPessoa {
            nome: "José".into(),
            sobrenome: Some("Souza Gonçalves".into()),
            sexo: "M".into(),
            minibiografia: None,
            is_vivo: false,
            foto_url: None,
        },
    )
    .await
    .unwrap();

    let uniao = regras::criar_uniao(&origem, Some(&avo), Some(&ava), "casamento")
        .await
        .unwrap();
    regras::anexar_filho(&origem, &uniao, &filho, "biologico")
        .await
        .unwrap();

    for (pessoa, tipo, texto, ano, dia, mes) in [
        (&avo, "nascimento", "12 de março de 1900", 1900, Some(12), Some(3)),
        (&avo, "falecimento", "1970", 1970, None, None),
        (&filho, "nascimento", "1930", 1930, None, None),
    ] {
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,
                                  ano_inicio,dia_inicio,mes_inicio)
             VALUES (?,?,?,?,'exata',?,?,?)",
        )
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(pessoa)
        .bind(tipo)
        .bind(texto)
        .bind(ano)
        .bind(dia)
        .bind(mes)
        .execute(&origem)
        .await
        .unwrap();
    }

    sqlx::query("INSERT INTO religioes_pessoa (id,pessoa_id,denominacao) VALUES (?,?,'Católica')")
        .bind(uuid::Uuid::new_v4().to_string())
        .bind(&avo)
        .execute(&origem)
        .await
        .unwrap();

    // ---- exporta ----
    let exportado = montar(&origem, &OpcoesExportacao::default()).await.unwrap();

    // ---- reimporta num acervo vazio ----
    let destino = pool_de_teste().await;
    let lido = ler(exportado.texto.as_bytes()).unwrap();
    let analise = analisar(&lido);
    assert!(
        analise.conflitos.is_empty(),
        "o que este programa exporta não pode gerar conflito ao voltar: {:?}",
        analise.conflitos.iter().map(|c| &c.titulo).collect::<Vec<_>>()
    );

    let r = aplicar(&destino, &lido, &sem_decisoes()).await.unwrap();
    assert_eq!(r.pessoas, 3);
    assert_eq!(r.unioes, 1);
    assert_eq!(r.filhos, 1);

    // ---- compara ----
    let nomes = |pool: SqlitePool| async move {
        let v: Vec<String> = sqlx::query_scalar(
            "SELECT nome || ' ' || COALESCE(sobrenome,'') FROM pessoas
             WHERE is_placeholder = 0 ORDER BY nome",
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        v
    };
    assert_eq!(nomes(origem.clone()).await, nomes(destino.clone()).await);

    // O acento sobreviveu à ida e à volta — é o que mais quebra em GEDCOM.
    let lista = nomes(destino.clone()).await;
    assert!(lista.iter().any(|n| n.contains("Conceição")), "{lista:?}");
    assert!(lista.iter().any(|n| n.contains("Gonçalves")), "{lista:?}");

    // A data completa não virou só o ano.
    let ev = sqlx::query(
        "SELECT data_texto, dia_inicio, mes_inicio, ano_inicio FROM eventos
         WHERE tipo_evento = 'nascimento' AND ano_inicio = 1900",
    )
    .fetch_one(&destino)
    .await
    .unwrap();
    assert_eq!(ev.get::<String, _>("data_texto"), "12 de março de 1900");
    assert_eq!(ev.get::<i64, _>("dia_inicio"), 12);
    assert_eq!(ev.get::<i64, _>("mes_inicio"), 3);

    // A filiação voltou ligada à união, não a um dos pais.
    let filiacoes: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id",
    )
    .fetch_one(&destino)
    .await
    .unwrap();
    assert_eq!(filiacoes, 1);

    let religiao: String = sqlx::query_scalar("SELECT denominacao FROM religioes_pessoa")
        .fetch_one(&destino)
        .await
        .unwrap();
    assert_eq!(religiao, "Católica");
}

#[tokio::test]
async fn ida_e_volta_preserva_o_placeholder_como_lado_desconhecido() {
    let origem = pool_de_teste().await;
    let mae = regras::criar_pessoa(
        &origem,
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
    let filho = regras::criar_pessoa(
        &origem,
        NovaPessoa {
            nome: "Pedro".into(),
            sobrenome: Some("Souza".into()),
            sexo: "M".into(),
            minibiografia: None,
            is_vivo: true,
            foto_url: None,
        },
    )
    .await
    .unwrap();
    let uniao = regras::criar_uniao(&origem, None, Some(&mae), "casamento")
        .await
        .unwrap();
    regras::anexar_filho(&origem, &uniao, &filho, "biologico")
        .await
        .unwrap();

    let exportado = montar(&origem, &OpcoesExportacao::default()).await.unwrap();
    // O placeholder não vira INDI — a FAM sai com um lado só.
    assert!(!exportado.texto.contains("Desconhecido"));

    let destino = pool_de_teste().await;
    let lido = ler(exportado.texto.as_bytes()).unwrap();
    let r = aplicar(&destino, &lido, &sem_decisoes()).await.unwrap();

    // E na volta o slot é preenchido de novo, como manda a invariante 2.
    assert_eq!(r.pessoas, 2);
    assert_eq!(r.placeholders, 1);
    assert_eq!(r.filhos, 1);
}
