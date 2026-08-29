-- 007 — Datas ordenáveis, fontes/citações e duas correções de modelagem.
--
-- Três problemas que ficam baratos agora e caros depois de existirem acervos
-- reais lá fora.

-- =====================================================================
-- 1. DATAS: qualificador + faixa de anos ordenável
-- =====================================================================
-- `data_texto` guarda o que o usuário escreveu, e continua sendo a verdade
-- exibida na tela ("cerca de 1890", "entre 1902 e 1904", "12/03/1945").
--
-- Mas texto livre não ordena e não plota. O relatório da seção 6 exige
-- "data de nascimento ascendente" e a linha do tempo da seção 8 exige um eixo
-- numérico. Daí o par ano_inicio/ano_fim: a faixa que aquele texto cobre,
-- derivada no momento de gravar.
--
--   "1945"            -> qualificador=exata,   ano_inicio=1945, ano_fim=1945
--   "cerca de 1890"   -> qualificador=cerca_de, ano_inicio=1885, ano_fim=1895
--   "antes de 1900"   -> qualificador=antes_de, ano_inicio=NULL, ano_fim=1900
--   "1902-1904"       -> qualificador=intervalo, ano_inicio=1902, ano_fim=1904
--   "" (sem data)     -> qualificador=desconhecida, ambos NULL
--
-- Eventos sem data continuam válidos: a regra transversal da seção 2.5 diz que
-- a data nunca é obrigatória para salvar.
ALTER TABLE eventos ADD COLUMN data_qualificador TEXT NOT NULL DEFAULT 'desconhecida'
    CHECK (data_qualificador IN ('exata','cerca_de','antes_de','apos','intervalo','desconhecida'));
ALTER TABLE eventos ADD COLUMN ano_inicio INTEGER;
ALTER TABLE eventos ADD COLUMN ano_fim    INTEGER;

-- Batismo carrega opcionalmente a própria denominação e igreja (seção 2.3).
ALTER TABLE eventos ADD COLUMN denominacao_religiosa TEXT;
ALTER TABLE eventos ADD COLUMN instituicao TEXT;

-- Ordenação cronológica de relatório e varredura da linha do tempo.
CREATE INDEX ix_eventos_ano_inicio ON eventos (ano_inicio);
CREATE INDEX ix_eventos_tipo_ano   ON eventos (tipo_evento, ano_inicio);

-- Mesmo tratamento para os eventos de contexto: o eixo da linha do tempo
-- precisa de número, não de texto.
ALTER TABLE eventos_linha ADD COLUMN ano_inicio INTEGER;
ALTER TABLE eventos_linha ADD COLUMN ano_fim    INTEGER;
CREATE INDEX ix_eventos_linha_ano ON eventos_linha (ano_inicio);

-- =====================================================================
-- 2. FONTES E CITAÇÕES (seção 2.7 — "preparar cedo, preencher depois")
-- =====================================================================
CREATE TABLE fontes (
    id TEXT PRIMARY KEY,
    titulo TEXT NOT NULL,
    tipo TEXT CHECK (tipo IN (
        'certidao','censo','registro_paroquial','jornal','livro',
        'lapide','entrevista','correspondencia','fotografia','outro'
    )),
    autor_orgao TEXT,
    data_publicacao TEXT,
    repositorio TEXT,          -- cartório, arquivo, site onde a fonte está
    referencia TEXT,           -- livro/folha/número, URL, cota do arquivo
    nota TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Uma citação liga um fato a uma fonte. O fato pode ser uma pessoa, um evento,
-- uma união ou uma entrada de atributo — daí o par (alvo_tipo, alvo_id), que
-- não vira FK, mas é validado na camada de domínio.
CREATE TABLE citacoes (
    id TEXT PRIMARY KEY,
    fonte_id TEXT NOT NULL,
    alvo_tipo TEXT NOT NULL CHECK (alvo_tipo IN (
        'pessoa','uniao','evento','religiao','escolaridade','profissao','documento'
    )),
    alvo_id TEXT NOT NULL,
    pagina_folha TEXT,
    confianca TEXT CHECK (confianca IN ('alta','media','baixa','questionavel')),
    transcricao TEXT,
    nota TEXT,
    FOREIGN KEY (fonte_id) REFERENCES fontes(id) ON DELETE CASCADE
);

CREATE INDEX ix_citacoes_fonte ON citacoes (fonte_id);
CREATE INDEX ix_citacoes_alvo  ON citacoes (alvo_tipo, alvo_id);

-- =====================================================================
-- 3. CORREÇÃO: arvore_membros não deduplicava
-- =====================================================================
-- A PK era (arvore_id, pessoa_id, uniao_id) com duas colunas anuláveis. No
-- SQLite, NULL numa coluna de PK é permitido e nunca colide com outro NULL —
-- então (a1, p1, NULL) podia ser inserido infinitas vezes.
--
-- A correção troca a PK por índices únicos parciais, um para cada tipo de
-- membro, que é o que a regra realmente queria dizer.
CREATE TABLE arvore_membros_novo (
    id TEXT PRIMARY KEY,
    arvore_id TEXT NOT NULL,
    pessoa_id TEXT,
    uniao_id TEXT,
    FOREIGN KEY (arvore_id) REFERENCES arvores(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (uniao_id)  REFERENCES unioes(id)  ON DELETE CASCADE,
    -- exatamente um dos dois, nunca ambos, nunca nenhum
    CHECK ((pessoa_id IS NOT NULL) <> (uniao_id IS NOT NULL))
);

INSERT INTO arvore_membros_novo (id, arvore_id, pessoa_id, uniao_id)
SELECT lower(hex(randomblob(16))), arvore_id, pessoa_id, uniao_id FROM arvore_membros;

DROP TABLE arvore_membros;
ALTER TABLE arvore_membros_novo RENAME TO arvore_membros;

CREATE UNIQUE INDEX ix_arvore_membros_pessoa_unica ON arvore_membros (arvore_id, pessoa_id) WHERE pessoa_id IS NOT NULL;
CREATE UNIQUE INDEX ix_arvore_membros_uniao_unica  ON arvore_membros (arvore_id, uniao_id)  WHERE uniao_id  IS NOT NULL;
CREATE INDEX ix_arvore_membros_pessoa ON arvore_membros (pessoa_id);
CREATE INDEX ix_arvore_membros_uniao  ON arvore_membros (uniao_id);

-- =====================================================================
-- 4. CORREÇÃO: documento_vinculos aceitava vínculo órfão
-- =====================================================================
-- `eventos` tinha o CHECK de "pelo menos um alvo"; esta tabela não. Sem ele,
-- dava para gravar um vínculo que não aponta para nada.
CREATE TABLE documento_vinculos_novo (
    id TEXT PRIMARY KEY,
    documento_id TEXT NOT NULL,
    pessoa_id TEXT,
    evento_id TEXT,
    FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE,
    CHECK (pessoa_id IS NOT NULL OR evento_id IS NOT NULL)
);

INSERT INTO documento_vinculos_novo (id, documento_id, pessoa_id, evento_id)
SELECT id, documento_id, pessoa_id, evento_id FROM documento_vinculos
WHERE pessoa_id IS NOT NULL OR evento_id IS NOT NULL;

DROP TABLE documento_vinculos;
ALTER TABLE documento_vinculos_novo RENAME TO documento_vinculos;

CREATE INDEX ix_doc_vinculos_documento ON documento_vinculos (documento_id);
CREATE INDEX ix_doc_vinculos_pessoa    ON documento_vinculos (pessoa_id);
CREATE INDEX ix_doc_vinculos_evento    ON documento_vinculos (evento_id);
