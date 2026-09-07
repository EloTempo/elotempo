-- 026 — Semente completa do Acervo de 31 Linhas de Contexto Histórico do EloTempo.
-- Desativa temporariamente triggers de somente-leitura para atualização segura.

DROP TRIGGER IF EXISTS trg_evento_linha_bloqueada_update;
DROP TRIGGER IF EXISTS trg_evento_linha_bloqueada_delete;
DROP TRIGGER IF EXISTS trg_linha_tempo_bloqueada_update;
DROP TRIGGER IF EXISTS trg_linha_tempo_bloqueada_delete;

UPDATE linhas_tempo SET escopo = 'Brasil', icone = '🇧🇷' WHERE id IN ('lt-brasil', 'lt-independencia');
UPDATE linhas_tempo SET escopo = 'Brasil', icone = '🏛️' WHERE id = 'lt-presidentes';
UPDATE linhas_tempo SET escopo = 'Brasil', icone = '💰' WHERE id = 'lt-moeda';
UPDATE linhas_tempo SET escopo = 'Mundo', icone = '💡' WHERE id = 'lt-tecnologia';
UPDATE linhas_tempo SET escopo = 'Sistema', icone = '💻' WHERE id = 'lt-software';

INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-grandes-acontecimentos-da-historia-mundial', 'História Geral', 'Grandes Acontecimentos da História Mundial', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🌍');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-moedas-em-circulacao-brasil', 'Moedas & Economia', 'Moedas em Circulação - Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '💰');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-moedas-em-circulacao-estados-unidos', 'Moedas & Economia', 'Moedas em Circulação - Estados Unidos', 1, 1, 'Acervo histórico curado do EloTempo — Estados Unidos.', 'Estados Unidos', '💰');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-moedas-em-circulacao-europa-territorios-histori', 'Moedas & Economia', 'Moedas em Circulação - Europa & Territórios Históricos', 1, 1, 'Acervo histórico curado do EloTempo — Europa.', 'Europa', '💰');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-moedas-em-circulacao-russia', 'Moedas & Economia', 'Moedas em Circulação - Rússia', 1, 1, 'Acervo histórico curado do EloTempo — Rússia.', 'Rússia', '💰');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-governantes-do-brasil-monarquia-e-republica-vel', 'Poder e Governo', 'Governantes do Brasil - Monarquia e República Velha', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '🏛️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-governantes-do-brasil-era-vargas-a-1964', 'Poder e Governo', 'Governantes do Brasil - Era Vargas a 1964', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '🏛️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-governantes-do-brasil-ditadura-militar-e-nova-r', 'Poder e Governo', 'Governantes do Brasil - Ditadura Militar e Nova República', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '🏛️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-tecnologia-transporte', 'Tecnologia e Inovação', 'Tecnologia - Transporte', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🚗');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-tecnologia-comunicacao', 'Tecnologia e Inovação', 'Tecnologia - Comunicação', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '📡');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-tecnologia-computacao', 'Tecnologia e Inovação', 'Tecnologia - Computação', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '💻');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-ciencia-medicina-e-saude', 'Ciência e Conhecimento', 'Ciência - Medicina e Saúde', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🧬');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-tecnologia-energia', 'Tecnologia e Inovação', 'Tecnologia - Energia', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '⚡');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-ciencia-astronomia-e-fisica', 'Ciência e Conhecimento', 'Ciência - Astronomia e Física', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🔭');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-ciencia-biologia-e-evolucao', 'Ciência e Conhecimento', 'Ciência - Biologia e Evolução', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🌱');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-livros-e-literatura-fundamental', 'Livros e Literatura', 'Livros e Literatura Fundamental', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '📚');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-livros-e-literatura-brasil', 'Livros e Literatura', 'Livros e Literatura - Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '📚');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-guerras-e-conflitos-mundo', 'Guerras e Conflitos', 'Guerras e Conflitos - Mundo', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '⚔️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-guerras-e-conflitos-brasil', 'Guerras e Conflitos', 'Guerras e Conflitos - Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '⚔️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-religioes-e-historia-religiosa', 'Religião', 'Religiões e História Religiosa', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '⛪');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-entidades-politicas-do-mundo-biblico', 'História Antiga', 'Entidades Políticas do Mundo Bíblico', 1, 1, 'Acervo histórico curado do EloTempo — Oriente Próximo.', 'Oriente Próximo', '📜');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-economia-e-ciclos-economicos-do-brasil', 'Moedas & Economia', 'Economia e Ciclos Econômicos do Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '🇧🇷');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-constituicoes-brasileiras', 'Política e Leis', 'Constituições Brasileiras', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '⚖️');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-escravidao-e-abolicionismo-no-brasil', 'Sociedade e Direitos', 'Escravidão e Abolicionismo no Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '👥');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-ciencia-e-inovacao-no-brasil', 'Tecnologia e Inovação', 'Ciência e Inovação no Brasil', 1, 1, 'Acervo histórico curado do EloTempo — Brasil.', 'Brasil', '🇧🇷');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-russia-e-uniao-sovietica-entidades-politicas-e', 'História Geral', 'Rússia e União Soviética - Entidades Políticas e Espaço', 1, 1, 'Acervo histórico curado do EloTempo — Rússia.', 'Rússia', '🚀');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-america-latina-integracao-e-transformacoes-poli', 'História Geral', 'América Latina - Integração e Transformações Políticas', 1, 1, 'Acervo histórico curado do EloTempo — América Latina.', 'América Latina', '🌍');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-grandes-pandemias-historicas', 'Medicina e Saúde', 'Grandes Pandemias Históricas', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🦠');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-transformacoes-sociais-e-direitos', 'Sociedade e Direitos', 'Transformações Sociais e Direitos', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '👥');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-cultura-musica-cinema-e-esportes', 'Cultura e Lazer', 'Cultura - Música, Cinema e Esportes', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '🎨');
INSERT OR REPLACE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia, escopo, icone)
VALUES ('lt-pessoas-que-mudaram-a-historia', 'Biografias e Personalidades', 'Pessoas que Mudaram a História', 1, 1, 'Acervo histórico curado do EloTempo — Mundo.', 'Mundo', '👤');

