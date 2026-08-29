-- 011 — Título e descrição nos documentos (fatia 03).
--
-- A tabela `documentos` da migration 005 guardava caminho, tipo e tamanho —
-- suficiente para armazenar, insuficiente para lembrar. "IMG_4471.jpg" não diz
-- nada; "Casamento dos bisavós, na igreja de Santa Rita" diz tudo, e é esse o
-- ponto do programa.

ALTER TABLE documentos ADD COLUMN titulo TEXT;
ALTER TABLE documentos ADD COLUMN descricao TEXT;

-- Nome original do arquivo escolhido pelo usuário. O arquivo copiado recebe um
-- nome gerado (o id + extensão) para evitar colisão entre dois "IMG_0001.jpg",
-- mas o nome de origem é uma pista de memória por si só — e ajuda a reconhecer
-- o anexo se alguém for olhar a pasta de mídia por fora.
ALTER TABLE documentos ADD COLUMN nome_original TEXT;

ALTER TABLE documentos ADD COLUMN data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP;

CREATE INDEX ix_documentos_tipo ON documentos (tipo_midia);
