-- pais_fundadores_estadistas.sql
-- Semente canônica do Lote 8: Pais Fundadores & Estadistas das Américas.
-- Contempla 5 árvores canônicas de fundação do Estado e soberania nacional:
-- 1. Família de George Washington (pub_arv_washington)
-- 2. Família de Thomas Jefferson (pub_arv_jefferson)
-- 3. Família de Benjamin Franklin (pub_arv_franklin)
-- 4. Família de Abraham Lincoln (pub_arv_lincoln)
-- 5. Protagonistas da Independência de 1822 (pub_arv_independencia_1822)
-- Cadastro de obras capitais de pensamento político/estado e idiomas falados.

-- =====================================================================
-- 1. OBRAS CAPITAIS DE ESTADO E PENSAMENTO POLÍTICO (obras_culturais)
-- =====================================================================

-- George Washington
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_042_was_rules', 'pub_washington_george', 'livro', 'Rules of Civility & Decent Behaviour in Company and Conversation', 'Tratado de Conduta Moral', 1744, NULL, 'Cópia manuscrita juvenil de 110 preceitos éticos e cívicos que moldaram a compostura clássica e integridade de Washington.', 'loc-us-westmoreland-va'),
    ('obra_042_was_general_orders', 'pub_washington_george', 'livro', 'General Orders to the Continental Army', 'Ordens Militares e Manifesto Republicano', 1776, NULL, 'Ordens gerais às tropas continentais proclamando que a causa da independência estava sob a proteção divina e a virtude dos homens livres.', 'loc-us-newyork'),
    ('obra_042_was_inaugural', 'pub_washington_george', 'livro', 'First Inaugural Address to the Congress of the United States', 'Discurso de Posse de Estado', 1789, NULL, 'Primeiro discurso de posse presidencial da história dos Estados Unidos, no Federal Hall de Nova York, consagrando o governo republicano.', 'loc-us-newyork')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;

-- Thomas Jefferson
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_042_jef_summary_view', 'pub_jefferson_thomas', 'livro', 'A Summary View of the Rights of British America', 'Tratado Jurídico e Filosófico', 1774, NULL, 'Ensaio seminal distribuído ao Primeiro Congresso Continental, estabelecendo a base teórica de que as colônias não estavam subordinadas ao Parlamento britânico.', 'loc-us-monticello-va'),
    ('obra_042_jef_notes_virginia', 'pub_jefferson_thomas', 'livro', 'Notes on the State of Virginia', 'Compêndio Científico e Político', 1785, NULL, 'Único livro completo de Jefferson, monumento do Iluminismo americano que abrange a geografia, recursos, sociedade e instituições da Virgínia.', 'loc-fr-paris'),
    ('obra_042_jef_statute_religion', 'pub_jefferson_thomas', 'livro', 'Virginia Statute for Religious Freedom', 'Legislação e Liberdade de Consciência', 1786, NULL, 'Uma das obras cimeiras de Jefferson, precursora da Primeira Emenda à Constituição americana garantindo separação Igreja-Estado e liberdade religiosa.', 'loc-us-monticello-va')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;

-- Benjamin Franklin
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_042_fra_poor_richard', 'pub_franklin_benjamin', 'livro', 'Poor Richard''s Almanack', 'Almanaque Popular e Sabedoria Moral', 1732, 1758, 'Publicação anual célebre contendo aforismos éticos, sabedoria financeira, provérbios e conselhos cívicos sob o pseudônimo Richard Saunders.', 'loc-us-filadelfia'),
    ('obra_042_fra_experiments_electricity', 'pub_franklin_benjamin', 'livro', 'Experiments and Observations on Electricity', 'Tratado Científico Experimental', 1751, NULL, 'Marco divisor da ciência moderna demonstrando a natureza elétrica dos relâmpagos, cunhando os conceitos de carga positiva/negativa e a invenção do para-raios.', 'loc-us-filadelfia'),
    ('obra_042_fra_treaty_paris', 'pub_franklin_benjamin', 'outro', 'Tratado de Paris de 1783 (Paz e Soberania dos Estados Unidos)', 'Tratado Internacional e Diplomacia', 1783, NULL, 'Tratado diplomático histórico que encerrou a Guerra Revolucionária Americana e consagrou o reconhecimento formal da independência dos Estados Unidos.', 'loc-fr-paris')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;

