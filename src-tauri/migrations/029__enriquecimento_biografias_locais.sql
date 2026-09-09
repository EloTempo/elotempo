-- 029 — Enriquecimento de biografias históricas, inclusão de falecimentos e georreferenciamento
-- Fornece datas completas, cidades com coordenadas geográficas e marcos de vida
-- 0. Normalização de locais que possam ter tido UUIDs pré-existentes antes da migração 028
UPDATE eventos SET local_id = 'loc-pt-lisboa' WHERE local_id IN (SELECT id FROM locais WHERE pais_id = 'pt' AND nome_busca = 'lisboa' AND id != 'loc-pt-lisboa');
DELETE FROM locais WHERE pais_id = 'pt' AND nome_busca = 'lisboa' AND id != 'loc-pt-lisboa';
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('loc-pt-lisboa', 'Lisboa', 'Lisboa', 'pt', 38.76791, -9.16036, 'lisboa');

-- 1. Cidades mundiais e marcos históricos necessários
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_eisenach', 'Eisenach', 'Turíngia', 'de', 50.9748, 10.3245, 'eisenach');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_weimar', 'Weimar', 'Turíngia', 'de', 50.9803, 11.329, 'weimar');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_kothen', 'Köthen', 'Saxônia-Anhalt', 'de', 51.7519, 11.9744, 'kothen');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_arnstadt', 'Arnstadt', 'Turíngia', 'de', 50.8333, 10.95, 'arnstadt');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_bronnbach', 'Bronnbach', 'Baden-Württemberg', 'de', 49.7144, 9.5475, 'bronnbach');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_de_coburgo', 'Coburgo', 'Baviera', 'de', 50.2581, 10.9645, 'coburgo');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_shrewsbury', 'Shrewsbury', 'Shropshire', 'gb', 52.7073, -2.7553, 'shrewsbury');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_plymouth', 'Plymouth', 'Devon', 'gb', 50.3755, -4.1427, 'plymouth');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_windsor', 'Windsor', 'Berkshire', 'gb', 51.4839, -0.6044, 'windsor');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_cowes', 'Cowes', 'Ilha de Wight', 'gb', 50.7633, -1.2974, 'cowes');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_sandringham', 'Sandringham', 'Norfolk', 'gb', 52.8315, 0.5117, 'sandringham');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gb_balmoral', 'Balmoral', 'Aberdeenshire', 'gb', 57.0397, -3.2292, 'balmoral');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_fr_cannes', 'Cannes', 'Alpes-Maritimes', 'fr', 43.5528, 7.0174, 'cannes');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_fr_eu', 'Eu', 'Normandia', 'fr', 50.0483, 1.4178, 'eu');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_fr_passy', 'Passy', 'Alta Saboia', 'fr', 45.9228, 6.6872, 'passy');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_ec_galapagos', 'Ilhas Galápagos', 'Galápagos', 'ec', -0.9538, -90.9656, 'ilhas galapagos');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_gr_corfu', 'Corfu', 'Ilhas Jônicas', 'gr', 39.6243, 19.9217, 'corfu');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_pt_queluz', 'Queluz', 'Sintra / Lisboa', 'pt', 38.7561, -9.2586, 'queluz');
INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES ('hist_it_castellabate', 'Castellabate', 'Salerno / Campânia', 'it', 40.28, 14.952, 'castellabate');

-- 2. Correção de sinalizador is_vivo para figuras contemporâneas vivas
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kennedy_caroline_kennedy';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kennedy_maria_shriver';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kennedy_patrick_j_kennedy';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kennedy_robert_f_kennedy_jr';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_curie_pierre_joliot';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_curie_helene_langevin_joliot';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_charles3_uk';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_william_uk';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_catherine_uk';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_george_uk';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_akihito';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_michiko';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_naruhito';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_masako';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_aiko';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_fumihito';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_kiko';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_casa_imperial_japao_hisahito';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bourbon_felipe_vi';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bourbon_letizia';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bourbon_leonor_princesa_das_asturias';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bourbon_juan_carlos_i';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_alberto_ii_de_monaco';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_frederik_x_da_dinamarca';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_willem_alexander_dos_paises_baixos';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_philippe_da_belgica';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_henri_de_luxemburgo';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_outras_monarquias_harald_v_da_noruega';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_jeb_bush';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_marvin_bush';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_neil_bush';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_dorothy_bush_koch';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_george_p_bush';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_jenna_bush_hager';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_bush_barbara_pierce_bush';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_matarazzo_eduardo_matarazzo_suplicy';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_guinle_guilhermina_guinle';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_guinle_luiz_eduardo';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_klabin_horacio_lafer_piva';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_klabin_celso_lafer';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_peron_isabel_peron';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_mussolini_alessandra_mussolini';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_mussolini_rachele_mussolini_politica';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_habsburgo_karl_von_habsburgo';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_franco_luis_alfonso_de_borbon';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_franco_francis_franco';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_franco_carmen_martinez_bordiu';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_rockefeller_john_d_rockefeller_iv';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_mao_mao_xinyu';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_mao_li_na';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_mao_li_min';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_stalin_chrese_evans';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kong_confucio_kong_yu_jen';
UPDATE pessoas SET is_vivo = 1 WHERE id = 'pub_kong_confucio_kung_tsui_chang';

