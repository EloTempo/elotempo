-- artes_literatura.sql
-- Semente canônica do Lote 4: Grandes Gênios da Literatura e das Artes Clássicas.
-- Contempla 7 árvores genealógicas monumentais:
-- 1. Família de Wolfgang Amadeus Mozart (Salzburgo e Viena)
-- 2. Família de Ludwig van Beethoven (Bonn e Viena)
-- 3. Família de William Shakespeare (Stratford-upon-Avon e Londres)
-- 4. Família de Dante Alighieri (Florença, Verona e Ravena)
-- 5. Família de Miguel de Cervantes Saavedra (Alcalá de Henares e Madrid)
-- 6. Família de Johann Wolfgang von Goethe (Frankfurt e Weimar)
-- 7. Família de Victor Hugo (Besançon, Paris e Guernsey)

-- =====================================================================
-- 1. PESSOAS REAIS (pessoas)
-- =====================================================================

-- MOZART
INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico) VALUES
('pub_mozart_leopold', 'Johann Georg Leopold', 'Mozart', 'M', 'Compositor, pedagogo musical de renome europeu, autor do influente tratado de violino Versuch einer gründlichen Violinschule e vice-mestre de capela do príncipe-arcebispo de Salzburgo; pai e mentor de Wolfgang Amadeus Mozart.', 0, 0, 1),
('pub_mozart_anna_maria', 'Anna Maria', 'Pertl Mozart', 'F', 'Mãe de Wolfgang Amadeus Mozart e Nannerl, que o acompanhou nas grandes viagens e turnês musicais da juventude até falecer em Paris durante a turnê de 1778.', 0, 0, 1),
('pub_mozart_nannerl', 'Maria Anna', 'Mozart (Nannerl)', 'F', 'Virtuosa cravista e pianista austríaca, irmã mais velha de Mozart com quem excursionou como prodígio musical pelas cortes da Europa, guardiã memorial da família.', 0, 0, 1),
('pub_mozart_wolfgang', 'Wolfgang Amadeus', 'Mozart (Johannes Chrysostomus Wolfgangus Theophilus)', 'M', 'Gênio supremo da música ocidental clássica, criador de mais de 600 obras-primas transcendentais entre sinfonias, óperas, concertos e o lendário Requiem.', 0, 0, 1),
('pub_mozart_constanze', 'Constanze', 'Weber Mozart (von Nissen)', 'F', 'Soprano talentosa, esposa dedicada de Mozart e articuladora incansável da preservação, publicação e perpetuação histórica da obra integral do marido.', 0, 0, 1),
('pub_mozart_karl', 'Karl Thomas', 'Mozart', 'M', 'Filho primogênito sobrevivente de Mozart, pianista amador talentoso e respeitado oficial fazendário a serviço do Império Austríaco em Milão.', 0, 0, 1),
('pub_mozart_franz_xaver', 'Franz Xaver Wolfgang', 'Mozart (Wolfgang Amadeus Mozart Filho)', 'M', 'Compositor, regente e pianista virtuoso da era clássica tardia e romântica inicial, filho caçula de Mozart e fundador da Sociedade Musical de Lviv (Lemberg).', 0, 0, 1),

-- BEETHOVEN
('pub_beethoven_johann', 'Johann', 'van Beethoven', 'M', 'Tenor e cravista da corte do príncipe-eleitor de Colônia em Bonn, primeiro professor de música de seu filho Ludwig van Beethoven.', 0, 0, 1),
('pub_beethoven_maria_magdalena', 'Maria Magdalena', 'Keverich van Beethoven', 'F', 'Mulher de profunda retidão e doçura, mãe de Ludwig van Beethoven, descrita pelo compositor como sua melhor amiga e conselheira na juventude.', 0, 0, 1),
('pub_beethoven_ludwig', 'Ludwig', 'van Beethoven', 'M', 'Colosso da história da música, revolucionou a sinfonia, o quarteto de cordas e o concerto, estabelecendo a transição do Classicismo para o Romantismo com força heroica e humanista universal.', 0, 0, 1),
('pub_beethoven_kaspar', 'Kaspar Anton Karl', 'van Beethoven', 'M', 'Irmão de Ludwig van Beethoven, músico e assessor fazendário em Viena, cuja morte precoce deflagrou a longa tutela do compositor sobre o sobrinho Karl.', 0, 0, 1),
('pub_beethoven_nikolaus', 'Nikolaus Johann', 'van Beethoven', 'M', 'Irmão mais novo de Beethoven, boticário e próspero proprietário rural em Linz e Gneixendorf.', 0, 0, 1),
('pub_beethoven_johanna', 'Johanna', 'Reiss van Beethoven', 'F', 'Esposa de Kaspar Anton Karl e mãe de Karl van Beethoven, cuja disputa de guarda com o cunhado Ludwig marcou os anos maduros do mestre.', 0, 0, 1),
('pub_beethoven_karl', 'Karl', 'van Beethoven', 'M', 'Sobrinho e pupilo sob a custódia de Ludwig van Beethoven, herdeiro universal do espólio musical e manuscritos do tio.', 0, 0, 1),

-- SHAKESPEARE
('pub_shakespeare_john', 'John', 'Shakespeare', 'M', 'Luveiro proeminente, comerciante de couro, proprietário de terras e Alto Bailio (prefeito) de Stratford-upon-Avon, pai de William Shakespeare.', 0, 0, 1),
('pub_shakespeare_mary_arden', 'Mary', 'Arden Shakespeare', 'F', 'Herdeira da nobre fidalguia rural de Wilmcote (Warwickshire), mãe de William Shakespeare que lhe transmitiu sólida dignidade ancestral.', 0, 0, 1),
('pub_shakespeare_william', 'William', 'Shakespeare (O Bardo de Avon)', 'M', 'Considerado o maior escritor da língua inglesa e o dramaturgo mais influente de todos os tempos, criador de Hamlet, Romeu e Julieta, Macbeth e dos célebres Sonetos.', 0, 0, 1),
('pub_shakespeare_anne_hathaway', 'Anne', 'Hathaway Shakespeare', 'F', 'Esposa de William Shakespeare, natural da aldeia de Shottery, com quem o poeta compartilhou mais de três décadas de casamento e a residência de New Place.', 0, 0, 1),
('pub_shakespeare_joan', 'Joan', 'Shakespeare Hart', 'F', 'Irmã de William Shakespeare que residiu na casa natal da Henley Street e manteve a descendência viva do clã Shakespeare em Stratford.', 0, 0, 1),
('pub_shakespeare_susanna', 'Susanna', 'Shakespeare Hall', 'F', 'Filha primogênita e herdeira principal de William Shakespeare, mulher letrada e casada com o renomado médico Dr. John Hall na Hall’s Croft.', 0, 0, 1),
('pub_shakespeare_judith', 'Judith', 'Shakespeare Quiney', 'F', 'Filha caçula de William Shakespeare e irmã gêmea de Hamnet, casada com o comerciante de vinhos Thomas Quiney em Stratford.', 0, 0, 1),

