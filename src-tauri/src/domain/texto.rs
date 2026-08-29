//! Normalização de texto para busca.
//!
//! O `COLLATE NOCASE` do SQLite só conhece ASCII: para ele, "São" e "sao" são
//! palavras diferentes. Num país cujos topônimos são "São Paulo", "Goiás" e
//! "Paraíba", isso quebra qualquer autocomplete — e ninguém digita acento
//! quando está procurando.
//!
//! A solução é guardar uma versão sem acento ao lado do nome real e buscar
//! nela. Este módulo é a única definição dessa transformação; se ela divergir
//! entre a gravação e a consulta, a busca passa a errar em silêncio.

/// Minúsculas e sem acento, preservando o resto.
///
/// Cobre o que aparece em português e nas línguas de imigração mais comuns no
/// Brasil. Não é uma normalização Unicode completa de propósito: trazer uma
/// dependência para isso pesaria mais do que a tabela abaixo.
pub fn sem_acento(texto: &str) -> String {
    texto
        .chars()
        .map(|c| match c {
            'á' | 'à' | 'â' | 'ã' | 'ä' | 'å' | 'Á' | 'À' | 'Â' | 'Ã' | 'Ä' | 'Å' => 'a',
            'é' | 'è' | 'ê' | 'ë' | 'É' | 'È' | 'Ê' | 'Ë' => 'e',
            'í' | 'ì' | 'î' | 'ï' | 'Í' | 'Ì' | 'Î' | 'Ï' => 'i',
            'ó' | 'ò' | 'ô' | 'õ' | 'ö' | 'Ó' | 'Ò' | 'Ô' | 'Õ' | 'Ö' => 'o',
            'ú' | 'ù' | 'û' | 'ü' | 'Ú' | 'Ù' | 'Û' | 'Ü' => 'u',
            'ç' | 'Ç' => 'c',
            'ñ' | 'Ñ' => 'n',
            'ý' | 'ÿ' | 'Ý' => 'y',
            outro => outro.to_ascii_lowercase(),
        })
        .collect()
}

/// Sem acento e com os espaços colapsados. Para comparar o que o usuário
/// digitou com o que está guardado.
pub fn normalizar_busca(texto: &str) -> String {
    sem_acento(texto).split_whitespace().collect::<Vec<_>>().join(" ")
}

#[cfg(test)]
mod testes {
    use super::*;

    #[test]
    fn tira_acento_dos_toponimos_brasileiros() {
        assert_eq!(sem_acento("São Paulo"), "sao paulo");
        assert_eq!(sem_acento("Goiás"), "goias");
        assert_eq!(sem_acento("Paraíba"), "paraiba");
        assert_eq!(sem_acento("Ceará"), "ceara");
        assert_eq!(sem_acento("Açu"), "acu");
        assert_eq!(sem_acento("Itaocara"), "itaocara");
    }

    #[test]
    fn aguenta_nomes_de_imigracao() {
        assert_eq!(sem_acento("Nova Trento"), "nova trento");
        assert_eq!(sem_acento("Muñoz"), "munoz");
        assert_eq!(sem_acento("Köln"), "koln");
    }

    #[test]
    fn nao_estraga_o_que_ja_e_ascii() {
        assert_eq!(sem_acento("Campos dos Goytacazes"), "campos dos goytacazes");
        assert_eq!(sem_acento("Rio de Janeiro"), "rio de janeiro");
    }

    #[test]
    fn colapsa_espaco_na_busca() {
        assert_eq!(normalizar_busca("  São   Paulo "), "sao paulo");
        assert_eq!(normalizar_busca(""), "");
    }

    #[test]
    fn hifen_e_apostrofo_sobrevivem() {
        // "Santa Bárbara d'Oeste" e "Mogi-Guaçu" existem.
        assert_eq!(sem_acento("Santa Bárbara d'Oeste"), "santa barbara d'oeste");
        assert_eq!(sem_acento("Mogi-Guaçu"), "mogi-guacu");
    }

    /// O contrato que a migration 012 precisa cumprir no backfill.
    ///
    /// Se o SQL de lá deixar de bater com esta função, a busca por município
    /// começa a errar em silêncio: o Rust grava normalizado de um jeito e
    /// procura de outro.
    #[test]
    fn casos_que_a_migration_012_tambem_precisa_cobrir() {
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
