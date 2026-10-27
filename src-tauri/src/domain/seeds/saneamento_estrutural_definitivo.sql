-- ============================================================================
-- SANEAMENTO ESTRUTURAL DEFINITIVO DO ACERVO PÚBLICO
-- 1. Remove placeholders órfãos sem união
-- 2. Corrige os 4 ciclos de cônjuge-filho (Confúcio, Dinastias 21-23, Bach, Franco, Buendía)
-- 3. Conecta todas as pessoas solitárias às suas respectivas famílias
-- 4. Ajusta raiz_pessoa_id para o ancestral de topo de cada linhagem
-- ============================================================================

-- ----------------------------------------------------------------------------
-- A. CORREÇÃO DE CICLOS (CÔNJUGE COMPARTILHADO ENTRE GERAÇÕES)
-- ----------------------------------------------------------------------------

-- 1. Linhagem de Confúcio (pub_arv_kong_confucio)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_confucio_kong_ji_esposa', 'Esposa de Kong Ji', NULL, 'F', 'Consorte de Kong Ji (Zisi).', 0, 1, 1, 'Antiguidade e Dinastias Históricas', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_ph_confucio_kong_ji_esposa', NULL);

UPDATE unioes
SET slot_feminino_id = 'pub_ph_confucio_kong_ji_esposa'
WHERE id = 'pub_u_confucio_kong_ji_yansheng';

UPDATE arvores
SET raiz_pessoa_id = 'pub_kong_confucio_shuliang_he'
WHERE id = 'pub_arv_kong_confucio';

-- 2. Dinastias 21 a 23 do Egito (pub_arv_dinastias_21_23)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_dinastias_psusennes_esposa', 'Mutnedjmet', '(Rainha Consorte)', 'F', 'Grande Esposa Real do Faraó Psusennes I em Tânis.', 0, 1, 1, 'Antiguidade e Dinastias Históricas', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastias_21_23', 'pub_ph_dinastias_psusennes_esposa', NULL);

UPDATE unioes
SET slot_feminino_id = 'pub_ph_dinastias_psusennes_esposa'
WHERE id = 'pub_u_dinastias_psusennes_trans';

UPDATE arvores
SET raiz_pessoa_id = 'pub_dinastias_21_23_psusennes_i'
WHERE id = 'pub_arv_dinastias_21_23';

-- 3. Dinastia Musical Bach (pub_arv_bach)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_bach_veit_esposa', 'Esposa de Veit Bach', NULL, 'F', 'Matriarca da linhagem Bach na Turíngia.', 0, 1, 1, 'Ciência, Artes e Pensamento', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_bach_maria_elisabeth_lammerhirt', 'Maria Elisabeth', 'Lämmerhirt', 'F', 'Esposa de Johann Ambrosius Bach e mãe de Johann Sebastian Bach.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_maria_elisabeth', 'pub_bach_maria_elisabeth_lammerhirt', 'nascimento', 1644, 1644, 'exata', '24 de fevereiro de 1644');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_maria_elisabeth', 'pub_bach_maria_elisabeth_lammerhirt', 'falecimento', 1694, 1694, 'exata', '1º de maio de 1694');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_bach', 'pub_ph_bach_veit_esposa', NULL),
('pub_arv_bach', 'pub_bach_maria_elisabeth_lammerhirt', NULL);

UPDATE unioes
SET slot_feminino_id = 'pub_ph_bach_veit_esposa'
WHERE id = 'pub_u_pub_arv_bach_veit_bach';

UPDATE unioes
SET slot_feminino_id = 'pub_bach_maria_elisabeth_lammerhirt'
WHERE id = 'pub_u_pub_arv_bach_johann_ambrosius';

DELETE FROM arvore_membros WHERE pessoa_id IN ('pub_ph_pub_bach_johann_ambrosius_bach', 'pub_ph_pub_bach_maria_barbara_bach', 'pub_ph_pub_bach_anna_magdalena_bach');
DELETE FROM pessoas WHERE id IN ('pub_ph_pub_bach_johann_ambrosius_bach', 'pub_ph_pub_bach_maria_barbara_bach', 'pub_ph_pub_bach_anna_magdalena_bach');

UPDATE arvores
SET raiz_pessoa_id = 'pub_bach_veit_bach'
WHERE id = 'pub_arv_bach';

-- 4. Família de Francisco Franco (pub_arv_franco)
DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f';
DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f';
DELETE FROM unioes WHERE id = 'pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f';

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pub_arv_franco_pub_franco_cristobal_martinez_bordiu_pu', 'pub_franco_carmen_martinez_bordiu', 'biologico', 1),
('pub_u_pub_arv_franco_pub_franco_cristobal_martinez_bordiu_pu', 'pub_franco_francis_franco', 'biologico', 2);

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_franco_alfonso_borbon', 'Alfonso de Borbón', '(Duque de Cádiz)', 'M', 'Neto de Afonso XIII da Espanha; Duque de Anjou e de Cádiz, pai de Luis Alfonso de Borbón.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_alfonso_borbon', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_franco_carmen_alfonso', 'pub_franco_alfonso_borbon', 'pub_franco_carmen_martinez_bordiu', 'casamento', 'Casamento em 1972');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', NULL, 'pub_u_franco_carmen_alfonso');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_franco_carmen_alfonso', 'pub_franco_luis_alfonso_de_borbon', 'biologico', 1);

-- 5. Família Buendía (pub_arv_buendia) — elimina placeholder compartilhado e conecta Arcadio, Santa Sofía e os gêmeos
UPDATE unioes
SET slot_feminino_id = 'pub_buendia_pilar_ternera'
WHERE id = 'pub_u_pub_arv_buendia_jose_arcadio_filho';

UPDATE unioes
SET slot_masculino_id = 'pub_buendia_mauricio_babilonia'
WHERE id = 'pub_u_pub_arv_buendia_meme_mauricio';

DELETE FROM uniao_filhos WHERE pessoa_id IN ('pub_buendia_jose_arcadio_segundo', 'pub_buendia_aureliano_segundo');
DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia';
DELETE FROM unioes WHERE id = 'pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia';

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_buendia_arcadio_santa_sofia', 'pub_buendia_arcadio', 'pub_buendia_santa_sofia', 'estavel', 'Pais dos gêmeos José Arcadio Segundo e Aureliano Segundo');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_buendia_arcadio_santa_sofia');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_buendia_arcadio_santa_sofia', 'pub_buendia_jose_arcadio_segundo', 'biologico', 1),
('pub_u_buendia_arcadio_santa_sofia', 'pub_buendia_aureliano_segundo', 'biologico', 2);

DELETE FROM arvore_membros WHERE pessoa_id = 'pub_ph_pub_buendia_arcadio';
DELETE FROM pessoas WHERE id = 'pub_ph_pub_buendia_arcadio';

-- ----------------------------------------------------------------------------
-- B. CONEXÃO DE TODAS AS PESSOAS SOLITÁRIAS E UNIFICAÇÃO DE RAMOS
-- ----------------------------------------------------------------------------

-- 6. 18ª Dinastia do Egito (pub_arv_dinastia_18)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_dinastia_18_ahmose_nefertari', 'Ahmose-Nefertari', NULL, 'F', 'Grande Esposa Real de Amosis I; venerada como ancestral divina do Novo Império.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_ahmose_nefertari', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_dinastia_18_amosis_nefertari', 'pub_dinastia_18_amosis_i', 'pub_dinastia_18_ahmose_nefertari', 'casamento', 'Fundadores da 18ª Dinastia do Egito');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', NULL, 'pub_u_dinastia_18_amosis_nefertari');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_dinastia_18_amosis_nefertari', 'pub_dinastia_18_tutmes_iii', 'biologico', 1);

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_tutmes_iii_pub_ph_', 'pub_dinastia_18_amenofis_iii', 'biologico', 2);

UPDATE arvores
SET raiz_pessoa_id = 'pub_dinastia_18_amosis_i'
WHERE id = 'pub_arv_dinastia_18';

-- 7. 19ª Dinastia do Egito (pub_arv_dinastia_19)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_dinastia_19_ramesses_ii_nefertari', 'pub_dinastia_19_ramesses_ii', 'pub_dinastia_19_nefertari', 'casamento', 'Casamento real de Ramsés II e Nefertari');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', NULL, 'pub_u_dinastia_19_ramesses_ii_nefertari');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_dinastia_19_ramesses_ii_nefertari', 'pub_dinastia_19_merneptah', 'biologico', 1);

-- 8. Dinastia Bush (pub_arv_bush)
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_dorothy_bush_koch', 'biologico', 6);

UPDATE arvores
SET raiz_pessoa_id = 'pub_bush_samuel_p_bush'
WHERE id = 'pub_arv_bush';

-- 9. Família Alighieri (pub_arv_dante)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_dante_beatrice', 'pub_dante_alighieri', 'pub_dante_beatrice_portinari', 'estavel', 'Amor cortês e musa inspiradora na Vita Nuova e na Divina Comédia');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dante', NULL, 'pub_u_dante_beatrice');

-- 10. Família Curie / Joliot-Curie (pub_arv_curie)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_curie_eugene_curie', 'Eugène', 'Curie', 'M', 'Médico francês de convicções republicanas; pai e primeiro incentivador científico de Jacques e Pierre Curie.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real'),
('pub_curie_sophie_claire_depouilly', 'Sophie-Claire', 'Depouilly Curie', 'F', 'Filha de industriais franceses; mãe dos físicos Jacques e Pierre Curie.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_curie_eugene', 'pub_curie_eugene_curie', 'nascimento', 1827, 1827, 'exata', '28 de agosto de 1827'),
('ev_d_pub_curie_eugene', 'pub_curie_eugene_curie', 'falecimento', 1910, 1910, 'exata', '25 de fevereiro de 1910'),
('ev_b_pub_curie_sophie', 'pub_curie_sophie_claire_depouilly', 'nascimento', 1832, 1832, 'exata', '1832'),
('ev_d_pub_curie_sophie', 'pub_curie_sophie_claire_depouilly', 'falecimento', 1897, 1897, 'exata', '27 de setembro de 1897');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_curie', 'pub_curie_eugene_curie', NULL),
('pub_arv_curie', 'pub_curie_sophie_claire_depouilly', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_curie_eugene_sophie', 'pub_curie_eugene_curie', 'pub_curie_sophie_claire_depouilly', 'casamento', 'Pais de Jacques e Pierre Curie');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', NULL, 'pub_u_curie_eugene_sophie');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_curie_eugene_sophie', 'pub_curie_jacques_curie', 'biologico', 1),
('pub_u_curie_eugene_sophie', 'pub_curie_pierre_curie', 'biologico', 2);

UPDATE arvores
SET raiz_pessoa_id = 'pub_curie_eugene_curie'
WHERE id = 'pub_arv_curie';

-- 11. Família Karamazov (pub_arv_karamazov)
DELETE FROM uniao_filhos
WHERE uniao_id = 'pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k'
  AND pessoa_id IN ('pub_karamazov_ivan_karamazov', 'pub_karamazov_aliocha_karamazov');

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_karamazov_fiodor_sofia', 'pub_karamazov_fiodor_karamazov', 'pub_karamazov_sofia_ivanovna', 'casamento', '2º casamento de Fiódor Karamázov');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', NULL, 'pub_u_karamazov_fiodor_sofia');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_karamazov_fiodor_sofia', 'pub_karamazov_ivan_karamazov', 'biologico', 1),
('pub_u_karamazov_fiodor_sofia', 'pub_karamazov_aliocha_karamazov', 'biologico', 2);

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_karamazov_lizaveta_smerdiachtchaia', 'Lizaveta', 'Smerdiáchtchaia', 'F', 'Andarilha da cidade e mãe de Pável Smerdiákov no romance de Dostoiévski.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_lizaveta_smerdiachtchaia', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_karamazov_fiodor_lizaveta', 'pub_karamazov_fiodor_karamazov', 'pub_karamazov_lizaveta_smerdiachtchaia', 'estavel', 'Paternidade atribuída de Pável Smerdiákov');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', NULL, 'pub_u_karamazov_fiodor_lizaveta');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_karamazov_fiodor_lizaveta', 'pub_karamazov_pavel_smerdiakov', 'biologico', 1);