-- DANTE
('pub_dante_alighiero', 'Alighiero', 'di Bellincione', 'M', 'Jurista, cambista e notário florentino da facção dos Güelfos, pai de Dante Alighieri.', 0, 0, 1),
('pub_dante_bella', 'Bella', 'degli Abati', 'F', 'Matriarca da prestigiosa família patrícia degli Abati de Florença, mãe de Dante Alighieri.', 0, 0, 1),
('pub_dante_alighieri', 'Dante', 'Alighieri (Durante di Alighiero degli Alighieri)', 'M', 'O Sumo Poeta (Il Sommo Poeta) da Itália, pai da língua italiana moderna e criador da imortal Divina Comédia, magistrado florentino e arauto do pensamento medieval.', 0, 0, 1),
('pub_dante_gemma_donati', 'Gemma', 'Donati Alighieri', 'F', 'Nobre florentina da poderosa linhagem patrícia dos Donati, esposa de Dante Alighieri e mãe de seus quatro filhos.', 0, 0, 1),
('pub_dante_pietro', 'Pietro', 'Alighieri', 'M', 'Magistrado e juiz em Verona, primogênito de Dante e autor do Commentarium, primeira grande análise erudita em latim sobre a Divina Comédia.', 0, 0, 1),
('pub_dante_jacopo', 'Jacopo', 'Alighieri', 'M', 'Poeta e erudito, segundo filho de Dante que acompanhou o pai no exílio de Ravena e compôs o célebre poema explicativo Il Dottrinale.', 0, 0, 1),
('pub_dante_beatrice_portinari', 'Beatrice', 'Portinari (Bice)', 'F', 'Nobre florentina, filha de Folco Portinari, musa transcendental do Dolce Stil Novo e guia espiritual imortalizada por Dante na Vita Nova e no Paraíso da Divina Comédia.', 0, 0, 1),

-- CERVANTES
('pub_cervantes_rodrigo', 'Rodrigo', 'de Cervantes', 'M', 'Cirurgião-barbeiro itinerante de ascendência fidalga cordovesa, pai de Miguel de Cervantes.', 0, 0, 1),
('pub_cervantes_leonor', 'Leonor', 'de Cortinas', 'F', 'Mulher de excepcional coragem e determinação, mãe de Cervantes, que reuniu o dinheiro do resgate para libertar os filhos do cativeiro de Argel.', 0, 0, 1),
('pub_cervantes_miguel', 'Miguel', 'de Cervantes Saavedra (El Príncipe de los Ingenios)', 'M', 'Gênio supremo da literatura em língua espanhola e criador do romance moderno ocidental com Dom Quixote de la Mancha, veterano e herói ferido na Batalha de Lepanto.', 0, 0, 1),
('pub_cervantes_andrea', 'Andrea', 'de Cervantes', 'F', 'Irmã mais velha de Miguel de Cervantes, costureira e esteio de solidariedade familiar nas sucessivas crises econômicas em Madrid e Valladolid.', 0, 0, 1),
('pub_cervantes_rodrigo_jr', 'Rodrigo', 'de Cervantes (o Jovem)', 'M', 'Soldado dos Terços espanhóis de Flandres e do Mediterrâneo, companheiro de armas de Miguel em Lepanto e no cárcere de Argel.', 0, 0, 1),
('pub_cervantes_catalina', 'Catalina', 'de Salazar y Palacios', 'F', 'Fidalga proprietária de terras de Esquivias (Toledo), esposa de Miguel de Cervantes durante mais de três décadas.', 0, 0, 1),
('pub_cervantes_ana_franca', 'Ana', 'Franca de Rojas', 'F', 'Mãe de Isabel de Saavedra, companheira de Miguel de Cervantes em Madrid.', 0, 0, 1),
('pub_cervantes_isabel', 'Isabel', 'de Saavedra', 'F', 'Única filha reconhecida de Miguel de Cervantes, mantida próxima ao pai nos anos áureos da publicação de Dom Quixote.', 0, 0, 1),

-- GOETHE
('pub_goethe_johann_caspar', 'Johann Caspar', 'Goethe', 'M', 'Conselheiro Imperial (Kaiserlicher Rat) em Frankfurt, doutor em Direito pela Universidade de Giessen, erudito e viajante, pai e primeiro instrutor de Goethe.', 0, 0, 1),
('pub_goethe_catharina', 'Catharina Elisabeth', 'Textor Goethe (Frau Rat)', 'F', 'Filha do prefeito de Frankfurt, mulher de invulgar inteligência, imaginação narrativa e generosidade, mãe e confidente de Johann Wolfgang von Goethe.', 0, 0, 1),
('pub_goethe_johann_wolfgang', 'Johann Wolfgang', 'von Goethe', 'M', 'Titã das letras alemãs e figura máxima da literatura universal, autor de Fausto e Os Sofrimentos do Jovem Werther, polímata, botânico, teórico das cores e Primeiro-Ministro do Ducado de Saxe-Weimar.', 0, 0, 1),
('pub_goethe_cornelia', 'Cornelia', 'Goethe Schlosser', 'F', 'Irmã amada de Goethe, interlocutora brilhante de seus primeiros anseios literários e correspondente culta do Iluminismo alemão.', 0, 0, 1),
('pub_goethe_christiane', 'Christiane', 'Vulpius von Goethe', 'F', 'Companheira devota de Goethe em Weimar durante quase trinta anos, guardiã da casa e inspiração lírica das Elegias Romanas.', 0, 0, 1),
('pub_goethe_august', 'Julius August Walther', 'von Goethe', 'M', 'Filho único sobrevivente de Goethe, camareiro e conselheiro no grão-ducado de Weimar, assistente leal do pai na organização de seus arquivos.', 0, 0, 1),
('pub_goethe_ottilie', 'Ottilie', 'von Pogwisch von Goethe', 'F', 'Nora de Goethe, editora da revista literária Chaos e anfitriã brilhante dos círculos intelectuais de Weimar nos anos finais do poeta.', 0, 0, 1),

-- VICTOR HUGO
('pub_hugo_joseph_leopold', 'Joseph Léopold Sigisbert', 'Hugo (Conde Hugo)', 'M', 'General de divisão do exército napoleônico, governador provincial na Espanha e na Itália, pai de Victor Hugo.', 0, 0, 1),
('pub_hugo_sophie', 'Sophie', 'Trébuchet Hugo', 'F', 'Aristocrata bretã e monarquista convicta, mãe de Victor Hugo que incutiu nos filhos o amor pelas letras e pelas artes clássicas.', 0, 0, 1),
('pub_hugo_victor', 'Victor Marie', 'Hugo (Pair de France)', 'M', 'Patriarca supremo da literatura francesa e líder inconteste do Romantismo, autor monumental de Os Miseráveis e Nossa Senhora de Paris, dramaturgo, poeta lírico e senador da Terceira República.', 0, 0, 1),
('pub_hugo_adele_foucher', 'Adèle', 'Foucher Hugo', 'F', 'Amiga de infância e esposa de Victor Hugo, anfitriã literária dos românticos e autora da biografia testemunhal Victor Hugo raconté par un témoin de sa vie.', 0, 0, 1),
('pub_hugo_abel', 'Abel', 'Hugo', 'M', 'Irmão mais velho de Victor Hugo, militar, historiador militar e ensaísta, cofundador da revista literária Le Conservateur littéraire.', 0, 0, 1),
('pub_hugo_leopoldine', 'Léopoldine', 'Cécile Marie-Pierre Catherine Hugo', 'F', 'Filha primogênita muito amada de Victor Hugo, cuja trágica morte prematura por afogamento no rio Sena em Villequier inspirou as sublimes elegias de Les Contemplations.', 0, 0, 1),
('pub_hugo_charles', 'Charles', 'Hugo', 'M', 'Jornalista, romancista e pioneiro da arte fotográfica em Jersey e Guernsey, companheiro de exílio político de Victor Hugo.', 0, 0, 1),
('pub_hugo_francois_victor', 'François-Victor', 'Hugo', 'M', 'Escritor e célebre tradutor para o francês da obra teatral e poética completa de William Shakespeare, aclamada universalmente pela erudição.', 0, 0, 1)
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  sobrenome = excluded.sobrenome,
  sexo = excluded.sexo,
  minibiografia = excluded.minibiografia,
  is_publico = 1;

