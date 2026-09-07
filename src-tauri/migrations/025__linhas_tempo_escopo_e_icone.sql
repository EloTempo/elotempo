-- 025 — Escopo geográfico e ícone visual para linhas de contexto (Fatia 07 + Catálogo Histórico).
--
-- Permite categorizar e filtrar linhas por abrangência territorial (Mundo, Brasil, EUA, Europa, etc.)
-- e apresentar ícones temáticos ricos no novo Catálogo Histórico.

ALTER TABLE linhas_tempo ADD COLUMN escopo TEXT DEFAULT 'Mundo';
ALTER TABLE linhas_tempo ADD COLUMN icone  TEXT DEFAULT '📌';
