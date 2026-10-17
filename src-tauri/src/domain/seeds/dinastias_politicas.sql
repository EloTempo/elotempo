-- =====================================================================
-- EloTempo - Semente Canônica: Lote 5 (Grandes Dinastias Políticas do Século XX)
-- Clãs: Família Kennedy, Dinastia Roosevelt, Dinastia Bush, Família Perón
-- =====================================================================

-- 1. NOVAS PESSOAS CANÔNICAS (Consortes Históricas e Mães Biológicas)
INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, data_criacao, is_publico, categoria, tipo_tempo) VALUES
-- Roosevelt
('pub_roosevelt_alice_lee', 'Alice Hathaway', 'Lee Roosevelt', 'F', 'Primeira esposa de Theodore Roosevelt e mãe de Alice Roosevelt Longworth. Sua trágica morte aos 22 anos, apenas dois dias após dar à luz, marcou profundamente a vida de Teddy Roosevelt.', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_roosevelt_anna_hall', 'Anna Rebecca', 'Hall Roosevelt', 'F', 'Socialite nova-iorquina de grande beleza, mãe da Primeira-Dama Eleanor Roosevelt. Faleceu precocemente de difteria em 1892.', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_roosevelt_jannetje', 'Jannetje', 'Samuels Thomas', 'F', 'Matriarca ancestral da família Roosevelt na América, esposa do imigrante neerlandês Claes Martenszen van Rosenvelt em Nova Amsterdã (atual Nova York).', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_roosevelt_anna_maria', 'Anna Maria', 'van Schaack', 'F', 'Matriarca colonial de Nova Amsterdã / Nova York, esposa do vereador Nicholas Roosevelt, unindo os primeiros ramos de Oyster Bay e Hyde Park.', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),

-- Bush
('pub_bush_columba', 'Columba', 'Garnica Gallo Bush', 'F', 'Filantropa mexicano-americana, defensora da educação e das artes, esposa do 43º Governador da Flórida Jeb Bush e mãe de George P. Bush.', 1, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),

-- Kennedy
('pub_kennedy_mary_hickey', 'Mary Augusta', 'Hickey Kennedy', 'F', 'Matriarca da segunda geração do clã Kennedy em Boston, filha de empresário e esposa do senador estadual P. J. Kennedy, mãe do embaixador Joseph P. Kennedy Sr.', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_kennedy_josie_hannon', 'Mary Josephine', 'Hannon Fitzgerald', 'F', 'Primeira-Dama de Boston e matriarca da família Fitzgerald, esposa do lendário prefeito John F. Honey Fitz Fitzgerald e mãe de Rose Fitzgerald Kennedy.', 0, 0, CURRENT_TIMESTAMP, 1, 'Chefes de Estado e Lideranças Políticas', 'real')
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  sobrenome = excluded.sobrenome,
  sexo = excluded.sexo,
  minibiografia = excluded.minibiografia,
  is_vivo = excluded.is_vivo,
  is_placeholder = excluded.is_placeholder,
  is_publico = excluded.is_publico,
  categoria = excluded.categoria,
  tipo_tempo = excluded.tipo_tempo;

-- 2. VINCULAR ÀS ÁRVORES (arvore_membros)
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_roosevelt', 'pub_roosevelt_alice_lee', NULL),
('pub_arv_roosevelt', 'pub_roosevelt_anna_hall', NULL),
('pub_arv_roosevelt', 'pub_roosevelt_jannetje', NULL),
('pub_arv_roosevelt', 'pub_roosevelt_anna_maria', NULL),
('pub_arv_bush', 'pub_bush_columba', NULL),
('pub_arv_kennedy', 'pub_kennedy_mary_hickey', NULL),
('pub_arv_kennedy', 'pub_kennedy_josie_hannon', NULL);

-- 3. CORREÇÃO E CRIAÇÃO DE UNIÕES (unioes)
-- Corrigir uniões auto-referenciadas em Roosevelt
INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_roosevelt_claes_nicholas', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 'pub_roosevelt_jannetje', 'casamento', 'União fundadora dos Roosevelt em Nova Amsterdã'),
('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_nicholas_roosevelt', 'pub_roosevelt_anna_maria', 'casamento', 'União colonial em Nova York'),
('pub_u_roosevelt_elliott_eleanor', 'pub_roosevelt_elliott_roosevelt', 'pub_roosevelt_anna_hall', 'casamento', 'Pais de Anna Eleanor Roosevelt'),
('pub_u_roosevelt_teddy_alice_lee', 'pub_roosevelt_theodore_roosevelt', 'pub_roosevelt_alice_lee', 'casamento', 'Primeiro casamento de Theodore Roosevelt, mãe de Alice Longworth'),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_theodore_roosevelt', 'pub_roosevelt_edith_kermit_carow_roosevelt', 'casamento', 'Segundo casamento de Theodore Roosevelt na Casa Branca'),
('pub_u_bush_jeb_columba', 'pub_bush_jeb_bush', 'pub_bush_columba', 'casamento', 'Casamento do Governador Jeb Bush e Columba Garnica Gallo'),
('pub_u_kennedy_pj_mary', 'pub_kennedy_patrick_joseph_kennedy', 'pub_kennedy_mary_hickey', 'casamento', 'Casamento dos pais do Embaixador Joseph P. Kennedy Sr.'),
('pub_u_kennedy_honey_josie', 'pub_kennedy_john_francis_fitzgerald', 'pub_kennedy_josie_hannon', 'casamento', 'Casamento dos pais de Rose Fitzgerald Kennedy')
ON CONFLICT(id) DO UPDATE SET
  slot_masculino_id = excluded.slot_masculino_id,
  slot_feminino_id = excluded.slot_feminino_id,
  estado_vinculo = excluded.estado_vinculo,
  nota = excluded.nota;

-- 4. FILIAÇÕES (uniao_filhos)
-- Atualizar Alice Roosevelt Longworth para filha de Teddy + Alice Lee
DELETE FROM uniao_filhos WHERE pessoa_id = 'pub_roosevelt_alice_roosevelt_longworth';
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_teddy_alice_lee', 'pub_roosevelt_alice_roosevelt_longworth', 'biologico', 1);

-- Teddy + Edith: Theodore Jr., Kermit, Quentin
DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_roosevelt_teddy_edith' AND pessoa_id = 'pub_roosevelt_alice_roosevelt_longworth';
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_theodore_roosevelt_jr', 'biologico', 1),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_kermit_roosevelt', 'biologico', 2),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_quentin_roosevelt', 'biologico', 3);

-- Jeb + Columba -> George P. Bush
DELETE FROM uniao_filhos WHERE pessoa_id = 'pub_bush_george_p_bush';
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_bush_jeb_columba', 'pub_bush_george_p_bush', 'biologico', 1);

-- P.J. + Mary Hickey -> Joseph P. Kennedy Sr.
DELETE FROM uniao_filhos WHERE pessoa_id = 'pub_kennedy_joseph_p_kennedy_sr';
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_kennedy_pj_mary', 'pub_kennedy_joseph_p_kennedy_sr', 'biologico', 1);

-- Honey Fitz + Josie -> Rose Fitzgerald Kennedy
DELETE FROM uniao_filhos WHERE pessoa_id = 'pub_kennedy_rose_fitzgerald_kennedy';
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_kennedy_honey_josie', 'pub_kennedy_rose_fitzgerald_kennedy', 'biologico', 1);

-- Claes + Jannetje -> Nicholas
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_claes_nicholas', 'pub_roosevelt_nicholas_roosevelt', 'biologico', 1);

-- Nicholas + Anna Maria -> James Sr., Theodore Sr.
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_james_roosevelt', 'biologico', 1),
('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_theodore_roosevelt_sr', 'biologico', 2);

-- Elliott + Anna Hall -> Eleanor Roosevelt
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_elliott_eleanor', 'pub_roosevelt_eleanor_roosevelt', 'biologico', 1);

-- 5. IDIOMAS FALADOS (idiomas_pessoa)
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
-- Kennedy
('pub_id_jfk_en', 'pub_kennedy_john_f_kennedy', 'Inglês'),
('pub_id_jfk_fr', 'pub_kennedy_john_f_kennedy', 'Francês'),
('pub_id_jackie_en', 'pub_kennedy_jacqueline_kennedy_onassis', 'Inglês'),
('pub_id_jackie_fr', 'pub_kennedy_jacqueline_kennedy_onassis', 'Francês'),
('pub_id_jackie_es', 'pub_kennedy_jacqueline_kennedy_onassis', 'Espanhol'),
('pub_id_jackie_it', 'pub_kennedy_jacqueline_kennedy_onassis', 'Italiano'),
('pub_id_rfk_en', 'pub_kennedy_robert_f_kennedy', 'Inglês'),
('pub_id_ted_en', 'pub_kennedy_edward_m_kennedy', 'Inglês'),
('pub_id_ted_es', 'pub_kennedy_edward_m_kennedy', 'Espanhol'),
('pub_id_caroline_en', 'pub_kennedy_caroline_kennedy', 'Inglês'),
('pub_id_caroline_fr', 'pub_kennedy_caroline_kennedy', 'Francês'),
('pub_id_caroline_ja', 'pub_kennedy_caroline_kennedy', 'Japonês'),
('pub_id_eunice_en', 'pub_kennedy_eunice_kennedy_shriver', 'Inglês'),
('pub_id_sargent_en', 'pub_kennedy_sargent_shriver', 'Inglês'),
('pub_id_sargent_fr', 'pub_kennedy_sargent_shriver', 'Francês'),
('pub_id_sargent_de', 'pub_kennedy_sargent_shriver', 'Alemão'),
('pub_id_joe_sr_en', 'pub_kennedy_joseph_p_kennedy_sr', 'Inglês'),
('pub_id_rose_en', 'pub_kennedy_rose_fitzgerald_kennedy', 'Inglês'),
('pub_id_rose_fr', 'pub_kennedy_rose_fitzgerald_kennedy', 'Francês'),
('pub_id_rose_de', 'pub_kennedy_rose_fitzgerald_kennedy', 'Alemão'),

-- Roosevelt
('pub_id_tr_en', 'pub_roosevelt_theodore_roosevelt', 'Inglês'),
('pub_id_tr_fr', 'pub_roosevelt_theodore_roosevelt', 'Francês'),
('pub_id_tr_de', 'pub_roosevelt_theodore_roosevelt', 'Alemão'),
('pub_id_tr_it', 'pub_roosevelt_theodore_roosevelt', 'Italiano'),
('pub_id_fdr_en', 'pub_roosevelt_franklin_d_roosevelt', 'Inglês'),
('pub_id_fdr_fr', 'pub_roosevelt_franklin_d_roosevelt', 'Francês'),
('pub_id_fdr_de', 'pub_roosevelt_franklin_d_roosevelt', 'Alemão'),
('pub_id_eleanor_en', 'pub_roosevelt_eleanor_roosevelt', 'Inglês'),
('pub_id_eleanor_fr', 'pub_roosevelt_eleanor_roosevelt', 'Francês'),
('pub_id_eleanor_de', 'pub_roosevelt_eleanor_roosevelt', 'Alemão'),
('pub_id_eleanor_it', 'pub_roosevelt_eleanor_roosevelt', 'Italiano'),
('pub_id_alice_long_en', 'pub_roosevelt_alice_roosevelt_longworth', 'Inglês'),
('pub_id_alice_long_fr', 'pub_roosevelt_alice_roosevelt_longworth', 'Francês'),
('pub_id_tr_jr_en', 'pub_roosevelt_theodore_roosevelt_jr', 'Inglês'),
('pub_id_tr_jr_fr', 'pub_roosevelt_theodore_roosevelt_jr', 'Francês'),
('pub_id_kermit_en', 'pub_roosevelt_kermit_roosevelt', 'Inglês'),
('pub_id_kermit_pt', 'pub_roosevelt_kermit_roosevelt', 'Português'),
('pub_id_kermit_ar', 'pub_roosevelt_kermit_roosevelt', 'Árabe'),

-- Bush
('pub_id_ghwb_en', 'pub_bush_george_h_w_bush', 'Inglês'),
('pub_id_ghwb_es', 'pub_bush_george_h_w_bush', 'Espanhol'),
('pub_id_gwb_en', 'pub_bush_george_w_bush', 'Inglês'),
('pub_id_gwb_es', 'pub_bush_george_w_bush', 'Espanhol'),
('pub_id_jeb_en', 'pub_bush_jeb_bush', 'Inglês'),
('pub_id_jeb_es', 'pub_bush_jeb_bush', 'Espanhol'),
('pub_id_columba_es', 'pub_bush_columba', 'Espanhol'),
('pub_id_columba_en', 'pub_bush_columba', 'Inglês'),
('pub_id_barbara_en', 'pub_bush_barbara_bush', 'Inglês'),
('pub_id_laura_en', 'pub_bush_laura_bush', 'Inglês'),
('pub_id_laura_es', 'pub_bush_laura_bush', 'Espanhol'),
('pub_id_george_p_en', 'pub_bush_george_p_bush', 'Inglês'),
('pub_id_george_p_es', 'pub_bush_george_p_bush', 'Espanhol'),

-- Perón
('pub_id_peron_es', 'pub_peron_juan_domingo_peron', 'Espanhol'),
('pub_id_peron_it', 'pub_peron_juan_domingo_peron', 'Italiano'),
('pub_id_peron_fr', 'pub_peron_juan_domingo_peron', 'Francês'),
('pub_id_peron_en', 'pub_peron_juan_domingo_peron', 'Inglês'),
('pub_id_evita_es', 'pub_peron_eva_peron', 'Espanhol'),
('pub_id_isabel_es', 'pub_peron_isabel_peron', 'Espanhol'),
('pub_id_isabel_fr', 'pub_peron_isabel_peron', 'Francês'),
('pub_id_aurelia_es', 'pub_peron_aurelia_tizon', 'Espanhol'),
('pub_id_aurelia_en', 'pub_peron_aurelia_tizon', 'Inglês');

-- 6. OBRAS CULTURAIS, LITERÁRIAS E POLÍTICAS (obras_culturais)
INSERT OR REPLACE INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id) VALUES
-- JFK
('pub_ob_jfk_profiles', 'pub_kennedy_john_f_kennedy', 'livro', 'Profiles in Courage', 'ensaio_biografico', 1956, NULL, 'Vencedor do Prêmio Pulitzer de Biografia em 1957, retrata a coragem e integridade moral de oito senadores norte-americanos históricos.', 'loc-us-washington'),
('pub_ob_jfk_why_england', 'pub_kennedy_john_f_kennedy', 'livro', 'Why England Slept', 'ensaio_politico', 1940, NULL, 'Tese acadêmica de graduação em Harvard sobre o apaziguamento britânico anterior à Segunda Guerra Mundial.', 'loc-us-boston'),
('pub_ob_jfk_inaugural', 'pub_kennedy_john_f_kennedy', 'livro', 'Discurso Inaugural da Presidência dos EUA', 'discurso_historico', 1961, NULL, 'Discurso que imortalizou o chamado universal: "Ask not what your country can do for you — ask what you can do for your country".', 'loc-us-washington'),
('pub_ob_jfk_immigrants', 'pub_kennedy_john_f_kennedy', 'livro', 'A Nation of Immigrants', 'ensaio_social', 1958, NULL, 'Obra sobre a herança, o impacto e a dignidade fundamental dos povos imigrantes na construção dos Estados Unidos.', 'loc-us-washington'),

