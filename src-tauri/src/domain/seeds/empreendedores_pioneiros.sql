-- empreendedores_pioneiros.sql
-- Semente Canônica do Lote 6: Grandes Empreendedores & Pioneiros Industriais
-- Família Rockefeller, Família Matarazzo, Família Klabin-Lafer, Família Guinle, Família Álvares Penteado, Visconde de Mauá

-- =============================================================================
-- 1. CORREÇÃO E ATUALIZAÇÃO DE REGISTROS DE PESSOAS
-- =============================================================================

-- Rockefeller
UPDATE pessoas SET nome = 'Laura "Cettie" Spelman', sobrenome = 'Rockefeller', minibiografia = 'Filantropa, educadora e ativista pelos direitos civis e abolição. Esposa de John D. Rockefeller, o Spelman College foi nomeado em sua honra.' WHERE id = 'pub_rockefeller_laura_spelman_rockefeller';
UPDATE pessoas SET minibiografia = '37º Governador do Arkansas (1967–1971), filantropo e líder na modernização institucional e integração racial no Arkansas.' WHERE id = 'pub_rockefeller_winthrop_rockefeller';

-- Matarazzo
UPDATE pessoas SET nome = 'Filomena', sobrenome = 'Sansivieri Matarazzo (Condessa Matarazzo)', minibiografia = 'Matriarca da dinastia Matarazzo, casada com o Conde Francesco Matarazzo em 1875 na Itália, mãe de 13 filhos e esteio familiar do império IRFM.' WHERE id = 'pub_matarazzo_filomena_matarazzo';
UPDATE pessoas SET minibiografia = 'Francisco Matarazzo Sobrinho, célebre como Ciccillo Matarazzo. Industrial, mecenas e figura capital da cultura brasileira, fundador do Museu de Arte Moderna de São Paulo (MAM), da Bienal de São Paulo (1951), da Companhia Cinematográfica Vera Cruz e do TBC.' WHERE id = 'pub_matarazzo_ciccillo_matarazzo';
UPDATE pessoas SET minibiografia = 'Francisco "Baby" Pignatari, neto do Conde Francesco Matarazzo. Industrial pioneiro da mineração de cobre e laminação de metais (Cia. Brasileira de Metais) e lendário playboy do jet set internacional.' WHERE id = 'pub_matarazzo_francisco_matarazzo_pignatari';
UPDATE pessoas SET minibiografia = 'Eduardo Matarazzo Suplicy, bisneto do Conde Francesco Matarazzo. Economista, professor titular da FGV, senador por São Paulo por 24 anos e autor mundialmente reconhecido da proposta de Renda Básica de Cidadania.' WHERE id = 'pub_matarazzo_eduardo_matarazzo_suplicy';
UPDATE pessoas SET minibiografia = 'Primogênito do Conde Francesco Matarazzo, educado na Europa para suceder o pai no comando das IRFM, faleceu precocemente em trágico acidente automobilístico em 1920 na Itália.' WHERE id = 'pub_matarazzo_ermelino_matarazzo';

-- Guinle
UPDATE pessoas SET sexo = 'F', minibiografia = 'Mãe do patriarca Eduardo Palassin Guinle, de família tradicional francesa radicada na região dos Pireneus.' WHERE id = 'pub_guinle_josephine_palassin';
UPDATE pessoas SET minibiografia = 'Guilherme Guinle, pioneiro da industrialização pesada brasileira, presidente da Companhia Siderúrgica Nacional (CSN - Volta Redonda), presidente do Banco do Brasil e financiador da saúde pública e pesquisa biomédica.' WHERE id = 'pub_guinle_guilherme_guinle';
UPDATE pessoas SET minibiografia = 'Octávio Guinle, empresário da hotelaria internacional, idealizador e fundador em 1923 do emblemático Copacabana Palace Hotel no Rio de Janeiro.' WHERE id = 'pub_guinle_octavio_guinle';
UPDATE pessoas SET minibiografia = 'Arnaldo Guinle, empresário, dirigente esportivo do Fluminense Football Club (construiu o Estádio das Laranjeiras) e maior mecenas histórico do choro e da música popular brasileira (patrocinador dos Oito Batutas e Pixinguinha).' WHERE id = 'pub_guinle_arnaldo_guinle';
UPDATE pessoas SET minibiografia = 'Jorge "Jorginho" Guinle, lendário playboy e embaixador cultural informal do Brasil em Hollywood, autor de "Jazz Panorama" (primeiro livro sobre jazz no Brasil) e memorialista.' WHERE id = 'pub_guinle_jorge_guinle';

