-- grandes_monarquias_mundiais.sql
-- Semente Canônica Dedicada do Lote 11: Grandes Monarquias, Impérios & Casas Reais.
-- Contempla 7 grandes dinastias mundiais:
-- 1. Família Imperial do Brasil (Bragança)
-- 2. Casa Real de Portugal (Bragança)
-- 3. Casa Real Britânica (Windsor / Saxe-Coburgo-Gota)
-- 4. Casa de Habsburgo (Áustria e Sacro Império)
-- 5. Casa de Bourbon (França e Espanha)
-- 6. Casa Imperial do Japão (Dinastia Yamato)
-- 7. Monarquias Tradicionais Europeias (Mônaco, Dinamarca, Suécia, Noruega, Países Baixos, Bélgica, Liechtenstein, Luxemburgo)

-- =====================================================================
-- 1. ATOS DE ESTADO, TRATADOS, CONSTITUIÇÕES E OBRAS (obras_culturais)
-- =====================================================================
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id) VALUES
-- Casa Real Britânica (Windsor / Saxe-Coburgo-Gota)
('obra_045_uk_vitoria_india', 'pub_vitoria_uk', 'livro', 'Proclamação Real de 1858 (Governo da Índia)', 'Proclamação Real e Carta de Estado', 1858, NULL, 'Proclamação imperial histórica assumindo o governo direto da Índia britânica pela Coroa e prometendo liberdade religiosa e equidade aos povos indianos.', 'loc-gb-london'),
('obra_045_uk_vitoria_diarios', 'pub_vitoria_uk', 'livro', 'Diários e Cartas de Estado da Rainha Vitória', 'Epistolografia e Memórias', 1868, 1897, 'Extenso acervo de correspondências e diários pessoais (Leaves from the Journal of Our Life in the Highlands) documentando seis décadas da Era Vitoriana.', 'loc-gb-balmoral'),
('obra_045_uk_alberto_expo', 'pub_alberto_uk', 'livro', 'A Grande Exposição Universal de 1851 (The Great Exhibition)', 'Tratado de Inovação e Exposição Mundial', 1851, NULL, 'Idealização e organização da primeira grande exposição mundial de produtos industriais e artísticos no Palácio de Cristal em Londres, marcando o ápice da Revolução Industrial.', 'loc-gb-london'),
('obra_045_uk_george6_speech', 'pub_george6_uk', 'livro', 'Discurso Radiofônico de Declaração de Guerra (The King''s Speech)', 'Oratória de Estado e Mobilização Cívica', 1939, NULL, 'Histórico discurso de rádio à nação e ao Império Britânico por George VI ao iniciar a Segunda Guerra Mundial, conclamando o povo à serenidade e resistência contra a tirania.', 'loc-gb-london'),
('obra_045_uk_elizabeth2_natal', 'pub_elizabeth2_uk', 'livro', 'Primeira Mensagem Televisada de Natal (1957)', 'Comunicação Oficial e Radiodifusão', 1957, NULL, 'Transmissão televisiva pioneira da Rainha Elizabeth II direto de Sandringham, transformando a relação entre a Coroa britânica e os cidadãos da Commonwealth.', 'loc-gb-london'),
('obra_045_uk_elizabeth2_canada', 'pub_elizabeth2_uk', 'livro', 'Proclamação da Lei Constitucional do Canadá (Constitution Act 1982)', 'Tratado Constitucional', 1982, NULL, 'Ato solene assinado em Ottawa que garantiu a repatriação da Constituição canadense e a Carta de Direitos e Liberdades.', 'loc-gb-london'),
('obra_045_uk_charles3_harmony', 'pub_charles3_uk', 'livro', 'Harmony: A New Way of Looking at Our World', 'Tratado Ecológico e Arquitetônico', 2010, NULL, 'Manifesto seminal do Príncipe de Gales (Rei Charles III) sobre sustentabilidade, agricultura orgânica, arquitetura humanista e equilíbrio planetário.', 'loc-gb-london'),
('obra_045_uk_charles3_highgrove', 'pub_charles3_uk', 'livro', 'The Garden at Highgrove', 'Tratado de Botânica e Paisagismo', 1993, NULL, 'Obra ricamente documentada sobre a transformação ecológica e os jardins orgânicos modelo criados na propriedade de Highgrove.', 'loc-gb-london'),

