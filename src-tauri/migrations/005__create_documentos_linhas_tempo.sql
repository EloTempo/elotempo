CREATE TABLE documentos (
    id TEXT PRIMARY KEY,
    caminho_relativo TEXT NOT NULL,
    tipo_midia TEXT NOT NULL,
    tamanho_bytes INTEGER,
    data_documento TEXT
);

CREATE TABLE documento_vinculos (
    id TEXT PRIMARY KEY,
    documento_id TEXT NOT NULL,
    pessoa_id TEXT,
    evento_id TEXT,
    FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE
);

CREATE TABLE linhas_tempo (
    id TEXT PRIMARY KEY,
    categoria TEXT NOT NULL,
    titulo TEXT NOT NULL,
    is_contexto BOOLEAN NOT NULL DEFAULT 0,
    is_bloqueada BOOLEAN NOT NULL DEFAULT 0,
    fonte_referencia TEXT
);

CREATE TABLE eventos_linha (
    id TEXT PRIMARY KEY,
    linha_id TEXT NOT NULL,
    data_periodo_texto TEXT NOT NULL,
    titulo TEXT NOT NULL,
    descricao TEXT,
    relevancia TEXT CHECK(relevancia IN ('alta', 'media', 'detalhe')),
    fonte_especifica TEXT,
    FOREIGN KEY (linha_id) REFERENCES linhas_tempo(id) ON DELETE CASCADE
);