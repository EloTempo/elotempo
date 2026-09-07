-- 018 — Coluna is_publico para pessoas e árvores

ALTER TABLE pessoas ADD COLUMN is_publico BOOLEAN NOT NULL DEFAULT 0;
ALTER TABLE arvores ADD COLUMN is_publico BOOLEAN NOT NULL DEFAULT 0;

-- Remove as uniões dos registros de teste solicitados pelo usuário (respeitando ON DELETE RESTRICT)
DELETE FROM unioes 
WHERE slot_masculino_id IN ('ae457b64-7e1a-449c-9c67-84b50a92f021', 'facbe5cc-93e6-4e9b-8a09-7a10412758b2')
   OR slot_feminino_id IN ('ae457b64-7e1a-449c-9c67-84b50a92f021', 'facbe5cc-93e6-4e9b-8a09-7a10412758b2');

UPDATE arvores 
SET raiz_pessoa_id = NULL 
WHERE raiz_pessoa_id IN ('ae457b64-7e1a-449c-9c67-84b50a92f021', 'facbe5cc-93e6-4e9b-8a09-7a10412758b2');

-- Limpa os dois registros de teste solicitados pelo usuário
DELETE FROM pessoas WHERE id IN ('ae457b64-7e1a-449c-9c67-84b50a92f021', 'facbe5cc-93e6-4e9b-8a09-7a10412758b2');
