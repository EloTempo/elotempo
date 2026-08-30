-- 013 — Linhas de contexto são imutáveis, e o banco garante (fatia 07).
--
-- As seções 8 e 13 são categóricas: o usuário exibe e combina as linhas de
-- contexto, mas nunca as edita. Preservar a integridade da referência
-- bibliográfica é o ponto — uma linha do tempo que alguém pode alterar deixa
-- de servir como contexto e vira anotação pessoal.
--
-- `is_bloqueada` sozinho é uma flag que só a interface respeita, e uma flag
-- que só a interface respeita é uma flag que o próximo bug atropela. Daí os
-- gatilhos: mesma disciplina das invariantes da seção 3, onde o índice único
-- da migration 006 é a última linha de defesa atrás da regra de domínio.
--
-- INSERT continua permitido de propósito. É por ele que as migrations semeiam
-- o conteúdo, e é o caminho sancionado para corrigir um marco: escrever uma
-- migration nova, que deixa rastro versionado — exatamente o que se quer de
-- uma referência.

CREATE TRIGGER trg_evento_linha_bloqueada_update
BEFORE UPDATE ON eventos_linha
FOR EACH ROW
WHEN (SELECT is_bloqueada FROM linhas_tempo WHERE id = OLD.linha_id) = 1
BEGIN
    SELECT RAISE(ABORT, 'linha de contexto é somente leitura: não se altera um marco, escreve-se uma migration');
END;

CREATE TRIGGER trg_evento_linha_bloqueada_delete
BEFORE DELETE ON eventos_linha
FOR EACH ROW
WHEN (SELECT is_bloqueada FROM linhas_tempo WHERE id = OLD.linha_id) = 1
BEGIN
    SELECT RAISE(ABORT, 'linha de contexto é somente leitura: não se apaga um marco, escreve-se uma migration');
END;

CREATE TRIGGER trg_linha_tempo_bloqueada_update
BEFORE UPDATE ON linhas_tempo
FOR EACH ROW
WHEN OLD.is_bloqueada = 1
BEGIN
    SELECT RAISE(ABORT, 'linha de contexto é somente leitura');
END;

CREATE TRIGGER trg_linha_tempo_bloqueada_delete
BEFORE DELETE ON linhas_tempo
FOR EACH ROW
WHEN OLD.is_bloqueada = 1
BEGIN
    SELECT RAISE(ABORT, 'linha de contexto é somente leitura');
END;