-- Casa de Habsburgo
('obra_045_habs_carlos5_worms', 'pub_habsburgo_carlos_v', 'livro', 'Édito Imperial de Worms (1521)', 'Édito Imperial e Lei de Estado', 1521, NULL, 'Édito imperial de Carlos V sobre o Santo Império Romano-Germânico frente à Dieta de Worms e aos primórdios da Reforma.', 'loc-at-wien'),
('obra_045_habs_carlos5_augsburg', 'pub_habsburgo_carlos_v', 'livro', 'Paz de Augsburgo (Cuius regio, eius religio)', 'Tratado de Paz e Diplomacia', 1555, NULL, 'Acordo de paz histórica estabelecendo a coexistência pacífica do Luteranismo e Catolicismo no Sacro Império Romano-Germânico.', 'loc-at-wien'),
('obra_045_habs_felipe2_escorial', 'pub_habsburgo_filipe_ii', 'livro', 'Construção do Mosteiro Real de San Lorenzo de El Escorial', 'Patrimônio Arquitetônico Monumental', 1563, 1584, 'Fundação monumental concebida por Filipe II por Juan Bautista de Toledo e Juan de Herrera, abrigando palácio, basílica, biblioteca e o Panteão dos Reis da Espanha.', 'loc-es-escorial'),
('obra_045_habs_felipe2_tomar', 'pub_habsburgo_filipe_ii', 'livro', 'Cortes de Tomar e Ordenações Filipinas (União Ibérica)', 'Tratado Jurídico e Constitucional', 1581, 1603, 'Acordo das Cortes de Tomar jurando os foros e privilégios portugueses e a monumental compilação do Código Filipino que regeu Portugal e o Brasil colônia.', 'loc-es-madrid'),
('obra_045_habs_mteresa_escola', 'pub_habsburgo_maria_teresa', 'livro', 'Reforma Educacional Geral Teresiana (Allgemeine Schulordnung)', 'Decreto de Reforma Educacional', 1774, NULL, 'Legislação pioneira estabelecendo o sistema de ensino público primário compulsório universal nos domínios dos Habsburgos.', 'loc-at-wien'),
('obra_045_habs_fjose_ring', 'pub_habsburgo_francisco_jose_i', 'livro', 'Decreto de Criação da Ringstraße de Viena', 'Urbanismo e Modernização Imperial', 1857, 1865, 'Decreto de demolição das antigas muralhas de Viena e criação do suntuoso bulevar circular Ringstraße, abrigando a Ópera, Museus e Parlamento.', 'loc-at-wien'),
('obra_045_habs_fjose_ausgleich', 'pub_habsburgo_francisco_jose_i', 'livro', 'Compromisso Austro-Húngaro (Ausgleich de 1867)', 'Constituição da Monarquia Dual', 1867, NULL, 'Tratado constitucional que fundou o Império Austro-Húngaro, concedendo ampla autonomia parlamentar ao Reino da Hungria sob a coroa dos Habsburgos.', 'loc-at-wien'),
('obra_045_habs_otto_paneuropa', 'pub_habsburgo_otto_von_habsburgo', 'livro', 'Paneuropa-Union e Ordem Social do Amanhã', 'Tratado Político e Integração Europeia', 1957, 1973, 'Tratados e ensaios de Otto von Habsburgo, presidente da União Paneuropeia e eurodeputado, defendendo a unificação democrática e os direitos humanos na Europa pós-guerra.', 'loc-at-wien'),

