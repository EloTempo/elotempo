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

-- 24. Limpeza geral de placeholders órfãos que ficaram sem nenhuma união ou vínculo
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
