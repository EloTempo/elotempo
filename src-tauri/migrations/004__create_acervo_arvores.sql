CREATE TABLE arvores (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    descricao TEXT,
    raiz_pessoa_id TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_modificacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (raiz_pessoa_id) REFERENCES pessoas(id) ON DELETE SET NULL
);

CREATE TABLE arvore_membros (
    arvore_id TEXT NOT NULL,
    pessoa_id TEXT,
    uniao_id TEXT,
    PRIMARY KEY (arvore_id, pessoa_id, uniao_id),
    FOREIGN KEY (arvore_id) REFERENCES arvores(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    FOREIGN KEY (uniao_id) REFERENCES unioes(id) ON DELETE CASCADE,
    CHECK (pessoa_id IS NOT NULL OR uniao_id IS NOT NULL)
);