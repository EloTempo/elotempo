CREATE TABLE paises (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    codigo_iso TEXT
);

CREATE TABLE locais (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    uf TEXT,
    pais_id TEXT NOT NULL,
    codigo_ibge TEXT,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE RESTRICT
);

CREATE TABLE eventos (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT,
    uniao_id TEXT,
    tipo_evento TEXT NOT NULL,
    data_texto TEXT,
    local_id TEXT,
    rotulo_historico_livre TEXT,
    nota TEXT,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (uniao_id) REFERENCES unioes(id) ON DELETE CASCADE,
    FOREIGN KEY (local_id) REFERENCES locais(id) ON DELETE SET NULL,
    CHECK (pessoa_id IS NOT NULL OR uniao_id IS NOT NULL)
);