-- RFK
('pub_ob_rfk_enemy', 'pub_kennedy_robert_f_kennedy', 'livro', 'The Enemy Within', 'ensaio_investigativo', 1960, NULL, 'Relato sobre as investigações do comitê do Senado contra o crime organizado e a corrupção em sindicatos.', 'loc-us-washington'),
('pub_ob_rfk_thirteen_days', 'pub_kennedy_robert_f_kennedy', 'livro', 'Thirteen Days: A Memoir of the Cuban Missile Crisis', 'memorias_politicas', 1969, NULL, 'Memórias essenciais sobre a tomada de decisões no gabinete da Casa Branca durante os treze dias da Crise dos Mísseis de Cuba de 1962.', 'loc-us-washington'),
('pub_ob_rfk_newer_world', 'pub_kennedy_robert_f_kennedy', 'livro', 'To Seek a Newer World', 'ensaio_politico', 1967, NULL, 'Visão abrangente sobre justiça racial, combate à pobreza, desarmamento nuclear e reconciliação internacional.', 'loc-us-washington'),

-- Ted Kennedy
('pub_ob_ted_compass', 'pub_kennedy_edward_m_kennedy', 'livro', 'True Compass: A Memoir', 'autobiografia', 2009, NULL, 'Autobiografia abrangendo cinco décadas de liderança legislativa, saúde pública e a intimidade da família Kennedy.', 'loc-us-washington'),