-- 12. Família Klabin-Lafer (pub_arv_klabin)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_klabin_leon_klabin', 'Leon', 'Klabin', 'M', 'Patriarca da família Klabin na Lituânia; pai de Maurício, Hessel, Nessel e Salomão Klabin.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_chaia_sarah_klabin', 'Chaia Sarah', 'Klabin', 'F', 'Matriarca da família Klabin na Lituânia.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_salomao_klabin', 'Salomão', 'Klabin', 'M', 'Irmão de Maurício Freeman Klabin e cofundador da Klabin Irmãos & Cia; pai de Wolff Klabin.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_ Fanny_slossberg', 'Fanny', 'Klabin', 'F', 'Esposa de Salomão Klabin e mãe de Wolff Klabin.', 0, 1, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_rose_klabin', 'Rose Haas', 'Klabin', 'F', 'Esposa de Wolff Klabin e mãe de Israel Klabin.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_abraao_jacob_lafer', 'Abraão Jacob', 'Lafer', 'M', 'Empresário; irmão de Horácio Lafer e pai do chanceler Celso Lafer.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_klabin_mary_lafer', 'Mary', 'Lafer', 'F', 'Esposa de Abraão Jacob Lafer e mãe de Celso Lafer.', 0, 1, 1, 'Grandes Empreendedores e Pioneiros', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_klabin', 'pub_klabin_leon_klabin', NULL),
('pub_arv_klabin', 'pub_klabin_chaia_sarah_klabin', NULL),
('pub_arv_klabin', 'pub_klabin_salomao_klabin', NULL),
('pub_arv_klabin', 'pub_klabin_ Fanny_slossberg', NULL),
('pub_arv_klabin', 'pub_klabin_rose_klabin', NULL),
('pub_arv_klabin', 'pub_klabin_abraao_jacob_lafer', NULL),
('pub_arv_klabin', 'pub_klabin_mary_lafer', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_klabin_leon_chaia', 'pub_klabin_leon_klabin', 'pub_klabin_chaia_sarah_klabin', 'casamento', 'Patriarcas da Família Klabin'),
('pub_u_klabin_salomao_fanny', 'pub_klabin_salomao_klabin', 'pub_klabin_ Fanny_slossberg', 'casamento', NULL),
('pub_u_klabin_wolff_rose', 'pub_klabin_wolff_klabin', 'pub_klabin_rose_klabin', 'casamento', NULL),
('pub_u_klabin_abraao_mary', 'pub_klabin_abraao_jacob_lafer', 'pub_klabin_mary_lafer', 'casamento', NULL);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_klabin', NULL, 'pub_u_klabin_leon_chaia'),
('pub_arv_klabin', NULL, 'pub_u_klabin_salomao_fanny'),
('pub_arv_klabin', NULL, 'pub_u_klabin_wolff_rose'),
('pub_arv_klabin', NULL, 'pub_u_klabin_abraao_mary');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_klabin_leon_chaia', 'pub_klabin_mauricio_freeman_klabin', 'biologico', 1),
('pub_u_klabin_leon_chaia', 'pub_klabin_hessel_klabin', 'biologico', 2),
('pub_u_klabin_leon_chaia', 'pub_klabin_nessel_klabin', 'biologico', 3),
('pub_u_klabin_leon_chaia', 'pub_klabin_salomao_klabin', 'biologico', 4),
('pub_u_klabin_salomao_fanny', 'pub_klabin_wolff_klabin', 'biologico', 1),
('pub_u_klabin_wolff_rose', 'pub_klabin_israel_klabin', 'biologico', 1),
('pub_u_pub_arv_klabin_pub_klabin_miguel_lafer_pub_klabin_ness', 'pub_klabin_abraao_jacob_lafer', 'biologico', 2),
('pub_u_klabin_abraao_mary', 'pub_klabin_celso_lafer', 'biologico', 1);

UPDATE arvores
SET raiz_pessoa_id = 'pub_klabin_leon_klabin'
WHERE id = 'pub_arv_klabin';

-- 13. Família Matarazzo (pub_arv_matarazzo)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_matarazzo_mariangela_jovane', 'Mariangela', 'Jovane Matarazzo', 'F', 'Esposa de Costabile Matarazzo e mãe do Conde Francesco Matarazzo e de Andrea Matarazzo.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_andrea_matarazzo', 'Andrea', 'Matarazzo', 'M', 'Industrial italiano radicado em São Paulo; irmão do Conde Francesco Matarazzo e pai de Ciccillo Matarazzo.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_amalia_matarazzo', 'Amália', 'Ferreira Matarazzo', 'F', 'Esposa de Andrea Matarazzo e mãe de Ciccillo Matarazzo.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_lydia_matarazzo', 'Lydia', 'Matarazzo Pignatari', 'F', 'Filha do Conde Francesco Matarazzo e mãe de Francisco "Baby" Pignatari.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_giulio_pignatari', 'Giulio', 'Pignatari', 'M', 'Médico e industrial italiano; marido de Lydia Matarazzo e pai de Baby Pignatari.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_filomena_suplicy', 'Filomena', 'Matarazzo Suplicy', 'F', 'Neta do Conde Francesco Matarazzo e mãe do senador Eduardo Matarazzo Suplicy.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_matarazzo_paulo_suplicy', 'Paulo Cochrane', 'Suplicy', 'M', 'Empresário cafeeiro; marido de Filomena Matarazzo Suplicy e pai de Eduardo Matarazzo Suplicy.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_matarazzo', 'pub_matarazzo_mariangela_jovane', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_andrea_matarazzo', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_amalia_matarazzo', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_lydia_matarazzo', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_giulio_pignatari', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_filomena_suplicy', NULL),
('pub_arv_matarazzo', 'pub_matarazzo_paulo_suplicy', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_matarazzo_costabile_mariangela', 'pub_matarazzo_costabile_matarazzo', 'pub_matarazzo_mariangela_jovane', 'casamento', 'Patriarcas em Castellabate'),
('pub_u_matarazzo_andrea_amalia', 'pub_matarazzo_andrea_matarazzo', 'pub_matarazzo_amalia_matarazzo', 'casamento', NULL),
('pub_u_matarazzo_giulio_lydia', 'pub_matarazzo_giulio_pignatari', 'pub_matarazzo_lydia_matarazzo', 'casamento', NULL),
('pub_u_matarazzo_paulo_filomena', 'pub_matarazzo_paulo_suplicy', 'pub_matarazzo_filomena_suplicy', 'casamento', NULL);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_matarazzo', NULL, 'pub_u_matarazzo_costabile_mariangela'),
('pub_arv_matarazzo', NULL, 'pub_u_matarazzo_andrea_amalia'),
('pub_arv_matarazzo', NULL, 'pub_u_matarazzo_giulio_lydia'),
('pub_arv_matarazzo', NULL, 'pub_u_matarazzo_paulo_filomena');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_matarazzo_costabile_mariangela', 'pub_matarazzo_francesco_matarazzo', 'biologico', 1),
('pub_u_matarazzo_costabile_mariangela', 'pub_matarazzo_andrea_matarazzo', 'biologico', 2),
('pub_u_matarazzo_andrea_amalia', 'pub_matarazzo_ciccillo_matarazzo', 'biologico', 1),
('pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu', 'pub_matarazzo_ermelino_matarazzo', 'biologico', 1),
('pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu', 'pub_matarazzo_francisco_matarazzo_junior', 'biologico', 2),
('pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu', 'pub_matarazzo_lydia_matarazzo', 'biologico', 3),
('pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu', 'pub_matarazzo_filomena_suplicy', 'biologico', 4),
('pub_u_matarazzo_giulio_lydia', 'pub_matarazzo_francisco_matarazzo_pignatari', 'biologico', 1),
('pub_u_matarazzo_paulo_filomena', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'biologico', 1);

UPDATE arvores
SET raiz_pessoa_id = 'pub_matarazzo_costabile_matarazzo'
WHERE id = 'pub_arv_matarazzo';

-- 14. Família Mussolini (pub_arv_mussolini)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mussolini_rosa_maltoni', 'Rosa', 'Maltoni Mussolini', 'F', 'Professora primária italiana; esposa de Alessandro Mussolini e mãe de Benito Mussolini.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_mussolini_rosa', 'pub_mussolini_rosa_maltoni', 'nascimento', 1858, 1858, 'exata', '22 de abril de 1858'),
('ev_d_pub_mussolini_rosa', 'pub_mussolini_rosa_maltoni', 'falecimento', 1905, 1905, 'exata', '19 de fevereiro de 1905');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_rosa_maltoni', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mussolini_alessandro_rosa', 'pub_mussolini_alessandro_mussolini', 'pub_mussolini_rosa_maltoni', 'casamento', 'Pais de Benito Mussolini');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', NULL, 'pub_u_mussolini_alessandro_rosa');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_mussolini_alessandro_rosa', 'pub_mussolini_benito_mussolini', 'biologico', 1),
('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_anna_maria_mussolini', 'biologico', 5);

UPDATE arvores
SET raiz_pessoa_id = 'pub_mussolini_alessandro_mussolini'
WHERE id = 'pub_arv_mussolini';

-- 15. Família Souza Queirós (pub_arv_souza_queiros)
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'biologico', 1),
('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_vicente_de_sousa_queiros', 'biologico', 2),
('pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', 'biologico', 1);

-- 16. Família Álvares Penteado (pub_arv_penteado)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_penteado_maria_higina_penteado', 'Maria Higina', 'Álvares Penteado', 'F', 'Esposa do Capitão João Carlos Leite Penteado e mãe do Conde Antônio Álvares Leite Penteado.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_maria_higina_penteado', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_penteado_joao_maria', 'pub_penteado_joao_carlos_leite_penteado', 'pub_penteado_maria_higina_penteado', 'casamento', 'Pais do Conde Álvares Penteado');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', NULL, 'pub_u_penteado_joao_maria');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_penteado_joao_maria', 'pub_penteado_antonio_alvares_leite_penteado', 'biologico', 1),
('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_armando_alvares_penteado', 'biologico', 1),
('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_silvio_alvares_penteado', 'biologico', 2),
('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_estela_penteado', 'biologico', 3),
('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_eglantina_penteado', 'biologico', 4),
('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_antonieta_penteado', 'biologico', 5);

UPDATE arvores
SET raiz_pessoa_id = 'pub_penteado_joao_carlos_leite_penteado'
WHERE id = 'pub_arv_penteado';

-- 17. Família Washington (pub_arv_washington)
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_washington_augustine_mary', 'pub_washington_lawrence', 'biologico', 2),
('pub_u_washington_george_martha', 'pub_washington_jacky_custis', 'adotado', 1);

UPDATE arvores
SET raiz_pessoa_id = 'pub_washington_augustine'
WHERE id = 'pub_arv_washington';

-- 18. Linhagem Skywalker (pub_arv_skywalker)
DELETE FROM arvore_membros
WHERE arvore_id = 'pub_arv_skywalker' AND pessoa_id = 'pub_skywalker_bail_organa';

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_skywalker_ordem_jedi', 'Legado Jedi', '(Sucessão Espiritual)', 'F', 'Transmissão do legado da Ordem Jedi e do nome Skywalker.', 0, 1, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_ph_skywalker_ordem_jedi', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_skywalker_luke_rey', 'pub_skywalker_luke_skywalker', 'pub_ph_skywalker_ordem_jedi', 'estavel', 'Mestre Jedi e sucessora do legado Skywalker');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', NULL, 'pub_u_skywalker_luke_rey');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_skywalker_luke_rey', 'pub_skywalker_rey', 'adotado', 1);

-- 19. Família de Leonardo da Vinci (pub_arv_da_vinci)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_davinci_antonio', 'Antonio', 'da Vinci', 'M', 'Avô paterno de Leonardo da Vinci em Vinci; pai de Ser Piero e de Francesco da Vinci.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real'),
('pub_davinci_lucia', 'Lucia', 'di Ser Zoso', 'F', 'Avó paterna de Leonardo da Vinci; esposa de Antonio da Vinci.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real'),
('pub_ph_davinci_atelier', 'Atelier Renascentista', '(Herdeiros e Discípulos)', 'F', 'Oficina artística e sucessão testamentária de Leonardo da Vinci.', 0, 1, 1, 'Ciência, Artes e Pensamento', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_da_vinci', 'pub_davinci_antonio', NULL),
('pub_arv_da_vinci', 'pub_davinci_lucia', NULL),
('pub_arv_da_vinci', 'pub_ph_davinci_atelier', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_davinci_avos', 'pub_davinci_antonio', 'pub_davinci_lucia', 'casamento', 'Avós paternos de Leonardo da Vinci'),
('pub_u_davinci_leonardo_discipulos', 'pub_davinci_leonardo', 'pub_ph_davinci_atelier', 'estavel', 'Discípulos, filhos adotivos informais e herdeiros testamentários');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_da_vinci', NULL, 'pub_u_davinci_avos'),
('pub_arv_da_vinci', NULL, 'pub_u_davinci_leonardo_discipulos');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_davinci_avos', 'pub_davinci_piero', 'biologico', 1),
('pub_u_davinci_avos', 'pub_davinci_francesco', 'biologico', 2),
('pub_u_davinci_leonardo_discipulos', 'pub_davinci_melzi', 'adotado', 1),
('pub_u_davinci_leonardo_discipulos', 'pub_davinci_salai', 'adotado', 2);

UPDATE arvores
SET raiz_pessoa_id = 'pub_davinci_antonio'
WHERE id = 'pub_arv_da_vinci';

-- 20. Machado de Assis e Família (pub_arv_machado_de_assis)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_machado_antonio_novais', 'Antônio Luís', 'de Novais', 'M', 'Ourives portuense; pai de Carolina Augusta e de Faustino Xavier de Novais, sogro de Machado de Assis.', 0, 0, 1, 'História do Brasil', 'real'),
('pub_machado_custodia_novais', 'Custódia Emília', 'Xavier de Novais', 'F', 'Matriarca da família Novais no Porto; mãe de Carolina e Faustino Xavier de Novais.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_machado_de_assis', 'pub_machado_antonio_novais', NULL),
('pub_arv_machado_de_assis', 'pub_machado_custodia_novais', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_machado_sogros', 'pub_machado_antonio_novais', 'pub_machado_custodia_novais', 'casamento', 'Pais de Carolina e Faustino Xavier de Novais');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_machado_de_assis', NULL, 'pub_u_machado_sogros');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_machado_sogros', 'pub_machado_carolina_novais', 'biologico', 1),
('pub_u_machado_sogros', 'pub_machado_faustino_novais', 'biologico', 2);

UPDATE arvores
SET raiz_pessoa_id = 'pub_machado_francisco_jose'
WHERE id = 'pub_arv_machado_de_assis';

-- 21. Família de Sir Isaac Newton (pub_arv_newton)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_newton_robert_barton', 'Robert', 'Barton', 'M', 'Reverendo anglicano em Brigstock; marido de Hannah Smith e pai de Catherine Barton.', 0, 0, 1, 'Ciência, Artes e Pensamento', 'real');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_newton', 'pub_newton_robert_barton', NULL);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_newton_barton_hannah', 'pub_newton_robert_barton', 'pub_newton_hannah_smith', 'casamento', 'Pais de Catherine Barton (sobrinha de Isaac Newton)');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_newton', NULL, 'pub_u_newton_barton_hannah');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_newton_barton_hannah', 'pub_newton_catherine_barton', 'biologico', 1);

UPDATE arvores
SET raiz_pessoa_id = 'pub_newton_isaac_sr'
WHERE id = 'pub_arv_newton';

-- 22. Protagonistas da Independência (pub_arv_independencia_1822) e Genealogia de Jesus (pub_arv_jesus_lucas)
-- Mantém em pub_arv_independencia_1822 a família dos Irmãos Andrada (José Bonifácio) sem duplicar a Família Imperial
DELETE FROM arvore_membros
WHERE arvore_id = 'pub_arv_independencia_1822'
  AND (
    pessoa_id IN (
      'pub_goncalves_ledo',
      'pub_januario_barbosa',
      'pub_frei_caneca',
      'pub_maria_quiteria',
      'pub_joana_angelica',
      'pub_maria_felipa',
      'pub_pedro1',
      'pub_leopoldina',
      'pub_marquesa_santos'
    )
    OR uniao_id IN ('pub_u_pedro1_leopoldina', 'pub_u_pedro1_domitila')
  );

-- Remove a ilha separada de Jonas/Pedro/André da árvore genealógica de Lucas para manter 1 única linhagem conexa
DELETE FROM arvore_membros
WHERE arvore_id = 'pub_arv_jesus_lucas'
  AND (
    pessoa_id IN ('pub_luc_jonas', 'pub_luc_pedro', 'pub_luc_andre', 'pub_ph_luc_jonas_esposa')
    OR uniao_id = 'pub_u_luc_jonas'
  );

-- Separa as famílias presidenciais de Getúlio Vargas, Juscelino Kubitschek e Deodoro da Fonseca em árvores próprias 100% conexas
UPDATE arvores
SET nome = 'Getúlio Vargas e Família Vargas',
    descricao = 'Linhagem de São Borja do Presidente Getúlio Vargas, de Manuel do Nascimento Vargas a Alzira Vargas.',
    raiz_pessoa_id = 'pub_manuel_vargas'
WHERE id = 'arv_presidentes_brasil';

DELETE FROM arvore_membros
WHERE arvore_id = 'arv_presidentes_brasil'
  AND (
    pessoa_id IN ('pub_deodoro', 'pub_mariana_deodoro', 'pub_jk', 'pub_sarah_jk', 'pub_marcia_jk', 'pub_joao_cesar', 'pub_julia_kubitschek')
    OR uniao_id IN ('pub_u_deodoro_mariana', 'pub_u_jk_sarah', 'pub_u_pais_jk')
  );

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_deodoro_manuel_mendes', 'Manuel Mendes', 'da Fonseca', 'M', 'Tenente-coronel do Exército Imperial em Alagoas; pai do Marechal Deodoro da Fonseca e de Hermes Ernesto da Fonseca.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_deodoro_rosa_paulina', 'Rosa Maria Paulina', 'da Fonseca', 'F', 'Matriarca alagoana ("Mãe dos Sete Macabeus"); mãe do Marechal Deodoro da Fonseca.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real');

INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo) VALUES
('pub_arv_jk', 'Juscelino Kubitschek e Família', 'Linhagem de Diamantina do Presidente Juscelino Kubitschek, fundador de Brasília.', 'pub_joao_cesar', 1, 'Chefes de Estado e Lideranças Políticas', 'Brasil', '1872–2000', 'real'),
('pub_arv_deodoro', 'Marechal Deodoro da Fonseca e Família', 'Família do proclamador da República e primeiro Presidente do Brasil.', 'pub_deodoro_manuel_mendes', 1, 'Chefes de Estado e Lideranças Políticas', 'Brasil', '1785–1921', 'real');

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_deodoro_pais', 'pub_deodoro_manuel_mendes', 'pub_deodoro_rosa_paulina', 'casamento', 'Pais do Marechal Deodoro da Fonseca');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_deodoro_pais', 'pub_deodoro', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_jk', 'pub_joao_cesar', NULL),
('pub_arv_jk', 'pub_julia_kubitschek', NULL),
('pub_arv_jk', 'pub_jk', NULL),
('pub_arv_jk', 'pub_sarah_jk', NULL),
('pub_arv_jk', 'pub_marcia_jk', NULL),
('pub_arv_jk', NULL, 'pub_u_pais_jk'),
('pub_arv_jk', NULL, 'pub_u_jk_sarah'),
('pub_arv_deodoro', 'pub_deodoro_manuel_mendes', NULL),
('pub_arv_deodoro', 'pub_deodoro_rosa_paulina', NULL),
('pub_arv_deodoro', 'pub_deodoro', NULL),
('pub_arv_deodoro', 'pub_mariana_deodoro', NULL),
('pub_arv_deodoro', NULL, 'pub_u_deodoro_pais'),
('pub_arv_deodoro', NULL, 'pub_u_deodoro_mariana');