-- Álvares Penteado
UPDATE pessoas SET nome = 'Antônio', sobrenome = 'Álvares Leite Penteado (Conde de Álvares Penteado)', minibiografia = 'Conde de Álvares Penteado pelo Papa Bento XV. Grande cafeicultor e pioneiro da industrialização têxtil paulista, fundador do Cotonifício Rodolfo Penteado no Brás e da célebre Villa Penteado.' WHERE id = 'pub_penteado_antonio_alvares_leite_penteado';
UPDATE pessoas SET nome = 'Ana Paulina', sobrenome = 'de Lacerda Penteado (Condessa de Álvares Penteado)', minibiografia = 'Condessa consorte de Álvares Penteado, matriarca do clã cafeeiro e industrial, casada com Antônio Álvares Leite Penteado.' WHERE id = 'pub_penteado_ana_paulina_lacerda_penteado';
UPDATE pessoas SET nome = 'Armando Álvares', sobrenome = 'Penteado', minibiografia = 'Engenheiro, arquiteto, artista e mecenas. Instituiu em testamento a Fundação Armando Álvares Penteado (FAAP) e o Museu de Arte Brasileira (MAB), legado perene de educação e cultura em São Paulo.' WHERE id = 'pub_penteado_armando_alvares_penteado';
UPDATE pessoas SET nome = 'Annie Álvares', sobrenome = 'Penteado (Condessa Annie Penteado)', minibiografia = 'Annie Penteado, viúva de Armando Álvares Penteado, responsável por consolidar e inaugurar as instalações da FAAP em Higienópolis segundo as diretrizes testamentárias do marido.' WHERE id = 'pub_penteado_annie_alvares_penteado';

-- Visconde de Mauá
UPDATE pessoas SET nome = 'Irineu', sobrenome = 'Evangelista de Sousa (Visconde de Mauá)', minibiografia = 'Visconde de Mauá (1813–1889), pioneiro absoluto da modernização e da industrialização do Império do Brasil. Criou a primeira ferrovia brasileira (EF Mauá), iluminação a gás, cabos submarinos telegráficos e o Estaleiro da Ponta da Areia.' WHERE id = 'pub_maua_irineu_evangelista';
UPDATE pessoas SET nome = 'Maria Joaquina', sobrenome = 'de Sousa (Viscondessa de Mauá)', minibiografia = 'Viscondessa consorte de Mauá, companheira devota de Irineu Evangelista de Sousa em suas conquistas empresariais no Brasil e nos momentos difíceis de exílio na Europa e no Prata.' WHERE id = 'pub_maua_maria_joaquina';

-- Klabin
UPDATE pessoas SET minibiografia = 'Ema Gordon Klabin, mecenas e colecionadora de arte. Criou a Fundação Cultural Ema Gordon Klabin em sua residência no Jardim Europa (SP), reunindo pinturas renascentistas, barrocas, mobiliário e arte pré-colombiana.' WHERE id = 'pub_klabin_ema_gordon_klabin';
UPDATE pessoas SET minibiografia = 'Eva Klabin, colecionadora de arte e filantropa. Instituiu a Fundação Eva Klabin no Rio de Janeiro (Lagoa Rodrigo de Freitas), com acervo clássico, egípcio, greco-romano e oriental.' WHERE id = 'pub_klabin_eva_klabin';
UPDATE pessoas SET minibiografia = 'Jenny Klabin Segall, escritora, poetisa e tradutora monumental de Goethe ("Fausto") e Molière. Idealizou e fundou o Museu Lasar Segall em São Paulo para preservar o legado de seu marido.' WHERE id = 'pub_klabin_jenny_klabin_segall';
UPDATE pessoas SET minibiografia = 'Lasar Segall, mestre expressionista internacional, pintor, desenhista e gravador. Casou-se com Jenny Klabin em 1925, autor de obras cimeiras como "Navio de Emigrantes" e "Pogrom".' WHERE id = 'pub_klabin_lasar_segall';
UPDATE pessoas SET minibiografia = 'Gregori Warchavchik, arquiteto de origem ucraniana que introduziu a arquitetura moderna no Brasil, autor do Manifesto de 1925 e projetista da pioneira Casa Modernista da Rua Santa Cruz (1927–1928).' WHERE id = 'pub_klabin_gregori_warchavchik';
UPDATE pessoas SET minibiografia = 'Mina Klabin Warchavchik, pioneira do paisagismo moderno no Brasil, inovando no uso de cactos e plantas tropicais nativas em parceria com Gregori Warchavchik.' WHERE id = 'pub_klabin_mina_klabin_warchavchik';
UPDATE pessoas SET minibiografia = 'Israel Klabin, engenheiro, industrial, ambientalista e político. Prefeito da Cidade do Rio de Janeiro (1979–1980) e fundador da Fundação SOS Mata Atlântica.' WHERE id = 'pub_klabin_israel_klabin';


-- =============================================================================
-- 2. VINCULAÇÃO ESTRUTURAL DE FILHOS E UNIÕES
-- =============================================================================

-- Matarazzo: Francesco Matarazzo + Filomena -> Ermelino e Francisco Jr.
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_matarazzo_francisco_matarazzo_junior', 1
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_matarazzo_ermelino_matarazzo', 2
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu';