-- =====================================================================
-- 2. ÁRVORES GENEALÓGICAS (arvores)
-- =====================================================================
INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo) VALUES
('pub_arv_mozart', 'Família de Wolfgang Amadeus Mozart', 'Linhagem musical de Salzburgo e Viena que legou à humanidade o gênio clássico universal de Wolfgang Amadeus Mozart.', 'pub_mozart_leopold', 1, 'Música Clássica e Artes', 'Áustria', '1719–1858', 'real'),
('pub_arv_beethoven', 'Família de Ludwig van Beethoven', 'Linhagem de músicos e cantores de corte em Bonn e Viena que moldou a força criadora heroica de Ludwig van Beethoven.', 'pub_beethoven_johann', 1, 'Música Clássica e Artes', 'Alemanha', '1740–1869', 'real'),
('pub_arv_shakespeare', 'Família de William Shakespeare', 'Linhagem de comerciantes de Stratford-upon-Avon e o Bardo de Avon, o maior dramaturgo e poeta da língua inglesa.', 'pub_shakespeare_john', 1, 'Grandes Autores e Pensadores', 'Reino Unido', '1531–1662', 'real'),
('pub_arv_dante', 'Família de Dante Alighieri', 'Linhagem patrícia de Florença, Verona e Ravena centrada no Sumo Poeta, autor de A Divina Comédia e pai da língua italiana.', 'pub_dante_alighiero', 1, 'Grandes Autores e Pensadores', 'Itália', '1220–1364', 'real'),
('pub_arv_cervantes', 'Família de Miguel de Cervantes', 'Linhagem solariega e peregrina de Alcalá de Henares e Madrid, berço do criador de Dom Quixote de la Mancha.', 'pub_cervantes_rodrigo', 1, 'Grandes Autores e Pensadores', 'Espanha', '1509–1652', 'real'),
('pub_arv_goethe', 'Família de Johann Wolfgang von Goethe', 'Linhagem imperial e letrada de Frankfurt e da corte clássica de Weimar, berço do autor monumental de Fausto.', 'pub_goethe_johann_caspar', 1, 'Grandes Autores e Pensadores', 'Alemanha', '1710–1872', 'real'),
('pub_arv_victor_hugo', 'Família de Victor Hugo', 'Linhagem de generais imperiais e escritores românticos franceses centrada no autor imortal de Os Miseráveis e Notre-Dame de Paris.', 'pub_hugo_joseph_leopold', 1, 'Grandes Autores e Pensadores', 'França', '1773–1885', 'real')
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  descricao = excluded.descricao,
  raiz_pessoa_id = excluded.raiz_pessoa_id,
  categoria = excluded.categoria,
  pais = excluded.pais,
  periodo = excluded.periodo,
  is_publico = 1;

-- =====================================================================
-- 3. UNIÕES FAMILIARES (unioes)
-- =====================================================================
INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
-- Mozart
('pub_u_mozart_pais', 'pub_mozart_leopold', 'pub_mozart_anna_maria', 'casamento', 'Casamento em Salzburgo em 1747.'),
('pub_u_mozart_wolfgang_constanze', 'pub_mozart_wolfgang', 'pub_mozart_constanze', 'casamento', 'Casamento na Catedral de Santo Estêvão em Viena em 1782.'),

-- Beethoven
('pub_u_beethoven_pais', 'pub_beethoven_johann', 'pub_beethoven_maria_magdalena', 'casamento', 'Casamento na Igreja de São Remígio em Bonn em 1767.'),
('pub_u_beethoven_kaspar_johanna', 'pub_beethoven_kaspar', 'pub_beethoven_johanna', 'casamento', 'Casamento em Viena em 1806.'),

-- Shakespeare
('pub_u_shakespeare_pais', 'pub_shakespeare_john', 'pub_shakespeare_mary_arden', 'casamento', 'Casamento em Wilmcote c. 1557.'),
('pub_u_shakespeare_william_anne', 'pub_shakespeare_william', 'pub_shakespeare_anne_hathaway', 'casamento', 'Casamento em Temple Grafton em novembro de 1582.'),

-- Dante
('pub_u_dante_pais', 'pub_dante_alighiero', 'pub_dante_bella', 'casamento', 'Casamento em Florença c. 1260.'),
('pub_u_dante_gemma', 'pub_dante_alighieri', 'pub_dante_gemma_donati', 'casamento', 'Compromisso formal acordado em 1277 e casamento em Florença c. 1285.'),

-- Cervantes
('pub_u_cervantes_pais', 'pub_cervantes_rodrigo', 'pub_cervantes_leonor', 'casamento', 'Casamento em Alcalá de Henares c. 1542.'),
('pub_u_cervantes_miguel_catalina', 'pub_cervantes_miguel', 'pub_cervantes_catalina', 'casamento', 'Casamento na paróquia de Esquivias (Toledo) em 12 de dezembro de 1584.'),
('pub_u_cervantes_miguel_isabel', 'pub_cervantes_miguel', 'pub_cervantes_ana_franca', 'estavel', 'Relação em Madrid com Ana Franca de Rojas da qual nasceu Isabel de Saavedra.'),

-- Goethe
('pub_u_goethe_pais', 'pub_goethe_johann_caspar', 'pub_goethe_catharina', 'casamento', 'Casamento na Igreja de Santa Catarina em Frankfurt em 1748.'),
('pub_u_goethe_wolfgang_christiane', 'pub_goethe_johann_wolfgang', 'pub_goethe_christiane', 'casamento', 'União em Weimar desde 1788 e matrimônio oficializado na Jakobskirche em 1806.'),
('pub_u_goethe_august_ottilie', 'pub_goethe_august', 'pub_goethe_ottilie', 'casamento', 'Casamento em Weimar em 1817.'),

-- Victor Hugo
('pub_u_hugo_pais', 'pub_hugo_joseph_leopold', 'pub_hugo_sophie', 'casamento', 'Casamento em Paris em 1797.'),
('pub_u_hugo_victor_adele', 'pub_hugo_victor', 'pub_hugo_adele_foucher', 'casamento', 'Casamento na Igreja de Saint-Sulpice em Paris em 12 de outubro de 1822.')
ON CONFLICT(id) DO UPDATE SET
  slot_masculino_id = excluded.slot_masculino_id,
  slot_feminino_id = excluded.slot_feminino_id,
  estado_vinculo = excluded.estado_vinculo,
  nota = excluded.nota;

-- =====================================================================
-- 4. FILHOS DAS UNIÕES (uniao_filhos)
-- =====================================================================
INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
-- Mozart
('pub_u_mozart_pais', 'pub_mozart_nannerl', 'biologico', 1),
('pub_u_mozart_pais', 'pub_mozart_wolfgang', 'biologico', 2),
('pub_u_mozart_wolfgang_constanze', 'pub_mozart_karl', 'biologico', 1),
('pub_u_mozart_wolfgang_constanze', 'pub_mozart_franz_xaver', 'biologico', 2),

-- Beethoven
('pub_u_beethoven_pais', 'pub_beethoven_ludwig', 'biologico', 1),
('pub_u_beethoven_pais', 'pub_beethoven_kaspar', 'biologico', 2),
('pub_u_beethoven_pais', 'pub_beethoven_nikolaus', 'biologico', 3),
('pub_u_beethoven_kaspar_johanna', 'pub_beethoven_karl', 'biologico', 1),

-- Shakespeare
('pub_u_shakespeare_pais', 'pub_shakespeare_william', 'biologico', 1),
('pub_u_shakespeare_pais', 'pub_shakespeare_joan', 'biologico', 2),
('pub_u_shakespeare_william_anne', 'pub_shakespeare_susanna', 'biologico', 1),
('pub_u_shakespeare_william_anne', 'pub_shakespeare_judith', 'biologico', 2),

-- Dante
('pub_u_dante_pais', 'pub_dante_alighieri', 'biologico', 1),
('pub_u_dante_gemma', 'pub_dante_pietro', 'biologico', 1),
('pub_u_dante_gemma', 'pub_dante_jacopo', 'biologico', 2),

