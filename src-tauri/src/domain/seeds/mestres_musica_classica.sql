-- mestres_musica_classica.sql
-- Semente canônica do Lote 9: Mestres da Música Clássica & Artes Cênicas.
-- Contempla 4 árvores de dinastias e gênios musicais:
-- 1. Dinastia Musical Bach (pub_arv_bach - 9 membros)
-- 2. Família de Wolfgang Amadeus Mozart (pub_arv_mozart - 7 membros)
-- 3. Família de Ludwig van Beethoven (pub_arv_beethoven - 7 membros)
-- 4. Chiquinha Gonzaga e Pioneirismo Musical (pub_arv_chiquinha_gonzaga - 8 membros)
-- Cadastro de obras capitais (BWV, Köchel, Opus, partituras) e cobertura integral de idiomas.

-- =====================================================================
-- 1. OBRAS CAPITAIS DA MÚSICA CLÁSSICA E POPULAR (obras_culturais)
-- =====================================================================

-- DINASTIA MUSICAL BACH
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    -- Johann Sebastian Bach
    ('obra_043_bach_paixao_mateus', 'pub_bach_johann_sebastian_bach', 'musica', 'Paixão segundo São Mateus (Matthäus-Passion, BWV 244)', 'Oratório Sacro e Paixão', 1727, NULL, 'Obra monumental da música ocidental para duplo coro e orquestra, estreada na Thomaskirche de Leipzig na Sexta-Feira Santa de 1727.', 'loc-de-leipzig'),
    ('obra_043_bach_missa_si_menor', 'pub_bach_johann_sebastian_bach', 'musica', 'Missa em Si Menor (Missa solemnis, BWV 232)', 'Missa Sacra Monumental', 1749, NULL, 'Síntese suprema da polifonia sacra e do contraponto renascentista e barroco, coroando a trajetória composicional de Bach.', 'loc-de-leipzig'),
    ('obra_043_bach_cravo_1', 'pub_bach_johann_sebastian_bach', 'musica', 'O Cravo Bem Temperado - Livro I (BWV 846–869)', 'Prelúdios e Fugas / Pedagogia do Teclado', 1722, NULL, 'Conjunto de 24 prelúdios e fugas em todas as tonalidades maiores e menores, fixando a afinação temperada moderna.', 'loc-de-kothen'),
    ('obra_043_bach_cravo_2', 'pub_bach_johann_sebastian_bach', 'musica', 'O Cravo Bem Temperado - Livro II (BWV 870–893)', 'Prelúdios e Fugas', 1742, NULL, 'Segundo ciclo canônico explorando o contraponto avançado e formas expressivas livres.', 'loc-de-leipzig'),
    ('obra_043_bach_arte_fuga', 'pub_bach_johann_sebastian_bach', 'musica', 'A Arte da Fuga (Die Kunst der Fuge, BWV 1080)', 'Tratado de Contraponto Instrumental', 1750, NULL, 'Testamento contrapontístico supremo explorando todas as variações e cânones a partir de um único tema fundamental.', 'loc-de-leipzig'),
    ('obra_043_bach_brandemburgo', 'pub_bach_johann_sebastian_bach', 'musica', 'Concertos de Brandemburgo (BWV 1046–1051)', 'Concerti Grossi', 1721, NULL, 'Seis concertos dedicados ao marquês de Brandemburgo, ápice da instrumentação orquestral barroca.', 'loc-de-kothen'),
    ('obra_043_bach_goldberg', 'pub_bach_johann_sebastian_bach', 'musica', 'Variações Goldberg (BWV 988)', 'Tema com Variações para Cravo', 1741, NULL, 'Ária com trinta variações virtuosísticas compostas para o cravista Johann Gottlieb Goldberg.', 'loc-de-leipzig'),
    ('obra_043_bach_oferenda', 'pub_bach_johann_sebastian_bach', 'musica', 'Oferenda Musical (Musikalisches Opfer, BWV 1079)', 'Cânones e Fugas sobre Tema Real', 1747, NULL, 'Composição dedicada ao rei Frederico II da Prússia baseada no tema musical proposto pelo próprio monarca em Potsdam.', 'loc-de-leipzig'),

    -- Carl Philipp Emanuel Bach
    ('obra_043_cpe_versuch', 'pub_bach_carl_philipp_emanuel_bach', 'livro', 'Versuch über die wahre Art das Clavier zu spielen', 'Tratado Teórico e Método de Teclado', 1753, 1762, 'O mais influente compêndio do século XVIII sobre a técnica de teclado, ornamentação e interpretação do estilo sensível (Empfindsamer Stil).', 'loc-de-berlim'),
    ('obra_043_cpe_sinfonias_hamburgo', 'pub_bach_carl_philipp_emanuel_bach', 'musica', 'Seis Sinfonias de Hamburgo (Wq. 182)', 'Sinfonias para Cordas', 1773, NULL, 'Obras audaciosas com súbitas modulações e vigor expressivo que influenciaram decisivamente Haydn, Mozart e Beethoven.', 'loc-de-hamburgo'),
    ('obra_043_cpe_auferstehung', 'pub_bach_carl_philipp_emanuel_bach', 'musica', 'Die Auferstehung und Himmelfahrt Jesu (Wq. 240)', 'Oratório Sacro', 1777, NULL, 'Magistral oratório sobre a Ressurreição e Ascensão de Jesus, aclamado em toda a Europa ilustrada.', 'loc-de-hamburgo'),

    -- Johann Christian Bach
    ('obra_043_jcb_concertos_op7', 'pub_bach_johann_christian_bach', 'musica', 'Seis Concertos para Cravo ou Pianoforte (Op. 7)', 'Concertos para Teclado', 1770, NULL, 'Concertos célebres do "Bach de Londres" que introduziram o pianoforte na Inglaterra e serviram de modelo direto para os primeiros concertos de Mozart.', 'loc-gb-london'),
    ('obra_043_jcb_temistocle', 'pub_bach_johann_christian_bach', 'teatro', 'Ópera Temistocle', 'Dramma per Musica / Ópera Séria', 1772, NULL, 'Grande ópera séria estreada no Teatro da Corte de Mannheim, consolidando a fama internacional do compositor.', 'loc-de-mannheim'),

    -- Wilhelm Friedemann Bach
    ('obra_043_wfb_polonaises', 'pub_bach_wilhelm_friedemann_bach', 'musica', 'Doze Polonaises para Teclado (Falk 12)', 'Polonaises e Suítes para Teclado', 1765, NULL, 'Coleção de peças de extraordinária inventividade harmônica e profundidade emocional, antecipando o romantismo musical.', 'loc-de-dresden'),

    -- Johann Christoph Friedrich Bach
    ('obra_043_jcf_infancia_jesus', 'pub_bach_johann_christoph_friedrich_bach', 'musica', 'Die Kindheit Jesu', 'Oratório Sacro de Bückeburg', 1773, NULL, 'Oratório sacro composto na corte de Schaumburg-Lippe com libreto do filósofo Johann Gottfried Herder.', 'loc-de-buckeburg'),

    -- Johann Ambrosius Bach
    ('obra_043_amb_direcao_musical', 'pub_bach_johann_ambrosius_bach', 'musica', 'Direção Musical dos Músicos da Cidade de Eisenach', 'Música de Corte e Trompete Barroco', 1671, 1695, 'Atuação como Stadtpfeifer e diretor da corporação musical de Eisenach, transmitindo a tradição de cordas e trompete ao jovem Sebastian.', 'loc-de-eisenach')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;