-- Álvares Penteado: Antônio Álvares Leite Penteado + Ana Paulina -> Armando, Silvio, Antonieta, Eglantina, Estela
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_penteado_armando_alvares_penteado', 1
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_penteado_silvio_alvares_penteado', 2
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_penteado_antonieta_penteado', 3
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_penteado_eglantina_penteado', 4
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
SELECT u.id, 'pub_penteado_estela_penteado', 5
FROM unioes u
WHERE u.id = 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe';


-- =============================================================================
-- 3. EVENTOS HISTÓRICOS E VITAIS GEORREFERENCIADOS
-- =============================================================================

-- Rockefeller: John D. Rockefeller em Tarrytown
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_rockefeller_jdr_kykuit', 'pub_rockefeller_john_d_rockefeller', 'outro', 1913, 'exata', 'loc-us-tarrytown', 'Residência em Kykuit', 'Construção e fixação de residência na célebre mansão Kykuit em Pocantico Hills / Tarrytown.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_rockefeller_laura_morte', 'pub_rockefeller_laura_spelman_rockefeller', 'falecimento', 1915, 'exata', 'loc-us-tarrytown', 'Falecimento em Pocantico Hills', 'Faleceu aos 75 anos em Pocantico Hills, Tarrytown, Nova York.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_rockefeller_winthrop_gov', 'pub_rockefeller_winthrop_rockefeller', 'outro', 1967, 'exata', 'loc-us-novayork', 'Posse como Governador do Arkansas', 'Eleito 37º Governador do Arkansas, liderando reformas civis e sociais históricas.');

-- Matarazzo: Francesco Matarazzo
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_matarazzo_castellabate_nasce', 'pub_matarazzo_francesco_matarazzo', 'nascimento', 1854, 'exata', 'hist_it_castellabate', 'Nascimento em Castellabate', 'Nasceu em Castellabate, província de Salerno, Campânia, Itália.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_matarazzo_sorocaba', 'pub_matarazzo_francesco_matarazzo', 'outro', 1881, 'exata', 'ibge-3552205', 'Chegada e Comércio em Sorocaba', 'Início das atividades mercantis de comércio e banha de porco em Sorocaba (SP).');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_matarazzo_ciccillo_bienal', 'pub_matarazzo_ciccillo_matarazzo', 'outro', 1951, 'exata', 'ibge-3550308', 'Criação da Bienal de São Paulo', 'Inaugurou a 1ª Bienal Internacional de Arte de São Paulo no Trianon.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_matarazzo_suplicy_senado', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'outro', 1991, 'exata', 'ibge-5300108', 'Posse no Senado Federal', 'Início de mandato histórico de 24 anos ininterruptos no Senado pelo Estado de São Paulo.');

-- Klabin
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_klabin_mauricio_nasce', 'pub_klabin_mauricio_freeman_klabin', 'nascimento', 1860, 'exata', 'loc-lt-zarasai', 'Nascimento em Zarasai', 'Nasceu em Zarasai (Novoaleksandrovsk), Lituânia, no então Império Russo.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_klabin_segall_vilnius', 'pub_klabin_lasar_segall', 'nascimento', 1891, 'exata', 'loc-lt-vilnius', 'Nascimento em Vilnius', 'Nasceu em Vilnius (Vilna), tradicional centro cultural judaico da Lituânia.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_klabin_warchavchik_odessa', 'pub_klabin_gregori_warchavchik', 'nascimento', 1896, 'exata', 'loc-ua-odessa', 'Nascimento em Odessa', 'Nasceu em Odessa e formou-se pelo Instituto Superior de Belas Artes de Roma.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_klabin_casa_modernista', 'pub_klabin_gregori_warchavchik', 'outro', 1928, 'exata', 'ibge-3550308', 'Conclusão da Casa Modernista', 'Conclusão da residência da Rua Santa Cruz, primeiro edifício da arquitetura moderna do Brasil.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_klabin_israel_pref', 'pub_klabin_israel_klabin', 'outro', 1979, 'exata', 'ibge-3304557', 'Posse como Prefeito do Rio de Janeiro', 'Assumiu a Prefeitura da Cidade do Rio de Janeiro, pioneiro em políticas públicas ambientais.');

-- Guinle
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_guinle_porto_santos', 'pub_guinle_eduardo_palassin_guinle', 'outro', 1888, 'exata', 'ibge-3548500', 'Concessão do Porto de Santos', 'Assinatura do contrato de concessão e fundação da Companhia Docas de Santos.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_guinle_csn_volta_redonda', 'pub_guinle_guilherme_guinle', 'outro', 1941, 'exata', 'ibge-3306305', 'Criação da CSN em Volta Redonda', 'Presidiu a comissão de planejamento e fundação da Companhia Siderúrgica Nacional em Volta Redonda.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_guinle_copacabana_palace', 'pub_guinle_octavio_guinle', 'outro', 1923, 'exata', 'ibge-3304557', 'Inauguração do Copacabana Palace', 'Abertura das portas do hotel mais lendário e luxuoso da América do Sul.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_guinle_estadio_laranjeiras', 'pub_guinle_arnaldo_guinle', 'outro', 1919, 'exata', 'ibge-3304557', 'Inauguração do Estádio das Laranjeiras', 'Construção do Estádio de Álvaro Chaves para o Campeonato Sul-Americano de Futebol de 1919.');