-- Caroline Kennedy
('pub_ob_caroline_defense', 'pub_kennedy_caroline_kennedy', 'livro', 'In Our Defense: The Bill of Rights in Action', 'ensaio_juridico', 1991, NULL, 'Análise aprofundada da evolução e proteção da Carta de Direitos fundamentais da Constituição dos EUA.', 'loc-us-novayork'),

-- Theodore Roosevelt
('pub_ob_tr_naval_war', 'pub_roosevelt_theodore_roosevelt', 'livro', 'The Naval War of 1812', 'historiografia', 1882, NULL, 'Obra de referência historiográfica pioneira sobre as táticas navais, estratégia e batalhas da Guerra Anglo-Americana de 1812.', 'loc-us-novayork'),
('pub_ob_tr_wilderness', 'pub_roosevelt_theodore_roosevelt', 'livro', 'Through the Brazilian Wilderness (Nas Selvas do Brasil)', 'livro_viagem_exploracao', 1914, NULL, 'Crônica da Expedição Científica Roosevelt-Rondon através do Rio da Dúvida (atual Rio Roosevelt) na Amazônia brasileira.', 'ibge-1302603'),
('pub_ob_tr_winning_west', 'pub_roosevelt_theodore_roosevelt', 'livro', 'The Winning of the West', 'historiografia_epica', 1889, 1896, 'Magnum opus em quatro volumes narrando a expansão pioneira além dos Apalaches até o Mississippi.', 'loc-us-novayork'),
('pub_ob_tr_man_arena', 'pub_roosevelt_theodore_roosevelt', 'livro', 'Citizenship in a Republic (O Homem na Arena)', 'discurso_filosofico', 1910, NULL, 'Célebre conferência na Sorbonne em Paris proclamando o valor de quem luta e sangra na arena em vez dos críticos cínicos.', 'loc-fr-paris'),

