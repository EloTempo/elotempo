-- 010 — Vários nomes por pessoa (fatia 02).
--
-- A seção 2.1 previa um par nome/sobrenome e uma lista de apelidos. Isso não
-- comporta quem carregou mais de um nome na vida:
--
--   D. João VI          nome público ≠ nome de nascimento
--   Papa Francisco      nome religioso adotado em 2013
--   Maria de casada     sobrenome mudou na união
--   João Batista Rosa   nome aportuguesado na imigração
--
-- Nenhum desses é apelido. Apelido (NICK) é alcunha afetiva — "Zezinho", "a
-- Tia Chica" —, e `apelidos_pessoa` continua existindo para isso, sem mudar de
-- sentido.
--
-- `pessoas.nome` e `pessoas.sobrenome` seguem sendo o **nome de exibição**: o
-- que aparece no card, na busca e nos relatórios. Esta tabela é o registro
-- completo dos nomes que a pessoa teve. A duplicação é consciente — derivar a
-- exibição daqui obrigaria a mexer no grafo da árvore, na busca e nos índices
-- NOCASE, sem ganho proporcional.

CREATE TABLE nomes_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,

    -- Os tipos que o GEDCOM distingue em NAME.TYPE, mais os que o padrão
    -- agrupa em AKA e que aqui vale separar (público, religioso, artístico):
    -- num acervo de figuras históricas essa distinção é o dado, não um detalhe.
    tipo TEXT NOT NULL CHECK (tipo IN (
        'nascimento',    -- BIRTH
        'publico',       -- AKA — o nome pelo qual a história a conhece
        'religioso',     -- AKA — nome adotado em ordem ou pontificado
        'casada',        -- MARRIED
        'solteira',      -- MAIDEN
        'artistico',     -- AKA
        'profissional',  -- PROFESSIONAL
        'imigracao',     -- IMMIGRANT
        'outro'          -- OTHER
    )),

    prefixo TEXT,        -- NPFX: D., Dom, Dona, Papa, Madre, Frei, Sir, Dr.
    nome TEXT NOT NULL,  -- GIVN: a única parte obrigatória
    sobrenome TEXT,      -- SURN
    sufixo TEXT,         -- NSFX: VI, Jr., Filho, Neto

    -- Texto livre, opcional, como toda data no sistema (seção 2.5).
    -- Não é interpretado em anos porque nome não entra em linha do tempo.
    periodo TEXT,
    nota TEXT,
    ordem INTEGER,

    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

CREATE INDEX ix_nomes_pessoa ON nomes_pessoa (pessoa_id);
CREATE INDEX ix_nomes_pessoa_tipo ON nomes_pessoa (pessoa_id, tipo);

-- Busca por qualquer nome que a pessoa tenha carregado, não só o de exibição.
-- É o que permite achar "Bergoglio" e chegar em "Papa Francisco".
CREATE INDEX ix_nomes_busca ON nomes_pessoa (nome COLLATE NOCASE);
CREATE INDEX ix_nomes_busca_sobrenome ON nomes_pessoa (sobrenome COLLATE NOCASE);
