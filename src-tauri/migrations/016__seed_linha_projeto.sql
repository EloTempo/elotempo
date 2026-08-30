-- 016 — A linha do tempo do próprio programa.
--
-- Ideia do Gabriel: o software que situa vidas na história também tem uma
-- história, e ela merece o mesmo tratamento que as outras — marcos datados,
-- versionados, imutáveis.
--
-- Isto é mais do que simpatia. É a linha de contexto que qualquer usuário
-- pode conferir sozinho, porque o repositório está aberto: quem duvidar de um
-- marco confere no histórico do git. Serve de exemplo trabalhado do que uma
-- linha de contexto deve ser.
--
-- COMO ATUALIZAR (a regra da 013 vale aqui igual)
-- Marco novo é migration nova. Não se edita esta. A cada versão publicada,
-- escreva `0NN__linha_projeto_vX.sql` com um INSERT — que os gatilhos
-- permitem — e o marco entra com rastro. UPDATE e DELETE seguem recusados.
--
-- O QUE NÃO ESTÁ AQUI
-- A primeira versão pública ainda não saiu. Um marco para ela seria registro
-- de coisa que não aconteceu, que é exatamente o que uma referência não pode
-- fazer. Entra quando sair.

INSERT INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-projeto','projeto','Este programa',1,1,
 'Marcos do desenvolvimento deste software, conferíveis no histórico do repositório.');

INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim) VALUES
('proj-2026-08-29-versionamento','lt-projeto','29 de agosto de 2026',
 'Projeto sob controle de versão',
 'Primeiro commit do repositório, já com as quatro invariantes de conexão fechadas e testadas. O trabalho anterior ao versionamento não deixou registro datado.',
 'alta',2026,2026),

('proj-2026-08-29-mvp','lt-projeto','29 de agosto de 2026',
 'MVP completo',
 'Os nove itens do escopo mínimo entregues: pessoas, uniões e filhos com placeholder, árvore com pan/zoom, acervo em SQLite, fotos e documentos, locais do IBGE, atributos de vida, relatórios nos três modos e busca multicritério.',
 'alta',2026,2026),

('proj-2026-08-29-linhas','lt-projeto','29 de agosto de 2026',
 'As linhas do tempo',
 'A gaveta de contexto: história do Brasil, presidentes, moeda e tecnologias, mais a vida da pessoa selecionada — e o destaque, na árvore, de quem estava vivo num marco.',
 'alta',2026,2026),

('proj-2026-08-30-gedcom','lt-projeto','30 de agosto de 2026',
 'Exportação em GEDCOM',
 'O acervo passa a sair no formato que outros programas de genealogia leem, com as fotos num pacote GEDZip. É o que torna os dados portáveis para fora deste software.',
 'alta',2026,2026);
