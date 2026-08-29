CREATE TABLE pessoas (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    sobrenome TEXT,
    sexo TEXT NOT NULL CHECK(sexo IN ('M', 'F', 'X', 'U')),
    minibiografia TEXT,
    is_vivo BOOLEAN NOT NULL DEFAULT 1,
    is_placeholder BOOLEAN NOT NULL DEFAULT 0,
    foto_url TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE unioes (
    id TEXT PRIMARY KEY,
    slot_masculino_id TEXT NOT NULL,
    slot_feminino_id TEXT NOT NULL,
    estado_vinculo TEXT DEFAULT 'nao_informado' CHECK(estado_vinculo IN ('casamento', 'estavel', 'dissolvida', 'nao_informado')),
    nota TEXT,
    FOREIGN KEY (slot_masculino_id) REFERENCES pessoas(id) ON DELETE RESTRICT,
    FOREIGN KEY (slot_feminino_id) REFERENCES pessoas(id) ON DELETE RESTRICT
);

CREATE TABLE uniao_filhos (
    uniao_id TEXT NOT NULL,
    pessoa_id TEXT NOT NULL,
    tipo_vinculo TEXT NOT NULL DEFAULT 'biologico' CHECK(tipo_vinculo IN ('biologico', 'adotado', 'enteado', 'tutelado')),
    ordem INTEGER,
    PRIMARY KEY (uniao_id, pessoa_id),
    FOREIGN KEY (uniao_id) REFERENCES unioes(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);