-- Casa de Bourbon
('obra_045_bourb_henrique4_nantes', 'pub_bourbon_henrique_iv_da_franca', 'livro', 'Édito de Nantes (Paz Religiosa e Tolerância Cívica)', 'Édito Real de Pacificação', 1598, NULL, 'Édito promulgado pelo rei Henrique IV pondo fim a décadas de sangrentas Guerras Religiosas na França e garantindo liberdade de consciência aos huguenotes.', 'loc-fr-paris'),
('obra_045_bourb_luis14_versailles', 'pub_bourbon_luis_xiv', 'livro', 'Construção Monumental do Palácio e Jardins de Versalhes', 'Patrimônio Arquitetônico e Sede de Estado', 1661, 1682, 'Criação do palácio barroco mais influente do Ocidente por Louis Le Vau, André Le Nôtre e Jules Hardouin-Mansart, símbolo do Rei Sol e sede da monarquia francesa.', 'loc-fr-versailles'),
('obra_045_bourb_luis14_codenoir', 'pub_bourbon_luis_xiv', 'livro', 'Código Negro e Édito de Fontainebleau', 'Legislação e Éditos Reais', 1685, NULL, 'Compilação de ordens reais do absolutismo francês promulgadas sob o reinado de Luís XIV regulando o império ultramarino e a administração central.', 'loc-fr-versailles'),
('obra_045_bourb_luis16_estados', 'pub_bourbon_luis_xvi', 'livro', 'Convocação e Abertura dos Estados Gerais de 1789', 'Decreto Régio de Crise', 1789, NULL, 'Convocação solene da assembleia consultiva das três ordens do reino francês em Versalhes, deflagrando o processo histórico da Revolução Francesa.', 'loc-fr-versailles'),
('obra_045_bourb_felipe5_planta', 'pub_bourbon_filipe_v_da_espanha', 'livro', 'Decretos de Nueva Planta (Fundação da Monarquia Hispânica Moderna)', 'Decretos Reais Constitucionais', 1707, 1716, 'Série de decretos de Filipe V abolindo os foros autônomos de Aragão, Catalunha e Valência e estabelecendo uma administração central unificada na Espanha.', 'loc-es-madrid'),
('obra_045_bourb_juancarlos_23f', 'pub_bourbon_juan_carlos_i', 'livro', 'Mensagem Histórica à Nação contra o Golpe de Estado de 23-F', 'Oratória e Defesa Constitucional', 1981, NULL, 'Pronunciamento televisado decisivo do Rei Juan Carlos I em uniforme militar na madrugada de 24 de fevereiro de 1981, abortando o golpe militar e consolidando a democracia.', 'loc-es-madrid'),
('obra_045_bourb_felipe6_const', 'pub_bourbon_felipe_vi', 'livro', 'Mensagem à Nação em Defesa da Ordem Constitucional', 'Discurso de Estado', 2017, NULL, 'Mensagem extraordinária do Rei Felipe VI afirmando a vigência inegociável da Constituição espanhola de 1978 e a unidade democrática do Estado de direito.', 'loc-es-madrid'),

-- Casa Imperial do Japão (Dinastia Yamato)
('obra_045_jap_meiji_const', 'pub_casa_imperial_japao_imperador_meiji', 'livro', 'Constituição do Império do Japão (Constituição Meiji de 1889)', 'Carta Constitucional', 1889, NULL, 'A primeira constituição moderna da Ásia, outorgada pelo Imperador Meiji combinando a soberania imperial tradicional com monarquia constitucional e o parlamento (Dieta Imperial).', 'loc-jp-tokyo'),
('obra_045_jap_meiji_educ', 'pub_casa_imperial_japao_imperador_meiji', 'livro', 'Rescrito Imperial sobre a Educação (Kyōiku Chokugo)', 'Rescrito Imperial e Filosofia Cívica', 1890, NULL, 'Documento seminal assinado pelo Imperador Meiji definindo os preceitos morais e o dever cívico do sistema educacional moderno japonês.', 'loc-jp-tokyo'),
('obra_045_jap_showa_gyokuon', 'pub_casa_imperial_japao_imperador_showa', 'livro', 'Gyokuon-hōsō (Transmissão da Voz de Joia / Rescrito de Fim da Guerra)', 'Declaração Imperial Radiofônica', 1945, NULL, 'Histórica transmissão de rádio pela primeira vez da voz do Imperador Hirohito em 15 de agosto de 1945, anunciando a aceitação da Declaração de Potsdam e o fim da Segunda Guerra.', 'loc-jp-tokyo'),
('obra_045_jap_showa_biologia', 'pub_casa_imperial_japao_imperador_showa', 'livro', 'Monografias de Biologia Marinha dos Hidrozoários da Baía de Sagami', 'Monografia Científica de Taxonomia Marinha', 1967, NULL, 'Trabalho de pesquisa pioneiro de história natural e taxonomia marinha realizado pelo Imperador Shōwa no Laboratório Biológico do Palácio Imperial.', 'loc-jp-tokyo'),
('obra_045_jap_akihito_gobiidae', 'pub_casa_imperial_japao_akihito', 'livro', 'Estudos Sistemáticos e Filogenéticos sobre Peixes Gobiidae', 'Publicações Científicas (Nature e Science)', 1994, 2000, 'Investigações taxonômicas e morfológicas seminais sobre a família Gobiidae e a ictiofauna do Pacífico publicadas em periódicos internacionais pelo Imperador Akihito.', 'loc-jp-tokyo'),

