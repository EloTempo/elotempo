-- grandes_genios_literatura.sql
-- Semente Canônica Dedicada do Lote 10: Grandes Gênios da Literatura Universal & Dramaturgia.
-- Contempla 5 árvores genealógicas monumentais:
-- 1. Família de William Shakespeare (Stratford-upon-Avon e Londres)
-- 2. Família de Miguel de Cervantes Saavedra (Alcalá de Henares, Lepanto, Argel e Madrid)
-- 3. Família de Dante Alighieri (Florença, Verona e Ravena)
-- 4. Família de Johann Wolfgang von Goethe (Frankfurt, Estrasburgo e Weimar)
-- 5. Família de Victor Hugo (Besançon, Paris, Jersey e Guernsey)

-- =====================================================================
-- 1. OBRAS CULTURAIS E PUBLICAÇÕES CANÔNICAS (obras_culturais) - 46 OBRAS
-- =====================================================================
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id) VALUES
-- William Shakespeare (10 obras)
('obra_038_shak_hamlet', 'pub_shakespeare_william', 'livro', 'Hamlet (A Tragédia de Hamlet, Príncipe da Dinamarca)', 'Tragédia Teatral', 1601, NULL, 'A obra-prima máxima do teatro universal, explorando a vingança, o luto, a loucura fingida e o dilema existencial do Ser ou Não Ser.', 'loc-gb-london'),
('obra_038_shak_romeu', 'pub_shakespeare_william', 'livro', 'Romeu e Julieta (The Tragedy of Romeo and Juliet)', 'Tragédia Romântica', 1595, NULL, 'A arquetípica tragédia do amor juvenil proibido entre os Montesquios e Capuletos sob o sol de Verona.', 'loc-gb-london'),
('obra_038_shak_macbeth', 'pub_shakespeare_william', 'livro', 'Macbeth (A Tragédia de Macbeth)', 'Tragédia Teatral', 1606, NULL, 'Tragédia sobre a voragem destrutiva da ambição tirânica, a culpa profunda e o destino profetizado.', 'loc-gb-london'),
('obra_038_shak_otelo', 'pub_shakespeare_william', 'livro', 'Otelo, o Mouro de Veneza (The Tragedy of Othello)', 'Tragédia Teatral', 1603, NULL, 'Obra teatral seminal sobre o ciúme patológico, a intriga maquiavélica de Iago e a pureza de Desdêmona.', 'loc-gb-london'),
('obra_038_shak_lear', 'pub_shakespeare_william', 'livro', 'O Rei Lear (The Tragedy of King Lear)', 'Tragédia Teatral', 1606, NULL, 'Épico dramático sobre a cegueira do poder, a ingratidão filial e a loucura redentora na tempestade.', 'loc-gb-london'),
('obra_038_shak_sonho', 'pub_shakespeare_william', 'livro', 'Sonho de uma Noite de Verão (A Midsummer Night’s Dream)', 'Comédia Poética', 1596, NULL, 'Comédia fantástica entrelaçando amantes atenienses, atores rústicos e o reino mágico de Puck, Titânia e Oberon.', 'loc-gb-london'),
('obra_038_shak_sonetos', 'pub_shakespeare_william', 'livro', 'Sonetos de Shakespeare (Shakespeare’s Sonnets)', 'Poesia Lírica', 1609, NULL, 'Coletânea canônica de 154 sonetos que revolucionou a lírica amorosa com meditações sobre o tempo, a beleza e a imortalidade artística.', 'loc-gb-london'),
('obra_044_shak_tempestade', 'pub_shakespeare_william', 'livro', 'A Tempestade (The Tempest)', 'Comédia Romancesca', 1611, NULL, 'O testamento poético de Shakespeare centrado na ilha mágica do duque Próspero, Ariel e Calibã, exaltando o perdão.', 'loc-gb-london'),
('obra_044_shak_julio_cesar', 'pub_shakespeare_william', 'livro', 'Júlio César (The Tragedy of Julius Caesar)', 'Drama Histórico', 1599, NULL, 'Drama político magistral sobre conspiração republicana, honra cívica e retórica oratória no Senado romano.', 'loc-gb-london'),
('obra_044_shak_mercador', 'pub_shakespeare_william', 'livro', 'O Mercador de Veneza (The Merchant of Venice)', 'Comédia Dramática', 1596, NULL, 'Drama fascinante abordando justiça, misericórdia e comércio nas figuras de Pórcia, Antônio e Shylock.', 'loc-gb-london'),