-- FDR
('pub_ob_fdr_looking_forward', 'pub_roosevelt_franklin_d_roosevelt', 'livro', 'Looking Forward', 'programa_politico', 1933, NULL, 'Manifesto fundacional do New Deal para o enfrentamento da Grande Depressão econômica.', 'loc-us-washington'),
('pub_ob_fdr_four_freedoms', 'pub_roosevelt_franklin_d_roosevelt', 'livro', 'Discurso das Quatro Liberdades (Four Freedoms Speech)', 'discurso_historico', 1941, NULL, 'Mensagem ao Congresso delineando as quatro liberdades humanas fundamentais: de expressão, de culto, contra a penúria e contra o medo.', 'loc-us-washington'),
('pub_ob_fdr_fireside', 'pub_roosevelt_franklin_d_roosevelt', 'livro', 'Fireside Chats (Conversas ao Pé do Fogo)', 'transmissoes_radiofonicas', 1933, 1944, 'Série histórica de 30 conferências radiofônicas diretas com a população norte-americana explicando reformas e a guerra.', 'loc-us-washington'),

-- Eleanor Roosevelt
('pub_ob_eleanor_dudh', 'pub_roosevelt_eleanor_roosevelt', 'livro', 'Declaração Universal dos Direitos Humanos', 'documento_internacional', 1948, NULL, 'Como presidente da Comissão de Direitos Humanos da ONU, conduziu a redação e aprovação do marco supremo dos direitos do homem.', 'loc-fr-paris'),
('pub_ob_eleanor_this_is_my_story', 'pub_roosevelt_eleanor_roosevelt', 'livro', 'This Is My Story', 'autobiografia', 1937, NULL, 'Primeiro volume de sua aclamada trilogia autobiográfica relatando sua formação moral e primeiros anos na vida pública.', 'loc-us-novayork'),
('pub_ob_eleanor_you_learn', 'pub_roosevelt_eleanor_roosevelt', 'livro', 'You Learn by Living: Eleven Keys for a More Fulfilling Life', 'ensaio_filosofico', 1960, NULL, 'Guia de reflexão ética, coragem cívica, amadurecimento e sabedoria prática.', 'loc-us-novayork'),