-- Cervantes
('pub_u_cervantes_pais', 'pub_cervantes_andrea', 'biologico', 1),
('pub_u_cervantes_pais', 'pub_cervantes_miguel', 'biologico', 2),
('pub_u_cervantes_pais', 'pub_cervantes_rodrigo_jr', 'biologico', 3),
('pub_u_cervantes_miguel_isabel', 'pub_cervantes_isabel', 'biologico', 1),

-- Goethe
('pub_u_goethe_pais', 'pub_goethe_johann_wolfgang', 'biologico', 1),
('pub_u_goethe_pais', 'pub_goethe_cornelia', 'biologico', 2),
('pub_u_goethe_wolfgang_christiane', 'pub_goethe_august', 'biologico', 1),

-- Victor Hugo
('pub_u_hugo_pais', 'pub_hugo_abel', 'biologico', 1),
('pub_u_hugo_pais', 'pub_hugo_victor', 'biologico', 2),
('pub_u_hugo_victor_adele', 'pub_hugo_leopoldine', 'biologico', 1),
('pub_u_hugo_victor_adele', 'pub_hugo_charles', 'biologico', 2),
('pub_u_hugo_victor_adele', 'pub_hugo_francois_victor', 'biologico', 3)
ON CONFLICT(uniao_id, pessoa_id) DO UPDATE SET
  ordem = excluded.ordem,
  tipo_vinculo = excluded.tipo_vinculo;

-- =====================================================================
-- 5. MEMBROS DAS ÁRVORES (arvore_membros)
-- =====================================================================
-- Mozart
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_mozart', 'pub_mozart_leopold', NULL),
('pub_arv_mozart', 'pub_mozart_anna_maria', NULL),
('pub_arv_mozart', 'pub_mozart_nannerl', NULL),
('pub_arv_mozart', 'pub_mozart_wolfgang', NULL),
('pub_arv_mozart', 'pub_mozart_constanze', NULL),
('pub_arv_mozart', 'pub_mozart_karl', NULL),
('pub_arv_mozart', 'pub_mozart_franz_xaver', NULL),

-- Beethoven
('pub_arv_beethoven', 'pub_beethoven_johann', NULL),
('pub_arv_beethoven', 'pub_beethoven_maria_magdalena', NULL),
('pub_arv_beethoven', 'pub_beethoven_ludwig', NULL),
('pub_arv_beethoven', 'pub_beethoven_kaspar', NULL),
('pub_arv_beethoven', 'pub_beethoven_nikolaus', NULL),
('pub_arv_beethoven', 'pub_beethoven_johanna', NULL),
('pub_arv_beethoven', 'pub_beethoven_karl', NULL),

-- Shakespeare
('pub_arv_shakespeare', 'pub_shakespeare_john', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_mary_arden', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_william', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_anne_hathaway', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_joan', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_susanna', NULL),
('pub_arv_shakespeare', 'pub_shakespeare_judith', NULL),

-- Dante
('pub_arv_dante', 'pub_dante_alighiero', NULL),
('pub_arv_dante', 'pub_dante_bella', NULL),
('pub_arv_dante', 'pub_dante_alighieri', NULL),
('pub_arv_dante', 'pub_dante_gemma_donati', NULL),
('pub_arv_dante', 'pub_dante_pietro', NULL),
('pub_arv_dante', 'pub_dante_jacopo', NULL),
('pub_arv_dante', 'pub_dante_beatrice_portinari', NULL),

-- Cervantes
('pub_arv_cervantes', 'pub_cervantes_rodrigo', NULL),
('pub_arv_cervantes', 'pub_cervantes_leonor', NULL),
('pub_arv_cervantes', 'pub_cervantes_miguel', NULL),
('pub_arv_cervantes', 'pub_cervantes_andrea', NULL),
('pub_arv_cervantes', 'pub_cervantes_rodrigo_jr', NULL),
('pub_arv_cervantes', 'pub_cervantes_catalina', NULL),
('pub_arv_cervantes', 'pub_cervantes_ana_franca', NULL),
('pub_arv_cervantes', 'pub_cervantes_isabel', NULL),

-- Goethe
('pub_arv_goethe', 'pub_goethe_johann_caspar', NULL),
('pub_arv_goethe', 'pub_goethe_catharina', NULL),
('pub_arv_goethe', 'pub_goethe_johann_wolfgang', NULL),
('pub_arv_goethe', 'pub_goethe_cornelia', NULL),
('pub_arv_goethe', 'pub_goethe_christiane', NULL),
('pub_arv_goethe', 'pub_goethe_august', NULL),
('pub_arv_goethe', 'pub_goethe_ottilie', NULL),

-- Victor Hugo
('pub_arv_victor_hugo', 'pub_hugo_joseph_leopold', NULL),
('pub_arv_victor_hugo', 'pub_hugo_sophie', NULL),
('pub_arv_victor_hugo', 'pub_hugo_victor', NULL),
('pub_arv_victor_hugo', 'pub_hugo_adele_foucher', NULL),
('pub_arv_victor_hugo', 'pub_hugo_abel', NULL),
('pub_arv_victor_hugo', 'pub_hugo_leopoldine', NULL),
('pub_arv_victor_hugo', 'pub_hugo_charles', NULL),
('pub_arv_victor_hugo', 'pub_hugo_francois_victor', NULL);

-- =====================================================================
-- 6. EVENTOS VITAIS GEORREFERENCIADOS (eventos)
-- =====================================================================
INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto, local_id) VALUES
-- Mozart
('ev_038_moz_leop_nasc', 'pub_mozart_leopold', 'nascimento', 1719, 1719, 'exata', '14 de novembro de 1719', 'loc-de-augsburg'),
('ev_038_moz_leop_mort', 'pub_mozart_leopold', 'falecimento', 1787, 1787, 'exata', '28 de maio de 1787', 'loc-at-salzburg'),
('ev_038_moz_anna_nasc', 'pub_mozart_anna_maria', 'nascimento', 1720, 1720, 'exata', '25 de dezembro de 1720', 'loc-at-st-gilgen'),
('ev_038_moz_anna_mort', 'pub_mozart_anna_maria', 'falecimento', 1778, 1778, 'exata', '3 de julho de 1778', 'loc-fr-paris'),
('ev_038_moz_wolf_nasc', 'pub_mozart_wolfgang', 'nascimento', 1756, 1756, 'exata', '27 de janeiro de 1756', 'loc-at-salzburg'),
('ev_038_moz_wolf_mort', 'pub_mozart_wolfgang', 'falecimento', 1791, 1791, 'exata', '5 de dezembro de 1791', 'loc-at-wien'),
('ev_038_moz_const_mort', 'pub_mozart_constanze', 'falecimento', 1842, 1842, 'exata', '6 de março de 1842', 'loc-at-salzburg'),
('ev_038_moz_nann_mort', 'pub_mozart_nannerl', 'falecimento', 1829, 1829, 'exata', '29 de outubro de 1829', 'loc-at-salzburg'),
('ev_038_moz_karl_mort', 'pub_mozart_karl', 'falecimento', 1858, 1858, 'exata', '31 de outubro de 1858', 'loc-it-milano'),
('ev_038_moz_fx_mort', 'pub_mozart_franz_xaver', 'falecimento', 1844, 1844, 'exata', '29 de julho de 1844', 'loc-at-wien'),