-- Álvares Penteado
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_penteado_villa_penteado', 'pub_penteado_antonio_alvares_leite_penteado', 'outro', 1902, 'exata', 'ibge-3550308', 'Construção da Villa Penteado', 'Conclusão da monumental residência Art Nouveau em Higienópolis, projetada por Carlos Ekman.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_penteado_faap_testamento', 'pub_penteado_armando_alvares_penteado', 'outro', 1947, 'exata', 'ibge-3550308', 'Instituição da FAAP em Testamento', 'Destinação de vasto patrimônio para criação de escola de artes plásticas e engenharia e do MAB.');

-- Mauá
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_maua_nasce_arroio_grande', 'pub_maua_irineu_evangelista', 'nascimento', 1813, 'exata', 'ibge-4301305', 'Nascimento em Arroio Grande', 'Nasceu na estância materna em Arroio Grande, então distrito de Jaguarão (RS).');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_maua_ferrovia_inaugura', 'pub_maua_irineu_evangelista', 'outro', 1854, 'exata', 'ibge-3304557', 'Inauguração da 1ª Ferrovia do Brasil', 'Inauguração da Estrada de Ferro Mauá (Porto de Mauá a Raiz da Serra), com a locomotiva Baronesa.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, data_qualificador, local_id, rotulo_historico_livre, nota)
VALUES ('ev_maua_falecimento_petropolis', 'pub_maua_irineu_evangelista', 'falecimento', 1889, 'exata', 'ibge-3303906', 'Falecimento em Petrópolis', 'Faleceu em sua residência em Petrópolis aos 75 anos de idade.');


-- =============================================================================
-- 4. OBRAS CULTURAIS, LITERÁRIAS E MARCOS INDUSTRIAIS
-- =============================================================================

-- Rockefeller
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_rockefeller_reminiscences', 'pub_rockefeller_john_d_rockefeller', 'livro', 'Random Reminiscences of Men and Events', 'Autobiografia & Negócios', 1909, NULL, 'Memórias autobiográficas do fundador da Standard Oil sobre sua trajetória e princípios filantrópicos.', (SELECT id FROM locais WHERE id = 'loc-us-novayork')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_john_d_rockefeller')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_rockefeller_david_memoirs', 'pub_rockefeller_david_rockefeller', 'livro', 'Memoirs', 'Autobiografia & Geopolítica', 2002, NULL, 'Autobiografia detalhando a liderança no Chase Manhattan Bank e encontros com líderes globais.', (SELECT id FROM locais WHERE id = 'loc-us-novayork')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_david_rockefeller')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_rockefeller_nelson_federalism', 'pub_rockefeller_nelson_rockefeller', 'livro', 'The Future of Federalism', 'Ensaio Político & Doutrina', 1962, NULL, 'Conferências sobre federalismo proferidas na Universidade Harvard.', (SELECT id FROM locais WHERE id = 'loc-us-novayork')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_nelson_rockefeller')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_rockefeller_moma_fundacao', 'pub_rockefeller_abby_aldrich_rockefeller', 'arte', 'Criação do Museum of Modern Art (MoMA)', 'Patronato & Museu de Arte', 1929, NULL, 'Cofundação pioneira do primeiro grande museu dedicado exclusivamente à arte moderna em Nova York.', (SELECT id FROM locais WHERE id = 'loc-us-novayork')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_abby_aldrich_rockefeller')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

-- Matarazzo
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_matarazzo_bienal_sp', 'pub_matarazzo_ciccillo_matarazzo', 'arte', 'Fundação da Bienal Internacional de Arte de São Paulo', 'Instituição Cultural', 1951, NULL, 'Criação da segunda bienal de artes mais antiga do mundo, inserindo o Brasil no circuito das vanguardas internacionais.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_ciccillo_matarazzo')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_matarazzo_mam_sp', 'pub_matarazzo_ciccillo_matarazzo', 'arte', 'Fundação do Museu de Arte Moderna de São Paulo (MAM)', 'Museu de Arte', 1948, NULL, 'Idealização e doação do acervo fundador do MAM de São Paulo.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_ciccillo_matarazzo')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_matarazzo_vera_cruz', 'pub_matarazzo_ciccillo_matarazzo', 'arte', 'Fundação da Companhia Cinematográfica Vera Cruz', 'Indústria Cinematográfica', 1949, NULL, 'Estúdios que profissionalizaram o cinema brasileiro com filmes clássicos como "O Cangaceiro".', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_ciccillo_matarazzo')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_suplicy_renda_basica', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'livro', 'Renda Básica de Cidadania: A Resposta Dada pelo Vento', 'Economia & Política Pública', 2002, NULL, 'Obra fundamental de política distributiva e direitos sociais universais.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_eduardo_matarazzo_suplicy')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_matarazzo_irfm_marco', 'pub_matarazzo_francesco_matarazzo', 'outro', 'Constituição das Indústrias Reunidas Francisco Matarazzo (IRFM)', 'Complexo Industrial', 1911, NULL, 'Consolidação do maior complexo fabril da América do Sul, com mais de 350 fábricas.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_francesco_matarazzo')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

