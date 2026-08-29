-- 012 — Busca de município sem acento (fatia 04).
--
-- O `COLLATE NOCASE` do SQLite só conhece ASCII: para ele "São" e "sao" são
-- palavras diferentes. Num país de "São Paulo", "Goiás" e "Três Corações",
-- isso quebra o autocomplete exatamente nos nomes que mais importam — e
-- ninguém digita acento quando está procurando.
--
-- A coluna abaixo guarda o nome sem acento, em minúsculas, só para busca. O
-- `nome` continua sendo o que se exibe, com a grafia correta.
--
-- O preenchimento é feito aqui, com REPLACE encadeado, e não regerando o seed:
-- os 5.571 municípios já estão versionados na migration 009, e regerar exigiria
-- rede. Verboso, porém offline — que é o critério que vale neste projeto.
--
-- A transformação precisa bater exatamente com `domain::texto::sem_acento`.
-- Se divergirem, o Rust grava normalizado de um jeito e procura de outro, e a
-- busca passa a errar em silêncio. O teste
-- `casos_que_a_migration_012_tambem_precisa_cobrir` existe para prender as
-- duas pontas.

ALTER TABLE locais ADD COLUMN nome_busca TEXT;

UPDATE locais SET nome_busca =
  replace(replace(replace(replace(replace(replace(replace(replace(
  replace(replace(replace(replace(replace(replace(replace(replace(
  replace(replace(replace(replace(replace(replace(replace(replace(
    lower(nome),
    'á','a'),'à','a'),'â','a'),'ã','a'),'ä','a'),'å','a'),
    'é','e'),'è','e'),'ê','e'),'ë','e'),
    'í','i'),'ì','i'),'î','i'),'ï','i'),
    'ó','o'),'ò','o'),'ô','o'),'õ','o'),'ö','o'),
    'ú','u'),'ù','u'),'û','u'),'ü','u'),
    'ç','c');

-- Prefixo (`LIKE 'campos%'`) usa este índice; `LIKE '%campos%'` não usa, mas
-- 5.571 linhas cabem num scan em microssegundos.
CREATE INDEX ix_locais_nome_busca ON locais (nome_busca);

-- Uma cidade estrangeira é identificada pelo par nome + país: evita que
-- "Lisboa" vire três lugares diferentes por ter sido digitada três vezes.
-- Índice parcial porque os municípios brasileiros já são únicos pelo IBGE.
CREATE UNIQUE INDEX ix_locais_estrangeiro_unico
    ON locais (pais_id, nome_busca)
    WHERE codigo_ibge IS NULL;