-- 23. Ajusta raízes de outras árvores para o ancestral de topo
UPDATE arvores SET raiz_pessoa_id = 'pub_kennedy_patrick_joseph_kennedy' WHERE id = 'pub_arv_kennedy';
UPDATE arvores SET raiz_pessoa_id = 'pub_mao_mao_yichang' WHERE id = 'pub_arv_mao';

-- ============================================================================
-- C. VINCULAÇÃO DE REGISTROS PÚBLICOS ÓRFÃOS E CRIAÇÃO DE LINHAGENS CONEXAS
-- ============================================================================

-- 24.1 Elizabeth Allen (mãe de Emma Darwin) na árvore Darwin-Wedgwood
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_elizabeth_allen', NULL);

-- 24.2 Marquesa de Santos na Família Imperial do Brasil (união com D. Pedro I)
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('arv_imperial_brasil', 'pub_marquesa_santos', NULL),
('arv_imperial_brasil', NULL, 'pub_u_pedro1_domitila');

-- 24.3 São Pedro, Santo André e Família de Jonas (Apóstolos de Betsaida)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_luc_jonas_esposa', 'Esposa de Jonas', '(Betsaida)', 'F', 'Mãe dos apóstolos Simão Pedro e Santo André em Betsaida.', 0, 1, 1, 'Tradição Bíblica', 'real');

UPDATE unioes
SET slot_feminino_id = 'pub_ph_luc_jonas_esposa'
WHERE id = 'pub_u_luc_jonas';

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES (
  'pub_arv_apostolos_jonas',
  'São Pedro, Santo André e Família de Jonas (Apóstolos)',
  'Família apostólica de Betsaida na Galileia: Jonas (João bar Yonah) e seus filhos Simão Pedro (Cefas) e Santo André Apóstolo.',
  'pub_luc_jonas',
  1,
  'Tradição Bíblica',
  'Galileia / Israel Antigo',
  'Séc. I a.C. – Séc. I d.C.',
  'real'
)
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  descricao = excluded.descricao,
  raiz_pessoa_id = excluded.raiz_pessoa_id,
  categoria = excluded.categoria;

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_apostolos_jonas', 'pub_luc_jonas', NULL),
('pub_arv_apostolos_jonas', 'pub_ph_luc_jonas_esposa', NULL),
('pub_arv_apostolos_jonas', 'pub_luc_pedro', NULL),
('pub_arv_apostolos_jonas', 'pub_luc_andre', NULL),
('pub_arv_apostolos_jonas', NULL, 'pub_u_luc_jonas');

-- 24.4 Maria Quitéria de Jesus e Família Alves de Almeida (Heroína da Independência)
UPDATE arvores
SET nome = 'José Bonifácio e Clã dos Andradas (Independência)',
    descricao = 'Linhagem santista do Patriarca da Independência José Bonifácio de Andrada e Silva e seus irmãos Antônio Carlos e Martim Francisco.'
WHERE id = 'pub_arv_independencia_1822';

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_quiteria_goncalo_pai', 'Gonçalo', 'Alves de Almeida', 'M', 'Fazendeiro e proprietário rural na Freguesia de São José das Itapororocas (Feira de Santana, Bahia); pai de Maria Quitéria de Jesus.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_quiteria_mae', 'Quitéria Maria', 'de Jesus', 'F', 'Primeira esposa de Gonçalo Alves de Almeida e mãe da heroína nacional Maria Quitéria de Jesus.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_quiteria_gabriel_brito', 'Gabriel', 'Pereira de Brito (Alferes)', 'M', 'Alferes do Exército Imperial na Bahia; esposo de Maria Quitéria de Jesus e pai de Luísa Maria da Conceição.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_quiteria_luisa_filha', 'Luísa Maria', 'da Conceição', 'F', 'Filha única de Maria Quitéria de Jesus e do Alferes Gabriel Pereira de Brito em Salvador.', 0, 0, 1, 'História e Sociedade Brasileira', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_quiteria_goncalo', 'pub_quiteria_goncalo_pai', 'nascimento', 1765, 1765, 'cerca_de', 'c. 1765'),
('ev_d_pub_quiteria_goncalo', 'pub_quiteria_goncalo_pai', 'falecimento', 1834, 1834, 'cerca_de', 'c. 1834'),
('ev_b_pub_quiteria_mae', 'pub_quiteria_mae', 'nascimento', 1770, 1770, 'cerca_de', 'c. 1770'),
('ev_d_pub_quiteria_mae', 'pub_quiteria_mae', 'falecimento', 1803, 1803, 'exata', '1803'),
('ev_b_pub_quiteria_gabriel', 'pub_quiteria_gabriel_brito', 'nascimento', 1790, 1790, 'cerca_de', 'c. 1790'),
('ev_d_pub_quiteria_gabriel', 'pub_quiteria_gabriel_brito', 'falecimento', 1835, 1835, 'exata', '1835'),
('ev_b_pub_quiteria_luisa', 'pub_quiteria_luisa_filha', 'nascimento', 1826, 1826, 'exata', '1826');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES (
  'pub_arv_maria_quiteria',
  'Maria Quitéria e Família Alves de Almeida',
  'Linhagem baiana da primeira mulher a integrar o Exército Brasileiro e heroína da Guerra da Independência na Bahia (1822–1823).',
  'pub_quiteria_goncalo_pai',
  1,
  'História e Sociedade Brasileira',
  'Brasil',
  '1765–1853',
  'real'
)
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  descricao = excluded.descricao,
  raiz_pessoa_id = excluded.raiz_pessoa_id,
  categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_quiteria_pais', 'pub_quiteria_goncalo_pai', 'pub_quiteria_mae', 'casamento', 'Pais de Maria Quitéria em Feira de Santana'),
('pub_u_quiteria_gabriel', 'pub_quiteria_gabriel_brito', 'pub_maria_quiteria', 'casamento', 'Casamento após a Guerra da Independência na Bahia');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_quiteria_pais', 'pub_maria_quiteria', 'biologico', 1),
('pub_u_quiteria_gabriel', 'pub_quiteria_luisa_filha', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_maria_quiteria', 'pub_quiteria_goncalo_pai', NULL),
('pub_arv_maria_quiteria', 'pub_quiteria_mae', NULL),
('pub_arv_maria_quiteria', 'pub_maria_quiteria', NULL),
('pub_arv_maria_quiteria', 'pub_quiteria_gabriel_brito', NULL),
('pub_arv_maria_quiteria', 'pub_quiteria_luisa_filha', NULL),
('pub_arv_maria_quiteria', NULL, 'pub_u_quiteria_pais'),
('pub_arv_maria_quiteria', NULL, 'pub_u_quiteria_gabriel');

-- 24.5 Joaquim Gonçalves Ledo e Frei Caneca — conectados às suas famílias reais
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_ledo_antonio_pai', 'Antônio', 'Gonçalves Ledo', 'M', 'Comerciante no Rio de Janeiro colonial; pai de Joaquim Gonçalves Ledo e do médico Custódio Gonçalves Ledo.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_ledo_maria_mae', 'Maria dos Reis', 'Gonçalves Ledo', 'F', 'Matriarca da família Gonçalves Ledo no Rio de Janeiro.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_ledo_custodio_irmao', 'Custódio', 'Gonçalves Ledo', 'M', 'Médico formado em Londres e deputado geral do Império; irmão de Joaquim Gonçalves Ledo.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_caneca_domingos_pai', 'Domingos', 'da Silva Rabelo', 'M', 'Mestre tanoeiro no Recife (Bairro de Santo Antônio); pai de Joaquim do Amor Divino Rabelo (Frei Caneca).', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_caneca_francisca_mae', 'Francisca Maria', 'Alexandrina de Siqueira', 'F', 'Mãe de Frei Caneca no Recife.', 0, 0, 1, 'História e Sociedade Brasileira', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_ledo_antonio', 'pub_ledo_antonio_pai', 'nascimento', 1750, 1750, 'cerca_de', 'c. 1750'),
('ev_b_pub_ledo_maria', 'pub_ledo_maria_mae', 'nascimento', 1755, 1755, 'cerca_de', 'c. 1755'),
('ev_b_pub_ledo_custodio', 'pub_ledo_custodio_irmao', 'nascimento', 1778, 1778, 'cerca_de', 'c. 1778'),
('ev_b_pub_caneca_domingos', 'pub_caneca_domingos_pai', 'nascimento', 1750, 1750, 'cerca_de', 'c. 1750'),
('ev_b_pub_caneca_francisca', 'pub_caneca_francisca_mae', 'nascimento', 1755, 1755, 'cerca_de', 'c. 1755');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo) VALUES
('pub_arv_goncalves_ledo', 'Joaquim Gonçalves Ledo e Família Ledo', 'Família fluminense do fundador do jornal Revérbero Constitucional Fluminense e articulador do Dia do Fico e da Independência.', 'pub_ledo_antonio_pai', 1, 'História e Sociedade Brasileira', 'Brasil', '1750–1847', 'real'),
('pub_arv_frei_caneca', 'Frei Caneca e Família Silva Rabelo', 'Família pernambucana do religioso carmelita, pensador constitucional, jornalista do Typhis Pernambucano e mártir da Confederação do Equador (1824).', 'pub_caneca_domingos_pai', 1, 'História e Sociedade Brasileira', 'Brasil', '1750–1825', 'real')
ON CONFLICT(id) DO UPDATE SET
  nome = excluded.nome,
  descricao = excluded.descricao,
  raiz_pessoa_id = excluded.raiz_pessoa_id,
  categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_ledo_pais', 'pub_ledo_antonio_pai', 'pub_ledo_maria_mae', 'casamento', 'Pais de Joaquim e Custódio Gonçalves Ledo'),