-- Miguel de Cervantes Saavedra (6 obras)
('obra_038_cerv_quixote', 'pub_cervantes_miguel', 'livro', 'El ingenioso hidalgo Don Quijote de la Mancha (Dom Quixote)', 'Romance Moderno', 1605, 1615, 'Obra fundadora e monumento do romance moderno ocidental, narrando as aventuras de Dom Quixote e seu leal escudeiro Sancho Pança.', 'loc-es-madrid'),
('obra_038_cerv_exemplares', 'pub_cervantes_miguel', 'livro', 'Novelas Exemplares (Novelas ejemplares de honestísimo entretenimiento)', 'Contos e Novelas', 1613, NULL, 'Coletânea de doze novelas curtas em prosa castelhana, incluindo Rinconete y Cortadillo e El coloquio de los perros.', 'loc-es-madrid'),
('obra_038_cerv_galatea', 'pub_cervantes_miguel', 'livro', 'A Galateia (La Galatea)', 'Novela Pastoril', 1585, NULL, 'Primeiro livro publicado por Cervantes, refinada narrativa pastoril renascentista permeada de poesia lírica.', 'loc-es-alcala'),
('obra_038_cerv_persiles', 'pub_cervantes_miguel', 'livro', 'Os Trabalhos de Persiles e Sigismunda (Los trabalhos de Persiles y Sigismunda)', 'Romance Bizantino', 1617, NULL, 'Romance póstumo de peregrinação e aventuras nórdicas até Roma, cuja comovente dedicatória foi redigida às vésperas de falecer.', 'loc-es-madrid'),
('obra_044_cerv_parnaso', 'pub_cervantes_miguel', 'livro', 'Viagem do Parnaso (Viaje del Parnaso)', 'Poema Alegórico', 1614, NULL, 'Poema autobiográfico em tercetos encadeados em que Cervantes revisita espirituosamente os poetas espanhóis de sua época.', 'loc-es-madrid'),
('obra_044_cerv_numancia', 'pub_cervantes_miguel', 'livro', 'O Cerco de Numância (El cerco de Numancia)', 'Tragédia Heroica', 1582, NULL, 'Tragédia épica clássica celebrando a resistência estoica e o sacrifício coletivo da cidade ibérica contra as legiões romanas.', 'loc-es-madrid'),

-- Dante Alighieri e Família (7 obras)
('obra_038_dant_comedia', 'pub_dante_alighieri', 'livro', 'A Divina Comédia (Inferno, Purgatório e Paraíso)', 'Poema Épico Teológico', 1308, 1321, 'A mais sublime epopeia poética e filosófica da Cristandade ocidental em terza rima, guiada por Virgílio e pela luz de Beatrice Portinari.', 'loc-it-ravenna'),
('obra_038_dant_vitanova', 'pub_dante_alighieri', 'livro', 'Vita Nova', 'Prosimetrum Lírico', 1294, NULL, 'Obra-prima em prosa e verso do Dolce Stil Novo, consagrada ao amor celestial e transformador por Beatrice Portinari.', 'loc-it-firenze'),
('obra_038_dant_vulgari', 'pub_dante_alighieri', 'livro', 'De Vulgari Eloquentia', 'Tratado de Linguística e Poética', 1305, NULL, 'Tratado pioneiro defendendo a dignidade e perfeição expressiva da língua vulgar toscana para a criação literária.', 'loc-it-firenze'),
('obra_038_dant_monarchia', 'pub_dante_alighieri', 'livro', 'De Monarchia', 'Tratado Político e Filosófico', 1313, NULL, 'Tratado defendendo um império laico e universal com autoridade autônoma face ao poder teocrático papal.', 'loc-it-verona'),
('obra_044_dant_convivio', 'pub_dante_alighieri', 'livro', 'Il Convivio (O Banquete da Sabedoria)', 'Ensaio Filosófico e Poético', 1307, NULL, 'Banquete do saber oferecendo aos leigos os frutos da filosofia moral, metafísica e política em vernáculo toscano.', 'loc-it-firenze'),
('obra_044_dant_pietro_comm', 'pub_dante_pietro', 'livro', 'Commentarium super Dantis Comoediam', 'Crítica e Hermenêutica Literária', 1340, NULL, 'O primeiro grande comentário erudito em latim sobre a Divina Comédia, redigido pelo filho magistrado do poeta para elucidar as referências clássicas e canônicas do pai.', 'loc-it-verona'),
('obra_044_dant_jacopo_dottr', 'pub_dante_jacopo', 'livro', 'Il Dottrinale', 'Poema Didático e Exegético', 1320, NULL, 'Poema moral e didático em tercetos toscanos de 60 capítulos e primeiras notas explicativas em vernáculo dos cantos do pai Dante.', 'loc-it-ravenna'),