-- Beethoven
('ev_038_beet_joh_nasc', 'pub_beethoven_johann', 'nascimento', 1740, 1740, 'exata', '14 de novembro de 1740', 'loc-de-bonn'),
('ev_038_beet_joh_mort', 'pub_beethoven_johann', 'falecimento', 1792, 1792, 'exata', '18 de dezembro de 1792', 'loc-de-bonn'),
('ev_038_beet_lud_nasc', 'pub_beethoven_ludwig', 'nascimento', 1770, 1770, 'exata', '17 de dezembro de 1770 (batismo)', 'loc-de-bonn'),
('ev_038_beet_lud_mort', 'pub_beethoven_ludwig', 'falecimento', 1827, 1827, 'exata', '26 de março de 1827', 'loc-at-wien'),
('ev_038_beet_kasp_mort', 'pub_beethoven_kaspar', 'falecimento', 1815, 1815, 'exata', '15 de novembro de 1815', 'loc-at-wien'),
('ev_038_beet_nik_mort', 'pub_beethoven_nikolaus', 'falecimento', 1848, 1848, 'exata', '12 de janeiro de 1848', 'loc-at-wien'),
('ev_038_beet_karl_mort', 'pub_beethoven_karl', 'falecimento', 1858, 1858, 'exata', '13 de abril de 1858', 'loc-at-wien'),

-- Shakespeare
('ev_038_shak_will_nasc', 'pub_shakespeare_william', 'nascimento', 1564, 1564, 'exata', '26 de abril de 1564 (batismo)', 'loc-gb-stratford'),
('ev_038_shak_will_mort', 'pub_shakespeare_william', 'falecimento', 1616, 1616, 'exata', '23 de abril de 1616', 'loc-gb-stratford'),
('ev_038_shak_anne_mort', 'pub_shakespeare_anne_hathaway', 'falecimento', 1623, 1623, 'exata', '6 de agosto de 1623', 'loc-gb-stratford'),
('ev_038_shak_sus_mort', 'pub_shakespeare_susanna', 'falecimento', 1649, 1649, 'exata', '11 de julho de 1649', 'loc-gb-stratford'),
('ev_038_shak_jud_mort', 'pub_shakespeare_judith', 'falecimento', 1662, 1662, 'exata', '9 de fevereiro de 1662', 'loc-gb-stratford'),

-- Dante
('ev_038_dant_dan_nasc', 'pub_dante_alighieri', 'nascimento', 1265, 1265, 'cerca_de', 'maio / junho de 1265', 'loc-it-firenze'),
('ev_038_dant_dan_mort', 'pub_dante_alighieri', 'falecimento', 1321, 1321, 'exata', '14 de setembro de 1321', 'loc-it-ravenna'),
('ev_038_dant_piet_mort', 'pub_dante_pietro', 'falecimento', 1364, 1364, 'exata', '21 de abril de 1364', 'loc-it-verona'),
('ev_038_dant_beat_nasc', 'pub_dante_beatrice_portinari', 'nascimento', 1266, 1266, 'cerca_de', '1266', 'loc-it-firenze'),
('ev_038_dant_beat_mort', 'pub_dante_beatrice_portinari', 'falecimento', 1290, 1290, 'exata', '8 de junho de 1290', 'loc-it-firenze'),

-- Cervantes
('ev_038_cerv_mig_nasc', 'pub_cervantes_miguel', 'nascimento', 1547, 1547, 'exata', '29 de setembro de 1547 (batismo em 9 de outubro)', 'loc-es-alcala'),
('ev_038_cerv_mig_mort', 'pub_cervantes_miguel', 'falecimento', 1616, 1616, 'exata', '22 de abril de 1616', 'loc-es-madrid'),
('ev_038_cerv_cat_mort', 'pub_cervantes_catalina', 'falecimento', 1626, 1626, 'exata', '31 de outubro de 1626', 'loc-es-madrid'),
('ev_038_cerv_isab_mort', 'pub_cervantes_isabel', 'falecimento', 1652, 1652, 'exata', '1652', 'loc-es-madrid'),

-- Goethe
('ev_038_goet_wolf_nasc', 'pub_goethe_johann_wolfgang', 'nascimento', 1749, 1749, 'exata', '28 de agosto de 1749', 'loc-de-frankfurtammain'),
('ev_038_goet_wolf_mort', 'pub_goethe_johann_wolfgang', 'falecimento', 1832, 1832, 'exata', '22 de março de 1832', 'hist_de_weimar'),
('ev_038_goet_corn_nasc', 'pub_goethe_cornelia', 'nascimento', 1750, 1750, 'exata', '7 de dezembro de 1750', 'loc-de-frankfurtammain'),
('ev_038_goet_chris_mort', 'pub_goethe_christiane', 'falecimento', 1816, 1816, 'exata', '6 de junho de 1816', 'hist_de_weimar'),
('ev_038_goet_aug_mort', 'pub_goethe_august', 'falecimento', 1830, 1830, 'exata', '27 de outubro de 1830', 'loc-it-roma'),

-- Victor Hugo
('ev_038_hugo_vic_nasc', 'pub_hugo_victor', 'nascimento', 1802, 1802, 'exata', '26 de fevereiro de 1802', 'loc-fr-besancon'),
('ev_038_hugo_vic_mort', 'pub_hugo_victor', 'falecimento', 1885, 1885, 'exata', '22 de maio de 1885', 'loc-fr-paris'),
('ev_038_hugo_ade_mort', 'pub_hugo_adele_foucher', 'falecimento', 1868, 1868, 'exata', '27 de agosto de 1868', 'loc-fr-paris'),
('ev_038_hugo_leop_mort', 'pub_hugo_leopoldine', 'falecimento', 1843, 1843, 'exata', '4 de setembro de 1843', 'loc-fr-villequier'),
('ev_038_hugo_char_mort', 'pub_hugo_charles', 'falecimento', 1871, 1871, 'exata', '13 de março de 1871', 'loc-fr-paris'),
('ev_038_hugo_fv_mort', 'pub_hugo_francois_victor', 'falecimento', 1873, 1873, 'exata', '11 de outubro de 1873', 'loc-fr-paris')
ON CONFLICT(id) DO UPDATE SET
  ano_inicio = excluded.ano_inicio,
  ano_fim = excluded.ano_fim,
  data_texto = excluded.data_texto,
  local_id = excluded.local_id;

-- =====================================================================
-- 7. NACIONALIDADES (nacionalidades_pessoa)
-- =====================================================================
INSERT OR IGNORE INTO nacionalidades_pessoa (id, pessoa_id, pais_id) VALUES
('nac_038_moz_leop', 'pub_mozart_leopold', 'at'),
('nac_038_moz_wolf', 'pub_mozart_wolfgang', 'at'),
('nac_038_moz_const', 'pub_mozart_constanze', 'at'),
('nac_038_beet_lud', 'pub_beethoven_ludwig', 'de'),
('nac_038_beet_joh', 'pub_beethoven_johann', 'de'),
('nac_038_shak_will', 'pub_shakespeare_william', 'gb'),
('nac_038_shak_anne', 'pub_shakespeare_anne_hathaway', 'gb'),
('nac_038_dant_dan', 'pub_dante_alighieri', 'it'),
('nac_038_cerv_mig', 'pub_cervantes_miguel', 'es'),
('nac_038_cerv_cat', 'pub_cervantes_catalina', 'es'),
('nac_038_goet_wolf', 'pub_goethe_johann_wolfgang', 'de'),
('nac_038_goet_chris', 'pub_goethe_christiane', 'de'),
('nac_038_hugo_vic', 'pub_hugo_victor', 'fr'),
('nac_038_hugo_ade', 'pub_hugo_adele_foucher', 'fr');

