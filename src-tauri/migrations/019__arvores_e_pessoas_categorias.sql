-- 019 — Categorias, país e período para árvores e categorias para pessoas

ALTER TABLE arvores ADD COLUMN categoria TEXT;
ALTER TABLE arvores ADD COLUMN pais TEXT;
ALTER TABLE arvores ADD COLUMN periodo TEXT;

ALTER TABLE pessoas ADD COLUMN categoria TEXT;

-- Atualiza metadados das árvores públicas semeadas
UPDATE arvores
SET categoria = 'Famílias Reais',
    pais = 'Brasil',
    periodo = 'Império (Séc. XIX)'
WHERE id = 'arv_imperial_brasil';

UPDATE arvores
SET categoria = 'Chefes de Estado',
    pais = 'Brasil',
    periodo = 'República (Séc. XX)'
WHERE id = 'arv_presidentes_brasil';

UPDATE arvores
SET categoria = 'Monarcas Bíblicos',
    pais = 'Israel Antigo',
    periodo = 'Antiguidade (a.C.)'
WHERE id = 'arv_biblica_david';