-- Johann Wolfgang von Goethe e Família (11 obras)
('obra_038_goet_fausto', 'pub_goethe_johann_wolfgang', 'livro', 'Fausto: Uma Tragédia (Faust: Der Tragödie erster und zweiter Teil)', 'Drama Trágico em Versos', 1808, 1832, 'Monumento imperecível da alma moderna, retratando o pacto do Doutor Fausto com Mefistófeles em busca da plenitude do conhecimento e redenção.', 'loc-de-weimar'),
('obra_038_goet_werther', 'pub_goethe_johann_wolfgang', 'livro', 'Os Sofrimentos do Jovem Werther (Die Leiden des jungen Werthers)', 'Romance Epistolar', 1774, NULL, 'Romance clássico do Sturm und Drang que marcou a literatura mundial com a intensidade da paixão romântica de Werther por Lotte.', 'loc-de-wetzlar'),
('obra_038_goet_italia', 'pub_goethe_johann_wolfgang', 'livro', 'Viagem à Itália (Italienische Reise)', 'Memórias de Viagem', 1816, NULL, 'Crônica literária da travessia transformadora pela Península Itálica, marco do nascimento do Classicismo de Weimar.', 'loc-it-roma'),
('obra_038_goet_cores', 'pub_goethe_johann_wolfgang', 'livro', 'Teoria das Cores (Zur Farbenlehre)', 'Tratado de Óptica e Percepção', 1810, NULL, 'Investigação inovadora sobre a fisiologia, psicologia e fenomenologia das cores em oposição ao reducionismo estritamente mecânico.', 'loc-de-weimar'),
('obra_044_goet_wilhelm', 'pub_goethe_johann_wolfgang', 'livro', 'Os Anos de Aprendizado de Wilhelm Meister (Wilhelm Meisters Lehrjahre)', 'Romance de Formação (Bildungsroman)', 1796, NULL, 'O modelo definitivo do romance de formação europeu, retratando a maturidade individual através da arte e da experiência vital.', 'loc-de-weimar'),
('obra_044_goet_elegias', 'pub_goethe_johann_wolfgang', 'livro', 'Elegias Romanas (Römische Elegien)', 'Poesia Lírica Clássica', 1795, NULL, 'Ciclo de vinte e quatro elegias eróticas e estéticas celebrando a união sensual inspirada na estada em Roma e em Christiane Vulpius.', 'loc-de-weimar'),
('obra_044_goet_ifigenia', 'pub_goethe_johann_wolfgang', 'livro', 'Ifigênia em Táuris (Iphigenie auf Tauris)', 'Drama Clássico em Pentâmetros', 1787, NULL, 'A mais nobre exaltação do humanismo moral clássico onde a verdade interior e a empatia superam a violência ancestral dos deuses.', 'loc-de-weimar'),
('obra_044_goet_tasso', 'pub_goethe_johann_wolfgang', 'livro', 'Torquato Tasso', 'Drama em Versos', 1790, NULL, 'Retrato dramático do dilema entre a liberdade indomável da vocação artística e os limites da etiqueta cortês em Ferrara.', 'loc-de-weimar'),
('obra_044_goet_jasp_viaggio', 'pub_goethe_johann_caspar', 'livro', 'Viaggio per l''Italia', 'Diário e Guia de Viagem', 1740, NULL, 'Diário erudito de viagem redigido em italiano por Johann Caspar Goethe que inspirou desde a infância o fascínio de Goethe pela Itália.', 'loc-it-roma'),
('obra_044_goet_corn_diarios', 'pub_goethe_cornelia', 'livro', 'Correspondance Française et Journaux Intimes', 'Epistolografia e Diários', 1767, NULL, 'Cartas em francês e diários espirituosos mantidos com sua confidente Luise von Göchhausen, testemunho do Iluminismo feminino em Frankfurt.', 'loc-de-frankfurt'),
('obra_044_goet_otti_chaos', 'pub_goethe_ottilie', 'livro', 'Revista Literária Chaos (1829–1832)', 'Periódico Literário Internacional', 1829, 1832, 'Seminário e revista literária multilíngue fundada e dirigida em Weimar por Ottilie von Goethe, com ensaios e poemas de Goethe e jovens autores europeus.', 'loc-de-weimar'),

