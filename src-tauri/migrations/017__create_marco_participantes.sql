CREATE TABLE marco_participantes (
    id                TEXT PRIMARY KEY,
    marco_id          TEXT NOT NULL,
    pessoa_id         TEXT NOT NULL,
    papel             TEXT,
    visivel_na_pessoa BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (marco_id)  REFERENCES eventos_linha(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id)       ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_marco_participantes_unico ON marco_participantes(marco_id, pessoa_id);