-- 3. Enriquecimento de eventos biográficos com local_id, data_texto e ano
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_joao6', 'pub_joao6', 'nascimento', 1767, 1767, 'exata', '13 de maio de 1767', 'loc-pt-lisboa', 'Nascimento no Paço da Ribeira', 'Nascido infante de Portugal em Lisboa.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao6')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_joao6', 'pub_joao6', 'falecimento', 1826, 1826, 'exata', '10 de março de 1826', 'loc-pt-lisboa', 'Falecimento no Palácio da Bemposta', 'Rei de Portugal e do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao6')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_joao6_chegada', 'pub_joao6', 'evento', 1808, 1808, 'exata', '8 de março de 1808', 'ibge-3304557', 'Chegada da Corte ao Rio de Janeiro', 'Desembarque da família real e instalação da sede da monarquia portuguesa no Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao6')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_joao6_aclamacao', 'pub_joao6', 'posse', 1818, 1818, 'exata', '6 de fevereiro de 1818', 'ibge-3304557', 'Aclamação como Rei do Reino Unido', 'Cerimônia solene de coroação e aclamação no Largo do Paço.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao6')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_carlota', 'pub_carlota', 'nascimento', 1775, 1775, 'exata', '25 de abril de 1775', 'loc-es-madrid', 'Nascimento em Aranjuez', 'Infanta da Espanha.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_carlota')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_carlota', 'pub_carlota', 'falecimento', 1830, 1830, 'exata', '7 de janeiro de 1830', 'hist_pt_queluz', 'Falecimento no Palácio de Queluz', 'Rainha consorte de Portugal e do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_carlota')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pedro1', 'pub_pedro1', 'nascimento', 1798, 1798, 'exata', '12 de outubro de 1798', 'hist_pt_queluz', 'Nascimento no Palácio de Queluz', 'Nascido no Quarto Dom Quixote.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pedro1', 'pub_pedro1', 'falecimento', 1834, 1834, 'exata', '24 de setembro de 1834', 'hist_pt_queluz', 'Falecimento no Palácio de Queluz', 'Faleceu no mesmo quarto onde nasceu, após vencer as Guerras Liberais.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro1_fico', 'pub_pedro1', 'evento', 1822, 1822, 'exata', '9 de janeiro de 1822', 'ibge-3304557', 'Dia do Fico', '"Como é para o bem de todos e felicidade geral da Nação, estou pronto: diga ao povo que fico."'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro1_independencia', 'pub_pedro1', 'evento', 1822, 1822, 'exata', '7 de setembro de 1822', 'ibge-3550308', 'Proclamação da Independência (Grito do Ipiranga)', 'Às margens do riacho Ipiranga, declara a separação do Brasil de Portugal.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro1_constituicao', 'pub_pedro1', 'publicacao', 1824, 1824, 'exata', '25 de março de 1824', 'ibge-3304557', 'Outorga da Constituição de 1824', 'Primeira Carta Constitucional do Império do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro1_abdicacao', 'pub_pedro1', 'evento', 1831, 1831, 'exata', '7 de abril de 1831', 'ibge-3304557', 'Abdicação da Coroa Brasileira', 'Renúncia ao trono imperial brasileiro em favor de seu filho D. Pedro II.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro1_porto', 'pub_pedro1', 'batalha', 1832, 1832, 'exata', '8 de julho de 1832', 'loc-pt-porto', 'Desembarque do Mindelo e Cerco do Porto', 'Liderança liberal contra as forças absolutistas na Guerra Civil Portuguesa.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_leopoldina', 'pub_leopoldina', 'nascimento', 1797, 1797, 'exata', '22 de janeiro de 1797', 'loc-at-viena', 'Nascimento em Viena', 'Arquiduquesa da Áustria, filha do Imperador Francisco I.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_leopoldina')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_leopoldina', 'pub_leopoldina', 'falecimento', 1826, 1826, 'exata', '11 de dezembro de 1826', 'ibge-3304557', 'Falecimento no Palácio de São Cristóvão', 'Primeira Imperatriz do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_leopoldina')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_leopoldina_conselho', 'pub_leopoldina', 'evento', 1822, 1822, 'exata', '2 de setembro de 1822', 'ibge-3304557', 'Presidência do Conselho de Estado', 'Sessão solene em que Dona Leopoldina e José Bonifácio assinam a carta instando D. Pedro à Independência.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_leopoldina')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pedro2', 'pub_pedro2', 'nascimento', 1825, 1825, 'exata', '2 de dezembro de 1825', 'ibge-3304557', 'Nascimento no Palácio de São Cristóvão', 'Filho de D. Pedro I e Dona Leopoldina.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pedro2', 'pub_pedro2', 'falecimento', 1891, 1891, 'exata', '5 de dezembro de 1891', 'loc-fr-paris', 'Falecimento no Hotel Bedford', 'Faleceu no exílio em Paris, sepultado na Catedral de Petrópolis.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro2_maioridade', 'pub_pedro2', 'posse', 1840, 1840, 'exata', '23 de julho de 1840', 'ibge-3304557', 'Declaração da Maioridade', 'Aos 14 anos, assume o governo pleno do Império do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro2_petropolis', 'pub_pedro2', 'evento', 1843, 1843, 'exata', '16 de março de 1843', 'ibge-3303906', 'Decreto de Fundação de Petrópolis', 'Criação da cidade imperial de veraneio e colonização alemã.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro2_ferrovia', 'pub_pedro2', 'evento', 1858, 1858, 'exata', '29 de março de 1858', 'ibge-3304557', 'Inauguração da E. F. D. Pedro II', 'Primeiro trecho da ferrovia que ligou a capital ao interior do país.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro2_filadelfia', 'pub_pedro2', 'evento', 1876, 1876, 'exata', '25 de junho de 1876', 'loc-us-filadelfia', 'Visita à Exposição da Filadélfia e Teste do Telefone', 'Primeiro chefe de Estado a testar o telefone de Alexander Graham Bell.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_pedro2_exilio', 'pub_pedro2', 'evento', 1889, 1889, 'exata', '17 de novembro de 1889', 'ibge-3304557', 'Partida para o Exílio Europeu', 'Embarque forçado no navio Alagoas após o golpe militar republicano.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_teresa', 'pub_teresa', 'nascimento', 1822, 1822, 'exata', '14 de março de 1822', 'loc-it-napoles', 'Nascimento em Nápoles', 'Princesa das Duas Sicílias.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_teresa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_teresa', 'pub_teresa', 'falecimento', 1889, 1889, 'exata', '28 de dezembro de 1889', 'loc-pt-porto', 'Falecimento no Porto', 'Faleceu dias após a chegada do exílio a Portugal.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_teresa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_isabel', 'pub_isabel', 'nascimento', 1846, 1846, 'exata', '29 de julho de 1846', 'ibge-3304557', 'Nascimento no Palácio de São Cristóvão', 'Princesa Imperial do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_isabel')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_isabel', 'pub_isabel', 'falecimento', 1921, 1921, 'exata', '14 de novembro de 1921', 'hist_fr_eu', 'Falecimento no Castelo d’Eu', 'Falecida no exílio na França.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_isabel')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_isabel_ventrelivre', 'pub_isabel', 'publicacao', 1871, 1871, 'exata', '28 de setembro de 1871', 'ibge-3304557', 'Promulgação da Lei do Ventre Livre', 'Como Regente do Império, liberta os filhos de escravizados nascidos a partir daquela data.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_isabel')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_isabel_leiaurea', 'pub_isabel', 'publicacao', 1888, 1888, 'exata', '13 de maio de 1888', 'ibge-3304557', 'Assinatura da Lei Áurea', 'Extinguiu definitiva e incondicionalmente a escravidão no Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_isabel')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_conde_deu', 'pub_conde_deu', 'nascimento', 1842, 1842, 'exata', '28 de abril de 1842', 'loc-fr-paris', 'Nascimento em Neuilly-sur-Seine', 'Príncipe da Casa de Orléans.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_conde_deu')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_conde_deu', 'pub_conde_deu', 'falecimento', 1922, 1922, 'exata', '28 de agosto de 1922', 'ibge-3304557', 'Falecimento a Bordo do Massilia', 'Faleceu a caminho das comemorações do Centenário da Independência do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_conde_deu')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_conde_deu_assuncao', 'pub_conde_deu', 'batalha', 1869, 1869, 'exata', '15 de agosto de 1869', 'loc-py-assuncao', 'Comando na Guerra do Paraguai', 'Comandante-em-chefe das forças aliadas em Assunção.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_conde_deu')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria2', 'pub_maria2', 'nascimento', 1819, 1819, 'exata', '4 de abril de 1819', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Primogênita de D. Pedro I e Dona Leopoldina.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria2', 'pub_maria2', 'falecimento', 1853, 1853, 'exata', '15 de novembro de 1853', 'loc-pt-lisboa', 'Falecimento em Lisboa', 'Rainha de Portugal (D. Maria II).'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_miguel1', 'pub_miguel1', 'nascimento', 1802, 1802, 'exata', '26 de outubro de 1802', 'hist_pt_queluz', 'Nascimento em Queluz', 'Filho de D. João VI e Carlota Joaquina.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_miguel1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_miguel1', 'pub_miguel1', 'falecimento', 1866, 1866, 'exata', '14 de novembro de 1866', 'hist_de_bronnbach', 'Falecimento em Bronnbach', 'Exilado na Alemanha após as Guerras Liberais.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_miguel1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_januaria', 'pub_januaria', 'nascimento', 1822, 1822, 'exata', '11 de março de 1822', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Princesa Imperial do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_januaria')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_januaria', 'pub_januaria', 'falecimento', 1901, 1901, 'exata', '13 de março de 1901', 'loc-fr-nice', 'Falecimento em Nice', 'Condessa de Áquila.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_januaria')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_francisca', 'pub_francisca', 'nascimento', 1824, 1824, 'exata', '2 de agosto de 1824', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Princesa do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_francisca')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_francisca', 'pub_francisca', 'falecimento', 1898, 1898, 'exata', '27 de março de 1898', 'loc-fr-paris', 'Falecimento em Paris', 'Princesa de Joinville.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_francisca')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_leopoldina_filha', 'pub_leopoldina_filha', 'nascimento', 1847, 1847, 'exata', '13 de julho de 1847', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Segunda filha de D. Pedro II.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_leopoldina_filha')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_leopoldina_filha', 'pub_leopoldina_filha', 'falecimento', 1871, 1871, 'exata', '7 de fevereiro de 1871', 'loc-at-viena', 'Falecimento em Viena', 'Duquesa de Saxe.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_leopoldina_filha')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pedro_alcantara', 'pub_pedro_alcantara', 'nascimento', 1875, 1875, 'exata', '15 de outubro de 1875', 'ibge-3303906', 'Nascimento em Petrópolis', 'Príncipe do Grão-Pará.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro_alcantara')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pedro_alcantara', 'pub_pedro_alcantara', 'falecimento', 1940, 1940, 'exata', '29 de janeiro de 1940', 'ibge-3303906', 'Falecimento em Petrópolis', 'Palácio do Grão-Pará.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro_alcantara')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_luis_orleans', 'pub_luis_orleans', 'nascimento', 1878, 1878, 'exata', '26 de janeiro de 1878', 'ibge-3303906', 'Nascimento em Petrópolis', 'Príncipe de Orléans e Bragança.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_luis_orleans')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_luis_orleans', 'pub_luis_orleans', 'falecimento', 1920, 1920, 'exata', '26 de março de 1920', 'hist_fr_cannes', 'Falecimento em Cannes', 'Escritor e veterano da 1ª Guerra.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_luis_orleans')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_antonio_orleans', 'pub_antonio_orleans', 'nascimento', 1881, 1881, 'exata', '9 de agosto de 1881', 'loc-fr-paris', 'Nascimento em Paris', 'Príncipe de Orléans e Bragança.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_antonio_orleans')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_antonio_orleans', 'pub_antonio_orleans', 'falecimento', 1918, 1918, 'exata', '29 de novembro de 1918', 'loc-gb-londres', 'Falecimento em Edmonton / Londres', 'Oficial da Força Aérea Real britânica na 1ª Guerra Mundial.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_antonio_orleans')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria1_pt', 'pub_maria1_pt', 'nascimento', 1734, 1734, 'exata', '17 de dezembro de 1734', 'loc-pt-lisboa', 'Nascimento em Lisboa', 'Rainha de Portugal e do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria1_pt', 'pub_maria1_pt', 'falecimento', 1816, 1816, 'exata', '20 de março de 1816', 'ibge-3304557', 'Falecimento no Convento do Carmo', 'Faleceu no Rio de Janeiro durante a transferência da corte.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pedro3_pt', 'pub_pedro3_pt', 'nascimento', 1717, 1717, 'exata', '5 de julho de 1717', 'loc-pt-lisboa', 'Nascimento em Lisboa', 'Rei consorte de Portugal.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro3_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pedro3_pt', 'pub_pedro3_pt', 'falecimento', 1786, 1786, 'exata', '25 de maio de 1786', 'hist_pt_queluz', 'Falecimento em Queluz', 'Palácio Real de Queluz.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro3_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_fernando2_pt', 'pub_fernando2_pt', 'nascimento', 1816, 1816, 'exata', '29 de outubro de 1816', 'loc-at-viena', 'Nascimento em Viena', '"O Rei-Artista", idealizador do Palácio da Pena.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_fernando2_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_fernando2_pt', 'pub_fernando2_pt', 'falecimento', 1885, 1885, 'exata', '15 de dezembro de 1885', 'loc-pt-lisboa', 'Falecimento em Lisboa', 'Sepultado no Panteão dos Braganças.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_fernando2_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pedro5_pt', 'pub_pedro5_pt', 'nascimento', 1837, 1837, 'exata', '16 de setembro de 1837', 'loc-pt-lisboa', 'Nascimento no Palácio das Necessidades', 'Rei de Portugal ("O Esperançoso").'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro5_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pedro5_pt', 'pub_pedro5_pt', 'falecimento', 1861, 1861, 'exata', '11 de novembro de 1861', 'loc-pt-lisboa', 'Falecimento em Lisboa', 'Vítima precoce de febre tifoide aos 24 anos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_pedro5_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_luis1_pt', 'pub_luis1_pt', 'nascimento', 1838, 1838, 'exata', '31 de outubro de 1838', 'loc-pt-lisboa', 'Nascimento no Palácio das Necessidades', 'Rei de Portugal ("O Popular").'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_luis1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_luis1_pt', 'pub_luis1_pt', 'falecimento', 1889, 1889, 'exata', '19 de outubro de 1889', 'loc-pt-cascais', 'Falecimento na Cidadela de Cascais', 'Monarca ligado às artes e ciências oceânicas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_luis1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_mariapia_pt', 'pub_mariapia_pt', 'nascimento', 1847, 1847, 'exata', '16 de outubro de 1847', 'loc-it-turim', 'Nascimento no Palácio Real de Turim', 'Filha de Vítor Emanuel II da Itália.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mariapia_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_mariapia_pt', 'pub_mariapia_pt', 'falecimento', 1911, 1911, 'exata', '5 de julho de 1911', 'loc-it-turim', 'Falecimento em Stupinigi', 'Rainha consorte de Portugal ("O Anjo da Caridade").'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mariapia_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_carlos1_pt', 'pub_carlos1_pt', 'nascimento', 1863, 1863, 'exata', '28 de setembro de 1863', 'loc-pt-lisboa', 'Nascimento no Palácio da Ajuda', 'Rei de Portugal e oceanógrafo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_carlos1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_carlos1_pt', 'pub_carlos1_pt', 'falecimento', 1908, 1908, 'exata', '1 de fevereiro de 1908', 'loc-pt-lisboa', 'Regicídio de 1908 no Terreiro do Paço', 'Atentado fatal na Praça do Comércio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_carlos1_pt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_deodoro', 'pub_deodoro', 'nascimento', 1827, 1827, 'exata', '5 de agosto de 1827', 'ibge-2704708', 'Nascimento na Vila de Alagoas', 'Militar alagoano.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_deodoro', 'pub_deodoro', 'falecimento', 1892, 1892, 'exata', '23 de agosto de 1892', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Primeiro Presidente da República.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_deodoro_proclamacao', 'pub_deodoro', 'evento', 1889, 1889, 'exata', '15 de novembro de 1889', 'ibge-3304557', 'Proclamação da República', 'Liderança do movimento republicano que destituiu a monarquia.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_deodoro_posse', 'pub_deodoro', 'posse', 1891, 1891, 'exata', '26 de fevereiro de 1891', 'ibge-3304557', 'Eleição e Posse Presidencial', 'Eleito pelo Congresso Constituinte.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_mariana_deodoro', 'pub_mariana_deodoro', 'nascimento', 1826, 1826, 'exata', '19 de fevereiro de 1826', 'ibge-2704708', 'Nascimento em Alagoas', 'Primeira-dama do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mariana_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_mariana_deodoro', 'pub_mariana_deodoro', 'falecimento', 1905, 1905, 'exata', '9 de abril de 1905', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Sepultada no Cemitério do Caju.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mariana_deodoro')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_manuel_vargas', 'pub_manuel_vargas', 'nascimento', 1844, 1844, 'exata', '25 de dezembro de 1844', 'ibge-4314100', 'Nascimento em Passo Fundo', 'General e combatente na Guerra do Paraguai.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_manuel_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_manuel_vargas', 'pub_manuel_vargas', 'falecimento', 1921, 1921, 'exata', '21 de outubro de 1921', 'ibge-4318705', 'Falecimento em São Borja', 'Pai de Getúlio Vargas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_manuel_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_candida_vargas', 'pub_candida_vargas', 'nascimento', 1850, 1850, 'exata', '3 de dezembro de 1850', 'ibge-4318705', 'Nascimento em São Borja', 'Mãe de Getúlio Vargas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_candida_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_candida_vargas', 'pub_candida_vargas', 'falecimento', 1937, 1937, 'exata', '25 de junho de 1937', 'ibge-4318705', 'Falecimento em São Borja', 'Matriarca da família Vargas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_candida_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_vargas', 'pub_vargas', 'nascimento', 1882, 1882, 'exata', '19 de abril de 1882', 'ibge-4318705', 'Nascimento em São Borja', 'Líder político e presidente.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_vargas', 'pub_vargas', 'falecimento', 1954, 1954, 'exata', '24 de agosto de 1954', 'ibge-3304557', 'Suicídio no Palácio do Catete', '"Saio da vida para entrar na História."'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_vargas_rev30', 'pub_vargas', 'posse', 1930, 1930, 'exata', '3 de novembro de 1930', 'ibge-3304557', 'Posse na Revolução de 1930', 'Assunção da chefia do Governo Provisório no Palácio do Catete.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_vargas_clt', 'pub_vargas', 'publicacao', 1943, 1943, 'exata', '1 de maio de 1943', 'ibge-3304557', 'Promulgação da CLT', 'Instituição da Consolidação das Leis do Trabalho em São Januário.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_vargas_petrobras', 'pub_vargas', 'publicacao', 1953, 1953, 'exata', '3 de outubro de 1953', 'ibge-3304557', 'Criação da Petrobras', 'Sanção da Lei nº 2.004 estabelecendo o monopólio estatal do petróleo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_sepultamento_vargas', 'pub_vargas', 'sepultamento', 1954, 1954, 'exata', '27 de agosto de 1954', 'ibge-4318705', 'Sepultamento em São Borja', 'Mausoléu no Cemitério de São Borja.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_darcy', 'pub_darcy_vargas', 'nascimento', 1895, 1895, 'exata', '12 de dezembro de 1895', 'ibge-4318705', 'Nascimento em São Borja', 'Primeira-dama do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darcy_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_darcy', 'pub_darcy_vargas', 'falecimento', 1968, 1968, 'exata', '25 de junho de 1968', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Sepultada no Cemitério São João Batista.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darcy_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darcy_lba', 'pub_darcy_vargas', 'evento', 1942, 1942, 'exata', '28 de agosto de 1942', 'ibge-3304557', 'Criação da LBA', 'Fundação da Legião Brasileira de Assistência em apoio às famílias dos pracinhas da FEB.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darcy_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_alzira', 'pub_alzira_vargas', 'nascimento', 1914, 1914, 'exata', '22 de novembro de 1914', 'ibge-4318705', 'Nascimento em São Borja', 'Advogada e conselheira política.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alzira_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_alzira', 'pub_alzira_vargas', 'falecimento', 1992, 1992, 'exata', '26 de janeiro de 1992', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Chefe do Gabinete Civil de Getúlio Vargas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alzira_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_joao_cesar', 'pub_joao_cesar', 'nascimento', 1872, 1872, 'exata', '24 de junho de 1872', 'ibge-3121605', 'Nascimento em Diamantina', 'Comerciante e coletor de impostos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao_cesar')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_joao_cesar', 'pub_joao_cesar', 'falecimento', 1905, 1905, 'exata', '9 de janeiro de 1905', 'ibge-3121605', 'Falecimento em Diamantina', 'Pai de Juscelino Kubitschek.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joao_cesar')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_julia_kubitschek', 'pub_julia_kubitschek', 'nascimento', 1873, 1873, 'exata', '13 de março de 1873', 'ibge-3121605', 'Nascimento em Diamantina', 'Professora primária.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_julia_kubitschek')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_julia_kubitschek', 'pub_julia_kubitschek', 'falecimento', 1971, 1971, 'exata', '28 de julho de 1971', 'ibge-3106200', 'Falecimento em Belo Horizonte', 'Mãe e esteio da formação de JK.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_julia_kubitschek')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jk', 'pub_jk', 'nascimento', 1902, 1902, 'exata', '12 de setembro de 1902', 'ibge-3121605', 'Nascimento em Diamantina', 'Médico e político mineiro.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jk', 'pub_jk', 'falecimento', 1976, 1976, 'exata', '22 de agosto de 1976', 'ibge-3304201', 'Acidente Fatal na Rodovia Presidente Dutra', 'Falecimento trágico no km 165 em Resende, RJ.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_jk_formatura', 'pub_jk', 'evento', 1927, 1927, 'exata', '17 de dezembro de 1927', 'ibge-3106200', 'Formatura em Medicina na UFMG', 'Conclusão da graduação médica em Belo Horizonte.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_jk_pampulha', 'pub_jk', 'posse', 1940, 1940, 'exata', '16 de abril de 1940', 'ibge-3106200', 'Prefeitura de BH e Conjunto da Pampulha', 'Gestão visionária que contratou Oscar Niemeyer e Burle Marx.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_jk_posse', 'pub_jk', 'posse', 1956, 1956, 'exata', '31 de janeiro de 1956', 'ibge-3304557', 'Posse Presidencial e Plano de Metas', 'Início da presidência marcada pelo lema "50 anos em 5".'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_jk_brasilia', 'pub_jk', 'evento', 1960, 1960, 'exata', '21 de abril de 1960', 'ibge-5300108', 'Inauguração de Brasília', 'Transferência oficial da capital federal para o Planalto Central.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_sepultamento_jk', 'pub_jk', 'sepultamento', 1981, 1981, 'exata', '12 de setembro de 1981', 'ibge-5300108', 'Depósito dos Restos Mortais no Memorial JK', 'Inauguração do Memorial JK em Brasília com projeto de Oscar Niemeyer.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_sarah', 'pub_sarah_jk', 'nascimento', 1908, 1908, 'exata', '5 de outubro de 1908', 'ibge-3106200', 'Nascimento em Belo Horizonte', 'Primeira-dama do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_sarah_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_sarah', 'pub_sarah_jk', 'falecimento', 1996, 1996, 'exata', '4 de fevereiro de 1996', 'ibge-5300108', 'Falecimento em Brasília', 'Fundadora das Pioneiras Sociais e da Rede Sarah.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_sarah_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_marcia', 'pub_marcia_jk', 'nascimento', 1943, 1943, 'exata', '22 de outubro de 1943', 'ibge-3106200', 'Nascimento em Belo Horizonte', 'Jornalista e política.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_marcia_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_marcia', 'pub_marcia_jk', 'falecimento', 2000, 2000, 'exata', '5 de agosto de 2000', 'ibge-3550308', 'Falecimento em São Paulo', 'Deputada federal e vice-governadora do DF.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_marcia_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jose_bonifacio', 'pub_jose_bonifacio', 'nascimento', 1763, 1763, 'exata', '13 de junho de 1763', 'ibge-3548500', 'Nascimento em Santos', '"Patriarca da Independência".'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jose_bonifacio')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jose_bonifacio', 'pub_jose_bonifacio', 'falecimento', 1838, 1838, 'exata', '6 de abril de 1838', 'ibge-3304557', 'Falecimento na Ilha de Paquetá', 'Cientista, mineralogista e estadista.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jose_bonifacio')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_bonifacio_coimbra', 'pub_jose_bonifacio', 'evento', 1788, 1788, 'exata', '16 de julho de 1788', 'loc-pt-coimbra', 'Formatura na Universidade de Coimbra', 'Graduação em Leis e Filosofia Natural.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jose_bonifacio')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_bonifacio_ministerio', 'pub_jose_bonifacio', 'posse', 1822, 1822, 'exata', '16 de janeiro de 1822', 'ibge-3304557', 'Ministério do Reino e Negócios Estrangeiros', 'Primeiro gabinete ministerial legitimamente brasileiro.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_jose_bonifacio')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_bonifacio_pai', 'pub_bonifacio_jose_pai', 'nascimento', 1726, 1726, 'cerca_de', 'cerca de 1726', 'ibge-3548500', 'Nascimento em Santos', 'Coronel de milícias e comerciante.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bonifacio_jose_pai')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_bonifacio_pai', 'pub_bonifacio_jose_pai', 'falecimento', 1789, 1789, 'exata', '25 de julho de 1789', 'ibge-3548500', 'Falecimento em Santos', 'Pai dos Andradas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bonifacio_jose_pai')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria_barbara_mae', 'pub_maria_barbara_mae', 'nascimento', 1740, 1740, 'cerca_de', 'cerca de 1740', 'ibge-3548500', 'Nascimento em Santos', 'Matriarca da família Andrada.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_barbara_mae')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria_barbara_mae', 'pub_maria_barbara_mae', 'falecimento', 1821, 1821, 'exata', '31 de outubro de 1821', 'ibge-3548500', 'Falecimento em Santos', 'Mãe de José Bonifácio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_barbara_mae')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_gabriela_andrada', 'pub_gabriela_andrada', 'nascimento', 1798, 1798, 'exata', '15 de agosto de 1798', 'ibge-3548500', 'Nascimento em Santos', 'Filha de José Bonifácio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_gabriela_andrada')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_gabriela_andrada', 'pub_gabriela_andrada', 'falecimento', 1860, 1860, 'exata', '21 de julho de 1860', 'ibge-3548500', 'Falecimento em Santos', 'Família Andrada.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_gabriela_andrada')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_narcisa_oleary', 'pub_ph_narcisa_oleary', 'nascimento', 1772, 1772, 'cerca_de', 'cerca de 1772', 'loc-gb-londres', 'Nascimento nas Ilhas Britânicas', 'Esposa de José Bonifácio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_ph_narcisa_oleary')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_narcisa_oleary', 'pub_ph_narcisa_oleary', 'falecimento', 1829, 1829, 'exata', '5 de junho de 1829', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Sepultada no Convento de Santo Antônio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_ph_narcisa_oleary')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria_quiteria', 'pub_maria_quiteria', 'nascimento', 1792, 1792, 'exata', '27 de julho de 1792', 'ibge-2910800', 'Nascimento em Feira de Santana', 'Heroína da Independência do Brasil.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_quiteria')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria_quiteria', 'pub_maria_quiteria', 'falecimento', 1853, 1853, 'exata', '21 de agosto de 1853', 'ibge-2927408', 'Falecimento em Salvador', 'Sepultada na Igreja de Santana.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_quiteria')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_quiteria_condecoracao', 'pub_maria_quiteria', 'titulo', 1823, 1823, 'exata', '20 de agosto de 1823', 'ibge-3304557', 'Condecoração por D. Pedro I', 'Agraciada com a Ordem Imperial do Cruzeiro pela bravura na guerra.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_quiteria')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria_felipa', 'pub_maria_felipa', 'nascimento', 1799, 1799, 'cerca_de', 'cerca de 1799', 'ibge-2916104', 'Nascimento em Itaparica', 'Mulher negra marisqueira e combatente popular.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_felipa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria_felipa', 'pub_maria_felipa', 'falecimento', 1873, 1873, 'exata', '4 de julho de 1873', 'ibge-2916104', 'Falecimento em Itaparica', 'Líder das "Vedetas" na guerra de libertação da Bahia.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_felipa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_felipa_batalha', 'pub_maria_felipa', 'batalha', 1823, 1823, 'exata', '7 de janeiro de 1823', 'ibge-2916104', 'Batalha Naval e Queima da Armada Portuguesa', 'Ataque com cansanção e fogo contra os navios portugueses na Praia do Convento.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_maria_felipa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_frei_caneca', 'pub_frei_caneca', 'nascimento', 1779, 1779, 'exata', '20 de agosto de 1779', 'ibge-2611606', 'Nascimento no Recife', 'Religioso e líder revolucionário.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_frei_caneca')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_frei_caneca', 'pub_frei_caneca', 'falecimento', 1825, 1825, 'exata', '13 de janeiro de 1825', 'ibge-2611606', 'Execução no Forte das Cinco Pontas', 'Arcabuzado na repressão à Confederação do Equador.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_frei_caneca')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_goncalves_ledo', 'pub_goncalves_ledo', 'nascimento', 1781, 1781, 'exata', '11 de dezembro de 1781', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Líder liberal e jornalista.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_goncalves_ledo')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_goncalves_ledo', 'pub_goncalves_ledo', 'falecimento', 1847, 1847, 'exata', '19 de maio de 1847', 'ibge-3305703', 'Falecimento em Sumidouro', 'Articulador do movimento de emancipação política.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_goncalves_ledo')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_januario_barbosa', 'pub_januario_barbosa', 'nascimento', 1780, 1780, 'exata', '10 de julho de 1780', 'ibge-3304557', 'Nascimento no Rio de Janeiro', 'Cônego e jornalista patriota.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_januario_barbosa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_januario_barbosa', 'pub_januario_barbosa', 'falecimento', 1846, 1846, 'exata', '26 de abril de 1846', 'ibge-3303302', 'Falecimento em Niterói', 'Fundador e secretário perpétuo do IHGB.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_januario_barbosa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_joana_angelica', 'pub_joana_angelica', 'nascimento', 1761, 1761, 'exata', '12 de dezembro de 1761', 'ibge-2927408', 'Nascimento em Salvador', 'Religiosa franciscana.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joana_angelica')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_joana_angelica', 'pub_joana_angelica', 'falecimento', 1822, 1822, 'exata', '19 de fevereiro de 1822', 'ibge-2927408', 'Morte Heróica no Convento da Lapa', 'Assassinada por tropas portuguesas ao defender a clausura do convento.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_joana_angelica')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_marquesa_santos', 'pub_marquesa_santos', 'nascimento', 1797, 1797, 'exata', '27 de dezembro de 1797', 'ibge-3550308', 'Nascimento em São Paulo', 'Domitila de Castro Canto e Melo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_marquesa_santos')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_marquesa_santos', 'pub_marquesa_santos', 'falecimento', 1867, 1867, 'exata', '3 de novembro de 1867', 'ibge-3550308', 'Falecimento em São Paulo', 'Sepultada no Cemitério da Consolação.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_marquesa_santos')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_martim_francisco', 'pub_martim_francisco', 'nascimento', 1775, 1775, 'exata', '19 de abril de 1775', 'ibge-3548500', 'Nascimento em Santos', 'Ministro da Fazenda.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_martim_francisco')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_martim_francisco', 'pub_martim_francisco', 'falecimento', 1844, 1844, 'exata', '23 de fevereiro de 1844', 'ibge-3548500', 'Falecimento em Santos', 'Irmão de José Bonifácio.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_martim_francisco')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_antonio_carlos', 'pub_antonio_carlos', 'nascimento', 1773, 1773, 'exata', '1 de novembro de 1773', 'ibge-3548500', 'Nascimento em Santos', 'Orador parlamentar.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_antonio_carlos')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_antonio_carlos', 'pub_antonio_carlos', 'falecimento', 1845, 1845, 'exata', '5 de dezembro de 1845', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Deputado constituinte.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_antonio_carlos')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_marie_curie', 'pub_curie_marie_skodowska_curie', 'nascimento', 1867, 1867, 'exata', '7 de novembro de 1867', 'loc-pl-varsovia', 'Nascimento em Varsóvia', 'Física e química pioneira nos estudos de radioatividade.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_marie_skodowska_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_marie_curie', 'pub_curie_marie_skodowska_curie', 'falecimento', 1934, 1934, 'exata', '4 de julho de 1934', 'hist_fr_passy', 'Falecimento em Passy', 'Sanatório de Sancellemoz, Alta Saboia.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_marie_skodowska_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_curie_nobel_fisica', 'pub_curie_marie_skodowska_curie', 'titulo', 1903, 1903, 'exata', '10 de dezembro de 1903', 'loc-se-estocolmo', 'Prêmio Nobel de Física', 'Primeira mulher a ganhar o Prêmio Nobel.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_marie_skodowska_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_curie_nobel_quimica', 'pub_curie_marie_skodowska_curie', 'titulo', 1911, 1911, 'exata', '10 de dezembro de 1911', 'loc-se-estocolmo', 'Prêmio Nobel de Química', 'Única pessoa laureada em duas ciências naturais distintas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_marie_skodowska_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_curie_radio', 'pub_curie_marie_skodowska_curie', 'publicacao', 1898, 1898, 'exata', '26 de dezembro de 1898', 'loc-fr-paris', 'Descoberta do Rádio e Polônio', 'Apresentação à Academia de Ciências de Paris.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_marie_skodowska_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_pierre_curie', 'pub_curie_pierre_curie', 'nascimento', 1859, 1859, 'exata', '15 de maio de 1859', 'loc-fr-paris', 'Nascimento em Paris', 'Físico, pioneiro na piezoeletricidade.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_pierre_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_pierre_curie', 'pub_curie_pierre_curie', 'falecimento', 1906, 1906, 'exata', '19 de abril de 1906', 'loc-fr-paris', 'Falecimento em Paris', 'Atropelamento acidental na Rue Dauphine.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_pierre_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_irene_curie', 'pub_curie_irene_joliot_curie', 'nascimento', 1897, 1897, 'exata', '12 de setembro de 1897', 'loc-fr-paris', 'Nascimento em Paris', 'Física e química.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_irene_joliot_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_irene_curie', 'pub_curie_irene_joliot_curie', 'falecimento', 1956, 1956, 'exata', '17 de março de 1956', 'loc-fr-paris', 'Falecimento em Paris', 'Laureada com o Nobel.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_irene_joliot_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_irene_nobel', 'pub_curie_irene_joliot_curie', 'titulo', 1935, 1935, 'exata', '10 de dezembro de 1935', 'loc-se-estocolmo', 'Prêmio Nobel de Química', 'Descoberta da radioatividade artificial.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_irene_joliot_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_frederic_curie', 'pub_curie_frederic_joliot_curie', 'nascimento', 1900, 1900, 'exata', '19 de março de 1900', 'loc-fr-paris', 'Nascimento em Paris', 'Físico nuclear.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_frederic_joliot_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_frederic_curie', 'pub_curie_frederic_joliot_curie', 'falecimento', 1958, 1958, 'exata', '14 de agosto de 1958', 'loc-fr-paris', 'Falecimento em Paris', 'Alto comissário de energia atômica.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_frederic_joliot_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jacques_curie', 'pub_curie_jacques_curie', 'nascimento', 1856, 1856, 'exata', '29 de outubro de 1856', 'loc-fr-paris', 'Nascimento em Paris', 'Físico e co-descobridor da piezoeletricidade.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_jacques_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jacques_curie', 'pub_curie_jacques_curie', 'falecimento', 1941, 1941, 'exata', '19 de fevereiro de 1941', 'loc-fr-paris', 'Falecimento em Montpellier', 'Professor da Faculdade de Ciências.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_jacques_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_eve_curie', 'pub_curie_eve_curie', 'nascimento', 1904, 1904, 'exata', '6 de dezembro de 1904', 'loc-fr-paris', 'Nascimento em Paris', 'Escritora e diplomata.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_eve_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_eve_curie', 'pub_curie_eve_curie', 'falecimento', 2007, 2007, 'exata', '22 de outubro de 2007', 'loc-us-novayork', 'Falecimento em Nova York', 'Autora da aclamada biografia Madame Curie.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_curie_eve_curie')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_js_bach', 'pub_bach_johann_sebastian_bach', 'nascimento', 1685, 1685, 'exata', '31 de março de 1685', 'hist_de_eisenach', 'Nascimento em Eisenach', 'Compositor e organista mestre do Barroco.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_sebastian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_js_bach', 'pub_bach_johann_sebastian_bach', 'falecimento', 1750, 1750, 'exata', '28 de julho de 1750', 'loc-de-leipzig', 'Falecimento em Leipzig', 'Sepultado na Igreja de São Tomás.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_sebastian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_bach_weimar', 'pub_bach_johann_sebastian_bach', 'posse', 1708, 1708, 'exata', '14 de julho de 1708', 'hist_de_weimar', 'Organista da Corte em Weimar', 'Composição de obras-primas para órgão e cantatas.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_sebastian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_bach_kothen', 'pub_bach_johann_sebastian_bach', 'posse', 1717, 1717, 'exata', '1 de agosto de 1717', 'hist_de_kothen', 'Kapellmeister em Köthen', 'Criação dos Concertos de Brandemburgo e O Cravo Bem Temperado.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_sebastian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_bach_leipzig', 'pub_bach_johann_sebastian_bach', 'posse', 1723, 1723, 'exata', '5 de maio de 1723', 'loc-de-leipzig', 'Thomaskantor em Leipzig', 'Diretor de música sacra da Igreja de São Tomás.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_sebastian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_anna_magdalena', 'pub_bach_anna_magdalena_bach', 'nascimento', 1701, 1701, 'exata', '22 de setembro de 1701', 'loc-de-leipzig', 'Nascimento em Zeitz', 'Cantora lírica e copista musical.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_anna_magdalena_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_anna_magdalena', 'pub_bach_anna_magdalena_bach', 'falecimento', 1760, 1760, 'exata', '22 de fevereiro de 1760', 'loc-de-leipzig', 'Falecimento em Leipzig', 'Dedicatária do Caderno de Anna Magdalena Bach.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_anna_magdalena_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_maria_barbara', 'pub_bach_maria_barbara_bach', 'nascimento', 1684, 1684, 'exata', '20 de outubro de 1684', 'hist_de_arnstadt', 'Nascimento em Gehren', 'Primeira esposa de J. S. Bach.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_maria_barbara_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_maria_barbara', 'pub_bach_maria_barbara_bach', 'falecimento', 1720, 1720, 'exata', '7 de julho de 1720', 'hist_de_kothen', 'Falecimento em Köthen', 'Mãe de C. P. E. Bach e W. F. Bach.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_maria_barbara_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_ambrosius_bach', 'pub_bach_johann_ambrosius_bach', 'nascimento', 1645, 1645, 'exata', '22 de fevereiro de 1645', 'hist_de_eisenach', 'Nascimento em Erfurt', 'Músico da cidade de Eisenach.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_ambrosius_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_ambrosius_bach', 'pub_bach_johann_ambrosius_bach', 'falecimento', 1695, 1695, 'exata', '2 de março de 1695', 'hist_de_eisenach', 'Falecimento em Eisenach', 'Pai de Johann Sebastian Bach.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_ambrosius_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_cpe_bach', 'pub_bach_carl_philipp_emanuel_bach', 'nascimento', 1714, 1714, 'exata', '8 de março de 1714', 'hist_de_weimar', 'Nascimento em Weimar', 'Compositor da transição para o Classicismo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_carl_philipp_emanuel_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_cpe_bach', 'pub_bach_carl_philipp_emanuel_bach', 'falecimento', 1788, 1788, 'exata', '14 de dezembro de 1788', 'loc-de-hamburgo', 'Falecimento em Hamburgo', '"O Bach de Hamburgo".'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_carl_philipp_emanuel_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_wf_bach', 'pub_bach_wilhelm_friedemann_bach', 'nascimento', 1710, 1710, 'exata', '22 de novembro de 1710', 'hist_de_weimar', 'Nascimento em Weimar', 'Primogênito de J. S. Bach e organista virtuoso.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_wilhelm_friedemann_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_wf_bach', 'pub_bach_wilhelm_friedemann_bach', 'falecimento', 1784, 1784, 'exata', '1 de julho de 1784', 'loc-de-berlim', 'Falecimento em Berlim', 'Compositor da escola de Berlim.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_wilhelm_friedemann_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jc_bach', 'pub_bach_johann_christian_bach', 'nascimento', 1735, 1735, 'exata', '5 de setembro de 1735', 'loc-de-leipzig', 'Nascimento em Leipzig', '"O Bach de Londres", influenciador de Mozart.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_christian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jc_bach', 'pub_bach_johann_christian_bach', 'falecimento', 1782, 1782, 'exata', '1 de janeiro de 1782', 'loc-gb-londres', 'Falecimento em Londres', 'Mestre de música da Rainha Charlotte.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_christian_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jcf_bach', 'pub_bach_johann_christoph_friedrich_bach', 'nascimento', 1732, 1732, 'exata', '21 de junho de 1732', 'loc-de-leipzig', 'Nascimento em Leipzig', '"O Bach de Bückeburg".'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_christoph_friedrich_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jcf_bach', 'pub_bach_johann_christoph_friedrich_bach', 'falecimento', 1795, 1795, 'exata', '26 de janeiro de 1795', 'loc-de-leipzig', 'Falecimento em Bückeburg', 'Músico de câmara e compositor.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_bach_johann_christoph_friedrich_bach')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_darwin', 'pub_darwin_charles_darwin', 'nascimento', 1809, 1809, 'exata', '12 de fevereiro de 1809', 'hist_gb_shrewsbury', 'Nascimento em Shrewsbury', 'The Mount, Shropshire.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_darwin', 'pub_darwin_charles_darwin', 'falecimento', 1882, 1882, 'exata', '19 de abril de 1882', 'loc-gb-londres', 'Falecimento em Downe', 'Sepultado na Abadia de Westminster.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darwin_plymouth', 'pub_darwin_charles_darwin', 'evento', 1831, 1831, 'exata', '27 de dezembro de 1831', 'hist_gb_plymouth', 'Partida da Expedição do HMS Beagle', 'Início da circum-navegação científica com o capitão FitzRoy.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darwin_bahia', 'pub_darwin_charles_darwin', 'evento', 1832, 1832, 'exata', '28 de fevereiro de 1832', 'ibge-2927408', 'Desembarque e Pesquisa em Salvador', 'Primeiro contato com a exuberância e biodiversidade da Mata Atlântica.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darwin_rio', 'pub_darwin_charles_darwin', 'evento', 1832, 1832, 'exata', '5 de abril de 1832', 'ibge-3304557', 'Expedição Naturalista no Rio de Janeiro', 'Pesquisa biológica na Baía de Guanabara e Serra dos Órgãos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darwin_galapagos', 'pub_darwin_charles_darwin', 'evento', 1835, 1835, 'exata', '15 de setembro de 1835', 'hist_ec_galapagos', 'Estudos no Arquipélago de Galápagos', 'Observações cruciais sobre a variação de espécies e tentilhões.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_darwin_origem', 'pub_darwin_charles_darwin', 'publicacao', 1859, 1859, 'exata', '24 de novembro de 1859', 'loc-gb-londres', 'Publicação de "A Origem das Espécies"', 'Apresentação da teoria da evolução por seleção natural.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_charles_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_emma_darwin', 'pub_darwin_emma_darwin', 'nascimento', 1808, 1808, 'exata', '2 de maio de 1808', 'hist_gb_shrewsbury', 'Nascimento em Maer', 'Nascida Emma Wedgwood.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_emma_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_emma_darwin', 'pub_darwin_emma_darwin', 'falecimento', 1896, 1896, 'exata', '2 de outubro de 1896', 'loc-gb-londres', 'Falecimento em Downe', 'Esposa e colaboradora de Charles Darwin.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_emma_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_erasmus_darwin', 'pub_darwin_erasmus_darwin', 'nascimento', 1731, 1731, 'exata', '12 de dezembro de 1731', 'hist_gb_shrewsbury', 'Nascimento em Elston Hall', 'Médico, poeta e filósofo natural.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_erasmus_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_erasmus_darwin', 'pub_darwin_erasmus_darwin', 'falecimento', 1802, 1802, 'exata', '18 de abril de 1802', 'hist_gb_shrewsbury', 'Falecimento em Breadsall Priory', 'Membro fundador da Sociedade Lunar.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_erasmus_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_robert_darwin', 'pub_darwin_robert_waring_darwin', 'nascimento', 1766, 1766, 'exata', '30 de maio de 1766', 'hist_gb_shrewsbury', 'Nascimento em Lichfield', 'Médico e financeiro, pai de Charles Darwin.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_robert_waring_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_robert_darwin', 'pub_darwin_robert_waring_darwin', 'falecimento', 1848, 1848, 'exata', '13 de novembro de 1848', 'hist_gb_shrewsbury', 'Falecimento em The Mount, Shrewsbury', 'Sepultado em Montford.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_robert_waring_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_josiah_wedgwood', 'pub_darwin_josiah_wedgwood_i', 'nascimento', 1730, 1730, 'exata', '12 de julho de 1730', 'hist_gb_shrewsbury', 'Nascimento em Burslem', 'Pioneiro da cerâmica industrial e abolicionista.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_josiah_wedgwood_i')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_josiah_wedgwood', 'pub_darwin_josiah_wedgwood_i', 'falecimento', 1795, 1795, 'exata', '3 de janeiro de 1795', 'hist_gb_shrewsbury', 'Falecimento em Etruria Hall', 'Stoke-on-Trent.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_josiah_wedgwood_i')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_susannah_darwin', 'pub_darwin_susannah_darwin', 'nascimento', 1765, 1765, 'exata', '11 de janeiro de 1765', 'hist_gb_shrewsbury', 'Nascimento em Burslem', 'Mãe de Charles Darwin.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_susannah_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_susannah_darwin', 'pub_darwin_susannah_darwin', 'falecimento', 1817, 1817, 'exata', '15 de julho de 1817', 'hist_gb_shrewsbury', 'Falecimento em Shrewsbury', 'Esposa de Robert Darwin.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_darwin_susannah_darwin')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_vitoria_uk', 'pub_vitoria_uk', 'nascimento', 1819, 1819, 'exata', '24 de maio de 1819', 'loc-gb-londres', 'Nascimento no Palácio de Kensington', 'Rainha do Reino Unido e Imperatriz da Índia.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vitoria_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_vitoria_uk', 'pub_vitoria_uk', 'falecimento', 1901, 1901, 'exata', '22 de janeiro de 1901', 'hist_gb_cowes', 'Falecimento em Osborne House', 'Encerramento da Era Vitoriana.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vitoria_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_vitoria_imperatriz', 'pub_vitoria_uk', 'titulo', 1876, 1876, 'exata', '1 de maio de 1876', 'loc-gb-londres', 'Proclamação como Imperatriz da Índia', 'Royal Titles Act.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_vitoria_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_alberto_uk', 'pub_alberto_uk', 'nascimento', 1819, 1819, 'exata', '26 de agosto de 1819', 'hist_de_coburgo', 'Nascimento em Coburgo', 'Príncipe de Saxe-Coburgo-Gota.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alberto_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_alberto_uk', 'pub_alberto_uk', 'falecimento', 1861, 1861, 'exata', '14 de dezembro de 1861', 'hist_gb_windsor', 'Falecimento no Castelo de Windsor', 'Príncipe consorte britânico.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alberto_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_alberto_crystalpalace', 'pub_alberto_uk', 'evento', 1851, 1851, 'exata', '1 de maio de 1851', 'loc-gb-londres', 'Inauguração da Grande Exposição de 1851', 'Feira Mundial no Palácio de Cristal em Londres.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alberto_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_elizabeth2_uk', 'pub_elizabeth2_uk', 'nascimento', 1926, 1926, 'exata', '21 de abril de 1926', 'loc-gb-londres', 'Nascimento em Mayfair', 'Londres.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth2_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_elizabeth2_uk', 'pub_elizabeth2_uk', 'falecimento', 2022, 2022, 'exata', '8 de setembro de 2022', 'hist_gb_balmoral', 'Falecimento no Castelo de Balmoral', '70 anos de reinado soberano.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth2_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_elizabeth2_coroacao', 'pub_elizabeth2_uk', 'posse', 1953, 1953, 'exata', '2 de junho de 1953', 'loc-gb-londres', 'Coroação na Abadia de Westminster', 'Primeira coroação britânica transmitida ao vivo pela televisão.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth2_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_elizabeth2_platina', 'pub_elizabeth2_uk', 'evento', 2022, 2022, 'exata', '5 de junho de 2022', 'loc-gb-londres', 'Jubileu de Platina', 'Comemoração dos 70 anos de ascensão ao trono.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth2_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_philip_uk', 'pub_philip_uk', 'nascimento', 1921, 1921, 'exata', '10 de junho de 1921', 'hist_gr_corfu', 'Nascimento em Mon Repos', 'Príncipe da Grécia e Dinamarca.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_philip_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_philip_uk', 'pub_philip_uk', 'falecimento', 2021, 2021, 'exata', '9 de abril de 2021', 'hist_gb_windsor', 'Falecimento no Castelo de Windsor', 'Duque de Edimburgo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_philip_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_diana_uk', 'pub_diana_uk', 'nascimento', 1961, 1961, 'exata', '1 de julho de 1961', 'hist_gb_sandringham', 'Nascimento em Sandringham', 'Park House, Norfolk.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_diana_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_diana_uk', 'pub_diana_uk', 'falecimento', 1997, 1997, 'exata', '31 de agosto de 1997', 'loc-fr-paris', 'Falecimento Trágico em Paris', 'Túnel da Pont de l’Alma.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_diana_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_diana_casamento', 'pub_diana_uk', 'evento', 1981, 1981, 'exata', '29 de julho de 1981', 'loc-gb-londres', 'Casamento na Catedral de São Paulo', 'Cerimônia assistida por mais de 750 milhões de telespectadores no mundo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_diana_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_george6_uk', 'pub_george6_uk', 'nascimento', 1895, 1895, 'exata', '14 de dezembro de 1895', 'hist_gb_sandringham', 'Nascimento em Sandringham', 'York Cottage.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_george6_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_george6_uk', 'pub_george6_uk', 'falecimento', 1952, 1952, 'exata', '6 de fevereiro de 1952', 'hist_gb_sandringham', 'Falecimento em Sandringham', 'Rei durante a 2ª Guerra Mundial.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_george6_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_elizabeth_mae_uk', 'pub_elizabeth_mae_uk', 'nascimento', 1900, 1900, 'exata', '4 de agosto de 1900', 'loc-gb-londres', 'Nascimento em Londres', 'Rainha consorte britânica.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth_mae_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_elizabeth_mae_uk', 'pub_elizabeth_mae_uk', 'falecimento', 2002, 2002, 'exata', '30 de março de 2002', 'hist_gb_windsor', 'Falecimento no Royal Lodge', 'Centenária (101 anos).'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_elizabeth_mae_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_george5_uk', 'pub_george5_uk', 'nascimento', 1865, 1865, 'exata', '3 de junho de 1865', 'loc-gb-londres', 'Nascimento em Londres', 'Fundador da Casa de Windsor.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_george5_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_george5_uk', 'pub_george5_uk', 'falecimento', 1936, 1936, 'exata', '20 de janeiro de 1936', 'hist_gb_sandringham', 'Falecimento em Sandringham', 'Sandringham House.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_george5_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_mary_uk', 'pub_mary_uk', 'nascimento', 1867, 1867, 'exata', '26 de maio de 1867', 'loc-gb-londres', 'Nascimento em Londres', 'Palácio de Kensington.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mary_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_mary_uk', 'pub_mary_uk', 'falecimento', 1953, 1953, 'exata', '24 de março de 1953', 'loc-gb-londres', 'Falecimento em Londres', 'Marlborough House.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_mary_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_edward7_uk', 'pub_edward7_uk', 'nascimento', 1841, 1841, 'exata', '9 de novembro de 1841', 'loc-gb-londres', 'Nascimento em Londres', 'Palácio de Buckingham.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_edward7_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_edward7_uk', 'pub_edward7_uk', 'falecimento', 1910, 1910, 'exata', '6 de maio de 1910', 'loc-gb-londres', 'Falecimento em Londres', 'Palácio de Buckingham.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_edward7_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_alexandra_uk', 'pub_alexandra_uk', 'nascimento', 1844, 1844, 'exata', '1 de dezembro de 1844', 'loc-dk-copenhague', 'Nascimento em Copenhague', 'Palácio de Amalienborg.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alexandra_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_alexandra_uk', 'pub_alexandra_uk', 'falecimento', 1925, 1925, 'exata', '20 de novembro de 1925', 'hist_gb_sandringham', 'Falecimento em Sandringham', 'Sandringham House.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_alexandra_uk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jfk', 'pub_kennedy_john_f_kennedy', 'nascimento', 1917, 1917, 'exata', '29 de maio de 1917', 'loc-us-boston', 'Nascimento em Brookline', '35º Presidente dos EUA.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_john_f_kennedy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jfk', 'pub_kennedy_john_f_kennedy', 'falecimento', 1963, 1963, 'exata', '22 de novembro de 1963', 'loc-us-dallas', 'Assassinato em Dallas', 'Atentado em Dealey Plaza.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_john_f_kennedy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_jfk_posse', 'pub_kennedy_john_f_kennedy', 'posse', 1961, 1961, 'exata', '20 de janeiro de 1961', 'loc-us-washington', 'Posse Presidencial', '"Não pergunte o que seu país pode fazer por você..."'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_john_f_kennedy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_jackie_kennedy', 'pub_kennedy_jacqueline_kennedy_onassis', 'nascimento', 1929, 1929, 'exata', '28 de julho de 1929', 'loc-us-novayork', 'Nascimento em Southampton', 'Primeira-dama dos Estados Unidos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_jacqueline_kennedy_onassis')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_jackie_kennedy', 'pub_kennedy_jacqueline_kennedy_onassis', 'falecimento', 1994, 1994, 'exata', '19 de maio de 1994', 'loc-us-novayork', 'Falecimento em Nova York', 'Manhattan.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_jacqueline_kennedy_onassis')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_rfk', 'pub_kennedy_robert_f_kennedy', 'nascimento', 1925, 1925, 'exata', '20 de novembro de 1925', 'loc-us-boston', 'Nascimento em Brookline', 'Procurador-Geral e Senador.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_robert_f_kennedy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_rfk', 'pub_kennedy_robert_f_kennedy', 'falecimento', 1968, 1968, 'exata', '6 de junho de 1968', 'loc-us-washington', 'Assassinato no Hotel Ambassador', 'Atentado em Los Angeles.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_kennedy_robert_f_kennedy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_fdr', 'pub_roosevelt_franklin_d_roosevelt', 'nascimento', 1882, 1882, 'exata', '30 de janeiro de 1882', 'loc-us-novayork', 'Nascimento em Hyde Park', '32º Presidente dos Estados Unidos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_franklin_d_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_fdr', 'pub_roosevelt_franklin_d_roosevelt', 'falecimento', 1945, 1945, 'exata', '12 de abril de 1945', 'loc-us-washington', 'Falecimento em Warm Springs', 'Little White House, Geórgia.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_franklin_d_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_marco_fdr_posse', 'pub_roosevelt_franklin_d_roosevelt', 'posse', 1933, 1933, 'exata', '4 de março de 1933', 'loc-us-washington', 'Posse e Lançamento do New Deal', 'Combate à Grande Depressão.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_franklin_d_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_eleanor_roosevelt', 'pub_roosevelt_eleanor_roosevelt', 'nascimento', 1884, 1884, 'exata', '11 de outubro de 1884', 'loc-us-novayork', 'Nascimento em Nova York', 'Diplomata e ativista dos direitos humanos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_eleanor_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_eleanor_roosevelt', 'pub_roosevelt_eleanor_roosevelt', 'falecimento', 1962, 1962, 'exata', '7 de novembro de 1962', 'loc-us-novayork', 'Falecimento em Manhattan', 'Primeira presidente da Comissão de Direitos Humanos da ONU.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_eleanor_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_ted_roosevelt', 'pub_roosevelt_theodore_roosevelt', 'nascimento', 1858, 1858, 'exata', '27 de outubro de 1858', 'loc-us-novayork', 'Nascimento em Manhattan', '26º Presidente dos EUA e Prêmio Nobel da Paz.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_theodore_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_ted_roosevelt', 'pub_roosevelt_theodore_roosevelt', 'falecimento', 1919, 1919, 'exata', '6 de janeiro de 1919', 'loc-us-novayork', 'Falecimento em Sagamore Hill', 'Oyster Bay, Nova York.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_roosevelt_theodore_roosevelt')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_rockefeller', 'pub_rockefeller_john_d_rockefeller', 'nascimento', 1839, 1839, 'exata', '8 de julho de 1839', 'loc-us-novayork', 'Nascimento em Richford', 'Fundador da Standard Oil e filantropo.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_john_d_rockefeller')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_rockefeller', 'pub_rockefeller_john_d_rockefeller', 'falecimento', 1937, 1937, 'exata', '23 de maio de 1937', 'loc-us-novayork', 'Falecimento em Ormond Beach', 'The Casements, Flórida.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_rockefeller_john_d_rockefeller')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_matarazzo', 'pub_matarazzo_francesco_matarazzo', 'nascimento', 1854, 1854, 'exata', '9 de março de 1854', 'hist_it_castellabate', 'Nascimento em Castellabate', 'Pioneiro da industrialização brasileira (IRFM).'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_francesco_matarazzo')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_matarazzo', 'pub_matarazzo_francesco_matarazzo', 'falecimento', 1937, 1937, 'exata', '10 de fevereiro de 1937', 'ibge-3550308', 'Falecimento em São Paulo', 'Mausoléu no Cemitério da Consolação.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_matarazzo_francesco_matarazzo')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_guinle', 'pub_guinle_eduardo_palassin_guinle', 'nascimento', 1846, 1846, 'exata', '28 de junho de 1846', 'ibge-4314902', 'Nascimento em Porto Alegre', 'Empresário e pioneiro da modernização portuária.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_eduardo_palassin_guinle')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_guinle', 'pub_guinle_eduardo_palassin_guinle', 'falecimento', 1912, 1912, 'exata', '20 de março de 1912', 'ibge-3304557', 'Falecimento no Rio de Janeiro', 'Construção do Porto de Santos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_guinle_eduardo_palassin_guinle')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_penteado', 'pub_penteado_armando_alvares_penteado', 'nascimento', 1884, 1884, 'exata', '30 de setembro de 1884', 'ibge-3550308', 'Nascimento em São Paulo', 'Engenheiro, patrono das artes e criador da FAAP.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_penteado_armando_alvares_penteado')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_penteado', 'pub_penteado_armando_alvares_penteado', 'falecimento', 1947, 1947, 'exata', '27 de janeiro de 1947', 'ibge-3550308', 'Falecimento em São Paulo', 'Fundação Armando Álvares Penteado.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_penteado_armando_alvares_penteado')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_evita', 'pub_peron_eva_peron', 'nascimento', 1919, 1919, 'exata', '7 de maio de 1919', 'loc-ar-buenosaires', 'Nascimento em Los Toldos', '"Evita", líder política e ícone argentino.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_peron_eva_peron')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_evita', 'pub_peron_eva_peron', 'falecimento', 1952, 1952, 'exata', '26 de julho de 1952', 'loc-ar-buenosaires', 'Falecimento no Palácio Presidencial', 'Sepultada no Cemitério da Recoleta.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_peron_eva_peron')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_nasc_peron', 'pub_peron_juan_domingo_peron', 'nascimento', 1895, 1895, 'exata', '8 de outubro de 1895', 'loc-ar-buenosaires', 'Nascimento em Lobos', 'Presidente da Argentina em três mandatos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_peron_juan_domingo_peron')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_morte_peron', 'pub_peron_juan_domingo_peron', 'falecimento', 1974, 1974, 'exata', '1 de julho de 1974', 'loc-ar-buenosaires', 'Falecimento em Olivos', 'Quinta Presidencial de Olivos.'
WHERE EXISTS (SELECT 1 FROM pessoas WHERE id = 'pub_peron_juan_domingo_peron')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;