-- Victor Hugo e Família (12 obras)
('obra_038_hugo_miseraveis', 'pub_hugo_victor', 'livro', 'Os Miseráveis (Les Misérables)', 'Romance Social Épico', 1862, NULL, 'Épico imortal da redenção humana nas trajetórias entrelaçadas de Jean Valjean, Javert, Fantine, Cosette e as barricadas republicanas de 1832.', 'loc-gg-guernsey'),
('obra_038_hugo_notredame', 'pub_hugo_victor', 'livro', 'Nossa Senhora de Paris (Notre-Dame de Paris)', 'Romance Histórico Gótico', 1831, NULL, 'Romance monumental em torno da catedral medieval, salvando o patrimônio histórico francês através de Quasimodo e Esmeralda.', 'loc-fr-paris'),
('obra_038_hugo_trabalhadores', 'pub_hugo_victor', 'livro', 'Os Trabalhadores do Mar (Les Travailleurs de la Mer)', 'Romance Épico Marítimo', 1866, NULL, 'Romance do combate do homem contra as forças titânicas do oceano, dedicado à rochosa e acolhedora ilha de Guernsey.', 'loc-gg-guernsey'),
('obra_038_hugo_contemplacoes', 'pub_hugo_victor', 'livro', 'As Contemplações (Les Contemplations)', 'Poesia Lírica e Filosófica', 1856, NULL, 'Vasto ciclo poético em seis livros (Autrefois / Aujourd''hui), elegia comovente pela morte de sua filha Léopoldine Hugo.', 'loc-gg-guernsey'),
('obra_044_hugo_hernani', 'pub_hugo_victor', 'livro', 'Hernani (ou a Honra Castelhana)', 'Drama Romântico em Versos', 1830, NULL, 'Peça histórica cuja estreia triunfal na Comédie-Française deflagrou a histórica Batalha de Hernani, libertando o teatro clássico francês.', 'loc-fr-paris'),
('obra_044_hugo_homem_ri', 'pub_hugo_victor', 'livro', 'O Homem que Ri (L''Homme qui rit)', 'Romance Filosófico e Social', 1869, NULL, 'Fábula política sobre Gwynplaine e Dea, denunciando o desdém aristocrático e a exploração do sofrimento dos humildes.', 'loc-gg-guernsey'),
('obra_044_hugo_noventa_tres', 'pub_hugo_victor', 'livro', 'Noventa e Três (Quatrevingt-treize)', 'Romance Histórico Revolucionário', 1874, NULL, 'Último romance de Victor Hugo, meditação sobre o heroísmo trágico e os dilemas morais da Revolução Francesa e da insurreição da Vendeia.', 'loc-fr-paris'),
('obra_044_hugo_castigos', 'pub_hugo_victor', 'livro', 'Os Castigos (Les Châtiments)', 'Sátira Política e Poesia Cívica', 1853, NULL, 'Panfleto poético demolidor contra o golpe de Estado e a tirania de Napoleão III ("Napoléon le Petit"), composto no exílio de Jersey.', 'loc-gb-jersey'),
('obra_044_hugo_fv_shak', 'pub_hugo_francois_victor', 'livro', 'Œuvres complètes de Shakespeare (Tradução Integral em 18 Volumes)', 'Tradução Erudita e Crítica Teatral', 1859, 1866, 'A tradução mais aclamada e completa de Shakespeare para a língua francesa, realizada durante o longo exílio em Guernsey.', 'loc-gg-guernsey'),
('obra_044_hugo_char_boheme', 'pub_hugo_charles', 'livro', 'La Bohème dorée & Atelier Fotográfico de Marine Terrace', 'Romance e Fotografia Pioneira', 1853, 1859, 'Produção de romances sociais e o célebre atelier fotográfico de Jersey e Guernsey com Auguste Vacquerie, registrando a iconografia da família Hugo.', 'loc-gb-jersey'),
('obra_044_hugo_adele_biog', 'pub_hugo_adele_foucher', 'livro', 'Victor Hugo raconté par un témoin de sa vie', 'Biografia e Memórias', 1863, NULL, 'Biografia memorialística de Victor Hugo escrita por sua esposa Adèle, fonte primária imprescindível sobre os primórdios do Romantismo.', 'loc-fr-paris'),
('obra_044_hugo_abel_napoleon', 'pub_hugo_abel', 'livro', 'Histoire de l''Empereur Napoléon & France Militaire', 'Historiografia Militar', 1833, 1836, 'Obra historiográfica volumosa e pioneira de Abel Hugo documentando as campanhas napoleônicas e a trajetória dos exércitos franceses.', 'loc-fr-paris')
ON CONFLICT(id) DO UPDATE SET
  titulo = excluded.titulo,
  detalhes = excluded.detalhes,
  ano = excluded.ano,
  ano_fim = excluded.ano_fim,
  subtipo = excluded.subtipo,
  local_id = excluded.local_id;