('pub_u_caneca_pais', 'pub_caneca_domingos_pai', 'pub_caneca_francisca_mae', 'casamento', 'Pais de Frei Caneca no Recife');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_ledo_pais', 'pub_ledo_custodio_irmao', 'biologico', 1),
('pub_u_ledo_pais', 'pub_goncalves_ledo', 'biologico', 2),
('pub_u_caneca_pais', 'pub_frei_caneca', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_goncalves_ledo', 'pub_ledo_antonio_pai', NULL),
('pub_arv_goncalves_ledo', 'pub_ledo_maria_mae', NULL),
('pub_arv_goncalves_ledo', 'pub_ledo_custodio_irmao', NULL),
('pub_arv_goncalves_ledo', 'pub_goncalves_ledo', NULL),
('pub_arv_goncalves_ledo', NULL, 'pub_u_ledo_pais'),
('pub_arv_frei_caneca', 'pub_caneca_domingos_pai', NULL),
('pub_arv_frei_caneca', 'pub_caneca_francisca_mae', NULL),
('pub_arv_frei_caneca', 'pub_frei_caneca', NULL),
('pub_arv_frei_caneca', NULL, 'pub_u_caneca_pais');

-- Remove os 4 registros solitários sem árvore familiar
DELETE FROM obras_culturais WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM profissoes_pessoa WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM escolaridade_pessoa WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM idiomas_pessoa WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM religioes_pessoa WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM eventos WHERE pessoa_id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');
DELETE FROM pessoas WHERE id IN ('pub_januario_barbosa', 'pub_joana_angelica', 'pub_maria_felipa', 'pub_skywalker_bail_organa');

-- ============================================================================
-- D. EXPANSÃO DE GRANDES FAMÍLIAS E PERSONALIDADES HISTÓRICAS FALTANTES
-- ============================================================================

-- 25.1 Júlio César, Augusto e Dinastia Júlio-Claudiana (Roma Antiga)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_jc_caio_pai', 'Caio Júlio', 'César (Pretor)', 'M', 'Senador e pretor da República Romana, governador da província da Ásia; pai do ditador Júlio César e de Júlia Menor.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_aurelia_cota', 'Aurélia', 'Cota', 'F', 'Matrona patrícia romana de célebre virtude e cultura; mãe de Caio Júlio César e de Júlia Menor.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_julio_cesar', 'Caio Júlio', 'César (Ditador Perpétuo)', 'M', 'General, cônsul, historiador dos Comentários sobre a Guerra Gálica e Ditador Perpétuo de Roma; reformou o calendário (Juliano) e lançou as bases do Império Romano.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_cornelia', 'Cornélia', 'Cinila', 'F', 'Primeira esposa de Júlio César e mãe de sua filha legítima Júlia César.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_julia_filha', 'Júlia', 'César (Filha)', 'F', 'Filha de Júlio César e esposa de Pompeu Magno; sua morte em 54 a.C. precipitou a ruptura do Primeiro Triunvirato.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_julia_menor', 'Júlia', 'César Menor', 'F', 'Irmã de Júlio César e avó materna do primeiro imperador romano, César Augusto.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_acio_balbo', 'Marco Ácio', 'Balbo', 'M', 'Pretor e senador romano, sobrinho de Pompeu Estrabão; marido de Júlia Menor e avô de Augusto.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_acia', 'Ácia', 'Balba Cesônia', 'F', 'Sobrinha de Júlio César e mãe do Imperador César Augusto (Otaviano) e de Otávia Menor.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_caio_otavio', 'Caio', 'Otávio (Pretor da Macedônia)', 'M', 'Senador e governador romano da Macedônia; pai biológico do Imperador César Augusto.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_augusto', 'César Augusto', '(Caio Júlio César Otaviano)', 'M', 'Sobrinho-neto e filho adotivo de Júlio César; 1º Imperador Romano (27 a.C.–14 d.C.), fundador do Principado e inaugurador da Pax Romana.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_otavia', 'Otávia', 'Menor', 'F', 'Irmã muito respeitada do Imperador Augusto; mediadora diplomática e ancestral dos imperadores Cláudio, Calígula e Nero.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_livia', 'Lívia', 'Drusila (Júlia Augusta)', 'F', 'Imperatriz consorte de Roma por mais de cinquenta anos, conselheira política de Augusto e mãe do Imperador Tibério.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_jc_tiberio', 'Tibério', 'Júlio César Augusto', 'M', '2º Imperador Romano (14–37 d.C.), general brilhante na Germânia e Panônia, filho de Lívia e sucessor adotivo de Augusto.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_jc_caio_pai', 'pub_jc_caio_pai', 'nascimento', -140, -140, 'cerca_de', 'c. 140 a.C.'),
('ev_d_pub_jc_caio_pai', 'pub_jc_caio_pai', 'falecimento', -85, -85, 'exata', '85 a.C.'),
('ev_b_pub_jc_aurelia', 'pub_jc_aurelia_cota', 'nascimento', -120, -120, 'cerca_de', 'c. 120 a.C.'),
('ev_d_pub_jc_aurelia', 'pub_jc_aurelia_cota', 'falecimento', -54, -54, 'exata', '54 a.C.'),
('ev_b_pub_jc_julio_cesar', 'pub_jc_julio_cesar', 'nascimento', -100, -100, 'exata', '12 de julho de 100 a.C.'),
('ev_d_pub_jc_julio_cesar', 'pub_jc_julio_cesar', 'falecimento', -44, -44, 'exata', '15 de março de 44 a.C. (Idos de Março)'),
('ev_b_pub_jc_cornelia', 'pub_jc_cornelia', 'nascimento', -97, -97, 'cerca_de', 'c. 97 a.C.'),
('ev_d_pub_jc_cornelia', 'pub_jc_cornelia', 'falecimento', -69, -69, 'exata', '69 a.C.'),
('ev_b_pub_jc_julia_f', 'pub_jc_julia_filha', 'nascimento', -76, -76, 'cerca_de', 'c. 76 a.C.'),
('ev_d_pub_jc_julia_f', 'pub_jc_julia_filha', 'falecimento', -54, -54, 'exata', '54 a.C.'),
('ev_b_pub_jc_julia_m', 'pub_jc_julia_menor', 'nascimento', -101, -101, 'exata', '101 a.C.'),
('ev_d_pub_jc_julia_m', 'pub_jc_julia_menor', 'falecimento', -51, -51, 'exata', '51 a.C.'),
('ev_b_pub_jc_acio', 'pub_jc_acio_balbo', 'nascimento', -105, -105, 'exata', '105 a.C.'),
('ev_d_pub_jc_acio', 'pub_jc_acio_balbo', 'falecimento', -51, -51, 'exata', '51 a.C.'),
('ev_b_pub_jc_acia', 'pub_jc_acia', 'nascimento', -85, -85, 'exata', '85 a.C.'),
('ev_d_pub_jc_acia', 'pub_jc_acia', 'falecimento', -43, -43, 'exata', '43 a.C.'),
('ev_b_pub_jc_otavio', 'pub_jc_caio_otavio', 'nascimento', -100, -100, 'cerca_de', 'c. 100 a.C.'),
('ev_d_pub_jc_otavio', 'pub_jc_caio_otavio', 'falecimento', -59, -59, 'exata', '59 a.C.'),
('ev_b_pub_jc_augusto', 'pub_jc_augusto', 'nascimento', -63, -63, 'exata', '23 de setembro de 63 a.C.'),
('ev_d_pub_jc_augusto', 'pub_jc_augusto', 'falecimento', 14, 14, 'exata', '19 de agosto de 14 d.C.'),
('ev_b_pub_jc_otavia', 'pub_jc_otavia', 'nascimento', -69, -69, 'exata', '69 a.C.'),
('ev_d_pub_jc_otavia', 'pub_jc_otavia', 'falecimento', -11, -11, 'exata', '11 a.C.'),
('ev_b_pub_jc_livia', 'pub_jc_livia', 'nascimento', -58, -58, 'exata', '30 de janeiro de 58 a.C.'),
('ev_d_pub_jc_livia', 'pub_jc_livia', 'falecimento', 29, 29, 'exata', '28 de setembro de 29 d.C.'),
('ev_b_pub_jc_tiberio', 'pub_jc_tiberio', 'nascimento', -42, -42, 'exata', '16 de novembro de 42 a.C.'),
('ev_d_pub_jc_tiberio', 'pub_jc_tiberio', 'falecimento', 37, 37, 'exata', '16 de março de 37 d.C.');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_julio_claudiana', 'Júlio César, Augusto e Dinastia Júlio-Claudiana', 'Linhagem patrícia romana da Gens Júlia que conduziu a transição da República para o Império Romano, de Júlio César a César Augusto e Tibério.', 'pub_jc_caio_pai', 1, 'Antiguidade e Dinastias Históricas', 'Roma Antiga (Itália)', '140 a.C. – 37 d.C.', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_jc_pais', 'pub_jc_caio_pai', 'pub_jc_aurelia_cota', 'casamento', 'Pais de Júlio César e Júlia Menor'),
('pub_u_jc_cesar_cornelia', 'pub_jc_julio_cesar', 'pub_jc_cornelia', 'casamento', 'Casamento em 84 a.C.'),
('pub_u_jc_acio_julia', 'pub_jc_acio_balbo', 'pub_jc_julia_menor', 'casamento', 'Avós maternos de César Augusto'),
('pub_u_jc_otavio_acia', 'pub_jc_caio_otavio', 'pub_jc_acia', 'casamento', 'Pais de César Augusto e Otávia Menor'),
('pub_u_jc_augusto_livia', 'pub_jc_augusto', 'pub_jc_livia', 'casamento', 'Casamento imperial em 38 a.C.');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_jc_pais', 'pub_jc_julia_menor', 'biologico', 1),
('pub_u_jc_pais', 'pub_jc_julio_cesar', 'biologico', 2),
('pub_u_jc_cesar_cornelia', 'pub_jc_julia_filha', 'biologico', 1),
('pub_u_jc_acio_julia', 'pub_jc_acia', 'biologico', 1),
('pub_u_jc_otavio_acia', 'pub_jc_otavia', 'biologico', 1),
('pub_u_jc_otavio_acia', 'pub_jc_augusto', 'biologico', 2),
('pub_u_jc_augusto_livia', 'pub_jc_tiberio', 'adotado', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_julio_claudiana', 'pub_jc_caio_pai', NULL),
('pub_arv_julio_claudiana', 'pub_jc_aurelia_cota', NULL),
('pub_arv_julio_claudiana', 'pub_jc_julio_cesar', NULL),
('pub_arv_julio_claudiana', 'pub_jc_cornelia', NULL),
('pub_arv_julio_claudiana', 'pub_jc_julia_filha', NULL),
('pub_arv_julio_claudiana', 'pub_jc_julia_menor', NULL),
('pub_arv_julio_claudiana', 'pub_jc_acio_balbo', NULL),
('pub_arv_julio_claudiana', 'pub_jc_acia', NULL),
('pub_arv_julio_claudiana', 'pub_jc_caio_otavio', NULL),
('pub_arv_julio_claudiana', 'pub_jc_augusto', NULL),
('pub_arv_julio_claudiana', 'pub_jc_otavia', NULL),
('pub_arv_julio_claudiana', 'pub_jc_livia', NULL),
('pub_arv_julio_claudiana', 'pub_jc_tiberio', NULL),
('pub_arv_julio_claudiana', NULL, 'pub_u_jc_pais'),
('pub_arv_julio_claudiana', NULL, 'pub_u_jc_cesar_cornelia'),
('pub_arv_julio_claudiana', NULL, 'pub_u_jc_acio_julia'),
('pub_arv_julio_claudiana', NULL, 'pub_u_jc_otavio_acia'),
('pub_arv_julio_claudiana', NULL, 'pub_u_jc_augusto_livia');

-- 25.2 Alexandre, o Grande e Dinastia Argéada da Macedônia
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_alex_amintas3', 'Amintas III', 'da Macedônia', 'M', 'Rei da Macedônia da Dinastia Argéada; unificou o reino e foi pai de Filipe II e avô de Alexandre, o Grande.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_euridice', 'Eurídice I', 'da Macedônia', 'F', 'Rainha consorte da Macedônia, esposa de Amintas III e mãe de três reis macedônios, incluindo Filipe II.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_filipe2', 'Filipe II', 'da Macedônia', 'M', 'Rei da Macedônia (359–336 a.C.), criador da falange macedônia e hegêmona da Liga de Corinto; pai de Alexandre, o Grande.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_olimpia', 'Olímpia', 'do Epiro (Polixena)', 'F', 'Princesa molossa do Epiro, rainha consorte da Macedônia e mãe devotada de Alexandre, o Grande.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_magno', 'Alexandre, o Grande', '(Alexandre III da Macedônia)', 'M', 'Rei da Macedônia, Faraó do Egito e Rei da Ásia; discípulo de Aristóteles e maior estrategista da Antiguidade, fundou Alexandria e difundiu a civilização helenística.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_cleopatra_mac', 'Cleópatra', 'da Macedônia (Rainha do Epiro)', 'F', 'Irmã carnal de Alexandre, o Grande e rainha regente do Epiro.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_roxana', 'Roxana', 'da Báctria', 'F', 'Princesa bactriana de Sogdiana, esposa principal de Alexandre, o Grande e mãe de Alexandre IV.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real'),
('pub_alex_alexandre4', 'Alexandre IV', 'da Macedônia (Aegus)', 'M', 'Filho póstumo e herdeiro legítimo de Alexandre, o Grande e Roxana.', 0, 0, 1, 'Antiguidade e Dinastias Históricas', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_alex_amintas3', 'pub_alex_amintas3', 'nascimento', -430, -430, 'cerca_de', 'c. 430 a.C.'),
('ev_d_pub_alex_amintas3', 'pub_alex_amintas3', 'falecimento', -370, -370, 'exata', '370 a.C.'),
('ev_b_pub_alex_euridice', 'pub_alex_euridice', 'nascimento', -410, -410, 'cerca_de', 'c. 410 a.C.'),
('ev_d_pub_alex_euridice', 'pub_alex_euridice', 'falecimento', -365, -365, 'cerca_de', 'c. 365 a.C.'),
('ev_b_pub_alex_filipe2', 'pub_alex_filipe2', 'nascimento', -382, -382, 'exata', '382 a.C.'),
('ev_d_pub_alex_filipe2', 'pub_alex_filipe2', 'falecimento', -336, -336, 'exata', 'outubro de 336 a.C.'),
('ev_b_pub_alex_olimpia', 'pub_alex_olimpia', 'nascimento', -375, -375, 'cerca_de', 'c. 375 a.C.'),
('ev_d_pub_alex_olimpia', 'pub_alex_olimpia', 'falecimento', -316, -316, 'exata', '316 a.C.'),
('ev_b_pub_alex_magno', 'pub_alex_magno', 'nascimento', -356, -356, 'exata', '20 de julho de 356 a.C.'),
('ev_d_pub_alex_magno', 'pub_alex_magno', 'falecimento', -323, -323, 'exata', '10 de junho de 323 a.C.'),
('ev_b_pub_alex_cleop', 'pub_alex_cleopatra_mac', 'nascimento', -354, -354, 'cerca_de', 'c. 354 a.C.'),
('ev_d_pub_alex_cleop', 'pub_alex_cleopatra_mac', 'falecimento', -308, -308, 'exata', '308 a.C.'),
('ev_b_pub_alex_roxana', 'pub_alex_roxana', 'nascimento', -340, -340, 'cerca_de', 'c. 340 a.C.'),
('ev_d_pub_alex_roxana', 'pub_alex_roxana', 'falecimento', -310, -310, 'exata', '310 a.C.'),
('ev_b_pub_alex_alex4', 'pub_alex_alexandre4', 'nascimento', -323, -323, 'exata', 'agosto de 323 a.C.'),
('ev_d_pub_alex_alex4', 'pub_alex_alexandre4', 'falecimento', -309, -309, 'exata', '309 a.C.');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_alexandre_magno', 'Alexandre, o Grande e Dinastia Argéada (Macedônia)', 'Linhagem real macedônica de Pela: de Amintas III e Filipe II a Alexandre, o Grande, conquistador do Império Persa e difusor do Helenismo.', 'pub_alex_amintas3', 1, 'Antiguidade e Dinastias Históricas', 'Grécia / Macedônia Antiga', '430 a.C. – 309 a.C.', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_alex_amintas_euridice', 'pub_alex_amintas3', 'pub_alex_euridice', 'casamento', 'Reis da Macedônia'),
('pub_u_alex_filipe_olimpia', 'pub_alex_filipe2', 'pub_alex_olimpia', 'casamento', 'Casamento real em 357 a.C.'),
('pub_u_alex_magno_roxana', 'pub_alex_magno', 'pub_alex_roxana', 'casamento', 'Casamento em Balkh em 327 a.C.');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_alex_amintas_euridice', 'pub_alex_filipe2', 'biologico', 1),
('pub_u_alex_filipe_olimpia', 'pub_alex_magno', 'biologico', 1),
('pub_u_alex_filipe_olimpia', 'pub_alex_cleopatra_mac', 'biologico', 2),
('pub_u_alex_magno_roxana', 'pub_alex_alexandre4', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_alexandre_magno', 'pub_alex_amintas3', NULL),
('pub_arv_alexandre_magno', 'pub_alex_euridice', NULL),
('pub_arv_alexandre_magno', 'pub_alex_filipe2', NULL),
('pub_arv_alexandre_magno', 'pub_alex_olimpia', NULL),
('pub_arv_alexandre_magno', 'pub_alex_magno', NULL),
('pub_arv_alexandre_magno', 'pub_alex_cleopatra_mac', NULL),
('pub_arv_alexandre_magno', 'pub_alex_roxana', NULL),
('pub_arv_alexandre_magno', 'pub_alex_alexandre4', NULL),
('pub_arv_alexandre_magno', NULL, 'pub_u_alex_amintas_euridice'),
('pub_arv_alexandre_magno', NULL, 'pub_u_alex_filipe_olimpia'),
('pub_arv_alexandre_magno', NULL, 'pub_u_alex_magno_roxana');

-- 25.3 Dinastia Romanov (Czares do Império Russo)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_rom_alexandre2', 'Alexandre II', 'Romanov (Czar da Rússia)', 'M', 'Imperador de Todas as Rússias (1855–1881), conhecido como "Alexandre, o Libertador" pela emancipação dos servos russos em 1861.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_maria_alex', 'Maria Alexandrovna', '(Maria de Hesse e Reno)', 'F', 'Imperatriz consorte da Rússia, esposa de Alexandre II e mãe de Alexandre III.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_alexandre3', 'Alexandre III', 'Romanov (Czar da Rússia)', 'M', 'Imperador de Todas as Rússias (1881–1894), conhecido como "O Pacificador" por não ter envolvido o Império Russo em nenhuma guerra externa.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_maria_feod', 'Maria Feodorovna', '(Dagmar da Dinamarca)', 'F', 'Princesa da Dinamarca e Imperatriz consorte da Rússia, esposa de Alexandre III e mãe de Nicolau II.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_nicolau2', 'Nicolau II', 'Romanov (Último Czar da Rússia)', 'M', 'Último Imperador de Todas as Rússias (1894–1917), Rei da Polônia e Grão-Duque da Finlândia; abdicou na Revolução de 1917 e foi executado com a família em Ecaterimburgo.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_alexandra', 'Alexandra Feodorovna', '(Alix de Hesse)', 'F', 'Neta da Rainha Vitória e última Imperatriz consorte da Rússia, esposa de Nicolau II.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_olga', 'Olga Nikolaevna', 'Romanova (Grã-Duquesa)', 'F', 'Filha primogênita do Czar Nicolau II e da Imperatriz Alexandra; atuou como enfermeira da Cruz Vermelha na Primeira Guerra Mundial.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_anastasia', 'Anastásia Nikolaevna', 'Romanova (Grã-Duquesa)', 'F', 'Quarta filha do Czar Nicolau II e da Imperatriz Alexandra, imortalizada na memória histórica do século XX.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_rom_alexei', 'Alexei Nikolaevich', 'Romanov (Czarevitch)', 'M', 'Czarevitch e último herdeiro aparente ao trono do Império Russo, filho caçula de Nicolau II.', 0, 0, 1, 'Monarquias e Casas Reais', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_rom_alex2', 'pub_rom_alexandre2', 'nascimento', 1818, 1818, 'exata', '29 de abril de 1818'),
('ev_d_pub_rom_alex2', 'pub_rom_alexandre2', 'falecimento', 1881, 1881, 'exata', '13 de março de 1881'),
('ev_b_pub_rom_malex', 'pub_rom_maria_alex', 'nascimento', 1824, 1824, 'exata', '8 de agosto de 1824'),
('ev_d_pub_rom_malex', 'pub_rom_maria_alex', 'falecimento', 1880, 1880, 'exata', '3 de junho de 1880'),
('ev_b_pub_rom_alex3', 'pub_rom_alexandre3', 'nascimento', 1845, 1845, 'exata', '10 de março de 1845'),
('ev_d_pub_rom_alex3', 'pub_rom_alexandre3', 'falecimento', 1894, 1894, 'exata', '1º de novembro de 1894'),
('ev_b_pub_rom_mfeod', 'pub_rom_maria_feod', 'nascimento', 1847, 1847, 'exata', '26 de novembro de 1847'),
('ev_d_pub_rom_mfeod', 'pub_rom_maria_feod', 'falecimento', 1928, 1928, 'exata', '13 de outubro de 1928'),
('ev_b_pub_rom_nic2', 'pub_rom_nicolau2', 'nascimento', 1868, 1868, 'exata', '18 de maio de 1868'),
('ev_d_pub_rom_nic2', 'pub_rom_nicolau2', 'falecimento', 1918, 1918, 'exata', '17 de julho de 1918'),
('ev_b_pub_rom_alexandra', 'pub_rom_alexandra', 'nascimento', 1872, 1872, 'exata', '6 de junho de 1872'),
('ev_d_pub_rom_alexandra', 'pub_rom_alexandra', 'falecimento', 1918, 1918, 'exata', '17 de julho de 1918'),
('ev_b_pub_rom_olga', 'pub_rom_olga', 'nascimento', 1895, 1895, 'exata', '15 de novembro de 1895'),
('ev_d_pub_rom_olga', 'pub_rom_olga', 'falecimento', 1918, 1918, 'exata', '17 de julho de 1918'),
('ev_b_pub_rom_anastasia', 'pub_rom_anastasia', 'nascimento', 1901, 1901, 'exata', '18 de junho de 1901'),
('ev_d_pub_rom_anastasia', 'pub_rom_anastasia', 'falecimento', 1918, 1918, 'exata', '17 de julho de 1918'),
('ev_b_pub_rom_alexei', 'pub_rom_alexei', 'nascimento', 1904, 1904, 'exata', '12 de agosto de 1904'),
('ev_d_pub_rom_alexei', 'pub_rom_alexei', 'falecimento', 1918, 1918, 'exata', '17 de julho de 1918');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_romanov', 'Dinastia Romanov (Império Russo)', 'Casa Imperial da Rússia: de Alexandre II (o Libertador) e Alexandre III ao último Czar Nicolau II, Alexandra e seus filhos.', 'pub_rom_alexandre2', 1, 'Monarquias e Casas Reais', 'Rússia', '1818–1928', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_rom_alex2', 'pub_rom_alexandre2', 'pub_rom_maria_alex', 'casamento', 'Casamento imperial em 1841'),
('pub_u_rom_alex3', 'pub_rom_alexandre3', 'pub_rom_maria_feod', 'casamento', 'Casamento imperial em 1866'),
('pub_u_rom_nic2', 'pub_rom_nicolau2', 'pub_rom_alexandra', 'casamento', 'Casamento imperial em São Petersburgo em 1894');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_rom_alex2', 'pub_rom_alexandre3', 'biologico', 1),
('pub_u_rom_alex3', 'pub_rom_nicolau2', 'biologico', 1),
('pub_u_rom_nic2', 'pub_rom_olga', 'biologico', 1),
('pub_u_rom_nic2', 'pub_rom_anastasia', 'biologico', 2),
('pub_u_rom_nic2', 'pub_rom_alexei', 'biologico', 3);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_romanov', 'pub_rom_alexandre2', NULL),
('pub_arv_romanov', 'pub_rom_maria_alex', NULL),
('pub_arv_romanov', 'pub_rom_alexandre3', NULL),
('pub_arv_romanov', 'pub_rom_maria_feod', NULL),
('pub_arv_romanov', 'pub_rom_nicolau2', NULL),
('pub_arv_romanov', 'pub_rom_alexandra', NULL),
('pub_arv_romanov', 'pub_rom_olga', NULL),
('pub_arv_romanov', 'pub_rom_anastasia', NULL),
('pub_arv_romanov', 'pub_rom_alexei', NULL),
('pub_arv_romanov', NULL, 'pub_u_rom_alex2'),
('pub_arv_romanov', NULL, 'pub_u_rom_alex3'),
('pub_arv_romanov', NULL, 'pub_u_rom_nic2');

