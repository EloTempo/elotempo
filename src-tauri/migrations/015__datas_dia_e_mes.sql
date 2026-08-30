-- 015 — Dia e mês nas datas de evento (preparação da fatia 08).
--
-- O planejamento da exportação GEDCOM revelou uma perda: `eventos` guardava
-- `data_texto` (livre) e `ano_inicio`/`ano_fim` (derivados), mas nada de dia
-- nem de mês. Quem escreveu "12/03/1945" tinha o texto preservado, mas
-- estruturalmente o programa só sabia **1945** — e exportaria o ano onde sabe o
-- dia, num formato cujo propósito é fidelidade.
--
-- A escolha do autor tornou isso mais simples do que seria: em vez de o
-- programa adivinhar dia e mês lendo texto livre, a interface passa a
-- oferecê-los em listas suspensas. O dado chega estruturado da origem, e o
-- palpite deixa de existir.
--
-- `data_texto` continua sendo a verdade exibida (seção 2.5). O que muda é que
-- agora ela é **composta** a partir do que se escolheu — "12 de março de 1945"
-- —, em vez de digitada e depois interpretada.

ALTER TABLE eventos ADD COLUMN dia_inicio INTEGER
    CHECK (dia_inicio IS NULL OR (dia_inicio BETWEEN 1 AND 31));
ALTER TABLE eventos ADD COLUMN mes_inicio INTEGER
    CHECK (mes_inicio IS NULL OR (mes_inicio BETWEEN 1 AND 12));

-- Dia e mês só existem quando o ano existe: uma data "12 de março" sem ano não
-- se posiciona em lugar nenhum do eixo, e guardá-la daria a impressão de haver
-- informação onde não há.
--
-- O CHECK não pode ser acrescentado a uma tabela existente sem reconstruí-la,
-- e reconstruir `eventos` custaria mais do que vale. A regra fica no domínio,
-- em `datas.rs`, com teste.

CREATE INDEX ix_eventos_data_completa ON eventos (ano_inicio, mes_inicio, dia_inicio);