-- =====================================================================
-- 8. IDIOMAS FALADOS (idiomas_pessoa)
-- =====================================================================
-- Mozart: Alemão, Italiano, Francês, Inglês, Latim
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
('idi_038_moz_de', 'pub_mozart_wolfgang', 'Alemão'),
('idi_038_moz_it', 'pub_mozart_wolfgang', 'Italiano'),
('idi_038_moz_fr', 'pub_mozart_wolfgang', 'Francês'),
('idi_038_moz_en', 'pub_mozart_wolfgang', 'Inglês'),
('idi_038_moz_la', 'pub_mozart_wolfgang', 'Latim'),
('idi_038_moz_leop_de', 'pub_mozart_leopold', 'Alemão'),
('idi_038_moz_leop_it', 'pub_mozart_leopold', 'Italiano'),
('idi_038_moz_leop_la', 'pub_mozart_leopold', 'Latim'),
('idi_038_moz_const_de', 'pub_mozart_constanze', 'Alemão'),
('idi_038_moz_const_fr', 'pub_mozart_constanze', 'Francês'),

-- Beethoven: Alemão, Francês, Italiano, Latim
('idi_038_beet_de', 'pub_beethoven_ludwig', 'Alemão'),
('idi_038_beet_fr', 'pub_beethoven_ludwig', 'Francês'),
('idi_038_beet_it', 'pub_beethoven_ludwig', 'Italiano'),
('idi_038_beet_la', 'pub_beethoven_ludwig', 'Latim'),

-- Shakespeare: Inglês, Latim, Francês
('idi_038_shak_en', 'pub_shakespeare_william', 'Inglês'),
('idi_038_shak_la', 'pub_shakespeare_william', 'Latim'),
('idi_038_shak_fr', 'pub_shakespeare_william', 'Francês'),

-- Dante: Italiano (Toscano), Latim, Provençal / Occitano
('idi_038_dant_it', 'pub_dante_alighieri', 'Italiano'),
('idi_038_dant_la', 'pub_dante_alighieri', 'Latim'),
('idi_038_dant_oc', 'pub_dante_alighieri', 'Provençal (Occitano)'),
('idi_038_dant_piet_la', 'pub_dante_pietro', 'Latim'),
('idi_038_dant_piet_it', 'pub_dante_pietro', 'Italiano'),

-- Cervantes: Espanhol, Italiano, Latim
('idi_038_cerv_es', 'pub_cervantes_miguel', 'Espanhol'),
('idi_038_cerv_it', 'pub_cervantes_miguel', 'Italiano'),
('idi_038_cerv_la', 'pub_cervantes_miguel', 'Latim'),

-- Goethe: Alemão, Francês, Italiano, Inglês, Latim, Grego Antigo, Hebraico Bíblico
('idi_038_goet_de', 'pub_goethe_johann_wolfgang', 'Alemão'),
('idi_038_goet_fr', 'pub_goethe_johann_wolfgang', 'Francês'),
('idi_038_goet_it', 'pub_goethe_johann_wolfgang', 'Italiano'),
('idi_038_goet_en', 'pub_goethe_johann_wolfgang', 'Inglês'),
('idi_038_goet_la', 'pub_goethe_johann_wolfgang', 'Latim'),
('idi_038_goet_gr', 'pub_goethe_johann_wolfgang', 'Grego Antigo'),
('idi_038_goet_he', 'pub_goethe_johann_wolfgang', 'Hebraico Bíblico'),
('idi_038_goet_jasp_de', 'pub_goethe_johann_caspar', 'Alemão'),
('idi_038_goet_jasp_it', 'pub_goethe_johann_caspar', 'Italiano'),

-- Victor Hugo: Francês, Espanhol, Latim, Inglês
('idi_038_hugo_fr', 'pub_hugo_victor', 'Francês'),
('idi_038_hugo_es', 'pub_hugo_victor', 'Espanhol'),
('idi_038_hugo_la', 'pub_hugo_victor', 'Latim'),
('idi_038_hugo_en', 'pub_hugo_victor', 'Inglês'),
('idi_038_hugo_fv_en', 'pub_hugo_francois_victor', 'Inglês'),
('idi_038_hugo_fv_fr', 'pub_hugo_francois_victor', 'Francês');

-- =====================================================================
-- 9. ESCOLARIDADE E FORMAÇÃO (escolaridade_pessoa)
-- =====================================================================
INSERT INTO escolaridade_pessoa (id, pessoa_id, nivel, instituicao, periodo) VALUES
('esc_038_moz_leop_univ', 'pub_mozart_leopold', 'Estudos de Filosofia e Direito', 'Universidade Beneditina de Salzburgo', '1737–1739'),
('esc_038_moz_wolf_tut', 'pub_mozart_wolfgang', 'Educação Musical e Humanística Integral', 'Tutela pedagógica de Leopold Mozart e grandes mestres europeus (Padre Martini em Bolonha)', '1760–1773'),
('esc_038_beet_neefe', 'pub_beethoven_ludwig', 'Formação Musical e Teoria de Composição', 'Orientação do organista Christian Gottlob Neefe e estudos com Joseph Haydn em Viena', '1780–1794'),
('esc_038_shak_grammar', 'pub_shakespeare_william', 'Grammar School (Letras Clássicas e Retórica Latina)', 'King Edward VI School em Stratford-upon-Avon', '1571–1578'),
('esc_038_dant_studia', 'pub_dante_alighieri', 'Estudos Superiores de Filosofia, Teologia e Retórica', 'Studia dos Franciscanos (Santa Croce) e Dominicanos (Santa Maria Novella) em Florença e Universidade de Bolonha', '1280–1290'),
('esc_038_cerv_human', 'pub_cervantes_miguel', 'Estudos de Gramática e Humanidades', 'Estúdio de Juan López de Hoyos em Madrid e Academia de Roma', '1566–1570'),
('esc_038_goet_leipzig', 'pub_goethe_johann_wolfgang', 'Estudos Superiores de Direito', 'Universidade de Leipzig', '1765–1768'),
('esc_038_goet_strasbourg', 'pub_goethe_johann_wolfgang', 'Licenciatura em Direito (Licentiatus Juris)', 'Universidade de Estrasburgo', '1770–1771'),
('esc_038_hugo_louis', 'pub_hugo_victor', 'Estudos de Letras, Matemática e Humanidades', 'Lycée Louis-le-Grand em Paris', '1815–1818')
ON CONFLICT(id) DO UPDATE SET
  nivel = excluded.nivel,
  instituicao = excluded.instituicao,
  periodo = excluded.periodo;