-- 25.4 Casa de Médici (Senhores de Florença e Mecenas do Renascimento)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_med_giovanni_bicci', 'Giovanni di Bicci', 'de’ Medici', 'M', 'Banqueiro italiano e fundador do Banco Médici em 1397, que consolidou o poder econômico e político da Casa de Médici em Florença.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_piccarda', 'Piccarda', 'Bueri de’ Medici', 'F', 'Nobre florentina, esposa de Giovanni di Bicci e mãe de Cosme de’ Medici.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_cosimo', 'Cosimo', 'de’ Medici (Cosme, o Velho)', 'M', 'Senhor de fato da República de Florença, titulado Pater Patriae ("Pai da Pátria"), grande mecenas de Donatello, Brunelleschi e Marsilio Ficino.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_contessina', 'Contessina', 'de’ Bardi', 'F', 'Esposa de Cosme de’ Medici e avó e mentora de Lourenço, o Magnífico.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_piero', 'Piero', 'de’ Medici (o Gotoso)', 'M', 'Senhor de fato de Florença (1464–1469), colecionador de arte e pai de Lourenço e Giuliano de’ Medici.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_lucrezia', 'Lucrezia', 'Tornabuoni', 'F', 'Poetisa renascentista, conselheira política e mãe de Lourenço, o Magnífico.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_lorenzo', 'Lorenzo', 'de’ Medici (Lourenço, o Magnífico)', 'M', 'Estadista, poeta e governante de Florença no apogeu da Renascença Italiana; mecenas de Michelangelo, Botticelli e Leonardo da Vinci.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_giuliano', 'Giuliano', 'de’ Medici', 'M', 'Irmão e cogovernante de Lourenço, o Magnífico; assassinado na Catedral de Florença durante a Conspiração dos Pazzi em 1478.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_clarice', 'Clarice', 'Orsini de’ Medici', 'F', 'Aristocrata romana da família Orsini, esposa de Lourenço, o Magnífico e mãe do Papa Leão X.', 0, 0, 1, 'Monarquias e Casas Reais', 'real'),
('pub_med_leao10', 'Papa Leão X', '(Giovanni di Lorenzo de’ Medici)', 'M', 'Segundo filho de Lourenço, o Magnífico; Sumo Pontífice da Igreja Católica (1513–1521) e mecenas de Rafael Sanzio em Roma.', 0, 0, 1, 'Monarquias e Casas Reais', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_med_giov', 'pub_med_giovanni_bicci', 'nascimento', 1360, 1360, 'exata', '1360'),
('ev_d_pub_med_giov', 'pub_med_giovanni_bicci', 'falecimento', 1429, 1429, 'exata', '20 de fevereiro de 1429'),
('ev_b_pub_med_picc', 'pub_med_piccarda', 'nascimento', 1368, 1368, 'exata', '1368'),
('ev_d_pub_med_picc', 'pub_med_piccarda', 'falecimento', 1433, 1433, 'exata', '19 de abril de 1433'),
('ev_b_pub_med_cos', 'pub_med_cosimo', 'nascimento', 1389, 1389, 'exata', '27 de setembro de 1389'),
('ev_d_pub_med_cos', 'pub_med_cosimo', 'falecimento', 1464, 1464, 'exata', '1º de agosto de 1464'),
('ev_b_pub_med_cont', 'pub_med_contessina', 'nascimento', 1390, 1390, 'exata', '1390'),
('ev_d_pub_med_cont', 'pub_med_contessina', 'falecimento', 1473, 1473, 'exata', 'outubro de 1473'),
('ev_b_pub_med_piero', 'pub_med_piero', 'nascimento', 1416, 1416, 'exata', '19 de setembro de 1416'),
('ev_d_pub_med_piero', 'pub_med_piero', 'falecimento', 1469, 1469, 'exata', '2 de dezembro de 1469'),
('ev_b_pub_med_lucr', 'pub_med_lucrezia', 'nascimento', 1427, 1427, 'exata', '22 de junho de 1427'),
('ev_d_pub_med_lucr', 'pub_med_lucrezia', 'falecimento', 1482, 1482, 'exata', '25 de março de 1482'),
('ev_b_pub_med_lor', 'pub_med_lorenzo', 'nascimento', 1449, 1449, 'exata', '1º de janeiro de 1449'),
('ev_d_pub_med_lor', 'pub_med_lorenzo', 'falecimento', 1492, 1492, 'exata', '8 de abril de 1492'),
('ev_b_pub_med_giul', 'pub_med_giuliano', 'nascimento', 1453, 1453, 'exata', '25 de outubro de 1453'),
('ev_d_pub_med_giul', 'pub_med_giuliano', 'falecimento', 1478, 1478, 'exata', '26 de abril de 1478'),
('ev_b_pub_med_clar', 'pub_med_clarice', 'nascimento', 1453, 1453, 'exata', '1453'),
('ev_d_pub_med_clar', 'pub_med_clarice', 'falecimento', 1488, 1488, 'exata', '30 de julho de 1488'),
('ev_b_pub_med_leao', 'pub_med_leao10', 'nascimento', 1475, 1475, 'exata', '11 de dezembro de 1475'),
('ev_d_pub_med_leao', 'pub_med_leao10', 'falecimento', 1521, 1521, 'exata', '1º de dezembro de 1521');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_medici', 'Casa de Médici (Florença e Renascimento)', 'Dinastia de banqueiros, governantes e papas de Florença que patrocinou o florescimento do Renascimento italiano, de Giovanni di Bicci e Cosme a Lourenço, o Magnífico.', 'pub_med_giovanni_bicci', 1, 'Monarquias e Casas Reais', 'Itália (Florença)', '1360–1521', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_med_giov_picc', 'pub_med_giovanni_bicci', 'pub_med_piccarda', 'casamento', 'Fundadores da Casa de Médici'),
('pub_u_med_cos_cont', 'pub_med_cosimo', 'pub_med_contessina', 'casamento', 'Casamento em Florença c. 1415'),
('pub_u_med_piero_lucr', 'pub_med_piero', 'pub_med_lucrezia', 'casamento', 'Casamento em 1444'),
('pub_u_med_lor_clar', 'pub_med_lorenzo', 'pub_med_clarice', 'casamento', 'Casamento em 1469');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_med_giov_picc', 'pub_med_cosimo', 'biologico', 1),
('pub_u_med_cos_cont', 'pub_med_piero', 'biologico', 1),
('pub_u_med_piero_lucr', 'pub_med_lorenzo', 'biologico', 1),
('pub_u_med_piero_lucr', 'pub_med_giuliano', 'biologico', 2),
('pub_u_med_lor_clar', 'pub_med_leao10', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_medici', 'pub_med_giovanni_bicci', NULL),
('pub_arv_medici', 'pub_med_piccarda', NULL),
('pub_arv_medici', 'pub_med_cosimo', NULL),
('pub_arv_medici', 'pub_med_contessina', NULL),
('pub_arv_medici', 'pub_med_piero', NULL),
('pub_arv_medici', 'pub_med_lucrezia', NULL),
('pub_arv_medici', 'pub_med_lorenzo', NULL),
('pub_arv_medici', 'pub_med_giuliano', NULL),
('pub_arv_medici', 'pub_med_clarice', NULL),
('pub_arv_medici', 'pub_med_leao10', NULL),
('pub_arv_medici', NULL, 'pub_u_med_giov_picc'),
('pub_arv_medici', NULL, 'pub_u_med_cos_cont'),
('pub_arv_medici', NULL, 'pub_u_med_piero_lucr'),
('pub_arv_medici', NULL, 'pub_u_med_lor_clar');

-- 25.5 Simón Bolívar e Família Bolívar (O Libertador da América do Sul)
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_bol_juan_vicente_pai', 'Juan Vicente', 'Bolívar y Ponte', 'M', 'Coronel das Milícias de Aragua e aristocrata mantuano de Caracas; pai de Simón Bolívar.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_bol_concepcion_mae', 'María de la Concepción', 'Palacios y Blanco', 'F', 'Nobre caraqueña de fina cultura musical e literária; mãe de Simón Bolívar.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_bol_maria_antonia', 'María Antonia', 'Bolívar Palacios', 'F', 'Irmã primogênita e correspondente constante de Simón Bolívar em Caracas.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_bol_juana', 'Juana', 'Bolívar Palacios', 'F', 'Segunda irmã de Simón Bolívar, ativa no apoio à causa emancipacionista.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_bol_simon_bolivar', 'Simón', 'Bolívar (El Libertador)', 'M', 'Líder militar e estadista venezuelano que conduziu a independência da Venezuela, Colômbia, Equador, Peru, Panamá e Bolívia; Presidente da Grã-Colômbia.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real'),
('pub_bol_maria_teresa', 'María Teresa', 'Rodríguez del Toro y Alayza', 'F', 'Aristocrata madrilenha e esposa de Simón Bolívar, cuja morte precoce por febre amarela em Caracas marcou o rumo político do Libertador.', 0, 0, 1, 'Chefes de Estado e Lideranças Políticas', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_bol_pai', 'pub_bol_juan_vicente_pai', 'nascimento', 1726, 1726, 'exata', '15 de outubro de 1726'),
('ev_d_pub_bol_pai', 'pub_bol_juan_vicente_pai', 'falecimento', 1786, 1786, 'exata', '19 de janeiro de 1786'),
('ev_b_pub_bol_mae', 'pub_bol_concepcion_mae', 'nascimento', 1758, 1758, 'exata', '9 de dezembro de 1758'),
('ev_d_pub_bol_mae', 'pub_bol_concepcion_mae', 'falecimento', 1792, 1792, 'exata', '6 de julho de 1792'),
('ev_b_pub_bol_mant', 'pub_bol_maria_antonia', 'nascimento', 1777, 1777, 'exata', '1º de novembro de 1777'),
('ev_d_pub_bol_mant', 'pub_bol_maria_antonia', 'falecimento', 1842, 1842, 'exata', '7 de outubro de 1842'),
('ev_b_pub_bol_juana', 'pub_bol_juana', 'nascimento', 1779, 1779, 'exata', '16 de maio de 1779'),
('ev_d_pub_bol_juana', 'pub_bol_juana', 'falecimento', 1847, 1847, 'exata', '7 de março de 1847'),
('ev_b_pub_bol_simon', 'pub_bol_simon_bolivar', 'nascimento', 1783, 1783, 'exata', '24 de julho de 1783'),
('ev_d_pub_bol_simon', 'pub_bol_simon_bolivar', 'falecimento', 1830, 1830, 'exata', '17 de dezembro de 1830'),
('ev_b_pub_bol_mteresa', 'pub_bol_maria_teresa', 'nascimento', 1781, 1781, 'exata', '15 de outubro de 1781'),
('ev_d_pub_bol_mteresa', 'pub_bol_maria_teresa', 'falecimento', 1803, 1803, 'exata', '22 de janeiro de 1803');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_bolivar', 'Simón Bolívar e Família Bolívar (O Libertador)', 'Linhagem caraqueña de Simón Bolívar, o Libertador de seis nações sul-americanas e líder da emancipação hispano-americana.', 'pub_bol_juan_vicente_pai', 1, 'Chefes de Estado e Lideranças Políticas', 'Venezuela / Grã-Colômbia', '1726–1847', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_bol_pais', 'pub_bol_juan_vicente_pai', 'pub_bol_concepcion_mae', 'casamento', 'Casamento em Caracas em 1773'),
('pub_u_bol_simon_mteresa', 'pub_bol_simon_bolivar', 'pub_bol_maria_teresa', 'casamento', 'Casamento em Madrid em 26 de maio de 1802');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_bol_pais', 'pub_bol_maria_antonia', 'biologico', 1),
('pub_u_bol_pais', 'pub_bol_juana', 'biologico', 2),
('pub_u_bol_pais', 'pub_bol_simon_bolivar', 'biologico', 3);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_bolivar', 'pub_bol_juan_vicente_pai', NULL),
('pub_arv_bolivar', 'pub_bol_concepcion_mae', NULL),
('pub_arv_bolivar', 'pub_bol_maria_antonia', NULL),
('pub_arv_bolivar', 'pub_bol_juana', NULL),
('pub_arv_bolivar', 'pub_bol_simon_bolivar', NULL),
('pub_arv_bolivar', 'pub_bol_maria_teresa', NULL),
('pub_arv_bolivar', NULL, 'pub_u_bol_pais'),
('pub_arv_bolivar', NULL, 'pub_u_bol_simon_mteresa');

-- 25.6 Tiradentes (Joaquim José da Silva Xavier) e Família Silva Xavier
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_tir_domingos_pai', 'Domingos', 'da Silva dos Santos', 'M', 'Proprietário rural português na Fazenda do Pombal (Capitania de Minas Gerais) e almotacé da Câmara de São João del-Rei; pai de Tiradentes.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_tir_antonia_mae', 'Antônia', 'da Encarnação Xavier', 'F', 'Natural de São José del-Rei (atual Tiradentes, MG), mãe de Joaquim José da Silva Xavier (Tiradentes).', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_tir_pe_domingos', 'Padre Domingos', 'da Silva Xavier', 'M', 'Sacerdote católico e irmão mais velho e preceptor de Tiradentes em Minas Gerais.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_tir_tiradentes', 'Tiradentes', '(Joaquim José da Silva Xavier)', 'M', 'Alferes do Regimento de Cavalaria Regular de Minas Gerais, dentista prático, minerador e mártir da Inconfidência Mineira (1789); Patrono Cívico da Nação Brasileira.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_tir_antonia_comp', 'Antônia Maria', 'do Espírito Santo', 'F', 'Companheira de Joaquim José da Silva Xavier em Vila Rica (Ouro Preto) e mãe de sua filha Joaquina.', 0, 0, 1, 'História e Sociedade Brasileira', 'real'),
('pub_tir_joaquina_filha', 'Joaquina', 'de Paula da Silva Xavier', 'F', 'Filha de Tiradentes e Antônia Maria do Espírito Santo nascida em Vila Rica.', 0, 0, 1, 'História e Sociedade Brasileira', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_tir_pai', 'pub_tir_domingos_pai', 'nascimento', 1698, 1698, 'cerca_de', 'c. 1698'),
('ev_d_pub_tir_pai', 'pub_tir_domingos_pai', 'falecimento', 1757, 1757, 'exata', '1757'),
('ev_b_pub_tir_mae', 'pub_tir_antonia_mae', 'nascimento', 1721, 1721, 'exata', '1721'),
('ev_d_pub_tir_mae', 'pub_tir_antonia_mae', 'falecimento', 1755, 1755, 'exata', '1755'),
('ev_b_pub_tir_pedom', 'pub_tir_pe_domingos', 'nascimento', 1738, 1738, 'exata', '1738'),
('ev_d_pub_tir_pedom', 'pub_tir_pe_domingos', 'falecimento', 1800, 1800, 'cerca_de', 'c. 1800'),
('ev_b_pub_tir_tirad', 'pub_tir_tiradentes', 'nascimento', 1746, 1746, 'exata', '12 de novembro de 1746'),
('ev_d_pub_tir_tirad', 'pub_tir_tiradentes', 'falecimento', 1792, 1792, 'exata', '21 de abril de 1792'),
('ev_b_pub_tir_acomp', 'pub_tir_antonia_comp', 'nascimento', 1765, 1765, 'cerca_de', 'c. 1765'),
('ev_b_pub_tir_joaq', 'pub_tir_joaquina_filha', 'nascimento', 1786, 1786, 'exata', '1786');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_tiradentes', 'Tiradentes e Família Silva Xavier (Inconfidência Mineira)', 'Linhagem mineira da Fazenda do Pombal e Vila Rica centrada no Alferes Joaquim José da Silva Xavier (Tiradentes), mártir da Inconfidência Mineira.', 'pub_tir_domingos_pai', 1, 'História e Sociedade Brasileira', 'Brasil', '1698–1830', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_tir_pais', 'pub_tir_domingos_pai', 'pub_tir_antonia_mae', 'casamento', 'Casamento em 1738 na Fazenda do Pombal'),
('pub_u_tir_antonia', 'pub_tir_tiradentes', 'pub_tir_antonia_comp', 'estavel', 'União em Vila Rica (Ouro Preto)');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_tir_pais', 'pub_tir_pe_domingos', 'biologico', 1),
('pub_u_tir_pais', 'pub_tir_tiradentes', 'biologico', 2),
('pub_u_tir_antonia', 'pub_tir_joaquina_filha', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_tiradentes', 'pub_tir_domingos_pai', NULL),
('pub_arv_tiradentes', 'pub_tir_antonia_mae', NULL),
('pub_arv_tiradentes', 'pub_tir_pe_domingos', NULL),
('pub_arv_tiradentes', 'pub_tir_tiradentes', NULL),
('pub_arv_tiradentes', 'pub_tir_antonia_comp', NULL),
('pub_arv_tiradentes', 'pub_tir_joaquina_filha', NULL),
('pub_arv_tiradentes', NULL, 'pub_u_tir_pais'),
('pub_arv_tiradentes', NULL, 'pub_u_tir_antonia');

-- 25.7 Louis Pasteur e Família Pasteur
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_pas_jean_joseph', 'Jean-Joseph', 'Pasteur', 'M', 'Sargento-mor condecorado com a Legião de Honra nos exércitos de Napoleão e curtidor em Dole e Arbois; pai de Louis Pasteur.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_pas_jeanne_roqui', 'Jeanne-Étiennette', 'Roqui Pasteur', 'F', 'Natural de Marnoz (Jura), esposa de Jean-Joseph e mãe de Louis Pasteur.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_pas_louis_pasteur', 'Louis', 'Pasteur', 'M', 'Químico e microbiologista francês, pai da microbiologia moderna; criou o processo de pasteurização, refutou a geração espontânea e desenvolveu as vacinas contra a raiva e o carbúnculo.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_pas_marie_laurent', 'Marie', 'Laurent Pasteur', 'F', 'Filha do reitor da Academia de Estrasburgo, esposa e colaboradora científica e editorial de Louis Pasteur no laboratório.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_pas_jean_baptiste', 'Jean-Baptiste', 'Pasteur', 'M', 'Diplomata francês e único filho homem de Louis e Marie Pasteur.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_pas_marie_louise', 'Marie-Louise', 'Pasteur Vallery-Radot', 'F', 'Filha de Louis Pasteur e esposa do escritor René Vallery-Radot, biógrafo de Pasteur.', 0, 0, 1, 'Ciência e Invenção', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_pas_jj', 'pub_pas_jean_joseph', 'nascimento', 1791, 1791, 'exata', '1791'),
('ev_d_pub_pas_jj', 'pub_pas_jean_joseph', 'falecimento', 1865, 1865, 'exata', '1865'),
('ev_b_pub_pas_jr', 'pub_pas_jeanne_roqui', 'nascimento', 1793, 1793, 'exata', '1793'),
('ev_d_pub_pas_jr', 'pub_pas_jeanne_roqui', 'falecimento', 1848, 1848, 'exata', '1848'),
('ev_b_pub_pas_louis', 'pub_pas_louis_pasteur', 'nascimento', 1822, 1822, 'exata', '27 de dezembro de 1822'),
('ev_d_pub_pas_louis', 'pub_pas_louis_pasteur', 'falecimento', 1895, 1895, 'exata', '28 de setembro de 1895'),
('ev_b_pub_pas_marie', 'pub_pas_marie_laurent', 'nascimento', 1826, 1826, 'exata', '15 de janeiro de 1826'),
('ev_d_pub_pas_marie', 'pub_pas_marie_laurent', 'falecimento', 1910, 1910, 'exata', '28 de setembro de 1910'),
('ev_b_pub_pas_jb', 'pub_pas_jean_baptiste', 'nascimento', 1850, 1850, 'exata', '1850'),
('ev_d_pub_pas_jb', 'pub_pas_jean_baptiste', 'falecimento', 1908, 1908, 'exata', '1908'),
('ev_b_pub_pas_ml', 'pub_pas_marie_louise', 'nascimento', 1858, 1858, 'exata', '1858'),
('ev_d_pub_pas_ml', 'pub_pas_marie_louise', 'falecimento', 1934, 1934, 'exata', '1934');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_pasteur', 'Louis Pasteur e Família Pasteur', 'Linhagem francesa do pai da microbiologia, criador da pasteurização e das vacinas contra a raiva e o antraz, fundador do Instituto Pasteur.', 'pub_pas_jean_joseph', 1, 'Ciência e Invenção', 'França', '1791–1934', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_pas_pais', 'pub_pas_jean_joseph', 'pub_pas_jeanne_roqui', 'casamento', 'Casamento em 1816'),
('pub_u_pas_louis_marie', 'pub_pas_louis_pasteur', 'pub_pas_marie_laurent', 'casamento', 'Casamento em Estrasburgo em 29 de maio de 1849');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pas_pais', 'pub_pas_louis_pasteur', 'biologico', 1),
('pub_u_pas_louis_marie', 'pub_pas_jean_baptiste', 'biologico', 1),
('pub_u_pas_louis_marie', 'pub_pas_marie_louise', 'biologico', 2);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_pasteur', 'pub_pas_jean_joseph', NULL),
('pub_arv_pasteur', 'pub_pas_jeanne_roqui', NULL),
('pub_arv_pasteur', 'pub_pas_louis_pasteur', NULL),
('pub_arv_pasteur', 'pub_pas_marie_laurent', NULL),
('pub_arv_pasteur', 'pub_pas_jean_baptiste', NULL),
('pub_arv_pasteur', 'pub_pas_marie_louise', NULL),
('pub_arv_pasteur', NULL, 'pub_u_pas_pais'),
('pub_arv_pasteur', NULL, 'pub_u_pas_louis_marie');