-- Inserção de todos os marcos históricos das 31 linhas de contexto
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--10000-revolucao-agricola-neolit-1', 'lt-grandes-acontecimentos-da-historia-mundial', '10000 a.C.–4000 a.C.', 'Revolução Agrícola (Neolítico)', 'Transição do nomadismo caçador-coletor para a agricultura e sedentarização', 'alta', -10000, -4000);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--3500-surgimento-das-primeiras-2', 'lt-grandes-acontecimentos-da-historia-mundial', '3500 a.C.–3000 a.C.', 'Surgimento das Primeiras Civilizações', 'Primeiras cidades-Estado, irrigação e escrita cuneiforme', 'alta', -3500, -3000);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--3500-mesopotamia-3', 'lt-grandes-acontecimentos-da-historia-mundial', '3500 a.C.–539 a.C.', 'Mesopotâmia', 'Civilizações suméria, acádia, babilônica e assíria entre os rios Tigre e Eufrates', 'alta', -3500, -539);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--3100-egito-antigo-4', 'lt-grandes-acontecimentos-da-historia-mundial', '3100 a.C.–30 a.C.', 'Egito Antigo', 'Da unificação do Alto e Baixo Egito até a anexação pelo Império Romano', 'alta', -3100, -30);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--1200-grecia-antiga-5', 'lt-grandes-acontecimentos-da-historia-mundial', '1200 a.C.–146 a.C.', 'Grécia Antiga', 'Períodos arcaico, clássico e helenístico; berço da democracia e filosofia ocidental', 'alta', -1200, -146);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a--27-imperio-romano-6', 'lt-grandes-acontecimentos-da-historia-mundial', '27 a.C.–476', 'Império Romano', 'Da ascensão de Augusto à queda de Roma Ocidental', 'alta', -27, 476);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-476-queda-do-imperio-romano-d-7', 'lt-grandes-acontecimentos-da-historia-mundial', '476', 'Queda do Império Romano do Ocidente', 'Deposição de Rômulo Augusto pelos hérulos; início da Idade Média', 'alta', 476, 476);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-622-expansao-islamica-inicial-8', 'lt-grandes-acontecimentos-da-historia-mundial', '622–750', 'Expansão Islâmica Inicial', 'Da Hégira de Maomé à consolidação do Califado Omíada no Oriente Médio e Península Ibérica', 'alta', 622, 750);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1095-cruzadas-9', 'lt-grandes-acontecimentos-da-historia-mundial', '1095–1291', 'Cruzadas', 'Campanhas militares cristãs convocadas pelo Papa Urbano II no Oriente Próximo', 'alta', 1095, 1291);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1346-peste-negra-10', 'lt-grandes-acontecimentos-da-historia-mundial', '1346–1353', 'Peste Negra', 'Epidemia de peste bubônica que dizimou um terço da população europeia', 'alta', 1346, 1353);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1300-renascimento-cultural-e-a-11', 'lt-grandes-acontecimentos-da-historia-mundial', '1300–1600', 'Renascimento Cultural e Artístico', 'Movimento de valorização do humanismo e da Antiguidade Clássica', 'alta', 1300, 1600);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1415-expansao-maritima-europei-12', 'lt-grandes-acontecimentos-da-historia-mundial', '1415–1600', 'Expansão Marítima Europeia', 'Grandes navegações e rotas marítimas para as Índias e o Atlântico', 'alta', 1415, 1600);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1492-chegada-de-colombo-a-amer-13', 'lt-grandes-acontecimentos-da-historia-mundial', '1492', 'Chegada de Colombo à América', 'Início do processo sistemático de colonização europeia no continente americano', 'alta', 1492, 1492);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1517-reforma-protestante-14', 'lt-grandes-acontecimentos-da-historia-mundial', '1517–1648', 'Reforma Protestante', 'Movimento de ruptura religiosa iniciado por Martinho Lutero até a Paz de Vestfália', 'alta', 1517, 1648);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1543-revolucao-cientifica-15', 'lt-grandes-acontecimentos-da-historia-mundial', '1543–1687', 'Revolução Científica', 'De Copérnico a Newton; estabelecimento do método científico e da física clássica', 'alta', 1543, 1687);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1760-primeira-revolucao-indust-16', 'lt-grandes-acontecimentos-da-historia-mundial', '1760–1840', 'Primeira Revolução Industrial', 'Mecanização têxtil, ferro e máquina a vapor iniciadas na Grã-Bretanha', 'alta', 1760, 1840);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1776-independencias-americanas-17', 'lt-grandes-acontecimentos-da-historia-mundial', '1776–1825', 'Independências Americanas', 'Processos de independência nos EUA, América Espanhola e Brasil', 'alta', 1776, 1825);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1789-revolucao-francesa-18', 'lt-grandes-acontecimentos-da-historia-mundial', '1789–1799', 'Revolução Francesa', 'Fim do Antigo Regime francês, Queda da Bastilha e Declaração dos Direitos do Homem', 'alta', 1789, 1799);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1870-neocolonialismo-e-imperia-19', 'lt-grandes-acontecimentos-da-historia-mundial', '1870–1914', 'Neocolonialismo e Imperialismo', 'Partilha da África e dominação europeia na Ásia durante a Segunda Revolução Industrial', 'alta', 1870, 1914);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1914-primeira-guerra-mundial-20', 'lt-grandes-acontecimentos-da-historia-mundial', '1914–1918', 'Primeira Guerra Mundial', 'Conflito de trincheiras entre a Tríplice Entente e as Potências Centrais', 'alta', 1914, 1918);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1917-revolucao-russa-21', 'lt-grandes-acontecimentos-da-historia-mundial', '1917', 'Revolução Russa', 'Queda do czarismo e tomada de poder pelos bolcheviques liderados por Lenin', 'alta', 1917, 1917);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1939-segunda-guerra-mundial-22', 'lt-grandes-acontecimentos-da-historia-mundial', '1939–1945', 'Segunda Guerra Mundial', 'Conflito global entre Aliados e o Eixo; Holocausto e bombas atômicas', 'alta', 1939, 1945);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1947-guerra-fria-23', 'lt-grandes-acontecimentos-da-historia-mundial', '1947–1991', 'Guerra Fria', 'Polarização ideológica, militar e geopolítica entre EUA e União Soviética', 'alta', 1947, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1989-queda-do-muro-de-berlim-24', 'lt-grandes-acontecimentos-da-historia-mundial', '1989', 'Queda do Muro de Berlim', 'Colapso simbólico do bloco socialista europeu e reunificação da Alemanha', 'alta', 1989, 1989);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1991-dissolucao-da-uniao-sovie-25', 'lt-grandes-acontecimentos-da-historia-mundial', '1991', 'Dissolução da União Soviética', 'Renúncia de Gorbachev e fim da URSS; reconfiguração geopolítica global', 'alta', 1991, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1990-globalizacao-contemporane-26', 'lt-grandes-acontecimentos-da-historia-mundial', '1990–2026', 'Globalização Contemporânea', 'Integração acelerada de mercados financeiros, cadeias de suprimentos e redes digitais', 'alta', 1990, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-1991-abertura-publica-da-world-27', 'lt-grandes-acontecimentos-da-historia-mundial', '1991', 'Abertura Pública da World Wide Web', 'Disponibilização do protocolo www criado por Tim Berners-Lee ao público', 'alta', 1991, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-2020-pandemia-de-covid-19-28', 'lt-grandes-acontecimentos-da-historia-mundial', '2020–2023', 'Pandemia de COVID-19', 'Emergência de saúde pública internacional causada pelo vírus SARS-CoV-2', 'alta', 2020, 2023);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-a-2022-era-da-inteligencia-artif-29', 'lt-grandes-acontecimentos-da-historia-mundial', '2022–2026', 'Era da Inteligência Artificial Generativa', 'Disseminação em larga escala de modelos de linguagem e redes neurais profundas', 'alta', 2022, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1500-reis-coloniais-1', 'lt-moedas-em-circulacao-brasil', '1500–1808', 'Réis Coloniais', 'Padrão monetário herdado de Portugal em circulação na colônia', 'media', 1500, 1808);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1808-reis-mil-reis-2', 'lt-moedas-em-circulacao-brasil', '1808–1942', 'Réis (mil-réis)', 'Moeda do Reino Unido, Império do Brasil e Primeira República', 'alta', 1808, 1942);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1942-cruzeiro-cr-3', 'lt-moedas-em-circulacao-brasil', '1942–1967', 'Cruzeiro (Cr$)', 'Criado por Getúlio Vargas para modernizar o sistema decimal (1 Cr$ = 1.000 réis)', 'alta', 1942, 1967);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1967-cruzeiro-novo-ncr-4', 'lt-moedas-em-circulacao-brasil', '1967–1970', 'Cruzeiro Novo (NCr$)', 'Moeda de transição com corte de três zeros diante da inflação', 'alta', 1967, 1970);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1970-cruzeiro-cr-5', 'lt-moedas-em-circulacao-brasil', '1970–1986', 'Cruzeiro (Cr$)', 'Retorno formal do nome Cruzeiro mantendo a equivalência ao Cruzeiro Novo', 'alta', 1970, 1986);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1986-cruzado-cz-6', 'lt-moedas-em-circulacao-brasil', '1986–1989', 'Cruzado (Cz$)', 'Criado no Plano Cruzado com corte de três zeros e congelamento de preços', 'alta', 1986, 1989);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1989-cruzado-novo-ncz-7', 'lt-moedas-em-circulacao-brasil', '1989–1990', 'Cruzado Novo (NCz$)', 'Moeda do Plano Verão com corte de mais três zeros', 'alta', 1989, 1990);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1990-cruzeiro-cr-8', 'lt-moedas-em-circulacao-brasil', '1990–1993', 'Cruzeiro (Cr$)', 'Retorno do Cruzeiro implementado pelo Plano Collor', 'alta', 1990, 1993);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1993-cruzeiro-real-cr-9', 'lt-moedas-em-circulacao-brasil', '1993–1994', 'Cruzeiro Real (CR$)', 'Moeda transitória para o cálculo do alinhamento da URV', 'alta', 1993, 1994);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1994-real-r-10', 'lt-moedas-em-circulacao-brasil', '1994–2026', 'Real (R$)', 'Padrão monetário instituído pelo Plano Real', 'alta', 1994, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1535-spanish-dollar-real-de-a-1', 'lt-moedas-em-circulacao-estados-unidos', '1535–1857', 'Spanish Dollar (Real de a 8)', 'Dólar espanhol amplamente aceito como moeda de curso legal no comércio colonial e americano', 'media', 1535, 1857);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1775-continental-currency-2', 'lt-moedas-em-circulacao-estados-unidos', '1775–1785', 'Continental Currency', 'Papel-moeda emitido pelo Congresso Continental durante a Guerra de Independência', 'alta', 1775, 1785);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1792-dolar-bimetalico-coinage-3', 'lt-moedas-em-circulacao-estados-unidos', '1792–1873', 'Dólar Bimetálico (Coinage Act de 1792)', 'Estabelecimento oficial do dólar com lastro vinculado em ouro e prata', 'alta', 1792, 1873);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1873-padrao-ouro-classico-gold-4', 'lt-moedas-em-circulacao-estados-unidos', '1873–1933', 'Padrão-Ouro Clássico (Gold Standard)', 'Fim do bimetalismo (Coinage Act de 1873) e lastro exclusivo em ouro formalizado em 1900', 'alta', 1873, 1933);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1944-sistema-de-bretton-woods-5', 'lt-moedas-em-circulacao-estados-unidos', '1944–1971', 'Sistema de Bretton Woods', 'Dólar estabelecido como reserva monetária global lastreada em ouro a US$ 35/onça', 'alta', 1944, 1971);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1971-dolar-fiduciario-nixon-sh-6', 'lt-moedas-em-circulacao-estados-unidos', '1971–2026', 'Dólar Fiduciário (Nixon Shock)', 'Fim da conversibilidade direta em ouro; consolidação do dólar fiduciário flutuante', 'alta', 1971, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em--211-denario-romano-1', 'lt-moedas-em-circulacao-europa-territorios-histori', '211 a.C.–244', 'Denário Romano', 'Principal moeda de prata de Roma durante a República e o Alto Império', 'alta', -211, 244);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-312-soldo-bizantino-solidus-2', 'lt-moedas-em-circulacao-europa-territorios-histori', '312–1453', 'Soldo Bizantino (Solidus)', 'Moeda de ouro instituída por Constantino I; padrão financeiro por séculos', 'alta', 312, 1453);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1158-libra-esterlina-3', 'lt-moedas-em-circulacao-europa-territorios-histori', '1158–2026', 'Libra Esterlina', 'Moeda instituída por Henrique II na Inglaterra; a mais antiga divisa ainda em circulação', 'alta', 1158, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1252-florim-florentino-4', 'lt-moedas-em-circulacao-europa-territorios-histori', '1252–1533', 'Florim Florentino', 'Moeda de ouro de Florença amplamente utilizada no comércio mercantil europeu', 'media', 1252, 1533);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1284-ducado-veneziano-5', 'lt-moedas-em-circulacao-europa-territorios-histori', '1284–1797', 'Ducado Veneziano', 'Moeda de ouro cunhada pela República de Veneza para transações internacionais', 'media', 1284, 1797);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1360-franco-frances-6', 'lt-moedas-em-circulacao-europa-territorios-histori', '1360–2002', 'Franco Francês', 'Moeda histórica francesa oficializada no padrão decimal em 1795 e extinta pelo Euro', 'alta', 1360, 2002);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1873-marco-alemao-mark-deutsch-7', 'lt-moedas-em-circulacao-europa-territorios-histori', '1873–2002', 'Marco Alemão (Mark / Deutsche Mark)', 'Moeda unificada do Império Alemão e da República Federal até a adoção do Euro', 'alta', 1873, 2002);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1999-euro-8', 'lt-moedas-em-circulacao-europa-territorios-histori', '1999–2026', 'Euro (€)', 'Moeda única europeia adotada eletronicamente em 1999 e em circulação física em 2002', 'alta', 1999, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1704-rublo-imperial-russo-1', 'lt-moedas-em-circulacao-russia', '1704–1917', 'Rublo Imperial Russo', 'Reforma monetária de Pedro, o Grande, estabelecendo o rublo decimal em prata', 'alta', 1704, 1917);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1922-rublo-sovietico-2', 'lt-moedas-em-circulacao-russia', '1922–1991', 'Rublo Soviético', 'Moeda oficial da URSS utilizada em todas as repúblicas soviéticas', 'alta', 1922, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-moedas-em-1992-rublo-da-federacao-russa-3', 'lt-moedas-em-circulacao-russia', '1992–2026', 'Rublo da Federação Russa', 'Moeda instituída após o colapso soviético, redenominada em 1998', 'alta', 1992, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1822-dom-pedro-i-1', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1822–1831', 'Dom Pedro I', 'Primeiro Imperador do Brasil; outorgou a Constituição de 1824 e abdicou ao trono', 'alta', 1822, 1831);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1831-periodo-regencial-2', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1831–1840', 'Período Regencial', 'Transição governada por Regências Trinas e Unas até a maioridade de Pedro II', 'alta', 1831, 1840);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1840-dom-pedro-ii-3', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1840–1889', 'Dom Pedro II', 'Segundo Imperador; quase cinco décadas de estabilidade monárquica e consolidação nacional', 'alta', 1840, 1889);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1889-deodoro-da-fonseca-4', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1889–1891', 'Deodoro da Fonseca', 'Proclamador da República e primeiro Presidente Constitucional da República Velha', 'alta', 1889, 1891);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1891-floriano-peixoto-5', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1891–1894', 'Floriano Peixoto', 'Vice-presidente que assumiu após renúncia de Deodoro; consolidou o regime contra revoltas', 'alta', 1891, 1894);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1894-prudente-de-morais-6', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1894–1898', 'Prudente de Morais', 'Primeiro presidente civil do Brasil; enfrentou a Guerra de Canudos', 'alta', 1894, 1898);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1898-campos-sales-7', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1898–1902', 'Campos Sales', 'Instituidor da ''Política dos Governadores'' e do saneamento financeiro via Funding Loan', 'alta', 1898, 1902);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1902-rodrigues-alves-8', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1902–1906', 'Rodrigues Alves', 'Modernização urbana e sanitária do Rio de Janeiro; enfrentou a Revolta da Vacina', 'alta', 1902, 1906);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1906-afonso-pena-9', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1906–1909', 'Afonso Pena', 'Expansão ferroviária e apoio à cafeicultura pelo Convênio de Taubaté; faleceu no cargo', 'media', 1906, 1909);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1909-nilo-pecanha-10', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1909–1910', 'Nilo Peçanha', 'Assumiu após a morte de Afonso Pena; criou o Serviço de Proteção aos Índios', 'media', 1909, 1910);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1910-hermes-da-fonseca-11', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1910–1914', 'Hermes da Fonseca', 'Política das Salvações; enfrentou a Revolta da Chibata e o Contestado', 'media', 1910, 1914);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1914-venceslau-bras-12', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1914–1918', 'Venceslau Brás', 'Mandato marcado pela participação do Brasil na Primeira Guerra Mundial e Gripe Espanhola', 'media', 1914, 1918);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1918-delfim-moreira-13', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1918–1919', 'Delfim Moreira', 'Vice-presidente em exercício devido ao falecimento do presidente eleito Rodrigues Alves', 'media', 1918, 1919);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1919-epitacio-pessoa-14', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1919–1922', 'Epitácio Pessoa', 'Centenário da Independência e eclosão do movimento Tenentista (18 do Forte)', 'media', 1919, 1922);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1922-artur-bernardes-15', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1922–1926', 'Artur Bernardes', 'Mandato integralmente sob estado de sítio devido a rebeliões militares tenentistas', 'media', 1922, 1926);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1926-washington-luis-16', 'lt-governantes-do-brasil-monarquia-e-republica-vel', '1926–1930', 'Washington Luís', 'Último presidente da República Velha; deposto pela Revolução de 1930', 'alta', 1926, 1930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1930-getulio-vargas-governo-pr-1', 'lt-governantes-do-brasil-era-vargas-a-1964', '1930–1934', 'Getúlio Vargas (Governo Provisório)', 'Chegada ao poder após a Revolução de 1930; enfrentou a Revolução Constitucionalista', 'alta', 1930, 1934);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1934-getulio-vargas-governo-co-2', 'lt-governantes-do-brasil-era-vargas-a-1964', '1934–1937', 'Getúlio Vargas (Governo Constitucional)', 'Eleito indiretamente pela Assembleia Constituinte de 1934', 'alta', 1934, 1937);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1937-getulio-vargas-estado-nov-3', 'lt-governantes-do-brasil-era-vargas-a-1964', '1937–1945', 'Getúlio Vargas (Estado Novo)', 'Ditadura autoritária personalista; industrialização de base e envio da FEB à Itália', 'alta', 1937, 1945);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1945-jose-linhares-4', 'lt-governantes-do-brasil-era-vargas-a-1964', '1945–1946', 'José Linhares', 'Presidente do STF que governou interinamente após a deposição de Vargas', 'media', 1945, 1946);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1946-eurico-gaspar-dutra-5', 'lt-governantes-do-brasil-era-vargas-a-1964', '1946–1951', 'Eurico Gaspar Dutra', 'Mandato constitucional sob a Carta de 1946; alinhamento aos EUA na Guerra Fria', 'alta', 1946, 1951);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1951-getulio-vargas-constituci-6', 'lt-governantes-do-brasil-era-vargas-a-1964', '1951–1954', 'Getúlio Vargas (Constitucional)', 'Eleito por voto direto; criação da Petrobras e crise institucional que levou ao suicídio', 'alta', 1951, 1954);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1954-joao-cafe-filho-7', 'lt-governantes-do-brasil-era-vargas-a-1964', '1954–1955', 'João Café Filho', 'Vice-presidente que assumiu após o suicídio de Vargas', 'media', 1954, 1955);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1955-carlos-luz-8', 'lt-governantes-do-brasil-era-vargas-a-1964', '1955', 'Carlos Luz', 'Presidente da Câmara dos Deputados no cargo por três dias; deposto pelo Golpe Preventivo', 'media', 1955, 1955);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1955-nereu-ramos-9', 'lt-governantes-do-brasil-era-vargas-a-1964', '1955–1956', 'Nereu Ramos', 'Presidente do Senado que garantiu a posse pacífica de Juscelino Kubitschek', 'media', 1955, 1956);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1956-juscelino-kubitschek-10', 'lt-governantes-do-brasil-era-vargas-a-1964', '1956–1961', 'Juscelino Kubitschek', 'Plano de Metas, 50 anos em 5, abertura à indústria automobilística e fundação de Brasília', 'alta', 1956, 1961);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1961-janio-quadros-11', 'lt-governantes-do-brasil-era-vargas-a-1964', '1961', 'Jânio Quadros', 'Mandato de sete meses encerrado por renúncia inesperada gerando crise institucional', 'alta', 1961, 1961);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1961-ranieri-mazzilli-12', 'lt-governantes-do-brasil-era-vargas-a-1964', '1961', 'Ranieri Mazzilli', 'Presidente da Câmara no exercício da presidência durante a Crise da Renúncia', 'media', 1961, 1961);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1961-joao-goulart-13', 'lt-governantes-do-brasil-era-vargas-a-1964', '1961–1964', 'João Goulart', 'Governo marcado pela fase parlamentarista, retorno ao presidencialismo e Reformas de Base', 'alta', 1961, 1964);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1964-humberto-castelo-branco-1', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1964–1967', 'Humberto Castelo Branco', 'Primeiro general-presidente após o golpe civil-militar de 1964; edição do AI-1 e AI-2', 'alta', 1964, 1967);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1967-arthur-da-costa-e-silva-2', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1967–1969', 'Arthur da Costa e Silva', 'Promulgação da Constituição de 1967 e edição do AI-5; afastado por problemas de saúde', 'alta', 1967, 1969);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1969-junta-militar-de-1969-3', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1969', 'Junta Militar de 1969', 'Triunvirato das Forças Armadas no comando executivo até a posse de Médici', 'media', 1969, 1969);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1969-emilio-garrastazu-medici-4', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1969–1974', 'Emílio Garrastazu Médici', 'Período dos Anos de Chumbo, forte repressão política e o chamado Milagre Econômico', 'alta', 1969, 1974);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1974-ernesto-geisel-5', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1974–1979', 'Ernesto Geisel', 'Início do processo de abertura política lenta, gradual e segura; revogação do AI-5', 'alta', 1974, 1979);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1979-joao-figueiredo-6', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1979–1985', 'João Figueiredo', 'Concessão da Lei da Anistia, fim do bipartidarismo e transição para o poder civil', 'alta', 1979, 1985);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1985-jose-sarney-7', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1985–1990', 'José Sarney', 'Início da Nova República; redemocratização, Assembleia Constituinte de 1988 e Plano Cruzado', 'alta', 1985, 1990);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1990-fernando-collor-de-mello-8', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1990–1992', 'Fernando Collor de Mello', 'Primeiro eleito por voto direto pós-1960; abertura de mercado e processo de impeachment', 'alta', 1990, 1992);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1992-itamar-franco-9', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1992–1995', 'Itamar Franco', 'Conduziu a transição após a queda de Collor e o lançamento vitorioso do Plano Real', 'alta', 1992, 1995);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-1995-fernando-henrique-cardoso-10', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '1995–2003', 'Fernando Henrique Cardoso', 'Consolidação da estabilidade monetária, privatizações e instituição da reeleição', 'alta', 1995, 2003);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-2003-luiz-inacio-lula-da-silva-11', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '2003–2011', 'Luiz Inácio Lula da Silva', 'Programas de transferência de renda, crescimento via commodities e expansão do consumo', 'alta', 2003, 2011);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-2011-dilma-rousseff-12', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '2011–2016', 'Dilma Rousseff', 'Primeira mulher presidente; recessão econômica, protestos de 2013 e processo de impeachment', 'alta', 2011, 2016);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-2016-michel-temer-13', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '2016–2018', 'Michel Temer', 'Assumiu após impeachment; aprovação do Teto de Gastos e Reforma Trabalhista', 'alta', 2016, 2018);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-2019-jair-bolsonaro-14', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '2019–2022', 'Jair Bolsonaro', 'Gestão conservadora, desregulamentação, pandemia de COVID-19 e privatização da Eletrobras', 'alta', 2019, 2022);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-governant-2023-luiz-inacio-lula-da-silva-15', 'lt-governantes-do-brasil-ditadura-militar-e-nova-r', '2023–2026', 'Luiz Inácio Lula da Silva', 'Terceiro mandato presidencial de Lula, focado em reinserção externa e política fiscal', 'alta', 2023, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1769-veiculo-a-vapor-de-cugnot-1', 'lt-tecnologia-transporte', '1769', 'Veículo a Vapor de Cugnot', 'Primeiro protótipo funcional de carruagem autopropelida a vapor', 'media', 1769, 1769);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1804-primeira-locomotiva-a-vap-2', 'lt-tecnologia-transporte', '1804', 'Primeira Locomotiva a Vapor', 'Richard Trevithick demonstra tração mecânica ferroviária no País de Gales', 'alta', 1804, 1804);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1807-navio-a-vapor-comercial-3', 'lt-tecnologia-transporte', '1807', 'Navio a Vapor Comercial', 'Robert Fulton opera o barco Clermont comercialmente no Rio Hudson', 'alta', 1807, 1807);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1817-bicicleta-primitiva-drais-4', 'lt-tecnologia-transporte', '1817', 'Bicicleta Primitiva (Draisine)', 'Karl Drais patenteia a máquina de caminhar sem pedais', 'media', 1817, 1817);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1863-primeiro-metro-do-mundo-5', 'lt-tecnologia-transporte', '1863', 'Primeiro Metrô do Mundo', 'Inauguração do trecho subterrâneo a vapor do Metropolitan Railway em Londres', 'alta', 1863, 1863);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1886-automovel-a-combustao-int-6', 'lt-tecnologia-transporte', '1886', 'Automóvel a Combustão Interna', 'Karl Benz patenteia o Benz Patent-Motorwagen movido a gasolina', 'alta', 1886, 1886);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1885-primeira-motocicleta-7', 'lt-tecnologia-transporte', '1885', 'Primeira Motocicleta', 'Gottlieb Daimler cria a Reitwagen com motor a combustão interna', 'media', 1885, 1885);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1906-voo-do-14-bis-8', 'lt-tecnologia-transporte', '1906', 'Voo do 14-Bis', 'Santos Dumont realiza o primeiro voo homologado de aparelho mais pesado que o ar sem catapulta', 'alta', 1906, 1906);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1939-primeiro-helicoptero-func-9', 'lt-tecnologia-transporte', '1939', 'Primeiro Helicóptero Funcional', 'Igor Sikorsky testa com sucesso o helicóptero VS-300', 'alta', 1939, 1939);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1944-primeiro-foguete-espacial-10', 'lt-tecnologia-transporte', '1944', 'Primeiro Foguete Espacial (V-2)', 'O foguete balístico V-2 alemão cruza a linha de Kármán (100 km de altitude)', 'alta', 1944, 1944);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1957-primeiro-satelite-artific-11', 'lt-tecnologia-transporte', '1957', 'Primeiro Satélite Artificial', 'Lançamento do Sputnik 1 pela União Soviética', 'alta', 1957, 1957);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1964-primeiro-trem-de-alta-vel-12', 'lt-tecnologia-transporte', '1964', 'Primeiro Trem de Alta Velocidade', 'Inauguração da linha Shinkansen (Tokaido) entre Tóquio e Osaka', 'alta', 1964, 1964);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1969-chegada-do-homem-a-lua-13', 'lt-tecnologia-transporte', '1969', 'Chegada do Homem à Lua', 'Missão Apollo 11 transporta Neil Armstrong e Buzz Aldrin à superfície lunar', 'alta', 1969, 1969);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1978-lancamento-do-primeiro-sa-14', 'lt-tecnologia-transporte', '1978', 'Lançamento do Primeiro Satélite GPS', 'Início da constelação Navstar do Departamento de Defesa dos EUA', 'alta', 1978, 1978);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2008-veiculo-eletrico-moderno-15', 'lt-tecnologia-transporte', '2008', 'Veículo Elétrico Moderno de Longo Alcance', 'Tesla Motors lança o modelo esportivo Tesla Roadster com baterias de íon-lítio', 'alta', 2008, 2008);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi--3200-invencao-da-escrita-1', 'lt-tecnologia-comunicacao', '3200 a.C.', 'Invenção da Escrita', 'Desenvolvimento da escrita cuneiforme na Mesopotâmia e hieróglifos no Egito', 'alta', -3200, -3200);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1440-prensa-movel-de-gutenberg-2', 'lt-tecnologia-comunicacao', '1440–1450', 'Prensa Móvel de Gutenberg', 'Invenção dos tipos móveis metálicos revolucionando a reprodução de livros', 'alta', 1440, 1450);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1837-telegrafo-eletrico-3', 'lt-tecnologia-comunicacao', '1837–1844', 'Telégrafo Elétrico', 'Samuel Morse patenteia o código e envia a primeira mensagem telegráfica oficial', 'alta', 1837, 1844);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1876-invencao-do-telefone-4', 'lt-tecnologia-comunicacao', '1876', 'Invenção do Telefone', 'Alexander Graham Bell registra a patente do transmissor eletromagnético de voz', 'alta', 1876, 1876);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1895-telegrafia-sem-fio-radio-5', 'lt-tecnologia-comunicacao', '1895–1896', 'Telegrafia sem Fio (Rádio)', 'Guglielmo Marconi demonstra transmissões de sinais via ondas eletromagnéticas', 'alta', 1895, 1896);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1927-televisao-eletronica-6', 'lt-tecnologia-comunicacao', '1927', 'Televisão Eletrônica', 'Philo Farnsworth transmite a primeira imagem por tubo de feixe de elétrons', 'alta', 1927, 1927);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1962-primeiro-satelite-ativo-d-7', 'lt-tecnologia-comunicacao', '1962', 'Primeiro Satélite Ativo de Comunicações', 'Telstar 1 viabiliza a primeira transmissão de televisão ao vivo transatlântica', 'alta', 1962, 1962);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1964-aparelho-de-fax-moderno-8', 'lt-tecnologia-comunicacao', '1964', 'Aparelho de Fax Moderno', 'Lançamento do primeiro aparelho de fax de mesa pela Xerox', 'media', 1964, 1964);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1973-primeira-ligacao-de-celul-9', 'lt-tecnologia-comunicacao', '1973', 'Primeira Ligação de Celular', 'Martin Cooper realiza a primeira ligação de um telefone móvel portátil Motorola', 'alta', 1973, 1973);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1989-criacao-da-world-wide-web-10', 'lt-tecnologia-comunicacao', '1989–1991', 'Criação da World Wide Web', 'Tim Berners-Lee propõe os protocolos HTTP e HTML no CERN', 'alta', 1989, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1992-envio-do-primeiro-sms-11', 'lt-tecnologia-comunicacao', '1992', 'Envio do Primeiro SMS', 'Neil Papworth envia a mensagem ''Merry Christmas'' de um computador a um celular', 'media', 1992, 1992);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2004-disseminacao-de-redes-soc-12', 'lt-tecnologia-comunicacao', '2004', 'Disseminação de Redes Sociais Globais', 'Lançamento do TheFacebook, inaugurando a era das plataformas de redes sociais de massa', 'alta', 2004, 2004);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2007-lancamento-do-iphone-13', 'lt-tecnologia-comunicacao', '2007', 'Lançamento do iPhone', 'Apple introduz a interface multitouch consolidando o smartphone moderno', 'alta', 2007, 2007);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2011-popularizacao-da-videocon-14', 'lt-tecnologia-comunicacao', '2011', 'Popularização da Videoconferência em Nuvem', 'Fundação e disseminação da plataforma Zoom Video Communications', 'media', 2011, 2011);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2022-disseminacao-de-interface-15', 'lt-tecnologia-comunicacao', '2022', 'Disseminação de Interfaces de IA de Diálogo', 'Lançamento do ChatGPT inaugurando interação conversacional em larga escala', 'alta', 2022, 2022);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1837-maquina-analitica-de-babb-1', 'lt-tecnologia-computacao', '1837', 'Máquina Analítica de Babbage', 'Primeiro projeto mecânico conceitual de um computador programável de uso geral', 'alta', 1837, 1837);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1936-conceito-da-maquina-de-tu-2', 'lt-tecnologia-computacao', '1936', 'Conceito da Máquina de Turing', 'Alan Turing publica artigo formulando os fundamentos da computação universal', 'alta', 1936, 1936);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1941-z3-de-konrad-zuse-3', 'lt-tecnologia-computacao', '1941', 'Z3 de Konrad Zuse', 'Primeiro computador digital eletromecânico totalmente programável e automático', 'media', 1941, 1941);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1945-computador-eniac-4', 'lt-tecnologia-computacao', '1945–1946', 'Computador ENIAC', 'Primeiro computador digital eletrônico de grande escala para cálculo militar', 'alta', 1945, 1946);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1947-invencao-do-transistor-5', 'lt-tecnologia-computacao', '1947', 'Invenção do Transistor', 'John Bardeen, Walter Brattain e William Shockley no Bell Labs criam o transistor', 'alta', 1947, 1947);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1958-invencao-do-circuito-inte-6', 'lt-tecnologia-computacao', '1958–1959', 'Invenção do Circuito Integrado', 'Jack Kilby e Robert Noyce criam chips integrando múltiplos componentes', 'alta', 1958, 1959);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1964-mainframe-ibm-system360-7', 'lt-tecnologia-computacao', '1964', 'Mainframe IBM System/360', 'Padronização arquitetural corporativa com suporte a famílias inteiras de computadores', 'alta', 1964, 1964);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1971-primeiro-microprocessador-8', 'lt-tecnologia-computacao', '1971', 'Primeiro Microprocessador Comercial', 'Intel lança o processador Intel 4004 de 4 bits em um único chip', 'alta', 1971, 1971);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1977-computador-pessoal-apple-9', 'lt-tecnologia-computacao', '1977–1981', 'Computador Pessoal (Apple II e IBM PC)', 'Computadores saem de laboratórios rumo ao consumo doméstico e empresarial', 'alta', 1977, 1981);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2006-computacao-em-nuvem-comer-10', 'lt-tecnologia-computacao', '2006', 'Computação em Nuvem Comercial', 'Amazon Web Services lança o EC2 e o S3, iniciando a era de infraestrutura como serviço', 'alta', 2006, 2006);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2007-computacao-acelerada-por-11', 'lt-tecnologia-computacao', '2007', 'Computação Acelerada por GPU (CUDA)', 'Nvidia lança a arquitetura CUDA viabilizando processamento paralelo massivo', 'media', 2007, 2007);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2012-salto-em-deep-learning-al-12', 'lt-tecnologia-computacao', '2012', 'Salto em Deep Learning (AlexNet)', 'Rede neural convolucional vence a ImageNet, desencadeando a corrida do aprendizado profundo', 'alta', 2012, 2012);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2017-arquitetura-transformer-13', 'lt-tecnologia-computacao', '2017', 'Arquitetura Transformer', 'Publicação do artigo ''Attention Is All You Need'' pelo Google, alicerce dos LLMs', 'alta', 2017, 2017);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-2019-demonstracao-de-supremaci-14', 'lt-tecnologia-computacao', '2019', 'Demonstração de Supremacia Quântica', 'Processador Sycamore do Google resolve em minutos cálculo impraticável para supercomputadores', 'alta', 2019, 2019);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1796-primeira-vacina-variola-1', 'lt-ciencia-medicina-e-saude', '1796', 'Primeira Vacina (Varíola)', 'Edward Jenner utiliza vírus da varíola bovina para imunizar humanos', 'alta', 1796, 1796);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1846-primeira-anestesia-cirurg-2', 'lt-ciencia-medicina-e-saude', '1846', 'Primeira Anestesia Cirúrgica com Éter', 'William Morton demonstra o uso do éter sulfúrico no Massachusetts General Hospital', 'alta', 1846, 1846);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1867-introducao-da-antissepsia-3', 'lt-ciencia-medicina-e-saude', '1867', 'Introdução da Antissepsia Médica', 'Joseph Lister utiliza ácido fênico reduzindo mortes cirúrgicas por infecção', 'alta', 1867, 1867);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1876-teoria-microbiana-das-doe-4', 'lt-ciencia-medicina-e-saude', '1876–1884', 'Teoria Microbiana das Doenças', 'Louis Pasteur e Robert Koch isolam bactérias e comprovam que germes causam enfermidades', 'alta', 1876, 1884);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1895-descoberta-dos-raios-x-5', 'lt-ciencia-medicina-e-saude', '1895', 'Descoberta dos Raios-X', 'Wilhelm Röntgen descobre radiação eletromagnética que permite radiografar ossos humanos', 'alta', 1895, 1895);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1921-isolamento-e-aplicacao-da-6', 'lt-ciencia-medicina-e-saude', '1921–1922', 'Isolamento e Aplicação da Insulina', 'Frederick Banting e Charles Best purificam a insulina para tratamento de diabetes', 'alta', 1921, 1922);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1928-descoberta-da-penicilina-7', 'lt-ciencia-medicina-e-saude', '1928', 'Descoberta da Penicilina', 'Alexander Fleming descobre propriedades antibacterianas do fungo Penicillium notatum', 'alta', 1928, 1928);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1953-descoberta-da-estrutura-d-8', 'lt-ciencia-medicina-e-saude', '1953', 'Descoberta da Estrutura do DNA', 'James Watson, Francis Crick e Rosalind Franklin decifram a dupla hélice', 'alta', 1953, 1953);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1960-pilula-anticoncepcional-9', 'lt-ciencia-medicina-e-saude', '1960', 'Pílula Anticoncepcional', 'Aprovação do primeiro contraceptivo oral pela FDA revolucionando os direitos reprodutivos', 'alta', 1960, 1960);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1967-primeiro-transplante-de-c-10', 'lt-ciencia-medicina-e-saude', '1967', 'Primeiro Transplante de Coração', 'Christiaan Barnard realiza o primeiro transplante cardíaco humano na África do Sul', 'alta', 1967, 1967);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1978-primeiro-bebe-de-fertiliz-11', 'lt-ciencia-medicina-e-saude', '1978', 'Primeiro Bebê de Fertilização In Vitro', 'Nascimento de Louise Brown no Reino Unido viabilizado por Robert Edwards', 'alta', 1978, 1978);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1983-invencao-da-tecnica-de-pc-12', 'lt-ciencia-medicina-e-saude', '1983', 'Invenção da Técnica de PCR', 'Kary Mullis desenvolve a reação em cadeia da polimerase para replicar DNA', 'alta', 1983, 1983);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-1990-projeto-genoma-humano-13', 'lt-ciencia-medicina-e-saude', '1990–2003', 'Projeto Genoma Humano', 'Consórcio científico internacional sequencia 99% do genoma humano com precisão', 'alta', 1990, 2003);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-2012-edicao-genetica-via-crisp-14', 'lt-ciencia-medicina-e-saude', '2012', 'Edição Genética via CRISPR-Cas9', 'Jennifer Doudna e Emmanuelle Charpentier demonstram mecanismo preciso de edição gênica', 'alta', 2012, 2012);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-m-2020-primeiras-vacinas-de-rna-15', 'lt-ciencia-medicina-e-saude', '2020', 'Primeiras Vacinas de RNA Mensageiro', 'Aprovação emergencial de vacinas com plataforma de mRNA contra a COVID-19', 'alta', 2020, 2020);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1769-aperfeicoamento-da-maquin-1', 'lt-tecnologia-energia', '1769', 'Aperfeiçoamento da Máquina a Vapor', 'James Watt patenteia o condensador separado multiplicando o rendimento energético', 'alta', 1769, 1769);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1821-inducao-eletromagnetica-e-2', 'lt-tecnologia-energia', '1821–1831', 'Indução Eletromagnética e Motor Elétrico', 'Michael Faraday descobre princípios de indução e rotatividade elétrica contínua', 'alta', 1821, 1831);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1876-motor-de-combustao-de-qua-3', 'lt-tecnologia-energia', '1876', 'Motor de Combustão de Quatro Tempos', 'Nikolaus Otto projeta o motor de ciclo a combustão interna a gasolina', 'alta', 1876, 1876);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1882-primeira-usina-eletrica-c-4', 'lt-tecnologia-energia', '1882', 'Primeira Usina Elétrica Comercial', 'Thomas Edison inaugura a estação geradora de corrente contínua em Pearl Street, NY', 'alta', 1882, 1882);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1882-primeira-usina-hidreletri-5', 'lt-tecnologia-energia', '1882', 'Primeira Usina Hidrelétrica do Mundo', 'Entrada em operação da usina de Fox River em Appleton, Wisconsin', 'alta', 1882, 1882);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1892-patente-do-motor-diesel-6', 'lt-tecnologia-energia', '1892', 'Patente do Motor Diesel', 'Rudolf Diesel desenvolve motor térmico com ignição por compressão de ar', 'media', 1892, 1892);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1942-primeiro-reator-nuclear-c-7', 'lt-tecnologia-energia', '1942', 'Primeiro Reator Nuclear (Chicago Pile-1)', 'Enrico Fermi lidera a produção da primeira reação nuclear em cadeia autossustentada', 'alta', 1942, 1942);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1954-primeira-celula-solar-de-8', 'lt-tecnologia-energia', '1954', 'Primeira Célula Solar de Silício', 'Bell Labs projeta célula fotovoltaica viável com conversão de 6% da luz solar', 'alta', 1954, 1954);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1980-primeira-fazenda-eolica-m-9', 'lt-tecnologia-energia', '1980', 'Primeira Fazenda Eólica Moderna', 'Instalação do primeiro parque de turbinas eólicas em New Hampshire, EUA', 'media', 1980, 1980);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-tecnologi-1985-bateria-de-ion-de-litio-10', 'lt-tecnologia-energia', '1985–1991', 'Bateria de Íon de Lítio', 'Goodenough, Whittingham e Yoshino viabilizam baterias recarregáveis de alta densidade', 'alta', 1985, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1543-teoria-heliocentrica-de-c-1', 'lt-ciencia-astronomia-e-fisica', '1543', 'Teoria Heliocêntrica de Copérnico', 'Publicação de ''De revolutionibus orbium coelestium'' tirando a Terra do centro cósmico', 'alta', 1543, 1543);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1609-leis-de-kepler-do-movimen-2', 'lt-ciencia-astronomia-e-fisica', '1609–1619', 'Leis de Kepler do Movimento Planetário', 'Johannes Kepler formula leis que definem órbitas elípticas e variações de velocidade', 'alta', 1609, 1619);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1609-observacoes-telescopicas-3', 'lt-ciencia-astronomia-e-fisica', '1609–1610', 'Observações Telescópicas de Galileu', 'Galileu Galilei descobre luas de Júpiter, crateras lunares e fases de Vênus', 'alta', 1609, 1610);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1687-gravitacao-universal-e-le-4', 'lt-ciencia-astronomia-e-fisica', '1687', 'Gravitação Universal e Leis do Movimento', 'Isaac Newton publica o ''Principia'', estabelecendo a mecânica clássica', 'alta', 1687, 1687);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1824-formulacao-da-termodinami-5', 'lt-ciencia-astronomia-e-fisica', '1824–1850', 'Formulação da Termodinâmica', 'Nicolas Carnot, Rudolf Clausius e Lord Kelvin estruturam as leis de calor e entropia', 'alta', 1824, 1850);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1865-eletromagnetismo-classico-6', 'lt-ciencia-astronomia-e-fisica', '1865', 'Eletromagnetismo Clássico', 'James Clerk Maxwell publica equações unificando eletricidade, magnetismo e luz', 'alta', 1865, 1865);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1900-hipotese-quantica-de-plan-7', 'lt-ciencia-astronomia-e-fisica', '1900', 'Hipótese Quântica de Planck', 'Max Planck propõe que a energia é irradiada e absorvida em pacotes discretos (quanta)', 'alta', 1900, 1900);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1905-teoria-da-relatividade-es-8', 'lt-ciencia-astronomia-e-fisica', '1905–1915', 'Teoria da Relatividade Especial e Geral', 'Albert Einstein redefine conceitos de espaço, tempo, massa, gravidade e aceleração', 'alta', 1905, 1915);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1925-mecanica-quantica-matrici-9', 'lt-ciencia-astronomia-e-fisica', '1925–1927', 'Mecânica Quântica Matricial e Ondulatória', 'Heisenberg, Schrödinger e Bohr estabelecem a física quântica probabilística', 'alta', 1925, 1927);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1929-expansao-do-universo-lei-10', 'lt-ciencia-astronomia-e-fisica', '1929', 'Expansão do Universo (Lei de Hubble)', 'Edwin Hubble demonstra que galáxias distantes se afastam proporcionalmente à distância', 'alta', 1929, 1929);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1931-teoria-do-atomo-primordia-11', 'lt-ciencia-astronomia-e-fisica', '1931', 'Teoria do Átomo Primordial (Big Bang)', 'Georges Lemaître propõe a origem expansiva do universo a partir de um ponto singular', 'alta', 1931, 1931);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1965-descoberta-da-radiacao-co-12', 'lt-ciencia-astronomia-e-fisica', '1965', 'Descoberta da Radiação Cósmica de Fundo', 'Arno Penzias e Robert Wilson confirmam experimentalmente o eco residual do Big Bang', 'alta', 1965, 1965);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1974-consolidacao-do-modelo-pa-13', 'lt-ciencia-astronomia-e-fisica', '1974', 'Consolidação do Modelo Padrão de Partículas', 'Estruturação da teoria das partículas fundamentais (quarks, léptons e bósons)', 'alta', 1974, 1974);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-1995-descoberta-do-primeiro-ex-14', 'lt-ciencia-astronomia-e-fisica', '1995', 'Descoberta do Primeiro Exoplaneta', 'Michel Mayor e Didier Queloz descobrem planeta orbitando a estrela 51 Pegasi', 'alta', 1995, 1995);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-a-2015-deteccao-de-ondas-gravita-15', 'lt-ciencia-astronomia-e-fisica', '2015–2016', 'Detecção de Ondas Gravitacionais', 'Observatório LIGO registra deformações do espaço-tempo causadas pela fusão de buracos negros', 'alta', 2015, 2016);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1735-sistema-de-classificacao-1', 'lt-ciencia-biologia-e-evolucao', '1735', 'Sistema de Classificação de Lineu', 'Carl von Linné publica o ''Systema Naturae'', criando a nomenclatura binomial biológica', 'alta', 1735, 1735);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1859-teoria-da-evolucao-por-se-2', 'lt-ciencia-biologia-e-evolucao', '1859', 'Teoria da Evolução por Seleção Natural', 'Charles Darwin publica ''A Origem das Espécies'' fundamentando a ancestralidade comum', 'alta', 1859, 1859);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1866-leis-da-hereditariedade-d-3', 'lt-ciencia-biologia-e-evolucao', '1866', 'Leis da Hereditariedade de Mendel', 'Gregor Mendel estabelece os princípios básicos de dominância e segregação genética', 'alta', 1866, 1866);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1910-teoria-cromossomica-da-he-4', 'lt-ciencia-biologia-e-evolucao', '1910', 'Teoria Cromossômica da Hereditariedade', 'Thomas Hunt Morgan comprova que os genes residem fisicamente em cromossomos', 'alta', 1910, 1910);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1944-dna-como-portador-da-info-5', 'lt-ciencia-biologia-e-evolucao', '1944', 'DNA como Portador da Informação Genética', 'Experimento de Avery-MacLeod-McCarty comprova que o DNA carrega o material hereditário', 'alta', 1944, 1944);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-b-1977-metodo-de-sequenciamento-6', 'lt-ciencia-biologia-e-evolucao', '1977', 'Método de Sequenciamento de DNA', 'Frederick Sanger cria o método de terminação por dideoxinucleotídeos', 'alta', 1977, 1977);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e---2100-epopeia-de-gilgamesh-1', 'lt-livros-e-literatura-fundamental', '2100 a.C.–1200 a.C.', 'Epopeia de Gilgamesh', 'Um dos primeiros poemas épicos da humanidade registrado em tabuletas de argila', 'alta', -2100, -1200);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e---750-iliada-e-odisseia-de-home-2', 'lt-livros-e-literatura-fundamental', '750 a.C.–700 a.C.', 'Ilíada e Odisseia de Homero', 'Épicos gregos sobre a Guerra de Troia e o retorno do guerreiro Odisseu', 'alta', -750, -700);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e---29-eneida-de-virgilio-3', 'lt-livros-e-literatura-fundamental', '29 a.C.–19 a.C.', 'Eneida de Virgílio', 'Poema épico latino que mitifica as origens divinas e históricas de Roma', 'alta', -29, -19);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1308-divina-comedia-de-dante-a-4', 'lt-livros-e-literatura-fundamental', '1308–1320', 'Divina Comédia de Dante Alighieri', 'Épico em língua toscana estruturado na viagem pelo Inferno, Purgatório e Paraíso', 'alta', 1308, 1320);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1601-hamlet-de-william-shakesp-5', 'lt-livros-e-literatura-fundamental', '1601', 'Hamlet de William Shakespeare', 'Tragédia existencial sobre vingança, poder e dúvida no Castelo de Elsinore', 'alta', 1601, 1601);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1605-dom-quixote-de-miguel-de-6', 'lt-livros-e-literatura-fundamental', '1605–1615', 'Dom Quixote de Miguel de Cervantes', 'Romance seminal sobre a loucura idealista e sátira da cavalaria medieval', 'alta', 1605, 1615);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1543-de-revolutionibus-orbium-7', 'lt-livros-e-literatura-fundamental', '1543', 'De revolutionibus orbium coelestium', 'Nicolau Copérnico estabelece as bases matemáticas e teóricas do heliocentrismo', 'alta', 1543, 1543);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1687-philosophiae-naturalis-pr-8', 'lt-livros-e-literatura-fundamental', '1687', 'Philosophiae Naturalis Principia Mathematica', 'Isaac Newton publica a formulação matemática da gravidade e as três leis da dinâmica', 'alta', 1687, 1687);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1859-a-origem-das-especies-9', 'lt-livros-e-literatura-fundamental', '1859', 'A Origem das Espécies', 'Charles Darwin expõe formalmente as evidências científicas da seleção natural', 'alta', 1859, 1859);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1905-sobre-a-eletrodinamica-do-10', 'lt-livros-e-literatura-fundamental', '1905', 'Sobre a Eletrodinâmica dos Corpos em Movimento', 'Artigo de Einstein no Annalen der Physik inaugurando a Teoria da Relatividade Restrita', 'alta', 1905, 1905);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1769-o-uraguai-1', 'lt-livros-e-literatura-brasil', '1769', 'O Uraguai', 'Poema épico do Arcadismo escrito por Basílio da Gama sobre as Guerras Guaraníticas', 'media', 1769, 1769);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1865-iracema-2', 'lt-livros-e-literatura-brasil', '1865', 'Iracema', 'Romance indianista do Romantismo escrito por José de Alencar, a virgem dos lábios de mel', 'alta', 1865, 1865);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1881-memorias-postumas-de-bras-3', 'lt-livros-e-literatura-brasil', '1881', 'Memórias Póstumas de Brás Cubas', 'Machado de Assis inaugura o Realismo brasileiro com o narrador defunto autor', 'alta', 1881, 1881);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1899-dom-casmurro-4', 'lt-livros-e-literatura-brasil', '1899', 'Dom Casmurro', 'Obra-prima realista de Machado de Assis com o conflito sobre Capitu e Bentinho', 'alta', 1899, 1899);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1902-os-sertoes-5', 'lt-livros-e-literatura-brasil', '1902', 'Os Sertões', 'Euclides da Cunha combina análise sociológica, geográfica e reportagem da Guerra de Canudos', 'alta', 1902, 1902);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1922-pauliceia-desvairada-6', 'lt-livros-e-literatura-brasil', '1922', 'Pauliceia Desvairada', 'Livro de poemas de Mário de Andrade que deflagra a estética do Modernismo brasileiro', 'alta', 1922, 1922);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1938-vidas-secas-7', 'lt-livros-e-literatura-brasil', '1938', 'Vidas Secas', 'Romance do Modernismo regionalista de Graciliano Ramos sobre retirantes no sertão', 'alta', 1938, 1938);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-livros-e--1956-grande-sertao-veredas-8', 'lt-livros-e-literatura-brasil', '1956', 'Grande Sertão: Veredas', 'Obra monumental de João Guimarães Rosa explorando a travessia e metafísica dos jagunços', 'alta', 1956, 1956);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e--499-guerras-greco-persicas-1', 'lt-guerras-e-conflitos-mundo', '499 a.C.–449 a.C.', 'Guerras Greco-Pérsicas', 'Conflitos entre cidades-Estado gregas e o Império Aquemênida (Maratona, Termópilas, Salamina)', 'alta', -499, -449);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e--264-guerras-punicas-2', 'lt-guerras-e-conflitos-mundo', '264 a.C.–146 a.C.', 'Guerras Púnicas', 'Três conflitos entre a República Romana e Cartago pela hegemonia no Mar Mediterrâneo', 'alta', -264, -146);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1803-guerras-napoleonicas-3', 'lt-guerras-e-conflitos-mundo', '1803–1815', 'Guerras Napoleônicas', 'Campanhas militares da França imperial contra diversas coalizões monárquicas europeias', 'alta', 1803, 1815);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1861-guerra-civil-americana-4', 'lt-guerras-e-conflitos-mundo', '1861–1865', 'Guerra Civil Americana', 'Conflito armado entre a União e os Estados Confederados do Sul escravista', 'alta', 1861, 1865);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1914-primeira-guerra-mundial-5', 'lt-guerras-e-conflitos-mundo', '1914–1918', 'Primeira Guerra Mundial', 'Trincheiras, armas químicas e mobilização industrial na Europa e Oriente Médio', 'alta', 1914, 1918);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1939-segunda-guerra-mundial-6', 'lt-guerras-e-conflitos-mundo', '1939–1945', 'Segunda Guerra Mundial', 'Invasão da Polônia, expansão nazista, front oriental, Guerra no Pacífico e armas atômicas', 'alta', 1939, 1945);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1950-guerra-da-coreia-7', 'lt-guerras-e-conflitos-mundo', '1950–1953', 'Guerra da Coreia', 'Primeiro grande conflito armado por procuração da Guerra Fria; divisão na península no Paralelo 38', 'alta', 1950, 1953);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1955-guerra-do-vietna-8', 'lt-guerras-e-conflitos-mundo', '1955–1975', 'Guerra do Vietnã', 'Resistência do Vietnã do Norte e vietcongues contra forças do Vietnã do Sul e EUA', 'alta', 1955, 1975);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1990-guerra-do-golfo-9', 'lt-guerras-e-conflitos-mundo', '1990–1991', 'Guerra do Golfo', 'Coalizão liderada pelos EUA repele a invasão e anexação do Kuwait pelo Iraque', 'alta', 1990, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-2001-guerra-do-afeganistao-10', 'lt-guerras-e-conflitos-mundo', '2001–2021', 'Guerra do Afeganistão', 'Invasão liderada pelos EUA após o 11 de Setembro e saída em 2021 com retorno do Talibã', 'alta', 2001, 2021);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1835-guerra-dos-farrapos-revol-1', 'lt-guerras-e-conflitos-brasil', '1835–1845', 'Guerra dos Farrapos (Revolução Farroupilha)', 'Rebelião republicana separatista no Rio Grande do Sul contra o governo regencial', 'alta', 1835, 1845);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1864-guerra-do-paraguai-2', 'lt-guerras-e-conflitos-brasil', '1864–1870', 'Guerra do Paraguai', 'Tríplice Aliança (Brasil, Argentina e Uruguai) enfrenta as forças paraguaias de Solano López', 'alta', 1864, 1870);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1896-guerra-de-canudos-3', 'lt-guerras-e-conflitos-brasil', '1896–1897', 'Guerra de Canudos', 'Exército brasileiro destrói a comunidade messiânica de Antônio Conselheiro na Bahia', 'alta', 1896, 1897);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1912-guerra-do-contestado-4', 'lt-guerras-e-conflitos-brasil', '1912–1916', 'Guerra do Contestado', 'Conflito social armado entre sertanejos messiânicos e forças policiais/federais em SC e PR', 'alta', 1912, 1916);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1930-revolucao-de-1930-5', 'lt-guerras-e-conflitos-brasil', '1930', 'Revolução de 1930', 'Movimento armado liderado pela Aliança Liberal que derrubou a República Velha e empossou Vargas', 'alta', 1930, 1930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1932-revolucao-constitucionali-6', 'lt-guerras-e-conflitos-brasil', '1932', 'Revolução Constitucionalista de 1932', 'Insurreição armada paulista exigindo uma nova Constituição e eleições livres', 'alta', 1932, 1932);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-guerras-e-1964-golpe-militar-de-1964-7', 'lt-guerras-e-conflitos-brasil', '1964', 'Golpe Militar de 1964', 'Deposição armada do presidente João Goulart e implantação do regime militar no Brasil', 'alta', 1964, 1964);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--1800-periodo-dos-patriarcas-bi-1', 'lt-religioes-e-historia-religiosa', '1800 a.C.–1500 a.C.', 'Período dos Patriarcas Bíblicos', 'Tradições patriarcais de Abraão, Isaque e Jacó no Levante / Canaã', 'alta', -1800, -1500);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--1250-exodo-do-egito-2', 'lt-religioes-e-historia-religiosa', '1250 a.C.', 'Êxodo do Egito', 'Tradição da libertação dos hebreus do Egito e estabelecimento da Aliança no Sinai', 'alta', -1250, -1250);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--1000-reino-unido-de-israel-3', 'lt-religioes-e-historia-religiosa', '1000 a.C.–930 a.C.', 'Reino Unido de Israel', 'Monarquia unificada sob os governos de Saul, Davi e Salomão; construção do 1º Templo', 'alta', -1000, -930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--930-cisao-monarquica-israel-e-4', 'lt-religioes-e-historia-religiosa', '930 a.C.', 'Cisão Monárquica (Israel e Judá)', 'Divisão política após a morte de Salomão em Reino do Norte (Israel) e do Sul (Judá)', 'alta', -930, -930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--722-queda-do-reino-do-norte-s-5', 'lt-religioes-e-historia-religiosa', '722 a.C.', 'Queda do Reino do Norte (Samaria)', 'Conquista e dispersão das dez tribos do Norte pelo Império Assírio', 'alta', -722, -722);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--586-exilio-babilonico-6', 'lt-religioes-e-historia-religiosa', '586 a.C.–538 a.C.', 'Exílio Babilônico', 'Destruição de Jerusalém e do 1º Templo por Nabucodonosor II; cativeiro na Babilônia', 'alta', -586, -538);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--516-periodo-do-segundo-templo-7', 'lt-religioes-e-historia-religiosa', '516 a.C.–70 d.C.', 'Período do Segundo Templo', 'Reconstrução do Templo sob domínio persa até a destruição definitiva pelos romanos', 'alta', -516, 70);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes--4-nascimento-de-jesus-de-na-8', 'lt-religioes-e-historia-religiosa', '4 a.C.', 'Nascimento de Jesus de Nazaré', 'Estimativa histórica convencional para a natividade na Judeia', 'alta', -4, -4);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-30-crucificacao-de-jesus-9', 'lt-religioes-e-historia-religiosa', '30 d.C.–33 d.C.', 'Crucificação de Jesus', 'Morte de Jesus em Jerusalém e nascimento das primeiras comunidades apostólicas cristãs', 'alta', 30, 33);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-64-perseguicao-aos-cristaos-10', 'lt-religioes-e-historia-religiosa', '64 d.C.', 'Perseguição aos Cristãos sob Nero', 'Primeiro massacre sistemático de cristãos em Roma após o grande incêndio', 'alta', 64, 64);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-70-destruicao-de-jerusalem-11', 'lt-religioes-e-historia-religiosa', '70 d.C.', 'Destruição de Jerusalém', 'Legiões romanas comandadas por Tito destroem o Templo e dispersam a população judaica', 'alta', 70, 70);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-313-edito-de-milao-12', 'lt-religioes-e-historia-religiosa', '313', 'Edito de Milão', 'Imperadores Constantino e Licínio concedem liberdade religiosa aos cristãos no Império Romano', 'alta', 313, 313);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-325-primeiro-concilio-de-nice-13', 'lt-religioes-e-historia-religiosa', '325', 'Primeiro Concílio de Niceia', 'Primeiro concílio ecumênico convocado por Constantino para unificar o dogma da Trindade', 'alta', 325, 325);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-622-a-hegira-e-inicio-da-era-14', 'lt-religioes-e-historia-religiosa', '622', 'A Hégira e Início da Era Islâmica', 'Maomé e seguidores migram de Meca para Medina; marco zero do calendário muçulmano', 'alta', 622, 622);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-1054-grande-cisma-do-oriente-15', 'lt-religioes-e-historia-religiosa', '1054', 'Grande Cisma do Oriente', 'Ruptura mútua e excomunhão entre a Igreja Católica Romana e a Igreja Ortodoxa', 'alta', 1054, 1054);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-1517-publicacao-das-95-teses-d-16', 'lt-religioes-e-historia-religiosa', '1517', 'Publicação das 95 Teses de Lutero', 'Martinho Lutero afixa as teses em Wittenberg criticando as indulgências papais', 'alta', 1517, 1517);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-religioes-1545-concilio-de-trento-contra-17', 'lt-religioes-e-historia-religiosa', '1545–1563', 'Concílio de Trento (Contrarreforma)', 'Reunião dogmática da Igreja Católica reafirmando doutrinas e combatendo o protestantismo', 'alta', 1545, 1563);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--3100-antigo-egito-dinastico-1', 'lt-entidades-politicas-do-mundo-biblico', '3100 a.C.–332 a.C.', 'Antigo Egito Dinástico', 'Faraós das dinastias menfita e tebana interagindo com os povos semitas do Levante', 'alta', -3100, -332);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--2000-canaa-pre-israelita-2', 'lt-entidades-politicas-do-mundo-biblico', '2000 a.C.–1200 a.C.', 'Canaã Pré-Israelita', 'Cidades-Estado autônomas sob influência egípcia na faixa costeira do Levante', 'alta', -2000, -1200);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--1365-imperio-assirio-3', 'lt-entidades-politicas-do-mundo-biblico', '1365 a.C.–609 a.C.', 'Império Assírio', 'Potência militar mesopotâmica que subjugou a Síria, o Norte de Israel e a Fenícia', 'alta', -1365, -609);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--626-imperio-neobabilonico-4', 'lt-entidades-politicas-do-mundo-biblico', '626 a.C.–539 a.C.', 'Império Neobabilônico', 'Reinado caldeu de Nabucodonosor II que dominou o Oriente Próximo e saqueou Jerusalém', 'alta', -626, -539);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--550-imperio-persa-aquemenida-5', 'lt-entidades-politicas-do-mundo-biblico', '550 a.C.–330 a.C.', 'Império Persa Aquemênida', 'Ciro, o Grande permite o retorno dos judeus exilados e reconstrução de Jerusalém', 'alta', -550, -330);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--1200-fenicia-6', 'lt-entidades-politicas-do-mundo-biblico', '1200 a.C.–332 a.C.', 'Fenícia', 'Cidades mercantis marítimas (Tiro, Sídon e Biblos) responsáveis pelo alfabeto fonético', 'media', -1200, -332);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--336-imperio-macedonio-de-alex-7', 'lt-entidades-politicas-do-mundo-biblico', '336 a.C.–323 a.C.', 'Império Macedônio de Alexandre', 'Conquista relâmpago do Oriente Médio e disseminação da cultura helenística', 'alta', -336, -323);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-entidades--63-dominio-romano-sobre-a-ju-8', 'lt-entidades-politicas-do-mundo-biblico', '63 a.C.–476', 'Domínio Romano sobre a Judeia', 'Conquista de Jerusalém por Pompeu e administração provincial imperial romana', 'alta', -63, 476);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1500-ciclo-do-pau-brasil-1', 'lt-economia-e-ciclos-economicos-do-brasil', '1500–1530', 'Ciclo do Pau-Brasil', 'Extração vegetal exploratória litorânea via escambo com populações indígenas', 'media', 1500, 1530);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1530-ciclo-da-cana-de-acucar-2', 'lt-economia-e-ciclos-economicos-do-brasil', '1530–1700', 'Ciclo da Cana-de-Açúcar', 'Sistema de monocultura em latifúndios no Nordeste baseado em mão de obra escravizada', 'alta', 1530, 1700);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1695-ciclo-do-ouro-e-diamantes-3', 'lt-economia-e-ciclos-economicos-do-brasil', '1695–1780', 'Ciclo do Ouro e Diamantes', 'Exploração mineral em Minas Gerais, interiorização territorial e mudança da capital para o Rio', 'alta', 1695, 1780);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1830-ciclo-do-cafe-4', 'lt-economia-e-ciclos-economicos-do-brasil', '1830–1930', 'Ciclo do Café', 'Expansão cafeeira no Vale do Paraíba e Oeste Paulista, sustentando a economia imperial e republicana', 'alta', 1830, 1930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1879-primeiro-ciclo-da-borrach-5', 'lt-economia-e-ciclos-economicos-do-brasil', '1879–1912', 'Primeiro Ciclo da Borracha', 'Extração de látex na Amazônia, urbanização de Manaus e Belém com a exportação mundial', 'media', 1879, 1912);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-economia--1930-ciclo-da-industrializacao-6', 'lt-economia-e-ciclos-economicos-do-brasil', '1930–1980', 'Ciclo da Industrialização por Substituição', 'Criação de estatais de base (CSN, Petrobras), rodovias e urbanização industrial acelerada', 'alta', 1930, 1980);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1824-constituicao-imperial-de-1', 'lt-constituicoes-brasileiras', '1824–1889', 'Constituição Imperial de 1824', 'Outorgada por D. Pedro I; instituiu quatro poderes (Executivo, Legislativo, Judiciário e Moderador)', 'alta', 1824, 1889);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1891-constituicao-republicana-2', 'lt-constituicoes-brasileiras', '1891–1934', 'Constituição Republicana de 1891', 'Promulgada sob o modelo federalista presidencialista americano; separação Igreja-Estado', 'alta', 1891, 1934);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1934-constituicao-de-1934-3', 'lt-constituicoes-brasileiras', '1934–1937', 'Constituição de 1934', 'Criou o voto secreto, sufrágio feminino, Justiça Eleitoral e direitos trabalhistas', 'alta', 1934, 1937);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1937-constituicao-polaca-de-19-4', 'lt-constituicoes-brasileiras', '1937–1945', 'Constituição Polaca de 1937', 'Outorgada por Getúlio Vargas para inaugurar a ditadura corporativista do Estado Novo', 'alta', 1937, 1945);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1946-constituicao-democratica-5', 'lt-constituicoes-brasileiras', '1946–1967', 'Constituição Democrática de 1946', 'Redemocratização pós-Vargas restaurando o equilíbrio institucional e direitos cívicos', 'alta', 1946, 1967);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1967-constituicao-de-1967-6', 'lt-constituicoes-brasileiras', '1967–1988', 'Constituição de 1967', 'Centralizou poderes no Executivo militar e institucionalizou a doutrina de segurança nacional', 'alta', 1967, 1988);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-constitui-1988-constituicao-cidada-de-19-7', 'lt-constituicoes-brasileiras', '1988–2026', 'Constituição Cidadã de 1988', 'Vigente; garantia extensiva de direitos civis, sociais, fundamentais e descentralização federativa', 'alta', 1988, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1535-trafico-negreiro-e-escrav-1', 'lt-escravidao-e-abolicionismo-no-brasil', '1535–1888', 'Tráfico Negreiro e Escravidão Africana', 'Período de cerca de três séculos de exploração forçada de milhões de africanos e descendentes', 'alta', 1535, 1888);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1695-morte-de-zumbi-e-queda-de-2', 'lt-escravidao-e-abolicionismo-no-brasil', '1695', 'Morte de Zumbi e Queda de Palmares', 'Queda do maior quilombo autônomo de resistência antiescravista colonial em Alagoas', 'alta', 1695, 1695);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1850-lei-eusebio-de-queiros-3', 'lt-escravidao-e-abolicionismo-no-brasil', '1850', 'Lei Eusébio de Queirós', 'Extinção definitiva e proibição legal do tráfico negreiro transatlântico para o Brasil', 'alta', 1850, 1850);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1871-lei-do-ventre-livre-4', 'lt-escravidao-e-abolicionismo-no-brasil', '1871', 'Lei do Ventre Livre', 'Declarou libertos os filhos de mulheres escravizadas nascidos a partir daquela data', 'alta', 1871, 1871);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1885-lei-dos-sexagenarios-sara-5', 'lt-escravidao-e-abolicionismo-no-brasil', '1885', 'Lei dos Sexagenários (Saraiva-Cotegipe)', 'Liberdade formal para escravizados com mais de 60 anos com exigência de indenização', 'media', 1885, 1885);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-escravida-1888-lei-aurea-6', 'lt-escravidao-e-abolicionismo-no-brasil', '1888', 'Lei Áurea', 'Princesa Isabel sanciona o fim formal e imediato da escravidão no território brasileiro', 'alta', 1888, 1888);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1808-fundacao-da-imprensa-regi-1', 'lt-ciencia-e-inovacao-no-brasil', '1808', 'Fundação da Imprensa Régia', 'Chegada da Corte portuguesa autoriza a primeira publicação impressa oficial no Brasil', 'alta', 1808, 1808);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1852-instalacao-do-primeiro-te-2', 'lt-ciencia-e-inovacao-no-brasil', '1852', 'Instalação do Primeiro Telégrafo', 'Linha telegráfica inaugurada interligando o Palácio de São Cristóvão ao Quartel-General no Rio', 'media', 1852, 1852);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1877-primeiro-telefone-no-bras-3', 'lt-ciencia-e-inovacao-no-brasil', '1877', 'Primeiro Telefone no Brasil', 'D. Pedro II manda instalar aparelhos telefônicos no Palácio de São Cristóvão após a Exposição da Filadélfia', 'alta', 1877, 1877);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1923-primeira-transmissao-ofic-4', 'lt-ciencia-e-inovacao-no-brasil', '1923', 'Primeira Transmissão Oficial de Rádio', 'Roquette-Pinto funda a Rádio Sociedade do Rio de Janeiro pioneira na radiodifusão', 'media', 1923, 1923);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1950-inauguracao-da-televisao-5', 'lt-ciencia-e-inovacao-no-brasil', '1950', 'Inauguração da Televisão no Brasil', 'Assis Chateaubriand inaugura a PRF-3 TV Tupi canal 3 em São Paulo', 'alta', 1950, 1950);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1956-construcao-e-inauguracao-6', 'lt-ciencia-e-inovacao-no-brasil', '1956–1960', 'Construção e Inauguração de Brasília', 'Edificação acelerada da nova capital federal no Planalto Central projetada por Lúcio Costa e Niemeyer', 'alta', 1956, 1960);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1969-criacao-da-embraer-7', 'lt-ciencia-e-inovacao-no-brasil', '1969', 'Criação da Embraer', 'Fundação da Empresa Brasileira de Aeronáutica para alavancar a indústria de defesa e aviação', 'alta', 1969, 1969);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1995-abertura-comercial-da-int-8', 'lt-ciencia-e-inovacao-no-brasil', '1995', 'Abertura Comercial da Internet no Brasil', 'Ministério das Comunicações autoriza provedores de acesso comercial discado à rede mundial', 'alta', 1995, 1995);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-1996-adocao-da-urna-eletronica-9', 'lt-ciencia-e-inovacao-no-brasil', '1996', 'Adoção da Urna Eletrônica', 'Primeira votação informatizada brasileira implementada em capitais pelo TSE', 'alta', 1996, 1996);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-ciencia-e-2020-lancamento-do-pix-10', 'lt-ciencia-e-inovacao-no-brasil', '2020', 'Lançamento do PIX', 'Banco Central do Brasil lança o sistema nacional de pagamentos instantâneos eletrônicos', 'alta', 2020, 2020);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--882-russia-de-kiev-rus-de-kie-1', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '882–1240', 'Rússia de Kiev (Rus de Kiev)', 'Primeira federação eslava oriental unificada centrada na cidade de Kiev', 'media', 882, 1240);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1547-czarado-da-russia-2', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1547–1721', 'Czarado da Rússia', 'Centralização monárquica sob Ivan IV (o Terrível) e ascensão da dinastia Romanov', 'media', 1547, 1721);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1721-imperio-russo-3', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1721–1917', 'Império Russo', 'Proclamação imperial sob Pedro I o Grande; expansão até a Eurásia e queda de Nicolau II', 'alta', 1721, 1917);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1922-uniao-das-republicas-soci-4', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1922–1991', 'União das Repúblicas Socialistas Soviéticas', 'Estado socialista multinacional governado pelo Partido Comunista', 'alta', 1922, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1991-federacao-russa-5', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1991–2026', 'Federação Russa', 'Estado soberano sucessor da URSS estabelecido pós-dissolução sob Boris Yeltsin', 'alta', 1991, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1957-lancamento-do-sputnik-1-6', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1957', 'Lançamento do Sputnik 1', 'Primeiro satélite artificial lançado com sucesso ao espaço pelo programa espacial soviético', 'alta', 1957, 1957);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1957-voo-da-cadela-laika-sputn-7', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1957', 'Voo da Cadela Laika (Sputnik 2)', 'Primeiro ser vivo a orbitar a Terra a bordo de uma espaçonave', 'media', 1957, 1957);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1961-yuri-gagarin-no-espaco-vo-8', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1961', 'Yuri Gagarin no Espaço (Vostok 1)', 'Primeiro cosmonauta humano a orbitar a Terra e retornar em segurança', 'alta', 1961, 1961);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-russia-e--1986-operacao-da-estacao-espac-9', 'lt-russia-e-uniao-sovietica-entidades-politicas-e', '1986–2001', 'Operação da Estação Espacial Mir', 'Primeira estação espacial modular habitada de longa permanência na órbita terrestre', 'alta', 1986, 2001);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1810-guerras-de-independencia-1', 'lt-america-latina-integracao-e-transformacoes-poli', '1810–1826', 'Guerras de Independência Hispano-Americanas', 'Campanhas libertadoras de Simón Bolívar e José de San Martín', 'alta', 1810, 1826);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1948-criacao-da-oea-2', 'lt-america-latina-integracao-e-transformacoes-poli', '1948', 'Criação da OEA', 'Fundação da Organização dos Estados Americanos em Bogotá para cooperação hemisférica', 'media', 1948, 1948);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1959-revolucao-cubana-3', 'lt-america-latina-integracao-e-transformacoes-poli', '1959', 'Revolução Cubana', 'Fidel Castro, Che Guevara e rebeldes derrubam Fulgencio Batista instaurando regime socialista', 'alta', 1959, 1959);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1960-ciclo-de-ditaduras-milita-4', 'lt-america-latina-integracao-e-transformacoes-poli', '1960–1980', 'Ciclo de Ditaduras Militares no Cone Sul', 'Regimes autoritários no Brasil, Argentina, Chile, Uruguai e Paraguai (Operação Condor)', 'alta', 1960, 1980);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1980-processo-de-redemocratiza-5', 'lt-america-latina-integracao-e-transformacoes-poli', '1980–1990', 'Processo de Redemocratização Latino-Americano', 'Transição de juntas militares para governos civis eleitos em todo o subcontinente', 'alta', 1980, 1990);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-america-l-1991-assinatura-do-tratado-de-6', 'lt-america-latina-integracao-e-transformacoes-poli', '1991', 'Assinatura do Tratado de Assunção (Mercosul)', 'Brasil, Argentina, Paraguai e Uruguai criam o Mercado Comum do Sul', 'alta', 1991, 1991);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-165-peste-antonina-1', 'lt-grandes-pandemias-historicas', '165–180', 'Peste Antonina', 'Epidemia provavelmente de varíola que atingiu o Império Romano e matou o imperador Marco Aurélio', 'media', 165, 180);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-541-peste-de-justiniano-2', 'lt-grandes-pandemias-historicas', '541–542', 'Peste de Justiniano', 'Primeira grande onda documentada de peste bubônica afetando o Império Bizantino', 'alta', 541, 542);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-1346-a-peste-negra-3', 'lt-grandes-pandemias-historicas', '1346–1353', 'A Peste Negra', 'Segunda pandemia de peste bubônica com mortalidade catastrófica na Eurásia', 'alta', 1346, 1353);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-1817-primeira-pandemia-global-4', 'lt-grandes-pandemias-historicas', '1817–1824', 'Primeira Pandemia Global de Cólera', 'Surto em Calcutá disseminado por rotas mercantis na Ásia e Europa', 'media', 1817, 1824);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-1918-gripe-espanhola-h1n1-5', 'lt-grandes-pandemias-historicas', '1918–1920', 'Gripe Espanhola (H1N1)', 'Pandemia de influenza virulentíssima que infectou meio bilhão de pessoas', 'alta', 1918, 1920);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-1981-pandemia-de-hivaids-6', 'lt-grandes-pandemias-historicas', '1981–2026', 'Pandemia de HIV/AIDS', 'Identificação do vírus da imunodeficiência humana e sua disseminação global', 'alta', 1981, 2026);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-grandes-p-2020-pandemia-de-covid-19-7', 'lt-grandes-pandemias-historicas', '2020–2023', 'Pandemia de COVID-19', 'Crise sanitária do coronavírus declarada emergência internacional pela OMS', 'alta', 2020, 2023);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1789-declaracao-dos-direitos-d-1', 'lt-transformacoes-sociais-e-direitos', '1789', 'Declaração dos Direitos do Homem e do Cidadão', 'Marco dos direitos civis universais e igualdade perante a lei na França revolucionária', 'alta', 1789, 1789);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1893-primeiro-pais-com-sufragi-2', 'lt-transformacoes-sociais-e-direitos', '1893', 'Primeiro País com Sufrágio Feminino', 'Nova Zelândia torna-se o primeiro território autogovernado com voto irrestrito a mulheres', 'alta', 1893, 1893);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1932-sufragio-feminino-no-bras-3', 'lt-transformacoes-sociais-e-direitos', '1932', 'Sufrágio Feminino no Brasil', 'Código Eleitoral de 1932 garante formalmente o direito de voto para as mulheres brasileiras', 'alta', 1932, 1932);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1943-consolidacao-das-leis-do-4', 'lt-transformacoes-sociais-e-direitos', '1943', 'Consolidação das Leis do Trabalho (CLT)', 'Getúlio Vargas unifica normas de proteção ao trabalhador urbano no Brasil', 'alta', 1943, 1943);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1948-declaracao-universal-dos-5', 'lt-transformacoes-sociais-e-direitos', '1948', 'Declaração Universal dos Direitos Humanos', 'Assembleia Geral da ONU aprova o documento em resposta às atrocidades da 2ª Guerra', 'alta', 1948, 1948);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-1964-movimento-dos-direitos-ci-6', 'lt-transformacoes-sociais-e-direitos', '1964–1968', 'Movimento dos Direitos Civis nos EUA', 'Marchas de Martin Luther King Jr., aprovação do Civil Rights Act e Voting Rights Act', 'alta', 1964, 1968);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-transform-2013-resolucao-do-casamento-ci-7', 'lt-transformacoes-sociais-e-direitos', '2013', 'Resolução do Casamento Civil Igualitário no Brasil', 'CNJ obriga cartórios de todo o país a celebrarem casamentos entre pessoas do mesmo sexo', 'media', 2013, 2013);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1877-invencao-do-fonografo-1', 'lt-cultura-musica-cinema-e-esportes', '1877', 'Invenção do Fonógrafo', 'Thomas Edison projeta o primeiro equipamento mecânico capaz de gravar e reproduzir áudio', 'alta', 1877, 1877);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1895-primeira-exibicao-de-cine-2', 'lt-cultura-musica-cinema-e-esportes', '1895', 'Primeira Exibição de Cinema', 'Irmãos Auguste e Louis Lumière realizam a primeira sessão pública de cinema pago em Paris', 'alta', 1895, 1895);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1896-primeiros-jogos-olimpicos-3', 'lt-cultura-musica-cinema-e-esportes', '1896', 'Primeiros Jogos Olímpicos Modernos', 'Atenas sedia o renascimento das Olimpíadas idealizado pelo Barão Pierre de Coubertin', 'alta', 1896, 1896);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1920-nascimento-da-industria-f-4', 'lt-cultura-musica-cinema-e-esportes', '1920', 'Nascimento da Indústria Fonográfica do Jazz', 'Gravações de Louis Armstrong e orquestras espalham o jazz internacionalmente', 'media', 1920, 1920);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1927-primeiro-filme-sonoro-com-5', 'lt-cultura-musica-cinema-e-esportes', '1927', 'Primeiro Filme Sonoro Comercial', 'Lançamento de ''O Cantor de Jazz'' (The Jazz Singer) sincronizando falas e músicas na tela', 'alta', 1927, 1927);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1930-primeira-copa-do-mundo-fi-6', 'lt-cultura-musica-cinema-e-esportes', '1930', 'Primeira Copa do Mundo FIFA', 'Disputada e sediada no Uruguai com final vencida pela seleção anfitriã', 'alta', 1930, 1930);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1954-eclosao-do-rock-and-roll-7', 'lt-cultura-musica-cinema-e-esportes', '1954', 'Eclosão do Rock and Roll', 'Gravações de Elvis Presley no Sun Studio e ''Rock Around the Clock'' popularizam o gênero jovem', 'alta', 1954, 1954);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-1958-primeiro-titulo-mundial-d-8', 'lt-cultura-musica-cinema-e-esportes', '1958', 'Primeiro Título Mundial de Futebol do Brasil', 'Seleção Brasileira vence a Copa do Mundo na Suécia revelando Pelé ao planeta', 'alta', 1958, 1958);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-cultura-m-2008-consolidacao-do-streaming-9', 'lt-cultura-musica-cinema-e-esportes', '2008', 'Consolidação do Streaming Musical', 'Plataforma Spotify inicia operação transformando o consumo musical em áudio digital sob demanda', 'media', 2008, 2008);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1564-galileu-galilei-1', 'lt-pessoas-que-mudaram-a-historia', '1564–1642', 'Galileu Galilei', 'Astrônomo e físico italiano que aperfeiçoou o telescópio e defendeu o heliocentrismo', 'alta', 1564, 1642);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1643-isaac-newton-2', 'lt-pessoas-que-mudaram-a-historia', '1643–1727', 'Isaac Newton', 'Físico e matemático inglês, formulador da gravitação universal e do cálculo diferencial', 'alta', 1643, 1727);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1809-charles-darwin-3', 'lt-pessoas-que-mudaram-a-historia', '1809–1882', 'Charles Darwin', 'Naturalista britânico responsável pela teoria da evolução através da seleção natural', 'alta', 1809, 1882);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1856-nikola-tesla-4', 'lt-pessoas-que-mudaram-a-historia', '1856–1943', 'Nikola Tesla', 'Engenheiro inventor dos sistemas de transmissão elétrica de corrente alternada e motores de indução', 'alta', 1856, 1943);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1867-marie-curie-5', 'lt-pessoas-que-mudaram-a-historia', '1867–1934', 'Marie Curie', 'Pioneira no estudo da radioatividade, descobridora do rádio e polônio, primeira a vencer dois Prêmios Nobel', 'alta', 1867, 1934);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1873-alberto-santos-dumont-6', 'lt-pessoas-que-mudaram-a-historia', '1873–1932', 'Alberto Santos Dumont', 'Inventor brasileiro pioneiro dos dirigíveis a gás e aviação mais pesada que o ar na França', 'alta', 1873, 1932);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1879-albert-einstein-7', 'lt-pessoas-que-mudaram-a-historia', '1879–1955', 'Albert Einstein', 'Físico teórico alemão formulador das teorias da Relatividade Especial e Geral', 'alta', 1879, 1955);
INSERT OR REPLACE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
VALUES ('m-pessoas-q-1912-alan-turing-8', 'lt-pessoas-que-mudaram-a-historia', '1912–1954', 'Alan Turing', 'Matemático britânico, pioneiro da ciência da computação teórica e criptoanalista da máquina Enigma', 'alta', 1912, 1954);

-- Reativação dos gatilhos de integridade somente-leitura das linhas de contexto
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