-- Klabin
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_jenny_fausto', 'pub_klabin_jenny_klabin_segall', 'livro', 'Tradução Poética de "Fausto" de Goethe', 'Tradução Clássica', 1949, NULL, 'A mais aclamada tradução integral em versos rítmicos do "Fausto" de Goethe para a língua portuguesa.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_jenny_klabin_segall')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_jenny_corneille', 'pub_klabin_jenny_klabin_segall', 'livro', 'Tradução das Tragédias de Pierre Corneille', 'Tradução Dramatúrgica', 1956, NULL, 'Traduções métricas de "Le Cid", "Cinna" e "Horace" com rigor filológico excepcional.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_jenny_klabin_segall')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_segall_emigrantes', 'pub_klabin_lasar_segall', 'arte', 'Navio de Emigrantes', 'Pintura Expressionista a Óleo', 1941, NULL, 'Obra-prima monumental do expressionismo brasileiro retratando o drama dos refugiados e imigrantes.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_lasar_segall')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_segall_pogrom', 'pub_klabin_lasar_segall', 'arte', 'Pogrom', 'Pintura Expressionista', 1937, NULL, 'Denúncia artística visceral da perseguição e violência contra o povo judeu na Europa.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_lasar_segall')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_warchavchik_manifesto', 'pub_klabin_gregori_warchavchik', 'pesquisa', 'Manifesto da Arquitetura Moderna', 'Manifesto Teórico & Ensaio', 1925, NULL, 'Texto fundador do modernismo arquitetônico no Brasil, publicado no Correio da Manhã.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_gregori_warchavchik')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_warchavchik_casa', 'pub_klabin_gregori_warchavchik', 'arte', 'Casa Modernista da Rua Santa Cruz', 'Projeto Arquitetônico Histórico', 1928, NULL, 'A primeira residência em linguagem modernista construída no território brasileiro.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_gregori_warchavchik')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_ema_fundacao', 'pub_klabin_ema_gordon_klabin', 'arte', 'Criação da Fundação Cultural Ema Gordon Klabin', 'Acervo Museológico & Mecenato', 1978, NULL, 'Instituição mantenedora de mais de 1.500 obras de arte clássica, oriental e moderna.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_ema_gordon_klabin')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_eva_fundacao', 'pub_klabin_eva_klabin', 'arte', 'Criação da Fundação Eva Klabin', 'Acervo Museológico & Mecenato', 1990, NULL, 'Criação do museu-casa com rica coleção de arte clássica, greco-romana e renascentista.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_eva_klabin')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_celso_dh', 'pub_klabin_celso_lafer', 'livro', 'A Reconstrução dos Direitos Humanos: Um Diálogo com o Pensamento de Hannah Arendt', 'Filosofia do Direito', 1988, NULL, 'Ensaio canônico de teoria do direito e direitos humanos fundamentais.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_celso_lafer')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_klabin_celso_identidade', 'pub_klabin_celso_lafer', 'livro', 'A Identidade Internacional do Brasil e a Política Externa Brasileira', 'Diplomacia & Relações Internacionais', 2001, NULL, 'Análise de referência sobre a inserção estratégica do Brasil no sistema global pós-Guerra Fria.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_klabin_celso_lafer')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

-- Guinle
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_guinle_jorginho_jazz', 'pub_guinle_jorge_guinle', 'livro', 'Jazz Panorama', 'Musicologia & História do Jazz', 1953, NULL, 'Primeiro estudo crítico e histórico publicado no Brasil sobre o nascimento e evolução do jazz.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_jorge_guinle')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_guinle_jorginho_memorias', 'pub_guinle_jorge_guinle', 'livro', 'Um Século de Boa Vida', 'Memórias Autobiográficas', 1997, NULL, 'Crônicas memorialísticas de sua convivência íntima com estrelas de Hollywood e a Era de Ouro do Rio.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_jorge_guinle')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_guinle_copacabana_marco', 'pub_guinle_octavio_guinle', 'outro', 'Construção e Inauguração do Copacabana Palace Hotel', 'Patrimônio Histórico & Hotelaria', 1923, NULL, 'Ícone da hotelaria de luxo e do glamour internacional no Rio de Janeiro, projetado por Joseph Gire.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_octavio_guinle')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_guinle_csn_marco', 'pub_guinle_guilherme_guinle', 'outro', 'Implantação da Companhia Siderúrgica Nacional (CSN)', 'Siderurgia Nacional', 1946, NULL, 'Fundação do marco da industrialização pesada do aço na América Latina em Volta Redonda.', (SELECT id FROM locais WHERE id = 'ibge-3306305')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_guilherme_guinle')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