-- Monarquias Tradicionais Europeias
('obra_045_out_margrethe_tolkien', 'pub_monarquias_margrethe_ii', 'livro', 'Ilustrações Oficiais de O Senhor dos Anéis (J.R.R. Tolkien)', 'Ilustração Literária e Artes Plásticas', 1977, NULL, 'Célebres ilustrações oficiais criadas pela Rainha Margrethe II da Dinamarca sob o pseudônimo artístico Ingahild Grathmer para a edição dinamarquesa de The Lord of the Rings.', 'loc-dk-copenhagen'),
('obra_045_out_rainier_const', 'pub_monarquias_rainier_iii', 'livro', 'Constituição do Principado de Mônaco de 1962', 'Carta Constitucional', 1962, NULL, 'Nova constituição moderna de Mônaco instituída pelo Príncipe Rainier III consolidando o Estado soberano, os direitos fundamentais e o Conselho Nacional.', 'loc-mc-monaco'),
('obra_045_out_grace_foundation', 'pub_monarquias_grace_kelly', 'livro', 'Fundação Princesa Grace e Promoção Internacional das Artes', 'Filantropia e Fomento Artístico', 1964, NULL, 'Criação da prestigiada fundação beneficente e apoio internacional a jovens talentos de teatro, dança e cinema pela Princesa Grace de Mônaco.', 'loc-mc-monaco'),
('obra_045_out_carlgustaf_const', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'livro', 'Instrumento de Governo de 1974 (Regeringsformen da Suécia)', 'Constituição Democrática', 1974, NULL, 'Promulgação do moderno instrumento constitucional sueco redefinindo a monarquia parlamentar estritamente representativa e os direitos dos cidadãos.', 'loc-se-stockholm'),
('obra_045_out_willem_posse', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'livro', 'Declaração de Posse Constitucional e Abdicação de Beatrix', 'Ato de Estado e Juramento Constitucional', 2013, NULL, 'Solenidade na Nieuwe Kerk de Amsterdã em que o Rei Willem-Alexander prestou juramento como primeiro rei masculino dos Países Baixos em mais de um século.', 'loc-nl-amsterdam'),
('obra_045_out_harald_altfornorge', 'pub_outras_monarquias_harald_v_da_noruega', 'livro', 'Proclamação Real Alt for Norge e Discurso pela Unidade e Diversidade', 'Oratória Humanista e Cívica', 2016, NULL, 'Célebre discurso real de Harald V no palácio de Oslo sobre acolhimento, tolerância, diversidade e o compromisso permanente com o lema histórico Alt for Norge.', 'loc-no-oslo')
ON CONFLICT(id) DO UPDATE SET
  titulo = excluded.titulo,
  detalhes = excluded.detalhes,
  ano = excluded.ano,
  ano_fim = excluded.ano_fim,
  subtipo = excluded.subtipo,
  local_id = excluded.local_id;

-- =====================================================================
-- 2. MULTILINGUISMO DINÁSTICO INTEGRAL (idiomas_pessoa) - 130 MEMBROS
-- =====================================================================
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
-- Casa de Bourbon (Consortes e membros sem registro prévio)
('idi_045_bourb_mercedes_es', 'pub_bourbon_maria_das_mercedes', 'Espanhol'),
('idi_045_bourb_medici_it', 'pub_bourbon_maria_de_medici', 'Italiano'),
('idi_045_bourb_medici_fr', 'pub_bourbon_maria_de_medici', 'Francês'),
('idi_045_bourb_saboia_it', 'pub_bourbon_maria_luisa_de_saboia', 'Italiano'),
('idi_045_bourb_saboia_es', 'pub_bourbon_maria_luisa_de_saboia', 'Espanhol'),
('idi_045_bourb_teresa_es', 'pub_bourbon_maria_teresa_da_espanha', 'Espanhol'),
('idi_045_bourb_teresa_fr', 'pub_bourbon_maria_teresa_da_espanha', 'Francês'),
('idi_045_bourb_sofia_gr', 'pub_bourbon_rainha_sofia', 'Grego'),
('idi_045_bourb_sofia_es', 'pub_bourbon_rainha_sofia', 'Espanhol'),
('idi_045_bourb_sofia_en', 'pub_bourbon_rainha_sofia', 'Inglês'),
('idi_045_bourb_vitoria_en', 'pub_bourbon_vitoria_eugenia', 'Inglês'),
('idi_045_bourb_vitoria_es', 'pub_bourbon_vitoria_eugenia', 'Espanhol'),