-- FAMÍLIA MOZART
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    -- Wolfgang Amadeus Mozart
    ('obra_043_moz_requiem', 'pub_mozart_wolfgang', 'musica', 'Requiem em Ré menor (K. 626)', 'Missa de Réquiem', 1791, NULL, 'Cume sublime da música sacra clássica, composto no leito de morte de Mozart e completado por seu discípulo Franz Xaver Süssmayr.', 'loc-at-viena'),
    ('obra_043_moz_flauta_magica', 'pub_mozart_wolfgang', 'teatro', 'A Flauta Mágica (Die Zauberflöte, K. 620)', 'Singspiel / Ópera Alemã', 1791, NULL, 'Obra-prima do teatro lírico universal com libreto de Emanuel Schikaneder, mesclando alegorias maçônicas e virtuosismo vocal.', 'loc-at-viena'),
    ('obra_043_moz_don_giovanni', 'pub_mozart_wolfgang', 'teatro', 'Don Giovanni (Il dissoluto punito, K. 527)', 'Dramma Giocoso / Ópera', 1787, NULL, 'Ópera magistral com libreto de Lorenzo Da Ponte, estreada com êxito triunfal no Teatro dos Estados em Praga.', 'loc-at-viena'),
    ('obra_043_moz_bodas_figaro', 'pub_mozart_wolfgang', 'teatro', 'As Bodas de Fígaro (Le nozze di Figaro, K. 492)', 'Commedia per Musica', 1786, NULL, 'Comédia lírica revolucionária baseada na peça de Beaumarchais, satirizando as prerrogativas da aristocracia do Antigo Regime.', 'loc-at-viena'),
    ('obra_043_moz_jupiter', 'pub_mozart_wolfgang', 'musica', 'Sinfonia nº 41 em Dó maior "Júpiter" (K. 551)', 'Sinfonia Clássica com Fuga Quíntupla', 1788, NULL, 'Última sinfonia de Mozart, culminando em um célebre movimento final com contraponto quíntuplo invertível.', 'loc-at-viena'),
    ('obra_043_moz_clarinete', 'pub_mozart_wolfgang', 'musica', 'Concerto para Clarinete em Lá maior (K. 622)', 'Concerto para Instrumento Solo e Orquestra', 1791, NULL, 'Última obra instrumental completada por Mozart, escrita para o clarinetista Anton Stadler.', 'loc-at-viena'),

    -- Leopold Mozart
    ('obra_043_leo_violinschule', 'pub_mozart_leopold', 'livro', 'Versuch einer gründlichen Violinschule', 'Tratado Pedagógico de Violino', 1756, NULL, 'Tratado clássico fundamental sobre a técnica, postura, arcada e estética do violino, publicado no ano de nascimento de Wolfgang.', 'loc-de-augsburg'),
    ('obra_043_leo_brinquedos', 'pub_mozart_leopold', 'musica', 'Cassatio ex G (Sinfonia dos Brinquedos)', 'Sinfonia Lúdica com Efeitos Rústicos', 1759, NULL, 'Célebre composição camerística integrando apitos de pássaros, tambor de brinquedo e matraca.', 'loc-at-salzburgo'),

    -- Franz Xaver Wolfgang Mozart (Mozart Filho)
    ('obra_043_fxm_concerto_piano2', 'pub_mozart_franz_xaver', 'musica', 'Concerto para Piano nº 2 em Mi bemol maior (Op. 25)', 'Concerto Romântico para Piano', 1818, NULL, 'Elegante concerto estreado em Lviv e Viena demonstrando a transição do classicismo vienense para o primeiro romantismo.', 'loc-at-viena')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;