-- =====================================================================
-- 2. IDIOMAS FALADOS (idiomas_pessoa) - COBERTURA INTEGRAL DOS 37 MEMBROS
-- =====================================================================
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
-- Família Shakespeare (7 membros)
('idi_044_shak_will_en', 'pub_shakespeare_william', 'Inglês'),
('idi_044_shak_will_la', 'pub_shakespeare_william', 'Latim'),
('idi_044_shak_will_fr', 'pub_shakespeare_william', 'Francês'),
('idi_044_shak_will_it', 'pub_shakespeare_william', 'Italiano'),
('idi_044_shak_anne_en', 'pub_shakespeare_anne_hathaway', 'Inglês'),
('idi_044_shak_john_en', 'pub_shakespeare_john', 'Inglês'),
('idi_044_shak_mary_en', 'pub_shakespeare_mary_arden', 'Inglês'),
('idi_044_shak_susa_en', 'pub_shakespeare_susanna', 'Inglês'),
('idi_044_shak_susa_la', 'pub_shakespeare_susanna', 'Latim'),
('idi_044_shak_judi_en', 'pub_shakespeare_judith', 'Inglês'),
('idi_044_shak_joan_en', 'pub_shakespeare_joan', 'Inglês'),

-- Família Cervantes (8 membros)
('idi_044_cerv_mig_es', 'pub_cervantes_miguel', 'Espanhol'),
('idi_044_cerv_mig_it', 'pub_cervantes_miguel', 'Italiano'),
('idi_044_cerv_mig_la', 'pub_cervantes_miguel', 'Latim'),
('idi_044_cerv_mig_ar', 'pub_cervantes_miguel', 'Árabe'),
('idi_044_cerv_cat_es', 'pub_cervantes_catalina', 'Espanhol'),
('idi_044_cerv_rod_es', 'pub_cervantes_rodrigo', 'Espanhol'),
('idi_044_cerv_leo_es', 'pub_cervantes_leonor', 'Espanhol'),
('idi_044_cerv_rodjr_es', 'pub_cervantes_rodrigo_jr', 'Espanhol'),
('idi_044_cerv_rodjr_it', 'pub_cervantes_rodrigo_jr', 'Italiano'),
('idi_044_cerv_and_es', 'pub_cervantes_andrea', 'Espanhol'),
('idi_044_cerv_ana_es', 'pub_cervantes_ana_franca', 'Espanhol'),
('idi_044_cerv_isa_es', 'pub_cervantes_isabel', 'Espanhol'),

-- Família Dante Alighieri (7 membros)
('idi_044_dant_dan_it', 'pub_dante_alighieri', 'Italiano'),
('idi_044_dant_dan_la', 'pub_dante_alighieri', 'Latim'),
('idi_044_dant_dan_oc', 'pub_dante_alighieri', 'Provençal (Occitano)'),
('idi_044_dant_bea_it', 'pub_dante_beatrice_portinari', 'Italiano'),
('idi_044_dant_piet_it', 'pub_dante_pietro', 'Italiano'),
('idi_044_dant_piet_la', 'pub_dante_pietro', 'Latim'),
('idi_044_dant_jac_it', 'pub_dante_jacopo', 'Italiano'),
('idi_044_dant_jac_la', 'pub_dante_jacopo', 'Latim'),
('idi_044_dant_gem_it', 'pub_dante_gemma_donati', 'Italiano'),
('idi_044_dant_bel_it', 'pub_dante_bella', 'Italiano'),
('idi_044_dant_ali_it', 'pub_dante_alighiero', 'Italiano'),
('idi_044_dant_ali_la', 'pub_dante_alighiero', 'Latim'),

