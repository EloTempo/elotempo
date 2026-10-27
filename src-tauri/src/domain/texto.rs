//! Normalização de texto para busca.
//!
//! O `COLLATE NOCASE` do SQLite só conhece ASCII: para ele, "José" e "jose" são
//! palavras diferentes, e o `lower()` embutido também não mexe em letra
//! acentuada. Num país de Josés, Gonçalves e Conceições, isso quebra qualquer
//! busca por nome — e ninguém digita acento quando está procurando.
//!
//! Este módulo é a **única** definição dessa transformação, dos dois lados:
//! a função Rust normaliza o que o usuário digitou, e [`sem_acento_sql`] gera
//! a expressão SQL que normaliza a coluna. As duas saem da mesma tabela
//! [`SUBSTITUICOES`], então não têm como divergir — e divergir aqui faria a
//! busca errar em silêncio.

/// Letra acentuada e sua correspondente sem acento.
///
/// As maiúsculas precisam estar na tabela porque o `lower()` do SQLite não as
/// alcança: `lower('JOSÉ')` devolve `josÉ`, com o É intacto.
///
/// Cobre o português inteiro e as letras que aparecem nos nomes de imigração
/// mais comuns no Brasil.
const SUBSTITUICOES: [(char, char); 34] = [
    ('á', 'a'), ('Á', 'a'), ('à', 'a'), ('À', 'a'),
    ('â', 'a'), ('Â', 'a'), ('ã', 'a'), ('Ã', 'a'),
    ('ä', 'a'), ('Ä', 'a'),
    ('é', 'e'), ('É', 'e'), ('è', 'e'), ('È', 'e'),
    ('ê', 'e'), ('Ê', 'e'), ('ë', 'e'), ('Ë', 'e'),
    ('í', 'i'), ('Í', 'i'), ('î', 'i'), ('Î', 'i'),
    ('ó', 'o'), ('Ó', 'o'), ('ô', 'o'), ('Ô', 'o'),
    ('õ', 'o'), ('Õ', 'o'), ('ö', 'o'), ('Ö', 'o'),
    ('ú', 'u'), ('Ú', 'u'), ('ü', 'u'), ('Ü', 'u'),
];

/// Letras fora do português que aparecem em nomes de imigração.
///
/// **Esta tabela alimenta os DOIS lados**, como a de cima. O comentário
/// anterior dizia que só o Rust precisava dela, porque "o SQL as cobre pelo
/// `lower()`" — o que é falso: `lower()` não transforma `č` em `c`. Enquanto
/// o termo digitado era normalizado por aqui e a coluna não, buscar "Čapek"
/// deixava de achar "Čapek". Nomes assim funcionavam ANTES de a tabela
/// crescer, porque os dois lados deixavam o caractere intacto.
///
/// Acrescentar aqui engorda a expressão SQL da busca. É o preço de as duas
/// pontas não divergirem — e divergir em silêncio é pior do que ser lento.
const EXTRAS_RUST: &[(char, char)] = &[
    ('ç', 'c'), ('Ç', 'c'),
    ('ñ', 'n'), ('Ñ', 'n'),
    ('ý', 'y'), ('Ý', 'y'),
    ('ÿ', 'y'), ('å', 'a'), ('Å', 'a'),
    ('ā', 'a'), ('Ā', 'a'),
    ('ē', 'e'), ('Ē', 'e'),
    ('ī', 'i'), ('Ī', 'i'),
    ('ō', 'o'), ('Ō', 'o'),
    ('ū', 'u'), ('Ū', 'u'),
    ('š', 's'), ('Š', 's'),
    ('č', 'c'), ('Č', 'c'),
    ('ć', 'c'), ('Ć', 'c'),
    ('ř', 'r'), ('Ř', 'r'),
    ('ž', 'z'), ('Ž', 'z'),
    ('ł', 'l'), ('Ł', 'l'),
    ('ø', 'o'), ('Ø', 'o'),
];

/// Minúsculas e sem acento, preservando o resto.
pub fn sem_acento(texto: &str) -> String {
    texto
        .chars()
        .map(|c| {
            SUBSTITUICOES
                .iter()
                .chain(EXTRAS_RUST.iter())
                .find(|(de, _)| *de == c)
                .map(|(_, para)| *para)
                .unwrap_or_else(|| c.to_ascii_lowercase())
        })
        .collect()
}

/// Sem acento e com os espaços colapsados. Para comparar o que o usuário
/// digitou com o que está guardado.
pub fn normalizar_busca(texto: &str) -> String {
    sem_acento(texto).split_whitespace().collect::<Vec<_>>().join(" ")
}

