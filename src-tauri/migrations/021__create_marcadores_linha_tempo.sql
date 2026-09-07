-- Migration 021: Marcadores e Anotações da Linha do Tempo (estilo DaVinci Resolve Markers)
CREATE TABLE IF NOT EXISTS marcadores_linha_tempo (
    id TEXT PRIMARY KEY,
    ano INTEGER NOT NULL,
    titulo TEXT NOT NULL,
    comentario TEXT,
    cor TEXT NOT NULL DEFAULT 'azul',
    arvore_id TEXT,
    criado_em TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (arvore_id) REFERENCES arvores(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_marcadores_ano ON marcadores_linha_tempo(ano);
CREATE INDEX IF NOT EXISTS idx_marcadores_arvore ON marcadores_linha_tempo(arvore_id);