-- 25.8 Sigmund Freud e Família Freud
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_fre_jakob', 'Jakob', 'Freud', 'M', 'Comerciante de lã na Morávia e em Viena; pai de Sigmund Freud.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_amalia', 'Amalia', 'Nathansohn Freud', 'F', 'Esposa de Jakob Freud e mãe de Sigmund Freud.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_sigmund', 'Sigmund', 'Freud', 'M', 'Médico neurologista austríaco e fundador da Psicanálise; revolucionou a compreensão do inconsciente humano e autor de A Interpretação dos Sonhos.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_martha', 'Martha', 'Bernays Freud', 'F', 'Neta do rabino-chefe de Hamburgo Isaac Bernays; esposa de Sigmund Freud por cinquenta e três anos.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_martin', 'Martin', 'Freud', 'M', 'Advogado vienense e diretor da Editora Psicanalítica Internacional; filho primogênito de Sigmund Freud.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_ernst', 'Ernst L.', 'Freud', 'M', 'Arquiteto modernista em Berlim e Londres; filho de Sigmund Freud e pai do pintor Lucian Freud.', 0, 0, 1, 'Ciência e Invenção', 'real'),
('pub_fre_anna', 'Anna', 'Freud', 'F', 'Psicanalista austríaca-britânica, filha caçula de Sigmund Freud e fundadora da psicanálise infantil e da teoria dos mecanismos de defesa do ego.', 0, 0, 1, 'Ciência e Invenção', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_fre_jakob', 'pub_fre_jakob', 'nascimento', 1815, 1815, 'exata', '18 de dezembro de 1815'),
('ev_d_pub_fre_jakob', 'pub_fre_jakob', 'falecimento', 1896, 1896, 'exata', '23 de outubro de 1896'),
('ev_b_pub_fre_amalia', 'pub_fre_amalia', 'nascimento', 1835, 1835, 'exata', '18 de agosto de 1835'),
('ev_d_pub_fre_amalia', 'pub_fre_amalia', 'falecimento', 1930, 1930, 'exata', '12 de setembro de 1930'),
('ev_b_pub_fre_sigmund', 'pub_fre_sigmund', 'nascimento', 1856, 1856, 'exata', '6 de maio de 1856'),
('ev_d_pub_fre_sigmund', 'pub_fre_sigmund', 'falecimento', 1939, 1939, 'exata', '23 de setembro de 1939'),
('ev_b_pub_fre_martha', 'pub_fre_martha', 'nascimento', 1861, 1861, 'exata', '26 de julho de 1861'),
('ev_d_pub_fre_martha', 'pub_fre_martha', 'falecimento', 1951, 1951, 'exata', '2 de novembro de 1951'),
('ev_b_pub_fre_martin', 'pub_fre_martin', 'nascimento', 1889, 1889, 'exata', '7 de dezembro de 1889'),
('ev_d_pub_fre_martin', 'pub_fre_martin', 'falecimento', 1967, 1967, 'exata', '25 de abril de 1967'),
('ev_b_pub_fre_ernst', 'pub_fre_ernst', 'nascimento', 1892, 1892, 'exata', '6 de abril de 1892'),
('ev_d_pub_fre_ernst', 'pub_fre_ernst', 'falecimento', 1970, 1970, 'exata', '7 de abril de 1970'),
('ev_b_pub_fre_anna', 'pub_fre_anna', 'nascimento', 1895, 1895, 'exata', '3 de dezembro de 1895'),
('ev_d_pub_fre_anna', 'pub_fre_anna', 'falecimento', 1982, 1982, 'exata', '9 de outubro de 1982');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_freud', 'Sigmund Freud e Família Freud', 'Linhagem de Viena e Londres do fundador da Psicanálise Sigmund Freud e de sua filha e sucessora científica Anna Freud.', 'pub_fre_jakob', 1, 'Ciência e Invenção', 'Áustria / Reino Unido', '1815–1982', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_fre_pais', 'pub_fre_jakob', 'pub_fre_amalia', 'casamento', 'Casamento em Viena em 1855'),
('pub_u_fre_sigmund_martha', 'pub_fre_sigmund', 'pub_fre_martha', 'casamento', 'Casamento em 1886');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_fre_pais', 'pub_fre_sigmund', 'biologico', 1),
('pub_u_fre_sigmund_martha', 'pub_fre_martin', 'biologico', 1),
('pub_u_fre_sigmund_martha', 'pub_fre_ernst', 'biologico', 2),
('pub_u_fre_sigmund_martha', 'pub_fre_anna', 'biologico', 3);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_freud', 'pub_fre_jakob', NULL),
('pub_arv_freud', 'pub_fre_amalia', NULL),
('pub_arv_freud', 'pub_fre_sigmund', NULL),
('pub_arv_freud', 'pub_fre_martha', NULL),
('pub_arv_freud', 'pub_fre_martin', NULL),
('pub_arv_freud', 'pub_fre_ernst', NULL),
('pub_arv_freud', 'pub_fre_anna', NULL),
('pub_arv_freud', NULL, 'pub_u_fre_pais'),
('pub_arv_freud', NULL, 'pub_u_fre_sigmund_martha');