/// Gera a expressão SQL que normaliza uma coluna para comparação.
///
/// Devolve algo como `replace(replace(lower(p.nome),'á','a'),'Á','a')…`, que se
/// encaixa num `WHERE … LIKE ?`. É verboso, mas é **gerado**, não escrito à
/// mão, e sai da mesma tabela que a função Rust — que é o que garante que os
/// dois lados concordem.
///
/// `coluna` vem sempre de constante do próprio código, nunca do usuário.
///
/// Custa uma varredura, sem índice. Num acervo familiar — centenas a poucos
/// milhares de pessoas — isso é imperceptível, e evita uma coluna
/// desnormalizada que precisaria ser mantida em sincronia a cada escrita.
/// A tabela de municípios, que tem 5.571 linhas, usa coluna própria justamente
/// por ser fixa e grande; nomes de pessoa mudam o tempo todo.
pub fn sem_acento_sql(coluna: &str) -> String {
    let mut expressao = format!("lower({coluna})");
    // As duas tabelas, na mesma ordem que `sem_acento` usa. O cedilha já está
    // em EXTRAS_RUST e por isso saiu do caso especial que havia aqui.
    for (de, para) in SUBSTITUICOES.iter().chain(EXTRAS_RUST.iter()) {
        expressao = format!("replace({expressao},'{de}','{para}')");
    }
    expressao
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn tira_acento_dos_nomes_brasileiros() {
        assert_eq!(sem_acento("José"), "jose");
        assert_eq!(sem_acento("Gonçalves"), "goncalves");
        assert_eq!(sem_acento("Conceição"), "conceicao");
        assert_eq!(sem_acento("Antônio"), "antonio");
        assert_eq!(sem_acento("Inácio"), "inacio");
    }

    #[test]
    fn tira_acento_dos_toponimos() {
        assert_eq!(sem_acento("São Paulo"), "sao paulo");
        assert_eq!(sem_acento("Goiás"), "goias");
        assert_eq!(sem_acento("Três Corações"), "tres coracoes");
    }

    #[test]
    fn aguenta_maiusculas_acentuadas() {
        // O `lower()` do SQLite não alcança estas, por isso elas estão na
        // tabela de substituições.
        assert_eq!(sem_acento("JOSÉ"), "jose");
        assert_eq!(sem_acento("ÁVILA"), "avila");
        assert_eq!(sem_acento("Ângela"), "angela");
    }

    #[test]
    fn aguenta_nomes_de_imigracao() {
        assert_eq!(sem_acento("Muñoz"), "munoz");
        assert_eq!(sem_acento("Köln"), "koln");
        assert_eq!(sem_acento("Müller"), "muller");
    }

    #[test]
    fn nao_estraga_o_que_ja_e_ascii() {
        assert_eq!(sem_acento("Campos dos Goytacazes"), "campos dos goytacazes");
        assert_eq!(sem_acento("Silva"), "silva");
    }

    #[test]
    fn hifen_e_apostrofo_sobrevivem() {
        assert_eq!(sem_acento("Santa Bárbara d'Oeste"), "santa barbara d'oeste");
        assert_eq!(sem_acento("Mogi-Guaçu"), "mogi-guacu");
    }

    #[test]
    fn colapsa_espaco_na_busca() {
        assert_eq!(normalizar_busca("  São   Paulo "), "sao paulo");
        assert_eq!(normalizar_busca(""), "");
    }

    #[test]
    fn a_expressao_sql_e_montada_a_partir_da_mesma_tabela() {
        let sql = sem_acento_sql("p.nome");
        assert!(sql.starts_with("replace("));
        assert!(sql.contains("lower(p.nome)"));
        // Se uma substituição sumir da tabela, some da expressão também.
        for (de, para) in SUBSTITUICOES {
            assert!(
                sql.contains(&format!("'{de}','{para}'")),
                "a expressão perdeu {de} -> {para}"
            );
        }
        assert!(sql.contains("'ç','c'"), "o cedilha precisa estar lá");
    }

    /// Os casos que a migration 012 preencheu em `locais.nome_busca`.
    #[test]
    fn continua_compativel_com_o_seed_de_municipios() {
        for (entrada, esperado) in [
            ("São Paulo", "sao paulo"),
            ("Brasília", "brasilia"),
            ("Vitória", "vitoria"),
            ("Açailândia", "acailandia"),
            ("Poções", "pocoes"),
            ("Piraí", "pirai"),
            ("Três Corações", "tres coracoes"),
        ] {
            assert_eq!(sem_acento(entrada), esperado, "falhou em {entrada}");
        }
    }

    /// As duas pontas da busca normalizam igual — conferido rodando o SQL.
    ///
    /// A busca compara o TERMO, normalizado por `normalizar_busca` (Rust), com
    /// a COLUNA, normalizada por `sem_acento_sql` (SQLite). Se as duas tabelas
    /// divergirem, a busca erra em silêncio: o usuário digita o nome certo e
    /// não acha ninguém. Foi o que aconteceu quando `EXTRAS_RUST` cresceu e só
    /// o lado Rust passou a usar os caracteres novos.
    ///
    /// Este teste não emula o SQL: ele executa a expressão no SQLite e compara
    /// com a função Rust, caractere por caractere das duas tabelas.
    #[tokio::test]
    async fn o_termo_e_a_coluna_normalizam_igual() {
        use sqlx::sqlite::SqlitePoolOptions;
        use sqlx::Row;

        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");

        let mut amostras: Vec<String> = vec![
            "José".into(), "Conceição".into(), "Gonçalves".into(),
            "Čapek".into(), "Miloš".into(), "Jiří".into(),
            "Åke".into(), "Ōtomo".into(), "Łukasz".into(), "Ørsted".into(),
            "Muñoz".into(), "Dvořák".into(),
        ];
        // E cada caractere das duas tabelas, isolado, para nenhum escapar.
        for (de, _) in SUBSTITUICOES.iter().chain(EXTRAS_RUST.iter()) {
            amostras.push(format!("x{de}x"));
        }

        for amostra in &amostras {
            let expr = sem_acento_sql("?");
            let do_sql: String = sqlx::query(&format!("SELECT {expr} AS v"))
                .bind(amostra)
                .fetch_one(&pool)
                .await
                .expect("consulta")
                .get("v");
            let do_rust = normalizar_busca(amostra);
            assert_eq!(
                do_rust, do_sql,
                "'{amostra}': o Rust normaliza para '{do_rust}' e o SQL para '{do_sql}'.                  Caractere novo precisa entrar numa das tabelas que alimentam os DOIS lados."
            );
        }
    }
}