-- =====================================================================
-- 10. PROFISSÕES E CARGOS (profissoes_pessoa)
-- =====================================================================
INSERT INTO profissoes_pessoa (id, pessoa_id, ocupacao, empregador_local, periodo) VALUES
('prof_038_moz_leop_kapell', 'pub_mozart_leopold', 'Vice-Mestre de Capela e Músico de Corte', 'Corte dos Príncipes-Arcebispos de Salzburgo', '1743–1787'),
('prof_038_moz_wolf_comp', 'pub_mozart_wolfgang', 'Compositor Imperial e Real de Câmara', 'Corte Imperial dos Habsburgos em Viena (Imperador José II)', '1787–1791'),
('prof_038_moz_wolf_virt', 'pub_mozart_wolfgang', 'Compositor e Pianista Virtuoso Independente', 'Teatros e salões de Viena, Praga, Salzburgo e Paris', '1781–1791'),
('prof_038_beet_comp', 'pub_beethoven_ludwig', 'Compositor de Música Sinfônica e de Câmara', 'Meio musical e mecenato aristocrático de Viena (Príncipe Lobkowitz, Arquiduque Rodolfo)', '1792–1827'),
('prof_038_beet_joh_tenor', 'pub_beethoven_johann', 'Tenor e Músico de Capela', 'Corte do Príncipe-Eleitor de Colônia em Bonn', '1764–1789'),
('prof_038_shak_dram', 'pub_shakespeare_william', 'Dramaturgo Residente e Poeta', 'Lord Chamberlain’s Men / King’s Men no Globe Theatre', '1592–1613'),
('prof_038_shak_ator', 'pub_shakespeare_william', 'Ator e Coproprietário de Companhia Teatral', 'Globe Theatre e Blackfriars Theatre em Londres', '1594–1613'),
('prof_038_shak_john_bailiff', 'pub_shakespeare_john', 'Alto Bailio (Prefeito) e Juiz de Paz', 'Concelho Municipal de Stratford-upon-Avon', '1568–1571'),
('prof_038_dant_prior', 'pub_dante_alighieri', 'Prior de Florença (Magistrado Supremo da República)', 'Signoria da República de Florença', '1300'),
('prof_038_dant_poeta', 'pub_dante_alighieri', 'Poeta, Ensaísta e Teórico Político', 'Cortes da Itália (Florença, Verona dos Scaligeri, Ravena dos Polenta)', '1290–1321'),
('prof_038_cerv_sold', 'pub_cervantes_miguel', 'Soldado da Infantaria de Marinha Espanhola (Terço de Miguel de Moncada)', 'Armada da Liga Santa na Batalha de Lepanto e Tunísia', '1570–1575'),
('prof_038_cerv_escritor', 'pub_cervantes_miguel', 'Romancista, Dramaturgo e Poeta', 'Cortes de Madrid, Valladolid e Esquivias', '1585–1616'),
('prof_038_cerv_comiss', 'pub_cervantes_miguel', 'Comissário Real de Abastecimentos da Invencível Armada', 'Coroa de Espanha (Sevilha e Andaluzia)', '1587–1594'),
('prof_038_goet_ministro', 'pub_goethe_johann_wolfgang', 'Conselheiro Privado Secreto e Ministro de Estado', 'Ducado de Saxe-Weimar-Eisenach', '1776–1815'),
('prof_038_goet_teatro', 'pub_goethe_johann_wolfgang', 'Diretor do Teatro da Corte de Weimar', 'Hoftheater de Weimar', '1791–1817'),
('prof_038_hugo_par', 'pub_hugo_victor', 'Par da França e Senador da República', 'Câmara dos Pares e Senado da França', '1845–1885'),
('prof_038_hugo_acad', 'pub_hugo_victor', 'Membro Imortal da Academia Francesa (Cadeira 14)', 'Académie Française', '1841–1885'),
('prof_038_hugo_fv_trad', 'pub_hugo_francois_victor', 'Tradutor e Ensaísta Literário', 'Imprensa e editoras de Paris e Guernsey', '1853–1873')
ON CONFLICT(id) DO UPDATE SET
  ocupacao = excluded.ocupacao,
  empregador_local = excluded.empregador_local,
  periodo = excluded.periodo;

-- =====================================================================
-- 11. OBRAS CULTURAIS E PUBLICAÇÕES (obras_culturais)
-- =====================================================================
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id) VALUES
-- Mozart
('obra_038_moz_requiem', 'pub_mozart_wolfgang', 'musica', 'Requiem em Ré menor (K. 626)', 'Música Sacra', 1791, NULL, 'Missa de réquiem transcendental de Mozart, concluída por Franz Xaver Süssmayr após sua morte.', 'loc-at-wien'),
('obra_038_moz_flauta', 'pub_mozart_wolfgang', 'musica', 'A Flauta Mágica (Die Zauberflöte, K. 620)', 'Ópera (Singspiel)', 1791, NULL, 'Ópera mágica alegórica em dois atos com libreto de Emanuel Schikaneder, estreada no Theater auf der Wieden.', 'loc-at-wien'),
('obra_038_moz_don_giovanni', 'pub_mozart_wolfgang', 'musica', 'Don Giovanni (Il dissoluto punito, ossia il Don Giovanni, K. 527)', 'Ópera (Dramma giocoso)', 1787, NULL, 'Obra-prima operística sobre o mito de Dom Juan, com libreto de Lorenzo Da Ponte estreada no Teatro dos Estados de Praga.', 'loc-at-wien'),
('obra_038_moz_figaro', 'pub_mozart_wolfgang', 'musica', 'As Bodas de Fígaro (Le nozze di Figaro, K. 492)', 'Ópera buffa', 1786, NULL, 'Comédia lírica revolucionária baseada na peça de Beaumarchais, com libreto de Lorenzo Da Ponte.', 'loc-at-wien'),
('obra_038_moz_sinfonia40', 'pub_mozart_wolfgang', 'musica', 'Sinfonia nº 40 em Sol menor (K. 550)', 'Sinfonia Clássica', 1788, NULL, 'Uma das sinfonias mais célebres, emotivas e trágicas da era clássica ocidental.', 'loc-at-wien'),
('obra_038_moz_pequena_musica', 'pub_mozart_wolfgang', 'musica', 'Eine kleine Nachtmusik (Serenata nº 13 para Cordas em Sol maior, K. 525)', 'Música de Câmara', 1787, NULL, 'Serenata orquestral universalmente reconhecida pela vivacidade e perfeição melódica.', 'loc-at-wien'),

-- Beethoven
('obra_038_beet_nona', 'pub_beethoven_ludwig', 'musica', 'Sinfonia nº 9 em Ré menor "Coral" (Op. 125)', 'Sinfonia Coral', 1824, NULL, 'Monumento da música ocidental introduzindo solistas e coro no final com o texto da Ode à Alegria de Schiller.', 'loc-at-wien'),
('obra_038_beet_quinta', 'pub_beethoven_ludwig', 'musica', 'Sinfonia nº 5 em Dó menor (Op. 67)', 'Sinfonia Clássica/Romântica', 1808, NULL, 'Sinfonia heroica cujo motivo rítmico de abertura de quatro notas simboliza o destino batendo à porta.', 'loc-at-wien'),
('obra_038_beet_ao_luar', 'pub_beethoven_ludwig', 'musica', 'Sonata para Piano nº 14 "Quasi una fantasia" (Ao Luar, Op. 27 nº 2)', 'Sonata para Piano', 1801, NULL, 'Célebre sonata em Dó sustenido menor dedicada à Condessa Giulietta Guicciardi.', 'loc-at-wien'),
('obra_038_beet_fur_elise', 'pub_beethoven_ludwig', 'musica', 'Für Elise (Bagatela em Lá menor, WoO 59)', 'Bagatela para Piano', 1810, NULL, 'A peça pianística mais popular e reverenciada do repertório de Beethoven.', 'loc-at-wien'),
('obra_038_beet_imperador', 'pub_beethoven_ludwig', 'musica', 'Concerto para Piano nº 5 em Mi bemol maior "Imperador" (Op. 73)', 'Concerto para Piano e Orquestra', 1809, NULL, 'O ápice dos concertos para piano de Beethoven, marcado pela grandeza sinfônica e virtuosismo nobre.', 'loc-at-wien'),
('obra_038_beet_missa', 'pub_beethoven_ludwig', 'musica', 'Missa Solemnis em Ré maior (Op. 123)', 'Música Sacra Coral', 1823, NULL, 'Composição sacra monumental dedicada ao Arquiduque Rodolfo da Áustria.', 'loc-at-wien'),