-- 25.9 Heitor Villa-Lobos e Família Villa-Lobos
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_vl_raul_pai', 'Raul', 'Villa-Lobos', 'M', 'Funcionário da Biblioteca Nacional, historiador, astrônomo amador e músico; primeiro professor de violoncelo e clarinete de seu filho Heitor Villa-Lobos.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_vl_noemia_mae', 'Noêmia Umbelina', 'Santos Monteiro Villa-Lobos', 'F', 'Mãe dedicada de Heitor Villa-Lobos no Rio de Janeiro.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_vl_heitor', 'Heitor', 'Villa-Lobos', 'M', 'O maior compositor erudito das Américas; autor das 9 Bachianas Brasileiras e dos 14 Choros, participou da Semana de Arte Moderna de 1922 e fundou o Conservatório Nacional de Canto Orfeônico.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_vl_lucilia', 'Lucília', 'Guimarães Villa-Lobos', 'F', 'Pianista concertista e professora de canto orfeônico; primeira esposa e intérprete das obras pianísticas de Heitor Villa-Lobos.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_vl_mindinha', 'Arminda', 'Neves d’Almeida (Mindinha)', 'F', 'Musicóloga, companheira de Heitor Villa-Lobos por vinte e três anos e diretora vitalícia do Museu Villa-Lobos no Rio de Janeiro.', 0, 0, 1, 'Artes, Literatura e Música', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_vl_raul', 'pub_vl_raul_pai', 'nascimento', 1862, 1862, 'exata', '1862'),
('ev_d_pub_vl_raul', 'pub_vl_raul_pai', 'falecimento', 1899, 1899, 'exata', '18 de julho de 1899'),
('ev_b_pub_vl_noemia', 'pub_vl_noemia_mae', 'nascimento', 1859, 1859, 'exata', '1859'),
('ev_d_pub_vl_noemia', 'pub_vl_noemia_mae', 'falecimento', 1946, 1946, 'exata', '1946'),
('ev_b_pub_vl_heitor', 'pub_vl_heitor', 'nascimento', 1887, 1887, 'exata', '5 de março de 1887'),
('ev_d_pub_vl_heitor', 'pub_vl_heitor', 'falecimento', 1959, 1959, 'exata', '17 de novembro de 1959'),
('ev_b_pub_vl_lucilia', 'pub_vl_lucilia', 'nascimento', 1886, 1886, 'exata', '26 de maio de 1886'),
('ev_d_pub_vl_lucilia', 'pub_vl_lucilia', 'falecimento', 1966, 1966, 'exata', '25 de maio de 1966'),
('ev_b_pub_vl_mindinha', 'pub_vl_mindinha', 'nascimento', 1912, 1912, 'exata', '8 de outubro de 1912'),
('ev_d_pub_vl_mindinha', 'pub_vl_mindinha', 'falecimento', 1985, 1985, 'exata', '5 de julho de 1985');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_villa_lobos', 'Heitor Villa-Lobos e Família Villa-Lobos', 'Linhagem carioca do maior compositor erudito das Américas, autor das Bachianas Brasileiras e dos Choros.', 'pub_vl_raul_pai', 1, 'Artes, Literatura e Música', 'Brasil', '1859–1985', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_vl_pais', 'pub_vl_raul_pai', 'pub_vl_noemia_mae', 'casamento', 'Casamento no Rio de Janeiro em 1884'),
('pub_u_vl_heitor_lucilia', 'pub_vl_heitor', 'pub_vl_lucilia', 'casamento', 'Casamento em 1913'),
('pub_u_vl_heitor_mindinha', 'pub_vl_heitor', 'pub_vl_mindinha', 'estavel', 'Companheiros de 1936 a 1959');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_vl_pais', 'pub_vl_heitor', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_villa_lobos', 'pub_vl_raul_pai', NULL),
('pub_arv_villa_lobos', 'pub_vl_noemia_mae', NULL),
('pub_arv_villa_lobos', 'pub_vl_heitor', NULL),
('pub_arv_villa_lobos', 'pub_vl_lucilia', NULL),
('pub_arv_villa_lobos', 'pub_vl_mindinha', NULL),
('pub_arv_villa_lobos', NULL, 'pub_u_vl_pais'),
('pub_arv_villa_lobos', NULL, 'pub_u_vl_heitor_lucilia'),
('pub_arv_villa_lobos', NULL, 'pub_u_vl_heitor_mindinha');

-- 25.10 Carlos Drummond de Andrade e Família Andrade
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_dru_carlos_pai', 'Carlos', 'de Paula Andrade', 'M', 'Fazendeiro em Itabira do Mato Dentro (MG); pai do poeta Carlos Drummond de Andrade.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_dru_julieta_mae', 'Julieta Augusta', 'Drummond de Andrade', 'F', 'Matriarca da família Andrade em Itabira e mãe de Carlos Drummond de Andrade.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_dru_carlos_drummond', 'Carlos', 'Drummond de Andrade', 'M', 'O maior poeta brasileiro do século XX, cronista e contista mineiro; autor de A Rosa do Povo, Sentimento do Mundo e Claro Enigma.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_dru_dolores', 'Dolores', 'Dutra de Morais Andrade', 'F', 'Esposa de Carlos Drummond de Andrade por mais de seis décadas.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_dru_maria_julieta', 'Maria Julieta', 'Drummond de Andrade', 'F', 'Escritora, cronista e tradutora; filha única sobrevivente de Carlos Drummond de Andrade e Dolores.', 0, 0, 1, 'Artes, Literatura e Música', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_dru_pai', 'pub_dru_carlos_pai', 'nascimento', 1860, 1860, 'exata', '1860'),
('ev_d_pub_dru_pai', 'pub_dru_carlos_pai', 'falecimento', 1931, 1931, 'exata', '1931'),
('ev_b_pub_dru_mae', 'pub_dru_julieta_mae', 'nascimento', 1875, 1875, 'exata', '1875'),
('ev_d_pub_dru_mae', 'pub_dru_julieta_mae', 'falecimento', 1948, 1948, 'exata', '1948'),
('ev_b_pub_dru_cda', 'pub_dru_carlos_drummond', 'nascimento', 1902, 1902, 'exata', '31 de outubro de 1902'),
('ev_d_pub_dru_cda', 'pub_dru_carlos_drummond', 'falecimento', 1987, 1987, 'exata', '17 de agosto de 1987'),
('ev_b_pub_dru_dolores', 'pub_dru_dolores', 'nascimento', 1904, 1904, 'exata', '1904'),
('ev_d_pub_dru_dolores', 'pub_dru_dolores', 'falecimento', 2005, 2005, 'exata', '2005'),
('ev_b_pub_dru_mj', 'pub_dru_maria_julieta', 'nascimento', 1928, 1928, 'exata', '4 de março de 1928'),
('ev_d_pub_dru_mj', 'pub_dru_maria_julieta', 'falecimento', 1987, 1987, 'exata', '5 de agosto de 1987');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_drummond', 'Carlos Drummond de Andrade e Família Andrade', 'Linhagem mineira de Itabira do maior poeta moderno da língua portuguesa no Brasil, autor de Sentimento do Mundo e A Rosa do Povo.', 'pub_dru_carlos_pai', 1, 'Artes, Literatura e Música', 'Brasil', '1860–2005', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_dru_pais', 'pub_dru_carlos_pai', 'pub_dru_julieta_mae', 'casamento', 'Pais de Carlos Drummond de Andrade em Itabira'),
('pub_u_dru_cda_dolores', 'pub_dru_carlos_drummond', 'pub_dru_dolores', 'casamento', 'Casamento em Belo Horizonte em 1925');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_dru_pais', 'pub_dru_carlos_drummond', 'biologico', 1),
('pub_u_dru_cda_dolores', 'pub_dru_maria_julieta', 'biologico', 1);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_drummond', 'pub_dru_carlos_pai', NULL),
('pub_arv_drummond', 'pub_dru_julieta_mae', NULL),
('pub_arv_drummond', 'pub_dru_carlos_drummond', NULL),
('pub_arv_drummond', 'pub_dru_dolores', NULL),
('pub_arv_drummond', 'pub_dru_maria_julieta', NULL),
('pub_arv_drummond', NULL, 'pub_u_dru_pais'),
('pub_arv_drummond', NULL, 'pub_u_dru_cda_dolores');

-- 25.11 Monteiro Lobato e Família Lobato
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_lob_jose_bento_pai', 'José Bento', 'Marcondes Lobato', 'M', 'Fazendeiro cafeeiro em Taubaté (Vale do Paraíba); pai de Monteiro Lobato.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_olimpia_mae', 'Olímpia Augusta', 'Monteiro Lobato', 'F', 'Filha do Visconde de Tremembé (José Francisco Monteiro); mãe de Monteiro Lobato.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_monteiro_lobato', 'Monteiro', 'Lobato (José Bento Renato)', 'M', 'Escritor, editor pioneiro e criador do Sítio do Picapau Amarelo e da literatura infantojuvenil brasileira, além de autor de Urupês.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_purezinha', 'Maria Pureza', 'da Natividade (Purezinha)', 'F', 'Esposa dedicada de Monteiro Lobato, com quem teve quatro filhos.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_martha', 'Martha', 'Monteiro Lobato', 'F', 'Primogênita de Monteiro Lobato e Purezinha.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_edgard', 'Edgard', 'Monteiro Lobato', 'M', 'Segundo filho e tradutor parceiro de Monteiro Lobato.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_guilherme', 'Guilherme', 'Monteiro Lobato', 'M', 'Terceiro filho de Monteiro Lobato e Purezinha.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_lob_ruth', 'Ruth', 'Monteiro Lobato', 'F', 'Filha caçula de Monteiro Lobato e Purezinha.', 0, 0, 1, 'Artes, Literatura e Música', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_lob_pai', 'pub_lob_jose_bento_pai', 'nascimento', 1856, 1856, 'exata', '1856'),
('ev_d_pub_lob_pai', 'pub_lob_jose_bento_pai', 'falecimento', 1898, 1898, 'exata', '13 de junho de 1898'),
('ev_b_pub_lob_mae', 'pub_lob_olimpia_mae', 'nascimento', 1863, 1863, 'exata', '1863'),
('ev_d_pub_lob_mae', 'pub_lob_olimpia_mae', 'falecimento', 1899, 1899, 'exata', '1899'),
('ev_b_pub_lob_ml', 'pub_lob_monteiro_lobato', 'nascimento', 1882, 1882, 'exata', '18 de abril de 1882'),
('ev_d_pub_lob_ml', 'pub_lob_monteiro_lobato', 'falecimento', 1948, 1948, 'exata', '4 de julho de 1948'),
('ev_b_pub_lob_pur', 'pub_lob_purezinha', 'nascimento', 1885, 1885, 'exata', '1885'),
('ev_d_pub_lob_pur', 'pub_lob_purezinha', 'falecimento', 1959, 1959, 'exata', '1959'),
('ev_b_pub_lob_martha', 'pub_lob_martha', 'nascimento', 1909, 1909, 'exata', '1909'),
('ev_d_pub_lob_martha', 'pub_lob_martha', 'falecimento', 1996, 1996, 'exata', '1996'),
('ev_b_pub_lob_edgard', 'pub_lob_edgard', 'nascimento', 1910, 1910, 'exata', '1910'),
('ev_d_pub_lob_edgard', 'pub_lob_edgard', 'falecimento', 1942, 1942, 'exata', '1942'),
('ev_b_pub_lob_guil', 'pub_lob_guilherme', 'nascimento', 1912, 1912, 'exata', '1912'),
('ev_d_pub_lob_guil', 'pub_lob_guilherme', 'falecimento', 1939, 1939, 'exata', '1939'),
('ev_b_pub_lob_ruth', 'pub_lob_ruth', 'nascimento', 1916, 1916, 'exata', '1916'),
('ev_d_pub_lob_ruth', 'pub_lob_ruth', 'falecimento', 1972, 1972, 'exata', '1972');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_monteiro_lobato', 'Monteiro Lobato e Família Lobato', 'Linhagem de Taubaté do pai da literatura infantojuvenil brasileira, criador do Sítio do Picapau Amarelo e revolucionário editorial do Brasil.', 'pub_lob_jose_bento_pai', 1, 'Artes, Literatura e Música', 'Brasil', '1856–1996', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_lob_pais', 'pub_lob_jose_bento_pai', 'pub_lob_olimpia_mae', 'casamento', 'Pais de Monteiro Lobato em Taubaté'),
('pub_u_lob_ml_pur', 'pub_lob_monteiro_lobato', 'pub_lob_purezinha', 'casamento', 'Casamento em Taubaté em 28 de março de 1908');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_lob_pais', 'pub_lob_monteiro_lobato', 'biologico', 1),
('pub_u_lob_ml_pur', 'pub_lob_martha', 'biologico', 1),
('pub_u_lob_ml_pur', 'pub_lob_edgard', 'biologico', 2),
('pub_u_lob_ml_pur', 'pub_lob_guilherme', 'biologico', 3),
('pub_u_lob_ml_pur', 'pub_lob_ruth', 'biologico', 4);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_monteiro_lobato', 'pub_lob_jose_bento_pai', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_olimpia_mae', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_monteiro_lobato', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_purezinha', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_martha', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_edgard', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_guilherme', NULL),
('pub_arv_monteiro_lobato', 'pub_lob_ruth', NULL),
('pub_arv_monteiro_lobato', NULL, 'pub_u_lob_pais'),
('pub_arv_monteiro_lobato', NULL, 'pub_u_lob_ml_pur');

-- 25.12 Pablo Picasso e Família Ruiz Picasso
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_pic_jose_ruiz', 'José', 'Ruiz y Blasco', 'M', 'Pintor naturalista espanhol, curador de museu e professor de desenho em Málaga, Corunha e Barcelona; pai e primeiro mestre de Pablo Picasso.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_maria_picasso', 'María', 'Picasso y López', 'F', 'Nascida em Málaga de ascendência genovesa, mãe de Pablo Picasso, que adotou seu sobrenome artístico.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_pablo_picasso', 'Pablo', 'Ruiz Picasso', 'M', 'Pintor, escultor e ceramista espanhol, cofundador do Cubismo e um dos artistas mais influentes do século XX, autor de Guernica e Les Demoiselles d’Avignon.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_lola', 'Dolores (Lola)', 'Ruiz Picasso', 'F', 'Irmã e modelo constante das obras da juventude de Pablo Picasso.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_olga', 'Olga', 'Khokhlova Picasso', 'F', 'Bailarina russa dos Ballets Russes de Diaghilev; primeira esposa de Pablo Picasso e mãe de Paulo.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_paulo', 'Paulo', 'Ruiz Picasso', 'M', 'Filho primogênito de Pablo Picasso e Olga Khokhlova, retratado no célebre quadro Paulo como Arlequim.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_francoise', 'Françoise', 'Gilot', 'F', 'Pintora e escritora francesa aclamada, companheira de Pablo Picasso entre 1943 e 1953 e mãe de Claude e Paloma Picasso.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_claude', 'Claude', 'Ruiz Picasso', 'M', 'Fotógrafo, cineasta e administrador do espólio artístico de Picasso; filho de Pablo Picasso e Françoise Gilot.', 0, 0, 1, 'Artes, Literatura e Música', 'real'),
('pub_pic_paloma', 'Paloma', 'Picasso', 'F', 'Designer de joias e criadora de moda franco-espanhola de renome mundial; filha de Pablo Picasso e Françoise Gilot.', 1, 0, 1, 'Artes, Literatura e Música', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_pic_jose', 'pub_pic_jose_ruiz', 'nascimento', 1838, 1838, 'exata', '1838'),
('ev_d_pub_pic_jose', 'pub_pic_jose_ruiz', 'falecimento', 1913, 1913, 'exata', '1913'),
('ev_b_pub_pic_maria', 'pub_pic_maria_picasso', 'nascimento', 1855, 1855, 'exata', '1855'),
('ev_d_pub_pic_maria', 'pub_pic_maria_picasso', 'falecimento', 1939, 1939, 'exata', '1939'),
('ev_b_pub_pic_pablo', 'pub_pic_pablo_picasso', 'nascimento', 1881, 1881, 'exata', '25 de outubro de 1881'),
('ev_d_pub_pic_pablo', 'pub_pic_pablo_picasso', 'falecimento', 1973, 1973, 'exata', '8 de abril de 1973'),
('ev_b_pub_pic_lola', 'pub_pic_lola', 'nascimento', 1884, 1884, 'exata', '1884'),
('ev_d_pub_pic_lola', 'pub_pic_lola', 'falecimento', 1958, 1958, 'exata', '1958'),
('ev_b_pub_pic_olga', 'pub_pic_olga', 'nascimento', 1891, 1891, 'exata', '17 de junho de 1891'),
('ev_d_pub_pic_olga', 'pub_pic_olga', 'falecimento', 1955, 1955, 'exata', '11 de fevereiro de 1955'),
('ev_b_pub_pic_paulo', 'pub_pic_paulo', 'nascimento', 1921, 1921, 'exata', '4 de fevereiro de 1921'),
('ev_d_pub_pic_paulo', 'pub_pic_paulo', 'falecimento', 1975, 1975, 'exata', '5 de junho de 1975'),
('ev_b_pub_pic_franc', 'pub_pic_francoise', 'nascimento', 1921, 1921, 'exata', '26 de novembro de 1921'),
('ev_d_pub_pic_franc', 'pub_pic_francoise', 'falecimento', 2023, 2023, 'exata', '6 de junho de 2023'),
('ev_b_pub_pic_claude', 'pub_pic_claude', 'nascimento', 1947, 1947, 'exata', '15 de maio de 1947'),
('ev_d_pub_pic_claude', 'pub_pic_claude', 'falecimento', 2023, 2023, 'exata', '24 de agosto de 2023'),
('ev_b_pub_pic_paloma', 'pub_pic_paloma', 'nascimento', 1949, 1949, 'exata', '19 de abril de 1949');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_picasso', 'Pablo Picasso e Família Ruiz Picasso', 'Linhagem artística de Málaga, Barcelona e Paris centrada em Pablo Picasso, cofundador do Cubismo e autor de Guernica.', 'pub_pic_jose_ruiz', 1, 'Artes, Literatura e Música', 'Espanha / França', '1838–presente', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_pic_pais', 'pub_pic_jose_ruiz', 'pub_pic_maria_picasso', 'casamento', 'Pais de Pablo e Lola Picasso em Málaga'),
('pub_u_pic_pablo_olga', 'pub_pic_pablo_picasso', 'pub_pic_olga', 'casamento', 'Casamento em Paris em 1918'),
('pub_u_pic_pablo_franc', 'pub_pic_pablo_picasso', 'pub_pic_francoise', 'estavel', 'Relação em Paris e Vallauris (1943–1953)');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pic_pais', 'pub_pic_pablo_picasso', 'biologico', 1),
('pub_u_pic_pais', 'pub_pic_lola', 'biologico', 2),
('pub_u_pic_pablo_olga', 'pub_pic_paulo', 'biologico', 1),
('pub_u_pic_pablo_franc', 'pub_pic_claude', 'biologico', 1),
('pub_u_pic_pablo_franc', 'pub_pic_paloma', 'biologico', 2);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_picasso', 'pub_pic_jose_ruiz', NULL),
('pub_arv_picasso', 'pub_pic_maria_picasso', NULL),
('pub_arv_picasso', 'pub_pic_pablo_picasso', NULL),
('pub_arv_picasso', 'pub_pic_lola', NULL),
('pub_arv_picasso', 'pub_pic_olga', NULL),
('pub_arv_picasso', 'pub_pic_paulo', NULL),
('pub_arv_picasso', 'pub_pic_francoise', NULL),
('pub_arv_picasso', 'pub_pic_claude', NULL),
('pub_arv_picasso', 'pub_pic_paloma', NULL),
('pub_arv_picasso', NULL, 'pub_u_pic_pais'),
('pub_arv_picasso', NULL, 'pub_u_pic_pablo_olga'),
('pub_arv_picasso', NULL, 'pub_u_pic_pablo_franc');