-- George H. W. Bush
('pub_ob_ghwb_looking', 'pub_bush_george_h_w_bush', 'livro', 'Looking Forward', 'autobiografia', 1987, NULL, 'Memórias sobre sua trajetória como piloto de caça na Segunda Guerra, empresário do petróleo, diplomata na ONU, embaixador na China e vice-presidente.', 'loc-us-washington'),

-- Barbara Bush
('pub_ob_barbara_memoir', 'pub_bush_barbara_bush', 'livro', 'Barbara Bush: A Memoir', 'memorias', 1994, NULL, 'Relato biográfico franco e espirituoso sobre a vida na Casa Branca e sua dedicação integral à causa da alfabetização familiar.', 'loc-us-washington'),

-- George W. Bush
('pub_ob_gwb_decision', 'pub_bush_george_w_bush', 'livro', 'Decision Points', 'memorias_politicas', 2010, NULL, 'Exame aprofundado das decisões centrais de seus dois mandatos presidenciais, incluindo o 11 de Setembro e a crise financeira de 2008.', 'loc-us-washington'),
('pub_ob_gwb_portraits', 'pub_bush_george_w_bush', 'arte', 'Portraits of Courage: A Commander in Chief Tribute to America Warriors', 'pinturas_a_oleo', 2017, NULL, 'Coletânea de sessenta e seis retratos pintados a óleo pelo ex-presidente homenageando veteranos militares.', 'loc-us-dallas'),