-- Abraham Lincoln
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_042_lin_house_divided', 'pub_lincoln_abraham', 'livro', 'Discurso da Casa Dividida (House Divided Speech)', 'Oratória Política e Filosofia Republicana', 1858, NULL, 'Histórico pronunciamento em Springfield proclamando: Uma casa dividida contra si mesma não pode subsistir; este governo não pode tolerar permanentemente metade livre e metade escrava.', 'loc-us-springfield-il'),
    ('obra_042_lin_second_inaugural', 'pub_lincoln_abraham', 'livro', 'Segundo Discurso de Posse (Second Inaugural Address)', 'Oratória de Estado e Reconciliação', 1865, NULL, 'Magistral peça literária e moral sobre as causas profundas da Guerra Civil e o apelo à união nacional: Sem malícia para com ninguém; com caridade para com todos.', 'loc-us-washingtondc')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;

-- Protagonistas de 1822
INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id)
VALUES
    ('obra_042_led_reverbero', 'pub_goncalves_ledo', 'livro', 'Revérbero Constitucional Fluminense', 'Periódico Político e Manifesto Patriótico', 1821, 1822, 'Jornal doutrinário fundacional da imprensa livre e da emancipação política brasileira, combatente das imposições recolonizadoras das Cortes de Lisboa.', 'ibge-3304557'),
    ('obra_042_can_tifis', 'pub_frei_caneca', 'livro', 'O Tífis Pernambucano', 'Jornal Político e Panfleto Revolucionário', 1823, 1824, 'Periódico de combate intransigente ao absolutismo monárquico, difusor dos ideais de federalismo e arauto da Confederação do Equador.', 'ibge-2611606'),
    ('obra_042_can_cartas_pitia', 'pub_frei_caneca', 'livro', 'Cartas de Pítia a Damão', 'Epistolografia e Filosofia Política', 1822, NULL, 'Cartas políticas e filosóficas defendendo os princípios da monarquia constitucional, soberania das províncias e crítica contundente ao despotismo.', 'ibge-2611606'),
    ('obra_042_bar_parnaso', 'pub_januario_barbosa', 'livro', 'O Parnaso Brasileiro', 'Antologia Poética e Literatura Nacional', 1829, 1832, 'Primeira antologia canônica da poesia e letras brasileiras, resgatando poetas nativistas do período colonial e consolidando a literatura autônoma.', 'ibge-3304557'),
    ('obra_042_and_const_mandioca', 'pub_antonio_carlos', 'livro', 'Projeto de Constituição da Mandioca de 1823', 'Direito Constitucional e Projeto de Estado', 1823, NULL, 'Primeiro anteprojeto de Constituição para o Império do Brasil redigido por Antônio Carlos na Assembleia Constituinte, limitando o poder absolutista.', 'ibge-3304557'),
    ('obra_042_and_relatorio_fazenda', 'pub_martim_francisco', 'livro', 'Relatório do Ministro e Secretário de Estado dos Negócios da Fazenda', 'Economia Pública e Finanças de Estado', 1823, NULL, 'Primeiro orçamento e plano financeiro sistemático do Brasil independente, organizando o tesouro público, alfândegas e receitas fiscais do novel Império.', 'ibge-3304557'),
    ('obra_042_qui_insignia_cruzeiro', 'pub_maria_quiteria', 'outro', 'Comenda da Imperial Ordem do Cruzeiro e Distinção Militar', 'Condecoração Militar por Heroísmo', 1823, NULL, 'Condecoração e patente militar outorgadas pelo Imperador D. Pedro I pelo heroísmo em combate nas batalhas de Pirajá e na Guerra da Independência na Bahia.', 'loc-br-piraja')
ON CONFLICT(id) DO UPDATE SET
    titulo = excluded.titulo,
    subtipo = excluded.subtipo,
    ano = excluded.ano,
    detalhes = excluded.detalhes,
    local_id = excluded.local_id;


-- =====================================================================
-- 2. IDIOMAS FALADOS (idiomas_pessoa)
-- =====================================================================

-- Washington Family
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_was_aug_en', 'pub_washington_augustine', 'Inglês'),
    ('idi_was_geo_en', 'pub_washington_george', 'Inglês'),
    ('idi_was_mar_en', 'pub_washington_martha', 'Inglês'),
    ('idi_was_law_en', 'pub_washington_lawrence', 'Inglês'),
    ('idi_was_mbl_en', 'pub_washington_mary_ball', 'Inglês'),
    ('idi_was_jck_en', 'pub_washington_jacky_custis', 'Inglês');