-- Álvares Penteado
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_penteado_faap_marco', 'pub_penteado_armando_alvares_penteado', 'arte', 'Criação da Fundação Armando Álvares Penteado (FAAP) e MAB', 'Educação & Museu de Arte', 1947, NULL, 'Constituição de instituição voltada ao ensino das belas-artes, engenharia e do Museu de Arte Brasileira.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_penteado_armando_alvares_penteado')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_penteado_villa_marco', 'pub_penteado_antonio_alvares_leite_penteado', 'arte', 'Villa Penteado', 'Monumento Arquitetônico Art Nouveau', 1902, NULL, 'Palacete residencial marco do Art Nouveau em São Paulo, hoje sede de pós-graduação da FAU-USP.', (SELECT id FROM locais WHERE id = 'ibge-3550308')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_penteado_antonio_alvares_leite_penteado')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

-- Mauá
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_maua_autobiografia', 'pub_maua_irineu_evangelista', 'livro', 'Autobiografia: Exposição aos Credores e ao Público', 'Memórias & Economia Política', 1878, NULL, 'Clássico da história econômica em que Mauá detalha com sobriedade e altivez suas empresas, crises e retidão civil.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maua_irineu_evangelista')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_maua_ferrovia_marco', 'pub_maua_irineu_evangelista', 'outro', 'Estrada de Ferro Mauá', 'Infraestrutura Ferroviária', 1854, NULL, 'Construção da primeira linha ferroviária do Império do Brasil e da América do Sul.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maua_irineu_evangelista')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_maua_cabo_submarino', 'pub_maua_irineu_evangelista', 'outro', 'Cabo Submarino Telegráfico Transatlântico', 'Telecomunicações Pioneiras', 1874, NULL, 'Ligação telegráfica pioneira entre o Brasil e a Europa, revolucionando a comunicação intercontinental.', (SELECT id FROM locais WHERE id = 'ibge-3304557')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maua_irineu_evangelista')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;

INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
SELECT 'obr_maua_ponta_areia', 'pub_maua_irineu_evangelista', 'outro', 'Estaleiro e Fundição da Ponta da Areia', 'Indústria Naval & Metalúrgica', 1846, NULL, 'Maior complexo de construção naval do Brasil oitocentista, em Niterói (RJ).', (SELECT id FROM locais WHERE id = 'ibge-3303302')
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maua_irineu_evangelista')
ON CONFLICT(id) DO UPDATE SET categoria = excluded.categoria, titulo = excluded.titulo, subtipo = excluded.subtipo, ano = excluded.ano, detalhes = excluded.detalhes;


-- =============================================================================
-- 5. REGISTROS DE IDIOMAS FALADOS (idiomas_pessoa)
-- =============================================================================

-- Rockefeller (Inglês, Francês, Alemão, Espanhol)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_rock_jdr_en', 'pub_rockefeller_john_d_rockefeller', 'Inglês'),
    ('idm_rock_laura_en', 'pub_rockefeller_laura_spelman_rockefeller', 'Inglês'),
    ('idm_rock_jdr_jr_en', 'pub_rockefeller_john_d_rockefeller_jr', 'Inglês'),
    ('idm_rock_jdr_jr_fr', 'pub_rockefeller_john_d_rockefeller_jr', 'Francês'),
    ('idm_rock_abby_en', 'pub_rockefeller_abby_aldrich_rockefeller', 'Inglês'),
    ('idm_rock_abby_fr', 'pub_rockefeller_abby_aldrich_rockefeller', 'Francês'),
    ('idm_rock_nelson_en', 'pub_rockefeller_nelson_rockefeller', 'Inglês'),
    ('idm_rock_nelson_es', 'pub_rockefeller_nelson_rockefeller', 'Espanhol'),
    ('idm_rock_nelson_fr', 'pub_rockefeller_nelson_rockefeller', 'Francês'),
    ('idm_rock_david_en', 'pub_rockefeller_david_rockefeller', 'Inglês'),
    ('idm_rock_david_fr', 'pub_rockefeller_david_rockefeller', 'Francês'),
    ('idm_rock_david_de', 'pub_rockefeller_david_rockefeller', 'Alemão'),
    ('idm_rock_david_es', 'pub_rockefeller_david_rockefeller', 'Espanhol'),
    ('idm_rock_jdr3_en', 'pub_rockefeller_john_d_rockefeller_iii', 'Inglês'),
    ('idm_rock_winthrop_en', 'pub_rockefeller_winthrop_rockefeller', 'Inglês'),
    ('idm_rock_laurance_en', 'pub_rockefeller_laurance_rockefeller', 'Inglês'),
    ('idm_rock_jay_en', 'pub_rockefeller_john_d_rockefeller_iv', 'Inglês'),
    ('idm_rock_jay_ja', 'pub_rockefeller_john_d_rockefeller_iv', 'Japonês');