-- Casa de Habsburgo (Consortes e imperadores)
('idi_045_habs_carlos2_es', 'pub_habsburgo_carlos_ii_da_espanha', 'Espanhol'),
('idi_045_habs_carlos1_fr', 'pub_habsburgo_carlos_i_da_austria', 'Francês'),
('idi_045_habs_carlos1_hu', 'pub_habsburgo_carlos_i_da_austria', 'Húngaro'),
('idi_045_habs_filipe1_fr', 'pub_habsburgo_filipe_o_belo', 'Francês'),
('idi_045_habs_filipe1_es', 'pub_habsburgo_filipe_o_belo', 'Espanhol'),
('idi_045_habs_filipe2_es', 'pub_habsburgo_filipe_ii', 'Espanhol'),
('idi_045_habs_filipe2_pt', 'pub_habsburgo_filipe_ii', 'Português'),
('idi_045_habs_filipe2_la', 'pub_habsburgo_filipe_ii', 'Latim'),
('idi_045_habs_fferd_hu', 'pub_habsburgo_francisco_ferdinando', 'Húngaro'),
('idi_045_habs_fjose_hu', 'pub_habsburgo_francisco_jose_i', 'Húngaro'),
('idi_045_habs_fjose_it', 'pub_habsburgo_francisco_jose_i', 'Italiano'),
('idi_045_habs_joana_es', 'pub_habsburgo_joana_de_castela', 'Espanhol'),
('idi_045_habs_joana_la', 'pub_habsburgo_joana_de_castela', 'Latim'),
('idi_045_habs_karl_en', 'pub_habsburgo_karl_von_habsburgo', 'Inglês'),
('idi_045_habs_manto_fr', 'pub_habsburgo_maria_antonieta', 'Francês'),
('idi_045_habs_mteresa_la', 'pub_habsburgo_maria_teresa', 'Latim'),
('idi_045_habs_mteresa_fr', 'pub_habsburgo_maria_teresa', 'Francês'),
('idi_045_habs_otto_fr', 'pub_habsburgo_otto_von_habsburgo', 'Francês'),
('idi_045_habs_otto_en', 'pub_habsburgo_otto_von_habsburgo', 'Inglês'),
('idi_045_habs_otto_hu', 'pub_habsburgo_otto_von_habsburgo', 'Húngaro'),

-- Casa Imperial do Japão (Consortes e linhagem)
('idi_045_jap_michiko_en', 'pub_casa_imperial_japao_imperatriz_michiko', 'Inglês'),
('idi_045_jap_masako_en', 'pub_casa_imperial_japao_imperatriz_masako', 'Inglês'),
('idi_045_jap_masako_fr', 'pub_casa_imperial_japao_imperatriz_masako', 'Francês'),
('idi_045_jap_masako_ru', 'pub_casa_imperial_japao_imperatriz_masako', 'Russo'),
('idi_045_jap_naruhito_en', 'pub_casa_imperial_japao_naruhito', 'Inglês'),
('idi_045_jap_fumihito_en', 'pub_casa_imperial_japao_fumihito', 'Inglês'),
('idi_045_jap_kiko_en', 'pub_casa_imperial_japao_princesa_kiko', 'Inglês'),
('idi_045_jap_kiko_de', 'pub_casa_imperial_japao_princesa_kiko', 'Alemão'),
('idi_045_jap_yamato_jp', 'pub_casa_imperial_japao_linhagem_yamato', 'Japonês Arcaico'),
('idi_045_jap_jimmu_fem_jp', 'pub_ph_japao_jimmu', 'Japonês Arcaico'),
('idi_045_jap_yamato_fem_jp', 'pub_ph_japao_yamato', 'Japonês Arcaico'),