-- 25.13 Henry Ford e Dinastia Industrial Ford
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES
('pub_ford_william', 'William', 'Ford', 'M', 'Imigrante irlandês de County Cork que estabeleceu fazenda em Dearborn (Michigan); pai de Henry Ford.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_mary_litogot', 'Mary', 'Litogot Ford', 'F', 'De ascendência belga-flamenga em Michigan; mãe de Henry Ford.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_henry', 'Henry', 'Ford', 'M', 'Engenheiro e pioneiro industrial norte-americano, fundador da Ford Motor Company; revolucionou a indústria mundial com a linha de montagem móvel e o automóvel Ford Modelo T.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_clara', 'Clara Jane', 'Bryant Ford', 'F', 'Esposa de Henry Ford por cinquenta e nove anos, chamada pelo marido de "The Believer" pelo apoio incondicional às suas primeiras invenções.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_edsel', 'Edsel Bryant', 'Ford', 'M', 'Filho único de Henry e Clara Ford, presidente da Ford Motor Company (1919–1943), patrono do design automotivo moderno e do Detroit Institute of Arts.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_eleanor', 'Eleanor Lowthian', 'Clay Ford', 'F', 'Filantropa norte-americana, esposa de Edsel Ford e mãe de Henry Ford II.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_henry2', 'Henry', 'Ford II', 'M', 'Presidente e CEO da Ford Motor Company (1945–1979), que reconstruiu e globalizou a montadora no pós-Segunda Guerra Mundial.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real'),
('pub_ford_william_clay', 'William Clay', 'Ford Sr.', 'M', 'Empresário industrial, neto de Henry Ford e proprietário do Detroit Lions.', 0, 0, 1, 'Grandes Empreendedores e Pioneiros', 'real');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto) VALUES
('ev_b_pub_ford_will', 'pub_ford_william', 'nascimento', 1826, 1826, 'exata', '1826'),
('ev_d_pub_ford_will', 'pub_ford_william', 'falecimento', 1905, 1905, 'exata', '1905'),
('ev_b_pub_ford_mary', 'pub_ford_mary_litogot', 'nascimento', 1839, 1839, 'exata', '1839'),
('ev_d_pub_ford_mary', 'pub_ford_mary_litogot', 'falecimento', 1876, 1876, 'exata', '1876'),
('ev_b_pub_ford_henry', 'pub_ford_henry', 'nascimento', 1863, 1863, 'exata', '30 de julho de 1863'),
('ev_d_pub_ford_henry', 'pub_ford_henry', 'falecimento', 1947, 1947, 'exata', '7 de abril de 1947'),
('ev_b_pub_ford_clara', 'pub_ford_clara', 'nascimento', 1866, 1866, 'exata', '11 de abril de 1866'),
('ev_d_pub_ford_clara', 'pub_ford_clara', 'falecimento', 1950, 1950, 'exata', '29 de setembro de 1950'),
('ev_b_pub_ford_edsel', 'pub_ford_edsel', 'nascimento', 1893, 1893, 'exata', '6 de novembro de 1893'),
('ev_d_pub_ford_edsel', 'pub_ford_edsel', 'falecimento', 1943, 1943, 'exata', '26 de maio de 1943'),
('ev_b_pub_ford_eleanor', 'pub_ford_eleanor', 'nascimento', 1896, 1896, 'exata', '1896'),
('ev_d_pub_ford_eleanor', 'pub_ford_eleanor', 'falecimento', 1976, 1976, 'exata', '1976'),
('ev_b_pub_ford_henry2', 'pub_ford_henry2', 'nascimento', 1917, 1917, 'exata', '4 de setembro de 1917'),
('ev_d_pub_ford_henry2', 'pub_ford_henry2', 'falecimento', 1987, 1987, 'exata', '29 de setembro de 1987'),
('ev_b_pub_ford_wclay', 'pub_ford_william_clay', 'nascimento', 1925, 1925, 'exata', '14 de março de 1925'),
('ev_d_pub_ford_wclay', 'pub_ford_william_clay', 'falecimento', 2014, 2014, 'exata', '9 de março de 2014');

INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_ford', 'Henry Ford e Dinastia Industrial Ford', 'Linhagem de Dearborn (Michigan) de Henry Ford, criador da linha de montagem moderna e da Ford Motor Company.', 'pub_ford_william', 1, 'Grandes Empreendedores e Pioneiros', 'Estados Unidos', '1826–2014', 'real')
ON CONFLICT(id) DO UPDATE SET nome = excluded.nome, descricao = excluded.descricao, raiz_pessoa_id = excluded.raiz_pessoa_id, categoria = excluded.categoria;

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES
('pub_u_ford_pais', 'pub_ford_william', 'pub_ford_mary_litogot', 'casamento', 'Pais de Henry Ford em Dearborn'),
('pub_u_ford_henry_clara', 'pub_ford_henry', 'pub_ford_clara', 'casamento', 'Casamento em 11 de abril de 1888'),
('pub_u_ford_edsel_eleanor', 'pub_ford_edsel', 'pub_ford_eleanor', 'casamento', 'Casamento em 1916');

INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_ford_pais', 'pub_ford_henry', 'biologico', 1),
('pub_u_ford_henry_clara', 'pub_ford_edsel', 'biologico', 1),
('pub_u_ford_edsel_eleanor', 'pub_ford_henry2', 'biologico', 1),
('pub_u_ford_edsel_eleanor', 'pub_ford_william_clay', 'biologico', 2);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES
('pub_arv_ford', 'pub_ford_william', NULL),
('pub_arv_ford', 'pub_ford_mary_litogot', NULL),
('pub_arv_ford', 'pub_ford_henry', NULL),
('pub_arv_ford', 'pub_ford_clara', NULL),
('pub_arv_ford', 'pub_ford_edsel', NULL),
('pub_arv_ford', 'pub_ford_eleanor', NULL),
('pub_arv_ford', 'pub_ford_henry2', NULL),
('pub_arv_ford', 'pub_ford_william_clay', NULL),
('pub_arv_ford', NULL, 'pub_u_ford_pais'),
('pub_arv_ford', NULL, 'pub_u_ford_henry_clara'),
('pub_arv_ford', NULL, 'pub_u_ford_edsel_eleanor');

-- ============================================================================
-- E. PADRONIZAÇÃO DEFINITIVA DAS 9 PASTAS / CATEGORIAS CANÔNICAS (SEM REDUNDÂNCIAS)
-- ============================================================================

-- 1. Tradição Bíblica (única pasta para personagens do Antigo e Novo Testamento)
UPDATE arvores SET categoria = 'Tradição Bíblica' WHERE id IN (
  'arv_biblica_david',
  'pub_arv_adao',
  'pub_arv_patriarcas_israel',
  'pub_arv_moises',
  'pub_arv_jesus_mateus',
  'pub_arv_jesus_lucas',
  'pub_arv_apostolos_jonas'
);

-- 2. Antiguidade e Dinastias Históricas (única pasta para civilizações antigas e linhagens clássicas)
UPDATE arvores SET categoria = 'Antiguidade e Dinastias Históricas' WHERE id IN (
  'pub_arv_dinastia_18',
  'pub_arv_dinastia_19',
  'pub_arv_dinastias_21_23',
  'pub_arv_julio_claudiana',
  'pub_arv_alexandre_magno',
  'pub_arv_kong_confucio',
  'pub_arv_lurie'
);

-- 3. Monarquias e Casas Reais (única pasta para casas reais e imperiais)
UPDATE arvores SET categoria = 'Monarquias e Casas Reais' WHERE id IN (
  'arv_imperial_brasil',
  'arv_real_portugal',
  'arv_real_britanica',
  'pub_arv_bourbon',
  'pub_arv_habsburgo',
  'pub_arv_casa_imperial_japao',
  'pub_arv_romanov',
  'pub_arv_medici',
  'pub_arv_outras_monarquias'
);

-- 4. Chefes de Estado e Lideranças Políticas (única pasta para presidentes, estadistas e líderes políticos)
UPDATE arvores SET categoria = 'Chefes de Estado e Lideranças Políticas' WHERE id IN (
  'arv_presidentes_brasil',
  'pub_arv_jk',
  'pub_arv_deodoro',
  'pub_arv_bolivar',
  'pub_arv_bonaparte',
  'pub_arv_washington',
  'pub_arv_jefferson',
  'pub_arv_franklin',
  'pub_arv_lincoln',
  'pub_arv_roosevelt',
  'pub_arv_kennedy',
  'pub_arv_bush',
  'pub_arv_churchill',
  'pub_arv_gandhi',
  'pub_arv_mandela',
  'pub_arv_mlk',
  'pub_arv_peron',
  'pub_arv_mussolini',
  'pub_arv_stalin',
  'pub_arv_franco',
  'pub_arv_mao',
  'pub_arv_hitler'
);

-- 5. História e Sociedade Brasileira (única pasta para heróis nacionais, diplomatas e famílias históricas do Brasil)
UPDATE arvores SET categoria = 'História e Sociedade Brasileira' WHERE id IN (
  'pub_arv_tiradentes',
  'pub_arv_independencia_1822',
  'pub_arv_maria_quiteria',
  'pub_arv_goncalves_ledo',
  'pub_arv_frei_caneca',
  'pub_arv_duque_de_caxias',
  'pub_arv_joaquim_nabuco',
  'pub_arv_ruy_barbosa',
  'pub_arv_rio_branco',
  'pub_arv_prado',
  'pub_arv_souza_queiros',
  'pub_arv_penteado'
);

-- 6. Ciência e Invenção (única pasta para cientistas, médicos, naturalistas e inventores)
UPDATE arvores SET categoria = 'Ciência e Invenção' WHERE id IN (
  'pub_arv_galileu',
  'pub_arv_newton',
  'pub_arv_darwin',
  'pub_arv_pasteur',
  'pub_arv_curie',
  'pub_arv_einstein',
  'pub_arv_tesla',
  'pub_arv_edison',
  'pub_arv_santos_dumont',
  'pub_arv_oswaldo_cruz',
  'pub_arv_freud'
);

-- 7. Artes, Literatura e Música (única pasta para pintores, escultores, compositores e escritores)
UPDATE arvores SET categoria = 'Artes, Literatura e Música' WHERE id IN (
  'pub_arv_da_vinci',
  'pub_arv_bach',
  'pub_arv_mozart',
  'pub_arv_beethoven',
  'pub_arv_dante',
  'pub_arv_shakespeare',
  'pub_arv_cervantes',
  'pub_arv_goethe',
  'pub_arv_victor_hugo',
  'pub_arv_picasso',
  'pub_arv_machado_de_assis',
  'pub_arv_chiquinha_gonzaga',
  'pub_arv_villa_lobos',
  'pub_arv_monteiro_lobato',
  'pub_arv_drummond'
);

-- 8. Grandes Empreendedores e Pioneiros (única pasta para pioneiros industriais e dinastias empresariais)
UPDATE arvores SET categoria = 'Grandes Empreendedores e Pioneiros' WHERE id IN (
  'pub_arv_visconde_de_maua',
  'pub_arv_guinle',
  'pub_arv_klabin',
  'pub_arv_matarazzo',
  'pub_arv_rockefeller',
  'pub_arv_ford'
);

-- 9. Genealogias Literárias e Ficcionais (única pasta para genealogias de obras literárias e cinema)
UPDATE arvores SET categoria = 'Genealogias Literárias e Ficcionais' WHERE id IN (
  'pub_arv_terra_cambara',
  'pub_arv_buendia',
  'pub_arv_corleone',
  'pub_arv_karamazov',
  'pub_arv_compson',
  'pub_arv_lannister',
  'pub_arv_targaryen',
  'pub_arv_skywalker'
);

-- Vincula automaticamente qualquer cônjuge ou placeholder de união ao arvore_membros de sua respectiva árvore
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
SELECT DISTINCT am.arvore_id, u.slot_masculino_id, NULL
FROM unioes u
JOIN arvore_membros am ON am.pessoa_id = u.slot_feminino_id
WHERE u.slot_masculino_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM arvore_membros am2
    WHERE am2.arvore_id = am.arvore_id AND am2.pessoa_id = u.slot_masculino_id
  );

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
SELECT DISTINCT am.arvore_id, u.slot_feminino_id, NULL
FROM unioes u
JOIN arvore_membros am ON am.pessoa_id = u.slot_masculino_id
WHERE u.slot_feminino_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM arvore_membros am2
    WHERE am2.arvore_id = am.arvore_id AND am2.pessoa_id = u.slot_feminino_id
  );

-- Limpeza geral de placeholders órfãos que ficaram sem nenhuma união ou vínculo
DELETE FROM arvore_membros
WHERE pessoa_id IN (
    SELECT p.id FROM pessoas p
    WHERE p.is_placeholder = 1
      AND NOT EXISTS (SELECT 1 FROM unioes u WHERE u.slot_masculino_id = p.id OR u.slot_feminino_id = p.id)
      AND NOT EXISTS (SELECT 1 FROM uniao_filhos uf WHERE uf.pessoa_id = p.id)
);

DELETE FROM pessoas
WHERE is_placeholder = 1
  AND NOT EXISTS (SELECT 1 FROM unioes u WHERE u.slot_masculino_id = pessoas.id OR u.slot_feminino_id = pessoas.id)
  AND NOT EXISTS (SELECT 1 FROM uniao_filhos uf WHERE uf.pessoa_id = pessoas.id);

-- Sincroniza rigorosamente pessoas.categoria com arvores.categoria para evitar pastas duplicadas na barra lateral
UPDATE pessoas
SET categoria = (
    SELECT a.categoria
    FROM arvore_membros am
    JOIN arvores a ON a.id = am.arvore_id
    WHERE am.pessoa_id = pessoas.id
    LIMIT 1
)
WHERE is_publico = 1
  AND EXISTS (
    SELECT 1 FROM arvore_membros am WHERE am.pessoa_id = pessoas.id
  );