-- Laura Bush
('pub_ob_laura_spoken', 'pub_bush_laura_bush', 'livro', 'Spoken from the Heart', 'autobiografia', 2010, NULL, 'Memórias sobre sua infância no Texas, sua carreira como professora e bibliotecária, e suas missões humanitárias globais de saúde e educação.', 'loc-us-washington'),

-- Juan Domingo Perón
('pub_ob_peron_comunidad', 'pub_peron_juan_domingo_peron', 'livro', 'La Comunidad Organizada', 'ensaio_filosofico', 1949, NULL, 'Conferência proferida no Primeiro Congresso Nacional de Filosofia de Mendoza, base filosófica do Justicialismo e da Terceira Posição.', 'loc-ar-mendoza'),
('pub_ob_peron_conduccion', 'pub_peron_juan_domingo_peron', 'livro', 'Conducción Política', 'teoria_politica', 1952, NULL, 'Compilação das aulas magistrais ministradas na Escola Superior Peronista sobre a arte da liderança política.', 'loc-ar-buenosaires'),
('pub_ob_peron_toponimia', 'pub_peron_juan_domingo_peron', 'livro', 'Toponimia Patagónica de Etimología Araucana', 'linguistica_etnografia', 1935, NULL, 'Estudo pioneiro etnográfico e linguístico sobre a toponímia indígena da Patagônia argentina.', 'loc-ar-buenosaires'),
('pub_ob_peron_modelo', 'pub_peron_juan_domingo_peron', 'livro', 'Modelo Argentino para el Proyecto Nacional', 'ensaio_politico', 1974, NULL, 'Testamento político e doutrinário apresentado ao Congresso Nacional no ano de seu falecimento.', 'loc-ar-buenosaires'),

-- Eva Perón
('pub_ob_evita_razon', 'pub_peron_eva_peron', 'livro', 'La Razón de mi Vida', 'autobiografia_doutrinaria', 1951, NULL, 'Autobiografia e testamento espiritual narrando sua infância, seu amor pelo povo trabalhador (descamisados) e sua consagração à causa social.', 'loc-ar-buenosaires'),
('pub_ob_evita_mensaje', 'pub_peron_eva_peron', 'livro', 'Mi Mensaje', 'testamento_politico', 1952, NULL, 'Último texto político ditado por Eva Perón semanas antes de sua morte precoce.', 'loc-ar-buenosaires'),

-- Aurelia Tizón
('pub_ob_aurelia_traducoes', 'pub_peron_aurelia_tizon', 'livro', 'Traducciones Militares y Diplomáticas del Inglés', 'traducao_academica', 1936, NULL, 'Trabalhos de tradução do inglês para o espanhol de manuais técnicos militares e correspondências para Perón.', 'loc-ar-buenosaires');