-- FAMÍLIA BEETHOVEN
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    -- Ludwig van Beethoven
    ('obra_043_bee_nona_sinfonia', 'pub_beethoven_ludwig', 'musica', 'Sinfonia nº 9 em Ré menor "Coral" (Op. 125)', 'Sinfonia com Coro e Solistas', 1824, NULL, 'Monumento da fraternidade humana e da música universal, culminando na Ode à Alegria de Schiller.', 'loc-at-viena'),
    ('obra_043_bee_quinta_sinfonia', 'pub_beethoven_ludwig', 'musica', 'Sinfonia nº 5 em Dó menor (Op. 67)', 'Sinfonia / Tema do Destino', 1808, NULL, 'Obra célebre estruturada pelo motivo rítmico de quatro notas ("o destino batendo à porta"), triunfando das trevas à luz.', 'loc-at-viena'),
    ('obra_043_bee_terceira_eroica', 'pub_beethoven_ludwig', 'musica', 'Sinfonia nº 3 em Mi bemol maior "Eroica" (Op. 55)', 'Sinfonia Heroica', 1804, NULL, 'Marco fundador do Romantismo musical, expandindo a forma sinfônica clássica para dimensões emocionais inéditas.', 'loc-at-viena'),
    ('obra_043_bee_imperador', 'pub_beethoven_ludwig', 'musica', 'Concerto para Piano nº 5 em Mi bemol maior "Imperador" (Op. 73)', 'Concerto para Piano e Orquestra', 1809, NULL, 'O ápice dos concertos para piano beethovenianos, composto durante o cerco de Viena pelas tropas napoleônicas.', 'loc-at-viena'),
    ('obra_043_bee_sonata_luar', 'pub_beethoven_ludwig', 'musica', 'Sonata para Piano nº 14 "Quasi una fantasia" (Ao Luar, Op. 27 nº 2)', 'Sonata para Piano Solo', 1801, NULL, 'Uma das mais poéticas obras para teclado da história, com seu célebre movimento inicial Adagio sostenuto.', 'loc-at-viena'),
    ('obra_043_bee_fidelio', 'pub_beethoven_ludwig', 'teatro', 'Ópera Fidelio (Op. 72)', 'Ópera de Salvação e Liberdade', 1814, NULL, 'Única ópera de Beethoven, exaltando a coragem heroica de Leonore para salvar seu marido Florestan da tirania.', 'loc-at-viena'),
    ('obra_043_bee_missa_solemnis', 'pub_beethoven_ludwig', 'musica', 'Missa Solemnis em Ré maior (Op. 123)', 'Missa Sacra Coral', 1823, NULL, 'Composição sacra monumental trazendo a inscrição: "Do coração — possa ela voltar ao coração".', 'loc-at-baden')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;