-- Monarquias Tradicionais Europeias (Membros dinamarqueses, suecos, noruegueses, belgas, holandeses, monegascos)
('idi_045_out_albert2_fr', 'pub_monarquias_albert_ii_belgica', 'Francês'),
('idi_045_out_albert2_nl', 'pub_monarquias_albert_ii_belgica', 'Neerlandês'),
('idi_045_out_albert2_de', 'pub_monarquias_albert_ii_belgica', 'Alemão'),
('idi_045_out_alexandrine_de', 'pub_monarquias_alexandrine', 'Alemão'),
('idi_045_out_alexandrine_da', 'pub_monarquias_alexandrine', 'Dinamarquês'),
('idi_045_out_astrid_sv', 'pub_monarquias_astrid_da_suecia', 'Sueco'),
('idi_045_out_astrid_fr', 'pub_monarquias_astrid_da_suecia', 'Francês'),
('idi_045_out_beatrix_nl', 'pub_monarquias_beatrix_holanda', 'Neerlandês'),
('idi_045_out_beatrix_en', 'pub_monarquias_beatrix_holanda', 'Inglês'),
('idi_045_out_beatrix_fr', 'pub_monarquias_beatrix_holanda', 'Francês'),
('idi_045_out_beatrix_de', 'pub_monarquias_beatrix_holanda', 'Alemão'),
('idi_045_out_bernhard_de', 'pub_monarquias_bernhard', 'Alemão'),
('idi_045_out_bernhard_nl', 'pub_monarquias_bernhard', 'Neerlandês'),
('idi_045_out_carol_sv', 'pub_monarquias_carol_da_suecia', 'Sueco'),
('idi_045_out_claus_de', 'pub_monarquias_claus', 'Alemão'),
('idi_045_out_claus_nl', 'pub_monarquias_claus', 'Neerlandês'),
('idi_045_out_cristiano9_da', 'pub_monarquias_cristiano_ix', 'Dinamarquês'),
('idi_045_out_cristiano9_de', 'pub_monarquias_cristiano_ix', 'Alemão'),
('idi_045_out_cristiano10_da', 'pub_monarquias_cristiano_x', 'Dinamarquês'),
('idi_045_out_cristiano10_is', 'pub_monarquias_cristiano_x', 'Islandês'),
('idi_045_out_franzjosef_de', 'pub_monarquias_franz_josef_ii', 'Alemão'),
('idi_045_out_frederico9_da', 'pub_monarquias_frederico_ix', 'Dinamarquês'),
('idi_045_out_frederico8_da', 'pub_monarquias_frederico_viii', 'Dinamarquês'),
('idi_045_out_gina_de', 'pub_monarquias_gina', 'Alemão'),
('idi_045_out_grace_en', 'pub_monarquias_grace_kelly', 'Inglês'),
('idi_045_out_grace_fr', 'pub_monarquias_grace_kelly', 'Francês'),
('idi_045_out_gustavo_sv', 'pub_monarquias_gustavo_adolfo_duque', 'Sueco'),
('idi_045_out_haakon_no', 'pub_monarquias_haakon_vii', 'Norueguês'),
('idi_045_out_haakon_da', 'pub_monarquias_haakon_vii', 'Dinamarquês'),
('idi_045_out_henrik_fr', 'pub_monarquias_henrik', 'Francês'),
('idi_045_out_henrik_da', 'pub_monarquias_henrik', 'Dinamarquês'),
('idi_045_out_ingeborg_da', 'pub_monarquias_ingeborg', 'Dinamarquês'),
('idi_045_out_ingeborg_sv', 'pub_monarquias_ingeborg', 'Sueco'),
('idi_045_out_ingrid_sv', 'pub_monarquias_ingrid_da_suecia', 'Sueco'),
('idi_045_out_ingrid_da', 'pub_monarquias_ingrid_da_suecia', 'Dinamarquês'),
('idi_045_out_jean_fr', 'pub_monarquias_jean_luxemburgo', 'Francês'),
('idi_045_out_jean_de', 'pub_monarquias_jean_luxemburgo', 'Alemão'),
('idi_045_out_jean_lb', 'pub_monarquias_jean_luxemburgo', 'Luxemburguês'),
('idi_045_out_josephine_fr', 'pub_monarquias_josephine_charlotte', 'Francês'),
('idi_045_out_josephine_nl', 'pub_monarquias_josephine_charlotte', 'Neerlandês'),
('idi_045_out_juliana_nl', 'pub_monarquias_juliana_holanda', 'Neerlandês'),
('idi_045_out_juliana_en', 'pub_monarquias_juliana_holanda', 'Inglês'),
('idi_045_out_leopoldo3_fr', 'pub_monarquias_leopoldo_iii', 'Francês'),
('idi_045_out_leopoldo3_nl', 'pub_monarquias_leopoldo_iii', 'Neerlandês'),
('idi_045_out_luisa_sv', 'pub_monarquias_luisa_da_suecia', 'Sueco'),
('idi_045_out_luisa_da', 'pub_monarquias_luisa_da_suecia', 'Dinamarquês'),
('idi_045_out_luisa_hesse_de', 'pub_monarquias_luisa_de_hesse', 'Alemão'),
('idi_045_out_luisa_hesse_da', 'pub_monarquias_luisa_de_hesse', 'Dinamarquês'),
('idi_045_out_margrethe_da', 'pub_monarquias_margrethe_ii', 'Dinamarquês'),
('idi_045_out_margrethe_en', 'pub_monarquias_margrethe_ii', 'Inglês'),
('idi_045_out_margrethe_fr', 'pub_monarquias_margrethe_ii', 'Francês'),
('idi_045_out_margrethe_sv', 'pub_monarquias_margrethe_ii', 'Sueco'),
('idi_045_out_martha_sv', 'pub_monarquias_martha_da_suecia', 'Sueco'),
('idi_045_out_martha_no', 'pub_monarquias_martha_da_suecia', 'Norueguês'),
('idi_045_out_maud_en', 'pub_monarquias_maud_do_reino_unido', 'Inglês'),
('idi_045_out_maud_no', 'pub_monarquias_maud_do_reino_unido', 'Norueguês'),
('idi_045_out_olav_no', 'pub_monarquias_olav_v', 'Norueguês'),
('idi_045_out_olav_en', 'pub_monarquias_olav_v', 'Inglês'),
('idi_045_out_paola_it', 'pub_monarquias_paola', 'Italiano'),
('idi_045_out_paola_fr', 'pub_monarquias_paola', 'Francês'),
('idi_045_out_paola_nl', 'pub_monarquias_paola', 'Neerlandês'),
('idi_045_out_rainier_fr', 'pub_monarquias_rainier_iii', 'Francês'),
('idi_045_out_rainier_en', 'pub_monarquias_rainier_iii', 'Inglês'),
('idi_045_out_sibila_de', 'pub_monarquias_sibila_de_saxe', 'Alemão'),
('idi_045_out_sibila_sv', 'pub_monarquias_sibila_de_saxe', 'Sueco'),
('idi_045_out_alberto2_mc_fr', 'pub_outras_monarquias_alberto_ii_de_monaco', 'Francês'),
('idi_045_out_alberto2_mc_en', 'pub_outras_monarquias_alberto_ii_de_monaco', 'Inglês'),
('idi_045_out_carlgustaf_en', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'Inglês'),
('idi_045_out_carlgustaf_de', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'Alemão'),
('idi_045_out_frederik10_en', 'pub_outras_monarquias_frederik_x_da_dinamarca', 'Inglês'),
('idi_045_out_frederik10_fr', 'pub_outras_monarquias_frederik_x_da_dinamarca', 'Francês'),
('idi_045_out_hansadam_de', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'Alemão'),
('idi_045_out_hansadam_en', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'Inglês'),
('idi_045_out_harald5_no', 'pub_outras_monarquias_harald_v_da_noruega', 'Norueguês'),
('idi_045_out_harald5_en', 'pub_outras_monarquias_harald_v_da_noruega', 'Inglês'),
('idi_045_out_henri_lu_fr', 'pub_outras_monarquias_henri_de_luxemburgo', 'Francês'),
('idi_045_out_henri_lu_lb', 'pub_outras_monarquias_henri_de_luxemburgo', 'Luxemburguês'),
('idi_045_out_philippe_be_fr', 'pub_outras_monarquias_philippe_da_belgica', 'Francês'),
('idi_045_out_philippe_be_nl', 'pub_outras_monarquias_philippe_da_belgica', 'Neerlandês'),
('idi_045_out_philippe_be_de', 'pub_outras_monarquias_philippe_da_belgica', 'Alemão'),
('idi_045_out_willem_nl', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'Neerlandês'),
('idi_045_out_willem_en', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'Inglês'),
('idi_045_out_willem_es', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'Espanhol');
