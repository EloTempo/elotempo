CREATE TABLE apelidos_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    apelido TEXT NOT NULL,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

CREATE TABLE nacionalidades_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    pais_id TEXT NOT NULL,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE CASCADE
);

CREATE TABLE religioes_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    denominacao TEXT NOT NULL,
    periodo TEXT,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

CREATE TABLE escolaridade_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    nivel TEXT NOT NULL,
    instituicao TEXT,
    periodo TEXT,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

CREATE TABLE profissoes_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    ocupacao TEXT NOT NULL,
    empregador_local TEXT,
    periodo TEXT,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

CREATE TABLE idiomas_pessoa (
    id TEXT PRIMARY KEY,
    pessoa_id TEXT NOT NULL,
    idioma TEXT NOT NULL,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);