-- CHIQUINHA GONZAGA & PIONEIRISMO MUSICAL
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_043_gon_abre_alas', 'pub_gonzaga_chiquinha', 'musica', 'Ó Abre Alas (A Primeira Marcha Carnavalesca da História)', 'Marcha-Rancho / Carnaval', 1899, NULL, 'Composta para o cordão carnavalesco Rosas de Ouro, inaugurou o gênero da marcha de carnaval brasileira.', 'ibge-3304557'),
    ('obra_043_gon_atraente', 'pub_gonzaga_chiquinha', 'musica', 'Atraente (Polca-Choro Pioneira)', 'Choro Instrumental', 1877, NULL, 'Primeiro grande êxito popular de Chiquinha Gonzaga, consagrando a transição do piano de salão para o choro nativo.', 'ibge-3304557'),
    ('obra_043_gon_corta_jaca', 'pub_gonzaga_chiquinha', 'musica', 'Corta-Jaca (Gaúcho - Dança de Salão e Choro)', 'Tango Brasileiro / Dança', 1895, NULL, 'Célebre composição que escandalizou a elite conservadora ao ser executada ao violão no Palácio do Catete pela Primeira-Dama Nair de Teffé.', 'ibge-3304557'),
    ('obra_043_gon_forrobodo', 'pub_gonzaga_chiquinha', 'teatro', 'Opereta "Forrobodó"', 'Burleta de Costumes e Teatro de Revista', 1912, NULL, 'Maior sucesso da história do teatro musical ligeiro do Brasil, alcançando mais de 1.500 representações consecutivas.', 'ibge-3304557'),
    ('obra_043_gon_sbat', 'pub_gonzaga_chiquinha', 'outro', 'Fundação da Sociedade Brasileira de Autores Teatrais (SBAT)', 'Ativismo Cívico e Direitos Autorais', 1917, NULL, 'Marco pioneiro da proteção jurídica da propriedade intelectual e dos direitos autorais dos compositores e dramaturgos brasileiros.', 'ibge-3304557')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;


-- =====================================================================
-- 2. IDIOMAS FALADOS (idiomas_pessoa)
-- =====================================================================

-- Dinastia Musical Bach
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_bach_js_de', 'pub_bach_johann_sebastian_bach', 'Alemão'),
    ('idi_bach_js_fr', 'pub_bach_johann_sebastian_bach', 'Francês'),
    ('idi_bach_js_it', 'pub_bach_johann_sebastian_bach', 'Italiano'),
    ('idi_bach_js_la', 'pub_bach_johann_sebastian_bach', 'Latim'),
    ('idi_bach_cpe_de', 'pub_bach_carl_philipp_emanuel_bach', 'Alemão'),
    ('idi_bach_cpe_fr', 'pub_bach_carl_philipp_emanuel_bach', 'Francês'),
    ('idi_bach_cpe_it', 'pub_bach_carl_philipp_emanuel_bach', 'Italiano'),
    ('idi_bach_cpe_la', 'pub_bach_carl_philipp_emanuel_bach', 'Latim'),
    ('idi_bach_jcb_de', 'pub_bach_johann_christian_bach', 'Alemão'),
    ('idi_bach_jcb_en', 'pub_bach_johann_christian_bach', 'Inglês'),
    ('idi_bach_jcb_it', 'pub_bach_johann_christian_bach', 'Italiano'),
    ('idi_bach_jcb_fr', 'pub_bach_johann_christian_bach', 'Francês'),
    ('idi_bach_jcf_de', 'pub_bach_johann_christoph_friedrich_bach', 'Alemão'),
    ('idi_bach_jcf_fr', 'pub_bach_johann_christoph_friedrich_bach', 'Francês'),
    ('idi_bach_jcf_la', 'pub_bach_johann_christoph_friedrich_bach', 'Latim'),
    ('idi_bach_wfb_de', 'pub_bach_wilhelm_friedemann_bach', 'Alemão'),
    ('idi_bach_wfb_it', 'pub_bach_wilhelm_friedemann_bach', 'Italiano'),
    ('idi_bach_wfb_la', 'pub_bach_wilhelm_friedemann_bach', 'Latim'),
    ('idi_bach_amb_de', 'pub_bach_johann_ambrosius_bach', 'Alemão'),
    ('idi_bach_vtb_de', 'pub_bach_veit_bach', 'Alemão'),
    ('idi_bach_mbb_de', 'pub_bach_maria_barbara_bach', 'Alemão'),
    ('idi_bach_amb_fr', 'pub_bach_anna_magdalena_bach', 'Francês'),
    ('idi_bach_amb_it', 'pub_bach_anna_magdalena_bach', 'Italiano'),
    ('idi_bach_amb_de_ann', 'pub_bach_anna_magdalena_bach', 'Alemão');