-- Matarazzo (Italiano, Português, Francês, Espanhol, Inglês)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_mata_francisco_it', 'pub_matarazzo_francesco_matarazzo', 'Italiano'),
    ('idm_mata_francisco_pt', 'pub_matarazzo_francesco_matarazzo', 'Português'),
    ('idm_mata_filomena_it', 'pub_matarazzo_filomena_matarazzo', 'Italiano'),
    ('idm_mata_filomena_pt', 'pub_matarazzo_filomena_matarazzo', 'Português'),
    ('idm_mata_chiquinho_pt', 'pub_matarazzo_francisco_matarazzo_junior', 'Português'),
    ('idm_mata_chiquinho_it', 'pub_matarazzo_francisco_matarazzo_junior', 'Italiano'),
    ('idm_mata_chiquinho_fr', 'pub_matarazzo_francisco_matarazzo_junior', 'Francês'),
    ('idm_mata_ermelino_pt', 'pub_matarazzo_ermelino_matarazzo', 'Português'),
    ('idm_mata_ermelino_it', 'pub_matarazzo_ermelino_matarazzo', 'Italiano'),
    ('idm_mata_ciccillo_pt', 'pub_matarazzo_ciccillo_matarazzo', 'Português'),
    ('idm_mata_ciccillo_it', 'pub_matarazzo_ciccillo_matarazzo', 'Italiano'),
    ('idm_mata_ciccillo_fr', 'pub_matarazzo_ciccillo_matarazzo', 'Francês'),
    ('idm_mata_baby_pt', 'pub_matarazzo_francisco_matarazzo_pignatari', 'Português'),
    ('idm_mata_baby_en', 'pub_matarazzo_francisco_matarazzo_pignatari', 'Inglês'),
    ('idm_mata_baby_it', 'pub_matarazzo_francisco_matarazzo_pignatari', 'Italiano'),
    ('idm_mata_baby_fr', 'pub_matarazzo_francisco_matarazzo_pignatari', 'Francês'),
    ('idm_mata_suplicy_pt', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'Português'),
    ('idm_mata_suplicy_en', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'Inglês'),
    ('idm_mata_suplicy_it', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'Italiano'),
    ('idm_mata_suplicy_es', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'Espanhol');

-- Klabin (Português, Iídiche, Russo, Lituano, Alemão, Francês, Inglês, Hebraico)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_klab_mauricio_pt', 'pub_klabin_mauricio_freeman_klabin', 'Português'),
    ('idm_klab_mauricio_yi', 'pub_klabin_mauricio_freeman_klabin', 'Iídiche'),
    ('idm_klab_mauricio_ru', 'pub_klabin_mauricio_freeman_klabin', 'Russo'),
    ('idm_klab_mauricio_de', 'pub_klabin_mauricio_freeman_klabin', 'Alemão'),
    ('idm_klab_mauricio_lt', 'pub_klabin_mauricio_freeman_klabin', 'Lituano'),
    ('idm_klab_hessel_pt', 'pub_klabin_hessel_klabin', 'Português'),
    ('idm_klab_hessel_yi', 'pub_klabin_hessel_klabin', 'Iídiche'),
    ('idm_klab_hessel_ru', 'pub_klabin_hessel_klabin', 'Russo'),
    ('idm_klab_wolff_pt', 'pub_klabin_wolff_klabin', 'Português'),
    ('idm_klab_wolff_yi', 'pub_klabin_wolff_klabin', 'Iídiche'),
    ('idm_klab_wolff_ru', 'pub_klabin_wolff_klabin', 'Russo'),
    ('idm_klab_jenny_pt', 'pub_klabin_jenny_klabin_segall', 'Português'),
    ('idm_klab_jenny_de', 'pub_klabin_jenny_klabin_segall', 'Alemão'),
    ('idm_klab_jenny_fr', 'pub_klabin_jenny_klabin_segall', 'Francês'),
    ('idm_klab_jenny_yi', 'pub_klabin_jenny_klabin_segall', 'Iídiche'),
    ('idm_klab_segall_pt', 'pub_klabin_lasar_segall', 'Português'),
    ('idm_klab_segall_de', 'pub_klabin_lasar_segall', 'Alemão'),
    ('idm_klab_segall_ru', 'pub_klabin_lasar_segall', 'Russo'),
    ('idm_klab_segall_yi', 'pub_klabin_lasar_segall', 'Iídiche'),
    ('idm_klab_warchav_pt', 'pub_klabin_gregori_warchavchik', 'Português'),
    ('idm_klab_warchav_ru', 'pub_klabin_gregori_warchavchik', 'Russo'),
    ('idm_klab_warchav_it', 'pub_klabin_gregori_warchavchik', 'Italiano'),
    ('idm_klab_warchav_fr', 'pub_klabin_gregori_warchavchik', 'Francês'),
    ('idm_klab_mina_pt', 'pub_klabin_mina_klabin_warchavchik', 'Português'),
    ('idm_klab_mina_fr', 'pub_klabin_mina_klabin_warchavchik', 'Francês'),
    ('idm_klab_mina_de', 'pub_klabin_mina_klabin_warchavchik', 'Alemão'),
    ('idm_klab_ema_pt', 'pub_klabin_ema_gordon_klabin', 'Português'),
    ('idm_klab_ema_fr', 'pub_klabin_ema_gordon_klabin', 'Francês'),
    ('idm_klab_ema_de', 'pub_klabin_ema_gordon_klabin', 'Alemão'),
    ('idm_klab_ema_en', 'pub_klabin_ema_gordon_klabin', 'Inglês'),
    ('idm_klab_eva_pt', 'pub_klabin_eva_klabin', 'Português'),
    ('idm_klab_eva_fr', 'pub_klabin_eva_klabin', 'Francês'),
    ('idm_klab_eva_en', 'pub_klabin_eva_klabin', 'Inglês'),
    ('idm_klab_horacio_pt', 'pub_klabin_horacio_lafer', 'Português'),
    ('idm_klab_horacio_fr', 'pub_klabin_horacio_lafer', 'Francês'),
    ('idm_klab_horacio_en', 'pub_klabin_horacio_lafer', 'Inglês'),
    ('idm_klab_celso_pt', 'pub_klabin_celso_lafer', 'Português'),
    ('idm_klab_celso_en', 'pub_klabin_celso_lafer', 'Inglês'),
    ('idm_klab_celso_fr', 'pub_klabin_celso_lafer', 'Francês'),
    ('idm_klab_celso_es', 'pub_klabin_celso_lafer', 'Espanhol'),
    ('idm_klab_israel_pt', 'pub_klabin_israel_klabin', 'Português'),
    ('idm_klab_israel_en', 'pub_klabin_israel_klabin', 'Inglês'),
    ('idm_klab_israel_fr', 'pub_klabin_israel_klabin', 'Francês');

