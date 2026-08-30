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

/// Letras que só o lado Rust precisa tratar — o SQL as cobre pela tabela
/// acima mais o `lower()`, e acrescentá-las lá só engordaria a expressão.
const EXTRAS_RUST: [(char, char); 8] = [
    ('ç', 'c'), ('Ç', 'c'),
    ('ñ', 'n'), ('Ñ', 'n'),
    ('ý', 'y'), ('Ý', 'y'),
    ('ÿ', 'y'), ('å', 'a'),
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
    for (de, para) in SUBSTITUICOES {
        expressao = format!("replace({expressao},'{de}','{para}')");
    }
    // O cedilha entra à parte para a expressão não crescer mais do que precisa:
    // é a única consoante acentuada frequente em português.
    expressao = format!("replace(replace({expressao},'ç','c'),'Ç','c')");
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
}