-- 4. Georreferenciamento dos casamentos da Família Imperial, Presidentes e Reais
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_joao6_carlota', 'pub_u_joao6_carlota', 'casamento', 1785, 1785, 'exata', '8 de maio de 1785', 'loc-pt-lisboa', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_joao6_carlota')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_pedro1_leopoldina', 'pub_u_pedro1_leopoldina', 'casamento', 1817, 1817, 'exata', '5 de novembro de 1817', 'ibge-3304557', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_pedro1_leopoldina')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_pedro2_teresa', 'pub_u_pedro2_teresa', 'casamento', 1843, 1843, 'exata', '4 de setembro de 1843', 'ibge-3304557', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_pedro2_teresa')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_isabel_conde_deu', 'pub_u_isabel_conde_deu', 'casamento', 1864, 1864, 'exata', '15 de outubro de 1864', 'ibge-3304557', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_isabel_conde_deu')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_deodoro_mariana', 'pub_u_deodoro_mariana', 'casamento', 1860, 1860, 'exata', '16 de abril de 1860', 'ibge-4311007', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_deodoro_mariana')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_pais_vargas', 'pub_u_pais_vargas', 'casamento', 1872, 1872, 'exata', '16 de janeiro de 1872', 'ibge-4318705', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_pais_vargas')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_getulio_darcy', 'pub_u_getulio_darcy', 'casamento', 1911, 1911, 'exata', '4 de março de 1911', 'ibge-4318705', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_getulio_darcy')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_pais_jk', 'pub_u_pais_jk', 'casamento', 1898, 1898, 'exata', '18 de junho de 1898', 'ibge-3121605', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_pais_jk')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_jk_sarah', 'pub_u_jk_sarah', 'casamento', 1931, 1931, 'exata', '30 de dezembro de 1931', 'ibge-3106200', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_jk_sarah')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_pedro3_maria1', 'pub_u_pedro3_maria1', 'casamento', 1760, 1760, 'exata', '6 de junho de 1760', 'loc-pt-lisboa', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_pedro3_maria1')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_maria2_fernando2', 'pub_u_maria2_fernando2', 'casamento', 1836, 1836, 'exata', '9 de abril de 1836', 'loc-pt-lisboa', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_maria2_fernando2')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_luis1_mariapia', 'pub_u_luis1_mariapia', 'casamento', 1862, 1862, 'exata', '6 de outubro de 1862', 'loc-pt-lisboa', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_luis1_mariapia')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_vitoria_alberto', 'pub_u_vitoria_alberto', 'casamento', 1840, 1840, 'exata', '10 de fevereiro de 1840', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_vitoria_alberto')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_edward7_alexandra', 'pub_u_edward7_alexandra', 'casamento', 1863, 1863, 'exata', '10 de março de 1863', 'hist_gb_windsor', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_edward7_alexandra')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_george5_mary', 'pub_u_george5_mary', 'casamento', 1893, 1893, 'exata', '6 de julho de 1893', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_george5_mary')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_george6_elizabeth', 'pub_u_george6_elizabeth', 'casamento', 1923, 1923, 'exata', '26 de abril de 1923', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_george6_elizabeth')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_elizabeth2_philip', 'pub_u_elizabeth2_philip', 'casamento', 1947, 1947, 'exata', '20 de novembro de 1947', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_elizabeth2_philip')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_charles3_diana', 'pub_u_charles3_diana', 'casamento', 1981, 1981, 'exata', '29 de julho de 1981', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_charles3_diana')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id, rotulo_historico_livre, nota)
SELECT 'ev_casamento_pub_u_william_catherine', 'pub_u_william_catherine', 'casamento', 2011, 2011, 'exata', '29 de abril de 2011', 'loc-gb-londres', 'Cerimônia de Casamento', 'Casamento canônico registrado no acervo.'
WHERE EXISTS (SELECT 1 FROM unioes WHERE id = 'pub_u_william_catherine')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_qualificador = excluded.data_qualificador,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id,
  rotulo_historico_livre = excluded.rotulo_historico_livre,
  nota = excluded.nota;
