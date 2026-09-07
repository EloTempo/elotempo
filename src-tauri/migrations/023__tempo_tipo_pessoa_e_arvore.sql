-- 023 — Distinção entre Tempo Real e Tempo Fictício para Pessoas e Árvores

ALTER TABLE pessoas ADD COLUMN tipo_tempo TEXT NOT NULL DEFAULT 'real' CHECK(tipo_tempo IN ('real', 'ficticio'));
ALTER TABLE arvores ADD COLUMN tipo_tempo TEXT NOT NULL DEFAULT 'real' CHECK(tipo_tempo IN ('real', 'ficticio'));

-- Marcação de árvores de literatura, ficção ou mitologia
UPDATE arvores
SET tipo_tempo = 'ficticio'
WHERE id IN (
    'pub_arv_buendia',
    'pub_arv_lannister',
    'pub_arv_terra_cambara'
);

-- Marcação de personagens pertencentes a árvores fictícias
UPDATE pessoas
SET tipo_tempo = 'ficticio'
WHERE id IN (
    SELECT pessoa_id FROM arvore_membros
    WHERE arvore_id IN ('pub_arv_buendia', 'pub_arv_lannister', 'pub_arv_terra_cambara')
      AND pessoa_id IS NOT NULL
);