-- Família Goethe (7 membros)
('idi_044_goet_jw_de', 'pub_goethe_johann_wolfgang', 'Alemão'),
('idi_044_goet_jw_fr', 'pub_goethe_johann_wolfgang', 'Francês'),
('idi_044_goet_jw_it', 'pub_goethe_johann_wolfgang', 'Italiano'),
('idi_044_goet_jw_en', 'pub_goethe_johann_wolfgang', 'Inglês'),
('idi_044_goet_jw_la', 'pub_goethe_johann_wolfgang', 'Latim'),
('idi_044_goet_jw_gr', 'pub_goethe_johann_wolfgang', 'Grego Antigo'),
('idi_044_goet_jw_he', 'pub_goethe_johann_wolfgang', 'Hebraico Bíblico'),
('idi_044_goet_jc_de', 'pub_goethe_johann_caspar', 'Alemão'),
('idi_044_goet_jc_it', 'pub_goethe_johann_caspar', 'Italiano'),
('idi_044_goet_jc_fr', 'pub_goethe_johann_caspar', 'Francês'),
('idi_044_goet_jc_la', 'pub_goethe_johann_caspar', 'Latim'),
('idi_044_goet_cat_de', 'pub_goethe_catharina', 'Alemão'),
('idi_044_goet_cat_fr', 'pub_goethe_catharina', 'Francês'),
('idi_044_goet_cor_de', 'pub_goethe_cornelia', 'Alemão'),
('idi_044_goet_cor_fr', 'pub_goethe_cornelia', 'Francês'),
('idi_044_goet_cor_en', 'pub_goethe_cornelia', 'Inglês'),
('idi_044_goet_cor_it', 'pub_goethe_cornelia', 'Italiano'),
('idi_044_goet_chr_de', 'pub_goethe_christiane', 'Alemão'),
('idi_044_goet_aug_de', 'pub_goethe_august', 'Alemão'),
('idi_044_goet_aug_fr', 'pub_goethe_august', 'Francês'),
('idi_044_goet_aug_it', 'pub_goethe_august', 'Italiano'),
('idi_044_goet_ott_de', 'pub_goethe_ottilie', 'Alemão'),
('idi_044_goet_ott_fr', 'pub_goethe_ottilie', 'Francês'),
('idi_044_goet_ott_en', 'pub_goethe_ottilie', 'Inglês'),

-- Família Victor Hugo (8 membros)
('idi_044_hugo_vic_fr', 'pub_hugo_victor', 'Francês'),
('idi_044_hugo_vic_es', 'pub_hugo_victor', 'Espanhol'),
('idi_044_hugo_vic_la', 'pub_hugo_victor', 'Latim'),
('idi_044_hugo_vic_en', 'pub_hugo_victor', 'Inglês'),
('idi_044_hugo_ade_fr', 'pub_hugo_adele_foucher', 'Francês'),
('idi_044_hugo_leo_fr', 'pub_hugo_leopoldine', 'Francês'),
('idi_044_hugo_cha_fr', 'pub_hugo_charles', 'Francês'),
('idi_044_hugo_cha_en', 'pub_hugo_charles', 'Inglês'),
('idi_044_hugo_fv_fr', 'pub_hugo_francois_victor', 'Francês'),
('idi_044_hugo_fv_en', 'pub_hugo_francois_victor', 'Inglês'),
('idi_044_hugo_jl_fr', 'pub_hugo_joseph_leopold', 'Francês'),
('idi_044_hugo_jl_es', 'pub_hugo_joseph_leopold', 'Espanhol'),
('idi_044_hugo_jl_it', 'pub_hugo_joseph_leopold', 'Italiano'),
('idi_044_hugo_sop_fr', 'pub_hugo_sophie', 'Francês'),
('idi_044_hugo_abe_fr', 'pub_hugo_abel', 'Francês'),
('idi_044_hugo_abe_es', 'pub_hugo_abel', 'Espanhol'),
('idi_044_hugo_abe_it', 'pub_hugo_abel', 'Italiano');