-- Guinle (Português, Francês, Inglês)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_gui_eduardo_pt', 'pub_guinle_eduardo_palassin_guinle', 'Português'),
    ('idm_gui_eduardo_fr', 'pub_guinle_eduardo_palassin_guinle', 'Francês'),
    ('idm_gui_guilhermina_pt', 'pub_guinle_guilhermina_coutinho_da_silva', 'Português'),
    ('idm_gui_guilherme_pt', 'pub_guinle_guilherme_guinle', 'Português'),
    ('idm_gui_guilherme_fr', 'pub_guinle_guilherme_guinle', 'Francês'),
    ('idm_gui_guilherme_en', 'pub_guinle_guilherme_guinle', 'Inglês'),
    ('idm_gui_octavio_pt', 'pub_guinle_octavio_guinle', 'Português'),
    ('idm_gui_octavio_fr', 'pub_guinle_octavio_guinle', 'Francês'),
    ('idm_gui_octavio_en', 'pub_guinle_octavio_guinle', 'Inglês'),
    ('idm_gui_arnaldo_pt', 'pub_guinle_arnaldo_guinle', 'Português'),
    ('idm_gui_arnaldo_fr', 'pub_guinle_arnaldo_guinle', 'Francês'),
    ('idm_gui_carlos_pt', 'pub_guinle_carlos_guinle', 'Português'),
    ('idm_gui_carlos_fr', 'pub_guinle_carlos_guinle', 'Francês'),
    ('idm_gui_jorginho_pt', 'pub_guinle_jorge_guinle', 'Português'),
    ('idm_gui_jorginho_en', 'pub_guinle_jorge_guinle', 'Inglês'),
    ('idm_gui_jorginho_fr', 'pub_guinle_jorge_guinle', 'Francês');

-- Álvares Penteado (Português, Francês, Inglês, Italiano)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_pen_antonio_pt', 'pub_penteado_antonio_alvares_leite_penteado', 'Português'),
    ('idm_pen_antonio_fr', 'pub_penteado_antonio_alvares_leite_penteado', 'Francês'),
    ('idm_pen_ana_pt', 'pub_penteado_ana_paulina_lacerda_penteado', 'Português'),
    ('idm_pen_armando_pt', 'pub_penteado_armando_alvares_penteado', 'Português'),
    ('idm_pen_armando_fr', 'pub_penteado_armando_alvares_penteado', 'Francês'),
    ('idm_pen_annie_pt', 'pub_penteado_annie_alvares_penteado', 'Português'),
    ('idm_pen_annie_fr', 'pub_penteado_annie_alvares_penteado', 'Francês'),
    ('idm_pen_silvio_pt', 'pub_penteado_silvio_alvares_penteado', 'Português');

-- Mauá (Português, Inglês, Espanhol, Francês)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idm_maua_irineu_pt', 'pub_maua_irineu_evangelista', 'Português'),
    ('idm_maua_irineu_en', 'pub_maua_irineu_evangelista', 'Inglês'),
    ('idm_maua_irineu_es', 'pub_maua_irineu_evangelista', 'Espanhol'),
    ('idm_maua_irineu_fr', 'pub_maua_irineu_evangelista', 'Francês'),
    ('idm_maua_maria_pt', 'pub_maua_maria_joaquina', 'Português'),
    ('idm_maua_maria_es', 'pub_maua_maria_joaquina', 'Espanhol');