-- Família Mozart
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_moz_wam_de', 'pub_mozart_wolfgang', 'Alemão'),
    ('idi_moz_wam_it', 'pub_mozart_wolfgang', 'Italiano'),
    ('idi_moz_wam_fr', 'pub_mozart_wolfgang', 'Francês'),
    ('idi_moz_wam_en', 'pub_mozart_wolfgang', 'Inglês'),
    ('idi_moz_wam_la', 'pub_mozart_wolfgang', 'Latim'),
    ('idi_moz_leo_de', 'pub_mozart_leopold', 'Alemão'),
    ('idi_moz_leo_it', 'pub_mozart_leopold', 'Italiano'),
    ('idi_moz_leo_la', 'pub_mozart_leopold', 'Latim'),
    ('idi_moz_leo_fr', 'pub_mozart_leopold', 'Francês'),
    ('idi_moz_anm_de', 'pub_mozart_anna_maria', 'Alemão'),
    ('idi_moz_nan_de', 'pub_mozart_nannerl', 'Alemão'),
    ('idi_moz_nan_fr', 'pub_mozart_nannerl', 'Francês'),
    ('idi_moz_nan_it', 'pub_mozart_nannerl', 'Italiano'),
    ('idi_moz_cst_de', 'pub_mozart_constanze', 'Alemão'),
    ('idi_moz_cst_fr', 'pub_mozart_constanze', 'Francês'),
    ('idi_moz_cst_it', 'pub_mozart_constanze', 'Italiano'),
    ('idi_moz_krl_de', 'pub_mozart_karl', 'Alemão'),
    ('idi_moz_krl_it', 'pub_mozart_karl', 'Italiano'),
    ('idi_moz_krl_fr', 'pub_mozart_karl', 'Francês'),
    ('idi_moz_fxm_de', 'pub_mozart_franz_xaver', 'Alemão'),
    ('idi_moz_fxm_fr', 'pub_mozart_franz_xaver', 'Francês'),
    ('idi_moz_fxm_it', 'pub_mozart_franz_xaver', 'Italiano');

-- Família Beethoven
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_bee_lud_de', 'pub_beethoven_ludwig', 'Alemão'),
    ('idi_bee_lud_fr', 'pub_beethoven_ludwig', 'Francês'),
    ('idi_bee_lud_it', 'pub_beethoven_ludwig', 'Italiano'),
    ('idi_bee_lud_la', 'pub_beethoven_ludwig', 'Latim'),
    ('idi_bee_joh_de', 'pub_beethoven_johann', 'Alemão'),
    ('idi_bee_mmk_de', 'pub_beethoven_maria_magdalena', 'Alemão'),
    ('idi_bee_krl_de', 'pub_beethoven_karl', 'Alemão'),
    ('idi_bee_krl_fr', 'pub_beethoven_karl', 'Francês'),
    ('idi_bee_kas_de', 'pub_beethoven_kaspar', 'Alemão'),
    ('idi_bee_nik_de', 'pub_beethoven_nikolaus', 'Alemão'),
    ('idi_bee_jhn_de', 'pub_beethoven_johanna', 'Alemão');

-- Chiquinha Gonzaga e Família
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_gon_chq_pt', 'pub_gonzaga_chiquinha', 'Português'),
    ('idi_gon_chq_fr', 'pub_gonzaga_chiquinha', 'Francês'),
    ('idi_gon_chq_it', 'pub_gonzaga_chiquinha', 'Italiano'),
    ('idi_gon_jbg_pt', 'pub_gonzaga_jose_basileu', 'Português'),
    ('idi_gon_rlm_pt', 'pub_gonzaga_rosa_maria', 'Português'),
    ('idi_gon_jra_pt', 'pub_gonzaga_jacinto_amaral', 'Português'),
    ('idi_gon_jbl_pt', 'pub_gonzaga_joao_batista_lage', 'Português'),
    ('idi_gon_jbl_fr', 'pub_gonzaga_joao_batista_lage', 'Francês'),
    ('idi_gon_hil_pt', 'pub_gonzaga_hilario', 'Português'),
    ('idi_gon_jga_pt', 'pub_gonzaga_joao_gualberto', 'Português'),
    ('idi_gon_mdp_pt', 'pub_gonzaga_maria_do_patrocinio', 'Português');