-- Shakespeare
('obra_038_shak_hamlet', 'pub_shakespeare_william', 'livro', 'Hamlet (A Tragédia de Hamlet, Príncipe da Dinamarca)', 'Tragédia Teatral', 1601, NULL, 'A tragédia máxima de William Shakespeare explorando a vingança, a loucura fingida e o dilema existencial do Ser ou Não Ser.', 'loc-gb-london'),
('obra_038_shak_romeu', 'pub_shakespeare_william', 'livro', 'Romeu e Julieta (The Tragedy of Romeo and Juliet)', 'Tragédia Romântica', 1595, NULL, 'Arquetípica tragédia do amor juvenil proibido entre os Montesquios e Capuletos em Verona.', 'loc-gb-london'),
('obra_038_shak_macbeth', 'pub_shakespeare_william', 'livro', 'Macbeth (A Tragédia de Macbeth)', 'Tragédia Teatral', 1606, NULL, 'Estudo teatral profundo sobre a ambição destrutiva, culpa e poder na corte escocesa.', 'loc-gb-london'),
('obra_038_shak_otelo', 'pub_shakespeare_william', 'livro', 'Otelo, o Mouro de Veneza (The Tragedy of Othello)', 'Tragédia Teatral', 1603, NULL, 'Dramaturgia genial sobre o ciúme patológico, manipulação de Iago e a pureza de Desdêmona.', 'loc-gb-london'),
('obra_038_shak_lear', 'pub_shakespeare_william', 'livro', 'O Rei Lear (The Tragedy of King Lear)', 'Tragédia Teatral', 1606, NULL, 'Tragédia épica da velhice, ingratidão filial e partilha do reino britânico.', 'loc-gb-london'),
('obra_038_shak_sonho', 'pub_shakespeare_william', 'livro', 'Sonho de uma Noite de Verão (A Midsummer Night’s Dream)', 'Comédia Fantástica', 1596, NULL, 'Comédia mágica envolvendo amantes atenienses, fadas e duendes nos bosques de Puck e Oberon.', 'loc-gb-london'),
('obra_038_shak_sonetos', 'pub_shakespeare_william', 'livro', 'Sonetos de Shakespeare (Shakespeare’s Sonnets)', 'Poesia Lírica', 1609, NULL, 'Coletânea de 154 sonetos que revolucionou a poesia renascentista com reflexões sobre o amor, tempo e mortalidade.', 'loc-gb-london'),

-- Dante
('obra_038_dant_comedia', 'pub_dante_alighieri', 'livro', 'A Divina Comédia (Inferno, Purgatório e Paraíso)', 'Poema Épico Teológico', 1308, 1321, 'A maior epopeia poética e teológica do Ocidente, em tercetos encadeados (terza rima), descrevendo a jornada de Dante pelo além guiado por Virgílio e Beatrice.', 'loc-it-ravenna'),
('obra_038_dant_vitanova', 'pub_dante_alighieri', 'livro', 'Vita Nova', 'Prosimetrum Lírico', 1294, NULL, 'Narrativa em prosa e verso celebrando o amor espiritual por Beatrice Portinari no apogeu do Dolce Stil Novo.', 'loc-it-firenze'),
('obra_038_dant_vulgari', 'pub_dante_alighieri', 'livro', 'De Vulgari Eloquentia', 'Tratado de Linguística e Poética', 1305, NULL, 'Tratado pioneiro em latim defendendo o uso e a nobreza da língua vulgar vernácula italiana sobre o latim na alta literatura.', 'loc-it-firenze'),
('obra_038_dant_monarchia', 'pub_dante_alighieri', 'livro', 'De Monarchia', 'Tratado Político e Filosófico', 1313, NULL, 'Tratado político em defesa de um Império universal secular separado do poder eclesiástico papal.', 'loc-it-verona'),

-- Cervantes
('obra_038_cerv_quixote', 'pub_cervantes_miguel', 'livro', 'El ingenioso hidalgo Don Quijote de la Mancha (Dom Quixote)', 'Romance Moderno', 1605, 1615, 'Obra fundadora do romance moderno ocidental, narrando as aventuras cômicas e comoventes do Cavaleiro da Triste Figura e seu escudeiro Sancho Pança.', 'loc-es-madrid'),
('obra_038_cerv_exemplares', 'pub_cervantes_miguel', 'livro', 'Novelas Exemplares (Novelas ejemplares de honestísimo entretenimiento)', 'Contos e Novelas', 1613, NULL, 'Conjunto de doze novelas curtas que estabeleceram o modelo do conto em prosa em castelhano.', 'loc-es-madrid'),
('obra_038_cerv_galatea', 'pub_cervantes_miguel', 'livro', 'A Galateia (La Galatea)', 'Novela Pastoril', 1585, NULL, 'Primeiro romance publicado por Miguel de Cervantes, obra de refinado lirismo pastoril renascentista.', 'loc-es-alcala'),
('obra_038_cerv_persiles', 'pub_cervantes_miguel', 'livro', 'Os Trabalhos de Persiles e Sigismunda (Los trabajos de Persiles y Sigismunda)', 'Romance Bizantino', 1617, NULL, 'Obra póstuma de Cervantes com prólogo escrito dias antes de falecer, ápice de sua imaginação épica cristã.', 'loc-es-madrid'),

-- Goethe
('obra_038_goet_fausto', 'pub_goethe_johann_wolfgang', 'livro', 'Fausto: Uma Tragédia (Faust: Der Tragödie erster und zweiter Teil)', 'Drama Trágico em Versos', 1808, 1832, 'Monumento da literatura alemã e mundial, narrando o pacto do Doutor Fausto com Mefistófeles em busca do conhecimento absoluto e do sentido da existência.', 'hist_de_weimar'),
('obra_038_goet_werther', 'pub_goethe_johann_wolfgang', 'livro', 'Os Sofrimentos do Jovem Werther (Die Leiden des jungen Werthers)', 'Romance Epistolar', 1774, NULL, 'Romance fundador do movimento Sturm und Drang e do Romantismo europeu que comoveu uma geração com a paixão ardente de Werther por Lotte.', 'loc-de-wetzlar'),
('obra_038_goet_italia', 'pub_goethe_johann_wolfgang', 'livro', 'Viagem à Itália (Italienische Reise)', 'Memórias de Viagem', 1816, NULL, 'Crônica imortal da viagem transformadora de Goethe pela Península Itálica, redescobrindo o classicismo greco-romano.', 'loc-it-roma'),
('obra_038_goet_cores', 'pub_goethe_johann_wolfgang', 'livro', 'Teoria das Cores (Zur Farbenlehre)', 'Tratado de Óptica e Percepção', 1810, NULL, 'Estudo pioneiro de física e psicologia sobre a percepção subjetiva das cores e dos contrastes luminescentes.', 'hist_de_weimar'),

-- Victor Hugo
('obra_038_hugo_miseraveis', 'pub_hugo_victor', 'livro', 'Os Miseráveis (Les Misérables)', 'Romance Social e Épico', 1862, NULL, 'Obra-prima monumental da literatura mundial retratando a redenção de Jean Valjean, o destino de Fantine e Cosette e a insurreição republicana de 1832 em Paris.', 'loc-gg-guernsey'),
('obra_038_hugo_notredame', 'pub_hugo_victor', 'livro', 'Nossa Senhora de Paris (Notre-Dame de Paris / O Corcunda de Notre-Dame)', 'Romance Histórico Gótico', 1831, NULL, 'Romance gótico imortal que eternizou a catedral parisiense, a cigana Esmeralda e a fidelidade de Quasimodo.', 'loc-fr-paris'),
('obra_038_hugo_trabalhadores', 'pub_hugo_victor', 'livro', 'Os Trabalhadores do Mar (Les Travailleurs de la Mer)', 'Romance Marítimo', 1866, NULL, 'Romance épico escrito durante o exílio de Guernsey, celebrando o combate do homem contra as forças selvagens do oceano.', 'loc-gg-guernsey'),
('obra_038_hugo_contemplacoes', 'pub_hugo_victor', 'livro', 'As Contemplações (Les Contemplations)', 'Poesia Lírica e Filosófica', 1856, NULL, 'Coletânea monumental de 158 poemas em seis livros que expressa a dor infinita pela morte de Léopoldine e a meditação sobre a eternidade.', 'loc-gg-guernsey')
ON CONFLICT(id) DO UPDATE SET
  titulo = excluded.titulo,
  detalhes = excluded.detalhes,
  ano = excluded.ano,
  ano_fim = excluded.ano_fim,
  subtipo = excluded.subtipo,
  local_id = excluded.local_id;
