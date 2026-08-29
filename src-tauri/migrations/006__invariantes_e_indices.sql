-- 006 — Invariantes da seção 3 no schema, e os índices que sustentam a escala.
--
-- Até aqui as regras de conexão viviam só no código Rust, e apenas em parte.
-- O banco é a última linha de defesa: uma regra que só existe na aplicação é
-- uma regra que um bug futuro (ou um import GEDCOM mal feito) atropela.

-- =====================================================================
-- INVARIANTE: "uma pessoa pertence a no máximo uma união como filho"
-- =====================================================================
-- A PK (uniao_id, pessoa_id) só impedia o par repetido — a mesma pessoa podia
-- ser pendurada como filha em quantas uniões quisessem, bastando variar o
-- tipo_vinculo. Este índice é a tradução literal da regra da seção 3, e vale
-- para TODOS os tipos de vínculo, não só o biológico.
CREATE UNIQUE INDEX ix_uniao_filhos_pessoa_unica ON uniao_filhos (pessoa_id);

-- =====================================================================
-- INVARIANTE: atributos de lista não devem aceitar duplicata exata
-- =====================================================================
-- A data/período continua opcional (regra transversal da seção 2.5); o que se
-- impede aqui é a repetição literal do mesmo valor para a mesma pessoa.
CREATE UNIQUE INDEX ix_apelidos_pessoa_unico       ON apelidos_pessoa (pessoa_id, apelido);
CREATE UNIQUE INDEX ix_idiomas_pessoa_unico        ON idiomas_pessoa (pessoa_id, idioma);
CREATE UNIQUE INDEX ix_nacionalidades_pessoa_unica ON nacionalidades_pessoa (pessoa_id, pais_id);

-- =====================================================================
-- ÍNDICES DE CHAVE ESTRANGEIRA
-- =====================================================================
-- O SQLite não cria índice para FK automaticamente. Sem eles, toda busca por
-- pessoa_id nas tabelas de atributos e em eventos é full scan — o que quebra a
-- promessa de "milhares de nós sem travar" da seção 1.

-- Núcleo genealógico
CREATE INDEX ix_unioes_slot_masculino ON unioes (slot_masculino_id);
CREATE INDEX ix_unioes_slot_feminino  ON unioes (slot_feminino_id);
CREATE INDEX ix_uniao_filhos_uniao    ON uniao_filhos (uniao_id);

-- Eventos: o índice composto atende a consulta mais quente do app
-- ("o nascimento desta pessoa"), usada em cada card da árvore.
CREATE INDEX ix_eventos_pessoa      ON eventos (pessoa_id);
CREATE INDEX ix_eventos_uniao       ON eventos (uniao_id);
CREATE INDEX ix_eventos_local       ON eventos (local_id);
CREATE INDEX ix_eventos_pessoa_tipo ON eventos (pessoa_id, tipo_evento);
CREATE INDEX ix_eventos_uniao_tipo  ON eventos (uniao_id, tipo_evento);

-- Espaço
CREATE INDEX ix_locais_pais ON locais (pais_id);
CREATE INDEX ix_locais_ibge ON locais (codigo_ibge);
CREATE INDEX ix_locais_nome ON locais (nome);

-- Atributos de vida
CREATE INDEX ix_apelidos_pessoa       ON apelidos_pessoa (pessoa_id);
CREATE INDEX ix_nacionalidades_pessoa ON nacionalidades_pessoa (pessoa_id);
CREATE INDEX ix_nacionalidades_pais   ON nacionalidades_pessoa (pais_id);
CREATE INDEX ix_religioes_pessoa      ON religioes_pessoa (pessoa_id);
CREATE INDEX ix_escolaridade_pessoa   ON escolaridade_pessoa (pessoa_id);
CREATE INDEX ix_profissoes_pessoa     ON profissoes_pessoa (pessoa_id);
CREATE INDEX ix_idiomas_pessoa        ON idiomas_pessoa (pessoa_id);

-- Acervo de árvores
CREATE INDEX ix_arvore_membros_pessoa ON arvore_membros (pessoa_id);
CREATE INDEX ix_arvore_membros_uniao  ON arvore_membros (uniao_id);
CREATE INDEX ix_arvores_raiz          ON arvores (raiz_pessoa_id);

-- Documentos
CREATE INDEX ix_doc_vinculos_documento ON documento_vinculos (documento_id);
CREATE INDEX ix_doc_vinculos_pessoa    ON documento_vinculos (pessoa_id);
CREATE INDEX ix_doc_vinculos_evento    ON documento_vinculos (evento_id);

-- Linhas do tempo
CREATE INDEX ix_eventos_linha_linha      ON eventos_linha (linha_id);
CREATE INDEX ix_eventos_linha_relevancia ON eventos_linha (linha_id, relevancia);

-- =====================================================================
-- ÍNDICES DE BUSCA (seção 7 — pesquisa multicritério)
-- =====================================================================
-- Agrupar por sobrenome e filtrar por nome são os dois critérios mais usados
-- do painel de pesquisa. NOCASE porque ninguém digita acentuação e caixa de
-- forma consistente ao procurar um antepassado.
CREATE INDEX ix_pessoas_sobrenome ON pessoas (sobrenome COLLATE NOCASE);
CREATE INDEX ix_pessoas_nome      ON pessoas (nome COLLATE NOCASE);
CREATE INDEX ix_pessoas_placeholder ON pessoas (is_placeholder);