-- Jefferson Family
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_jef_tho_en', 'pub_jefferson_thomas', 'Inglês'),
    ('idi_jef_tho_fr', 'pub_jefferson_thomas', 'Francês'),
    ('idi_jef_tho_la', 'pub_jefferson_thomas', 'Latim'),
    ('idi_jef_tho_gr', 'pub_jefferson_thomas', 'Grego clássico'),
    ('idi_jef_tho_it', 'pub_jefferson_thomas', 'Italiano'),
    ('idi_jef_tho_es', 'pub_jefferson_thomas', 'Espanhol'),
    ('idi_jef_pet_en', 'pub_jefferson_peter', 'Inglês'),
    ('idi_jef_jan_en', 'pub_jefferson_jane_randolph', 'Inglês'),
    ('idi_jef_mwy_en', 'pub_jefferson_martha_wayles', 'Inglês'),
    ('idi_jef_pat_en', 'pub_jefferson_martha_patsy', 'Inglês'),
    ('idi_jef_pat_fr', 'pub_jefferson_martha_patsy', 'Francês'),
    ('idi_jef_mry_en', 'pub_jefferson_mary_maria', 'Inglês'),
    ('idi_jef_mry_fr', 'pub_jefferson_mary_maria', 'Francês');

-- Franklin Family
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_fra_ben_en', 'pub_franklin_benjamin', 'Inglês'),
    ('idi_fra_ben_fr', 'pub_franklin_benjamin', 'Francês'),
    ('idi_fra_ben_la', 'pub_franklin_benjamin', 'Latim'),
    ('idi_fra_ben_it', 'pub_franklin_benjamin', 'Italiano'),
    ('idi_fra_ben_es', 'pub_franklin_benjamin', 'Espanhol'),
    ('idi_fra_ben_de', 'pub_franklin_benjamin', 'Alemão'),
    ('idi_fra_jos_en', 'pub_franklin_josiah', 'Inglês'),
    ('idi_fra_abi_en', 'pub_franklin_abiah_folger', 'Inglês'),
    ('idi_fra_deb_en', 'pub_franklin_deborah_read', 'Inglês'),
    ('idi_fra_wil_en', 'pub_franklin_william', 'Inglês'),
    ('idi_fra_sal_en', 'pub_franklin_sarah_sally', 'Inglês'),
    ('idi_fra_sal_fr', 'pub_franklin_sarah_sally', 'Francês');

-- Lincoln Family
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_lin_abe_en', 'pub_lincoln_abraham', 'Inglês'),
    ('idi_lin_tho_en', 'pub_lincoln_thomas', 'Inglês'),
    ('idi_lin_nan_en', 'pub_lincoln_nancy_hanks', 'Inglês'),
    ('idi_lin_sbj_en', 'pub_lincoln_sarah_bush', 'Inglês'),
    ('idi_lin_mry_en', 'pub_lincoln_mary_todd', 'Inglês'),
    ('idi_lin_mry_fr', 'pub_lincoln_mary_todd', 'Francês'),
    ('idi_lin_rob_en', 'pub_lincoln_robert_todd', 'Inglês');

-- Protagonistas de 1822
INSERT OR IGNORE INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES
    ('idi_1822_p1_en', 'pub_pedro1', 'Inglês'),
    ('idi_1822_leo_en', 'pub_leopoldina', 'Inglês'),
    ('idi_1822_ant_fr', 'pub_antonio_carlos', 'Francês'),
    ('idi_1822_ant_la', 'pub_antonio_carlos', 'Latim'),
    ('idi_1822_mar_fr', 'pub_martim_francisco', 'Francês'),
    ('idi_1822_mar_la', 'pub_martim_francisco', 'Latim'),
    ('idi_1822_gab_fr', 'pub_gabriela_andrada', 'Francês'),
    ('idi_1822_nar_en', 'pub_ph_narcisa_oleary', 'Inglês'),
    ('idi_1822_can_la', 'pub_frei_caneca', 'Latim'),
    ('idi_1822_can_fr', 'pub_frei_caneca', 'Francês'),
    ('idi_1822_bar_la', 'pub_januario_barbosa', 'Latim'),
    ('idi_1822_bar_fr', 'pub_januario_barbosa', 'Francês'),
    ('idi_1822_jan_la', 'pub_joana_angelica', 'Latim');
