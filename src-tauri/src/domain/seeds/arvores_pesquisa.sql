-- 022 — Acervo expandido de árvores genealógicas de estudo e referência histórica
-- Gerado a partir do repositório de pesquisa canônica.

-- =====================================================================
-- ÁRVORE: Casa Imperial do Japão (Dinastia Yamato)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperador_jimmu', 'Jimmu', NULL, 'M', 'Fundador lendário e 1º Imperador do Japão (Trono do Crisântemo).', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperador_meiji', 'Meiji', '(Mutsuhito)', 'M', '122º Imperador do Japão; conduziu a modernização do país na Restauração Meiji.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperatriz_shoken', 'Shōken', '(Haruko Ichijō)', 'F', 'Imperatriz consorte do Imperador Meiji; patrona da Cruz Vermelha japonesa.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperador_taisho', 'Taishō', '(Yoshihito)', 'M', '123º Imperador do Japão (1912–1926); período de abertura democrática Taishō.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperatriz_teimei', 'Teimei', '(Sadako Kujō)', 'F', 'Imperatriz consorte do Imperador Taishō e mãe do Imperador Shōwa.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperador_showa', 'Shōwa', '(Hirohito)', 'M', '124º Imperador do Japão (1926–1989); reinado mais longo da história imperial.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperatriz_kojun', 'Kōjun', '(Nagako)', 'F', 'Imperatriz consorte do Imperador Shōwa (Hirohito); mãe de Akihito.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_akihito', 'Akihito', '(Imperador Emérito)', 'M', '125º Imperador (Era Heisei); primeiro a abdicar formalmente em dois séculos.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperatriz_michiko', 'Michiko', '(Michiko Shōda)', 'F', 'Imperatriz Emérita do Japão; primeira plebeia a ingressar na família imperial.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_naruhito', 'Naruhito', '(Imperador do Japão)', 'M', '126º Imperador do Japão; ascendeu ao trono em 2019 (Era Reiwa).', 1, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_imperatriz_masako', 'Masako', '(Masako Owada)', 'F', 'Imperatriz consorte do Japão; diplomata e poliglota de formação.', 1, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_aiko', 'Aiko', '(Princesa Toshi)', 'F', 'Filha única do Imperador Naruhito e da Imperatriz Masako.', 1, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_fumihito', 'Fumihito', '(Príncipe Akishino)', 'M', 'Irmão mais novo do Imperador Naruhito e herdeiro presuntivo da coroa.', 1, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_princesa_kiko', 'Kiko', '(Princesa Akishino)', 'F', 'Princesa consorte do Japão, nascida Kiko Kawashima.', 1, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_casa_imperial_japao_hisahito', 'Hisahito', '(Príncipe de Akishino)', 'M', 'Segundo na linha de sucessão ao Trono do Crisântemo japonês.', 1, 0, 1, 'Grandes Linhagens Antigas');

INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_casa_imperial_japao', 'Casa Imperial do Japão (Dinastia Yamato)', 'A mais antiga monarquia hereditária contínua do mundo (desde o Imperador Jimmu até a era moderna).', 'pub_casa_imperial_japao_imperador_jimmu', 1, 'Grandes Linhagens Antigas', 'Japão', '660 a.C. – presente');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_jimmu', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_meiji', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_shoken', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_taisho', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_teimei', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_showa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_kojun', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_akihito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_michiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_naruhito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_masako', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_aiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_fumihito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_princesa_kiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_hisahito', NULL);

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperador_jimmu', 'pub_casa_imperial_japao_imperador_jimmu', 'nascimento', -711, -711, 'cerca_de', 'cerca de 711 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperador_jimmu', 'pub_casa_imperial_japao_imperador_jimmu', 'falecimento', -585, -585, 'cerca_de', 'cerca de 585 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperador_meiji', 'pub_casa_imperial_japao_imperador_meiji', 'nascimento', 1852, 1852, 'exata', '1852');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperador_meiji', 'pub_casa_imperial_japao_imperador_meiji', 'falecimento', 1912, 1912, 'exata', '1912');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperatriz_shoken', 'pub_casa_imperial_japao_imperatriz_shoken', 'nascimento', 1849, 1849, 'exata', '1849');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperatriz_shoken', 'pub_casa_imperial_japao_imperatriz_shoken', 'falecimento', 1914, 1914, 'exata', '1914');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperador_taisho', 'pub_casa_imperial_japao_imperador_taisho', 'nascimento', 1879, 1879, 'exata', '1879');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperador_taisho', 'pub_casa_imperial_japao_imperador_taisho', 'falecimento', 1926, 1926, 'exata', '1926');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperatriz_teimei', 'pub_casa_imperial_japao_imperatriz_teimei', 'nascimento', 1884, 1884, 'exata', '1884');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperatriz_teimei', 'pub_casa_imperial_japao_imperatriz_teimei', 'falecimento', 1951, 1951, 'exata', '1951');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperador_showa', 'pub_casa_imperial_japao_imperador_showa', 'nascimento', 1901, 1901, 'exata', '1901');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperador_showa', 'pub_casa_imperial_japao_imperador_showa', 'falecimento', 1989, 1989, 'exata', '1989');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperatriz_kojun', 'pub_casa_imperial_japao_imperatriz_kojun', 'nascimento', 1903, 1903, 'exata', '1903');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_casa_imperial_japao_imperatriz_kojun', 'pub_casa_imperial_japao_imperatriz_kojun', 'falecimento', 2000, 2000, 'exata', '2000');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_akihito', 'pub_casa_imperial_japao_akihito', 'nascimento', 1933, 1933, 'exata', '1933');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperatriz_michiko', 'pub_casa_imperial_japao_imperatriz_michiko', 'nascimento', 1934, 1934, 'exata', '1934');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_naruhito', 'pub_casa_imperial_japao_naruhito', 'nascimento', 1960, 1960, 'exata', '1960');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_imperatriz_masako', 'pub_casa_imperial_japao_imperatriz_masako', 'nascimento', 1963, 1963, 'exata', '1963');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_fumihito', 'pub_casa_imperial_japao_fumihito', 'nascimento', 1965, 1965, 'exata', '1965');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_princesa_kiko', 'pub_casa_imperial_japao_princesa_kiko', 'nascimento', 1966, 1966, 'exata', '1966');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_aiko', 'pub_casa_imperial_japao_aiko', 'nascimento', 2001, 2001, 'exata', '2001');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_casa_imperial_japao_hisahito', 'pub_casa_imperial_japao_hisahito', 'nascimento', 2006, 2006, 'exata', '2006');

-- Uniões Imperiais
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_meiji_shoken', 'pub_casa_imperial_japao_imperador_meiji', 'pub_casa_imperial_japao_imperatriz_shoken', 'casamento', 'Casamento imperial em 1869');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_meiji_shoken');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_meiji_shoken', 'pub_casa_imperial_japao_imperador_taisho', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_taisho_teimei', 'pub_casa_imperial_japao_imperador_taisho', 'pub_casa_imperial_japao_imperatriz_teimei', 'casamento', 'Casamento imperial em 1900');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_taisho_teimei');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_taisho_teimei', 'pub_casa_imperial_japao_imperador_showa', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_showa_kojun', 'pub_casa_imperial_japao_imperador_showa', 'pub_casa_imperial_japao_imperatriz_kojun', 'casamento', 'Casamento imperial em 1924');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_showa_kojun');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_showa_kojun', 'pub_casa_imperial_japao_akihito', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_akihito', 'pub_casa_imperial_japao_imperatriz_michiko', 'casamento', 'Casamento imperial em 1959');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_akihito_michiko');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_naruhito', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_fumihito', 'biologico', 2);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_naruhito_masako', 'pub_casa_imperial_japao_naruhito', 'pub_casa_imperial_japao_imperatriz_masako', 'casamento', 'Casamento imperial em 1993');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_naruhito_masako');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_naruhito_masako', 'pub_casa_imperial_japao_aiko', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_japao_fumihito_kiko', 'pub_casa_imperial_japao_fumihito', 'pub_casa_imperial_japao_princesa_kiko', 'casamento', 'Casamento imperial em 1990');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_fumihito_kiko');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_japao_fumihito_kiko', 'pub_casa_imperial_japao_hisahito', 'biologico', 1);

-- ÁRVORE: Linhagem de Confúcio (Família Kong)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_shuliang_he', 'Shuliang', 'He', 'M', 'Atuação: oficial militar.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_yan_zhengzai', 'Yan', 'Zhengzai', 'F', '', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_confucio', 'Confúcio', NULL, 'M', 'Filósofo chinês; fundador do confucionismo e ancestral da linhagem documentada mais longa da história.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kong_li', 'Kong Li', '(Boyu)', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kong_ji', 'Kong Ji', '(Zisi)', 'U', 'Filósofo; a ele se atribui a "Doutrina do Meio" (Zhongyong).', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kong_lingyi', 'Kong', 'Lingyi', 'M', 'Atuação: nobre (Duque Yansheng, 76ª geração).', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kung_te_cheng', 'Kung', 'Te-cheng', 'M', '77ª geração; último Duque Yansheng e primeiro Oficial Sacrificial a Confúcio.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kung_wei_yi', 'Kung', 'Wei-yi', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kung_tsui_chang', 'Kung', 'Tsui-chang', 'M', '79ª geração; atual Oficial Sacrificial a Confúcio (Taiwan).', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kong_confucio_kong_yu_jen', 'Kong', 'Yu-jen', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_kong_confucio_confucio', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_kong_confucio_kung_te_cheng', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_kong_confucio_kung_tsui_chang', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_kong_confucio', 'Linhagem de Confúcio (Família Kong)', 'A maior árvore genealógica documentada do mundo, com mais de 80 gerações registradas.', 'pub_kong_confucio_confucio', 1, 'Grandes Linhagens Antigas', 'China', '551 a.C. – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_shuliang_he', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_yan_zhengzai', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_confucio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_li', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_ji', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_lingyi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_te_cheng', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_wei_yi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_tsui_chang', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_yu_jen', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_shuliang_he', 'pub_kong_confucio_shuliang_he', 'falecimento', -548, -548, 'cerca_de', 'cerca de 548 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_confucio', 'pub_kong_confucio_confucio', 'nascimento', -551, -551, 'cerca_de', '551 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_confucio', 'pub_kong_confucio_confucio', 'falecimento', -479, -479, 'cerca_de', '479 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kong_li', 'pub_kong_confucio_kong_li', 'nascimento', -532, -532, 'cerca_de', '532 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_kong_li', 'pub_kong_confucio_kong_li', 'falecimento', -483, -483, 'cerca_de', '483 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kong_ji', 'pub_kong_confucio_kong_ji', 'nascimento', -483, -483, 'cerca_de', 'cerca de 483 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_kong_ji', 'pub_kong_confucio_kong_ji', 'falecimento', -402, -402, 'cerca_de', 'cerca de 402 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kong_lingyi', 'pub_kong_confucio_kong_lingyi', 'nascimento', 1872, 1872, 'exata', '1872');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_kong_lingyi', 'pub_kong_confucio_kong_lingyi', 'falecimento', 1919, 1919, 'exata', '1919');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kung_te_cheng', 'pub_kong_confucio_kung_te_cheng', 'nascimento', 1920, 1920, 'exata', '1920');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_kung_te_cheng', 'pub_kong_confucio_kung_te_cheng', 'falecimento', 2008, 2008, 'exata', '2008');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kung_wei_yi', 'pub_kong_confucio_kung_wei_yi', 'nascimento', 1939, 1939, 'exata', '1939');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kong_confucio_kung_wei_yi', 'pub_kong_confucio_kung_wei_yi', 'falecimento', 1989, 1989, 'exata', '1989');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kung_tsui_chang', 'pub_kong_confucio_kung_tsui_chang', 'nascimento', 1975, 1975, 'exata', '1975');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kong_confucio_kong_yu_jen', 'pub_kong_confucio_kong_yu_jen', 'nascimento', 2006, 2006, 'exata', '2006');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p', 'pub_kong_confucio_confucio', 'pub_ph_pub_kong_confucio_confucio', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_', 'pub_kong_confucio_kung_te_cheng', 'pub_ph_pub_kong_confucio_kung_te_cheng', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan', 'pub_kong_confucio_kung_tsui_chang', 'pub_ph_pub_kong_confucio_kung_tsui_chang', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p', 'pub_kong_confucio_kong_li', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_', 'pub_kong_confucio_kung_wei_yi', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan', 'pub_kong_confucio_kong_yu_jen', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Lurie / Luria
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lurie_rashi', 'Rashi', '(Shlomo Yitzchaki)', 'M', 'Rabino e eminente comentarista da Torá e Talmud em Troyes; tradição genealógica rabínica documenta sua ascendência à Casa Real de Davi.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lurie_jehiel_luria', 'Jehiel', 'Luria', 'M', 'Rabino e erudito; primeiro a fixar o sobrenome Luria e chefe do tribunal rabínico de Brest-Litovsk.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lurie_solomon_luria', 'Solomon Luria', '(Maharshal)', 'M', 'O "Maharshal" (1510–1573); líder haláchico da Polônia e Lituânia, autor do Yam Shel Shlomo.', 0, 0, 1, 'Grandes Linhagens Antigas');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lurie_david_luria', 'David', 'Luria', 'M', 'O "Radal" (1798–1855); rabino, teólogo, comentarista e líder comunal em Bykhaw.', 0, 0, 1, 'Grandes Linhagens Antigas');

INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_lurie', 'Família Lurie / Luria', 'Uma das mais antigas linhagens documentadas da diáspora judaica, com tradição rabínica remontando a Rashi e à Casa de Davi.', 'pub_lurie_rashi', 1, 'Grandes Linhagens Antigas', 'Europa Oriental / Lituânia', 'Séc. XI – presente');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_lurie', 'pub_lurie_rashi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_lurie', 'pub_lurie_jehiel_luria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_lurie', 'pub_lurie_solomon_luria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_lurie', 'pub_lurie_david_luria', NULL);

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_lurie_rashi', 'pub_lurie_rashi', 'nascimento', 1040, 1040, 'exata', '1040');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_lurie_rashi', 'pub_lurie_rashi', 'falecimento', 1105, 1105, 'exata', '1105');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_lurie_jehiel_luria', 'pub_lurie_jehiel_luria', 'nascimento', 1400, 1400, 'cerca_de', 'cerca de 1400');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_lurie_solomon_luria', 'pub_lurie_solomon_luria', 'nascimento', 1510, 1510, 'cerca_de', 'cerca de 1510');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_lurie_solomon_luria', 'pub_lurie_solomon_luria', 'falecimento', 1573, 1573, 'exata', '1573');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_lurie_david_luria', 'pub_lurie_david_luria', 'nascimento', 1798, 1798, 'exata', '1798');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_lurie_david_luria', 'pub_lurie_david_luria', 'falecimento', 1855, 1855, 'exata', '1855');

-- Conexões de transmissão da linhagem rabínica Lurie
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_lurie_rashi_jehiel', 'pub_lurie_rashi', 'pub_lurie_rashi', 'nao_informado', 'Descendência rabínica até Jehiel Luria');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lurie', NULL, 'pub_u_lurie_rashi_jehiel');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_lurie_rashi_jehiel', 'pub_lurie_jehiel_luria', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_lurie_jehiel_solomon', 'pub_lurie_jehiel_luria', 'pub_lurie_jehiel_luria', 'nao_informado', 'Linhagem Luria até o Maharshal');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lurie', NULL, 'pub_u_lurie_jehiel_solomon');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_lurie_jehiel_solomon', 'pub_lurie_solomon_luria', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_lurie_solomon_david', 'pub_lurie_solomon_luria', 'pub_lurie_solomon_luria', 'nao_informado', 'Linhagem Luria até David Luria (Radal)');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lurie', NULL, 'pub_u_lurie_solomon_david');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_lurie_solomon_david', 'pub_lurie_david_luria', 'biologico', 1);

-- ÁRVORE: Dinastia Musical Bach
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_veit_bach', 'Veit (Vitus)', 'Bach', 'M', 'Ancestral fundador da dinastia; padeiro que se fixou em Wechmar, na Turíngia.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_johann_ambrosius_bach', 'Johann Ambrosius', 'Bach', 'M', 'Atuação: violinista; trompetista (músico da cidade de Eisenach).', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_johann_sebastian_bach', 'Johann Sebastian', 'Bach', 'M', 'Compositor e organista do Barroco; o membro mais célebre da família.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_maria_barbara_bach', 'Maria Barbara', 'Bach', 'F', '', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_anna_magdalena_bach', 'Anna Magdalena', 'Bach', 'F', 'Atuação: soprano.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_wilhelm_friedemann_bach', 'Wilhelm Friedemann', 'Bach', 'M', 'Compositor e organista; filho mais velho de J.S. Bach ("Bach de Halle").', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_carl_philipp_emanuel_bach', 'Carl Philipp Emanuel', 'Bach', 'M', 'Compositor; no séc. XVIII chegou a ser mais famoso que o pai ("Bach de Berlim/Hamburgo").', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_johann_christoph_friedrich_bach', 'Johann Christoph Friedrich', 'Bach', 'M', 'Atuação: compositor ("Bach de Bückeburg").', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bach_johann_christian_bach', 'Johann Christian', 'Bach', 'M', 'Compositor do Classicismo; atuou em Milão e Londres ("Bach de Londres").', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bach_johann_ambrosius_bach', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bach_maria_barbara_bach', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bach_anna_magdalena_bach', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_bach', 'Dinastia Musical Bach', 'A mais prolífica linhagem de músicos da história europeia, culminando em Johann Sebastian Bach e seus filhos compositores.', 'pub_bach_johann_sebastian_bach', 1, 'Ciência e Artes', 'Alemanha / Sacro Império', '1550 – 1800');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_veit_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_johann_ambrosius_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_johann_sebastian_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_maria_barbara_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_anna_magdalena_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_wilhelm_friedemann_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_carl_philipp_emanuel_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_johann_christoph_friedrich_bach', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', 'pub_bach_johann_christian_bach', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_veit_bach', 'pub_bach_veit_bach', 'falecimento', 1619, 1619, 'exata', '1619');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_johann_ambrosius_bach', 'pub_bach_johann_ambrosius_bach', 'nascimento', 1645, 1645, 'exata', '1645');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_johann_ambrosius_bach', 'pub_bach_johann_ambrosius_bach', 'falecimento', 1695, 1695, 'exata', '1695');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_johann_sebastian_bach', 'pub_bach_johann_sebastian_bach', 'nascimento', 1685, 1685, 'exata', '1685');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_johann_sebastian_bach', 'pub_bach_johann_sebastian_bach', 'falecimento', 1750, 1750, 'exata', '1750');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_maria_barbara_bach', 'pub_bach_maria_barbara_bach', 'nascimento', 1684, 1684, 'exata', '1684');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_maria_barbara_bach', 'pub_bach_maria_barbara_bach', 'falecimento', 1720, 1720, 'exata', '1720');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_anna_magdalena_bach', 'pub_bach_anna_magdalena_bach', 'nascimento', 1701, 1701, 'exata', '1701');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_anna_magdalena_bach', 'pub_bach_anna_magdalena_bach', 'falecimento', 1760, 1760, 'exata', '1760');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_wilhelm_friedemann_bach', 'pub_bach_wilhelm_friedemann_bach', 'nascimento', 1710, 1710, 'exata', '1710');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_wilhelm_friedemann_bach', 'pub_bach_wilhelm_friedemann_bach', 'falecimento', 1784, 1784, 'exata', '1784');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_carl_philipp_emanuel_bach', 'pub_bach_carl_philipp_emanuel_bach', 'nascimento', 1714, 1714, 'exata', '1714');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_carl_philipp_emanuel_bach', 'pub_bach_carl_philipp_emanuel_bach', 'falecimento', 1788, 1788, 'exata', '1788');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_johann_christoph_friedrich_bach', 'pub_bach_johann_christoph_friedrich_bach', 'nascimento', 1732, 1732, 'exata', '1732');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_johann_christoph_friedrich_bach', 'pub_bach_johann_christoph_friedrich_bach', 'falecimento', 1795, 1795, 'exata', '1795');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bach_johann_christian_bach', 'pub_bach_johann_christian_bach', 'nascimento', 1735, 1735, 'exata', '1735');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bach_johann_christian_bach', 'pub_bach_johann_christian_bach', 'falecimento', 1782, 1782, 'exata', '1782');
-- União de Veit Bach (patriarca) -> Johann Ambrosius
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bach_veit_bach', 'pub_bach_veit_bach', 'pub_ph_pub_bach_johann_ambrosius_bach', 'casamento', 'Patriarca da linhagem musical');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', NULL, 'pub_u_pub_arv_bach_veit_bach');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_veit_bach', 'pub_bach_johann_ambrosius_bach', 'biologico', 1);

-- União de Johann Ambrosius Bach -> Johann Sebastian Bach
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bach_johann_ambrosius', 'pub_bach_johann_ambrosius_bach', 'pub_ph_pub_bach_johann_ambrosius_bach', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', NULL, 'pub_u_pub_arv_bach_johann_ambrosius');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_johann_ambrosius', 'pub_bach_johann_sebastian_bach', 'biologico', 1);

-- 1º Casamento: Johann Sebastian Bach + Maria Barbara Bach
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bach_jsb_maria_barbara', 'pub_bach_johann_sebastian_bach', 'pub_bach_maria_barbara_bach', 'casamento', '1º casamento (1707)');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', NULL, 'pub_u_pub_arv_bach_jsb_maria_barbara');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_jsb_maria_barbara', 'pub_bach_wilhelm_friedemann_bach', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_jsb_maria_barbara', 'pub_bach_carl_philipp_emanuel_bach', 'biologico', 2);

-- 2º Casamento: Johann Sebastian Bach + Anna Magdalena Bach
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bach_jsb_anna_magdalena', 'pub_bach_johann_sebastian_bach', 'pub_bach_anna_magdalena_bach', 'casamento', '2º casamento (1721)');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bach', NULL, 'pub_u_pub_arv_bach_jsb_anna_magdalena');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_jsb_anna_magdalena', 'pub_bach_johann_christoph_friedrich_bach', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bach_jsb_anna_magdalena', 'pub_bach_johann_christian_bach', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Família Curie / Joliot-Curie
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_marie_skodowska_curie', 'Marie', 'Curie', 'F', 'Física e química; pioneira da radioatividade; única pessoa a ganhar o Nobel em duas ciências.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_pierre_curie', 'Pierre', 'Curie', 'M', 'Físico; co-descobridor da radioatividade, do polônio e do rádio.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_jacques_curie', 'Jacques', 'Curie', 'M', 'Atuação: físico.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_irene_joliot_curie', 'Irène', 'Joliot-Curie', 'F', 'Física e química; descobriu a radioatividade artificial junto com o marido.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_frederic_joliot_curie', 'Frédéric', 'Joliot-Curie', 'M', 'Atuação: físico; químico.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_eve_curie', 'Ève', 'Curie', 'F', 'Jornalista, pianista e escritora; autora da biografia "Madame Curie".', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_henry_richardson_labouisse', 'Henry R.', 'Labouisse', 'M', 'Atuação: diplomata; diretor do UNICEF.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_helene_langevin_joliot', 'Hélène', 'Langevin-Joliot', 'F', 'Física nuclear.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_curie_pierre_joliot', 'Pierre', 'Joliot', 'M', 'Atuação: biólogo (fotossíntese).', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_curie', 'Família Curie / Joliot-Curie', 'Dinastia científica pioneira da física nuclear e radioatividade, laureada com 5 Prêmios Nobel.', 'pub_curie_marie_skodowska_curie', 1, 'Ciência e Artes', 'França / Polônia', '1856 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_marie_skodowska_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_pierre_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_jacques_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_irene_joliot_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_frederic_joliot_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_eve_curie', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_henry_richardson_labouisse', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_helene_langevin_joliot', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', 'pub_curie_pierre_joliot', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_marie_skodowska_curie', 'pub_curie_marie_skodowska_curie', 'nascimento', 1867, 1867, 'exata', '1867');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_marie_skodowska_curie', 'pub_curie_marie_skodowska_curie', 'falecimento', 1934, 1934, 'exata', '1934');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_pierre_curie', 'pub_curie_pierre_curie', 'nascimento', 1859, 1859, 'exata', '1859');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_pierre_curie', 'pub_curie_pierre_curie', 'falecimento', 1906, 1906, 'exata', '1906');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_jacques_curie', 'pub_curie_jacques_curie', 'nascimento', 1856, 1856, 'exata', '1856');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_jacques_curie', 'pub_curie_jacques_curie', 'falecimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_irene_joliot_curie', 'pub_curie_irene_joliot_curie', 'nascimento', 1897, 1897, 'exata', '1897');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_irene_joliot_curie', 'pub_curie_irene_joliot_curie', 'falecimento', 1956, 1956, 'exata', '1956');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_frederic_joliot_curie', 'pub_curie_frederic_joliot_curie', 'nascimento', 1900, 1900, 'exata', '1900');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_frederic_joliot_curie', 'pub_curie_frederic_joliot_curie', 'falecimento', 1958, 1958, 'exata', '1958');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_eve_curie', 'pub_curie_eve_curie', 'nascimento', 1904, 1904, 'exata', '1904');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_eve_curie', 'pub_curie_eve_curie', 'falecimento', 2007, 2007, 'exata', '2007');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_henry_richardson_labouisse', 'pub_curie_henry_richardson_labouisse', 'nascimento', 1904, 1904, 'exata', '1904');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_curie_henry_richardson_labouisse', 'pub_curie_henry_richardson_labouisse', 'falecimento', 1987, 1987, 'exata', '1987');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_helene_langevin_joliot', 'pub_curie_helene_langevin_joliot', 'nascimento', 1927, 1927, 'exata', '1927');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_curie_pierre_joliot', 'pub_curie_pierre_joliot', 'nascimento', 1932, 1932, 'exata', '1932');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_curie_pub_curie_pierre_curie_pub_curie_marie_s', 'pub_curie_pierre_curie', 'pub_curie_marie_skodowska_curie', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', NULL, 'pub_u_pub_arv_curie_pub_curie_pierre_curie_pub_curie_marie_s');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_curie_pub_curie_frederic_joliot_curie_pub_curi', 'pub_curie_frederic_joliot_curie', 'pub_curie_irene_joliot_curie', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', NULL, 'pub_u_pub_arv_curie_pub_curie_frederic_joliot_curie_pub_curi');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_curie_pub_curie_henry_richardson_labouisse_pub', 'pub_curie_henry_richardson_labouisse', 'pub_curie_eve_curie', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_curie', NULL, 'pub_u_pub_arv_curie_pub_curie_henry_richardson_labouisse_pub');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_curie_pub_curie_pierre_curie_pub_curie_marie_s', 'pub_curie_irene_joliot_curie', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_curie_pub_curie_pierre_curie_pub_curie_marie_s', 'pub_curie_eve_curie', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_curie_pub_curie_frederic_joliot_curie_pub_curi', 'pub_curie_helene_langevin_joliot', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_curie_pub_curie_frederic_joliot_curie_pub_curi', 'pub_curie_pierre_joliot', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Família Darwin-Wedgwood
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_erasmus_darwin', 'Erasmus', 'Darwin', 'M', 'Médico, poeta e filósofo natural; avô de Charles Darwin e precursor de ideias evolutivas.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_josiah_wedgwood_i', 'Josiah', 'Wedgwood', 'M', 'Ceramista; fundador da fábrica Wedgwood e amigo de Erasmus Darwin.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_sarah_wedgwood', 'Sarah', 'Wedgwood', 'F', '', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_robert_waring_darwin', 'Robert', 'Darwin', 'M', 'Atuação: médico.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_susannah_darwin', 'Susannah Wedgwood', 'Darwin', 'F', '', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_josiah_wedgwood_ii', 'Josiah Wedgwood', 'II', 'M', 'Atuação: empresário (Wedgwood); político.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_charles_darwin', 'Charles', 'Darwin', 'M', 'Naturalista; formulou a teoria da evolução por seleção natural.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_emma_darwin', 'Emma', 'Darwin', 'F', '', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_francis_galton', 'Francis', 'Galton', 'M', 'Polímata e estatístico; "pai da eugenia"; primo de Charles Darwin.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_william_erasmus_darwin', 'William Erasmus', 'Darwin', 'U', 'Atuação: banqueiro.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_anne_darwin', 'Anne "Annie"', 'Darwin', 'F', '', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_henrietta_litchfield', 'Henrietta "Etty"', 'Litchfield', 'U', 'Atuação: editora (revisou obras do pai).', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_george_howard_darwin', 'George Howard', 'Darwin', 'M', 'Astrônomo e matemático; membro da Royal Society.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_francis_darwin', 'Francis', 'Darwin', 'M', 'Botânico; membro da Royal Society; editou a correspondência do pai.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_leonard_darwin', 'Leonard', 'Darwin', 'M', 'Atuação: militar; economista; eugenista.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_horace_darwin', 'Horace', 'Darwin', 'M', 'Engenheiro; fundou a Cambridge Scientific Instrument Company; Royal Society.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_darwin_erasmus_darwin', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_darwin_elizabeth_allen', 'Elizabeth', 'Allen', 'F', 'Esposa de Josiah Wedgwood II e mãe de Emma Darwin.', 0, 0, 1, 'Ciência e Artes');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_darwin', 'Família Darwin-Wedgwood', 'Família interligada de cientistas, naturalistas e industriais, berço de Charles Darwin e Josiah Wedgwood.', 'pub_darwin_josiah_wedgwood_i', 1, 'Ciência e Artes', 'Reino Unido', '1730 – 1914');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_erasmus_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_josiah_wedgwood_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_sarah_wedgwood', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_robert_waring_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_susannah_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_josiah_wedgwood_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_charles_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_emma_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_francis_galton', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_william_erasmus_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_anne_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_henrietta_litchfield', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_george_howard_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_francis_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_leonard_darwin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', 'pub_darwin_horace_darwin', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_erasmus_darwin', 'pub_darwin_erasmus_darwin', 'nascimento', 1731, 1731, 'exata', '1731');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_erasmus_darwin', 'pub_darwin_erasmus_darwin', 'falecimento', 1802, 1802, 'exata', '1802');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_josiah_wedgwood_i', 'pub_darwin_josiah_wedgwood_i', 'nascimento', 1730, 1730, 'exata', '1730');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_josiah_wedgwood_i', 'pub_darwin_josiah_wedgwood_i', 'falecimento', 1795, 1795, 'exata', '1795');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_sarah_wedgwood', 'pub_darwin_sarah_wedgwood', 'nascimento', 1734, 1734, 'exata', '1734');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_sarah_wedgwood', 'pub_darwin_sarah_wedgwood', 'falecimento', 1815, 1815, 'exata', '1815');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_robert_waring_darwin', 'pub_darwin_robert_waring_darwin', 'nascimento', 1766, 1766, 'exata', '1766');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_robert_waring_darwin', 'pub_darwin_robert_waring_darwin', 'falecimento', 1848, 1848, 'exata', '1848');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_susannah_darwin', 'pub_darwin_susannah_darwin', 'nascimento', 1765, 1765, 'exata', '1765');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_susannah_darwin', 'pub_darwin_susannah_darwin', 'falecimento', 1817, 1817, 'exata', '1817');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_josiah_wedgwood_ii', 'pub_darwin_josiah_wedgwood_ii', 'nascimento', 1769, 1769, 'exata', '1769');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_josiah_wedgwood_ii', 'pub_darwin_josiah_wedgwood_ii', 'falecimento', 1843, 1843, 'exata', '1843');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_elizabeth_allen', 'pub_darwin_elizabeth_allen', 'nascimento', 1764, 1764, 'exata', '1764');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_elizabeth_allen', 'pub_darwin_elizabeth_allen', 'falecimento', 1846, 1846, 'exata', '1846');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_charles_darwin', 'pub_darwin_charles_darwin', 'nascimento', 1809, 1809, 'exata', '1809');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_charles_darwin', 'pub_darwin_charles_darwin', 'falecimento', 1882, 1882, 'exata', '1882');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_emma_darwin', 'pub_darwin_emma_darwin', 'nascimento', 1808, 1808, 'exata', '1808');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_emma_darwin', 'pub_darwin_emma_darwin', 'falecimento', 1896, 1896, 'exata', '1896');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_francis_galton', 'pub_darwin_francis_galton', 'nascimento', 1822, 1822, 'exata', '1822');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_francis_galton', 'pub_darwin_francis_galton', 'falecimento', 1911, 1911, 'exata', '1911');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_william_erasmus_darwin', 'pub_darwin_william_erasmus_darwin', 'nascimento', 1839, 1839, 'exata', '1839');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_william_erasmus_darwin', 'pub_darwin_william_erasmus_darwin', 'falecimento', 1914, 1914, 'exata', '1914');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_anne_darwin', 'pub_darwin_anne_darwin', 'nascimento', 1841, 1841, 'exata', '1841');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_anne_darwin', 'pub_darwin_anne_darwin', 'falecimento', 1851, 1851, 'exata', '1851');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_henrietta_litchfield', 'pub_darwin_henrietta_litchfield', 'nascimento', 1843, 1843, 'exata', '1843');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_henrietta_litchfield', 'pub_darwin_henrietta_litchfield', 'falecimento', 1927, 1927, 'exata', '1927');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_george_howard_darwin', 'pub_darwin_george_howard_darwin', 'nascimento', 1845, 1845, 'exata', '1845');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_george_howard_darwin', 'pub_darwin_george_howard_darwin', 'falecimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_francis_darwin', 'pub_darwin_francis_darwin', 'nascimento', 1848, 1848, 'exata', '1848');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_francis_darwin', 'pub_darwin_francis_darwin', 'falecimento', 1925, 1925, 'exata', '1925');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_leonard_darwin', 'pub_darwin_leonard_darwin', 'nascimento', 1850, 1850, 'exata', '1850');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_leonard_darwin', 'pub_darwin_leonard_darwin', 'falecimento', 1943, 1943, 'exata', '1943');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_darwin_horace_darwin', 'pub_darwin_horace_darwin', 'nascimento', 1851, 1851, 'exata', '1851');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_darwin_horace_darwin', 'pub_darwin_horace_darwin', 'falecimento', 1928, 1928, 'exata', '1928');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_i_pub_darwin', 'pub_darwin_josiah_wedgwood_i', 'pub_darwin_sarah_wedgwood', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', NULL, 'pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_i_pub_darwin');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_robert_waring_darwin_pub_dar', 'pub_darwin_robert_waring_darwin', 'pub_darwin_susannah_darwin', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', NULL, 'pub_u_pub_arv_darwin_pub_darwin_robert_waring_darwin_pub_dar');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_charles_darwin', 'pub_darwin_emma_darwin', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', NULL, 'pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_erasmus_darwin_pub_ph_pub_da', 'pub_darwin_erasmus_darwin', 'pub_ph_pub_darwin_erasmus_darwin', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', NULL, 'pub_u_pub_arv_darwin_pub_darwin_erasmus_darwin_pub_ph_pub_da');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu', 'pub_darwin_josiah_wedgwood_ii', 'pub_darwin_elizabeth_allen', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_darwin', NULL, 'pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_erasmus_darwin_pub_ph_pub_da', 'pub_darwin_robert_waring_darwin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_i_pub_darwin', 'pub_darwin_susannah_darwin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_i_pub_darwin', 'pub_darwin_josiah_wedgwood_ii', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_robert_waring_darwin_pub_dar', 'pub_darwin_charles_darwin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu', 'pub_darwin_emma_darwin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_anne_darwin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_henrietta_litchfield', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_george_howard_darwin', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_francis_darwin', 'biologico', 4);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_leonard_darwin', 'biologico', 5);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_horace_darwin', 'biologico', 6);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_charles_darwin_pub_darwin_em', 'pub_darwin_william_erasmus_darwin', 'biologico', 7);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_darwin_pub_darwin_erasmus_darwin_pub_ph_pub_da', 'pub_darwin_francis_galton', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Linhagem de Moisés e Aarão (Tribo de Levi)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_moises_anrao', 'Anrão', NULL, 'M', '', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_moises_joquebede', 'Joquebede', NULL, 'F', '', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_moises_moises', 'Moisés', NULL, 'M', 'Líder que, segundo a tradição, conduziu o Êxodo e recebeu a Lei.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_moises_arao', 'Arão', NULL, 'M', '', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_moises_miria', 'Miriã', NULL, 'F', '', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_moises', 'Linhagem de Moisés e Aarão (Tribo de Levi)', 'Líderes do Êxodo e fundadores do sacerdócio levítico de Israel.', 'pub_moises_anrao', 1, 'Bíblicas e Antiguidade', 'Israel Antigo / Egito', 'Séc. XIII a.C.');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', 'pub_moises_anrao', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', 'pub_moises_joquebede', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', 'pub_moises_moises', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', 'pub_moises_arao', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', 'pub_moises_miria', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_moises_pub_moises_anrao_pub_moises_joquebede', 'pub_moises_anrao', 'pub_moises_joquebede', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_moises', NULL, 'pub_u_pub_arv_moises_pub_moises_anrao_pub_moises_joquebede');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_moises_pub_moises_anrao_pub_moises_joquebede', 'pub_moises_moises', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_moises_pub_moises_anrao_pub_moises_joquebede', 'pub_moises_arao', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_moises_pub_moises_anrao_pub_moises_joquebede', 'pub_moises_miria', 'biologico', 3);

-- =====================================================================

-- =====================================================================
-- ÁRVORE: Patriarcas de Israel (Abraão a José)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_abraao', 'Abraão', NULL, 'M', 'Patriarca bíblico do monoteísmo e ancestral comum das doze tribos de Israel.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_sara', 'Sara', NULL, 'F', 'Matriarca bíblica, esposa de Abraão e mãe de Isaac.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_isaac', 'Isaac', NULL, 'M', 'Segundo patriarca bíblico de Israel, filho da promessa de Abraão e Sara.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_rebeca', 'Rebeca', NULL, 'F', 'Matriarca bíblica, esposa de Isaac e mãe dos gêmeos Esaú e Jacó.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_esau', 'Esaú', '(Edom)', 'M', 'Filho primogênito de Isaac e Rebeca, irmão gêmeo de Jacó e patriarca dos edomitas.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_jaco', 'Jacó', '(Israel)', 'M', 'Terceiro patriarca bíblico de Israel; pai dos fundadores das 12 tribos.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_lia', 'Lia', NULL, 'F', 'Primeira esposa de Jacó, mãe de Judá, Rúben, Simeão, Levi, Issacar e Zebulom.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_raquel', 'Raquel', NULL, 'F', 'Segunda esposa amada de Jacó, mãe de José e Benjamim.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_juda', 'Judá', NULL, 'M', 'Quarto filho de Jacó e Lia; ancestral da Tribo de Judá e da linhagem real davídica.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_patriarcas_israel_jose', 'José', '(do Egito)', 'M', 'Filho de Jacó e Raquel; vendido pelos irmãos, tornou-se vizir do Egito.', 0, 0, 1, 'Bíblicas e Antiguidade');

INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_patriarcas_israel', 'Patriarcas de Israel (Abraão a José)', 'Linhagem fundacional das doze tribos de Israel narrada nas tradições bíblicas.', 'pub_patriarcas_israel_abraao', 1, 'Bíblicas e Antiguidade', 'Canaã / Oriente Próximo', 'Antiguidade (a.C.)');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_abraao', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_sara', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_isaac', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_rebeca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_esau', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_jaco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_lia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_raquel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_juda', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_patriarcas_israel', 'pub_patriarcas_israel_jose', NULL);

-- Eventos e datas bíblicas com qualificador 'cerca_de'
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_abraao', 'pub_patriarcas_israel_abraao', 'nascimento', -1813, -1813, 'cerca_de', 'cerca de 1813 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_abraao', 'pub_patriarcas_israel_abraao', 'falecimento', -1638, -1638, 'cerca_de', 'cerca de 1638 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_sara', 'pub_patriarcas_israel_sara', 'nascimento', -1803, -1803, 'cerca_de', 'cerca de 1803 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_sara', 'pub_patriarcas_israel_sara', 'falecimento', -1676, -1676, 'cerca_de', 'cerca de 1676 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_isaac', 'pub_patriarcas_israel_isaac', 'nascimento', -1713, -1713, 'cerca_de', 'cerca de 1713 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_isaac', 'pub_patriarcas_israel_isaac', 'falecimento', -1533, -1533, 'cerca_de', 'cerca de 1533 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_jaco', 'pub_patriarcas_israel_jaco', 'nascimento', -1653, -1653, 'cerca_de', 'cerca de 1653 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_jaco', 'pub_patriarcas_israel_jaco', 'falecimento', -1506, -1506, 'cerca_de', 'cerca de 1506 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_juda', 'pub_patriarcas_israel_juda', 'nascimento', -1600, -1600, 'cerca_de', 'cerca de 1600 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_juda', 'pub_patriarcas_israel_juda', 'falecimento', -1470, -1470, 'cerca_de', 'cerca de 1470 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_patriarcas_jose', 'pub_patriarcas_israel_jose', 'nascimento', -1562, -1562, 'cerca_de', 'cerca de 1562 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_patriarcas_jose', 'pub_patriarcas_israel_jose', 'falecimento', -1452, -1452, 'cerca_de', 'cerca de 1452 a.C.');

-- Uniões dos Patriarcas
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_patriarcas_abraao_sara', 'pub_patriarcas_israel_abraao', 'pub_patriarcas_israel_sara', 'casamento', 'União patriarcal');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_patriarcas_israel', NULL, 'pub_u_patriarcas_abraao_sara');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_patriarcas_abraao_sara', 'pub_patriarcas_israel_isaac', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_patriarcas_isaac_rebeca', 'pub_patriarcas_israel_isaac', 'pub_patriarcas_israel_rebeca', 'casamento', 'União patriarcal');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_patriarcas_israel', NULL, 'pub_u_patriarcas_isaac_rebeca');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_patriarcas_isaac_rebeca', 'pub_patriarcas_israel_esau', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_patriarcas_isaac_rebeca', 'pub_patriarcas_israel_jaco', 'biologico', 2);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_patriarcas_jaco_lia', 'pub_patriarcas_israel_jaco', 'pub_patriarcas_israel_lia', 'casamento', 'Casamento com Lia');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_patriarcas_israel', NULL, 'pub_u_patriarcas_jaco_lia');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_patriarcas_jaco_lia', 'pub_patriarcas_israel_juda', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_patriarcas_jaco_raquel', 'pub_patriarcas_israel_jaco', 'pub_patriarcas_israel_raquel', 'casamento', 'Casamento com Raquel');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_patriarcas_israel', NULL, 'pub_u_patriarcas_jaco_raquel');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_patriarcas_jaco_raquel', 'pub_patriarcas_israel_jose', 'biologico', 1);

-- ÁRVORE: Genealogia de Adão (Gênesis / Antediluviana)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_adao', 'Adão', NULL, 'M', 'Primeiro homem segundo o relato bíblico de Gênesis; patriarca da humanidade antediluviana (viveu 930 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_eva', 'Eva', NULL, 'F', 'Primeira mulher criada segundo o relato bíblico, denominada "a mãe de todos os viventes".', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_caim', 'Caim', NULL, 'M', 'Filho primogênito de Adão e Eva; agricultor e fundador da primeira cidade (Enoque).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_abel', 'Abel', NULL, 'M', 'Segundo filho de Adão e Eva; pastor de ovelhas cuja oferta foi acolhida com favor.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_sete', 'Sete', NULL, 'M', 'Terceiro filho nominado de Adão e Eva; patriarca da linhagem bíblica que conduz a Noé (viveu 912 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_enos', 'Enos', NULL, 'M', 'Filho de Sete; no seu tempo os seres humanos começaram a invocar o nome do Senhor (viveu 905 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_caina', 'Cainã', NULL, 'M', 'Filho de Enos e bisneto de Adão; quarto patriarca antediluviano (viveu 910 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_maalalel', 'Maalalel', NULL, 'M', 'Filho de Cainã; quinto patriarca antediluviano (viveu 895 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_jarede', 'Jarede', NULL, 'M', 'Filho de Maalalel e pai do profeta Enoque (viveu 962 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_enoque', 'Enoque', NULL, 'M', 'Profeta e sétimo patriarca a partir de Adão; "andou com Deus e não mais foi visto, porque Deus o levou".', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matusalem', 'Matusalém', NULL, 'M', 'Filho de Enoque e avô de Noé; a pessoa com maior longevidade documentada na Bíblia (969 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lameque_ant', 'Lameque', NULL, 'M', 'Filho de Matusalém e pai de Noé; profetizou o alívio que o filho traria à terra (viveu 777 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_noe', 'Noé', NULL, 'M', 'Patriarca do Dilúvio; construiu a Arca por mandado divino e preservou a vida e a linhagem humana (viveu 950 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_esposa_noe', 'Esposa de Noé', NULL, 'F', 'Matriarca que acompanhou Noé e seus filhos na Arca, mãe dos três fundadores dos povos pós-diluvianos.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_sem', 'Sem', NULL, 'M', 'Filho de Noé; ancestral dos povos semitas e da linhagem genealógica bíblica até Abraão (viveu 600 anos).', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_cam', 'Cam', NULL, 'M', 'Filho de Noé; ancestral tradicional dos povos da África e da terra de Canaã.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_jafe', 'Jafé', NULL, 'M', 'Filho de Noé; ancestral tradicional dos povos marítimos e indo-europeus.', 0, 0, 1, 'Bíblicas e Antiguidade');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terah', 'Terá', NULL, 'M', 'Descendente da linhagem de Sem e pai de Abraão; partiu de Ur dos Caldeus rumo a Canaã.', 0, 0, 1, 'Bíblicas e Antiguidade');

INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_adao', 'Genealogia de Adão (Gênesis / Antediluviana)', 'Linhagem patriarcal das primeiras gerações narrada no livro de Gênesis: de Adão e Eva, passando por Enoque e Matusalém, até Noé e Abraão.', 'pub_adao', 1, 'Bíblicas e Antiguidade', 'Crescente Fértil / Antiguidade', 'Antiguidade (a.C.)');

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_adao', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_eva', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_caim', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_abel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_sete', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_enos', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_caina', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_maalalel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_jarede', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_enoque', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_matusalem', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_lameque_ant', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_noe', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_esposa_noe', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_sem', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_cam', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_jafe', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_adao', 'pub_terah', NULL);

-- Eventos e cronologia com cerca_de
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_adao', 'pub_adao', 'nascimento', -4004, -4004, 'cerca_de', 'cerca de 4004 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_adao', 'pub_adao', 'falecimento', -3074, -3074, 'cerca_de', 'cerca de 3074 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_eva', 'pub_eva', 'nascimento', -4004, -4004, 'cerca_de', 'cerca de 4004 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_sete', 'pub_sete', 'nascimento', -3874, -3874, 'cerca_de', 'cerca de 3874 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_sete', 'pub_sete', 'falecimento', -2962, -2962, 'cerca_de', 'cerca de 2962 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_enos', 'pub_enos', 'nascimento', -3769, -3769, 'cerca_de', 'cerca de 3769 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_enos', 'pub_enos', 'falecimento', -2864, -2864, 'cerca_de', 'cerca de 2864 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_caina', 'pub_caina', 'nascimento', -3679, -3679, 'cerca_de', 'cerca de 3679 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_caina', 'pub_caina', 'falecimento', -2769, -2769, 'cerca_de', 'cerca de 2769 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_maalalel', 'pub_maalalel', 'nascimento', -3609, -3609, 'cerca_de', 'cerca de 3609 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_maalalel', 'pub_maalalel', 'falecimento', -2714, -2714, 'cerca_de', 'cerca de 2714 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_jarede', 'pub_jarede', 'nascimento', -3544, -3544, 'cerca_de', 'cerca de 3544 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_jarede', 'pub_jarede', 'falecimento', -2582, -2582, 'cerca_de', 'cerca de 2582 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_enoque', 'pub_enoque', 'nascimento', -3382, -3382, 'cerca_de', 'cerca de 3382 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_enoque', 'pub_enoque', 'falecimento', -3017, -3017, 'cerca_de', 'cerca de 3017 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matusalem', 'pub_matusalem', 'nascimento', -3317, -3317, 'cerca_de', 'cerca de 3317 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matusalem', 'pub_matusalem', 'falecimento', -2348, -2348, 'cerca_de', 'cerca de 2348 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_lameque_ant', 'pub_lameque_ant', 'nascimento', -3130, -3130, 'cerca_de', 'cerca de 3130 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_lameque_ant', 'pub_lameque_ant', 'falecimento', -2353, -2353, 'cerca_de', 'cerca de 2353 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_noe', 'pub_noe', 'nascimento', -2948, -2948, 'cerca_de', 'cerca de 2948 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_noe', 'pub_noe', 'falecimento', -1998, -1998, 'cerca_de', 'cerca de 1998 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_sem', 'pub_sem', 'nascimento', -2446, -2446, 'cerca_de', 'cerca de 2446 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_sem', 'pub_sem', 'falecimento', -1846, -1846, 'cerca_de', 'cerca de 1846 a.C.');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_terah', 'pub_terah', 'nascimento', -2126, -2126, 'cerca_de', 'cerca de 2126 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_terah', 'pub_terah', 'falecimento', -1921, -1921, 'cerca_de', 'cerca de 1921 a.C.');

-- Uniões e Filiações Antediluvianas
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_adao_eva', 'pub_adao', 'pub_eva', 'casamento', 'Primeiro casal da criação bíblica');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_adao_eva');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_adao_eva', 'pub_caim', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_adao_eva', 'pub_abel', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_adao_eva', 'pub_sete', 'biologico', 3);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_sete', 'pub_sete', 'pub_sete', 'nao_informado', 'Linhagem de Sete');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_sete');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_sete', 'pub_enos', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_enos', 'pub_enos', 'pub_enos', 'nao_informado', 'Linhagem de Enos');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_enos');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_enos', 'pub_caina', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_caina', 'pub_caina', 'pub_caina', 'nao_informado', 'Linhagem de Cainã');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_caina');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_caina', 'pub_maalalel', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_maalalel', 'pub_maalalel', 'pub_maalalel', 'nao_informado', 'Linhagem de Maalalel');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_maalalel');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_maalalel', 'pub_jarede', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_jarede', 'pub_jarede', 'pub_jarede', 'nao_informado', 'Linhagem de Jarede');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_jarede');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_jarede', 'pub_enoque', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_enoque', 'pub_enoque', 'pub_enoque', 'nao_informado', 'Linhagem de Enoque');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_enoque');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_enoque', 'pub_matusalem', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_matusalem', 'pub_matusalem', 'pub_matusalem', 'nao_informado', 'Linhagem de Matusalém');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_matusalem');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_matusalem', 'pub_lameque_ant', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_lameque', 'pub_lameque_ant', 'pub_lameque_ant', 'nao_informado', 'Linhagem de Lameque');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_lameque');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_lameque', 'pub_noe', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_noe_esposa', 'pub_noe', 'pub_esposa_noe', 'casamento', 'Família preservada na Arca de Noé');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_noe_esposa');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_noe_esposa', 'pub_sem', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_noe_esposa', 'pub_cam', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_noe_esposa', 'pub_jafe', 'biologico', 3);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_sem_terah', 'pub_sem', 'pub_sem', 'nao_informado', 'Descendência de Sem até Terá');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_sem_terah');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_sem_terah', 'pub_terah', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_terah_abraao', 'pub_terah', 'pub_terah', 'nao_informado', 'Conexão à linhagem dos Patriarcas de Israel');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_adao', NULL, 'pub_u_terah_abraao');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_terah_abraao', 'pub_patriarcas_israel_abraao', 'biologico', 1);

-- ÁRVORE: Família Álvares Penteado
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_joao_carlos_leite_penteado', 'João Carlos Leite', 'Penteado', 'M', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_antonio_alvares_leite_penteado', 'Álvares', 'Penteado', 'M', 'Cafeicultor que migrou para a indústria têxtil; conde (título papal) e grande mecenas.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_ana_paulina_lacerda_penteado', 'Álvares', 'Penteado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_armando_alvares_penteado', 'Armando Álvares', 'Penteado', 'M', 'Arquiteto, cafeicultor e mecenas; idealizador da FAAP (realizada após sua morte).', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_annie_alvares_penteado', 'Annie Álvares', 'Penteado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_silvio_alvares_penteado', 'Silvio Álvares', 'Penteado', 'M', 'Atuação: empresário.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_honorio_alvares_penteado', 'Honório Álvares', 'Penteado', 'M', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_estela_penteado', 'Estela Álvares', 'Penteado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_eglantina_penteado', 'Eglantina Álvares', 'Penteado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_penteado_antonieta_penteado', 'Antonieta Álvares', 'Penteado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_penteado_silvio_alvares_penteado', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'História do Brasil');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_penteado', 'Família Álvares Penteado', 'Tradicional linhagem cafeeira e mecenas das artes e educação em São Paulo.', 'pub_penteado_joao_carlos_leite_penteado', 1, 'História do Brasil', 'Brasil', 'Séc. XIX – XX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_joao_carlos_leite_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_antonio_alvares_leite_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_ana_paulina_lacerda_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_armando_alvares_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_annie_alvares_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_silvio_alvares_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_honorio_alvares_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_estela_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_eglantina_penteado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', 'pub_penteado_antonieta_penteado', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_penteado_antonio_alvares_leite_penteado', 'pub_penteado_antonio_alvares_leite_penteado', 'nascimento', 1852, 1852, 'exata', '1852');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_penteado_antonio_alvares_leite_penteado', 'pub_penteado_antonio_alvares_leite_penteado', 'falecimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_penteado_armando_alvares_penteado', 'pub_penteado_armando_alvares_penteado', 'nascimento', 1884, 1884, 'exata', '1884');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_penteado_armando_alvares_penteado', 'pub_penteado_armando_alvares_penteado', 'falecimento', 1947, 1947, 'exata', '1947');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe', 'pub_penteado_antonio_alvares_leite_penteado', 'pub_penteado_ana_paulina_lacerda_penteado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', NULL, 'pub_u_pub_arv_penteado_pub_penteado_antonio_alvares_leite_pe');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_penteado_pub_penteado_armando_alvares_penteado', 'pub_penteado_armando_alvares_penteado', 'pub_penteado_annie_alvares_penteado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', NULL, 'pub_u_pub_arv_penteado_pub_penteado_armando_alvares_penteado');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_penteado_pub_penteado_silvio_alvares_penteado_', 'pub_penteado_silvio_alvares_penteado', 'pub_ph_pub_penteado_silvio_alvares_penteado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_penteado', NULL, 'pub_u_pub_arv_penteado_pub_penteado_silvio_alvares_penteado_');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_penteado_pub_penteado_silvio_alvares_penteado_', 'pub_penteado_honorio_alvares_penteado', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Silva Prado
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_antonio_da_silva_prado_barao_de_iguape', 'Barão', 'de Iguape', 'M', 'Fundador da dinastia Prado; cafeicultor e comerciante, vice-presidente da Província de São Paulo.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_maria_candida_de_moura_vaz', 'Baronesa', 'de Iguape', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_martinho_da_silva_prado_1811', 'Martinho', 'da Silva Prado', 'M', 'Meio-irmão do Barão de Iguape; deputado provincial de São Paulo.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_veridiana_valeria_da_silva_prado', 'Veridiana', NULL, 'F', 'Matriarca dos Prado; manteve um dos salões culturais mais importantes de São Paulo no séc. XIX.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_antonio_da_silva_prado_conselheiro', 'Conselheiro Antônio', 'Prado', 'M', 'Primeiro prefeito de São Paulo; ministro do Império e grande empreendedor do café.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_maria_catarina_da_silva_prado', 'Maria Catarina', 'da Silva Prado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_martinho_da_silva_prado_junior', 'Martinico', 'Prado', 'M', 'Cafeicultor, abolicionista e propagandista republicano; pioneiro da imigração no Oeste paulista.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_albertina_de_morais_pinto', 'Albertina', 'de Morais Pinto', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_eduardo_paulo_da_silva_prado', 'Eduardo', 'Prado', 'M', 'Escritor e jornalista monarquista; membro fundador da Academia Brasileira de Letras.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_caio_da_silva_prado_tio', 'Caio', 'da Silva Prado', 'M', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_paulo_da_silva_prado', 'Paulo', 'Prado', 'M', 'Cafeicultor, mecenas e escritor; principal patrono da Semana de Arte Moderna de 1922.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_marinette_prado', 'Marinette', 'Prado', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_fabio_da_silva_prado', 'Fábio', 'Prado', 'M', 'Prefeito de São Paulo (1934–1938).', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_martinho_da_silva_prado_neto', 'Martinho Prado', 'Neto', 'M', 'Atuação: político (deputado federal, 1935–37).', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_caio_da_silva_prado_1872', 'Caio', 'da Silva Prado', 'M', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_prado_caio_prado_junior', 'Caio Prado', 'Júnior', 'M', 'Historiador marxista e editor; um dos grandes intérpretes do Brasil.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_prado_caio_da_silva_prado_1872', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'História do Brasil');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_prado', 'Família Silva Prado', 'Uma das mais influentes famílias políticas, cafeeiras e culturais de São Paulo.', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', 1, 'História do Brasil', 'Brasil', '1742 – Séc. XX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_maria_candida_de_moura_vaz', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_1811', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_veridiana_valeria_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_antonio_da_silva_prado_conselheiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_maria_catarina_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_junior', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_albertina_de_morais_pinto', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_eduardo_paulo_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_caio_da_silva_prado_tio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_paulo_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_marinette_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_fabio_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_neto', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_caio_da_silva_prado_1872', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', 'pub_prado_caio_prado_junior', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_antonio_da_silva_prado_barao_de_iguape', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', 'nascimento', 1778, 1778, 'cerca_de', 'cerca de 1778');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_antonio_da_silva_prado_barao_de_iguape', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', 'falecimento', 1875, 1875, 'exata', '1875');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_maria_candida_de_moura_vaz', 'pub_prado_maria_candida_de_moura_vaz', 'falecimento', 1868, 1868, 'exata', '1868');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_martinho_da_silva_prado_1811', 'pub_prado_martinho_da_silva_prado_1811', 'nascimento', 1811, 1811, 'exata', '1811');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_martinho_da_silva_prado_1811', 'pub_prado_martinho_da_silva_prado_1811', 'falecimento', 1891, 1891, 'exata', '1891');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_veridiana_valeria_da_silva_prado', 'pub_prado_veridiana_valeria_da_silva_prado', 'nascimento', 1825, 1825, 'exata', '1825');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_veridiana_valeria_da_silva_prado', 'pub_prado_veridiana_valeria_da_silva_prado', 'falecimento', 1910, 1910, 'exata', '1910');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_antonio_da_silva_prado_conselheiro', 'pub_prado_antonio_da_silva_prado_conselheiro', 'nascimento', 1840, 1840, 'exata', '1840');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_antonio_da_silva_prado_conselheiro', 'pub_prado_antonio_da_silva_prado_conselheiro', 'falecimento', 1929, 1929, 'exata', '1929');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_junior', 'nascimento', 1843, 1843, 'exata', '1843');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_junior', 'falecimento', 1906, 1906, 'exata', '1906');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_albertina_de_morais_pinto', 'pub_prado_albertina_de_morais_pinto', 'nascimento', 1852, 1852, 'exata', '1852');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_albertina_de_morais_pinto', 'pub_prado_albertina_de_morais_pinto', 'falecimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_eduardo_paulo_da_silva_prado', 'pub_prado_eduardo_paulo_da_silva_prado', 'nascimento', 1860, 1860, 'exata', '1860');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_eduardo_paulo_da_silva_prado', 'pub_prado_eduardo_paulo_da_silva_prado', 'falecimento', 1901, 1901, 'exata', '1901');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_paulo_da_silva_prado', 'pub_prado_paulo_da_silva_prado', 'nascimento', 1869, 1869, 'exata', '1869');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_paulo_da_silva_prado', 'pub_prado_paulo_da_silva_prado', 'falecimento', 1943, 1943, 'exata', '1943');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_caio_da_silva_prado_1872', 'pub_prado_caio_da_silva_prado_1872', 'nascimento', 1872, 1872, 'exata', '1872');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_caio_da_silva_prado_1872', 'pub_prado_caio_da_silva_prado_1872', 'falecimento', 1947, 1947, 'exata', '1947');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_prado_caio_prado_junior', 'pub_prado_caio_prado_junior', 'nascimento', 1907, 1907, 'exata', '1907');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_prado_caio_prado_junior', 'pub_prado_caio_prado_junior', 'falecimento', 1990, 1990, 'exata', '1990');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', 'pub_prado_maria_candida_de_moura_vaz', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_martinho_da_silva_prado_1811', 'pub_prado_veridiana_valeria_da_silva_prado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_conselh', 'pub_prado_antonio_da_silva_prado_conselheiro', 'pub_prado_maria_catarina_da_silva_prado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_conselh');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_junior', 'pub_prado_albertina_de_morais_pinto', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_paulo_da_silva_prado_pub_prado', 'pub_prado_paulo_da_silva_prado', 'pub_prado_marinette_prado', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_paulo_da_silva_prado_pub_prado');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p', 'pub_prado_caio_da_silva_prado_1872', 'pub_ph_pub_prado_caio_da_silva_prado_1872', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_antonio_da_silva_prado_conselheiro', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_martinho_da_silva_prado_junior', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_eduardo_paulo_da_silva_prado', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_fabio_da_silva_prado', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_neto', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_caio_da_silva_prado_1872', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p', 'pub_prado_caio_prado_junior', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Barão do Rio Branco e Família Paranhos
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'do Rio', 'Branco', 'M', 'Estadista do Império; presidente do Conselho de Ministros e responsável pela Lei do Ventre Livre (1871).', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rio_branco_teresa_de_figueiredo_rodrigues_faria', 'Teresa', 'de Figueiredo Faria', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'Barão', 'do Rio Branco', 'M', 'Diplomata, "patrono da diplomacia brasileira"; consolidou as fronteiras do país como Ministro das Relações Exteriores.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rio_branco_marie_stevens', 'Marie', 'Stevens', 'F', 'Atriz belga; esposa do Barão do Rio Branco.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rio_branco_paulo_do_rio_branco', 'Paulo', 'do Rio Branco', 'M', 'Atuação: jogador de rúgbi.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_rio_branco', 'Barão do Rio Branco e Família Paranhos', 'Patrono da diplomacia brasileira e seu pai, o Visconde do Rio Branco.', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 1, 'História do Brasil', 'Brasil', '1819 – 1912');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', 'pub_rio_branco_teresa_de_figueiredo_rodrigues_faria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', 'pub_rio_branco_marie_stevens', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', 'pub_rio_branco_paulo_do_rio_branco', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'nascimento', 1819, 1819, 'exata', '1819');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'falecimento', 1880, 1880, 'exata', '1880');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'nascimento', 1845, 1845, 'exata', '1845');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'falecimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_rio_branco_pub_rio_branco_jose_maria_da_silva_', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'pub_rio_branco_marie_stevens', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rio_branco', NULL, 'pub_u_pub_arv_rio_branco_pub_rio_branco_jose_maria_da_silva_');

-- =====================================================================
-- ÁRVORE: Família Souza Queirós
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_luis_antonio_de_sousa_queiros', 'Brigadeiro Luís Antônio', 'de Sousa Queirós', 'M', 'O "Brigadeiro Luís Antônio"; um dos maiores proprietários de terras de São Paulo e um dos homens mais ricos do Brasil.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_genebra_de_barros_leite', 'Genebra', 'de Barros Leite', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'Senador', 'Vergueiro', 'M', 'Senador Vergueiro; cafeicultor e político, pioneiro do trabalho imigrante na Fazenda Ibicaba.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'Barão', 'de Sousa Queirós', 'M', 'Barão de Sousa Queirós; senador do Império e cafeicultor; fundou o Instituto Ana Rosa (1874).', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', 'Antônia Eufrosina', 'Vergueiro', 'F', '', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_vicente_de_sousa_queiros', 'Barão', 'de Limeira', 'M', 'Barão de Limeira; cafeicultor e vereador.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_souza_queiros_maria_angelica_de_sousa_queiros', 'Maria Angélica', 'de Sousa Queirós', 'F', 'Proprietária rural; grande latifundiária da região central de São Paulo.', 0, 0, 1, 'História do Brasil');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_souza_queiros', 'Família Souza Queirós', 'Linhagem aristocrática paulista de barões do café e senadores do Império.', 'pub_souza_queiros_luis_antonio_de_sousa_queiros', 1, 'História do Brasil', 'Brasil', 'Séc. XIX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_luis_antonio_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_genebra_de_barros_leite', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_vicente_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'nascimento', 1778, 1778, 'exata', '1778');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'falecimento', 1859, 1859, 'exata', '1859');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'nascimento', 1806, 1806, 'cerca_de', 'cerca de 1806');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'falecimento', 1891, 1891, 'exata', '1891');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_souza_queiros_maria_angelica_de_sousa_queiros', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', 'nascimento', 1842, 1842, 'exata', '1842');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_souza_queiros_maria_angelica_de_sousa_queiros', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', 'falecimento', 1929, 1929, 'exata', '1929');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_luis_antonio_de_sousa_queiros', 'pub_souza_queiros_genebra_de_barros_leite', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', NULL, 'pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_souza_queiros', NULL, 'pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto');

-- =====================================================================
-- ÁRVORE: Família de Francisco Franco
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_francisco_franco', 'Francisco', 'Franco', 'M', 'Chefe de Estado e ditador da Espanha de 1939 até sua morte em 1975.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_carmen_polo', 'Carmen', 'Polo', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_carmen_franco', 'Carmen Franco y', 'Polo', 'F', 'Filha única de Franco; 1ª Duquesa de Franco.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_cristobal_martinez_bordiu', 'Cristóbal', 'Martínez-Bordiú', 'U', 'Atuação: cirurgião (fez o 1º transplante de coração da Espanha, 1968).', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_carmen_martinez_bordiu', 'Carmen', 'Martínez-Bordiú', 'U', 'Atuação: aristocrata.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_francis_franco', 'Francis', 'Franco', 'U', 'Atuação: aristocrata; empresário.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_franco_luis_alfonso_de_borbon', 'Luis Alfonso', 'de Borbón', 'M', 'Bisneto de Franco; pretendente legitimista ("Louis XX") ao trono francês.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_franco', 'Família de Francisco Franco', 'Linhagem militar e política do generalíssimo Francisco Franco na Espanha.', 'pub_franco_francisco_franco', 1, 'Figuras Históricas do Século XX', 'Espanha', '1855 – 1975');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_francisco_franco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_carmen_polo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_carmen_franco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_cristobal_martinez_bordiu', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_carmen_martinez_bordiu', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_francis_franco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', 'pub_franco_luis_alfonso_de_borbon', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_francisco_franco', 'pub_franco_francisco_franco', 'nascimento', 1892, 1892, 'exata', '1892');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_franco_francisco_franco', 'pub_franco_francisco_franco', 'falecimento', 1975, 1975, 'exata', '1975');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_carmen_polo', 'pub_franco_carmen_polo', 'nascimento', 1900, 1900, 'exata', '1900');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_franco_carmen_polo', 'pub_franco_carmen_polo', 'falecimento', 1988, 1988, 'exata', '1988');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_carmen_franco', 'pub_franco_carmen_franco', 'nascimento', 1926, 1926, 'exata', '1926');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_franco_carmen_franco', 'pub_franco_carmen_franco', 'falecimento', 2017, 2017, 'exata', '2017');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_cristobal_martinez_bordiu', 'pub_franco_cristobal_martinez_bordiu', 'nascimento', 1922, 1922, 'exata', '1922');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_franco_cristobal_martinez_bordiu', 'pub_franco_cristobal_martinez_bordiu', 'falecimento', 1998, 1998, 'exata', '1998');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_carmen_martinez_bordiu', 'pub_franco_carmen_martinez_bordiu', 'nascimento', 1951, 1951, 'exata', '1951');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_francis_franco', 'pub_franco_francis_franco', 'nascimento', 1954, 1954, 'exata', '1954');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_franco_luis_alfonso_de_borbon', 'pub_franco_luis_alfonso_de_borbon', 'nascimento', 1974, 1974, 'exata', '1974');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_franco_pub_franco_francisco_franco_pub_franco_', 'pub_franco_francisco_franco', 'pub_franco_carmen_polo', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', NULL, 'pub_u_pub_arv_franco_pub_franco_francisco_franco_pub_franco_');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_franco_pub_franco_cristobal_martinez_bordiu_pu', 'pub_franco_cristobal_martinez_bordiu', 'pub_franco_carmen_franco', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', NULL, 'pub_u_pub_arv_franco_pub_franco_cristobal_martinez_bordiu_pu');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f', 'pub_franco_carmen_martinez_bordiu', 'pub_franco_luis_alfonso_de_borbon', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_franco', NULL, 'pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_franco_pub_franco_francisco_franco_pub_franco_', 'pub_franco_carmen_franco', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_franco_pub_franco_carmen_martinez_bordiu_pub_f', 'pub_franco_luis_alfonso_de_borbon', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Genealogia de Adolf Hitler
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_alois_hitler', 'Alois', 'Hitler', 'M', 'Atuação: funcionário aduaneiro.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_klara_polzl', 'Klara', 'Hitler', 'U', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_adolf_hitler', 'Adolf', 'Hitler', 'M', 'Ditador da Alemanha nazista (1933–1945); responsável pela 2ª Guerra e pelo Holocausto.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_paula_hitler', 'Paula', 'Hitler', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_angela_hitler', 'Angela', 'Hitler', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_alois_hitler_jr', 'Alois Hitler', 'Jr.', 'M', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_geli_raubal', 'Geli', 'Raubal', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_hitler_william_patrick_hitler', 'William Patrick', 'Stuart-Houston', 'M', 'Sobrinho que rompeu publicamente com o tio e emigrou para os EUA.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_hitler_angela_hitler', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_hitler', 'Genealogia de Adolf Hitler', 'Ancestralidade e familiares imediatos de Adolf Hitler em Waldviertel e Linz.', 'pub_hitler_alois_hitler', 1, 'Figuras Históricas do Século XX', 'Áustria / Alemanha', '1837 – 1960');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_alois_hitler', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_klara_polzl', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_adolf_hitler', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_paula_hitler', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_angela_hitler', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_alois_hitler_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_geli_raubal', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', 'pub_hitler_william_patrick_hitler', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_alois_hitler', 'pub_hitler_alois_hitler', 'nascimento', 1837, 1837, 'exata', '1837');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_alois_hitler', 'pub_hitler_alois_hitler', 'falecimento', 1903, 1903, 'exata', '1903');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_klara_polzl', 'pub_hitler_klara_polzl', 'nascimento', 1860, 1860, 'exata', '1860');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_klara_polzl', 'pub_hitler_klara_polzl', 'falecimento', 1907, 1907, 'exata', '1907');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_adolf_hitler', 'pub_hitler_adolf_hitler', 'nascimento', 1889, 1889, 'exata', '1889');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_adolf_hitler', 'pub_hitler_adolf_hitler', 'falecimento', 1945, 1945, 'exata', '1945');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_paula_hitler', 'pub_hitler_paula_hitler', 'nascimento', 1896, 1896, 'exata', '1896');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_paula_hitler', 'pub_hitler_paula_hitler', 'falecimento', 1960, 1960, 'exata', '1960');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_angela_hitler', 'pub_hitler_angela_hitler', 'nascimento', 1883, 1883, 'exata', '1883');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_angela_hitler', 'pub_hitler_angela_hitler', 'falecimento', 1949, 1949, 'exata', '1949');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_geli_raubal', 'pub_hitler_geli_raubal', 'nascimento', 1908, 1908, 'exata', '1908');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_geli_raubal', 'pub_hitler_geli_raubal', 'falecimento', 1931, 1931, 'exata', '1931');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_hitler_william_patrick_hitler', 'pub_hitler_william_patrick_hitler', 'nascimento', 1911, 1911, 'exata', '1911');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_hitler_william_patrick_hitler', 'pub_hitler_william_patrick_hitler', 'falecimento', 1987, 1987, 'exata', '1987');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_hitler_pub_hitler_alois_hitler_pub_hitler_klar', 'pub_hitler_alois_hitler', 'pub_hitler_klara_polzl', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', NULL, 'pub_u_pub_arv_hitler_pub_hitler_alois_hitler_pub_hitler_klar');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_hitler_pub_ph_pub_hitler_angela_hitler_pub_hit', 'pub_ph_pub_hitler_angela_hitler', 'pub_hitler_angela_hitler', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_hitler', NULL, 'pub_u_pub_arv_hitler_pub_ph_pub_hitler_angela_hitler_pub_hit');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_hitler_pub_hitler_alois_hitler_pub_hitler_klar', 'pub_hitler_adolf_hitler', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_hitler_pub_ph_pub_hitler_angela_hitler_pub_hit', 'pub_hitler_geli_raubal', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_hitler_pub_hitler_alois_hitler_pub_hitler_klar', 'pub_hitler_william_patrick_hitler', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Família de Mao Tsé-Tung
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_mao_yichang', 'Mao', 'Yichang', 'M', 'Atuação: agricultor.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_mao_zedong', 'Mao', 'Zedong', 'M', 'Fundador da República Popular da China e líder do Partido Comunista até 1976.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_yang_kaihui', 'Yang', 'Kaihui', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_he_zizhen', 'He', 'Zizhen', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_jiang_qing', 'Jiang', 'Qing', 'F', '4ª esposa de Mao; líder do "Bando dos Quatro" na Revolução Cultural.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_mao_anying', 'Mao', 'Anying', 'M', 'Atuação: militar.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_mao_anqing', 'Mao', 'Anqing', 'M', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_li_min', 'Li', 'Min', 'F', 'Atuação: política.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_li_na', 'Li', 'Na', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mao_mao_xinyu', 'Mao', 'Xinyu', 'M', 'Atuação: militar (general); historiador.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_mao_mao_anqing', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_mao', 'Família de Mao Tsé-Tung', 'Linhagem de Mao Tsé-Tung em Shaoshan, suas esposas e descendentes.', 'pub_mao_mao_zedong', 1, 'Figuras Históricas do Século XX', 'China', '1870 – 1976');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_mao_yichang', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_mao_zedong', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_yang_kaihui', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_he_zizhen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_jiang_qing', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_mao_anying', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_mao_anqing', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_li_min', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_li_na', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', 'pub_mao_mao_xinyu', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_mao_zedong', 'pub_mao_mao_zedong', 'nascimento', 1893, 1893, 'exata', '1893');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_mao_zedong', 'pub_mao_mao_zedong', 'falecimento', 1976, 1976, 'exata', '1976');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_yang_kaihui', 'pub_mao_yang_kaihui', 'nascimento', 1901, 1901, 'exata', '1901');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_yang_kaihui', 'pub_mao_yang_kaihui', 'falecimento', 1930, 1930, 'exata', '1930');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_he_zizhen', 'pub_mao_he_zizhen', 'nascimento', 1910, 1910, 'exata', '1910');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_he_zizhen', 'pub_mao_he_zizhen', 'falecimento', 1984, 1984, 'exata', '1984');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_jiang_qing', 'pub_mao_jiang_qing', 'nascimento', 1914, 1914, 'exata', '1914');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_jiang_qing', 'pub_mao_jiang_qing', 'falecimento', 1991, 1991, 'exata', '1991');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_mao_anying', 'pub_mao_mao_anying', 'nascimento', 1922, 1922, 'exata', '1922');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_mao_anying', 'pub_mao_mao_anying', 'falecimento', 1950, 1950, 'exata', '1950');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_mao_anqing', 'pub_mao_mao_anqing', 'nascimento', 1924, 1924, 'exata', '1924');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mao_mao_anqing', 'pub_mao_mao_anqing', 'falecimento', 2007, 2007, 'exata', '2007');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_li_min', 'pub_mao_li_min', 'nascimento', 1936, 1936, 'exata', '1936');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_li_na', 'pub_mao_li_na', 'nascimento', 1940, 1940, 'exata', '1940');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mao_mao_xinyu', 'pub_mao_mao_xinyu', 'nascimento', 1970, 1970, 'exata', '1970');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mao_yichang_zedong', 'pub_mao_mao_yichang', 'pub_mao_mao_yichang', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', NULL, 'pub_u_mao_yichang_zedong');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mao_yichang_zedong', 'pub_mao_mao_zedong', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mao_zedong_yang', 'pub_mao_mao_zedong', 'pub_mao_yang_kaihui', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', NULL, 'pub_u_mao_zedong_yang');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_mao_zedong_yang', 'pub_mao_mao_anying', 'biologico', 1),
('pub_u_mao_zedong_yang', 'pub_mao_mao_anqing', 'biologico', 2);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mao_zedong_he', 'pub_mao_mao_zedong', 'pub_mao_he_zizhen', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', NULL, 'pub_u_mao_zedong_he');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mao_zedong_he', 'pub_mao_li_min', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mao_zedong_jiang', 'pub_mao_mao_zedong', 'pub_mao_jiang_qing', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', NULL, 'pub_u_mao_zedong_jiang');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mao_zedong_jiang', 'pub_mao_li_na', 'biologico', 1);

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mao_anqing_xinyu', 'pub_mao_mao_anqing', 'pub_mao_mao_anqing', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mao', NULL, 'pub_u_mao_anqing_xinyu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mao_anqing_xinyu', 'pub_mao_mao_xinyu', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Mussolini
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_alessandro_mussolini', 'Alessandro', 'Mussolini', 'M', 'Atuação: ferreiro; socialista.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_benito_mussolini', 'Benito', 'Mussolini', 'M', 'Fundador do fascismo; ditador da Itália (o "Duce") de 1922 a 1943.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_rachele_mussolini', 'Rachele', 'Mussolini', 'F', 'Donna Rachele Guidi; primeira-dama da Itália fascista, esposa de Benito Mussolini e mãe de seus filhos.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_edda_mussolini', 'Edda', 'Ciano', 'F', 'Filha mais velha do Duce; casada com o chanceler Galeazzo Ciano.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_galeazzo_ciano', 'Galeazzo', 'Ciano', 'U', 'Atuação: político (ministro das Relações Exteriores).', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_vittorio_mussolini', 'Vittorio', 'Mussolini', 'M', 'Atuação: crítico e produtor de cinema.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_bruno_mussolini', 'Bruno', 'Mussolini', 'M', 'Atuação: aviador militar.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_romano_mussolini', 'Romano', 'Mussolini', 'U', 'Filho caçula homem do Duce; pianista de jazz e pintor.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_anna_maria_mussolini', 'Anna Maria', 'Mussolini', 'F', 'Atuação: locutora de rádio.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_alessandra_mussolini', 'Alessandra', 'Mussolini', 'F', 'Neta do Duce; política (deputada e eurodeputada).', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_mussolini_rachele_mussolini_politica', 'Rachele', 'Mussolini', 'F', 'Atuação: política.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_mussolini_romano_mussolini', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_mussolini', 'Família Mussolini', 'Família do ditador fascista Benito Mussolini e sua descendência política e artística.', 'pub_mussolini_benito_mussolini', 1, 'Figuras Históricas do Século XX', 'Itália', '1854 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_alessandro_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_benito_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_rachele_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_edda_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_galeazzo_ciano', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_vittorio_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_bruno_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_romano_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_anna_maria_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_alessandra_mussolini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', 'pub_mussolini_rachele_mussolini_politica', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_benito_mussolini', 'pub_mussolini_benito_mussolini', 'nascimento', 1883, 1883, 'exata', '1883');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_benito_mussolini', 'pub_mussolini_benito_mussolini', 'falecimento', 1945, 1945, 'exata', '1945');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_rachele_mussolini', 'pub_mussolini_rachele_mussolini', 'nascimento', 1890, 1890, 'exata', '1890');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_rachele_mussolini', 'pub_mussolini_rachele_mussolini', 'falecimento', 1979, 1979, 'exata', '1979');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_edda_mussolini', 'pub_mussolini_edda_mussolini', 'nascimento', 1910, 1910, 'exata', '1910');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_edda_mussolini', 'pub_mussolini_edda_mussolini', 'falecimento', 1995, 1995, 'exata', '1995');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_galeazzo_ciano', 'pub_mussolini_galeazzo_ciano', 'nascimento', 1903, 1903, 'exata', '1903');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_galeazzo_ciano', 'pub_mussolini_galeazzo_ciano', 'falecimento', 1944, 1944, 'exata', '1944');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_vittorio_mussolini', 'pub_mussolini_vittorio_mussolini', 'nascimento', 1916, 1916, 'exata', '1916');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_vittorio_mussolini', 'pub_mussolini_vittorio_mussolini', 'falecimento', 1997, 1997, 'exata', '1997');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_bruno_mussolini', 'pub_mussolini_bruno_mussolini', 'nascimento', 1918, 1918, 'exata', '1918');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_bruno_mussolini', 'pub_mussolini_bruno_mussolini', 'falecimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_romano_mussolini', 'pub_mussolini_romano_mussolini', 'nascimento', 1927, 1927, 'exata', '1927');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_romano_mussolini', 'pub_mussolini_romano_mussolini', 'falecimento', 2006, 2006, 'exata', '2006');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_anna_maria_mussolini', 'pub_mussolini_anna_maria_mussolini', 'nascimento', 1929, 1929, 'exata', '1929');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mussolini_anna_maria_mussolini', 'pub_mussolini_anna_maria_mussolini', 'falecimento', 1968, 1968, 'exata', '1968');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_alessandra_mussolini', 'pub_mussolini_alessandra_mussolini', 'nascimento', 1962, 1962, 'exata', '1962');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mussolini_rachele_mussolini_politica', 'pub_mussolini_rachele_mussolini_politica', 'nascimento', 1974, 1974, 'exata', '1974');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_benito_mussolini', 'pub_mussolini_rachele_mussolini', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', NULL, 'pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_galeazzo_ciano_pub_mus', 'pub_mussolini_galeazzo_ciano', 'pub_mussolini_edda_mussolini', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', NULL, 'pub_u_pub_arv_mussolini_pub_mussolini_galeazzo_ciano_pub_mus');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_romano_mussolini_pub_p', 'pub_mussolini_romano_mussolini', 'pub_ph_pub_mussolini_romano_mussolini', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_mussolini', NULL, 'pub_u_pub_arv_mussolini_pub_mussolini_romano_mussolini_pub_p');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_edda_mussolini', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_vittorio_mussolini', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_bruno_mussolini', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m', 'pub_mussolini_romano_mussolini', 'biologico', 4);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_romano_mussolini_pub_p', 'pub_mussolini_alessandra_mussolini', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_mussolini_pub_mussolini_romano_mussolini_pub_p', 'pub_mussolini_rachele_mussolini_politica', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Família Stalin (Jughashvili)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_besarion_jughashvili', 'Besarion', 'Jughashvili', 'M', 'Atuação: sapateiro.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_stalin', 'Josef', 'Stalin', 'M', 'Líder da União Soviética de meados dos anos 1920 até 1953.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_kato_svanidze', 'Kato', 'Svanidze', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_nadezhda_alliluyeva', 'Nadezhda', 'Alliluyeva', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_yakov_dzhugashvili', 'Yakov', 'Dzhugashvili', 'M', 'Atuação: militar.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_vasily_stalin', 'Vasily', 'Stalin', 'M', 'Atuação: militar (general da Força Aérea).', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_svetlana_alliluyeva', 'Svetlana', 'Alliluyeva', 'F', 'Filha de Stalin; causou sensação ao desertar para os EUA em 1967.', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_stalin_chrese_evans', 'Chrese', 'Evans', 'F', '', 0, 0, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_stalin_svetlana_alliluyeva', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Figuras Históricas do Século XX');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_stalin', 'Família Stalin (Jughashvili)', 'Família de Josef Stalin, suas duas esposas e filhos na União Soviética.', 'pub_stalin_besarion_jughashvili', 1, 'Figuras Históricas do Século XX', 'União Soviética / Geórgia', '1850 – 2011');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_besarion_jughashvili', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_stalin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_kato_svanidze', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_nadezhda_alliluyeva', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_yakov_dzhugashvili', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_vasily_stalin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_svetlana_alliluyeva', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', 'pub_stalin_chrese_evans', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_stalin', 'pub_stalin_stalin', 'nascimento', 1878, 1878, 'exata', '1878');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_stalin', 'pub_stalin_stalin', 'falecimento', 1953, 1953, 'exata', '1953');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_kato_svanidze', 'pub_stalin_kato_svanidze', 'nascimento', 1885, 1885, 'exata', '1885');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_kato_svanidze', 'pub_stalin_kato_svanidze', 'falecimento', 1907, 1907, 'exata', '1907');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_nadezhda_alliluyeva', 'pub_stalin_nadezhda_alliluyeva', 'nascimento', 1901, 1901, 'exata', '1901');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_nadezhda_alliluyeva', 'pub_stalin_nadezhda_alliluyeva', 'falecimento', 1932, 1932, 'exata', '1932');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_yakov_dzhugashvili', 'pub_stalin_yakov_dzhugashvili', 'nascimento', 1907, 1907, 'exata', '1907');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_yakov_dzhugashvili', 'pub_stalin_yakov_dzhugashvili', 'falecimento', 1943, 1943, 'exata', '1943');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_vasily_stalin', 'pub_stalin_vasily_stalin', 'nascimento', 1921, 1921, 'exata', '1921');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_vasily_stalin', 'pub_stalin_vasily_stalin', 'falecimento', 1962, 1962, 'exata', '1962');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_svetlana_alliluyeva', 'pub_stalin_svetlana_alliluyeva', 'nascimento', 1926, 1926, 'exata', '1926');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_stalin_svetlana_alliluyeva', 'pub_stalin_svetlana_alliluyeva', 'falecimento', 2011, 2011, 'exata', '2011');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_stalin_chrese_evans', 'pub_stalin_chrese_evans', 'nascimento', 1971, 1971, 'exata', '1971');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_kato_svani', 'pub_stalin_stalin', 'pub_stalin_kato_svanidze', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', NULL, 'pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_kato_svani');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_nadezhda_a', 'pub_stalin_stalin', 'pub_stalin_nadezhda_alliluyeva', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', NULL, 'pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_nadezhda_a');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_stalin_pub_ph_pub_stalin_svetlana_alliluyeva_p', 'pub_ph_pub_stalin_svetlana_alliluyeva', 'pub_stalin_svetlana_alliluyeva', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_stalin', NULL, 'pub_u_pub_arv_stalin_pub_ph_pub_stalin_svetlana_alliluyeva_p');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_kato_svani', 'pub_stalin_yakov_dzhugashvili', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_nadezhda_a', 'pub_stalin_vasily_stalin', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_stalin_pub_stalin_stalin_pub_stalin_nadezhda_a', 'pub_stalin_svetlana_alliluyeva', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_stalin_pub_ph_pub_stalin_svetlana_alliluyeva_p', 'pub_stalin_chrese_evans', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Dinastia Bush
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_samuel_p_bush', 'Samuel P.', 'Bush', 'M', 'Industrial do aço; patriarca da dinastia Bush.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_prescott_bush', 'Prescott', 'Bush', 'M', 'Banqueiro e senador dos EUA por Connecticut.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_dorothy_walker_bush', 'Dorothy Walker', 'Bush', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_marvin_pierce', 'Marvin', 'Pierce', 'M', 'Atuação: executivo editorial (McCall Corporation).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_george_h_w_bush', 'George H. W.', 'Bush', 'M', '41º presidente dos EUA (e 43º vice-presidente); antes, diretor da CIA e embaixador na ONU.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_barbara_bush', 'Barbara', 'Bush', 'F', 'Primeira-dama; fundadora da Barbara Bush Foundation for Family Literacy.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_george_w_bush', 'George W.', 'Bush', 'M', '43º presidente dos EUA; antes, governador do Texas.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_laura_bush', 'Laura', 'Bush', 'F', 'Atuação: professora; bibliotecária; primeira-dama.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_pauline_robinson_bush', 'Robin', 'Bush', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_jeb_bush', 'Jeb', 'Bush', 'M', 'Governador da Flórida.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_neil_bush', 'Neil', 'Bush', 'M', 'Atuação: empresário.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_marvin_bush', 'Marvin', 'Bush', 'M', 'Atuação: empresário.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_dorothy_bush_koch', 'Dorothy "Doro" Bush', 'Koch', 'F', 'Atuação: escritora; filantropa.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_george_p_bush', 'George P.', 'Bush', 'M', 'Atuação: político (comissário de terras do Texas).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_jenna_bush_hager', 'Jenna Bush', 'Hager', 'F', 'Atuação: jornalista; apresentadora; escritora.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bush_barbara_pierce_bush', 'Barbara Pierce', 'Bush', 'F', 'Atuação: ativista de saúde global.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bush_samuel_p_bush', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bush_marvin_pierce', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bush_jeb_bush', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_bush', 'Dinastia Bush', 'Influente família norte-americana de senadores, industriais do petróleo e dois presidentes dos EUA.', 'pub_bush_barbara_bush', 1, 'Grandes Empreendedores', 'Estados Unidos', '1895 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_samuel_p_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_prescott_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_dorothy_walker_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_marvin_pierce', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_george_h_w_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_barbara_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_george_w_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_laura_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_pauline_robinson_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_jeb_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_neil_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_marvin_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_dorothy_bush_koch', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_george_p_bush', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_jenna_bush_hager', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', 'pub_bush_barbara_pierce_bush', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_samuel_p_bush', 'pub_bush_samuel_p_bush', 'nascimento', 1863, 1863, 'exata', '1863');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_samuel_p_bush', 'pub_bush_samuel_p_bush', 'falecimento', 1948, 1948, 'exata', '1948');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_prescott_bush', 'pub_bush_prescott_bush', 'nascimento', 1895, 1895, 'exata', '1895');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_prescott_bush', 'pub_bush_prescott_bush', 'falecimento', 1972, 1972, 'exata', '1972');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_dorothy_walker_bush', 'pub_bush_dorothy_walker_bush', 'nascimento', 1901, 1901, 'exata', '1901');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_dorothy_walker_bush', 'pub_bush_dorothy_walker_bush', 'falecimento', 1992, 1992, 'exata', '1992');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_marvin_pierce', 'pub_bush_marvin_pierce', 'nascimento', 1893, 1893, 'exata', '1893');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_marvin_pierce', 'pub_bush_marvin_pierce', 'falecimento', 1969, 1969, 'exata', '1969');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_george_h_w_bush', 'pub_bush_george_h_w_bush', 'nascimento', 1924, 1924, 'exata', '1924');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_george_h_w_bush', 'pub_bush_george_h_w_bush', 'falecimento', 2018, 2018, 'exata', '2018');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_barbara_bush', 'pub_bush_barbara_bush', 'nascimento', 1925, 1925, 'exata', '1925');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_barbara_bush', 'pub_bush_barbara_bush', 'falecimento', 2018, 2018, 'exata', '2018');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_george_w_bush', 'pub_bush_george_w_bush', 'nascimento', 1946, 1946, 'exata', '1946');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_laura_bush', 'pub_bush_laura_bush', 'nascimento', 1946, 1946, 'exata', '1946');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_pauline_robinson_bush', 'pub_bush_pauline_robinson_bush', 'nascimento', 1949, 1949, 'exata', '1949');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bush_pauline_robinson_bush', 'pub_bush_pauline_robinson_bush', 'falecimento', 1953, 1953, 'exata', '1953');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_jeb_bush', 'pub_bush_jeb_bush', 'nascimento', 1953, 1953, 'exata', '1953');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_neil_bush', 'pub_bush_neil_bush', 'nascimento', 1955, 1955, 'exata', '1955');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_marvin_bush', 'pub_bush_marvin_bush', 'nascimento', 1956, 1956, 'exata', '1956');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_dorothy_bush_koch', 'pub_bush_dorothy_bush_koch', 'nascimento', 1959, 1959, 'exata', '1959');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_george_p_bush', 'pub_bush_george_p_bush', 'nascimento', 1976, 1976, 'exata', '1976');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_jenna_bush_hager', 'pub_bush_jenna_bush_hager', 'nascimento', 1981, 1981, 'exata', '1981');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bush_barbara_pierce_bush', 'pub_bush_barbara_pierce_bush', 'nascimento', 1981, 1981, 'exata', '1981');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_prescott_bush_pub_bush_dorothy_w', 'pub_bush_prescott_bush', 'pub_bush_dorothy_walker_bush', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_prescott_bush_pub_bush_dorothy_w');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_george_h_w_bush', 'pub_bush_barbara_bush', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_w_bush_pub_bush_laura_bus', 'pub_bush_george_w_bush', 'pub_bush_laura_bush', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_george_w_bush_pub_bush_laura_bus');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_samuel_p_bush_pub_ph_pub_bush_sa', 'pub_bush_samuel_p_bush', 'pub_ph_pub_bush_samuel_p_bush', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_samuel_p_bush_pub_ph_pub_bush_sa');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_marvin_pierce_pub_ph_pub_bush_ma', 'pub_bush_marvin_pierce', 'pub_ph_pub_bush_marvin_pierce', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_marvin_pierce_pub_ph_pub_bush_ma');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_bush_pub_bush_jeb_bush_pub_ph_pub_bush_jeb_bus', 'pub_bush_jeb_bush', 'pub_ph_pub_bush_jeb_bush', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bush', NULL, 'pub_u_pub_arv_bush_pub_bush_jeb_bush_pub_ph_pub_bush_jeb_bus');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_samuel_p_bush_pub_ph_pub_bush_sa', 'pub_bush_prescott_bush', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_prescott_bush_pub_bush_dorothy_w', 'pub_bush_george_h_w_bush', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_marvin_pierce_pub_ph_pub_bush_ma', 'pub_bush_barbara_bush', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_george_w_bush', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_pauline_robinson_bush', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_jeb_bush', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_neil_bush', 'biologico', 4);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_h_w_bush_pub_bush_barbara', 'pub_bush_marvin_bush', 'biologico', 5);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_jeb_bush_pub_ph_pub_bush_jeb_bus', 'pub_bush_george_p_bush', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_w_bush_pub_bush_laura_bus', 'pub_bush_jenna_bush_hager', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_bush_pub_bush_george_w_bush_pub_bush_laura_bus', 'pub_bush_barbara_pierce_bush', 'biologico', 2);

-- =====================================================================
-- ÁRVORE: Família Guinle
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_jean_arnauld_guinle', 'Jean-Arnauld', 'Guinle', 'M', 'Atuação: imigrante (comerciante).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_josephine_palassin', 'Josephine Désirée Bernardine', 'Palassin', 'U', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_eduardo_palassin_guinle', 'Eduardo Palassin', 'Guinle', 'M', 'Patriarca da dinastia; cofundador da Companhia Docas de Santos e um dos homens mais ricos do Brasil.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_guilhermina_coutinho_da_silva', 'Guilhermina Coutinho', 'da Silva', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_eduardo_guinle_filho', 'Eduardo', 'Guinle', 'M', 'Primogênito; pioneiro do setor imobiliário carioca (comprou terrenos de Copacabana em 1902).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_guilherme_guinle', 'Guilherme', 'Guinle', 'M', 'Empresário e mecenas; ligado à criação da CSN e a hospitais (Gaffrée e Guinle).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_carlos_guinle', 'Carlos', 'Guinle', 'M', 'Atuação: empresário.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_arnaldo_guinle', 'Arnaldo', 'Guinle', 'M', 'Empresário e mecenas do esporte; grande patrono do Fluminense F.C.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_octavio_guinle', 'Octávio', 'Guinle', 'M', 'Fundador do Copacabana Palace (1923) e construtor do Palácio das Laranjeiras.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_celina_guinle', 'Celina', 'Guinle', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_heloisa_guinle', 'Heloísa', 'Guinle', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_jorge_guinle', 'Jorge "Jorginho"', 'Guinle', 'M', 'Bon vivant e crítico de jazz; dilapidou boa parte da fortuna herdada.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_guinle_guilhermina_guinle', 'Guilhermina', 'Guinle', 'F', 'Atuação: atriz.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_guinle_carlos_guinle', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_guinle', 'Família Guinle', 'Pioneiros da infraestrutura moderna brasileira (Porto de Santos) e hotelaria (Copacabana Palace).', 'pub_guinle_jean_arnauld_guinle', 1, 'Grandes Empreendedores', 'Brasil', '1846 – Séc. XX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_jean_arnauld_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_josephine_palassin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_eduardo_palassin_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_guilhermina_coutinho_da_silva', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_eduardo_guinle_filho', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_guilherme_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_carlos_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_arnaldo_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_octavio_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_celina_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_heloisa_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_jorge_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', 'pub_guinle_guilhermina_guinle', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_guinle_eduardo_palassin_guinle', 'pub_guinle_eduardo_palassin_guinle', 'nascimento', 1846, 1846, 'exata', '1846');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_guinle_eduardo_palassin_guinle', 'pub_guinle_eduardo_palassin_guinle', 'falecimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_guinle_guilherme_guinle', 'pub_guinle_guilherme_guinle', 'nascimento', 1882, 1882, 'exata', '1882');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_guinle_guilherme_guinle', 'pub_guinle_guilherme_guinle', 'falecimento', 1960, 1960, 'exata', '1960');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_guinle_jorge_guinle', 'pub_guinle_jorge_guinle', 'nascimento', 1916, 1916, 'exata', '1916');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_guinle_jorge_guinle', 'pub_guinle_jorge_guinle', 'falecimento', 2004, 2004, 'exata', '2004');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_eduardo_palassin_guinle', 'pub_guinle_guilhermina_coutinho_da_silva', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', NULL, 'pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui', 'pub_guinle_carlos_guinle', 'pub_ph_pub_guinle_carlos_guinle', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_guinle', NULL, 'pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_eduardo_guinle_filho', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_guilherme_guinle', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_carlos_guinle', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_arnaldo_guinle', 'biologico', 4);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_octavio_guinle', 'biologico', 5);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_celina_guinle', 'biologico', 6);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_heloisa_guinle', 'biologico', 7);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui', 'pub_guinle_jorge_guinle', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Klabin-Lafer
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_mauricio_freeman_klabin', 'Maurício Freeman', 'Klabin', 'M', 'Imigrante lituano; fundou a Klabin Irmãos & Cia, origem da maior papeleira do Brasil.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_nessel_klabin', 'Nessel', 'Klabin', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_miguel_lafer', 'Miguel', 'Lafer', 'M', 'Atuação: empresário (cofundador da KIC).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_wolff_klabin', 'Wolff', 'Klabin', 'M', 'Dirigiu o grupo Klabin e, com Horácio Lafer, criou nos anos 1940 a primeira grande indústria de celulose do Brasil (Monte Alegre, PR).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_horacio_lafer', 'Horácio', 'Lafer', 'M', 'Empresário e estadista; ministro da Fazenda (1951) e das Relações Exteriores (1959).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_israel_klabin', 'Israel', 'Klabin', 'U', 'Engenheiro, ambientalista e ex-prefeito do Rio de Janeiro (1979–1980).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_celso_lafer', 'Celso', 'Lafer', 'U', 'Jurista e diplomata; ministro das Relações Exteriores (1992 e 2001–02); membro da ABL.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_klabin_horacio_lafer_piva', 'Horácio Lafer', 'Piva', 'M', 'Atuação: empresário (ex-presidente da FIESP).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_klabin', 'Família Klabin-Lafer', 'Fundadores da maior indústria papeleira do Brasil e diplomatas proeminentes.', 'pub_klabin_miguel_lafer', 1, 'Grandes Empreendedores', 'Brasil / Lituânia', '1850 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_mauricio_freeman_klabin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_nessel_klabin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_miguel_lafer', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_wolff_klabin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_horacio_lafer', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_israel_klabin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_celso_lafer', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', 'pub_klabin_horacio_lafer_piva', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_mauricio_freeman_klabin', 'pub_klabin_mauricio_freeman_klabin', 'nascimento', 1860, 1860, 'exata', '1860');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_klabin_mauricio_freeman_klabin', 'pub_klabin_mauricio_freeman_klabin', 'falecimento', 1923, 1923, 'exata', '1923');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_nessel_klabin', 'pub_klabin_nessel_klabin', 'nascimento', 1880, 1880, 'exata', '1880');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_klabin_nessel_klabin', 'pub_klabin_nessel_klabin', 'falecimento', 1955, 1955, 'exata', '1955');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_miguel_lafer', 'pub_klabin_miguel_lafer', 'nascimento', 1876, 1876, 'exata', '1876');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_klabin_miguel_lafer', 'pub_klabin_miguel_lafer', 'falecimento', 1926, 1926, 'exata', '1926');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_wolff_klabin', 'pub_klabin_wolff_klabin', 'nascimento', 1880, 1880, 'exata', '1880');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_klabin_wolff_klabin', 'pub_klabin_wolff_klabin', 'falecimento', 1957, 1957, 'exata', '1957');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_horacio_lafer', 'pub_klabin_horacio_lafer', 'nascimento', 1900, 1900, 'exata', '1900');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_klabin_horacio_lafer', 'pub_klabin_horacio_lafer', 'falecimento', 1965, 1965, 'exata', '1965');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_israel_klabin', 'pub_klabin_israel_klabin', 'nascimento', 1926, 1926, 'exata', '1926');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_celso_lafer', 'pub_klabin_celso_lafer', 'nascimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_klabin_horacio_lafer_piva', 'pub_klabin_horacio_lafer_piva', 'nascimento', 1957, 1957, 'exata', '1957');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_klabin_pub_klabin_miguel_lafer_pub_klabin_ness', 'pub_klabin_miguel_lafer', 'pub_klabin_nessel_klabin', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_klabin', NULL, 'pub_u_pub_arv_klabin_pub_klabin_miguel_lafer_pub_klabin_ness');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_klabin_pub_klabin_miguel_lafer_pub_klabin_ness', 'pub_klabin_horacio_lafer', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Matarazzo
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_costabile_matarazzo', 'Costabile', 'Matarazzo', 'M', 'Atuação: médico; comerciante.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_francesco_matarazzo', 'Francesco', 'Matarazzo', 'M', 'Imigrante italiano que fundou as Indústrias Reunidas Fábricas Matarazzo (IRFM), o maior conglomerado industrial da América Latina.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_filomena_matarazzo', 'Filomena', 'Matarazzo', 'F', '', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_francisco_matarazzo_junior', 'Francisco Matarazzo', 'Júnior', 'M', 'Filho e sucessor do fundador; comandou as IRFM por cerca de 40 anos.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_ermelino_matarazzo', 'Ermelino', 'Matarazzo', 'M', 'Atuação: industrial (comendador).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_ciccillo_matarazzo', 'Ciccillo', 'Matarazzo', 'M', 'Mecenas das artes; fundador da Bienal de São Paulo e do MAM-SP; ex-prefeito de Ubatuba.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_maria_pia_matarazzo', 'Maria Pia', 'Matarazzo', 'F', 'Atuação: empresária (sucessora nas IRFM).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_francisco_matarazzo_pignatari', 'Baby', 'Pignatari', 'M', 'Industrial e célebre bon vivant ("Baby" Pignatari).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_jose_eduardo_matarazzo_kalil', 'José Eduardo Matarazzo', 'Kalil', 'M', 'Atuação: —.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_matarazzo_eduardo_matarazzo_suplicy', 'Eduardo Matarazzo', 'Suplicy', 'M', 'Atuação: economista; político (senador; vereador).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_matarazzo_francisco_matarazzo_junior', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_matarazzo_maria_pia_matarazzo', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_matarazzo', 'Família Matarazzo', 'Maior conglomerado industrial da história da América Latina sob o comando do Conde Francesco Matarazzo.', 'pub_matarazzo_francisco_matarazzo_pignatari', 1, 'Grandes Empreendedores', 'Brasil / Itália', '1854 – 1977');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_costabile_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_francesco_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_filomena_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_francisco_matarazzo_junior', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_ermelino_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_ciccillo_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_maria_pia_matarazzo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_francisco_matarazzo_pignatari', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_jose_eduardo_matarazzo_kalil', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', 'pub_matarazzo_eduardo_matarazzo_suplicy', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matarazzo_costabile_matarazzo', 'pub_matarazzo_costabile_matarazzo', 'falecimento', 1873, 1873, 'exata', '1873');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matarazzo_francesco_matarazzo', 'pub_matarazzo_francesco_matarazzo', 'nascimento', 1854, 1854, 'exata', '1854');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matarazzo_francesco_matarazzo', 'pub_matarazzo_francesco_matarazzo', 'falecimento', 1937, 1937, 'exata', '1937');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matarazzo_francisco_matarazzo_junior', 'pub_matarazzo_francisco_matarazzo_junior', 'nascimento', 1900, 1900, 'cerca_de', 'cerca de 1900');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matarazzo_francisco_matarazzo_junior', 'pub_matarazzo_francisco_matarazzo_junior', 'falecimento', 1977, 1977, 'exata', '1977');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matarazzo_ciccillo_matarazzo', 'pub_matarazzo_ciccillo_matarazzo', 'nascimento', 1898, 1898, 'exata', '1898');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matarazzo_ciccillo_matarazzo', 'pub_matarazzo_ciccillo_matarazzo', 'falecimento', 1977, 1977, 'exata', '1977');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matarazzo_francisco_matarazzo_pignatari', 'pub_matarazzo_francisco_matarazzo_pignatari', 'nascimento', 1917, 1917, 'exata', '1917');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_matarazzo_francisco_matarazzo_pignatari', 'pub_matarazzo_francisco_matarazzo_pignatari', 'falecimento', 1977, 1977, 'exata', '1977');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_matarazzo_eduardo_matarazzo_suplicy', 'pub_matarazzo_eduardo_matarazzo_suplicy', 'nascimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu', 'pub_matarazzo_francesco_matarazzo', 'pub_matarazzo_filomena_matarazzo', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', NULL, 'pub_u_pub_arv_matarazzo_pub_matarazzo_francesco_matarazzo_pu');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_matarazzo_pub_matarazzo_francisco_matarazzo_ju', 'pub_matarazzo_francisco_matarazzo_junior', 'pub_ph_pub_matarazzo_francisco_matarazzo_junior', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', NULL, 'pub_u_pub_arv_matarazzo_pub_matarazzo_francisco_matarazzo_ju');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_matarazzo_pub_ph_pub_matarazzo_maria_pia_matar', 'pub_ph_pub_matarazzo_maria_pia_matarazzo', 'pub_matarazzo_maria_pia_matarazzo', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_matarazzo', NULL, 'pub_u_pub_arv_matarazzo_pub_ph_pub_matarazzo_maria_pia_matar');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_matarazzo_pub_matarazzo_francisco_matarazzo_ju', 'pub_matarazzo_maria_pia_matarazzo', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_matarazzo_pub_ph_pub_matarazzo_maria_pia_matar', 'pub_matarazzo_jose_eduardo_matarazzo_kalil', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Rockefeller
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_william_avery_rockefeller_sr', 'William A. Rockefeller', 'Sr.', 'M', 'Atuação: vendedor ambulante.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_john_d_rockefeller', 'John D.', 'Rockefeller', 'M', 'Fundador da Standard Oil; primeiro bilionário do mundo (1916) e grande filantropo.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_laura_spelman_rockefeller', 'Laura "Cettie" Spelman', 'Rockefeller', 'F', 'Atuação: professora.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_william_rockefeller', 'William', 'Rockefeller', 'M', 'Atuação: empresário (cofundador da Standard Oil).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_john_d_rockefeller_jr', 'John D. Rockefeller', 'Jr.', 'M', 'Financista e filantropo; único filho homem do fundador; financiou o Rockefeller Center e a doação do terreno da ONU.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_abby_aldrich_rockefeller', 'Abby Aldrich', 'Rockefeller', 'F', 'Socialite e filantropa; força motriz na criação do MoMA.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_abby_rockefeller_mauze', 'Abby "Babs" Rockefeller', 'Mauzé', 'F', 'Atuação: filantropa.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_john_d_rockefeller_iii', 'John D. Rockefeller', 'III', 'M', 'Filantropo; fundou a Asia Society e foi decisivo no Lincoln Center.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_nelson_rockefeller', 'Nelson', 'Rockefeller', 'M', '41º vice-presidente dos EUA e governador de Nova York.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_laurance_rockefeller', 'Laurance', 'Rockefeller', 'M', 'Financista e conservacionista; capital de risco pioneiro (Intel, Apple).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_winthrop_rockefeller', 'Winthrop', 'Rockefeller', 'M', 'Governador do Arkansas.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_david_rockefeller', 'David', 'Rockefeller', 'M', 'Banqueiro; presidente do Chase Manhattan e figura de projeção internacional.', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_rockefeller_john_d_rockefeller_iv', 'Jay', 'Rockefeller', 'M', 'Atuação: político (senador dos EUA pela Virgínia Ocidental; governador).', 0, 0, 1, 'Grandes Empreendedores');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_rockefeller', 'Família Rockefeller', 'Fundadores da Standard Oil, pioneiros da filantropia moderna, finanças e política norte-americana.', 'pub_rockefeller_john_d_rockefeller', 1, 'Grandes Empreendedores', 'Estados Unidos', '1810 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_william_avery_rockefeller_sr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_john_d_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_laura_spelman_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_william_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_john_d_rockefeller_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_abby_aldrich_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_abby_rockefeller_mauze', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_john_d_rockefeller_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_nelson_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_laurance_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_winthrop_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_david_rockefeller', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', 'pub_rockefeller_john_d_rockefeller_iv', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_william_avery_rockefeller_sr', 'pub_rockefeller_william_avery_rockefeller_sr', 'nascimento', 1810, 1810, 'exata', '1810');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_william_avery_rockefeller_sr', 'pub_rockefeller_william_avery_rockefeller_sr', 'falecimento', 1906, 1906, 'exata', '1906');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_john_d_rockefeller', 'pub_rockefeller_john_d_rockefeller', 'nascimento', 1839, 1839, 'exata', '1839');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_john_d_rockefeller', 'pub_rockefeller_john_d_rockefeller', 'falecimento', 1937, 1937, 'exata', '1937');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_laura_spelman_rockefeller', 'pub_rockefeller_laura_spelman_rockefeller', 'nascimento', 1839, 1839, 'exata', '1839');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_laura_spelman_rockefeller', 'pub_rockefeller_laura_spelman_rockefeller', 'falecimento', 1915, 1915, 'exata', '1915');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_william_rockefeller', 'pub_rockefeller_william_rockefeller', 'nascimento', 1841, 1841, 'exata', '1841');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_william_rockefeller', 'pub_rockefeller_william_rockefeller', 'falecimento', 1922, 1922, 'exata', '1922');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_john_d_rockefeller_jr', 'pub_rockefeller_john_d_rockefeller_jr', 'nascimento', 1874, 1874, 'exata', '1874');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_john_d_rockefeller_jr', 'pub_rockefeller_john_d_rockefeller_jr', 'falecimento', 1960, 1960, 'exata', '1960');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_abby_aldrich_rockefeller', 'pub_rockefeller_abby_aldrich_rockefeller', 'nascimento', 1874, 1874, 'exata', '1874');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_abby_aldrich_rockefeller', 'pub_rockefeller_abby_aldrich_rockefeller', 'falecimento', 1948, 1948, 'exata', '1948');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_abby_rockefeller_mauze', 'pub_rockefeller_abby_rockefeller_mauze', 'nascimento', 1903, 1903, 'exata', '1903');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_abby_rockefeller_mauze', 'pub_rockefeller_abby_rockefeller_mauze', 'falecimento', 1976, 1976, 'exata', '1976');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_john_d_rockefeller_iii', 'pub_rockefeller_john_d_rockefeller_iii', 'nascimento', 1906, 1906, 'exata', '1906');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_john_d_rockefeller_iii', 'pub_rockefeller_john_d_rockefeller_iii', 'falecimento', 1978, 1978, 'exata', '1978');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_nelson_rockefeller', 'pub_rockefeller_nelson_rockefeller', 'nascimento', 1908, 1908, 'exata', '1908');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_nelson_rockefeller', 'pub_rockefeller_nelson_rockefeller', 'falecimento', 1979, 1979, 'exata', '1979');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_laurance_rockefeller', 'pub_rockefeller_laurance_rockefeller', 'nascimento', 1910, 1910, 'exata', '1910');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_laurance_rockefeller', 'pub_rockefeller_laurance_rockefeller', 'falecimento', 2004, 2004, 'exata', '2004');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_winthrop_rockefeller', 'pub_rockefeller_winthrop_rockefeller', 'nascimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_winthrop_rockefeller', 'pub_rockefeller_winthrop_rockefeller', 'falecimento', 1973, 1973, 'exata', '1973');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_david_rockefeller', 'pub_rockefeller_david_rockefeller', 'nascimento', 1915, 1915, 'exata', '1915');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_rockefeller_david_rockefeller', 'pub_rockefeller_david_rockefeller', 'falecimento', 2017, 2017, 'exata', '2017');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_rockefeller_john_d_rockefeller_iv', 'pub_rockefeller_john_d_rockefeller_iv', 'nascimento', 1937, 1937, 'exata', '1937');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_rockefeller_pub_rockefeller_john_d_rockefeller', 'pub_rockefeller_john_d_rockefeller_iii', 'pub_rockefeller_laura_spelman_rockefeller', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_rockefeller', NULL, 'pub_u_pub_arv_rockefeller_pub_rockefeller_john_d_rockefeller');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_rockefeller_pub_rockefeller_john_d_rockefeller', 'pub_rockefeller_john_d_rockefeller_iv', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: 18ª Dinastia do Egito (Tutmésides e Amarna)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_amosis_i', 'Amosis I', '(Ahmose)', 'M', 'Atuação: faraó (fundador da dinastia).', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_hatshepsut', 'Hatshepsut', NULL, 'F', 'Uma das poucas mulheres a reinar como faraó, em prosperidade e grandes obras.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_tutmes_iii', 'Tutmés', 'III', 'M', 'Grande faraó guerreiro, expandiu o império ao máximo.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_amenofis_iii', 'Amenófis', 'III', 'M', 'Atuação: faraó.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_akhenaton', 'Akhenaton (Amenófis', 'IV)', 'M', 'Faraó que impôs o culto monoteísta a Aton e mudou a arte e a religião egípcias.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_nefertiti', 'Nefertiti', NULL, 'F', 'Atuação: rainha.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_18_tutancamon', 'Tutancâmon', NULL, 'M', 'O "faraó menino"; célebre pela tumba quase intacta descoberta em 1922.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_dinastia_18_tutmes_iii', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_dinastia_18_amenofis_iii', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_dinastia_18', '18ª Dinastia do Egito (Tutmésides e Amarna)', 'A dinastia do Novo Império que incluiu Hatshepsut, Akhenaton e Tutancâmon.', 'pub_dinastia_18_tutancamon', 1, 'Egito Antigo e Faraós', 'Egito Antigo', 'c. 1550 a.C. – 1292 a.C.');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_amosis_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_hatshepsut', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_tutmes_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_amenofis_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_akhenaton', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_nefertiti', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', 'pub_dinastia_18_tutancamon', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_dinastia_18_amosis_i', 'pub_dinastia_18_amosis_i', 'nascimento', -1560, -1560, 'cerca_de', 'cerca de 1560 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_dinastia_18_hatshepsut', 'pub_dinastia_18_hatshepsut', 'nascimento', -1507, -1507, 'cerca_de', 'cerca de 1507 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_18_hatshepsut', 'pub_dinastia_18_hatshepsut', 'falecimento', -1458, -1458, 'cerca_de', 'cerca de 1458 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_18_tutmes_iii', 'pub_dinastia_18_tutmes_iii', 'falecimento', -1425, -1425, 'cerca_de', 'cerca de 1425 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_18_amenofis_iii', 'pub_dinastia_18_amenofis_iii', 'falecimento', -1353, -1353, 'cerca_de', 'cerca de 1353 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_18_akhenaton', 'pub_dinastia_18_akhenaton', 'falecimento', -1336, -1336, 'cerca_de', 'cerca de 1336 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_dinastia_18_tutancamon', 'pub_dinastia_18_tutancamon', 'nascimento', -1341, -1341, 'cerca_de', 'cerca de 1341 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_18_tutancamon', 'pub_dinastia_18_tutancamon', 'falecimento', -1323, -1323, 'cerca_de', 'cerca de 1323 a.C.');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_akhenaton_pub_dina', 'pub_dinastia_18_akhenaton', 'pub_dinastia_18_nefertiti', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', NULL, 'pub_u_pub_arv_dinastia_18_pub_dinastia_18_akhenaton_pub_dina');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_tutmes_iii_pub_ph_', 'pub_dinastia_18_tutmes_iii', 'pub_ph_pub_dinastia_18_tutmes_iii', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', NULL, 'pub_u_pub_arv_dinastia_18_pub_dinastia_18_tutmes_iii_pub_ph_');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_amenofis_iii_pub_p', 'pub_dinastia_18_amenofis_iii', 'pub_ph_pub_dinastia_18_amenofis_iii', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_18', NULL, 'pub_u_pub_arv_dinastia_18_pub_dinastia_18_amenofis_iii_pub_p');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_tutmes_iii_pub_ph_', 'pub_dinastia_18_hatshepsut', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_amenofis_iii_pub_p', 'pub_dinastia_18_akhenaton', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_18_pub_dinastia_18_akhenaton_pub_dina', 'pub_dinastia_18_tutancamon', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: 19ª Dinastia do Egito (Ramsésidas)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_19_ramesses_i', 'Ramessés', 'I', 'M', 'Atuação: faraó (fundador da dinastia).', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_19_seti_i', 'Seti', 'I', 'M', 'Atuação: faraó.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_19_ramesses_ii', 'Ramessés', 'II', 'M', '"Ramessés, o Grande"; reinou cerca de 66 anos e teve mais de 100 filhos.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_19_nefertari', 'Nefertari', NULL, 'F', 'Atuação: rainha.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastia_19_merneptah', 'Merneptah', NULL, 'M', 'Atuação: faraó.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_dinastia_19_ramesses_i', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_dinastia_19_seti_i', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_dinastia_19', '19ª Dinastia do Egito (Ramsésidas)', 'Grande dinastia de guerreiros e construtores faraônicos, destacando Ramsés II, o Grande.', 'pub_dinastia_19_ramesses_i', 1, 'Egito Antigo e Faraós', 'Egito Antigo', 'c. 1292 a.C. – 1189 a.C.');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', 'pub_dinastia_19_ramesses_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', 'pub_dinastia_19_seti_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', 'pub_dinastia_19_ramesses_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', 'pub_dinastia_19_nefertari', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', 'pub_dinastia_19_merneptah', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_19_ramesses_i', 'pub_dinastia_19_ramesses_i', 'falecimento', -1290, -1290, 'cerca_de', 'cerca de 1290 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_19_seti_i', 'pub_dinastia_19_seti_i', 'falecimento', -1279, -1279, 'cerca_de', 'cerca de 1279 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_dinastia_19_ramesses_ii', 'pub_dinastia_19_ramesses_ii', 'nascimento', -1303, -1303, 'cerca_de', 'cerca de 1303 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_19_ramesses_ii', 'pub_dinastia_19_ramesses_ii', 'falecimento', -1213, -1213, 'cerca_de', 'cerca de 1213 a.C.');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_dinastia_19_merneptah', 'pub_dinastia_19_merneptah', 'falecimento', -1203, -1203, 'cerca_de', 'cerca de 1203 a.C.');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_dinastia_19_pub_dinastia_19_ramesses_i_pub_ph_', 'pub_dinastia_19_ramesses_i', 'pub_ph_pub_dinastia_19_ramesses_i', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', NULL, 'pub_u_pub_arv_dinastia_19_pub_dinastia_19_ramesses_i_pub_ph_');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_dinastia_19_pub_dinastia_19_seti_i_pub_ph_pub_', 'pub_dinastia_19_seti_i', 'pub_ph_pub_dinastia_19_seti_i', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastia_19', NULL, 'pub_u_pub_arv_dinastia_19_pub_dinastia_19_seti_i_pub_ph_pub_');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_19_pub_dinastia_19_ramesses_i_pub_ph_', 'pub_dinastia_19_seti_i', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_dinastia_19_pub_dinastia_19_seti_i_pub_ph_pub_', 'pub_dinastia_19_ramesses_ii', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Dinastias 21 a 23 do Egito (Terceiro Período Intermediário)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastias_21_23_psusennes_i', 'Psusennes', 'I', 'M', 'Atuação: faraó (21ª dinastia, Tânis).', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_dinastias_21_23_sheshonq_i', 'Sheshonq', 'I', 'M', 'Fundador da 22ª dinastia (líbia); frequentemente associado ao "Shishak" bíblico.', 0, 0, 1, 'Egito Antigo e Faraós');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_dinastias_21_23', 'Dinastias 21 a 23 do Egito (Terceiro Período Intermediário)', 'Período de governantes sacerdotes de Tebas e reis de Tânis.', 'pub_dinastias_21_23_sheshonq_i', 1, 'Egito Antigo e Faraós', 'Egito Antigo', 'c. 1069 a.C. – 715 a.C.');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastias_21_23', 'pub_dinastias_21_23_psusennes_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_dinastias_21_23', 'pub_dinastias_21_23_sheshonq_i', NULL);

-- =====================================================================
-- ÁRVORE: Família Buendía (Cem Anos de Solidão)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_jose_arcadio_buendia', 'José Arcadio', 'Buendía', 'M', 'Fundador de Macondo; visionário obcecado por alquimia.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_ursula_iguaran', 'Úrsula', 'Iguarán', 'F', 'Matriarca longeva; teme a maldição do incesto (um filho com cauda de porco).', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_jose_arcadio', 'José Arcadio', '(filho)', 'U', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_coronel_aureliano_buendia', 'Coronel Aureliano', 'Buendía', 'M', 'Líder rebelde; teve 17 filhos, todos chamados Aureliano.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_amaranta', 'Amaranta', NULL, 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_rebeca', 'Rebeca', NULL, 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_arcadio', 'Arcadio', NULL, 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_aureliano_segundo', 'Aureliano', 'Segundo', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_jose_arcadio_segundo', 'José Arcadio', 'Segundo', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_fernanda_del_carpio', 'Fernanda', 'del Carpio', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_meme', 'Renata Remedios', '"Meme"', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_amaranta_ursula', 'Amaranta', 'Úrsula', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_aureliano_babilonia', 'Aureliano', 'Babilonia', 'M', 'Decifra os pergaminhos de Melquíades que previam o destino da família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_buendia_aureliano_o_ultimo', 'Aureliano (o', 'último)', 'M', 'A criança com cauda de porco que cumpre a profecia e encerra a linhagem.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_buendia_arcadio', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_buendia', 'Família Buendía (Cem Anos de Solidão)', 'Genealogia mítica de Macondo na obra-prima de Gabriel García Márquez.', 'pub_buendia_jose_arcadio_buendia', 1, 'Genealogias Literárias e Ficcionais', 'Macondo (Ficção)', 'Ficção Literária');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio_buendia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_ursula_iguaran', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_coronel_aureliano_buendia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_amaranta', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_rebeca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_arcadio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_segundo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio_segundo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_fernanda_del_carpio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_meme', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_amaranta_ursula', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_babilonia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_o_ultimo', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_jose_arcadio_buendia', 'pub_buendia_ursula_iguaran', 'casamento', 'Patriarcas fundadores de Macondo');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_jose_arcadio', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_coronel_aureliano_buendia', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_amaranta', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_rebeca', 'adotado', 4);

-- José Arcadio (filho) com placeholder (Pilar Ternera) -> Arcadio
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_jose_arcadio_filho', 'pub_buendia_jose_arcadio', 'pub_ph_pub_buendia_arcadio', 'estavel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_jose_arcadio_filho');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_jose_arcadio_filho', 'pub_buendia_arcadio', 'biologico', 1);

-- Arcadio com placeholder (Santa Sofía) -> Aureliano Segundo e José Arcadio Segundo
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia', 'pub_buendia_arcadio', 'pub_ph_pub_buendia_arcadio', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia', 'pub_buendia_jose_arcadio_segundo', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia', 'pub_buendia_aureliano_segundo', 'biologico', 2);

-- Aureliano Segundo + Fernanda del Carpio -> Meme e Amaranta Úrsula
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_aureliano_segundo', 'pub_buendia_fernanda_del_carpio', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_meme', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_amaranta_ursula', 'biologico', 2);

-- Renata Remedios "Meme" + placeholder (Mauricio Babilonia) -> Aureliano Babilonia
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_meme_mauricio', 'pub_ph_pub_buendia_arcadio', 'pub_buendia_meme', 'estavel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_meme_mauricio');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_meme_mauricio', 'pub_buendia_aureliano_babilonia', 'biologico', 1);

-- Aureliano Babilonia + Amaranta Úrsula -> Aureliano (o último)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_buendia_babilonia_amaranta_ursula', 'pub_buendia_aureliano_babilonia', 'pub_buendia_amaranta_ursula', 'estavel', 'Linhagem final de Macondo');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_babilonia_amaranta_ursula');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_buendia_babilonia_amaranta_ursula', 'pub_buendia_aureliano_o_ultimo', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Compson (O Som e a Fúria)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_jason_compson_iii', 'Jason Compson', 'III', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_caroline_compson', 'Caroline Bascomb', 'Compson', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_quentin_compson', 'Quentin', 'Compson', 'M', 'O filho mais velho, atormentado; narrador de uma das seções.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_caddy_compson', 'Candace "Caddy"', 'Compson', 'F', 'A irmã, eixo emocional do romance.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_jason_compson_iv', 'Jason Compson', 'IV', 'M', 'O irmão amargo e cínico que assume o comando da casa em ruína.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_benjy_compson', 'Benjamin "Benjy"', 'Compson', 'M', 'O irmão com deficiência intelectual; abre o romance com seu monólogo.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_compson_miss_quentin', 'Miss', 'Quentin', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_compson', 'Família Compson (O Som e a Fúria)', 'Linhagem em decadência aristocrática no Sul dos EUA criada por William Faulkner.', 'pub_compson_jason_compson_iii', 1, 'Genealogias Literárias e Ficcionais', 'Yoknapatawpha (Ficção)', 'Ficção Literária');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_jason_compson_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_caroline_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_quentin_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_caddy_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_jason_compson_iv', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_benjy_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', 'pub_compson_miss_quentin', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_jason_compson_iii', 'pub_compson_caroline_compson', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_compson', NULL, 'pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp');

-- =====================================================================
-- ÁRVORE: Família Corleone (O Poderoso Chefão)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_vito_corleone', 'Vito', 'Corleone', 'M', 'Patriarca; imigrante siciliano que funda a família mafiosa em Nova York.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_carmela_corleone', 'Carmela', 'Corleone', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_sonny_corleone', 'Santino "Sonny"', 'Corleone', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_fredo_corleone', 'Fredo', 'Corleone', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_michael_corleone', 'Michael', 'Corleone', 'M', 'Filho caçula que se torna o sucessor de Vito à frente da família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_connie_corleone', 'Constanzia "Connie"', 'Corleone', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_tom_hagen', 'Tom', 'Hagen', 'M', 'Consigliere da família; filho adotivo informal de Vito.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_corleone_vincent_mancini', 'Vincent Mancini', '(Corleone)', 'M', 'Filho ilegítimo de Sonny; assume a família na Parte III.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_corleone_sonny_corleone', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_corleone', 'Família Corleone (O Poderoso Chefão)', 'A dinastia mafiosa de Don Vito Corleone na obra de Mario Puzo.', 'pub_corleone_vito_corleone', 1, 'Genealogias Literárias e Ficcionais', 'EUA / Sicília (Ficção)', 'Ficção / Séc. XX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_vito_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_carmela_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_sonny_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_fredo_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_michael_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_connie_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_tom_hagen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', 'pub_corleone_vincent_mancini', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_vito_corleone', 'pub_corleone_carmela_corleone', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', NULL, 'pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu', 'pub_corleone_sonny_corleone', 'pub_ph_pub_corleone_sonny_corleone', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_corleone', NULL, 'pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_fredo_corleone', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_michael_corleone', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_connie_corleone', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu', 'pub_corleone_vincent_mancini', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Karamazov (Dostoiévski)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_fiodor_karamazov', 'Fiódor Pávlovitch', 'Karamázov', 'M', 'Pai dissoluto e avarento cuja morte move a trama.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_adelaida_ivanovna', 'Adelaida', 'Ivánovna', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_sofia_ivanovna', 'Sofia', 'Ivánovna', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_dmitri_karamazov', 'Dmitri "Mítia"', 'Karamázov', 'M', 'O irmão passional; acusado do assassinato do pai.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_ivan_karamazov', 'Ivan', 'Karamázov', 'M', 'O irmão intelectual e cético ("se Deus não existe, tudo é permitido").', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_aliocha_karamazov', 'Alexei "Aliócha"', 'Karamázov', 'M', 'O irmão mais novo, noviço e espiritual; centro moral do romance.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_karamazov_pavel_smerdiakov', 'Pável', 'Smerdiákov', 'M', 'Criado da casa; peça-chave do crime.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_karamazov', 'Família Karamazov (Dostoiévski)', 'Fiódor Karamazov e seus três filhos (Dmitri, Ivan e Aliócha) no romance de Dostoiévski.', 'pub_karamazov_fiodor_karamazov', 1, 'Genealogias Literárias e Ficcionais', 'Rússia (Ficção)', 'Ficção / Séc. XIX');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_fiodor_karamazov', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_adelaida_ivanovna', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_sofia_ivanovna', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_dmitri_karamazov', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_ivan_karamazov', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_aliocha_karamazov', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', 'pub_karamazov_pavel_smerdiakov', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k', 'pub_karamazov_fiodor_karamazov', 'pub_karamazov_adelaida_ivanovna', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', NULL, 'pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k', 'pub_karamazov_fiodor_karamazov', 'pub_karamazov_sofia_ivanovna', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_karamazov', NULL, 'pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k', 'pub_karamazov_dmitri_karamazov', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k', 'pub_karamazov_ivan_karamazov', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_karamazov_pub_karamazov_fiodor_karamazov_pub_k', 'pub_karamazov_aliocha_karamazov', 'biologico', 3);

-- =====================================================================
-- ÁRVORE: Casa Lannister (Gelo e Fogo)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_tywin_lannister', 'Tywin', 'Lannister', 'M', 'Patriarca da Casa Lannister; senhor de Rochedo Casterly.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_joanna_lannister', 'Joanna', 'Lannister', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_cersei_lannister', 'Cersei', 'Lannister', 'F', 'Rainha; busca o poder a qualquer custo.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_jaime_lannister', 'Jaime', 'Lannister', 'M', 'Cavaleiro da Guarda Real; irmão gêmeo de Cersei.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_tyrion_lannister', 'Tyrion', 'Lannister', 'M', 'O irmão mais novo, arguto e político.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_lannister_joffrey_baratheon', 'Joffrey', 'Baratheon', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_lannister', 'Casa Lannister (Gelo e Fogo)', 'Os senhores do Rochedo Casterly em As Crônicas de Gelo e Fogo de George R.R. Martin.', 'pub_lannister_tywin_lannister', 1, 'Genealogias Literárias e Ficcionais', 'Westeros (Ficção)', 'Fantasia Épica');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_tywin_lannister', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_joanna_lannister', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_cersei_lannister', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_jaime_lannister', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_tyrion_lannister', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', 'pub_lannister_joffrey_baratheon', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_tywin_lannister_pub_la', 'pub_lannister_tywin_lannister', 'pub_lannister_joanna_lannister', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', NULL, 'pub_u_pub_arv_lannister_pub_lannister_tywin_lannister_pub_la');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_jaime_lannister_pub_la', 'pub_lannister_jaime_lannister', 'pub_lannister_cersei_lannister', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_lannister', NULL, 'pub_u_pub_arv_lannister_pub_lannister_jaime_lannister_pub_la');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_tywin_lannister_pub_la', 'pub_lannister_cersei_lannister', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_tywin_lannister_pub_la', 'pub_lannister_jaime_lannister', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_tywin_lannister_pub_la', 'pub_lannister_tyrion_lannister', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_lannister_pub_lannister_jaime_lannister_pub_la', 'pub_lannister_joffrey_baratheon', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Linhagem Skywalker (Star Wars)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_shmi_skywalker', 'Shmi', 'Skywalker', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_anakin_skywalker', 'Anakin', 'Skywalker', 'M', 'Cavaleiro Jedi que se torna o Sith Darth Vader; figura central da saga.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_padme_amidala', 'Padmé', 'Amidala', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_luke_skywalker', 'Luke', 'Skywalker', 'M', 'Jedi; protagonista da trilogia original.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_leia_organa', 'Leia', 'Organa', 'F', 'Princesa e líder da Rebelião.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_bail_organa', 'Bail', 'Organa', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_han_solo', 'Han', 'Solo', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_ben_solo', 'Ben Solo (Kylo', 'Ren)', 'M', 'Filho de Han e Leia que se torna o vilão Kylo Ren.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_skywalker_rey', 'Rey', 'Skywalker', 'U', 'Heroína da trilogia sequência; ao final, adota o sobrenome Skywalker.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_skywalker_shmi_skywalker', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_skywalker', 'Linhagem Skywalker (Star Wars)', 'A saga familiar central da galáxia Star Wars criada por George Lucas.', 'pub_skywalker_shmi_skywalker', 1, 'Genealogias Literárias e Ficcionais', 'Galáxia de Star Wars (Ficção)', 'Ficção Científica');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_shmi_skywalker', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_anakin_skywalker', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_padme_amidala', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_luke_skywalker', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_leia_organa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_bail_organa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_han_solo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_ben_solo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', 'pub_skywalker_rey', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_skywalker_pub_skywalker_anakin_skywalker_pub_s', 'pub_skywalker_anakin_skywalker', 'pub_skywalker_padme_amidala', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', NULL, 'pub_u_pub_arv_skywalker_pub_skywalker_anakin_skywalker_pub_s');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_skywalker_pub_skywalker_han_solo_pub_skywalker', 'pub_skywalker_han_solo', 'pub_skywalker_leia_organa', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', NULL, 'pub_u_pub_arv_skywalker_pub_skywalker_han_solo_pub_skywalker');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_skywalker_pub_ph_pub_skywalker_shmi_skywalker_', 'pub_ph_pub_skywalker_shmi_skywalker', 'pub_skywalker_shmi_skywalker', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_skywalker', NULL, 'pub_u_pub_arv_skywalker_pub_ph_pub_skywalker_shmi_skywalker_');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_skywalker_pub_ph_pub_skywalker_shmi_skywalker_', 'pub_skywalker_anakin_skywalker', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_skywalker_pub_skywalker_anakin_skywalker_pub_s', 'pub_skywalker_luke_skywalker', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_skywalker_pub_skywalker_anakin_skywalker_pub_s', 'pub_skywalker_leia_organa', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_skywalker_pub_skywalker_han_solo_pub_skywalker', 'pub_skywalker_ben_solo', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Casa Targaryen (Gelo e Fogo)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_aerys_ii_targaryen', 'Aerys II', 'Targaryen', 'M', 'O "Rei Louco"; último Targaryen no Trono de Ferro antes da Rebelião.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_rhaella_targaryen', 'Rhaella', 'Targaryen', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_rhaegar_targaryen', 'Rhaegar', 'Targaryen', 'M', 'Príncipe herdeiro; sua fuga com Lyanna Stark deflagra a guerra.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_viserys_targaryen', 'Viserys', 'Targaryen', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_daenerys_targaryen', 'Daenerys', 'Targaryen', 'F', 'A "Mãe dos Dragões"; busca retomar o trono.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_targaryen_jon_snow', 'Jon Snow (Aegon', 'Targaryen)', 'M', 'Criado como bastardo dos Stark; revela-se Targaryen (Aegon), herdeiro legítimo.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_targaryen_rhaegar_targaryen', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_targaryen', 'Casa Targaryen (Gelo e Fogo)', 'A dinastia valiriana dos cavaleiros de dragão que unificou os Sete Reinos.', 'pub_targaryen_aerys_ii_targaryen', 1, 'Genealogias Literárias e Ficcionais', 'Westeros (Ficção)', 'Fantasia Épica');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_aerys_ii_targaryen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_rhaella_targaryen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_rhaegar_targaryen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_viserys_targaryen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_daenerys_targaryen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', 'pub_targaryen_jon_snow', NULL);
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_aerys_ii_targaryen_pub', 'pub_targaryen_aerys_ii_targaryen', 'pub_targaryen_rhaella_targaryen', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', NULL, 'pub_u_pub_arv_targaryen_pub_targaryen_aerys_ii_targaryen_pub');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_rhaegar_targaryen_pub_', 'pub_targaryen_rhaegar_targaryen', 'pub_ph_pub_targaryen_rhaegar_targaryen', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_targaryen', NULL, 'pub_u_pub_arv_targaryen_pub_targaryen_rhaegar_targaryen_pub_');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_aerys_ii_targaryen_pub', 'pub_targaryen_rhaegar_targaryen', 'biologico', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_aerys_ii_targaryen_pub', 'pub_targaryen_viserys_targaryen', 'biologico', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_aerys_ii_targaryen_pub', 'pub_targaryen_daenerys_targaryen', 'biologico', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_targaryen_pub_targaryen_rhaegar_targaryen_pub_', 'pub_targaryen_jon_snow', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Terra Cambará (O Tempo e o Vento)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_maneco_terra', 'Maneco', 'Terra', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_ana_terra', 'Ana', 'Terra', 'F', 'Matriarca fundadora da saga; sobrevive ao massacre da família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_pedro_missioneiro', 'Pedro', 'Missioneiro', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_pedro_terra', 'Pedro', 'Terra', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_bibiana_terra', 'Bibiana', 'Terra', 'F', 'Neta de Ana; matriarca do clã Terra-Cambará (o nome "Bibiana" duplica "Ana").', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_capitao_rodrigo_cambara', 'Capitão Rodrigo', 'Cambará', 'M', 'Forasteiro destemido cuja chegada funde as linhagens Terra e Cambará.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_bolivar_cambara', 'Bolívar', 'Cambará', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_licurgo_cambara', 'Licurgo', 'Cambará', 'M', 'Intendente e chefe político de Santa Fé; defende o sobrado no cerco de 1895.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_rodrigo_terra_cambara', 'Rodrigo Terra', 'Cambará', 'M', 'Médico e político; figura central de "O Arquipélago".', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_terra_cambara_floriano_cambara', 'Floriano', 'Cambará', 'M', 'Escritor; alter ego do autor, que sonha narrar a própria família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_terra_cambara_maneco_terra', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_terra_cambara_pedro_terra', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_terra_cambara_bolivar_cambara', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_terra_cambara_licurgo_cambara', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_terra_cambara_rodrigo_terra_cambara', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Genealogias Literárias e Ficcionais');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_terra_cambara', 'Família Terra Cambará (O Tempo e o Vento)', 'A epopeia de duas famílias ao longo de dois séculos de formação do Rio Grande do Sul.', 'pub_terra_cambara_maneco_terra', 1, 'Genealogias Literárias e Ficcionais', 'Brasil / RS (Ficção)', 'Ficção Histórica');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_maneco_terra', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_ana_terra', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_pedro_missioneiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_pedro_terra', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_bibiana_terra', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_capitao_rodrigo_cambara', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_bolivar_cambara', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_licurgo_cambara', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_rodrigo_terra_cambara', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', 'pub_terra_cambara_floriano_cambara', NULL);
-- Maneco Terra -> Ana Terra
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_maneco_terra_p', 'pub_terra_cambara_maneco_terra', 'pub_ph_pub_terra_cambara_maneco_terra', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_maneco_terra_p');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_maneco_terra_p', 'pub_terra_cambara_ana_terra', 'biologico', 1);

-- Pedro Missioneiro + Ana Terra -> Pedro Terra
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pedro_ana', 'pub_terra_cambara_pedro_missioneiro', 'pub_terra_cambara_ana_terra', 'estavel', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pedro_ana');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pedro_ana', 'pub_terra_cambara_pedro_terra', 'biologico', 1);

-- Pedro Terra + placeholder -> Bibiana Terra
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_pedro_terra_pu', 'pub_terra_cambara_pedro_terra', 'pub_ph_pub_terra_cambara_pedro_terra', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_pedro_terra_pu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_pedro_terra_pu', 'pub_terra_cambara_bibiana_terra', 'biologico', 1);

-- Capitão Rodrigo Cambará + Bibiana Terra -> Bolívar Cambará
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_capitao_rodrig', 'pub_terra_cambara_capitao_rodrigo_cambara', 'pub_terra_cambara_bibiana_terra', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_capitao_rodrig');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_capitao_rodrig', 'pub_terra_cambara_bolivar_cambara', 'biologico', 1);

-- Bolívar Cambará + placeholder -> Licurgo Cambará
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_bolivar_cambar', 'pub_terra_cambara_bolivar_cambara', 'pub_ph_pub_terra_cambara_bolivar_cambara', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_bolivar_cambar');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_bolivar_cambar', 'pub_terra_cambara_licurgo_cambara', 'biologico', 1);

-- Licurgo Cambará + placeholder -> Rodrigo Terra Cambará
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_licurgo_cambar', 'pub_terra_cambara_licurgo_cambara', 'pub_ph_pub_terra_cambara_licurgo_cambara', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_licurgo_cambar');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_licurgo_cambar', 'pub_terra_cambara_rodrigo_terra_cambara', 'biologico', 1);

-- Rodrigo Terra Cambará + placeholder -> Floriano Cambará
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_rodrigo_terra_', 'pub_terra_cambara_rodrigo_terra_cambara', 'pub_ph_pub_terra_cambara_rodrigo_terra_cambara', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_terra_cambara', NULL, 'pub_u_pub_arv_terra_cambara_pub_terra_cambara_rodrigo_terra_');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_terra_cambara_pub_terra_cambara_rodrigo_terra_', 'pub_terra_cambara_floriano_cambara', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Kennedy
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_patrick_joseph_kennedy', 'P. J.', 'Kennedy', 'M', 'Atuação: comerciante; político (legislatura de Massachusetts).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_john_francis_fitzgerald', 'John F. "Honey Fitz"', 'Fitzgerald', 'M', 'Prefeito de Boston; patriarca materno dos Kennedy.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_joseph_p_kennedy_sr', 'Joseph P. Kennedy', 'Sr.', 'M', 'Empresário e investidor; embaixador dos EUA no Reino Unido e 1º presidente da SEC.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_rose_fitzgerald_kennedy', 'Rose Fitzgerald', 'Kennedy', 'F', 'Matriarca dos Kennedy; filantropa, feita condessa papal (1951).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_joseph_p_kennedy_jr', 'Joseph P. Kennedy', 'Jr.', 'M', 'Atuação: militar (aviador naval).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_john_f_kennedy', 'John F.', 'Kennedy', 'M', '35º presidente dos EUA; assassinado em Dallas em 1963.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_jacqueline_kennedy_onassis', 'Jacqueline "Jackie"', 'Kennedy', 'F', 'Atuação: editora; jornalista; primeira-dama.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_rosemary_kennedy', 'Rosemary', 'Kennedy', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_kathleen_kennedy', 'Kathleen "Kick"', 'Kennedy', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_eunice_kennedy_shriver', 'Eunice Kennedy', 'Shriver', 'F', 'Fundadora das Olimpíadas Especiais (Special Olympics).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_sargent_shriver', 'Sargent', 'Shriver', 'M', 'Atuação: político; diplomata (1º diretor do Peace Corps).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_patricia_kennedy_lawford', 'Patricia Kennedy', 'Lawford', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_robert_f_kennedy', 'Robert F.', 'Kennedy', 'M', 'Procurador-Geral e senador; candidato presidencial assassinado em 1968.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_ethel_skakel_kennedy', 'Ethel Skakel', 'Kennedy', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_jean_kennedy_smith', 'Jean Kennedy', 'Smith', 'F', 'Atuação: diplomata (embaixadora dos EUA na Irlanda).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_edward_m_kennedy', 'Edward "Ted"', 'Kennedy', 'M', 'Senador por Massachusetts por quase 47 anos.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_caroline_kennedy', 'Caroline', 'Kennedy', 'F', 'Atuação: advogada; escritora; diplomata (embaixadora no Japão e na Austrália).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_john_f_kennedy_jr', 'John F. Kennedy', 'Jr.', 'M', 'Atuação: advogado; jornalista (revista George).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_robert_f_kennedy_jr', 'Robert F. Kennedy', 'Jr.', 'M', 'Atuação: advogado ambiental; político.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_patrick_j_kennedy', 'Patrick J.', 'Kennedy', 'M', 'Atuação: político (deputado federal, Rhode Island).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_kennedy_maria_shriver', 'Maria', 'Shriver', 'F', 'Atuação: jornalista; escritora.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_kennedy_john_francis_fitzgerald', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_kennedy_edward_m_kennedy', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_kennedy', 'Família Kennedy', 'Dinastia política norte-americana de Patrick Joseph até JFK, Robert e Edward Kennedy.', 'pub_kennedy_eunice_kennedy_shriver', 1, 'Chefes de Estado e Política', 'Estados Unidos', '1858 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_patrick_joseph_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_john_francis_fitzgerald', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_joseph_p_kennedy_sr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_rose_fitzgerald_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_joseph_p_kennedy_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_john_f_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_jacqueline_kennedy_onassis', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_rosemary_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_kathleen_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_eunice_kennedy_shriver', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_sargent_shriver', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_patricia_kennedy_lawford', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_robert_f_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_ethel_skakel_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_jean_kennedy_smith', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_edward_m_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_caroline_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_john_f_kennedy_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_robert_f_kennedy_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_patrick_j_kennedy', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', 'pub_kennedy_maria_shriver', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_patrick_joseph_kennedy', 'pub_kennedy_patrick_joseph_kennedy', 'nascimento', 1858, 1858, 'exata', '1858');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_patrick_joseph_kennedy', 'pub_kennedy_patrick_joseph_kennedy', 'falecimento', 1929, 1929, 'exata', '1929');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_john_francis_fitzgerald', 'pub_kennedy_john_francis_fitzgerald', 'nascimento', 1863, 1863, 'exata', '1863');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_john_francis_fitzgerald', 'pub_kennedy_john_francis_fitzgerald', 'falecimento', 1950, 1950, 'exata', '1950');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_joseph_p_kennedy_sr', 'pub_kennedy_joseph_p_kennedy_sr', 'nascimento', 1888, 1888, 'exata', '1888');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_joseph_p_kennedy_sr', 'pub_kennedy_joseph_p_kennedy_sr', 'falecimento', 1969, 1969, 'exata', '1969');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_rose_fitzgerald_kennedy', 'pub_kennedy_rose_fitzgerald_kennedy', 'nascimento', 1890, 1890, 'exata', '1890');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_rose_fitzgerald_kennedy', 'pub_kennedy_rose_fitzgerald_kennedy', 'falecimento', 1995, 1995, 'exata', '1995');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_joseph_p_kennedy_jr', 'pub_kennedy_joseph_p_kennedy_jr', 'nascimento', 1915, 1915, 'exata', '1915');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_joseph_p_kennedy_jr', 'pub_kennedy_joseph_p_kennedy_jr', 'falecimento', 1944, 1944, 'exata', '1944');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_john_f_kennedy', 'pub_kennedy_john_f_kennedy', 'nascimento', 1917, 1917, 'exata', '1917');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_john_f_kennedy', 'pub_kennedy_john_f_kennedy', 'falecimento', 1963, 1963, 'exata', '1963');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_jacqueline_kennedy_onassis', 'pub_kennedy_jacqueline_kennedy_onassis', 'nascimento', 1929, 1929, 'exata', '1929');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_jacqueline_kennedy_onassis', 'pub_kennedy_jacqueline_kennedy_onassis', 'falecimento', 1994, 1994, 'exata', '1994');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_rosemary_kennedy', 'pub_kennedy_rosemary_kennedy', 'nascimento', 1918, 1918, 'exata', '1918');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_rosemary_kennedy', 'pub_kennedy_rosemary_kennedy', 'falecimento', 2005, 2005, 'exata', '2005');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_kathleen_kennedy', 'pub_kennedy_kathleen_kennedy', 'nascimento', 1920, 1920, 'exata', '1920');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_kathleen_kennedy', 'pub_kennedy_kathleen_kennedy', 'falecimento', 1948, 1948, 'exata', '1948');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_eunice_kennedy_shriver', 'pub_kennedy_eunice_kennedy_shriver', 'nascimento', 1921, 1921, 'exata', '1921');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_eunice_kennedy_shriver', 'pub_kennedy_eunice_kennedy_shriver', 'falecimento', 2009, 2009, 'exata', '2009');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_sargent_shriver', 'pub_kennedy_sargent_shriver', 'nascimento', 1915, 1915, 'exata', '1915');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_sargent_shriver', 'pub_kennedy_sargent_shriver', 'falecimento', 2011, 2011, 'exata', '2011');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_patricia_kennedy_lawford', 'pub_kennedy_patricia_kennedy_lawford', 'nascimento', 1924, 1924, 'exata', '1924');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_patricia_kennedy_lawford', 'pub_kennedy_patricia_kennedy_lawford', 'falecimento', 2006, 2006, 'exata', '2006');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_robert_f_kennedy', 'pub_kennedy_robert_f_kennedy', 'nascimento', 1925, 1925, 'exata', '1925');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_robert_f_kennedy', 'pub_kennedy_robert_f_kennedy', 'falecimento', 1968, 1968, 'exata', '1968');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_ethel_skakel_kennedy', 'pub_kennedy_ethel_skakel_kennedy', 'nascimento', 1928, 1928, 'exata', '1928');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_ethel_skakel_kennedy', 'pub_kennedy_ethel_skakel_kennedy', 'falecimento', 2024, 2024, 'exata', '2024');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_jean_kennedy_smith', 'pub_kennedy_jean_kennedy_smith', 'nascimento', 1928, 1928, 'exata', '1928');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_jean_kennedy_smith', 'pub_kennedy_jean_kennedy_smith', 'falecimento', 2020, 2020, 'exata', '2020');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_edward_m_kennedy', 'pub_kennedy_edward_m_kennedy', 'nascimento', 1932, 1932, 'exata', '1932');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_edward_m_kennedy', 'pub_kennedy_edward_m_kennedy', 'falecimento', 2009, 2009, 'exata', '2009');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_caroline_kennedy', 'pub_kennedy_caroline_kennedy', 'nascimento', 1957, 1957, 'exata', '1957');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_john_f_kennedy_jr', 'pub_kennedy_john_f_kennedy_jr', 'nascimento', 1960, 1960, 'exata', '1960');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_kennedy_john_f_kennedy_jr', 'pub_kennedy_john_f_kennedy_jr', 'falecimento', 1999, 1999, 'exata', '1999');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_robert_f_kennedy_jr', 'pub_kennedy_robert_f_kennedy_jr', 'nascimento', 1954, 1954, 'exata', '1954');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_patrick_j_kennedy', 'pub_kennedy_patrick_j_kennedy', 'nascimento', 1967, 1967, 'exata', '1967');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_kennedy_maria_shriver', 'pub_kennedy_maria_shriver', 'nascimento', 1955, 1955, 'exata', '1955');
-- P.J. Kennedy -> Joe Kennedy Sr.
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_pj_kennedy', 'pub_kennedy_patrick_joseph_kennedy', 'pub_ph_pub_kennedy_john_francis_fitzgerald', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_pj_kennedy');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kennedy_pj_kennedy', 'pub_kennedy_joseph_p_kennedy_sr', 'biologico', 1);

-- John Francis Fitzgerald -> Rose Fitzgerald Kennedy
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_john_francis_fitzgerald_pu', 'pub_kennedy_john_francis_fitzgerald', 'pub_ph_pub_kennedy_john_francis_fitzgerald', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_pub_kennedy_john_francis_fitzgerald_pu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_john_francis_fitzgerald_pu', 'pub_kennedy_rose_fitzgerald_kennedy', 'biologico', 1);

-- Joe Kennedy Sr. + Rose Fitzgerald Kennedy
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_joseph_p_kennedy_sr', 'pub_kennedy_rose_fitzgerald_kennedy', 'casamento', 'Casamento patriarcal em 1914');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_joe_rose');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_joseph_p_kennedy_jr', 'biologico', 1),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_john_f_kennedy', 'biologico', 2),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_rosemary_kennedy', 'biologico', 3),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_kathleen_kennedy', 'biologico', 4),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_eunice_kennedy_shriver', 'biologico', 5),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_patricia_kennedy_lawford', 'biologico', 6),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_robert_f_kennedy', 'biologico', 7),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_jean_kennedy_smith', 'biologico', 8),
('pub_u_pub_arv_kennedy_joe_rose', 'pub_kennedy_edward_m_kennedy', 'biologico', 9);

-- John F. Kennedy + Jacqueline Kennedy
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_jfk_jackie', 'pub_kennedy_john_f_kennedy', 'pub_kennedy_jacqueline_kennedy_onassis', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_jfk_jackie');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_pub_arv_kennedy_jfk_jackie', 'pub_kennedy_caroline_kennedy', 'biologico', 1),
('pub_u_pub_arv_kennedy_jfk_jackie', 'pub_kennedy_john_f_kennedy_jr', 'biologico', 2);

-- Robert F. Kennedy + Ethel Skakel
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_pub_kenne', 'pub_kennedy_robert_f_kennedy', 'pub_kennedy_ethel_skakel_kennedy', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_pub_kenne');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_pub_kenne', 'pub_kennedy_robert_f_kennedy_jr', 'biologico', 1);

-- Sargent Shriver + Eunice Kennedy
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_sargent_shriver_pub_kenned', 'pub_kennedy_sargent_shriver', 'pub_kennedy_eunice_kennedy_shriver', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_pub_kennedy_sargent_shriver_pub_kenned');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_sargent_shriver_pub_kenned', 'pub_kennedy_maria_shriver', 'biologico', 1);

-- Edward "Ted" Kennedy + placeholder -> Patrick J. Kennedy
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_edward_m_kennedy_pub_ph_pu', 'pub_kennedy_edward_m_kennedy', 'pub_ph_pub_kennedy_edward_m_kennedy', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_kennedy', NULL, 'pub_u_pub_arv_kennedy_pub_kennedy_edward_m_kennedy_pub_ph_pu');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_kennedy_pub_kennedy_edward_m_kennedy_pub_ph_pu', 'pub_kennedy_patrick_j_kennedy', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Família Perón
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_mario_tomas_peron', 'Mario Tomás', 'Perón', 'M', 'Atuação: agricultor.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_juana_sosa_toledo', 'Juana', 'Sosa', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_juan_domingo_peron', 'Juan Domingo', 'Perón', 'M', 'Militar e político; três vezes presidente da Argentina e fundador do peronismo.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_mario_avelino_peron', 'Mario Avelino', 'Perón', 'M', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_aurelia_tizon', 'Aurelia', 'Tizón', 'F', 'Primeira esposa de Perón; professora, pintora e tradutora.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_eva_peron', 'Eva', 'Perón', 'F', 'Atriz e líder política; primeira-dama, símbolo do peronismo e da conquista do voto feminino.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_isabel_peron', 'Isabel', 'Perón', 'F', 'Bailarina; vice e depois presidenta da Argentina (1974–1976), a primeira mulher chefe de Estado do país.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_juana_ibarguren', 'Juana', 'Ibarguren', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_juan_duarte_pai', 'Juan', 'Duarte', 'M', 'Atuação: fazendeiro.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_peron_juan_duarte_irmao', 'Juan "Juancito"', 'Duarte', 'M', 'Atuação: secretário particular de Juan Perón.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_peron', 'Família Perón', 'O general Juan Domingo Perón, suas esposas (incluindo Evita) e familiares na Argentina.', 'pub_peron_juan_domingo_peron', 1, 'Chefes de Estado e Política', 'Argentina', '1867 – 1974');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_mario_tomas_peron', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_juana_sosa_toledo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_juan_domingo_peron', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_mario_avelino_peron', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_aurelia_tizon', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_eva_peron', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_isabel_peron', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_juana_ibarguren', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_juan_duarte_pai', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', 'pub_peron_juan_duarte_irmao', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_peron_juan_domingo_peron', 'pub_peron_juan_domingo_peron', 'nascimento', 1895, 1895, 'exata', '1895');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_peron_juan_domingo_peron', 'pub_peron_juan_domingo_peron', 'falecimento', 1974, 1974, 'exata', '1974');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_peron_aurelia_tizon', 'pub_peron_aurelia_tizon', 'nascimento', 1902, 1902, 'exata', '1902');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_peron_aurelia_tizon', 'pub_peron_aurelia_tizon', 'falecimento', 1938, 1938, 'exata', '1938');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_peron_eva_peron', 'pub_peron_eva_peron', 'nascimento', 1919, 1919, 'exata', '1919');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_peron_eva_peron', 'pub_peron_eva_peron', 'falecimento', 1952, 1952, 'exata', '1952');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_peron_isabel_peron', 'pub_peron_isabel_peron', 'nascimento', 1931, 1931, 'exata', '1931');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_peron_juan_duarte_irmao', 'pub_peron_juan_duarte_irmao', 'falecimento', 1953, 1953, 'exata', '1953');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_ju', 'pub_peron_mario_tomas_peron', 'pub_peron_juana_sosa_toledo', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', NULL, 'pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_ju');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_peron_pub_peron_juan_domingo_peron_pub_peron_a', 'pub_peron_juan_domingo_peron', 'pub_peron_aurelia_tizon', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', NULL, 'pub_u_pub_arv_peron_pub_peron_juan_domingo_peron_pub_peron_a');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_ev', 'pub_peron_mario_tomas_peron', 'pub_peron_eva_peron', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', NULL, 'pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_ev');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_is', 'pub_peron_mario_tomas_peron', 'pub_peron_isabel_peron', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', NULL, 'pub_u_pub_arv_peron_pub_peron_mario_tomas_peron_pub_peron_is');
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pub_arv_peron_pub_peron_juan_duarte_pai_pub_peron_juan', 'pub_peron_juan_duarte_pai', 'pub_peron_juana_ibarguren', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_peron', NULL, 'pub_u_pub_arv_peron_pub_peron_juan_duarte_pai_pub_peron_juan');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_pub_arv_peron_pub_peron_juan_duarte_pai_pub_peron_juan', 'pub_peron_eva_peron', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Dinastia Roosevelt (Oyster Bay e Hyde Park)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_claes_martenszen_van_rosenvelt', 'Claes Martenszen', 'van Rosenvelt', 'M', 'Imigrante holandês; ancestral de toda a família Roosevelt na América.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_nicholas_roosevelt', 'Nicholas', 'Roosevelt', 'U', 'Atuação: vereador (alderman).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_theodore_roosevelt_sr', 'Theodore Roosevelt', 'Sr.', 'M', 'Atuação: empresário; filantropo.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_martha_bulloch_roosevelt', 'Martha "Mittie"', 'Bulloch', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_theodore_roosevelt', 'Theodore', 'Roosevelt', 'M', '26º presidente dos EUA; líder progressista e Nobel da Paz de 1906.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_edith_kermit_carow_roosevelt', 'Edith Kermit', 'Carow', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_alice_roosevelt_longworth', 'Alice Roosevelt', 'Longworth', 'F', 'Atuação: socialite; escritora.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_theodore_roosevelt_jr', 'Theodore Roosevelt', 'Jr.', 'M', 'Atuação: militar (general, herói do Dia D); político.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_kermit_roosevelt', 'Kermit', 'Roosevelt', 'M', 'Atuação: militar; explorador; empresário.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_quentin_roosevelt', 'Quentin', 'Roosevelt', 'M', 'Atuação: aviador militar.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_elliott_roosevelt', 'Elliott', 'Roosevelt', 'M', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_james_roosevelt', 'James', 'Roosevelt', 'M', 'Atuação: empresário.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_sara_delano_roosevelt', 'Sara Ann', 'Delano', 'F', '', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_franklin_d_roosevelt', 'Franklin D.', 'Roosevelt', 'M', '32º presidente dos EUA; único eleito quatro vezes; liderou o país na Depressão e na 2ª Guerra.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_eleanor_roosevelt', 'Eleanor', 'Roosevelt', 'F', 'Primeira-dama e diplomata; presidiu o comitê da Declaração Universal dos Direitos Humanos.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_anna_roosevelt_halsted', 'Anna', 'Roosevelt', 'F', 'Atuação: jornalista; escritora.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_james_roosevelt_ii', 'James', 'Roosevelt', 'M', 'Atuação: político (deputado federal); militar.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'Elliott', 'Roosevelt', 'M', 'Atuação: militar (aviador); escritor.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_franklin_d_roosevelt_jr', 'Franklin D. Roosevelt', 'Jr.', 'M', 'Atuação: político (deputado federal).', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_roosevelt_john_aspinwall_roosevelt', 'John', 'Roosevelt', 'M', 'Atuação: empresário.', 0, 0, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Chefes de Estado e Política');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_roosevelt', 'Dinastia Roosevelt (Oyster Bay e Hyde Park)', 'As duas ramas da família que geraram Theodore Roosevelt e Franklin Delano Roosevelt.', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 1, 'Chefes de Estado e Política', 'Estados Unidos', '1831 – 1962');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_claes_martenszen_van_rosenvelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_nicholas_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_theodore_roosevelt_sr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_martha_bulloch_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_theodore_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_edith_kermit_carow_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_alice_roosevelt_longworth', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_theodore_roosevelt_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_kermit_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_quentin_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_elliott_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_james_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_sara_delano_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_franklin_d_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_eleanor_roosevelt', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_anna_roosevelt_halsted', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_james_roosevelt_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_elliott_roosevelt_filho_de_fdr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_franklin_d_roosevelt_jr', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', 'pub_roosevelt_john_aspinwall_roosevelt', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_claes_martenszen_van_rosenvelt', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 'nascimento', 1626, 1626, 'cerca_de', 'cerca de 1626');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_claes_martenszen_van_rosenvelt', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 'falecimento', 1659, 1659, 'exata', '1659');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_theodore_roosevelt_sr', 'pub_roosevelt_theodore_roosevelt_sr', 'nascimento', 1831, 1831, 'exata', '1831');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_theodore_roosevelt_sr', 'pub_roosevelt_theodore_roosevelt_sr', 'falecimento', 1878, 1878, 'exata', '1878');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_martha_bulloch_roosevelt', 'pub_roosevelt_martha_bulloch_roosevelt', 'nascimento', 1835, 1835, 'exata', '1835');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_martha_bulloch_roosevelt', 'pub_roosevelt_martha_bulloch_roosevelt', 'falecimento', 1884, 1884, 'exata', '1884');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_theodore_roosevelt', 'pub_roosevelt_theodore_roosevelt', 'nascimento', 1858, 1858, 'exata', '1858');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_theodore_roosevelt', 'pub_roosevelt_theodore_roosevelt', 'falecimento', 1919, 1919, 'exata', '1919');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_edith_kermit_carow_roosevelt', 'pub_roosevelt_edith_kermit_carow_roosevelt', 'nascimento', 1861, 1861, 'exata', '1861');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_edith_kermit_carow_roosevelt', 'pub_roosevelt_edith_kermit_carow_roosevelt', 'falecimento', 1948, 1948, 'exata', '1948');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_alice_roosevelt_longworth', 'pub_roosevelt_alice_roosevelt_longworth', 'nascimento', 1884, 1884, 'exata', '1884');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_alice_roosevelt_longworth', 'pub_roosevelt_alice_roosevelt_longworth', 'falecimento', 1980, 1980, 'exata', '1980');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_theodore_roosevelt_jr', 'pub_roosevelt_theodore_roosevelt_jr', 'nascimento', 1887, 1887, 'exata', '1887');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_theodore_roosevelt_jr', 'pub_roosevelt_theodore_roosevelt_jr', 'falecimento', 1944, 1944, 'exata', '1944');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_kermit_roosevelt', 'pub_roosevelt_kermit_roosevelt', 'nascimento', 1889, 1889, 'exata', '1889');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_kermit_roosevelt', 'pub_roosevelt_kermit_roosevelt', 'falecimento', 1943, 1943, 'exata', '1943');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_quentin_roosevelt', 'pub_roosevelt_quentin_roosevelt', 'nascimento', 1897, 1897, 'exata', '1897');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_quentin_roosevelt', 'pub_roosevelt_quentin_roosevelt', 'falecimento', 1918, 1918, 'exata', '1918');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_elliott_roosevelt', 'pub_roosevelt_elliott_roosevelt', 'nascimento', 1860, 1860, 'exata', '1860');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_elliott_roosevelt', 'pub_roosevelt_elliott_roosevelt', 'falecimento', 1894, 1894, 'exata', '1894');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_james_roosevelt', 'pub_roosevelt_james_roosevelt', 'nascimento', 1828, 1828, 'exata', '1828');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_james_roosevelt', 'pub_roosevelt_james_roosevelt', 'falecimento', 1900, 1900, 'exata', '1900');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_sara_delano_roosevelt', 'pub_roosevelt_sara_delano_roosevelt', 'nascimento', 1854, 1854, 'exata', '1854');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_sara_delano_roosevelt', 'pub_roosevelt_sara_delano_roosevelt', 'falecimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_franklin_d_roosevelt', 'pub_roosevelt_franklin_d_roosevelt', 'nascimento', 1882, 1882, 'exata', '1882');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_franklin_d_roosevelt', 'pub_roosevelt_franklin_d_roosevelt', 'falecimento', 1945, 1945, 'exata', '1945');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_eleanor_roosevelt', 'pub_roosevelt_eleanor_roosevelt', 'nascimento', 1884, 1884, 'exata', '1884');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_eleanor_roosevelt', 'pub_roosevelt_eleanor_roosevelt', 'falecimento', 1962, 1962, 'exata', '1962');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_anna_roosevelt_halsted', 'pub_roosevelt_anna_roosevelt_halsted', 'nascimento', 1906, 1906, 'exata', '1906');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_anna_roosevelt_halsted', 'pub_roosevelt_anna_roosevelt_halsted', 'falecimento', 1975, 1975, 'exata', '1975');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_james_roosevelt_ii', 'pub_roosevelt_james_roosevelt_ii', 'nascimento', 1907, 1907, 'exata', '1907');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_james_roosevelt_ii', 'pub_roosevelt_james_roosevelt_ii', 'falecimento', 1991, 1991, 'exata', '1991');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'nascimento', 1910, 1910, 'exata', '1910');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'falecimento', 1990, 1990, 'exata', '1990');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_franklin_d_roosevelt_jr', 'pub_roosevelt_franklin_d_roosevelt_jr', 'nascimento', 1914, 1914, 'exata', '1914');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_franklin_d_roosevelt_jr', 'pub_roosevelt_franklin_d_roosevelt_jr', 'falecimento', 1988, 1988, 'exata', '1988');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_roosevelt_john_aspinwall_roosevelt', 'pub_roosevelt_john_aspinwall_roosevelt', 'nascimento', 1916, 1916, 'exata', '1916');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_roosevelt_john_aspinwall_roosevelt', 'pub_roosevelt_john_aspinwall_roosevelt', 'falecimento', 1981, 1981, 'exata', '1981');
-- Claes Martenszen -> Nicholas Roosevelt
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_claes_nicholas', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 'pub_roosevelt_claes_martenszen_van_rosenvelt', 'casamento', 'Patriarca ancestral');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_claes_nicholas');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_roosevelt_claes_nicholas', 'pub_roosevelt_nicholas_roosevelt', 'biologico', 1);

-- Nicholas Roosevelt -> ancestrais de Theodore Sr. e James
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_nicholas_roosevelt', 'pub_roosevelt_nicholas_roosevelt', 'casamento', 'Ancestral comum dos ramos de Oyster Bay e Hyde Park');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_nicholas_filhos');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_theodore_roosevelt_sr', 'biologico', 1),
('pub_u_roosevelt_nicholas_filhos', 'pub_roosevelt_james_roosevelt', 'biologico', 2);

-- Theodore Sr. + Martha Bulloch tiveram Theodore (Teddy) e Elliott
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_theo_sr_martha', 'pub_roosevelt_theodore_roosevelt_sr', 'pub_roosevelt_martha_bulloch_roosevelt', 'casamento', 'Ramo Oyster Bay');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_theo_sr_martha');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_theo_sr_martha', 'pub_roosevelt_theodore_roosevelt', 'biologico', 1),
('pub_u_roosevelt_theo_sr_martha', 'pub_roosevelt_elliott_roosevelt', 'biologico', 2);

-- Theodore (Teddy) Roosevelt + Edith Kermit Carow
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_theodore_roosevelt', 'pub_roosevelt_edith_kermit_carow_roosevelt', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_teddy_edith');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_alice_roosevelt_longworth', 'biologico', 1),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_theodore_roosevelt_jr', 'biologico', 2),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_kermit_roosevelt', 'biologico', 3),
('pub_u_roosevelt_teddy_edith', 'pub_roosevelt_quentin_roosevelt', 'biologico', 4);

-- Elliott Roosevelt -> Eleanor Roosevelt
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_elliott_eleanor', 'pub_roosevelt_elliott_roosevelt', 'pub_roosevelt_elliott_roosevelt', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_elliott_eleanor');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_roosevelt_elliott_eleanor', 'pub_roosevelt_eleanor_roosevelt', 'biologico', 1);

-- James Roosevelt + Sara Delano -> Franklin D. Roosevelt (FDR)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_james_sara', 'pub_roosevelt_james_roosevelt', 'pub_roosevelt_sara_delano_roosevelt', 'casamento', 'Ramo Hyde Park');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_james_sara');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_roosevelt_james_sara', 'pub_roosevelt_franklin_d_roosevelt', 'biologico', 1);

-- Franklin D. Roosevelt + Eleanor Roosevelt -> Anna, James II, Elliott Jr, Franklin Jr, John
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_franklin_d_roosevelt', 'pub_roosevelt_eleanor_roosevelt', 'casamento', 'Casamento em 1905');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_roosevelt', NULL, 'pub_u_roosevelt_fdr_eleanor');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_anna_roosevelt_halsted', 'biologico', 1),
('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_james_roosevelt_ii', 'biologico', 2),
('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_elliott_roosevelt_filho_de_fdr', 'biologico', 3),
('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_franklin_d_roosevelt_jr', 'biologico', 4),
('pub_u_roosevelt_fdr_eleanor', 'pub_roosevelt_john_aspinwall_roosevelt', 'biologico', 5);

-- =====================================================================
-- ÁRVORE: Casa de Bourbon (França e Espanha)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_henrique_iv_da_franca', 'Henrique', 'IV', 'M', 'Primeiro rei Bourbon da França; encerrou as guerras religiosas com o Édito de Nantes.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_luis_xiv', 'Luís', 'XIV', 'M', 'O "Rei Sol"; o mais longo reinado da história europeia (72 anos).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_luis_xvi', 'Luís', 'XVI', 'M', 'Rei deposto e guilhotinado na Revolução Francesa.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_filipe_v_da_espanha', 'Filipe', 'V', 'M', 'Neto de Luís XIV; primeiro rei Bourbon da Espanha.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_afonso_xiii', 'Afonso', 'XIII', 'M', 'Atuação: monarca.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_juan_de_borbon', 'Juan de Borbón (Conde', 'de Barcelona)', 'M', '', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_juan_carlos_i', 'Juan Carlos', 'I', 'M', 'Rei que conduziu a transição democrática espanhola pós-Franco; abdicou em 2014.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_felipe_vi', 'Felipe', 'VI', 'M', 'Rei da Espanha desde 2014.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_letizia', 'Letizia', NULL, 'F', 'Atuação: jornalista; rainha consorte.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_bourbon_leonor_princesa_das_asturias', 'Leonor', 'de Borbón', 'F', 'Atuação: herdeira do trono (Princesa das Astúrias).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bourbon_afonso_xiii', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_bourbon_juan_carlos_i', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_bourbon', 'Casa de Bourbon (França e Espanha)', 'Dinastia real capetiana que governou a França, Espanha, Parma e Duas Sicílias.', 'pub_bourbon_henrique_iv_da_franca', 1, 'Famílias Reais e Dinastias', 'França / Espanha', '1553 – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_henrique_iv_da_franca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_luis_xiv', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_luis_xvi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_filipe_v_da_espanha', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_afonso_xiii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_juan_de_borbon', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_juan_carlos_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_felipe_vi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_letizia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', 'pub_bourbon_leonor_princesa_das_asturias', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_henrique_iv_da_franca', 'pub_bourbon_henrique_iv_da_franca', 'nascimento', 1553, 1553, 'exata', '1553');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_henrique_iv_da_franca', 'pub_bourbon_henrique_iv_da_franca', 'falecimento', 1610, 1610, 'exata', '1610');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_luis_xiv', 'pub_bourbon_luis_xiv', 'nascimento', 1638, 1638, 'exata', '1638');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_luis_xiv', 'pub_bourbon_luis_xiv', 'falecimento', 1715, 1715, 'exata', '1715');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_luis_xvi', 'pub_bourbon_luis_xvi', 'nascimento', 1754, 1754, 'exata', '1754');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_luis_xvi', 'pub_bourbon_luis_xvi', 'falecimento', 1793, 1793, 'exata', '1793');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_filipe_v_da_espanha', 'pub_bourbon_filipe_v_da_espanha', 'nascimento', 1683, 1683, 'exata', '1683');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_filipe_v_da_espanha', 'pub_bourbon_filipe_v_da_espanha', 'falecimento', 1746, 1746, 'exata', '1746');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_afonso_xiii', 'pub_bourbon_afonso_xiii', 'nascimento', 1886, 1886, 'exata', '1886');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_afonso_xiii', 'pub_bourbon_afonso_xiii', 'falecimento', 1941, 1941, 'exata', '1941');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_juan_de_borbon', 'pub_bourbon_juan_de_borbon', 'nascimento', 1913, 1913, 'exata', '1913');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_bourbon_juan_de_borbon', 'pub_bourbon_juan_de_borbon', 'falecimento', 1993, 1993, 'exata', '1993');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_juan_carlos_i', 'pub_bourbon_juan_carlos_i', 'nascimento', 1938, 1938, 'exata', '1938');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_felipe_vi', 'pub_bourbon_felipe_vi', 'nascimento', 1968, 1968, 'exata', '1968');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_letizia', 'pub_bourbon_letizia', 'nascimento', 1972, 1972, 'exata', '1972');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_bourbon_leonor_princesa_das_asturias', 'pub_bourbon_leonor_princesa_das_asturias', 'nascimento', 2005, 2005, 'exata', '2005');
-- Henrique IV -> Luís XIV (Rei Sol)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_henrique_luis', 'pub_bourbon_henrique_iv_da_franca', 'pub_bourbon_henrique_iv_da_franca', 'casamento', 'Tronco da Casa de Bourbon');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_henrique_luis');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_henrique_luis', 'pub_bourbon_luis_xiv', 'biologico', 1);

-- Luís XIV -> Luís XVI (França) e Filipe V (Espanha)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_luis_xiv', 'pub_bourbon_luis_xiv', 'casamento', 'Sucessão real de França e Espanha');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_luis_xiv_desc');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_luis_xvi', 'biologico', 1),
('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_filipe_v_da_espanha', 'biologico', 2);

-- Filipe V -> Afonso XIII
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_filipe_afonso', 'pub_bourbon_filipe_v_da_espanha', 'pub_bourbon_filipe_v_da_espanha', 'casamento', 'Dinastia Bourbon Espanhola');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_filipe_afonso');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_filipe_afonso', 'pub_bourbon_afonso_xiii', 'biologico', 1);

-- Afonso XIII -> Juan de Borbón
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_afonso_juan', 'pub_bourbon_afonso_xiii', 'pub_bourbon_afonso_xiii', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_afonso_juan');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_afonso_juan', 'pub_bourbon_juan_de_borbon', 'biologico', 1);

-- Juan de Borbón -> Juan Carlos I
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_juan_juan_carlos', 'pub_bourbon_juan_de_borbon', 'pub_bourbon_juan_de_borbon', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_juan_juan_carlos');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_juan_juan_carlos', 'pub_bourbon_juan_carlos_i', 'biologico', 1);

-- Juan Carlos I -> Felipe VI
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_juan_carlos_felipe', 'pub_bourbon_juan_carlos_i', 'pub_bourbon_juan_carlos_i', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_juan_carlos_felipe');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_juan_carlos_felipe', 'pub_bourbon_felipe_vi', 'biologico', 1);

-- Felipe VI + Letizia -> Leonor
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bourbon_felipe_letizia', 'pub_bourbon_felipe_vi', 'pub_bourbon_letizia', 'casamento', 'Família Real Espanhola Atual');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_felipe_letizia');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_bourbon_felipe_letizia', 'pub_bourbon_leonor_princesa_das_asturias', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Casa de Habsburgo
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_filipe_o_belo', 'Filipe I de Castela (o', 'Belo)', 'M', '', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_joana_de_castela', 'Joana, a', 'Louca', 'F', '', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_carlos_v', 'Carlos V (Carlos I', 'da Espanha)', 'M', 'Sacro Imperador e rei da Espanha; governou um império "onde o sol não se punha".', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_filipe_ii', 'Filipe', 'II', 'M', 'Rei da Espanha no auge do império; casou-se quatro vezes, incluindo com a sobrinha Ana da Áustria.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_carlos_ii_da_espanha', 'Carlos II (o', 'Enfeitiçado)', 'U', 'Último Habsburgo espanhol; incapacitado por gerações de endogamia, morreu sem herdeiros, o que deflagrou a Guerra da Sucessão Espanhola.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_maria_teresa', 'Maria Teresa', 'da Áustria', 'F', 'Arquiduquesa da Áustria e soberana dos domínios Habsburgo; mãe de 16 filhos.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_maria_antonieta', 'Maria', 'Antonieta', 'F', 'Arquiduquesa austríaca que se tornou rainha da França; guilhotinada na Revolução.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_francisco_jose_i', 'Francisco José', 'I', 'M', 'Imperador da Áustria-Hungria por 68 anos; seu reinado terminou em plena 1ª Guerra.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_isabel_da_baviera_sissi', 'Imperatriz Isabel', '("Sissi")', 'F', '', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_francisco_ferdinando', 'Arquiduque Francisco', 'Ferdinando', 'U', 'Herdeiro do trono austro-húngaro; seu assassinato em Sarajevo (1914) desencadeou a 1ª Guerra Mundial.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_carlos_i_da_austria', 'Carlos', 'I', 'M', 'Atuação: monarca (último imperador austro-húngaro).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_otto_von_habsburgo', 'Otto', 'von Habsburgo', 'M', 'Atuação: político (eurodeputado); escritor.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_habsburgo_karl_von_habsburgo', 'Karl', 'von Habsburgo', 'U', 'Atuação: atual chefe da Casa de Habsburgo.', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_habsburgo_carlos_v', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_habsburgo_maria_teresa', 'Desconhecido', NULL, 'M', NULL, 0, 1, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_ph_pub_habsburgo_carlos_i_da_austria', 'Desconhecido', NULL, 'F', NULL, 0, 1, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_habsburgo', 'Casa de Habsburgo', 'Uma das casas reais mais influentes da Europa, soberanos do Sacro Império, Áustria e Espanha.', 'pub_habsburgo_filipe_o_belo', 1, 'Famílias Reais e Dinastias', 'Áustria / Sacro Império', '1459 – 1922');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_filipe_o_belo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_joana_de_castela', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_carlos_v', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_filipe_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_carlos_ii_da_espanha', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_maria_teresa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_maria_antonieta', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_francisco_jose_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_isabel_da_baviera_sissi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_francisco_ferdinando', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_carlos_i_da_austria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_otto_von_habsburgo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', 'pub_habsburgo_karl_von_habsburgo', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_filipe_o_belo', 'pub_habsburgo_filipe_o_belo', 'nascimento', 1478, 1478, 'exata', '1478');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_filipe_o_belo', 'pub_habsburgo_filipe_o_belo', 'falecimento', 1506, 1506, 'exata', '1506');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_joana_de_castela', 'pub_habsburgo_joana_de_castela', 'nascimento', 1479, 1479, 'exata', '1479');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_joana_de_castela', 'pub_habsburgo_joana_de_castela', 'falecimento', 1555, 1555, 'exata', '1555');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_carlos_v', 'pub_habsburgo_carlos_v', 'nascimento', 1500, 1500, 'exata', '1500');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_carlos_v', 'pub_habsburgo_carlos_v', 'falecimento', 1558, 1558, 'exata', '1558');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_filipe_ii', 'pub_habsburgo_filipe_ii', 'nascimento', 1527, 1527, 'exata', '1527');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_filipe_ii', 'pub_habsburgo_filipe_ii', 'falecimento', 1598, 1598, 'exata', '1598');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_carlos_ii_da_espanha', 'pub_habsburgo_carlos_ii_da_espanha', 'nascimento', 1661, 1661, 'exata', '1661');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_carlos_ii_da_espanha', 'pub_habsburgo_carlos_ii_da_espanha', 'falecimento', 1700, 1700, 'exata', '1700');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_maria_teresa', 'pub_habsburgo_maria_teresa', 'nascimento', 1717, 1717, 'exata', '1717');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_maria_teresa', 'pub_habsburgo_maria_teresa', 'falecimento', 1780, 1780, 'exata', '1780');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_maria_antonieta', 'pub_habsburgo_maria_antonieta', 'nascimento', 1755, 1755, 'exata', '1755');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_maria_antonieta', 'pub_habsburgo_maria_antonieta', 'falecimento', 1793, 1793, 'exata', '1793');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_francisco_jose_i', 'pub_habsburgo_francisco_jose_i', 'nascimento', 1830, 1830, 'exata', '1830');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_francisco_jose_i', 'pub_habsburgo_francisco_jose_i', 'falecimento', 1916, 1916, 'exata', '1916');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_isabel_da_baviera_sissi', 'pub_habsburgo_isabel_da_baviera_sissi', 'nascimento', 1837, 1837, 'exata', '1837');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_isabel_da_baviera_sissi', 'pub_habsburgo_isabel_da_baviera_sissi', 'falecimento', 1898, 1898, 'exata', '1898');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_francisco_ferdinando', 'pub_habsburgo_francisco_ferdinando', 'nascimento', 1863, 1863, 'exata', '1863');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_francisco_ferdinando', 'pub_habsburgo_francisco_ferdinando', 'falecimento', 1914, 1914, 'exata', '1914');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_carlos_i_da_austria', 'pub_habsburgo_carlos_i_da_austria', 'nascimento', 1887, 1887, 'exata', '1887');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_carlos_i_da_austria', 'pub_habsburgo_carlos_i_da_austria', 'falecimento', 1922, 1922, 'exata', '1922');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_otto_von_habsburgo', 'pub_habsburgo_otto_von_habsburgo', 'nascimento', 1912, 1912, 'exata', '1912');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_habsburgo_otto_von_habsburgo', 'pub_habsburgo_otto_von_habsburgo', 'falecimento', 2011, 2011, 'exata', '2011');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_habsburgo_karl_von_habsburgo', 'pub_habsburgo_karl_von_habsburgo', 'nascimento', 1961, 1961, 'exata', '1961');
-- Filipe o Belo + Joana de Castela -> Carlos V
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_filipe_joana', 'pub_habsburgo_filipe_o_belo', 'pub_habsburgo_joana_de_castela', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_filipe_joana');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_filipe_joana', 'pub_habsburgo_carlos_v', 'biologico', 1);

-- Carlos V -> Filipe II
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_carlos_v_filipe_ii', 'pub_habsburgo_carlos_v', 'pub_habsburgo_carlos_v', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_carlos_v_filipe_ii');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_carlos_v_filipe_ii', 'pub_habsburgo_filipe_ii', 'biologico', 1);

-- Filipe II -> Carlos II (o Enfeitiçado)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_filipe_ii_carlos_ii', 'pub_habsburgo_filipe_ii', 'pub_habsburgo_filipe_ii', 'casamento', 'Linhagem de Espanha');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_filipe_ii_carlos_ii');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_filipe_ii_carlos_ii', 'pub_habsburgo_carlos_ii_da_espanha', 'biologico', 1);

-- Carlos V -> Maria Teresa (tronco austríaco)
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_carlos_v_austria', 'pub_habsburgo_carlos_v', 'pub_habsburgo_carlos_v', 'casamento', 'Tronco da Áustria');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_carlos_v_austria');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_carlos_v_austria', 'pub_habsburgo_maria_teresa', 'biologico', 1);

-- Maria Teresa -> Maria Antonieta, Francisco Ferdinando, Francisco José I, Carlos I
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_maria_teresa_desc', 'pub_habsburgo_maria_teresa', 'pub_habsburgo_maria_teresa', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_maria_teresa_desc');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES
('pub_u_habsburgo_maria_teresa_desc', 'pub_habsburgo_maria_antonieta', 'biologico', 1),
('pub_u_habsburgo_maria_teresa_desc', 'pub_habsburgo_francisco_ferdinando', 'biologico', 2),
('pub_u_habsburgo_maria_teresa_desc', 'pub_habsburgo_francisco_jose_i', 'biologico', 3),
('pub_u_habsburgo_maria_teresa_desc', 'pub_habsburgo_carlos_i_da_austria', 'biologico', 4);

-- Francisco José I + Imperatriz Sissi
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_fj_sissi', 'pub_habsburgo_francisco_jose_i', 'pub_habsburgo_isabel_da_baviera_sissi', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_fj_sissi');

-- Carlos I da Áustria -> Otto von Habsburgo
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_carlos_i_otto', 'pub_habsburgo_carlos_i_da_austria', 'pub_habsburgo_carlos_i_da_austria', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_carlos_i_otto');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_carlos_i_otto', 'pub_habsburgo_otto_von_habsburgo', 'biologico', 1);

-- Otto von Habsburgo -> Karl von Habsburgo
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_habsburgo_otto_karl', 'pub_habsburgo_otto_von_habsburgo', 'pub_habsburgo_otto_von_habsburgo', 'casamento', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_habsburgo', NULL, 'pub_u_habsburgo_otto_karl');
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_habsburgo_otto_karl', 'pub_habsburgo_karl_von_habsburgo', 'biologico', 1);

-- =====================================================================
-- ÁRVORE: Monarquias Tradicionais Europeias
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_philippe_da_belgica', 'Philippe', NULL, 'M', 'Atuação: monarca (rei dos belgas, desde 2013).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'Willem-Alexander', NULL, 'M', 'Atuação: monarca (rei dos Países Baixos, desde 2013).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_frederik_x_da_dinamarca', 'Frederik', 'X', 'M', 'Atuação: monarca (rei da Dinamarca, desde 2024).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_harald_v_da_noruega', 'Harald', 'V', 'M', 'Atuação: monarca (rei da Noruega, desde 1991).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'Carl XVI', 'Gustaf', 'M', 'Atuação: monarca (rei da Suécia, desde 1973).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_alberto_ii_de_monaco', 'Alberto', 'II', 'M', 'Atuação: monarca (príncipe de Mônaco, desde 2005).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'Hans-Adam', 'II', 'M', 'Atuação: monarca (príncipe de Liechtenstein, desde 1989).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
VALUES ('pub_outras_monarquias_henri_de_luxemburgo', 'Grão-Duque', 'Henri', 'M', 'Atuação: monarca (grão-duque de Luxemburgo, desde 2000).', 0, 0, 1, 'Famílias Reais e Dinastias');
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
VALUES ('pub_arv_outras_monarquias', 'Monarquias Tradicionais Europeias', 'Dinastias soberanas de Mônaco (Grimaldi), Suécia (Bernadotte) e Países Baixos (Orange-Nassau).', 'pub_outras_monarquias_philippe_da_belgica', 1, 'Famílias Reais e Dinastias', 'Mônaco / Suécia / Holanda', 'Séc. XVII – presente');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_philippe_da_belgica', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_frederik_x_da_dinamarca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_harald_v_da_noruega', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_alberto_ii_de_monaco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_henri_de_luxemburgo', NULL);
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_philippe_da_belgica', 'pub_outras_monarquias_philippe_da_belgica', 'nascimento', 1960, 1960, 'exata', '1960');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'nascimento', 1967, 1967, 'exata', '1967');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_frederik_x_da_dinamarca', 'pub_outras_monarquias_frederik_x_da_dinamarca', 'nascimento', 1968, 1968, 'exata', '1968');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_harald_v_da_noruega', 'pub_outras_monarquias_harald_v_da_noruega', 'nascimento', 1937, 1937, 'exata', '1937');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'nascimento', 1946, 1946, 'exata', '1946');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_alberto_ii_de_monaco', 'pub_outras_monarquias_alberto_ii_de_monaco', 'nascimento', 1958, 1958, 'exata', '1958');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'nascimento', 1945, 1945, 'exata', '1945');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_outras_monarquias_henri_de_luxemburgo', 'pub_outras_monarquias_henri_de_luxemburgo', 'nascimento', 1955, 1955, 'exata', '1955');

-- =====================================================================


-- =====================================================================
-- ATUALIZAÇÃO E INTEGRAÇÃO DAS LINHAGENS DAS 12 ÁRVORES PESQUISADAS
-- =====================================================================

-- 1. Novas pessoas e complementos das linhagens
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_aiko', 'Aiko', NULL, 'F', '', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_akihito', 'Akihito (Imperador', 'Emérito)', 'M', 'Imperador da era Heisei; primeiro a abdicar em cerca de 200 anos (2019).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_fumihito', 'Fumihito', '(Akishino)', 'M', 'Atuação: membro da realeza (herdeiro do trono).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_hisahito', 'Hisahito', '(Príncipe de Akishino)', 'M', 'Segundo na linha de sucessão ao Trono do Crisântemo japonês.', 1, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperador_jimmu', 'Jimmu', NULL, 'M', 'Fundador lendário da linhagem imperial japonesa.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperador_meiji', 'Meiji', NULL, 'M', 'Imperador da modernização do Japão (Restauração Meiji).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperador_showa', 'Shōwa', '(Hirohito)', 'M', 'Atuação: monarca.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperador_taisho', 'Taishō', '(Yoshihito)', 'M', '123º Imperador do Japão (1912–1926); período de abertura democrática Taishō.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperatriz_kojun', 'Kōjun', '(Nagako)', 'F', 'Imperatriz consorte do Imperador Shōwa (Hirohito); mãe de Akihito.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperatriz_masako', 'Masako', '(Masako Owada)', 'F', 'Imperatriz consorte do Japão; diplomata e poliglota de formação.', 1, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperatriz_michiko', 'Michiko', '(Michiko Shōda)', 'F', 'Imperatriz Emérita do Japão; primeira plebeia a ingressar na família imperial.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperatriz_shoken', 'Shōken', '(Haruko Ichijō)', 'F', 'Imperatriz consorte do Imperador Meiji; patrona da Cruz Vermelha japonesa.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_imperatriz_teimei', 'Teimei', '(Sadako Kujō)', 'F', 'Imperatriz consorte do Imperador Taishō e mãe do Imperador Shōwa.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_linhagem_yamato', 'Linhagem Imperial Yamato', '(Gerações Tradicionais)', 'M', '120 gerações da mais antiga dinastia hereditária contínua do mundo conectando o fundador Jimmu à era moderna.', 0, 1, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_naruhito', 'Naruhito', NULL, 'M', '126º imperador do Japão; era Reiwa, desde 2019.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_casa_imperial_japao_princesa_kiko', 'Kiko', '(Princesa Akishino)', 'F', 'Princesa consorte do Japão, nascida Kiko Kawashima.', 1, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_japao_jimmu', 'Imperatriz Consorte', '(Tradição Yamato)', 'F', 'Consorte imperial.', 0, 1, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_japao_yamato', 'Imperatriz Consorte', '(Linhagem Histórica)', 'F', 'Consorte imperial.', 0, 1, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_confucio', 'Confúcio', NULL, 'M', 'Filósofo chinês; fundador do confucionismo e ancestral da linhagem documentada mais longa da história.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_geracoes_yansheng', 'Linhagem Ducal Yansheng', '(70 Gerações da Casa Kong)', 'M', 'Linhagem hereditária dos Duques Yansheng, mantendo a mais longa árvore genealógica documentada da história mundial.', 0, 1, 1, 'Filosofia e Pensamento', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kong_ji', 'Kong Ji', '(Zisi)', 'U', 'Filósofo; a ele se atribui a "Doutrina do Meio" (Zhongyong).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kong_li', 'Kong Li', '(Boyu)', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kong_lingyi', 'Kong', 'Lingyi', 'M', 'Atuação: nobre (Duque Yansheng, 76ª geração).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kong_yu_jen', 'Kong', 'Yu-jen', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kung_te_cheng', 'Kung', 'Te-cheng', 'M', '77ª geração; último Duque Yansheng e primeiro Oficial Sacrificial a Confúcio.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kung_tsui_chang', 'Kung', 'Tsui-chang', 'M', '79ª geração; atual Oficial Sacrificial a Confúcio (Taiwan).', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_kung_wei_yi', 'Kung', 'Wei-yi', 'M', '', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_shuliang_he', 'Shuliang', 'He', 'M', 'Atuação: oficial militar.', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_kong_confucio_yan_zhengzai', 'Yan', 'Zhengzai', 'F', '', 0, 0, 1, 'Grandes Linhagens Antigas', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_confucio_geracoes_esposa', 'Esposa Nobre', '', 'F', 'Consorte.', 0, 1, 1, 'Filosofia e Pensamento', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_confucio_kong_li_esposa', 'Esposa de Kong Li', '', 'F', 'Consorte.', 0, 1, 1, 'Filosofia e Pensamento', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_confucio_lingyi_esposa', 'Madame Wang', '', 'F', 'Esposa do Duque Yansheng.', 0, 1, 1, 'Filosofia e Pensamento', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_confucio_wei_yi_esposa', 'Esposa de Kung Wei-yi', '', 'F', 'Consorte.', 0, 1, 1, 'Filosofia e Pensamento', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_amaranta', 'Amaranta', NULL, 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_amaranta_ursula', 'Amaranta', 'Úrsula', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_arcadio', 'Arcadio', NULL, 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_aureliano_babilonia', 'Aureliano', 'Babilonia', 'M', 'Decifra os pergaminhos de Melquíades que previam o destino da família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_aureliano_o_ultimo', 'Aureliano (o', 'último)', 'M', 'A criança com cauda de porco que cumpre a profecia e encerra a linhagem.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_aureliano_segundo', 'Aureliano', 'Segundo', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_coronel_aureliano_buendia', 'Coronel Aureliano', 'Buendía', 'M', 'Líder rebelde; teve 17 filhos, todos chamados Aureliano.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_fernanda_del_carpio', 'Fernanda', 'del Carpio', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_jose_arcadio', 'José Arcadio', '(filho)', 'U', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_jose_arcadio_buendia', 'José Arcadio', 'Buendía', 'M', 'Fundador de Macondo; visionário obcecado por alquimia.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_jose_arcadio_segundo', 'José Arcadio', 'Segundo', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_mauricio_babilonia', 'Mauricio', 'Babilonia', 'M', 'Mecânico da companhia bananeira, sempre cercado de borboletas amarelas; pai de Aureliano Babilonia com Renata Remedios (Meme).', 0, 0, 1, 'Literatura e Ficção', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_meme', 'Renata Remedios', '"Meme"', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_pilar_ternera', 'Pilar', 'Ternera', 'F', 'Matriarca informal e confidente da família Buendía, lê o destino nas cartas e gera Arcadio com José Arcadio filho.', 0, 0, 1, 'Literatura e Ficção', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_rebeca', 'Rebeca', NULL, 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_santa_sofia', 'Santa Sofía de la Piedad', '', 'F', 'Companheira fiel de Arcadio e mãe dos gêmeos Aureliano Segundo e José Arcadio Segundo.', 0, 0, 1, 'Literatura e Ficção', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_buendia_ursula_iguaran', 'Úrsula', 'Iguarán', 'F', 'Matriarca longeva; teme a maldição do incesto (um filho com cauda de porco).', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_carmela_corleone', 'Carmela', 'Corleone', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_connie_corleone', 'Constanzia "Connie"', 'Corleone', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_fredo_corleone', 'Fredo', 'Corleone', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_michael_corleone', 'Michael', 'Corleone', 'M', 'Filho caçula que se torna o sucessor de Vito à frente da família.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_sonny_corleone', 'Santino "Sonny"', 'Corleone', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_tom_hagen', 'Tom', 'Hagen', 'M', 'Consigliere da família; filho adotivo informal de Vito.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_vincent_mancini', 'Vincent Mancini', '(Corleone)', 'M', 'Filho ilegítimo de Sonny; assume a família na Parte III.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_corleone_vito_corleone', 'Vito', 'Corleone', 'M', 'Patriarca; imigrante siciliano que funda a família mafiosa em Nova York.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_benjy_compson', 'Benjamin "Benjy"', 'Compson', 'M', 'O irmão com deficiência intelectual; abre o romance com seu monólogo.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_caddy_compson', 'Candace "Caddy"', 'Compson', 'F', 'A irmã, eixo emocional do romance.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_caroline_compson', 'Caroline Bascomb', 'Compson', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_jason_compson_iii', 'Jason Compson', 'III', 'M', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_jason_compson_iv', 'Jason Compson', 'IV', 'M', 'O irmão amargo e cínico que assume o comando da casa em ruína.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_miss_quentin', 'Miss', 'Quentin', 'F', '', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_compson_quentin_compson', 'Quentin', 'Compson', 'M', 'O filho mais velho, atormentado; narrador de uma das seções.', 0, 0, 1, 'Genealogias Literárias e Ficcionais', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_compson_caddy_pai', 'Pai de Miss Quentin', '', 'M', 'Pai não confirmado de Miss Quentin.', 0, 1, 1, 'Literatura e Ficção', 'ficticio');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_afonso_xiii', 'Afonso', 'XIII', 'M', 'Atuação: monarca.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_felipe_vi', 'Felipe', 'VI', 'M', 'Rei da Espanha desde 2014.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_filipe_v_da_espanha', 'Filipe', 'V', 'M', 'Neto de Luís XIV; primeiro rei Bourbon da Espanha.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_henrique_iv_da_franca', 'Henrique', 'IV', 'M', 'Primeiro rei Bourbon da França; encerrou as guerras religiosas com o Édito de Nantes.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_juan_carlos_i', 'Juan Carlos', 'I', 'M', 'Rei que conduziu a transição democrática espanhola pós-Franco; abdicou em 2014.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_juan_de_borbon', 'Juan de Borbón (Conde', 'de Barcelona)', 'M', '', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_leonor_princesa_das_asturias', 'Leonor', 'de Borbón', 'F', 'Atuação: herdeira do trono (Princesa das Astúrias).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_letizia', 'Letizia', NULL, 'F', 'Atuação: jornalista; rainha consorte.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_luis_xiv', 'Luís', 'XIV', 'M', 'O "Rei Sol"; o mais longo reinado da história europeia (72 anos).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_luis_xvi', 'Luís', 'XVI', 'M', 'Rei deposto e guilhotinado na Revolução Francesa.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_maria_das_mercedes', 'Maria das Mercedes de Bourbon', '', 'F', 'Condessa de Barcelona, esposa de Dom Juan de Borbón e mãe de Juan Carlos I.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_maria_de_medici', 'Maria de Médici', '', 'F', 'Rainha consorte da França, segunda esposa de Henrique IV e regente do reino.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_maria_luisa_de_saboia', 'Maria Luísa de Saboia', '', 'F', 'Rainha consorte da Espanha, primeira esposa de Filipe V.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_maria_teresa_da_espanha', 'Maria Teresa da Espanha', '', 'F', 'Infanta da Espanha e rainha consorte da França, esposa de Luís XIV.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_rainha_sofia', 'Sofia da Grécia', '', 'F', 'Rainha emérita da Espanha, esposa de Juan Carlos I e mãe de Felipe VI.', 1, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_bourbon_vitoria_eugenia', 'Vitória Eugénia de Battenberg', '', 'F', 'Rainha consorte da Espanha, esposa de Afonso XIII e neta da rainha Vitória.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_albert_ii_belgica', 'Albert II da Bélgica', '', 'M', 'Rei dos Belgas (1993-2013), pai do rei Philippe.', 1, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_alexandrine', 'Alexandrine de Mecklemburgo', '', 'F', 'Rainha consorte da Dinamarca.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_astrid_da_suecia', 'Astrid da Suécia (Rainha dos Belgas)', '', 'F', 'Mãe dos reis Balduíno e Alberto II da Bélgica e da Grã-Duquesa Joséphine-Charlotte de Luxemburgo.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_beatrix_holanda', 'Princesa Beatrix dos Países Baixos', '', 'F', 'Rainha dos Países Baixos (1980-2013), mãe de Willem-Alexander.', 1, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_bernhard', 'Príncipe Bernhard de Lippe-Biesterfeld', '', 'M', 'Príncipe consorte dos Países Baixos.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_carol_da_suecia', 'Príncipe Carl da Suécia', '', 'M', 'Duque de Västergötland.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_claus', 'Príncipe Claus dos Países Baixos', '', 'M', 'Príncipe consorte dos Países Baixos, pai de Willem-Alexander.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_cristiano_ix', 'Cristiano IX da Dinamarca', '', 'M', 'Rei da Dinamarca (1863-1906), cognominado "O Sogro da Europa" por seus descendentes que ocuparam quase todos os tronos europeus.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_cristiano_x', 'Cristiano X da Dinamarca', '', 'M', 'Rei da Dinamarca durante as duas guerras mundiais.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_franz_josef_ii', 'Franz Josef II de Liechtenstein', '', 'M', 'Príncipe soberano de Liechtenstein (1938-1989), pai de Hans-Adam II.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_frederico_ix', 'Frederico IX da Dinamarca', '', 'M', 'Rei da Dinamarca, pai da rainha Margrethe II.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_frederico_viii', 'Frederico VIII da Dinamarca', '', 'M', 'Rei da Dinamarca, pai de Christian X e de Haakon VII da Noruega, e avô da rainha Astrid dos Belgas.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_gina', 'Condessa Georgina (Gina) von Wilczek', '', 'F', 'Princesa consorte de Liechtenstein, mãe de Hans-Adam II.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_grace_kelly', 'Grace Kelly (Princesa Grace de Mônaco)', '', 'F', 'Atriz e princesa consorte de Mônaco, mãe de Alberto II.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_gustavo_adolfo_duque', 'Gustavo Adolfo (Duque de Västerbotten)', '', 'M', 'Príncipe herdeiro da Suécia, pai do rei Carl XVI Gustaf.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_haakon_vii', 'Haakon VII da Noruega', '', 'M', 'Primeiro rei da Noruega moderna após a dissolução da união com a Suécia, filho de Frederico VIII.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_henrik', 'Príncipe Henrik da Dinamarca', '', 'M', 'Príncipe consorte da Dinamarca, pai de Frederik X.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_ingeborg', 'Princesa Ingeborg da Dinamarca', '', 'F', 'Princesa da Dinamarca e Suécia, avó dos reis Harald V da Noruega, Balduíno e Alberto II da Bélgica.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_ingrid_da_suecia', 'Ingrid da Suécia', '', 'F', 'Rainha consorte da Dinamarca, tia do rei Carl XVI Gustaf da Suécia.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_jean_luxemburgo', 'Grão-Duque Jean de Luxemburgo', '', 'M', 'Grão-Duque de Luxemburgo (1964-2000), pai do Grão-Duque Henri.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_josephine_charlotte', 'Joséphine-Charlotte da Bélgica', '', 'F', 'Grã-Duquesa consorte de Luxemburgo, irmã de Albert II da Bélgica e mãe de Henri.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_juliana_holanda', 'Rainha Juliana dos Países Baixos', '', 'F', 'Rainha dos Países Baixos (1948-1980), avó do rei Willem-Alexander.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_leopoldo_iii', 'Leopoldo III da Bélgica', '', 'M', 'Rei dos Belgas, pai de Albert II e avô de Philippe da Bélgica e Henri de Luxemburgo.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_luisa_da_suecia', 'Luísa da Suécia', '', 'F', 'Rainha consorte da Dinamarca, filha do rei Carlos XV da Suécia.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_luisa_de_hesse', 'Luísa de Hesse-Kassel', '', 'F', 'Rainha consorte da Dinamarca, matriarca das casas reais contemporâneas da Europa.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_margrethe_ii', 'Margrethe II da Dinamarca', '', 'F', 'Rainha da Dinamarca (1972-2024), mãe do atual rei Frederik X.', 1, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_martha_da_suecia', 'Princesa Märtha da Suécia', '', 'F', 'Princesa herdeira consorte da Noruega, mãe de Harald V.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_maud_do_reino_unido', 'Rainha Maud de Gales', '', 'F', 'Rainha consorte da Noruega, filha do rei Eduardo VII do Reino Unido.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_olav_v', 'Olav V da Noruega', '', 'M', 'Rei da Noruega (1957-1991), pai do rei Harald V.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_paola', 'Rainha Paola da Bélgica', '', 'F', 'Rainha consorte dos Belgas, mãe de Philippe.', 1, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_rainier_iii', 'Rainier III de Mônaco', '', 'M', 'Príncipe soberano de Mônaco, pai de Alberto II.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_monarquias_sibila_de_saxe', 'Princesa Sibila de Saxe-Coburgo-Gota', '', 'F', 'Mãe do rei Carl XVI Gustaf da Suécia.', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_alberto_ii_de_monaco', 'Alberto', 'II', 'M', 'Atuação: monarca (príncipe de Mônaco, desde 2005).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'Carl XVI', 'Gustaf', 'M', 'Atuação: monarca (rei da Suécia, desde 1973).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_frederik_x_da_dinamarca', 'Frederik', 'X', 'M', 'Atuação: monarca (rei da Dinamarca, desde 2024).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'Hans-Adam', 'II', 'M', 'Atuação: monarca (príncipe de Liechtenstein, desde 1989).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_harald_v_da_noruega', 'Harald', 'V', 'M', 'Atuação: monarca (rei da Noruega, desde 1991).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_henri_de_luxemburgo', 'Grão-Duque', 'Henri', 'M', 'Atuação: monarca (grão-duque de Luxemburgo, desde 2000).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_philippe_da_belgica', 'Philippe', NULL, 'M', 'Atuação: monarca (rei dos belgas, desde 2013).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'Willem-Alexander', NULL, 'M', 'Atuação: monarca (rei dos Países Baixos, desde 2013).', 0, 0, 1, 'Famílias Reais e Dinastias', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_albertina_de_morais_pinto', 'Albertina', 'de Morais Pinto', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_antonio_da_silva_prado_barao_de_iguape', 'Barão', 'de Iguape', 'M', 'Fundador da dinastia Prado; cafeicultor e comerciante, vice-presidente da Província de São Paulo.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_antonio_da_silva_prado_conselheiro', 'Conselheiro Antônio', 'Prado', 'M', 'Primeiro prefeito de São Paulo; ministro do Império e grande empreendedor do café.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_caio_da_silva_prado_1872', 'Caio', 'da Silva Prado', 'M', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_caio_da_silva_prado_tio', 'Caio', 'da Silva Prado', 'M', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_caio_prado_junior', 'Caio Prado', 'Júnior', 'M', 'Historiador marxista e editor; um dos grandes intérpretes do Brasil.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_eduardo_paulo_da_silva_prado', 'Eduardo', 'Prado', 'M', 'Escritor e jornalista monarquista; membro fundador da Academia Brasileira de Letras.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_fabio_da_silva_prado', 'Fábio', 'Prado', 'M', 'Prefeito de São Paulo (1934–1938).', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_maria_candida_de_moura_vaz', 'Baronesa', 'de Iguape', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_maria_catarina_da_silva_prado', 'Maria Catarina', 'da Silva Prado', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_marinette_prado', 'Marinette', 'Prado', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_martinho_da_silva_prado_1811', 'Martinho', 'da Silva Prado', 'M', 'Meio-irmão do Barão de Iguape; deputado provincial de São Paulo.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_martinho_da_silva_prado_junior', 'Martinico', 'Prado', 'M', 'Cafeicultor, abolicionista e propagandista republicano; pioneiro da imigração no Oeste paulista.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_martinho_da_silva_prado_neto', 'Martinho Prado', 'Neto', 'M', 'Atuação: político (deputado federal, 1935–37).', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_paulo_da_silva_prado', 'Paulo', 'Prado', 'M', 'Cafeicultor, mecenas e escritor; principal patrono da Semana de Arte Moderna de 1922.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_prado_veridiana_valeria_da_silva_prado', 'Veridiana', NULL, 'F', 'Matriarca dos Prado; manteve um dos salões culturais mais importantes de São Paulo no séc. XIX.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'Barão', 'do Rio Branco', 'M', 'Diplomata, "patrono da diplomacia brasileira"; consolidou as fronteiras do país como Ministro das Relações Exteriores.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'do Rio', 'Branco', 'M', 'Estadista do Império; presidente do Conselho de Ministros e responsável pela Lei do Ventre Livre (1871).', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_rio_branco_marie_stevens', 'Marie', 'Stevens', 'F', 'Atriz belga; esposa do Barão do Rio Branco.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_rio_branco_paulo_do_rio_branco', 'Paulo', 'do Rio Branco', 'M', 'Atuação: jogador de rúgbi.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_rio_branco_teresa_de_figueiredo_rodrigues_faria', 'Teresa', 'de Figueiredo Faria', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_arnaldo_guinle', 'Arnaldo', 'Guinle', 'M', 'Empresário e mecenas do esporte; grande patrono do Fluminense F.C.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_carlos_guinle', 'Carlos', 'Guinle', 'M', 'Atuação: empresário.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_celina_guinle', 'Celina', 'Guinle', 'F', '', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_eduardo_guinle_filho', 'Eduardo', 'Guinle', 'M', 'Primogênito; pioneiro do setor imobiliário carioca (comprou terrenos de Copacabana em 1902).', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_eduardo_palassin_guinle', 'Eduardo Palassin', 'Guinle', 'M', 'Patriarca da dinastia; cofundador da Companhia Docas de Santos e um dos homens mais ricos do Brasil.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_guilherme_guinle', 'Guilherme', 'Guinle', 'M', 'Empresário e mecenas; ligado à criação da CSN e a hospitais (Gaffrée e Guinle).', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_guilhermina_coutinho_da_silva', 'Guilhermina Coutinho', 'da Silva', 'F', '', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_guilhermina_guinle', 'Guilhermina', 'Guinle', 'F', 'Atuação: atriz.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_heloisa_guinle', 'Heloísa', 'Guinle', 'F', '', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_jean_arnauld_guinle', 'Jean-Arnauld', 'Guinle', 'M', 'Atuação: imigrante (comerciante).', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_jorge_guinle', 'Jorge "Jorginho"', 'Guinle', 'M', 'Bon vivant e crítico de jazz; dilapidou boa parte da fortuna herdada.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_josephine_palassin', 'Josephine Désirée Bernardine', 'Palassin', 'U', '', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_luiz_eduardo', 'Luiz Eduardo', 'Guinle', 'M', 'Pai da atriz Guilhermina Guinle e filho de Carlos Guinle.', 1, 0, 1, 'Grandes Famílias do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_guinle_octavio_guinle', 'Octávio', 'Guinle', 'M', 'Fundador do Copacabana Palace (1923) e construtor do Palácio das Laranjeiras.', 0, 0, 1, 'Grandes Empreendedores', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_guinle_luiz_esposa', 'Gisela', 'Guinle', 'F', 'Mãe de Guilhermina Guinle.', 1, 0, 1, 'Grandes Famílias do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_dinastias_21_23_psusennes_i', 'Psusennes', 'I', 'M', 'Atuação: faraó (21ª dinastia, Tânis).', 0, 0, 1, 'Egito Antigo e Faraós', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_dinastias_21_23_sheshonq_i', 'Sheshonq', 'I', 'M', 'Fundador da 22ª dinastia (líbia); frequentemente associado ao "Shishak" bíblico.', 0, 0, 1, 'Egito Antigo e Faraós', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_dinastias_21_23_transicao', 'Transição Tânis-Bubástis', '(Aliança 21ª-22ª Dinastias)', 'M', 'Aliança dinástica entre a casa real de Tânis e os governantes da 22ª dinastia.', 0, 1, 1, 'Egito Antigo e Faraós', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_dinastias_consorte', 'Esposa Real', '(Dinastia 21-22)', 'F', 'Consorte.', 0, 1, 1, 'Egito Antigo e Faraós', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_ph_souza_queiros_esposa_vergueiro', 'Esposa do Senador Vergueiro', '', 'F', 'Consorte.', 0, 1, 1, 'Grandes Famílias do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', 'Antônia Eufrosina', 'Vergueiro', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'Barão', 'de Sousa Queirós', 'M', 'Barão de Sousa Queirós; senador do Império e cafeicultor; fundou o Instituto Ana Rosa (1874).', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_genebra_de_barros_leite', 'Genebra', 'de Barros Leite', 'F', '', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_luis_antonio_de_sousa_queiros', 'Brigadeiro Luís Antônio', 'de Sousa Queirós', 'M', 'O "Brigadeiro Luís Antônio"; um dos maiores proprietários de terras de São Paulo e um dos homens mais ricos do Brasil.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_maria_angelica_de_sousa_queiros', 'Maria Angélica', 'de Sousa Queirós', 'F', 'Proprietária rural; grande latifundiária da região central de São Paulo.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'Senador', 'Vergueiro', 'M', 'Senador Vergueiro; cafeicultor e político, pioneiro do trabalho imigrante na Fazenda Ibicaba.', 0, 0, 1, 'História do Brasil', 'real');
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo) VALUES ('pub_souza_queiros_vicente_de_sousa_queiros', 'Barão', 'de Limeira', 'M', 'Barão de Limeira; cafeicultor e vereador.', 0, 0, 1, 'História do Brasil', 'real');

-- 2. Atualização das raízes das árvores
UPDATE arvores SET raiz_pessoa_id = 'pub_casa_imperial_japao_imperador_meiji' WHERE id = 'pub_arv_casa_imperial_japao';
UPDATE arvores SET raiz_pessoa_id = 'pub_kong_confucio_confucio' WHERE id = 'pub_arv_kong_confucio';
UPDATE arvores SET raiz_pessoa_id = 'pub_buendia_jose_arcadio_buendia' WHERE id = 'pub_arv_buendia';
UPDATE arvores SET raiz_pessoa_id = 'pub_corleone_vito_corleone' WHERE id = 'pub_arv_corleone';
UPDATE arvores SET raiz_pessoa_id = 'pub_compson_jason_compson_iii' WHERE id = 'pub_arv_compson';
UPDATE arvores SET raiz_pessoa_id = 'pub_bourbon_henrique_iv_da_franca' WHERE id = 'pub_arv_bourbon';
UPDATE arvores SET raiz_pessoa_id = 'pub_monarquias_cristiano_ix' WHERE id = 'pub_arv_outras_monarquias';
UPDATE arvores SET raiz_pessoa_id = 'pub_prado_antonio_da_silva_prado_barao_de_iguape' WHERE id = 'pub_arv_prado';
UPDATE arvores SET raiz_pessoa_id = 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco' WHERE id = 'pub_arv_rio_branco';
UPDATE arvores SET raiz_pessoa_id = 'pub_guinle_jean_arnauld_guinle' WHERE id = 'pub_arv_guinle';
UPDATE arvores SET raiz_pessoa_id = 'pub_dinastias_21_23_sheshonq_i' WHERE id = 'pub_arv_dinastias_21_23';
UPDATE arvores SET raiz_pessoa_id = 'pub_souza_queiros_luis_antonio_de_sousa_queiros' WHERE id = 'pub_arv_souza_queiros';

-- 3. Uniões familiares corrigidas e integradas
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_akihito', 'pub_casa_imperial_japao_imperatriz_michiko', 'casamento', 'Casamento imperial em 1959');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_fumihito_kiko', 'pub_casa_imperial_japao_fumihito', 'pub_casa_imperial_japao_princesa_kiko', 'casamento', 'Casamento imperial em 1990');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_jimmu_linhagem', 'pub_casa_imperial_japao_imperador_jimmu', 'pub_ph_japao_jimmu', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_meiji_shoken', 'pub_casa_imperial_japao_imperador_meiji', 'pub_casa_imperial_japao_imperatriz_shoken', 'casamento', 'Casamento imperial em 1869');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_naruhito_masako', 'pub_casa_imperial_japao_naruhito', 'pub_casa_imperial_japao_imperatriz_masako', 'casamento', 'Casamento imperial em 1993');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_showa_kojun', 'pub_casa_imperial_japao_imperador_showa', 'pub_casa_imperial_japao_imperatriz_kojun', 'casamento', 'Casamento imperial em 1924');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_taisho_teimei', 'pub_casa_imperial_japao_imperador_taisho', 'pub_casa_imperial_japao_imperatriz_teimei', 'casamento', 'Casamento imperial em 1900');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_japao_yamato_meiji', 'pub_casa_imperial_japao_linhagem_yamato', 'pub_ph_japao_yamato', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_kong_ji_yansheng', 'pub_kong_confucio_kong_ji', 'pub_ph_confucio_geracoes_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_kong_li', 'pub_kong_confucio_kong_li', 'pub_ph_confucio_kong_li_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_lingyi', 'pub_kong_confucio_kong_lingyi', 'pub_ph_confucio_lingyi_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_pais', 'pub_kong_confucio_shuliang_he', 'pub_kong_confucio_yan_zhengzai', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_wei_yi', 'pub_kong_confucio_kung_wei_yi', 'pub_ph_confucio_wei_yi_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_confucio_yansheng_lingyi', 'pub_kong_confucio_geracoes_yansheng', 'pub_ph_confucio_geracoes_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p', 'pub_kong_confucio_confucio', 'pub_ph_pub_kong_confucio_confucio', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_', 'pub_kong_confucio_kung_te_cheng', 'pub_ph_pub_kong_confucio_kung_te_cheng', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan', 'pub_kong_confucio_kung_tsui_chang', 'pub_ph_pub_kong_confucio_kung_tsui_chang', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_babilonia_amaranta_ursula', 'pub_buendia_aureliano_babilonia', 'pub_buendia_amaranta_ursula', 'casamento', 'Linhagem final de Macondo');
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_jose_arcadio_filho', 'pub_buendia_jose_arcadio', 'pub_buendia_pilar_ternera', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_meme_mauricio', 'pub_buendia_mauricio_babilonia', 'pub_buendia_meme', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia', 'pub_buendia_arcadio', 'pub_ph_pub_buendia_arcadio', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_aureliano_segundo', 'pub_buendia_fernanda_del_carpio', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_jose_arcadio_buendia', 'pub_buendia_ursula_iguaran', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu', 'pub_corleone_sonny_corleone', 'pub_ph_pub_corleone_sonny_corleone', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_vito_corleone', 'pub_corleone_carmela_corleone', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_compson_caddy_quentin', 'pub_ph_compson_caddy_pai', 'pub_compson_caddy_compson', 'dissolvida', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_jason_compson_iii', 'pub_compson_caroline_compson', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_afonso_juan', 'pub_bourbon_afonso_xiii', 'pub_bourbon_vitoria_eugenia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_felipe_letizia', 'pub_bourbon_felipe_vi', 'pub_bourbon_letizia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_filipe_afonso', 'pub_bourbon_filipe_v_da_espanha', 'pub_bourbon_maria_luisa_de_saboia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_henrique_luis', 'pub_bourbon_henrique_iv_da_franca', 'pub_bourbon_maria_de_medici', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_juan_carlos_felipe', 'pub_bourbon_juan_carlos_i', 'pub_bourbon_rainha_sofia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_juan_juan_carlos', 'pub_bourbon_juan_de_borbon', 'pub_bourbon_maria_das_mercedes', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_luis_xiv', 'pub_bourbon_maria_teresa_da_espanha', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_albert_paola', 'pub_monarquias_albert_ii_belgica', 'pub_monarquias_paola', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_beatrix_claus', 'pub_monarquias_claus', 'pub_monarquias_beatrix_holanda', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_carl_ingeborg', 'pub_monarquias_carol_da_suecia', 'pub_monarquias_ingeborg', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_cristiano_alexandrine', 'pub_monarquias_cristiano_x', 'pub_monarquias_alexandrine', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_cristiano_ix', 'pub_monarquias_luisa_de_hesse', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_franz_gina', 'pub_monarquias_franz_josef_ii', 'pub_monarquias_gina', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_frederico_ingrid', 'pub_monarquias_frederico_ix', 'pub_monarquias_ingrid_da_suecia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_frederico_luisa', 'pub_monarquias_frederico_viii', 'pub_monarquias_luisa_da_suecia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_gustavo_sibila', 'pub_monarquias_gustavo_adolfo_duque', 'pub_monarquias_sibila_de_saxe', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_haakon_maud', 'pub_monarquias_haakon_vii', 'pub_monarquias_maud_do_reino_unido', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_jean_josephine', 'pub_monarquias_jean_luxemburgo', 'pub_monarquias_josephine_charlotte', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_juliana_bernhard', 'pub_monarquias_bernhard', 'pub_monarquias_juliana_holanda', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_leopoldo_astrid', 'pub_monarquias_leopoldo_iii', 'pub_monarquias_astrid_da_suecia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_margrethe_henrik', 'pub_monarquias_henrik', 'pub_monarquias_margrethe_ii', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_olav_martha', 'pub_monarquias_olav_v', 'pub_monarquias_martha_da_suecia', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_monarquias_rainier_grace', 'pub_monarquias_rainier_iii', 'pub_monarquias_grace_kelly', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', 'pub_prado_maria_candida_de_moura_vaz', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_conselh', 'pub_prado_antonio_da_silva_prado_conselheiro', 'pub_prado_maria_catarina_da_silva_prado', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p', 'pub_prado_caio_da_silva_prado_1872', 'pub_ph_pub_prado_caio_da_silva_prado_1872', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_martinho_da_silva_prado_1811', 'pub_prado_veridiana_valeria_da_silva_prado', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_junior', 'pub_prado_albertina_de_morais_pinto', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_prado_pub_prado_paulo_da_silva_prado_pub_prado', 'pub_prado_paulo_da_silva_prado', 'pub_prado_marinette_prado', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_rio_branco_pub_rio_branco_jose_maria_da_silva_', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'pub_rio_branco_marie_stevens', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_rio_branco_visconde_teresa', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', 'pub_rio_branco_teresa_de_figueiredo_rodrigues_faria', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_guinle_carlos_luiz', 'pub_guinle_carlos_guinle', 'pub_ph_pub_guinle_carlos_guinle', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_guinle_jean_josephine', 'pub_guinle_jean_arnauld_guinle', 'pub_guinle_josephine_palassin', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_guinle_luiz_guilhermina', 'pub_guinle_luiz_eduardo', 'pub_ph_guinle_luiz_esposa', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui', 'pub_guinle_carlos_guinle', 'pub_ph_pub_guinle_carlos_guinle', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_eduardo_palassin_guinle', 'pub_guinle_guilhermina_coutinho_da_silva', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_dinastias_psusennes_trans', 'pub_dinastias_21_23_psusennes_i', 'pub_ph_dinastias_consorte', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_dinastias_trans_sheshonq', 'pub_dinastias_21_23_transicao', 'pub_ph_dinastias_consorte', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_luis_antonio_de_sousa_queiros', 'pub_souza_queiros_genebra_de_barros_leite', 'casamento', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota) VALUES ('pub_u_souza_queiros_vergueiro', 'pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', 'pub_ph_souza_queiros_esposa_vergueiro', 'casamento', NULL);

-- 4. Vínculos de descendência (uniao_filhos)
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_naruhito', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_akihito_michiko', 'pub_casa_imperial_japao_fumihito', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_fumihito_kiko', 'pub_casa_imperial_japao_hisahito', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_jimmu_linhagem', 'pub_casa_imperial_japao_linhagem_yamato', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_meiji_shoken', 'pub_casa_imperial_japao_imperador_taisho', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_naruhito_masako', 'pub_casa_imperial_japao_aiko', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_showa_kojun', 'pub_casa_imperial_japao_akihito', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_taisho_teimei', 'pub_casa_imperial_japao_imperador_showa', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_japao_yamato_meiji', 'pub_casa_imperial_japao_imperador_meiji', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_kong_ji_yansheng', 'pub_kong_confucio_geracoes_yansheng', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_kong_li', 'pub_kong_confucio_kong_ji', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_lingyi', 'pub_kong_confucio_kung_te_cheng', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_pais', 'pub_kong_confucio_confucio', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_wei_yi', 'pub_kong_confucio_kung_tsui_chang', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_confucio_yansheng_lingyi', 'pub_kong_confucio_kong_lingyi', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p', 'pub_kong_confucio_kong_li', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_', 'pub_kong_confucio_kung_wei_yi', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan', 'pub_kong_confucio_kong_yu_jen', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_babilonia_amaranta_ursula', 'pub_buendia_aureliano_o_ultimo', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_jose_arcadio_filho', 'pub_buendia_arcadio', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_meme_mauricio', 'pub_buendia_aureliano_babilonia', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_meme', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen', 'pub_buendia_amaranta_ursula', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_jose_arcadio', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_coronel_aureliano_buendia', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_amaranta', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b', 'pub_buendia_rebeca', 'adotado', 4);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu', 'pub_corleone_vincent_mancini', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_sonny_corleone', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_fredo_corleone', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_michael_corleone', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_connie_corleone', 'biologico', 4);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo', 'pub_corleone_tom_hagen', 'adotado', 5);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_compson_caddy_quentin', 'pub_compson_miss_quentin', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_quentin_compson', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_caddy_compson', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_jason_compson_iv', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp', 'pub_compson_benjy_compson', 'biologico', 4);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_afonso_juan', 'pub_bourbon_juan_de_borbon', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_felipe_letizia', 'pub_bourbon_leonor_princesa_das_asturias', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_filipe_afonso', 'pub_bourbon_afonso_xiii', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_henrique_luis', 'pub_bourbon_luis_xiv', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_juan_carlos_felipe', 'pub_bourbon_felipe_vi', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_juan_juan_carlos', 'pub_bourbon_juan_carlos_i', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_luis_xvi', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_bourbon_luis_xiv_desc', 'pub_bourbon_filipe_v_da_espanha', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_albert_paola', 'pub_outras_monarquias_philippe_da_belgica', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_beatrix_claus', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_carl_ingeborg', 'pub_monarquias_astrid_da_suecia', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_carl_ingeborg', 'pub_monarquias_martha_da_suecia', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_alexandrine', 'pub_monarquias_frederico_ix', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_frederico_viii', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_gustavo_adolfo_duque', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_juliana_holanda', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_rainier_iii', 'biologico', 4);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_cristiano_luisa', 'pub_monarquias_franz_josef_ii', 'biologico', 5);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_franz_gina', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_frederico_ingrid', 'pub_monarquias_margrethe_ii', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_frederico_luisa', 'pub_monarquias_cristiano_x', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_frederico_luisa', 'pub_monarquias_haakon_vii', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_frederico_luisa', 'pub_monarquias_ingeborg', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_gustavo_sibila', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_haakon_maud', 'pub_monarquias_olav_v', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_jean_josephine', 'pub_outras_monarquias_henri_de_luxemburgo', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_juliana_bernhard', 'pub_monarquias_beatrix_holanda', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_leopoldo_astrid', 'pub_monarquias_albert_ii_belgica', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_leopoldo_astrid', 'pub_monarquias_josephine_charlotte', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_margrethe_henrik', 'pub_outras_monarquias_frederik_x_da_dinamarca', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_olav_martha', 'pub_outras_monarquias_harald_v_da_noruega', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_monarquias_rainier_grace', 'pub_outras_monarquias_alberto_ii_de_monaco', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d', 'pub_prado_martinho_da_silva_prado_1811', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d', 'pub_prado_caio_da_silva_prado_tio', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_conselh', 'pub_prado_paulo_da_silva_prado', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p', 'pub_prado_caio_prado_junior', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_antonio_da_silva_prado_conselheiro', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_martinho_da_silva_prado_junior', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p', 'pub_prado_eduardo_paulo_da_silva_prado', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_fabio_da_silva_prado', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_martinho_da_silva_prado_neto', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior', 'pub_prado_caio_da_silva_prado_1872', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_rio_branco_pub_rio_branco_jose_maria_da_silva_', 'pub_rio_branco_paulo_do_rio_branco', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_rio_branco_visconde_teresa', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_guinle_carlos_luiz', 'pub_guinle_luiz_eduardo', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_guinle_jean_josephine', 'pub_guinle_eduardo_palassin_guinle', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_guinle_luiz_guilhermina', 'pub_guinle_guilhermina_guinle', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui', 'pub_guinle_jorge_guinle', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_eduardo_guinle_filho', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_guilherme_guinle', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_carlos_guinle', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_arnaldo_guinle', 'biologico', 4);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_octavio_guinle', 'biologico', 5);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_celina_guinle', 'biologico', 6);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_', 'pub_guinle_heloisa_guinle', 'biologico', 7);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_dinastias_psusennes_trans', 'pub_dinastias_21_23_transicao', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_dinastias_trans_sheshonq', 'pub_dinastias_21_23_sheshonq_i', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d', 'pub_souza_queiros_vicente_de_sousa_queiros', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES ('pub_u_souza_queiros_vergueiro', 'pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', 'biologico', 1);

-- 5. Inclusão dos membros nas árvores (arvore_membros)
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_jimmu', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_meiji', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_showa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_akihito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_naruhito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_fumihito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_aiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_shoken', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperador_taisho', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_teimei', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_kojun', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_michiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_imperatriz_masako', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_princesa_kiko', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_hisahito', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_casa_imperial_japao_linhagem_yamato', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_ph_japao_jimmu', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', 'pub_ph_japao_yamato', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_meiji_shoken');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_taisho_teimei');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_showa_kojun');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_akihito_michiko');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_naruhito_masako');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_fumihito_kiko');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_jimmu_linhagem');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_casa_imperial_japao', NULL, 'pub_u_japao_yamato_meiji');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_shuliang_he', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_yan_zhengzai', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_confucio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_li', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_ji', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_lingyi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_te_cheng', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_wei_yi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kung_tsui_chang', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_kong_yu_jen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_ph_confucio_kong_li_esposa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_kong_confucio_geracoes_yansheng', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_ph_confucio_geracoes_esposa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_ph_confucio_lingyi_esposa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', 'pub_ph_confucio_wei_yi_esposa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_confucio_pub_p');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_te_cheng_');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_pub_arv_kong_confucio_pub_kong_confucio_kung_tsui_chan');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_pais');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_kong_li');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_kong_ji_yansheng');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_yansheng_lingyi');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_lingyi');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_kong_confucio', NULL, 'pub_u_confucio_wei_yi');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio_buendia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_ursula_iguaran', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_coronel_aureliano_buendia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_amaranta', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_rebeca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_arcadio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_segundo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_jose_arcadio_segundo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_fernanda_del_carpio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_meme', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_amaranta_ursula', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_babilonia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_aureliano_o_ultimo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_pilar_ternera', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_santa_sofia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', 'pub_buendia_mauricio_babilonia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_aureliano_segundo_pub_buen');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_pub_buendia_arcadio_pub_ph_pub_buendia');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_jose_arcadio_filho');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_meme_mauricio');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_buendia', NULL, 'pub_u_pub_arv_buendia_babilonia_amaranta_ursula');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_vito_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_carmela_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_sonny_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_fredo_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_michael_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_connie_corleone', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_tom_hagen', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', 'pub_corleone_vincent_mancini', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', NULL, 'pub_u_pub_arv_corleone_pub_corleone_vito_corleone_pub_corleo');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_corleone', NULL, 'pub_u_pub_arv_corleone_pub_corleone_sonny_corleone_pub_ph_pu');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_jason_compson_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_caroline_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_quentin_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_caddy_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_jason_compson_iv', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_benjy_compson', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_compson_miss_quentin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', 'pub_ph_compson_caddy_pai', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', NULL, 'pub_u_pub_arv_compson_pub_compson_jason_compson_iii_pub_comp');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_compson', NULL, 'pub_u_compson_caddy_quentin');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_henrique_iv_da_franca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_luis_xiv', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_luis_xvi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_filipe_v_da_espanha', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_afonso_xiii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_juan_de_borbon', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_juan_carlos_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_felipe_vi', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_letizia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_leonor_princesa_das_asturias', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_maria_de_medici', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_maria_teresa_da_espanha', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_maria_luisa_de_saboia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_vitoria_eugenia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_maria_das_mercedes', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', 'pub_bourbon_rainha_sofia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_henrique_luis');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_luis_xiv_desc');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_filipe_afonso');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_afonso_juan');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_juan_juan_carlos');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_juan_carlos_felipe');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_bourbon', NULL, 'pub_u_bourbon_felipe_letizia');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_philippe_da_belgica', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_willem_alexander_dos_paises_baixos', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_frederik_x_da_dinamarca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_harald_v_da_noruega', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_carl_xvi_gustaf_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_alberto_ii_de_monaco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_hans_adam_ii_de_liechtenstein', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_outras_monarquias_henri_de_luxemburgo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_cristiano_ix', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_luisa_de_hesse', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_frederico_viii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_luisa_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_ingeborg', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_carol_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_astrid_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_leopoldo_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_haakon_vii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_maud_do_reino_unido', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_olav_v', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_martha_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_cristiano_x', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_alexandrine', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_frederico_ix', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_ingrid_da_suecia', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_margrethe_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_henrik', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_gustavo_adolfo_duque', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_sibila_de_saxe', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_albert_ii_belgica', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_paola', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_jean_luxemburgo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_josephine_charlotte', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_juliana_holanda', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_bernhard', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_beatrix_holanda', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_claus', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_rainier_iii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_grace_kelly', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_franz_josef_ii', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', 'pub_monarquias_gina', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_cristiano_luisa');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_frederico_luisa');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_cristiano_alexandrine');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_frederico_ingrid');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_margrethe_henrik');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_haakon_maud');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_olav_martha');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_carl_ingeborg');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_leopoldo_astrid');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_albert_paola');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_jean_josephine');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_gustavo_sibila');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_juliana_bernhard');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_beatrix_claus');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_rainier_grace');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_outras_monarquias', NULL, 'pub_u_monarquias_franz_gina');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_antonio_da_silva_prado_barao_de_iguape', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_maria_candida_de_moura_vaz', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_1811', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_veridiana_valeria_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_antonio_da_silva_prado_conselheiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_maria_catarina_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_junior', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_albertina_de_morais_pinto', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_eduardo_paulo_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_caio_da_silva_prado_tio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_paulo_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_marinette_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_fabio_da_silva_prado', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_martinho_da_silva_prado_neto', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_caio_da_silva_prado_1872', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', 'pub_prado_caio_prado_junior', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_barao_d');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_1811_p');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_antonio_da_silva_prado_conselh');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_martinho_da_silva_prado_junior');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_paulo_da_silva_prado_pub_prado');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_prado', NULL, 'pub_u_pub_arv_prado_pub_prado_caio_da_silva_prado_1872_pub_p');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', 'pub_rio_branco_teresa_de_figueiredo_rodrigues_faria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', 'pub_rio_branco_jose_maria_da_silva_paranhos_junior_barao_do_rio_branco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', 'pub_rio_branco_marie_stevens', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', 'pub_rio_branco_paulo_do_rio_branco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', NULL, 'pub_u_pub_arv_rio_branco_pub_rio_branco_jose_maria_da_silva_');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_rio_branco', NULL, 'pub_u_rio_branco_visconde_teresa');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_jean_arnauld_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_josephine_palassin', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_eduardo_palassin_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_guilhermina_coutinho_da_silva', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_eduardo_guinle_filho', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_guilherme_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_carlos_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_arnaldo_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_octavio_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_celina_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_heloisa_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_jorge_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_guilhermina_guinle', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_guinle_luiz_eduardo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', 'pub_ph_guinle_luiz_esposa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', NULL, 'pub_u_pub_arv_guinle_pub_guinle_eduardo_palassin_guinle_pub_');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', NULL, 'pub_u_pub_arv_guinle_pub_guinle_carlos_guinle_pub_ph_pub_gui');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', NULL, 'pub_u_guinle_jean_josephine');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', NULL, 'pub_u_guinle_carlos_luiz');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_guinle', NULL, 'pub_u_guinle_luiz_guilhermina');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', 'pub_dinastias_21_23_psusennes_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', 'pub_dinastias_21_23_sheshonq_i', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', 'pub_dinastias_21_23_transicao', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', 'pub_ph_dinastias_consorte', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', NULL, 'pub_u_dinastias_psusennes_trans');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_dinastias_21_23', NULL, 'pub_u_dinastias_trans_sheshonq');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_luis_antonio_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_genebra_de_barros_leite', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_nicolau_pereira_de_campos_vergueiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_francisco_antonio_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_antonia_eufrosina_de_campos_vergueiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_vicente_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_souza_queiros_maria_angelica_de_sousa_queiros', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', 'pub_ph_souza_queiros_esposa_vergueiro', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', NULL, 'pub_u_pub_arv_souza_queiros_pub_souza_queiros_luis_antonio_d');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', NULL, 'pub_u_pub_arv_souza_queiros_pub_souza_queiros_francisco_anto');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_souza_queiros', NULL, 'pub_u_souza_queiros_vergueiro');

-- =====================================================================
-- ÁRVORE: Protagonistas da Independência do Brasil (1822)
-- =====================================================================
INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_marquesa_santos', 'Domitila de Castro', '(Marquesa de Santos)', 'F', 'Aristocrata paulista e favorita de D. Pedro I, com grande influência na corte imperial.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_jose_bonifacio', 'José Bonifácio', 'de Andrada e Silva', 'M', 'O Patriarca da Independência. Estadista santista, mineralogista catedrático em Coimbra, Grão-Mestre da maçonaria (facção Azul/Apostolado) e ministro do Reino.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_antonio_carlos', 'Antônio Carlos', 'Ribeiro de Andrada', 'M', 'Magistrado e orador. Líder da bancada brasileira nas Cortes de Lisboa e relator da Constituinte de 1823.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_martim_francisco', 'Martim Francisco', 'Ribeiro de Andrada', 'M', 'Naturalista e Ministro da Fazenda do primeiro gabinete imperial.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_bonifacio_jose_pai', 'Bonifácio José', 'Ribeiro de Andrada', 'M', 'Coronel de milícias em Santos e patriarca da família Andrada.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_maria_barbara_mae', 'Maria Bárbara', 'da Silva', 'F', 'Matriarca dos Andradas, prima de seu esposo [CONSANGUINIDADE].', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_ph_narcisa_oleary', 'Narcisa Emília', 'O''Leary', 'F', 'Esposa irlandesa de José Bonifácio de Andrada e Silva.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_gabriela_andrada', 'Gabriela Frederica', 'Ribeiro de Andrada', 'F', 'Filha de José Bonifácio. Casou-se com o tio Martim Francisco [CONSANGUINIDADE].', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_goncalves_ledo', 'Joaquim Gonçalves Ledo', NULL, 'M', 'Jornalista e líder maçônico (facção Vermelha, liberal-republicana). Articulador do Dia do Fico e do Manifesto aos Povos.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_januario_barbosa', 'Januário da Cunha Barbosa', '(Cônego)', 'M', 'Cônego da Capela Real, jornalista revolucionário do Revérbero e cofundador do IHGB.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_maria_quiteria', 'Maria Quitéria', 'de Jesus', 'F', 'Heroína da Guerra da Independência na Bahia. Alistou-se como Soldado Medeiros e foi a primeira mulher no Exército Brasileiro.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_frei_caneca', 'Frei Caneca', '(Joaquim do Amor Divino)', 'M', 'Frade carmelita, professor e líder da Confederação do Equador (1824). Fuzilado no Recife.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_joana_angelica', 'Sóror Joana Angélica', NULL, 'F', 'Abadessa conceicionista do Convento da Lapa (Salvador). Mártir morta ao defender o claustro em 19/02/1822.', 0, 0, 1, 'História do Brasil', 'real');

INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_maria_felipa', 'Maria Felipa', 'de Oliveira', 'F', 'Marisqueira e líder negra da resistência em Itaparica (Bahia), comandou a queima de naus portuguesas.', 0, 0, 1, 'História do Brasil', 'real');

-- Árvore
INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_independencia_1822', 'Protagonistas da Independência (1822)', 'Família Imperial, Clã dos Andradas, líderes da maçonaria liberal e heróis da Guerra da Independência', 'pub_pedro1', 1, 'História do Brasil', 'Brasil', '1820–1825', 'real');

-- Uniões
INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_pedro1_domitila', 'pub_pedro1', 'pub_marquesa_santos', 'estavel', 'Relação e aliança iniciada em agosto de 1822 em São Paulo');

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_bonifacio_mariabarbara', 'pub_bonifacio_jose_pai', 'pub_maria_barbara_mae', 'casamento', 'Casamento entre primos-irmãos [CONSANGUINIDADE]');

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_josebonifacio_narcisa', 'pub_jose_bonifacio', 'pub_ph_narcisa_oleary', 'casamento', 'Casamento com Narcisa Emília O''Leary');

INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_martim_gabriela', 'pub_martim_francisco', 'pub_gabriela_andrada', 'casamento', 'Casamento entre tio e sobrinha carnal [CONSANGUINIDADE]');

-- Filhos
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES ('pub_u_bonifacio_mariabarbara', 'pub_jose_bonifacio', 1);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES ('pub_u_bonifacio_mariabarbara', 'pub_antonio_carlos', 2);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES ('pub_u_bonifacio_mariabarbara', 'pub_martim_francisco', 3);
INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES ('pub_u_josebonifacio_narcisa', 'pub_gabriela_andrada', 1);

-- Membros da árvore
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_joao6', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_carlota', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_pedro1', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_leopoldina', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_marquesa_santos', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_bonifacio_jose_pai', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_maria_barbara_mae', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_jose_bonifacio', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_antonio_carlos', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_martim_francisco', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_ph_narcisa_oleary', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_gabriela_andrada', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_goncalves_ledo', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_januario_barbosa', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_maria_quiteria', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_frei_caneca', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_joana_angelica', NULL);
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', 'pub_maria_felipa', NULL);

INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', NULL, 'pub_u_pedro1_leopoldina');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', NULL, 'pub_u_pedro1_domitila');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', NULL, 'pub_u_bonifacio_mariabarbara');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', NULL, 'pub_u_josebonifacio_narcisa');
INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id) VALUES ('pub_arv_independencia_1822', NULL, 'pub_u_martim_gabriela');

-- Eventos de Nascimento e Morte
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_marquesa_santos', 'pub_marquesa_santos', 'nascimento', 1797, 1797, 'exata', '27 de dezembro de 1797');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_marquesa_santos', 'pub_marquesa_santos', 'falecimento', 1867, 1867, 'exata', '3 de novembro de 1867');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_jose_bonifacio', 'pub_jose_bonifacio', 'nascimento', 1763, 1763, 'exata', '13 de junho de 1763');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_jose_bonifacio', 'pub_jose_bonifacio', 'falecimento', 1838, 1838, 'exata', '6 de abril de 1838');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_antonio_carlos', 'pub_antonio_carlos', 'nascimento', 1773, 1773, 'exata', '1 de novembro de 1773');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_antonio_carlos', 'pub_antonio_carlos', 'falecimento', 1845, 1845, 'exata', '5 de dezembro de 1845');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_martim_francisco', 'pub_martim_francisco', 'nascimento', 1775, 1775, 'exata', '9 de abril de 1775');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_martim_francisco', 'pub_martim_francisco', 'falecimento', 1844, 1844, 'exata', '23 de fevereiro de 1844');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_goncalves_ledo', 'pub_goncalves_ledo', 'nascimento', 1781, 1781, 'exata', '11 de dezembro de 1781');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_goncalves_ledo', 'pub_goncalves_ledo', 'falecimento', 1847, 1847, 'exata', '9 de maio de 1847');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_januario_barbosa', 'pub_januario_barbosa', 'nascimento', 1780, 1780, 'exata', '10 de julho de 1780');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_januario_barbosa', 'pub_januario_barbosa', 'falecimento', 1846, 1846, 'exata', '26 de abril de 1846');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_maria_quiteria', 'pub_maria_quiteria', 'nascimento', 1792, 1792, 'exata', '27 de julho de 1792');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_maria_quiteria', 'pub_maria_quiteria', 'falecimento', 1853, 1853, 'exata', '21 de agosto de 1853');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_frei_caneca', 'pub_frei_caneca', 'nascimento', 1779, 1779, 'exata', '20 de agosto de 1779');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_frei_caneca', 'pub_frei_caneca', 'falecimento', 1825, 1825, 'exata', '13 de janeiro de 1825');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_joana_angelica', 'pub_joana_angelica', 'nascimento', 1761, 1761, 'exata', '12 de dezembro de 1761');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_joana_angelica', 'pub_joana_angelica', 'falecimento', 1822, 1822, 'exata', '19 de fevereiro de 1822');

INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_maria_felipa', 'pub_maria_felipa', 'nascimento', 1799, 1799, 'cerca_de', 'c. 1799');
INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_maria_felipa', 'pub_maria_felipa', 'falecimento', 1873, 1873, 'exata', '4 de julho de 1873');

-- Vínculos com os marcos da linha do tempo da Independência
INSERT OR IGNORE INTO marco_participantes (id, marco_id, pessoa_id, papel, visivel_na_pessoa) VALUES
('mp-fico-pedro1', 'ind-1822-01-09', 'pub_pedro1', 'Príncipe Regente que proclamou a permanência no Brasil', 1),
('mp-fico-ledo', 'ind-1822-01-09', 'pub_goncalves_ledo', 'Promotor e orador da petição popular fluminense pelo Fico', 1),
('mp-fico-januario', 'ind-1822-01-09', 'pub_januario_barbosa', 'Articulador clerical e propagandista no Revérbero', 1),
('mp-min-bonifacio', 'ind-1822-01-16', 'pub_jose_bonifacio', 'Nomeado Ministro do Reino e Negócios Estrangeiros', 1),
('mp-min-pedro1', 'ind-1822-01-16', 'pub_pedro1', 'Nomeou o primeiro gabinete composto por brasileiros', 1),
('mp-lapa-joana', 'ind-1822-02-19', 'pub_joana_angelica', 'Abadessa assassinada na defesa das noviças do Convento da Lapa', 1),
('mp-cumpra-bonifacio', 'ind-1822-05-04', 'pub_jose_bonifacio', 'Idealizador do decreto de soberania institucional', 1),
('mp-cumpra-pedro1', 'ind-1822-05-04', 'pub_pedro1', 'Assinou o decreto barrando ordens unilaterais de Lisboa', 1),
('mp-defensor-pedro1', 'ind-1822-05-13', 'pub_pedro1', 'Aclamado Defensor Perpétuo do Brasil', 1),
('mp-defensor-ledo', 'ind-1822-05-13', 'pub_goncalves_ledo', 'Orador maçônico que outorgou o título solene', 1),
('mp-const-pedro1', 'ind-1822-06-03', 'pub_pedro1', 'Convocou a Assembleia Constituinte do Brasil', 1),
('mp-const-bonifacio', 'ind-1822-06-03', 'pub_jose_bonifacio', 'Referendou a convocação eleitoral das províncias', 1),
('mp-manif-ledo', 'ind-1822-08-01', 'pub_goncalves_ledo', 'Redator do Manifesto aos Povos do Brasil', 1),
('mp-manif-bonifacio', 'ind-1822-08-06', 'pub_jose_bonifacio', 'Redator do Manifesto às Nações Amigas comunicando a soberania', 1),
('mp-reg-leopoldina', 'ind-1822-08-14', 'pub_leopoldina', 'Princesa Regente do Brasil com poderes executivos plenos', 1),
('mp-reg-pedro1', 'ind-1822-08-14', 'pub_pedro1', 'Partiu em jornada a cavalo à Província de São Paulo', 1),
('mp-santos-pedro1', 'ind-1822-08-25', 'pub_pedro1', 'Conheceu a futura Marquesa de Santos em São Paulo', 1),
('mp-santos-domitila', 'ind-1822-08-25', 'pub_marquesa_santos', 'Iniciou relacionamento que marcou o Primeiro Reinado', 1),
('mp-guerra-quiteria', 'ind-1822-08-29', 'pub_maria_quiteria', 'Alistou-se disfarçada como Soldado Medeiros no Regimento de Artilharia', 1),
('mp-guerra-felipa', 'ind-1822-08-29', 'pub_maria_felipa', 'Comandou as marisqueiras na queima das naus lusitanas em Itaparica', 1),
('mp-conselho-leopoldina', 'ind-1822-09-02', 'pub_leopoldina', 'Presidiu o Conselho de Estado que decretou a separação de Portugal', 1),
('mp-conselho-bonifacio', 'ind-1822-09-02', 'pub_jose_bonifacio', 'Chanceler que subscreveu a ruptura e enviou correio a D. Pedro', 1),
('mp-ipiranga-pedro1', 'ind-1822-09-07', 'pub_pedro1', 'Bradou "Independência ou Morte!" às margens do riacho Ipiranga', 1),
('mp-hino-pedro1', 'ind-1822-09-21', 'pub_pedro1', 'Compositor da música e melodia oficial do Hino da Independência', 1),
('mp-aclam-pedro1', 'ind-1822-10-12', 'pub_pedro1', 'Aclamado Imperador Constitucional no Campo de Santana', 1),
('mp-aclam-leopoldina', 'ind-1822-10-12', 'pub_leopoldina', 'Primeira Imperatriz consorte do Brasil', 1),
('mp-maconaria-pedro1', 'ind-1822-10-25', 'pub_pedro1', 'Rompeu com a maçonaria e fechou as lojas do Grande Oriente', 1),
('mp-maconaria-bonifacio', 'ind-1822-10-25', 'pub_jose_bonifacio', 'Líder da facção Azul (monarquista/moderada) e Grão-Mestre', 1),
('mp-maconaria-ledo', 'ind-1822-10-25', 'pub_goncalves_ledo', 'Líder da facção Vermelha (liberal-republicana)', 1),
('mp-coroa-pedro1', 'ind-1822-12-01', 'pub_pedro1', 'Sagrado e coroado Imperador do Brasil na Capela Imperial', 1),
('mp-coroa-leopoldina', 'ind-1822-12-01', 'pub_leopoldina', 'Coroada Imperatriz do Brasil', 1),
('mp-const-antoniocarlos', 'ind-1823-05-03', 'pub_antonio_carlos', 'Líder da Constituinte e relator do anteprojeto constitucional', 1),
('mp-const-martim', 'ind-1823-05-03', 'pub_martim_francisco', 'Deputado constituinte e Ministro da Fazenda', 1),
('mp-agonia-pedro1', 'ind-1823-11-12', 'pub_pedro1', 'Cercou militarmente e dissolveu a Assembleia Constituinte', 1),
('mp-agonia-bonifacio', 'ind-1823-11-12', 'pub_jose_bonifacio', 'Preso e deportado para o exílio na França', 1),
('mp-agonia-antoniocarlos', 'ind-1823-11-12', 'pub_antonio_carlos', 'Preso e banido para o exílio com os irmãos', 1),
('mp-agonia-martim', 'ind-1823-11-12', 'pub_martim_francisco', 'Preso e banido para o exílio com os irmãos', 1),
('mp-vitoria-quiteria', 'ind-1823-07-02', 'pub_maria_quiteria', 'Marchou no desfile da vitória em Salvador e foi aclamada heroína', 1),
('mp-vitoria-felipa', 'ind-1823-07-02', 'pub_maria_felipa', 'Celebrou a libertação e consolidação territorial na Baía de Todos os Santos', 1),
('mp-confed-caneca', 'ind-1824-07-02', 'pub_frei_caneca', 'Líder intelectual e ideólogo republicano da Confederação do Equador', 1),
('mp-morte-caneca', 'ind-1825-01-13', 'pub_frei_caneca', 'Fuzilado no Recife por sua defesa da liberdade e do pacto federativo', 1);

-- Atributos
INSERT OR IGNORE INTO religioes_pessoa (id, pessoa_id, denominacao, periodo) VALUES
('rel_pedro1', 'pub_pedro1', 'Católico', '1798–1834'),
('rel_leopoldina', 'pub_leopoldina', 'Católica Apostólica Romana', '1797–1826'),
('rel_bonifacio', 'pub_jose_bonifacio', 'Católico', '1763–1838'),
('rel_antoniocarlos', 'pub_antonio_carlos', 'Católico', '1773–1845'),
('rel_martim', 'pub_martim_francisco', 'Católico', '1775–1844'),
('rel_ledo', 'pub_goncalves_ledo', 'Católico', '1781–1847'),
('rel_januario', 'pub_januario_barbosa', 'Católico — Clero Secular (Cônego)', '1780–1846'),
('rel_quiteria', 'pub_maria_quiteria', 'Católica', '1792–1853'),
('rel_caneca', 'pub_frei_caneca', 'Católico — Ordem Carmelita (Frade)', '1779–1825'),
('rel_joana', 'pub_joana_angelica', 'Católica — Ordem Concepcionista (Abadessa)', '1761–1822');

INSERT OR IGNORE INTO apelidos_pessoa (id, pessoa_id, apelido) VALUES
('ap_bonifacio_1', 'pub_jose_bonifacio', 'O Patriarca da Independência'),
('ap_ledo_1', 'pub_goncalves_ledo', 'Diderot (Codinome Maçônico)'),
('ap_quiteria_1', 'pub_maria_quiteria', 'Soldado Medeiros'),
('ap_quiteria_2', 'pub_maria_quiteria', 'A Joana d''Arc Brasileira'),
('ap_caneca_1', 'pub_frei_caneca', 'Caneca (do ofício paterno de tanoeiro)');

-- Limpeza prévia segura com IDs explícitos (sem wildcards ambíguos)
DELETE FROM arvore_membros WHERE arvore_id IN ('pub_arv_jesus_mateus', 'pub_arv_jesus_lucas') OR pessoa_id IN ('pub_mat_abraao', 'pub_mat_sara', 'pub_mat_isaac', 'pub_mat_rebeca', 'pub_mat_jaco_patriarca', 'pub_mat_lia', 'pub_mat_juda', 'pub_mat_tamar', 'pub_mat_perez', 'pub_mat_esrom', 'pub_mat_arao', 'pub_mat_aminadabe', 'pub_mat_naassom', 'pub_mat_salmom', 'pub_mat_raabe', 'pub_mat_boaz', 'pub_mat_rute', 'pub_mat_obede', 'pub_mat_jesse', 'pub_mat_davi', 'pub_mat_bateseba', 'pub_mat_salomao', 'pub_mat_naama', 'pub_mat_roboao', 'pub_mat_maaca', 'pub_mat_abias', 'pub_mat_asa', 'pub_mat_josafa', 'pub_mat_jorao', 'pub_mat_atalia', 'pub_mat_ozias', 'pub_mat_jotao', 'pub_mat_acaz', 'pub_mat_ezequias', 'pub_mat_hefziba', 'pub_mat_manasses', 'pub_mat_mesulemete', 'pub_mat_amom', 'pub_mat_jedida', 'pub_mat_josias', 'pub_mat_jeconias', 'pub_mat_salatiel', 'pub_mat_zorobabel', 'pub_mat_abiude', 'pub_mat_eliaquim', 'pub_mat_azor', 'pub_mat_sadoque', 'pub_mat_aquim', 'pub_mat_eliude', 'pub_mat_eleazar', 'pub_mat_mata', 'pub_mat_jaco_pai_jose', 'pub_mat_jose', 'pub_mat_maria', 'pub_jesus_mateus', 'pub_luc_abraao', 'pub_luc_isaac', 'pub_luc_jaco_patriarca', 'pub_luc_juda', 'pub_luc_perez', 'pub_luc_esrom', 'pub_luc_arao', 'pub_luc_aminadabe', 'pub_luc_naassom', 'pub_luc_salmom', 'pub_luc_boaz', 'pub_luc_obede', 'pub_luc_jesse', 'pub_luc_davi', 'pub_luc_nata', 'pub_luc_matata', 'pub_luc_mena', 'pub_luc_meleia', 'pub_luc_eliaquim', 'pub_luc_jona', 'pub_luc_jose_antigo', 'pub_luc_juda_filho_jose', 'pub_luc_simeao', 'pub_luc_levi_antigo', 'pub_luc_matat_antigo', 'pub_luc_jorim', 'pub_luc_eliezer', 'pub_luc_jesus_antigo', 'pub_luc_er', 'pub_luc_elmada', 'pub_luc_cosa', 'pub_luc_adi', 'pub_luc_melqui_antigo', 'pub_luc_neri', 'pub_luc_salatiel', 'pub_luc_zorobabel', 'pub_luc_resa', 'pub_luc_joana', 'pub_luc_joda', 'pub_luc_jose_pos_exilio', 'pub_luc_semei', 'pub_luc_matatias_antigo', 'pub_luc_maate', 'pub_luc_nagai', 'pub_luc_esli', 'pub_luc_naum', 'pub_luc_amos', 'pub_luc_matatias_recente', 'pub_luc_jose_recente', 'pub_luc_janai', 'pub_luc_melqui_recente', 'pub_luc_levi_recente', 'pub_luc_matat_recente', 'pub_luc_heli', 'pub_luc_jose', 'pub_luc_maria', 'pub_jesus_lucas', 'pub_luc_clopas', 'pub_luc_maria_clopas', 'pub_luc_tiago_menor', 'pub_luc_judas_tadeu', 'pub_luc_jose_irmao', 'pub_luc_simao_irmao', 'pub_luc_zebedeu', 'pub_luc_salome', 'pub_luc_tiago_maior', 'pub_luc_joao_evangelista', 'pub_luc_zacarias', 'pub_luc_isabel', 'pub_luc_joao_batista', 'pub_luc_jonas', 'pub_luc_pedro', 'pub_luc_andre', 'pub_jesus_mateus', 'pub_jesus_lucas') OR uniao_id IN ('pub_u_mat_abraao_sara', 'pub_u_mat_isaac_rebeca', 'pub_u_mat_jaco_lia', 'pub_u_mat_juda_tamar', 'pub_u_mat_perez', 'pub_u_mat_esrom', 'pub_u_mat_arao', 'pub_u_mat_aminadabe', 'pub_u_mat_naassom', 'pub_u_mat_salmom_raabe', 'pub_u_mat_boaz_rute', 'pub_u_mat_obede', 'pub_u_mat_jesse', 'pub_u_mat_davi_bateseba', 'pub_u_mat_salomao_naama', 'pub_u_mat_roboao_maaca', 'pub_u_mat_abias', 'pub_u_mat_asa', 'pub_u_mat_josafa', 'pub_u_mat_jorao_atalia', 'pub_u_mat_ozias', 'pub_u_mat_jotao', 'pub_u_mat_acaz', 'pub_u_mat_ezequias_hefziba', 'pub_u_mat_manasses_mesulemete', 'pub_u_mat_amom_jedida', 'pub_u_mat_josias', 'pub_u_mat_jeconias', 'pub_u_mat_salatiel', 'pub_u_mat_zorobabel', 'pub_u_mat_abiude', 'pub_u_mat_eliaquim', 'pub_u_mat_azor', 'pub_u_mat_sadoque', 'pub_u_mat_aquim', 'pub_u_mat_eliude', 'pub_u_mat_eleazar', 'pub_u_mat_mata', 'pub_u_mat_jaco', 'pub_u_mat_jose_maria', 'pub_u_luc_abraao', 'pub_u_luc_isaac', 'pub_u_luc_jaco', 'pub_u_luc_juda', 'pub_u_luc_perez', 'pub_u_luc_esrom', 'pub_u_luc_arao', 'pub_u_luc_aminadabe', 'pub_u_luc_naassom', 'pub_u_luc_salmom', 'pub_u_luc_boaz', 'pub_u_luc_obede', 'pub_u_luc_jesse', 'pub_u_luc_davi', 'pub_u_luc_nata', 'pub_u_luc_matata', 'pub_u_luc_mena', 'pub_u_luc_meleia', 'pub_u_luc_eliaquim', 'pub_u_luc_jona', 'pub_u_luc_jose_antigo', 'pub_u_luc_juda_filho_jose', 'pub_u_luc_simeao', 'pub_u_luc_levi_antigo', 'pub_u_luc_matat_antigo', 'pub_u_luc_jorim', 'pub_u_luc_eliezer', 'pub_u_luc_jesus_antigo', 'pub_u_luc_er', 'pub_u_luc_elmada', 'pub_u_luc_cosa', 'pub_u_luc_adi', 'pub_u_luc_melqui_antigo', 'pub_u_luc_neri', 'pub_u_luc_salatiel', 'pub_u_luc_zorobabel', 'pub_u_luc_resa', 'pub_u_luc_joana', 'pub_u_luc_joda', 'pub_u_luc_jose_pos_exilio', 'pub_u_luc_semei', 'pub_u_luc_matatias_antigo', 'pub_u_luc_maate', 'pub_u_luc_nagai', 'pub_u_luc_esli', 'pub_u_luc_naum', 'pub_u_luc_amos', 'pub_u_luc_matatias_recente', 'pub_u_luc_jose_recente', 'pub_u_luc_janai', 'pub_u_luc_melqui_recente', 'pub_u_luc_levi_recente', 'pub_u_luc_matat_recente', 'pub_u_luc_heli', 'pub_u_luc_jose_maria', 'pub_u_luc_clopas_maria', 'pub_u_luc_zebedeu_salome', 'pub_u_luc_zacarias_isabel', 'pub_u_luc_jonas');
DELETE FROM uniao_filhos WHERE uniao_id IN ('pub_u_mat_abraao_sara', 'pub_u_mat_isaac_rebeca', 'pub_u_mat_jaco_lia', 'pub_u_mat_juda_tamar', 'pub_u_mat_perez', 'pub_u_mat_esrom', 'pub_u_mat_arao', 'pub_u_mat_aminadabe', 'pub_u_mat_naassom', 'pub_u_mat_salmom_raabe', 'pub_u_mat_boaz_rute', 'pub_u_mat_obede', 'pub_u_mat_jesse', 'pub_u_mat_davi_bateseba', 'pub_u_mat_salomao_naama', 'pub_u_mat_roboao_maaca', 'pub_u_mat_abias', 'pub_u_mat_asa', 'pub_u_mat_josafa', 'pub_u_mat_jorao_atalia', 'pub_u_mat_ozias', 'pub_u_mat_jotao', 'pub_u_mat_acaz', 'pub_u_mat_ezequias_hefziba', 'pub_u_mat_manasses_mesulemete', 'pub_u_mat_amom_jedida', 'pub_u_mat_josias', 'pub_u_mat_jeconias', 'pub_u_mat_salatiel', 'pub_u_mat_zorobabel', 'pub_u_mat_abiude', 'pub_u_mat_eliaquim', 'pub_u_mat_azor', 'pub_u_mat_sadoque', 'pub_u_mat_aquim', 'pub_u_mat_eliude', 'pub_u_mat_eleazar', 'pub_u_mat_mata', 'pub_u_mat_jaco', 'pub_u_mat_jose_maria', 'pub_u_luc_abraao', 'pub_u_luc_isaac', 'pub_u_luc_jaco', 'pub_u_luc_juda', 'pub_u_luc_perez', 'pub_u_luc_esrom', 'pub_u_luc_arao', 'pub_u_luc_aminadabe', 'pub_u_luc_naassom', 'pub_u_luc_salmom', 'pub_u_luc_boaz', 'pub_u_luc_obede', 'pub_u_luc_jesse', 'pub_u_luc_davi', 'pub_u_luc_nata', 'pub_u_luc_matata', 'pub_u_luc_mena', 'pub_u_luc_meleia', 'pub_u_luc_eliaquim', 'pub_u_luc_jona', 'pub_u_luc_jose_antigo', 'pub_u_luc_juda_filho_jose', 'pub_u_luc_simeao', 'pub_u_luc_levi_antigo', 'pub_u_luc_matat_antigo', 'pub_u_luc_jorim', 'pub_u_luc_eliezer', 'pub_u_luc_jesus_antigo', 'pub_u_luc_er', 'pub_u_luc_elmada', 'pub_u_luc_cosa', 'pub_u_luc_adi', 'pub_u_luc_melqui_antigo', 'pub_u_luc_neri', 'pub_u_luc_salatiel', 'pub_u_luc_zorobabel', 'pub_u_luc_resa', 'pub_u_luc_joana', 'pub_u_luc_joda', 'pub_u_luc_jose_pos_exilio', 'pub_u_luc_semei', 'pub_u_luc_matatias_antigo', 'pub_u_luc_maate', 'pub_u_luc_nagai', 'pub_u_luc_esli', 'pub_u_luc_naum', 'pub_u_luc_amos', 'pub_u_luc_matatias_recente', 'pub_u_luc_jose_recente', 'pub_u_luc_janai', 'pub_u_luc_melqui_recente', 'pub_u_luc_levi_recente', 'pub_u_luc_matat_recente', 'pub_u_luc_heli', 'pub_u_luc_jose_maria', 'pub_u_luc_clopas_maria', 'pub_u_luc_zebedeu_salome', 'pub_u_luc_zacarias_isabel', 'pub_u_luc_jonas') OR pessoa_id IN ('pub_mat_abraao', 'pub_mat_sara', 'pub_mat_isaac', 'pub_mat_rebeca', 'pub_mat_jaco_patriarca', 'pub_mat_lia', 'pub_mat_juda', 'pub_mat_tamar', 'pub_mat_perez', 'pub_mat_esrom', 'pub_mat_arao', 'pub_mat_aminadabe', 'pub_mat_naassom', 'pub_mat_salmom', 'pub_mat_raabe', 'pub_mat_boaz', 'pub_mat_rute', 'pub_mat_obede', 'pub_mat_jesse', 'pub_mat_davi', 'pub_mat_bateseba', 'pub_mat_salomao', 'pub_mat_naama', 'pub_mat_roboao', 'pub_mat_maaca', 'pub_mat_abias', 'pub_mat_asa', 'pub_mat_josafa', 'pub_mat_jorao', 'pub_mat_atalia', 'pub_mat_ozias', 'pub_mat_jotao', 'pub_mat_acaz', 'pub_mat_ezequias', 'pub_mat_hefziba', 'pub_mat_manasses', 'pub_mat_mesulemete', 'pub_mat_amom', 'pub_mat_jedida', 'pub_mat_josias', 'pub_mat_jeconias', 'pub_mat_salatiel', 'pub_mat_zorobabel', 'pub_mat_abiude', 'pub_mat_eliaquim', 'pub_mat_azor', 'pub_mat_sadoque', 'pub_mat_aquim', 'pub_mat_eliude', 'pub_mat_eleazar', 'pub_mat_mata', 'pub_mat_jaco_pai_jose', 'pub_mat_jose', 'pub_mat_maria', 'pub_jesus_mateus', 'pub_luc_abraao', 'pub_luc_isaac', 'pub_luc_jaco_patriarca', 'pub_luc_juda', 'pub_luc_perez', 'pub_luc_esrom', 'pub_luc_arao', 'pub_luc_aminadabe', 'pub_luc_naassom', 'pub_luc_salmom', 'pub_luc_boaz', 'pub_luc_obede', 'pub_luc_jesse', 'pub_luc_davi', 'pub_luc_nata', 'pub_luc_matata', 'pub_luc_mena', 'pub_luc_meleia', 'pub_luc_eliaquim', 'pub_luc_jona', 'pub_luc_jose_antigo', 'pub_luc_juda_filho_jose', 'pub_luc_simeao', 'pub_luc_levi_antigo', 'pub_luc_matat_antigo', 'pub_luc_jorim', 'pub_luc_eliezer', 'pub_luc_jesus_antigo', 'pub_luc_er', 'pub_luc_elmada', 'pub_luc_cosa', 'pub_luc_adi', 'pub_luc_melqui_antigo', 'pub_luc_neri', 'pub_luc_salatiel', 'pub_luc_zorobabel', 'pub_luc_resa', 'pub_luc_joana', 'pub_luc_joda', 'pub_luc_jose_pos_exilio', 'pub_luc_semei', 'pub_luc_matatias_antigo', 'pub_luc_maate', 'pub_luc_nagai', 'pub_luc_esli', 'pub_luc_naum', 'pub_luc_amos', 'pub_luc_matatias_recente', 'pub_luc_jose_recente', 'pub_luc_janai', 'pub_luc_melqui_recente', 'pub_luc_levi_recente', 'pub_luc_matat_recente', 'pub_luc_heli', 'pub_luc_jose', 'pub_luc_maria', 'pub_jesus_lucas', 'pub_luc_clopas', 'pub_luc_maria_clopas', 'pub_luc_tiago_menor', 'pub_luc_judas_tadeu', 'pub_luc_jose_irmao', 'pub_luc_simao_irmao', 'pub_luc_zebedeu', 'pub_luc_salome', 'pub_luc_tiago_maior', 'pub_luc_joao_evangelista', 'pub_luc_zacarias', 'pub_luc_isabel', 'pub_luc_joao_batista', 'pub_luc_jonas', 'pub_luc_pedro', 'pub_luc_andre', 'pub_jesus_mateus', 'pub_jesus_lucas');
DELETE FROM unioes WHERE id IN ('pub_u_mat_abraao_sara', 'pub_u_mat_isaac_rebeca', 'pub_u_mat_jaco_lia', 'pub_u_mat_juda_tamar', 'pub_u_mat_perez', 'pub_u_mat_esrom', 'pub_u_mat_arao', 'pub_u_mat_aminadabe', 'pub_u_mat_naassom', 'pub_u_mat_salmom_raabe', 'pub_u_mat_boaz_rute', 'pub_u_mat_obede', 'pub_u_mat_jesse', 'pub_u_mat_davi_bateseba', 'pub_u_mat_salomao_naama', 'pub_u_mat_roboao_maaca', 'pub_u_mat_abias', 'pub_u_mat_asa', 'pub_u_mat_josafa', 'pub_u_mat_jorao_atalia', 'pub_u_mat_ozias', 'pub_u_mat_jotao', 'pub_u_mat_acaz', 'pub_u_mat_ezequias_hefziba', 'pub_u_mat_manasses_mesulemete', 'pub_u_mat_amom_jedida', 'pub_u_mat_josias', 'pub_u_mat_jeconias', 'pub_u_mat_salatiel', 'pub_u_mat_zorobabel', 'pub_u_mat_abiude', 'pub_u_mat_eliaquim', 'pub_u_mat_azor', 'pub_u_mat_sadoque', 'pub_u_mat_aquim', 'pub_u_mat_eliude', 'pub_u_mat_eleazar', 'pub_u_mat_mata', 'pub_u_mat_jaco', 'pub_u_mat_jose_maria', 'pub_u_luc_abraao', 'pub_u_luc_isaac', 'pub_u_luc_jaco', 'pub_u_luc_juda', 'pub_u_luc_perez', 'pub_u_luc_esrom', 'pub_u_luc_arao', 'pub_u_luc_aminadabe', 'pub_u_luc_naassom', 'pub_u_luc_salmom', 'pub_u_luc_boaz', 'pub_u_luc_obede', 'pub_u_luc_jesse', 'pub_u_luc_davi', 'pub_u_luc_nata', 'pub_u_luc_matata', 'pub_u_luc_mena', 'pub_u_luc_meleia', 'pub_u_luc_eliaquim', 'pub_u_luc_jona', 'pub_u_luc_jose_antigo', 'pub_u_luc_juda_filho_jose', 'pub_u_luc_simeao', 'pub_u_luc_levi_antigo', 'pub_u_luc_matat_antigo', 'pub_u_luc_jorim', 'pub_u_luc_eliezer', 'pub_u_luc_jesus_antigo', 'pub_u_luc_er', 'pub_u_luc_elmada', 'pub_u_luc_cosa', 'pub_u_luc_adi', 'pub_u_luc_melqui_antigo', 'pub_u_luc_neri', 'pub_u_luc_salatiel', 'pub_u_luc_zorobabel', 'pub_u_luc_resa', 'pub_u_luc_joana', 'pub_u_luc_joda', 'pub_u_luc_jose_pos_exilio', 'pub_u_luc_semei', 'pub_u_luc_matatias_antigo', 'pub_u_luc_maate', 'pub_u_luc_nagai', 'pub_u_luc_esli', 'pub_u_luc_naum', 'pub_u_luc_amos', 'pub_u_luc_matatias_recente', 'pub_u_luc_jose_recente', 'pub_u_luc_janai', 'pub_u_luc_melqui_recente', 'pub_u_luc_levi_recente', 'pub_u_luc_matat_recente', 'pub_u_luc_heli', 'pub_u_luc_jose_maria', 'pub_u_luc_clopas_maria', 'pub_u_luc_zebedeu_salome', 'pub_u_luc_zacarias_isabel', 'pub_u_luc_jonas');
DELETE FROM eventos WHERE pessoa_id IN ('pub_mat_abraao', 'pub_mat_sara', 'pub_mat_isaac', 'pub_mat_rebeca', 'pub_mat_jaco_patriarca', 'pub_mat_lia', 'pub_mat_juda', 'pub_mat_tamar', 'pub_mat_perez', 'pub_mat_esrom', 'pub_mat_arao', 'pub_mat_aminadabe', 'pub_mat_naassom', 'pub_mat_salmom', 'pub_mat_raabe', 'pub_mat_boaz', 'pub_mat_rute', 'pub_mat_obede', 'pub_mat_jesse', 'pub_mat_davi', 'pub_mat_bateseba', 'pub_mat_salomao', 'pub_mat_naama', 'pub_mat_roboao', 'pub_mat_maaca', 'pub_mat_abias', 'pub_mat_asa', 'pub_mat_josafa', 'pub_mat_jorao', 'pub_mat_atalia', 'pub_mat_ozias', 'pub_mat_jotao', 'pub_mat_acaz', 'pub_mat_ezequias', 'pub_mat_hefziba', 'pub_mat_manasses', 'pub_mat_mesulemete', 'pub_mat_amom', 'pub_mat_jedida', 'pub_mat_josias', 'pub_mat_jeconias', 'pub_mat_salatiel', 'pub_mat_zorobabel', 'pub_mat_abiude', 'pub_mat_eliaquim', 'pub_mat_azor', 'pub_mat_sadoque', 'pub_mat_aquim', 'pub_mat_eliude', 'pub_mat_eleazar', 'pub_mat_mata', 'pub_mat_jaco_pai_jose', 'pub_mat_jose', 'pub_mat_maria', 'pub_jesus_mateus', 'pub_luc_abraao', 'pub_luc_isaac', 'pub_luc_jaco_patriarca', 'pub_luc_juda', 'pub_luc_perez', 'pub_luc_esrom', 'pub_luc_arao', 'pub_luc_aminadabe', 'pub_luc_naassom', 'pub_luc_salmom', 'pub_luc_boaz', 'pub_luc_obede', 'pub_luc_jesse', 'pub_luc_davi', 'pub_luc_nata', 'pub_luc_matata', 'pub_luc_mena', 'pub_luc_meleia', 'pub_luc_eliaquim', 'pub_luc_jona', 'pub_luc_jose_antigo', 'pub_luc_juda_filho_jose', 'pub_luc_simeao', 'pub_luc_levi_antigo', 'pub_luc_matat_antigo', 'pub_luc_jorim', 'pub_luc_eliezer', 'pub_luc_jesus_antigo', 'pub_luc_er', 'pub_luc_elmada', 'pub_luc_cosa', 'pub_luc_adi', 'pub_luc_melqui_antigo', 'pub_luc_neri', 'pub_luc_salatiel', 'pub_luc_zorobabel', 'pub_luc_resa', 'pub_luc_joana', 'pub_luc_joda', 'pub_luc_jose_pos_exilio', 'pub_luc_semei', 'pub_luc_matatias_antigo', 'pub_luc_maate', 'pub_luc_nagai', 'pub_luc_esli', 'pub_luc_naum', 'pub_luc_amos', 'pub_luc_matatias_recente', 'pub_luc_jose_recente', 'pub_luc_janai', 'pub_luc_melqui_recente', 'pub_luc_levi_recente', 'pub_luc_matat_recente', 'pub_luc_heli', 'pub_luc_jose', 'pub_luc_maria', 'pub_jesus_lucas', 'pub_luc_clopas', 'pub_luc_maria_clopas', 'pub_luc_tiago_menor', 'pub_luc_judas_tadeu', 'pub_luc_jose_irmao', 'pub_luc_simao_irmao', 'pub_luc_zebedeu', 'pub_luc_salome', 'pub_luc_tiago_maior', 'pub_luc_joao_evangelista', 'pub_luc_zacarias', 'pub_luc_isabel', 'pub_luc_joao_batista', 'pub_luc_jonas', 'pub_luc_pedro', 'pub_luc_andre', 'pub_jesus_mateus', 'pub_jesus_lucas');
DELETE FROM arvores WHERE id IN ('pub_arv_jesus_mateus', 'pub_arv_jesus_lucas');
DELETE FROM pessoas WHERE id IN ('pub_mat_abraao', 'pub_mat_sara', 'pub_mat_isaac', 'pub_mat_rebeca', 'pub_mat_jaco_patriarca', 'pub_mat_lia', 'pub_mat_juda', 'pub_mat_tamar', 'pub_mat_perez', 'pub_mat_esrom', 'pub_mat_arao', 'pub_mat_aminadabe', 'pub_mat_naassom', 'pub_mat_salmom', 'pub_mat_raabe', 'pub_mat_boaz', 'pub_mat_rute', 'pub_mat_obede', 'pub_mat_jesse', 'pub_mat_davi', 'pub_mat_bateseba', 'pub_mat_salomao', 'pub_mat_naama', 'pub_mat_roboao', 'pub_mat_maaca', 'pub_mat_abias', 'pub_mat_asa', 'pub_mat_josafa', 'pub_mat_jorao', 'pub_mat_atalia', 'pub_mat_ozias', 'pub_mat_jotao', 'pub_mat_acaz', 'pub_mat_ezequias', 'pub_mat_hefziba', 'pub_mat_manasses', 'pub_mat_mesulemete', 'pub_mat_amom', 'pub_mat_jedida', 'pub_mat_josias', 'pub_mat_jeconias', 'pub_mat_salatiel', 'pub_mat_zorobabel', 'pub_mat_abiude', 'pub_mat_eliaquim', 'pub_mat_azor', 'pub_mat_sadoque', 'pub_mat_aquim', 'pub_mat_eliude', 'pub_mat_eleazar', 'pub_mat_mata', 'pub_mat_jaco_pai_jose', 'pub_mat_jose', 'pub_mat_maria', 'pub_jesus_mateus', 'pub_luc_abraao', 'pub_luc_isaac', 'pub_luc_jaco_patriarca', 'pub_luc_juda', 'pub_luc_perez', 'pub_luc_esrom', 'pub_luc_arao', 'pub_luc_aminadabe', 'pub_luc_naassom', 'pub_luc_salmom', 'pub_luc_boaz', 'pub_luc_obede', 'pub_luc_jesse', 'pub_luc_davi', 'pub_luc_nata', 'pub_luc_matata', 'pub_luc_mena', 'pub_luc_meleia', 'pub_luc_eliaquim', 'pub_luc_jona', 'pub_luc_jose_antigo', 'pub_luc_juda_filho_jose', 'pub_luc_simeao', 'pub_luc_levi_antigo', 'pub_luc_matat_antigo', 'pub_luc_jorim', 'pub_luc_eliezer', 'pub_luc_jesus_antigo', 'pub_luc_er', 'pub_luc_elmada', 'pub_luc_cosa', 'pub_luc_adi', 'pub_luc_melqui_antigo', 'pub_luc_neri', 'pub_luc_salatiel', 'pub_luc_zorobabel', 'pub_luc_resa', 'pub_luc_joana', 'pub_luc_joda', 'pub_luc_jose_pos_exilio', 'pub_luc_semei', 'pub_luc_matatias_antigo', 'pub_luc_maate', 'pub_luc_nagai', 'pub_luc_esli', 'pub_luc_naum', 'pub_luc_amos', 'pub_luc_matatias_recente', 'pub_luc_jose_recente', 'pub_luc_janai', 'pub_luc_melqui_recente', 'pub_luc_levi_recente', 'pub_luc_matat_recente', 'pub_luc_heli', 'pub_luc_jose', 'pub_luc_maria', 'pub_jesus_lucas', 'pub_luc_clopas', 'pub_luc_maria_clopas', 'pub_luc_tiago_menor', 'pub_luc_judas_tadeu', 'pub_luc_jose_irmao', 'pub_luc_simao_irmao', 'pub_luc_zebedeu', 'pub_luc_salome', 'pub_luc_tiago_maior', 'pub_luc_joao_evangelista', 'pub_luc_zacarias', 'pub_luc_isabel', 'pub_luc_joao_batista', 'pub_luc_jonas', 'pub_luc_pedro', 'pub_luc_andre', 'pub_jesus_mateus', 'pub_jesus_lucas') OR id LIKE 'pub_ph_pub_u_mat_%' OR id LIKE 'pub_ph_pub_u_luc_%';

-- =====================================================================
-- ÁRVORE: Genealogia de Jesus (Segundo Mateus — Linhagem Régia)
-- =====================================================================
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_abraao', 'Abraão', 'ben Terah', 'M', 'Patriarca bíblico do monoteísmo e depositário da promessa messiânica (Mt 1:2).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_abraao', 'pub_mat_abraao', 'nascimento', -1813, -1813, 'cerca_de', 'cerca de 1813 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_abraao', 'pub_mat_abraao', 'falecimento', -1638, -1638, 'cerca_de', 'cerca de 1638 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_sara', 'Sara', NULL, 'F', 'Matriarca bíblica, esposa de Abraão e mãe de Isaac.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_sara', 'pub_mat_sara', 'nascimento', -1803, -1803, 'cerca_de', 'cerca de 1803 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_sara', 'pub_mat_sara', 'falecimento', -1676, -1676, 'cerca_de', 'cerca de 1676 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_isaac', 'Isaac', 'ben Avraham', 'M', 'Segundo patriarca bíblico, filho da promessa de Abraão e Sara (Mt 1:2).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_isaac', 'pub_mat_isaac', 'nascimento', -1713, -1713, 'cerca_de', 'cerca de 1713 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_isaac', 'pub_mat_isaac', 'falecimento', -1533, -1533, 'cerca_de', 'cerca de 1533 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_rebeca', 'Rebeca', NULL, 'F', 'Matriarca bíblica, esposa de Isaac e mãe de Jacó.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_rebeca', 'pub_mat_rebeca', 'nascimento', -1690, -1690, 'cerca_de', 'cerca de 1690 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_rebeca', 'pub_mat_rebeca', 'falecimento', -1550, -1550, 'cerca_de', 'cerca de 1550 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jaco_patriarca', 'Jacó', '(Israel)', 'M', 'Terceiro patriarca de Israel, pai das doze tribos (Mt 1:2). Não confundir com Jacó ben Matã.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jaco_patriarca', 'pub_mat_jaco_patriarca', 'nascimento', -1653, -1653, 'cerca_de', 'cerca de 1653 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jaco_patriarca', 'pub_mat_jaco_patriarca', 'falecimento', -1506, -1506, 'cerca_de', 'cerca de 1506 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_lia', 'Lia', NULL, 'F', 'Primeira esposa de Jacó e mãe de Judá.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_lia', 'pub_mat_lia', 'nascimento', -1640, -1640, 'cerca_de', 'cerca de 1640 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_lia', 'pub_mat_lia', 'falecimento', -1510, -1510, 'cerca_de', 'cerca de 1510 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_juda', 'Judá', 'ben Yaakov', 'M', 'Quarto filho de Jacó; líder tribal de onde provém a dinastia real davídica (Mt 1:2-3).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_juda', 'pub_mat_juda', 'nascimento', -1566, -1566, 'cerca_de', 'cerca de 1566 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_juda', 'pub_mat_juda', 'falecimento', -1437, -1437, 'cerca_de', 'cerca de 1437 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_tamar', 'Tamar', NULL, 'F', 'Primeira das quatro mulheres citadas por Mateus na genealogia messiânica (Mt 1:3; Gn 38).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_tamar', 'pub_mat_tamar', 'nascimento', -1530, -1530, 'cerca_de', 'cerca de 1530 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_tamar', 'pub_mat_tamar', 'falecimento', -1450, -1450, 'cerca_de', 'cerca de 1450 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_perez', 'Perez', '(Farés)', 'M', 'Filho de Judá e Tamar; ancestral dos clãs principais da tribo de Judá (Mt 1:3).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_perez', 'pub_mat_perez', 'nascimento', -1500, -1500, 'cerca_de', 'cerca de 1500 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_perez', 'pub_mat_perez', 'falecimento', -1420, -1420, 'cerca_de', 'cerca de 1420 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_esrom', 'Esrom', '(Hezrom)', 'M', 'Neto de Judá; líder de clã durante a permanência dos hebreus no Egito (Mt 1:3).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_esrom', 'pub_mat_esrom', 'nascimento', -1450, -1450, 'cerca_de', 'cerca de 1450 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_esrom', 'pub_mat_esrom', 'falecimento', -1380, -1380, 'cerca_de', 'cerca de 1380 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_arao', 'Arão', '(Ram)', 'M', 'Descendente de Perez no Egito (Mt 1:3-4). Não confundir com o sacerdote Aarão irmão de Moisés.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_arao', 'pub_mat_arao', 'nascimento', -1400, -1400, 'cerca_de', 'cerca de 1400 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_arao', 'pub_mat_arao', 'falecimento', -1330, -1330, 'cerca_de', 'cerca de 1330 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_aminadabe', 'Aminadabe', 'ben Ram', 'M', 'Líder da tribo de Judá no período do Êxodo; sogro do sumo sacerdote Aarão (Mt 1:4).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_aminadabe', 'pub_mat_aminadabe', 'nascimento', -1350, -1350, 'cerca_de', 'cerca de 1350 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_aminadabe', 'pub_mat_aminadabe', 'falecimento', -1280, -1280, 'cerca_de', 'cerca de 1280 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_naassom', 'Naassom', 'ben Amminadav', 'M', 'Príncipe e comandante da tribo de Judá durante a travessia do deserto com Moisés (Mt 1:4).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_naassom', 'pub_mat_naassom', 'nascimento', -1300, -1300, 'cerca_de', 'cerca de 1300 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_naassom', 'pub_mat_naassom', 'falecimento', -1240, -1240, 'cerca_de', 'cerca de 1240 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_salmom', 'Salmom', '(Salma)', 'M', 'Líder tribal na conquista de Canaã; desposou Raabe de Jericó (Mt 1:4-5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_salmom', 'pub_mat_salmom', 'nascimento', -1250, -1250, 'cerca_de', 'cerca de 1250 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_salmom', 'pub_mat_salmom', 'falecimento', -1190, -1190, 'cerca_de', 'cerca de 1190 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_raabe', 'Raabe', 'de Jericó', 'F', 'Mulher cananeia acolhida em Israel; segunda mulher citada na genealogia de Mateus (Mt 1:5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_raabe', 'pub_mat_raabe', 'nascimento', -1240, -1240, 'cerca_de', 'cerca de 1240 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_raabe', 'pub_mat_raabe', 'falecimento', -1180, -1180, 'cerca_de', 'cerca de 1180 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_boaz', 'Boaz', 'ben Salmon', 'M', 'Proprietário de terras em Belém; protagonista do Livro de Rute e resgatador da linhagem (Mt 1:5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_boaz', 'pub_mat_boaz', 'nascimento', -1180, -1180, 'cerca_de', 'cerca de 1180 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_boaz', 'pub_mat_boaz', 'falecimento', -1110, -1110, 'cerca_de', 'cerca de 1110 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_rute', 'Rute', 'a Moabita', 'F', 'Mulher estrangeira de Moabe, bisavó do Rei Davi; terceira mulher citada em Mateus 1:5.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_rute', 'pub_mat_rute', 'nascimento', -1160, -1160, 'cerca_de', 'cerca de 1160 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_rute', 'pub_mat_rute', 'falecimento', -1100, -1100, 'cerca_de', 'cerca de 1100 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_obede', 'Obede', 'ben Boaz', 'M', 'Filho de Boaz e Rute; avô do Rei Davi em Belém de Judá (Mt 1:5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_obede', 'pub_mat_obede', 'nascimento', -1130, -1130, 'cerca_de', 'cerca de 1130 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_obede', 'pub_mat_obede', 'falecimento', -1060, -1060, 'cerca_de', 'cerca de 1060 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jesse', 'Jessé', 'ben Oved', 'M', 'Ancião de Belém; pai do Rei Davi; raiz da profética ''Árvore de Jessé'' (Is 11:1; Mt 1:5-6).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jesse', 'pub_mat_jesse', 'nascimento', -1090, -1090, 'cerca_de', 'cerca de 1090 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jesse', 'pub_mat_jesse', 'falecimento', -1020, -1020, 'cerca_de', 'cerca de 1020 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_davi', 'Rei David', 'de Israel', 'M', 'Segundo rei de Israel e Judá; unificador das tribos; ponto de bifurcação (Mt 1:6).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_davi', 'pub_mat_davi', 'nascimento', -1040, -1040, 'cerca_de', 'cerca de 1040 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_davi', 'pub_mat_davi', 'falecimento', -970, -970, 'cerca_de', 'cerca de 970 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_bateseba', 'Bate-Seba', '(mulher de Urias)', 'F', 'Esposa de Davi e mãe de Salomão; quarta mulher citada na genealogia de Mateus 1:6.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_bateseba', 'pub_mat_bateseba', 'nascimento', -1020, -1020, 'cerca_de', 'cerca de 1020 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_bateseba', 'pub_mat_bateseba', 'falecimento', -960, -960, 'cerca_de', 'cerca de 960 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_salomao', 'Salomão', 'o Sábio', 'M', 'Rei de Israel, construtor do Primeiro Templo; cabeça da linhagem régia de Mateus (Mt 1:6).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_salomao', 'pub_mat_salomao', 'nascimento', -990, -990, 'cerca_de', 'cerca de 990 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_salomao', 'pub_mat_salomao', 'falecimento', -931, -931, 'cerca_de', 'cerca de 931 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_naama', 'Naama', 'a Amonita', 'F', 'Esposa amonita de Salomão e mãe do rei Roboão.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_naama', 'pub_mat_naama', 'nascimento', -980, -980, 'cerca_de', 'cerca de 980 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_naama', 'pub_mat_naama', 'falecimento', -925, -925, 'cerca_de', 'cerca de 925 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_roboao', 'Roboão', 'ben Shlomo', 'M', 'Primeiro rei de Judá após o cisma das dez tribos do norte (Mt 1:7).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_roboao', 'pub_mat_roboao', 'nascimento', -971, -971, 'cerca_de', 'cerca de 971 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_roboao', 'pub_mat_roboao', 'falecimento', -913, -913, 'cerca_de', 'cerca de 913 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_maaca', 'Maaca', NULL, 'F', 'Esposa de Roboão e mãe do rei Abias.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_maaca', 'pub_mat_maaca', 'nascimento', -950, -950, 'cerca_de', 'cerca de 950 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_maaca', 'pub_mat_maaca', 'falecimento', -900, -900, 'cerca_de', 'cerca de 900 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_abias', 'Abias', '(Abião)', 'M', 'Rei de Judá, filho de Roboão (Mt 1:7).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_abias', 'pub_mat_abias', 'nascimento', -935, -935, 'cerca_de', 'cerca de 935 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_abias', 'pub_mat_abias', 'falecimento', -911, -911, 'cerca_de', 'cerca de 911 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_asa', 'Asa', 'ben Aviyam', 'M', 'Rei reformador de Judá que reinou por mais de 40 anos (Mt 1:7-8).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_asa', 'pub_mat_asa', 'nascimento', -930, -930, 'cerca_de', 'cerca de 930 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_asa', 'pub_mat_asa', 'falecimento', -870, -870, 'cerca_de', 'cerca de 870 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_josafa', 'Josafá', 'ben Asa', 'M', 'Rei piedoso de Judá que promoveu a justiça e a instrução da Lei (Mt 1:8).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_josafa', 'pub_mat_josafa', 'nascimento', -905, -905, 'cerca_de', 'cerca de 905 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_josafa', 'pub_mat_josafa', 'falecimento', -848, -848, 'cerca_de', 'cerca de 848 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jorao', 'Jorão', 'ben Yehoshafat', 'M', 'Rei de Judá, casado com Atalia de Israel (Mt 1:8).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jorao', 'pub_mat_jorao', 'nascimento', -880, -880, 'cerca_de', 'cerca de 880 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jorao', 'pub_mat_jorao', 'falecimento', -841, -841, 'cerca_de', 'cerca de 841 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_atalia', 'Atalia', 'de Israel', 'F', 'Filha de Acabe e Jezabel de Israel; rainha consorte e usurpadora do trono de Judá.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_atalia', 'pub_mat_atalia', 'nascimento', -875, -875, 'cerca_de', 'cerca de 875 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_atalia', 'pub_mat_atalia', 'falecimento', -835, -835, 'cerca_de', 'cerca de 835 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_ozias', 'Ozias', '(Azarias)', 'M', 'Rei de Judá. Mateus omitiu Acazias, Joás e Amazias para manter a métrica de 14 gerações (Mt 1:8-9).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_ozias', 'pub_mat_ozias', 'nascimento', -808, -808, 'cerca_de', 'cerca de 808 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_ozias', 'pub_mat_ozias', 'falecimento', -758, -758, 'cerca_de', 'cerca de 758 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jotao', 'Jotão', 'ben Uzziyahu', 'M', 'Rei de Judá que reconstruiu a porta superior do Templo de Jerusalém (Mt 1:9).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jotao', 'pub_mat_jotao', 'nascimento', -770, -770, 'cerca_de', 'cerca de 770 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jotao', 'pub_mat_jotao', 'falecimento', -735, -735, 'cerca_de', 'cerca de 735 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_acaz', 'Acaz', 'ben Yotam', 'M', 'Rei de Judá vassalo da Assíria; destinatário da profecia do Emanuel (Is 7:14; Mt 1:9).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_acaz', 'pub_mat_acaz', 'nascimento', -753, -753, 'cerca_de', 'cerca de 753 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_acaz', 'pub_mat_acaz', 'falecimento', -715, -715, 'cerca_de', 'cerca de 715 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_ezequias', 'Ezequias', 'ben Ahaz', 'M', 'Grande rei reformador de Judá que resistiu ao cerco assírio de Senaqueribe (Mt 1:9-10).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_ezequias', 'pub_mat_ezequias', 'nascimento', -739, -739, 'cerca_de', 'cerca de 739 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_ezequias', 'pub_mat_ezequias', 'falecimento', -687, -687, 'cerca_de', 'cerca de 687 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_hefziba', 'Hefzibá', NULL, 'F', 'Esposa do rei Ezequias e mãe de Manassés.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_hefziba', 'pub_mat_hefziba', 'nascimento', -725, -725, 'cerca_de', 'cerca de 725 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_hefziba', 'pub_mat_hefziba', 'falecimento', -670, -670, 'cerca_de', 'cerca de 670 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_manasses', 'Manassés', 'ben Hizkiyahu', 'M', 'Rei de Judá de reinado mais longo (55 anos); introduziu cultos pagãos (Mt 1:10).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_manasses', 'pub_mat_manasses', 'nascimento', -709, -709, 'cerca_de', 'cerca de 709 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_manasses', 'pub_mat_manasses', 'falecimento', -643, -643, 'cerca_de', 'cerca de 643 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_mesulemete', 'Mesulemete', NULL, 'F', 'Esposa do rei Manassés e mãe de Amom.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_mesulemete', 'pub_mat_mesulemete', 'nascimento', -680, -680, 'cerca_de', 'cerca de 680 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_mesulemete', 'pub_mat_mesulemete', 'falecimento', -630, -630, 'cerca_de', 'cerca de 630 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_amom', 'Amom', 'ben Menasheh', 'M', 'Rei idólatra de Judá assassinado após dois anos de governo (Mt 1:10).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_amom', 'pub_mat_amom', 'nascimento', -664, -664, 'cerca_de', 'cerca de 664 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_amom', 'pub_mat_amom', 'falecimento', -641, -641, 'cerca_de', 'cerca de 641 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jedida', 'Jedida', NULL, 'F', 'Esposa do rei Amom e mãe de Josias.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jedida', 'pub_mat_jedida', 'nascimento', -660, -660, 'cerca_de', 'cerca de 660 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jedida', 'pub_mat_jedida', 'falecimento', -615, -615, 'cerca_de', 'cerca de 615 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_josias', 'Josias', 'ben Amon', 'M', 'Rei justo de Judá que liderou a grande Reforma Deuteronômica (Mt 1:10-11).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_josias', 'pub_mat_josias', 'nascimento', -648, -648, 'cerca_de', 'cerca de 648 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_josias', 'pub_mat_josias', 'falecimento', -609, -609, 'cerca_de', 'cerca de 609 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jeconias', 'Jeconias', '(Jocanias)', 'M', 'Rei de Judá deposto e deportado para a Babilônia em 597 a.C. (Mt 1:11-12; omissão de Joaquim).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jeconias', 'pub_mat_jeconias', 'nascimento', -616, -616, 'cerca_de', 'cerca de 616 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jeconias', 'pub_mat_jeconias', 'falecimento', -561, -561, 'cerca_de', 'cerca de 561 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_salatiel', 'Salatiel', '(Sealtiel)', 'M', 'Príncipe de Judá no Cativeiro Babilônico; filho de Jeconias em Mateus 1:12 (ponto de reencontro).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_salatiel', 'pub_mat_salatiel', 'nascimento', -580, -580, 'cerca_de', 'cerca de 580 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_salatiel', 'pub_mat_salatiel', 'falecimento', -520, -520, 'cerca_de', 'cerca de 520 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_zorobabel', 'Zorobabel', 'ben Shealtiel', 'M', 'Governador de Judá que liderou o retorno e a reconstrução do Templo (Mt 1:12-13).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_zorobabel', 'pub_mat_zorobabel', 'nascimento', -550, -550, 'cerca_de', 'cerca de 550 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_zorobabel', 'pub_mat_zorobabel', 'falecimento', -490, -490, 'cerca_de', 'cerca de 490 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_abiude', 'Abiúde', 'ben Zerubavel', 'M', 'Filho de Zorobabel em Mateus; ponto da nova separação com Lucas (Mt 1:13).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_abiude', 'pub_mat_abiude', 'nascimento', -510, -510, 'cerca_de', 'cerca de 510 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_abiude', 'pub_mat_abiude', 'falecimento', -450, -450, 'cerca_de', 'cerca de 450 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_eliaquim', 'Eliaquim', 'ben Avihud', 'M', 'Descendente davídico na linhagem pós-exílica de Mateus 1:13.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_eliaquim', 'pub_mat_eliaquim', 'nascimento', -470, -470, 'cerca_de', 'cerca de 470 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_eliaquim', 'pub_mat_eliaquim', 'falecimento', -410, -410, 'cerca_de', 'cerca de 410 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_azor', 'Azor', 'ben Elyakim', 'M', 'Elo genealógico de Judá na linha de Mateus 1:13-14.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_azor', 'pub_mat_azor', 'nascimento', -430, -430, 'cerca_de', 'cerca de 430 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_azor', 'pub_mat_azor', 'falecimento', -370, -370, 'cerca_de', 'cerca de 370 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_sadoque', 'Sadoque', 'ben Azur', 'M', 'Antepassado de José na Judeia persa/ptolomaica (Mt 1:14). Não é o sumo sacerdote Sadoque.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_sadoque', 'pub_mat_sadoque', 'nascimento', -390, -390, 'cerca_de', 'cerca de 390 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_sadoque', 'pub_mat_sadoque', 'falecimento', -330, -330, 'cerca_de', 'cerca de 330 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_aquim', 'Aquim', 'ben Tzadok', 'M', 'Descendente davídico da era ptolomaica em Mateus 1:14.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_aquim', 'pub_mat_aquim', 'nascimento', -350, -350, 'cerca_de', 'cerca de 350 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_aquim', 'pub_mat_aquim', 'falecimento', -290, -290, 'cerca_de', 'cerca de 290 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_eliude', 'Eliúde', 'ben Yakhin', 'M', 'Antepassado messiânico no período pré-macabeu (Mt 1:14-15).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_eliude', 'pub_mat_eliude', 'nascimento', -310, -310, 'cerca_de', 'cerca de 310 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_eliude', 'pub_mat_eliude', 'falecimento', -250, -250, 'cerca_de', 'cerca de 250 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_eleazar', 'Eleazar', 'ben Elihud', 'M', 'Bisavô de José de Nazaré segundo Mateus 1:15.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_eleazar', 'pub_mat_eleazar', 'nascimento', -270, -270, 'cerca_de', 'cerca de 270 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_eleazar', 'pub_mat_eleazar', 'falecimento', -210, -210, 'cerca_de', 'cerca de 210 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_mata', 'Matã', 'ben Elazar', 'M', 'Avô de José de Nazaré segundo Mateus 1:15. Casou-se com Está segundo a tradição patrística.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_mata', 'pub_mat_mata', 'nascimento', -230, -230, 'cerca_de', 'cerca de 230 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_mata', 'pub_mat_mata', 'falecimento', -170, -170, 'cerca_de', 'cerca de 170 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jaco_pai_jose', 'Jacó', 'ben Mattan', 'M', 'Pai de José de Nazaré segundo Mateus 1:16. Diverge frontalmente de Heli de Lucas.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jaco_pai_jose', 'pub_mat_jaco_pai_jose', 'nascimento', -50, -50, 'cerca_de', 'cerca de 50 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jaco_pai_jose', 'pub_mat_jaco_pai_jose', 'falecimento', 10, 10, 'cerca_de', 'cerca de 10 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_jose', 'São José', 'ben Yaakov', 'M', 'Esposo da Virgem Maria e pai legal de Jesus na linhagem régia de Mateus 1:16.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_jose', 'pub_mat_jose', 'nascimento', -30, -30, 'cerca_de', 'cerca de 30 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_jose', 'pub_mat_jose', 'falecimento', 18, 18, 'cerca_de', 'cerca de 18 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_mat_maria', 'Virgem Maria', 'de Nazaré', 'F', 'Mãe de Jesus; desposada por José, da qual nasceu Jesus chamado o Cristo (Mt 1:16).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_mat_maria', 'pub_mat_maria', 'nascimento', -18, -18, 'cerca_de', 'cerca de 18 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_mat_maria', 'pub_mat_maria', 'falecimento', 48, 48, 'cerca_de', 'cerca de 48 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_jesus_mateus', 'Jesus de Nazaré', '(Cristo)', 'M', 'Figura central do cristianismo; Messias davídico na linhagem régia dinástica de Mateus 1:1-17. Nascido no ano 1 d.C. em Belém e crucificado aos 33 anos em Jerusalém.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_jesus_mateus', 'pub_jesus_mateus', 'nascimento', 1, 1, 'exata', '1 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_jesus_mateus', 'pub_jesus_mateus', 'falecimento', 33, 33, 'exata', '33 d.C.');
INSERT OR REPLACE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_jesus_mateus', 'Genealogia de Jesus (Mateus — Linhagem Régia)', 'Linhagem messiânica e dinástica de Jesus de Nazaré desde Abraão e Davi por Salomão e os Reis de Judá até José (Mateus 1:1-17).', 'pub_jesus_mateus', 1, 'Bíblicas e Antiguidade', 'Israel Antigo / Judeia', 'c. 1800 a.C. – 33 d.C.', 'real');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_abraao', 'pub_arv_jesus_mateus', 'pub_mat_abraao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_sara', 'pub_arv_jesus_mateus', 'pub_mat_sara', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_isaac', 'pub_arv_jesus_mateus', 'pub_mat_isaac', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_rebeca', 'pub_arv_jesus_mateus', 'pub_mat_rebeca', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jaco_patriarca', 'pub_arv_jesus_mateus', 'pub_mat_jaco_patriarca', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_lia', 'pub_arv_jesus_mateus', 'pub_mat_lia', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_juda', 'pub_arv_jesus_mateus', 'pub_mat_juda', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_tamar', 'pub_arv_jesus_mateus', 'pub_mat_tamar', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_perez', 'pub_arv_jesus_mateus', 'pub_mat_perez', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_esrom', 'pub_arv_jesus_mateus', 'pub_mat_esrom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_arao', 'pub_arv_jesus_mateus', 'pub_mat_arao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_aminadabe', 'pub_arv_jesus_mateus', 'pub_mat_aminadabe', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_naassom', 'pub_arv_jesus_mateus', 'pub_mat_naassom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_salmom', 'pub_arv_jesus_mateus', 'pub_mat_salmom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_raabe', 'pub_arv_jesus_mateus', 'pub_mat_raabe', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_boaz', 'pub_arv_jesus_mateus', 'pub_mat_boaz', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_rute', 'pub_arv_jesus_mateus', 'pub_mat_rute', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_obede', 'pub_arv_jesus_mateus', 'pub_mat_obede', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jesse', 'pub_arv_jesus_mateus', 'pub_mat_jesse', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_davi', 'pub_arv_jesus_mateus', 'pub_mat_davi', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_bateseba', 'pub_arv_jesus_mateus', 'pub_mat_bateseba', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_salomao', 'pub_arv_jesus_mateus', 'pub_mat_salomao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_naama', 'pub_arv_jesus_mateus', 'pub_mat_naama', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_roboao', 'pub_arv_jesus_mateus', 'pub_mat_roboao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_maaca', 'pub_arv_jesus_mateus', 'pub_mat_maaca', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_abias', 'pub_arv_jesus_mateus', 'pub_mat_abias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_asa', 'pub_arv_jesus_mateus', 'pub_mat_asa', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_josafa', 'pub_arv_jesus_mateus', 'pub_mat_josafa', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jorao', 'pub_arv_jesus_mateus', 'pub_mat_jorao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_atalia', 'pub_arv_jesus_mateus', 'pub_mat_atalia', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_ozias', 'pub_arv_jesus_mateus', 'pub_mat_ozias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jotao', 'pub_arv_jesus_mateus', 'pub_mat_jotao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_acaz', 'pub_arv_jesus_mateus', 'pub_mat_acaz', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_ezequias', 'pub_arv_jesus_mateus', 'pub_mat_ezequias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_hefziba', 'pub_arv_jesus_mateus', 'pub_mat_hefziba', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_manasses', 'pub_arv_jesus_mateus', 'pub_mat_manasses', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_mesulemete', 'pub_arv_jesus_mateus', 'pub_mat_mesulemete', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_amom', 'pub_arv_jesus_mateus', 'pub_mat_amom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jedida', 'pub_arv_jesus_mateus', 'pub_mat_jedida', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_josias', 'pub_arv_jesus_mateus', 'pub_mat_josias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jeconias', 'pub_arv_jesus_mateus', 'pub_mat_jeconias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_salatiel', 'pub_arv_jesus_mateus', 'pub_mat_salatiel', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_zorobabel', 'pub_arv_jesus_mateus', 'pub_mat_zorobabel', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_abiude', 'pub_arv_jesus_mateus', 'pub_mat_abiude', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_eliaquim', 'pub_arv_jesus_mateus', 'pub_mat_eliaquim', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_azor', 'pub_arv_jesus_mateus', 'pub_mat_azor', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_sadoque', 'pub_arv_jesus_mateus', 'pub_mat_sadoque', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_aquim', 'pub_arv_jesus_mateus', 'pub_mat_aquim', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_eliude', 'pub_arv_jesus_mateus', 'pub_mat_eliude', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_eleazar', 'pub_arv_jesus_mateus', 'pub_mat_eleazar', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_mata', 'pub_arv_jesus_mateus', 'pub_mat_mata', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jaco_pai_jose', 'pub_arv_jesus_mateus', 'pub_mat_jaco_pai_jose', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_jose', 'pub_arv_jesus_mateus', 'pub_mat_jose', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_mat_maria', 'pub_arv_jesus_mateus', 'pub_mat_maria', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_pub_jesus_mateus', 'pub_arv_jesus_mateus', 'pub_jesus_mateus', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_abraao_sara', 'pub_mat_abraao', 'pub_mat_sara', 'casamento', 'Patriarcas de Israel (Mt 1:2)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_abraao_sara', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_abraao_sara');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_abraao_sara', 'pub_mat_isaac', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_isaac_rebeca', 'pub_mat_isaac', 'pub_mat_rebeca', 'casamento', 'Patriarcas de Israel (Mt 1:2)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_isaac_rebeca', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_isaac_rebeca');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_isaac_rebeca', 'pub_mat_jaco_patriarca', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jaco_lia', 'pub_mat_jaco_patriarca', 'pub_mat_lia', 'casamento', 'Patriarcas de Israel (Mt 1:2)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jaco_lia', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jaco_lia');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jaco_lia', 'pub_mat_juda', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_juda_tamar', 'pub_mat_juda', 'pub_mat_tamar', 'casamento', 'Geração de Perez e Zerá (Mt 1:3; Gn 38)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_juda_tamar', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_juda_tamar');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_juda_tamar', 'pub_mat_perez', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_perez', 'pub_mat_perez', 'pub_mat_perez', 'nao_informado', 'Linhagem de Judá no Egito (Mt 1:3)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_perez', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_perez');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_perez', 'pub_mat_esrom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_esrom', 'pub_mat_esrom', 'pub_mat_esrom', 'nao_informado', 'Linhagem em Gosén (Mt 1:3-4)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_esrom', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_esrom');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_esrom', 'pub_mat_arao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_arao', 'pub_mat_arao', 'pub_mat_arao', 'nao_informado', 'Linhagem pré-Êxodo (Mt 1:4)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_arao', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_arao');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_arao', 'pub_mat_aminadabe', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_aminadabe', 'pub_mat_aminadabe', 'pub_mat_aminadabe', 'nao_informado', 'Linhagem do Êxodo (Mt 1:4)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_aminadabe', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_aminadabe');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_aminadabe', 'pub_mat_naassom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_naassom', 'pub_mat_naassom', 'pub_mat_naassom', 'nao_informado', 'Linhagem no Deserto (Mt 1:4)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_naassom', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_naassom');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_naassom', 'pub_mat_salmom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_salmom_raabe', 'pub_mat_salmom', 'pub_mat_raabe', 'casamento', 'Casamento com Raabe de Jericó (Mt 1:5)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_salmom_raabe', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_salmom_raabe');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_salmom_raabe', 'pub_mat_boaz', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_boaz_rute', 'pub_mat_boaz', 'pub_mat_rute', 'casamento', 'Resgate em Belém (Mt 1:5; Rute 4)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_boaz_rute', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_boaz_rute');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_boaz_rute', 'pub_mat_obede', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_obede', 'pub_mat_obede', 'pub_mat_obede', 'nao_informado', 'Linhagem em Belém (Mt 1:5)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_obede', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_obede');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_obede', 'pub_mat_jesse', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jesse', 'pub_mat_jesse', 'pub_mat_jesse', 'nao_informado', 'Filhos de Jessé de Belém (Mt 1:6)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jesse', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jesse');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jesse', 'pub_mat_davi', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_davi_bateseba', 'pub_mat_davi', 'pub_mat_bateseba', 'casamento', 'Rei Davi gerou Salomão da mulher de Urias (Mt 1:6)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_davi_bateseba', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_davi_bateseba');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_davi_bateseba', 'pub_mat_salomao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_salomao_naama', 'pub_mat_salomao', 'pub_mat_naama', 'casamento', 'Salomão gerou Roboão (Mt 1:7)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_salomao_naama', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_salomao_naama');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_salomao_naama', 'pub_mat_roboao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_roboao_maaca', 'pub_mat_roboao', 'pub_mat_maaca', 'casamento', 'Roboão gerou Abias (Mt 1:7)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_roboao_maaca', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_roboao_maaca');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_roboao_maaca', 'pub_mat_abias', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_abias', 'pub_mat_abias', 'pub_mat_abias', 'nao_informado', 'Abias gerou Asa (Mt 1:7)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_abias', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_abias');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_abias', 'pub_mat_asa', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_asa', 'pub_mat_asa', 'pub_mat_asa', 'nao_informado', 'Asa gerou Josafá (Mt 1:8)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_asa', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_asa');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_asa', 'pub_mat_josafa', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_josafa', 'pub_mat_josafa', 'pub_mat_josafa', 'nao_informado', 'Josafá gerou Jorão (Mt 1:8)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_josafa', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_josafa');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_josafa', 'pub_mat_jorao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jorao_atalia', 'pub_mat_jorao', 'pub_mat_atalia', 'casamento', 'Jorão gerou Ozias (omissão de Acazias, Joás, Amazias) (Mt 1:8)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jorao_atalia', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jorao_atalia');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jorao_atalia', 'pub_mat_ozias', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_ozias', 'pub_mat_ozias', 'pub_mat_ozias', 'nao_informado', 'Ozias gerou Jotão (Mt 1:9)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_ozias', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_ozias');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_ozias', 'pub_mat_jotao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jotao', 'pub_mat_jotao', 'pub_mat_jotao', 'nao_informado', 'Jotão gerou Acaz (Mt 1:9)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jotao', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jotao');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jotao', 'pub_mat_acaz', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_acaz', 'pub_mat_acaz', 'pub_mat_acaz', 'nao_informado', 'Acaz gerou Ezequias (Mt 1:9-10)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_acaz', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_acaz');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_acaz', 'pub_mat_ezequias', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_ezequias_hefziba', 'pub_mat_ezequias', 'pub_mat_hefziba', 'casamento', 'Ezequias gerou Manassés (Mt 1:10)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_ezequias_hefziba', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_ezequias_hefziba');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_ezequias_hefziba', 'pub_mat_manasses', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_manasses_mesulemete', 'pub_mat_manasses', 'pub_mat_mesulemete', 'casamento', 'Manassés gerou Amom (Mt 1:10)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_manasses_mesulemete', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_manasses_mesulemete');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_manasses_mesulemete', 'pub_mat_amom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_amom_jedida', 'pub_mat_amom', 'pub_mat_jedida', 'casamento', 'Amom gerou Josias (Mt 1:10)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_amom_jedida', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_amom_jedida');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_amom_jedida', 'pub_mat_josias', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_josias', 'pub_mat_josias', 'pub_mat_josias', 'nao_informado', 'Josias gerou Jeconias no exílio da Babilônia (Mt 1:11)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_josias', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_josias');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_josias', 'pub_mat_jeconias', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jeconias', 'pub_mat_jeconias', 'pub_mat_jeconias', 'nao_informado', 'Depois do exílio, Jeconias gerou Salatiel (Mt 1:12)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jeconias', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jeconias');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jeconias', 'pub_mat_salatiel', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_salatiel', 'pub_mat_salatiel', 'pub_mat_salatiel', 'nao_informado', 'Salatiel gerou Zorobabel (Mt 1:12)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_salatiel', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_salatiel');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_salatiel', 'pub_mat_zorobabel', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_zorobabel', 'pub_mat_zorobabel', 'pub_mat_zorobabel', 'nao_informado', 'Zorobabel gerou Abiúde (Mt 1:13)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_zorobabel', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_zorobabel');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_zorobabel', 'pub_mat_abiude', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_abiude', 'pub_mat_abiude', 'pub_mat_abiude', 'nao_informado', 'Abiúde gerou Eliaquim (Mt 1:13)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_abiude', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_abiude');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_abiude', 'pub_mat_eliaquim', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_eliaquim', 'pub_mat_eliaquim', 'pub_mat_eliaquim', 'nao_informado', 'Eliaquim gerou Azor (Mt 1:13)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_eliaquim', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_eliaquim');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_eliaquim', 'pub_mat_azor', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_azor', 'pub_mat_azor', 'pub_mat_azor', 'nao_informado', 'Azor gerou Sadoque (Mt 1:14)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_azor', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_azor');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_azor', 'pub_mat_sadoque', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_sadoque', 'pub_mat_sadoque', 'pub_mat_sadoque', 'nao_informado', 'Sadoque gerou Aquim (Mt 1:14)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_sadoque', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_sadoque');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_sadoque', 'pub_mat_aquim', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_aquim', 'pub_mat_aquim', 'pub_mat_aquim', 'nao_informado', 'Aquim gerou Eliúde (Mt 1:14)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_aquim', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_aquim');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_aquim', 'pub_mat_eliude', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_eliude', 'pub_mat_eliude', 'pub_mat_eliude', 'nao_informado', 'Eliúde gerou Eleazar (Mt 1:15)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_eliude', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_eliude');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_eliude', 'pub_mat_eleazar', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_eleazar', 'pub_mat_eleazar', 'pub_mat_eleazar', 'nao_informado', 'Eleazar gerou Matã (Mt 1:15)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_eleazar', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_eleazar');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_eleazar', 'pub_mat_mata', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_mata', 'pub_mat_mata', 'pub_mat_mata', 'nao_informado', 'Matã gerou Jacó (Mt 1:15)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_mata', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_mata');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_mata', 'pub_mat_jaco_pai_jose', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jaco', 'pub_mat_jaco_pai_jose', 'pub_mat_jaco_pai_jose', 'nao_informado', 'Jacó gerou José, esposo de Maria (Mt 1:16)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jaco', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jaco');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jaco', 'pub_mat_jose', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_mat_jose_maria', 'pub_mat_jose', 'pub_mat_maria', 'casamento', 'Maria, da qual nasceu Jesus chamado Cristo (Mt 1:16)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_mat_u_pub_u_mat_jose_maria', 'pub_arv_jesus_mateus', NULL, 'pub_u_mat_jose_maria');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_mat_jose_maria', 'pub_jesus_mateus', 'adotado', 1);

-- =====================================================================
-- ÁRVORE: Genealogia de Jesus (Segundo Lucas — Linhagem por Natã e Parentesco)
-- =====================================================================
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_abraao', 'Abraão', 'ben Terah', 'M', 'Patriarca bíblico de Israel (Lc 3:34).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_abraao', 'pub_luc_abraao', 'nascimento', -1813, -1813, 'cerca_de', 'cerca de 1813 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_abraao', 'pub_luc_abraao', 'falecimento', -1638, -1638, 'cerca_de', 'cerca de 1638 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_isaac', 'Isaac', 'ben Avraham', 'M', 'Segundo patriarca bíblico de Israel (Lc 3:34).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_isaac', 'pub_luc_isaac', 'nascimento', -1713, -1713, 'cerca_de', 'cerca de 1713 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_isaac', 'pub_luc_isaac', 'falecimento', -1533, -1533, 'cerca_de', 'cerca de 1533 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jaco_patriarca', 'Jacó', '(Israel)', 'M', 'Terceiro patriarca bíblico de Israel (Lc 3:34).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jaco_patriarca', 'pub_luc_jaco_patriarca', 'nascimento', -1653, -1653, 'cerca_de', 'cerca de 1653 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jaco_patriarca', 'pub_luc_jaco_patriarca', 'falecimento', -1506, -1506, 'cerca_de', 'cerca de 1506 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_juda', 'Judá', 'ben Yaakov', 'M', 'Quarto filho de Jacó (Lc 3:33).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_juda', 'pub_luc_juda', 'nascimento', -1566, -1566, 'cerca_de', 'cerca de 1566 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_juda', 'pub_luc_juda', 'falecimento', -1437, -1437, 'cerca_de', 'cerca de 1437 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_perez', 'Perez', '(Farés)', 'M', 'Filho de Judá (Lc 3:33).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_perez', 'pub_luc_perez', 'nascimento', -1500, -1500, 'cerca_de', 'cerca de 1500 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_perez', 'pub_luc_perez', 'falecimento', -1420, -1420, 'cerca_de', 'cerca de 1420 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_esrom', 'Esrom', '(Hezrom)', 'M', 'Filho de Perez (Lc 3:33).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_esrom', 'pub_luc_esrom', 'nascimento', -1450, -1450, 'cerca_de', 'cerca de 1450 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_esrom', 'pub_luc_esrom', 'falecimento', -1380, -1380, 'cerca_de', 'cerca de 1380 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_arao', 'Arni', '(Ram)', 'M', 'Filho de Esrom (Lc 3:33).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_arao', 'pub_luc_arao', 'nascimento', -1400, -1400, 'cerca_de', 'cerca de 1400 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_arao', 'pub_luc_arao', 'falecimento', -1330, -1330, 'cerca_de', 'cerca de 1330 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_aminadabe', 'Aminadabe', 'ben Ram', 'M', 'Filho de Arão/Arni (Lc 3:33).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_aminadabe', 'pub_luc_aminadabe', 'nascimento', -1350, -1350, 'cerca_de', 'cerca de 1350 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_aminadabe', 'pub_luc_aminadabe', 'falecimento', -1280, -1280, 'cerca_de', 'cerca de 1280 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_naassom', 'Naassom', 'ben Amminadav', 'M', 'Príncipe de Judá (Lc 3:32).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_naassom', 'pub_luc_naassom', 'nascimento', -1300, -1300, 'cerca_de', 'cerca de 1300 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_naassom', 'pub_luc_naassom', 'falecimento', -1240, -1240, 'cerca_de', 'cerca de 1240 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_salmom', 'Salá', '(Salmom)', 'M', 'Filho de Naassom (Lc 3:32).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_salmom', 'pub_luc_salmom', 'nascimento', -1250, -1250, 'cerca_de', 'cerca de 1250 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_salmom', 'pub_luc_salmom', 'falecimento', -1190, -1190, 'cerca_de', 'cerca de 1190 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_boaz', 'Boaz', 'ben Salmon', 'M', 'Esposo de Rute em Belém (Lc 3:32).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_boaz', 'pub_luc_boaz', 'nascimento', -1180, -1180, 'cerca_de', 'cerca de 1180 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_boaz', 'pub_luc_boaz', 'falecimento', -1110, -1110, 'cerca_de', 'cerca de 1110 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_obede', 'Obede', 'ben Boaz', 'M', 'Filho de Boaz (Lc 3:32).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_obede', 'pub_luc_obede', 'nascimento', -1130, -1130, 'cerca_de', 'cerca de 1130 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_obede', 'pub_luc_obede', 'falecimento', -1060, -1060, 'cerca_de', 'cerca de 1060 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jesse', 'Jessé', 'ben Oved', 'M', 'Pai do Rei Davi (Lc 3:32).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jesse', 'pub_luc_jesse', 'nascimento', -1090, -1090, 'cerca_de', 'cerca de 1090 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jesse', 'pub_luc_jesse', 'falecimento', -1020, -1020, 'cerca_de', 'cerca de 1020 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_davi', 'Rei David', 'de Israel', 'M', 'Segundo rei de Israel; ponto de bifurcação (Lc 3:31).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_davi', 'pub_luc_davi', 'nascimento', -1040, -1040, 'cerca_de', 'cerca de 1040 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_davi', 'pub_luc_davi', 'falecimento', -970, -970, 'cerca_de', 'cerca de 970 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_nata', 'Natã', 'ben David', 'M', 'Terceiro filho de Davi com Bate-Seba; cabeça da linhagem de Lucas (Lc 3:31; 1 Cr 3:5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_nata', 'pub_luc_nata', 'nascimento', -995, -995, 'cerca_de', 'cerca de 995 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_nata', 'pub_luc_nata', 'falecimento', -935, -935, 'cerca_de', 'cerca de 935 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_matata', 'Matatá', 'ben Natan', 'M', 'Filho de Natã (Lc 3:31).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_matata', 'pub_luc_matata', 'nascimento', -960, -960, 'cerca_de', 'cerca de 960 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_matata', 'pub_luc_matata', 'falecimento', -900, -900, 'cerca_de', 'cerca de 900 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_mena', 'Mená', 'ben Mattatah', 'M', 'Filho de Matatá (Lc 3:31).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_mena', 'pub_luc_mena', 'nascimento', -930, -930, 'cerca_de', 'cerca de 930 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_mena', 'pub_luc_mena', 'falecimento', -870, -870, 'cerca_de', 'cerca de 870 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_meleia', 'Meleia', 'ben Menna', 'M', 'Filho de Mená (Lc 3:31).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_meleia', 'pub_luc_meleia', 'nascimento', -900, -900, 'cerca_de', 'cerca de 900 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_meleia', 'pub_luc_meleia', 'falecimento', -840, -840, 'cerca_de', 'cerca de 840 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_eliaquim', 'Eliaquim', 'ben Melea', 'M', 'Filho de Meleia (Lc 3:30-31). Não confundir com Eliaquim ben Avihud.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_eliaquim', 'pub_luc_eliaquim', 'nascimento', -870, -870, 'cerca_de', 'cerca de 870 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_eliaquim', 'pub_luc_eliaquim', 'falecimento', -810, -810, 'cerca_de', 'cerca de 810 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jona', 'Jonã', 'ben Elyakim', 'M', 'Filho de Eliaquim (Lc 3:30).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jona', 'pub_luc_jona', 'nascimento', -840, -840, 'cerca_de', 'cerca de 840 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jona', 'pub_luc_jona', 'falecimento', -780, -780, 'cerca_de', 'cerca de 780 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jose_antigo', 'José', 'ben Yonam', 'M', 'Filho de Jonã na linhagem pré-exílica de Lucas (Lc 3:30).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jose_antigo', 'pub_luc_jose_antigo', 'nascimento', -810, -810, 'cerca_de', 'cerca de 810 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jose_antigo', 'pub_luc_jose_antigo', 'falecimento', -750, -750, 'cerca_de', 'cerca de 750 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_juda_filho_jose', 'Judá', 'ben Yosef', 'M', 'Filho de José ben Jonã (Lc 3:30).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_juda_filho_jose', 'pub_luc_juda_filho_jose', 'nascimento', -780, -780, 'cerca_de', 'cerca de 780 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_juda_filho_jose', 'pub_luc_juda_filho_jose', 'falecimento', -720, -720, 'cerca_de', 'cerca de 720 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_simeao', 'Simeão', 'ben Yehudah', 'M', 'Filho de Judá (Lc 3:30).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_simeao', 'pub_luc_simeao', 'nascimento', -750, -750, 'cerca_de', 'cerca de 750 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_simeao', 'pub_luc_simeao', 'falecimento', -690, -690, 'cerca_de', 'cerca de 690 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_levi_antigo', 'Levi', 'ben Shimon', 'M', 'Filho de Simeão na linha de Natã (Lc 3:29-30).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_levi_antigo', 'pub_luc_levi_antigo', 'nascimento', -720, -720, 'cerca_de', 'cerca de 720 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_levi_antigo', 'pub_luc_levi_antigo', 'falecimento', -660, -660, 'cerca_de', 'cerca de 660 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_matat_antigo', 'Matat', 'ben Levi', 'M', 'Filho de Levi ben Shimon (Lc 3:29).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_matat_antigo', 'pub_luc_matat_antigo', 'nascimento', -690, -690, 'cerca_de', 'cerca de 690 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_matat_antigo', 'pub_luc_matat_antigo', 'falecimento', -630, -630, 'cerca_de', 'cerca de 630 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jorim', 'Jorim', 'ben Mattat', 'M', 'Filho de Matat (Lc 3:29).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jorim', 'pub_luc_jorim', 'nascimento', -665, -665, 'cerca_de', 'cerca de 665 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jorim', 'pub_luc_jorim', 'falecimento', -605, -605, 'cerca_de', 'cerca de 605 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_eliezer', 'Eliezer', 'ben Yorim', 'M', 'Filho de Jorim (Lc 3:29).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_eliezer', 'pub_luc_eliezer', 'nascimento', -640, -640, 'cerca_de', 'cerca de 640 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_eliezer', 'pub_luc_eliezer', 'falecimento', -580, -580, 'cerca_de', 'cerca de 580 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jesus_antigo', 'Jesus', '(Josué ben Eliezer)', 'M', 'Antepassado homônimo na linhagem de Natã (Lc 3:29).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jesus_antigo', 'pub_luc_jesus_antigo', 'nascimento', -620, -620, 'cerca_de', 'cerca de 620 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jesus_antigo', 'pub_luc_jesus_antigo', 'falecimento', -560, -560, 'cerca_de', 'cerca de 560 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_er', 'Er', 'ben Yehoshua', 'M', 'Filho de Jesus/Josué (Lc 3:28).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_er', 'pub_luc_er', 'nascimento', -600, -600, 'cerca_de', 'cerca de 600 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_er', 'pub_luc_er', 'falecimento', -540, -540, 'cerca_de', 'cerca de 540 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_elmada', 'Elmadã', 'ben Er', 'M', 'Filho de Er (Lc 3:28).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_elmada', 'pub_luc_elmada', 'nascimento', -585, -585, 'cerca_de', 'cerca de 585 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_elmada', 'pub_luc_elmada', 'falecimento', -525, -525, 'cerca_de', 'cerca de 525 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_cosa', 'Cosã', 'ben Elmadam', 'M', 'Filho de Elmadã na Babilônia (Lc 3:28).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_cosa', 'pub_luc_cosa', 'nascimento', -565, -565, 'cerca_de', 'cerca de 565 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_cosa', 'pub_luc_cosa', 'falecimento', -505, -505, 'cerca_de', 'cerca de 505 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_adi', 'Adi', 'ben Kosam', 'M', 'Filho de Cosã no Cativeiro Babilônico (Lc 3:28).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_adi', 'pub_luc_adi', 'nascimento', -545, -545, 'cerca_de', 'cerca de 545 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_adi', 'pub_luc_adi', 'falecimento', -485, -485, 'cerca_de', 'cerca de 485 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_melqui_antigo', 'Melqui', 'ben Addi', 'M', 'Filho de Adi (Lc 3:28).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_melqui_antigo', 'pub_luc_melqui_antigo', 'nascimento', -525, -525, 'cerca_de', 'cerca de 525 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_melqui_antigo', 'pub_luc_melqui_antigo', 'falecimento', -465, -465, 'cerca_de', 'cerca de 465 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_neri', 'Neri', 'ben Malki', 'M', 'Pai de Salatiel segundo Lucas 3:27-28; diverge de Mateus.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_neri', 'pub_luc_neri', 'nascimento', -505, -505, 'cerca_de', 'cerca de 505 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_neri', 'pub_luc_neri', 'falecimento', -450, -450, 'cerca_de', 'cerca de 450 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_salatiel', 'Salatiel', 'ben Neri', 'M', 'Príncipe de Judá; filho de Neri em Lucas 3:27 (ponto de convergência com Mateus).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_salatiel', 'pub_luc_salatiel', 'nascimento', -580, -580, 'cerca_de', 'cerca de 580 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_salatiel', 'pub_luc_salatiel', 'falecimento', -520, -520, 'cerca_de', 'cerca de 520 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_zorobabel', 'Zorobabel', 'ben Shealtiel', 'M', 'Líder do retorno babilônico; em Lucas seu filho é Resa (Lc 3:27).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_zorobabel', 'pub_luc_zorobabel', 'nascimento', -550, -550, 'cerca_de', 'cerca de 550 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_zorobabel', 'pub_luc_zorobabel', 'falecimento', -490, -490, 'cerca_de', 'cerca de 490 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_resa', 'Resa', 'ben Zerubavel', 'M', 'Filho de Zorobabel em Lucas 3:27; início da nova separação com Mateus.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_resa', 'pub_luc_resa', 'nascimento', -515, -515, 'cerca_de', 'cerca de 515 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_resa', 'pub_luc_resa', 'falecimento', -455, -455, 'cerca_de', 'cerca de 455 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_joana', 'Joanã', 'ben Rhesa', 'M', 'Filho de Resa (Lc 3:27).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_joana', 'pub_luc_joana', 'nascimento', -485, -485, 'cerca_de', 'cerca de 485 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_joana', 'pub_luc_joana', 'falecimento', -425, -425, 'cerca_de', 'cerca de 425 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_joda', 'Jodá', 'ben Yochanan', 'M', 'Filho de Joanã (Lc 3:26).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_joda', 'pub_luc_joda', 'nascimento', -455, -455, 'cerca_de', 'cerca de 455 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_joda', 'pub_luc_joda', 'falecimento', -395, -395, 'cerca_de', 'cerca de 395 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jose_pos_exilio', 'José', 'ben Yodah', 'M', 'Filho de Jodá na linhagem de Lucas (Lc 3:26).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jose_pos_exilio', 'pub_luc_jose_pos_exilio', 'nascimento', -425, -425, 'cerca_de', 'cerca de 425 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jose_pos_exilio', 'pub_luc_jose_pos_exilio', 'falecimento', -365, -365, 'cerca_de', 'cerca de 365 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_semei', 'Semei', 'ben Yosef', 'M', 'Filho de José ben Jodá (Lc 3:26).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_semei', 'pub_luc_semei', 'nascimento', -395, -395, 'cerca_de', 'cerca de 395 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_semei', 'pub_luc_semei', 'falecimento', -335, -335, 'cerca_de', 'cerca de 335 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_matatias_antigo', 'Matatias', 'ben Shimei', 'M', 'Filho de Semei (Lc 3:26).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_matatias_antigo', 'pub_luc_matatias_antigo', 'nascimento', -365, -365, 'cerca_de', 'cerca de 365 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_matatias_antigo', 'pub_luc_matatias_antigo', 'falecimento', -305, -305, 'cerca_de', 'cerca de 305 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_maate', 'Maate', 'ben Mattityahu', 'M', 'Filho de Matatias (Lc 3:26).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_maate', 'pub_luc_maate', 'nascimento', -335, -335, 'cerca_de', 'cerca de 335 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_maate', 'pub_luc_maate', 'falecimento', -275, -275, 'cerca_de', 'cerca de 275 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_nagai', 'Nagai', 'ben Mahath', 'M', 'Filho de Maate (Lc 3:25).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_nagai', 'pub_luc_nagai', 'nascimento', -305, -305, 'cerca_de', 'cerca de 305 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_nagai', 'pub_luc_nagai', 'falecimento', -245, -245, 'cerca_de', 'cerca de 245 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_esli', 'Esli', 'ben Naggai', 'M', 'Filho de Nagai (Lc 3:25).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_esli', 'pub_luc_esli', 'nascimento', -275, -275, 'cerca_de', 'cerca de 275 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_esli', 'pub_luc_esli', 'falecimento', -215, -215, 'cerca_de', 'cerca de 215 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_naum', 'Naum', 'ben Hesli', 'M', 'Filho de Esli (Lc 3:25). Não confundir com o profeta Naum de Elcos.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_naum', 'pub_luc_naum', 'nascimento', -245, -245, 'cerca_de', 'cerca de 245 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_naum', 'pub_luc_naum', 'falecimento', -185, -185, 'cerca_de', 'cerca de 185 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_amos', 'Amós', 'ben Nahum', 'M', 'Filho de Naum (Lc 3:25). Não confundir com o profeta Amós de Tecoa.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_amos', 'pub_luc_amos', 'nascimento', -215, -215, 'cerca_de', 'cerca de 215 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_amos', 'pub_luc_amos', 'falecimento', -155, -155, 'cerca_de', 'cerca de 155 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_matatias_recente', 'Matatias', 'ben Amos', 'M', 'Filho de Amós da era macabeia (Lc 3:25).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_matatias_recente', 'pub_luc_matatias_recente', 'nascimento', -185, -185, 'cerca_de', 'cerca de 185 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_matatias_recente', 'pub_luc_matatias_recente', 'falecimento', -125, -125, 'cerca_de', 'cerca de 125 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jose_recente', 'José', 'ben Mattityahu', 'M', 'Filho de Matatias no período asmoneu (Lc 3:24-25).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jose_recente', 'pub_luc_jose_recente', 'nascimento', -155, -155, 'cerca_de', 'cerca de 155 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jose_recente', 'pub_luc_jose_recente', 'falecimento', -95, -95, 'cerca_de', 'cerca de 95 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_janai', 'Janai', 'ben Yosef', 'M', 'Filho de José ben Matatias (Lc 3:24).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_janai', 'pub_luc_janai', 'nascimento', -125, -125, 'cerca_de', 'cerca de 125 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_janai', 'pub_luc_janai', 'falecimento', -65, -65, 'cerca_de', 'cerca de 65 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_melqui_recente', 'Melqui', 'ben Yannai', 'M', 'Bisavô de José de Nazaré segundo Lucas 3:24.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_melqui_recente', 'pub_luc_melqui_recente', 'nascimento', -95, -95, 'cerca_de', 'cerca de 95 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_melqui_recente', 'pub_luc_melqui_recente', 'falecimento', -35, -35, 'cerca_de', 'cerca de 35 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_levi_recente', 'Levi', 'ben Malki', 'M', 'Filho de Melqui ben Janai (Lc 3:24).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_levi_recente', 'pub_luc_levi_recente', 'nascimento', -70, -70, 'cerca_de', 'cerca de 70 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_levi_recente', 'pub_luc_levi_recente', 'falecimento', -10, -10, 'cerca_de', 'cerca de 10 a.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_matat_recente', 'Matat', 'ben Levi', 'M', 'Avô de José de Nazaré segundo Lucas 3:24. Pai de Heli e ancestral de Santa Isabel.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_matat_recente', 'pub_luc_matat_recente', 'nascimento', -50, -50, 'cerca_de', 'cerca de 50 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_matat_recente', 'pub_luc_matat_recente', 'falecimento', 15, 15, 'cerca_de', '15 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_heli', 'Heli', '(Eli ben Mattat)', 'M', 'Pai de José segundo Lucas 3:23 (''sendo, como se cuidava, filho de José, de Heli''). Pela tese de 1490, pai de Maria e Clopas.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_heli', 'pub_luc_heli', 'nascimento', -55, -55, 'cerca_de', 'cerca de 55 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_heli', 'pub_luc_heli', 'falecimento', 10, 10, 'cerca_de', '10 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jose', 'São José', 'ben Eli', 'M', 'Esposo de Maria; pai legal de Jesus na linhagem de Lucas 3:23 (''filho de Heli'').', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jose', 'pub_luc_jose', 'nascimento', -30, -30, 'cerca_de', 'cerca de 30 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jose', 'pub_luc_jose', 'falecimento', 18, 18, 'cerca_de', '18 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_maria', 'Virgem Maria', 'de Nazaré', 'F', 'Mãe de Jesus; na tese tradicional de Annio de Viterbo (c. 1490) é filha biológica de Heli.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_maria', 'pub_luc_maria', 'nascimento', -18, -18, 'cerca_de', 'cerca de 18 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_maria', 'pub_luc_maria', 'falecimento', 48, 48, 'cerca_de', '48 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_jesus_lucas', 'Jesus de Nazaré', '(Salvador Universal)', 'M', 'Figura central do cristianismo; Filho de Deus e descendente universal de Davi e Adão (Lc 3:23-38). Nascido no ano 1 d.C. em Belém e crucificado aos 33 anos em Jerusalém.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_jesus_lucas', 'pub_jesus_lucas', 'nascimento', 1, 1, 'exata', '1 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_jesus_lucas', 'pub_jesus_lucas', 'falecimento', 33, 33, 'exata', '33 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_clopas', 'Clopas', '(Alfeu)', 'M', 'Irmão de São José segundo Hegesipo; casado com Maria de Clopas (Jo 19:25; Mc 3:18).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_clopas', 'pub_luc_clopas', 'nascimento', -35, -35, 'cerca_de', 'cerca de 35 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_clopas', 'pub_luc_clopas', 'falecimento', 25, 25, 'cerca_de', '25 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_maria_clopas', 'Maria de Clopas', NULL, 'F', 'Discípula presente na crucificação (Jo 19:25); mãe de Tiago Menor e José (Mc 15:40).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_maria_clopas', 'pub_luc_maria_clopas', 'nascimento', -30, -30, 'cerca_de', 'cerca de 30 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_maria_clopas', 'pub_luc_maria_clopas', 'falecimento', 50, 50, 'cerca_de', '50 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_tiago_menor', 'São Tiago Menor', 'ben Hilfai', 'M', 'Apóstolo de Jesus; filho de Alfeu e Maria de Clopas; primo de Jesus (Mc 3:18).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_tiago_menor', 'pub_luc_tiago_menor', 'nascimento', -5, -5, 'cerca_de', 'cerca de 5 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_tiago_menor', 'pub_luc_tiago_menor', 'falecimento', 62, 62, 'cerca_de', '62 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_judas_tadeu', 'São Judas Tadeu', 'de Tiago', 'M', 'Apóstolo de Jesus; tradicionalmente filho/irmão de Tiago Menor (Lc 6:16).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_judas_tadeu', 'pub_luc_judas_tadeu', 'nascimento', 0, 0, 'cerca_de', '0 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_judas_tadeu', 'pub_luc_judas_tadeu', 'falecimento', 70, 70, 'cerca_de', '70 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jose_irmao', 'José', '(irmão do Senhor)', 'M', 'Citado entre os quatro ''irmãos'' de Jesus (Mc 6:3; Mt 13:55). Filho de Maria de Clopas na tese hieronimiana.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jose_irmao', 'pub_luc_jose_irmao', 'nascimento', 5, 5, 'cerca_de', '5 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jose_irmao', 'pub_luc_jose_irmao', 'falecimento', 70, 70, 'cerca_de', '70 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_simao_irmao', 'Simão', '(irmão do Senhor)', 'M', 'Citado como irmão de Jesus (Mc 6:3); 2º bispo de Jerusalém (Hegesipo).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_simao_irmao', 'pub_luc_simao_irmao', 'nascimento', 7, 7, 'cerca_de', '7 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_simao_irmao', 'pub_luc_simao_irmao', 'falecimento', 107, 107, 'cerca_de', '107 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_zebedeu', 'Zebedeu', NULL, 'M', 'Mestre pescador de Cafarnaum; pai dos apóstolos Tiago Maior e João (Mt 4:21).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_zebedeu', 'pub_luc_zebedeu', 'nascimento', -45, -45, 'cerca_de', 'cerca de 45 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_zebedeu', 'pub_luc_zebedeu', 'falecimento', 15, 15, 'cerca_de', '15 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_salome', 'Santa Salomé', NULL, 'F', 'Mãe dos apóstolos Tiago Maior e João; na Hipótese A de Jo 19:25, irmã da Virgem Maria.', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_salome', 'pub_luc_salome', 'nascimento', -40, -40, 'cerca_de', 'cerca de 40 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_salome', 'pub_luc_salome', 'falecimento', 45, 45, 'cerca_de', '45 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_tiago_maior', 'São Tiago Maior', 'ben Zavdai', 'M', 'Apóstolo do círculo íntimo de Jesus; filho de Zebedeu; martirizado em 44 d.C. (At 12:2).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_tiago_maior', 'pub_luc_tiago_maior', 'nascimento', -5, -5, 'cerca_de', 'cerca de 5 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_tiago_maior', 'pub_luc_tiago_maior', 'falecimento', 44, 44, 'cerca_de', '44 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_joao_evangelista', 'São João Evangelista', 'ben Zavdai', 'M', 'O discípulo amado; irmão de Tiago Maior; autor do 4º Evangelho (Jo 19:26-27).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_joao_evangelista', 'pub_luc_joao_evangelista', 'nascimento', 6, 6, 'cerca_de', '6 d.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_joao_evangelista', 'pub_luc_joao_evangelista', 'falecimento', 100, 100, 'cerca_de', '100 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_zacarias', 'Zacarias', NULL, 'M', 'Sacerdote do turno de Abias no Templo de Jerusalém; pai de João Batista (Lc 1:5).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_zacarias', 'pub_luc_zacarias', 'nascimento', -50, -50, 'cerca_de', 'cerca de 50 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_zacarias', 'pub_luc_zacarias', 'falecimento', 10, 10, 'cerca_de', '10 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_isabel', 'Santa Isabel', NULL, 'F', 'Esposa de Zacarias e mãe de João Batista; PARENTA (syngenis) de Maria (Lc 1:36).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_isabel', 'pub_luc_isabel', 'nascimento', -45, -45, 'cerca_de', 'cerca de 45 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_isabel', 'pub_luc_isabel', 'falecimento', 15, 15, 'cerca_de', '15 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_joao_batista', 'São João Batista', 'ben Zekaryah', 'M', 'Profeta precursor que batizou Jesus no Jordão; parente materno de Jesus (Lc 1:5-80; 3:1-20).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_joao_batista', 'pub_luc_joao_batista', 'nascimento', -5, -5, 'cerca_de', 'cerca de 5 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_joao_batista', 'pub_luc_joao_batista', 'falecimento', 29, 29, 'cerca_de', '29 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_jonas', 'Jonas', '(João bar Yonah)', 'M', 'Pescador de Betsaida; contemporâneo e parceiro de pesca de Zebedeu; pai de Pedro e André (Mt 16:17).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_jonas', 'pub_luc_jonas', 'nascimento', -40, -40, 'cerca_de', 'cerca de 40 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_jonas', 'pub_luc_jonas', 'falecimento', 15, 15, 'cerca_de', '15 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_pedro', 'São Pedro', '(Simão Cefas)', 'M', 'Apóstolo líder dos Doze; irmão de André; martirizado em Roma (Mt 16:18).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_pedro', 'pub_luc_pedro', 'nascimento', -1, -1, 'cerca_de', 'cerca de 1 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_pedro', 'pub_luc_pedro', 'falecimento', 67, 67, 'cerca_de', '67 d.C.');
INSERT OR REPLACE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria, tipo_tempo)
VALUES ('pub_luc_andre', 'Santo André', 'Apóstolo', 'M', 'Primeiro apóstolo chamado; irmão de Simão Pedro; ex-discípulo de João Batista (Jo 1:40).', 0, 0, 1, 'Bíblicas e Antiguidade', 'real');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_b_pub_luc_andre', 'pub_luc_andre', 'nascimento', -5, -5, 'cerca_de', 'cerca de 5 a.C.');
INSERT OR REPLACE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
VALUES ('ev_d_pub_luc_andre', 'pub_luc_andre', 'falecimento', 60, 60, 'cerca_de', '60 d.C.');
INSERT OR REPLACE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo, tipo_tempo)
VALUES ('pub_arv_jesus_lucas', 'Genealogia de Jesus (Lucas — Linhagem por Natã e Parentesco)', 'Linhagem universal de Jesus desde Davi por Natã até Heli e José, incluindo ramificações apostólicas e parentescos (Lucas 3:23-38).', 'pub_jesus_lucas', 1, 'Bíblicas e Antiguidade', 'Israel Antigo / Judeia', 'c. 1800 a.C. – c. 100 d.C.', 'real');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_abraao', 'pub_arv_jesus_lucas', 'pub_luc_abraao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_isaac', 'pub_arv_jesus_lucas', 'pub_luc_isaac', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jaco_patriarca', 'pub_arv_jesus_lucas', 'pub_luc_jaco_patriarca', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_juda', 'pub_arv_jesus_lucas', 'pub_luc_juda', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_perez', 'pub_arv_jesus_lucas', 'pub_luc_perez', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_esrom', 'pub_arv_jesus_lucas', 'pub_luc_esrom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_arao', 'pub_arv_jesus_lucas', 'pub_luc_arao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_aminadabe', 'pub_arv_jesus_lucas', 'pub_luc_aminadabe', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_naassom', 'pub_arv_jesus_lucas', 'pub_luc_naassom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_salmom', 'pub_arv_jesus_lucas', 'pub_luc_salmom', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_boaz', 'pub_arv_jesus_lucas', 'pub_luc_boaz', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_obede', 'pub_arv_jesus_lucas', 'pub_luc_obede', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jesse', 'pub_arv_jesus_lucas', 'pub_luc_jesse', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_davi', 'pub_arv_jesus_lucas', 'pub_luc_davi', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_nata', 'pub_arv_jesus_lucas', 'pub_luc_nata', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_matata', 'pub_arv_jesus_lucas', 'pub_luc_matata', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_mena', 'pub_arv_jesus_lucas', 'pub_luc_mena', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_meleia', 'pub_arv_jesus_lucas', 'pub_luc_meleia', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_eliaquim', 'pub_arv_jesus_lucas', 'pub_luc_eliaquim', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jona', 'pub_arv_jesus_lucas', 'pub_luc_jona', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jose_antigo', 'pub_arv_jesus_lucas', 'pub_luc_jose_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_juda_filho_jose', 'pub_arv_jesus_lucas', 'pub_luc_juda_filho_jose', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_simeao', 'pub_arv_jesus_lucas', 'pub_luc_simeao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_levi_antigo', 'pub_arv_jesus_lucas', 'pub_luc_levi_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_matat_antigo', 'pub_arv_jesus_lucas', 'pub_luc_matat_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jorim', 'pub_arv_jesus_lucas', 'pub_luc_jorim', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_eliezer', 'pub_arv_jesus_lucas', 'pub_luc_eliezer', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jesus_antigo', 'pub_arv_jesus_lucas', 'pub_luc_jesus_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_er', 'pub_arv_jesus_lucas', 'pub_luc_er', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_elmada', 'pub_arv_jesus_lucas', 'pub_luc_elmada', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_cosa', 'pub_arv_jesus_lucas', 'pub_luc_cosa', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_adi', 'pub_arv_jesus_lucas', 'pub_luc_adi', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_melqui_antigo', 'pub_arv_jesus_lucas', 'pub_luc_melqui_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_neri', 'pub_arv_jesus_lucas', 'pub_luc_neri', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_salatiel', 'pub_arv_jesus_lucas', 'pub_luc_salatiel', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_zorobabel', 'pub_arv_jesus_lucas', 'pub_luc_zorobabel', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_resa', 'pub_arv_jesus_lucas', 'pub_luc_resa', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_joana', 'pub_arv_jesus_lucas', 'pub_luc_joana', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_joda', 'pub_arv_jesus_lucas', 'pub_luc_joda', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jose_pos_exilio', 'pub_arv_jesus_lucas', 'pub_luc_jose_pos_exilio', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_semei', 'pub_arv_jesus_lucas', 'pub_luc_semei', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_matatias_antigo', 'pub_arv_jesus_lucas', 'pub_luc_matatias_antigo', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_maate', 'pub_arv_jesus_lucas', 'pub_luc_maate', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_nagai', 'pub_arv_jesus_lucas', 'pub_luc_nagai', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_esli', 'pub_arv_jesus_lucas', 'pub_luc_esli', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_naum', 'pub_arv_jesus_lucas', 'pub_luc_naum', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_amos', 'pub_arv_jesus_lucas', 'pub_luc_amos', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_matatias_recente', 'pub_arv_jesus_lucas', 'pub_luc_matatias_recente', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jose_recente', 'pub_arv_jesus_lucas', 'pub_luc_jose_recente', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_janai', 'pub_arv_jesus_lucas', 'pub_luc_janai', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_melqui_recente', 'pub_arv_jesus_lucas', 'pub_luc_melqui_recente', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_levi_recente', 'pub_arv_jesus_lucas', 'pub_luc_levi_recente', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_matat_recente', 'pub_arv_jesus_lucas', 'pub_luc_matat_recente', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_heli', 'pub_arv_jesus_lucas', 'pub_luc_heli', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jose', 'pub_arv_jesus_lucas', 'pub_luc_jose', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_maria', 'pub_arv_jesus_lucas', 'pub_luc_maria', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_jesus_lucas', 'pub_arv_jesus_lucas', 'pub_jesus_lucas', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_clopas', 'pub_arv_jesus_lucas', 'pub_luc_clopas', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_maria_clopas', 'pub_arv_jesus_lucas', 'pub_luc_maria_clopas', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_tiago_menor', 'pub_arv_jesus_lucas', 'pub_luc_tiago_menor', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_judas_tadeu', 'pub_arv_jesus_lucas', 'pub_luc_judas_tadeu', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jose_irmao', 'pub_arv_jesus_lucas', 'pub_luc_jose_irmao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_simao_irmao', 'pub_arv_jesus_lucas', 'pub_luc_simao_irmao', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_zebedeu', 'pub_arv_jesus_lucas', 'pub_luc_zebedeu', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_salome', 'pub_arv_jesus_lucas', 'pub_luc_salome', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_tiago_maior', 'pub_arv_jesus_lucas', 'pub_luc_tiago_maior', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_joao_evangelista', 'pub_arv_jesus_lucas', 'pub_luc_joao_evangelista', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_zacarias', 'pub_arv_jesus_lucas', 'pub_luc_zacarias', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_isabel', 'pub_arv_jesus_lucas', 'pub_luc_isabel', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_joao_batista', 'pub_arv_jesus_lucas', 'pub_luc_joao_batista', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_jonas', 'pub_arv_jesus_lucas', 'pub_luc_jonas', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_pedro', 'pub_arv_jesus_lucas', 'pub_luc_pedro', NULL);
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_pub_luc_andre', 'pub_arv_jesus_lucas', 'pub_luc_andre', NULL);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_abraao', 'pub_luc_abraao', 'pub_luc_abraao', 'nao_informado', 'Patriarcas de Israel (Lc 3:34)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_abraao', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_abraao');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_abraao', 'pub_luc_isaac', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_isaac', 'pub_luc_isaac', 'pub_luc_isaac', 'nao_informado', 'Patriarcas de Israel (Lc 3:34)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_isaac', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_isaac');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_isaac', 'pub_luc_jaco_patriarca', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jaco', 'pub_luc_jaco_patriarca', 'pub_luc_jaco_patriarca', 'nao_informado', 'Patriarcas de Israel (Lc 3:33)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jaco', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jaco');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jaco', 'pub_luc_juda', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_juda', 'pub_luc_juda', 'pub_luc_juda', 'nao_informado', 'Linhagem de Judá (Lc 3:33)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_juda', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_juda');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_juda', 'pub_luc_perez', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_perez', 'pub_luc_perez', 'pub_luc_perez', 'nao_informado', 'Linhagem de Judá (Lc 3:33)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_perez', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_perez');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_perez', 'pub_luc_esrom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_esrom', 'pub_luc_esrom', 'pub_luc_esrom', 'nao_informado', 'Linhagem no Egito (Lc 3:33)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_esrom', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_esrom');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_esrom', 'pub_luc_arao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_arao', 'pub_luc_arao', 'pub_luc_arao', 'nao_informado', 'Linhagem no Egito (Lc 3:33)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_arao', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_arao');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_arao', 'pub_luc_aminadabe', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_aminadabe', 'pub_luc_aminadabe', 'pub_luc_aminadabe', 'nao_informado', 'Linhagem do Êxodo (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_aminadabe', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_aminadabe');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_aminadabe', 'pub_luc_naassom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_naassom', 'pub_luc_naassom', 'pub_luc_naassom', 'nao_informado', 'Linhagem do Deserto (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_naassom', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_naassom');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_naassom', 'pub_luc_salmom', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_salmom', 'pub_luc_salmom', 'pub_luc_salmom', 'nao_informado', 'Linhagem em Canaã (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_salmom', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_salmom');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_salmom', 'pub_luc_boaz', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_boaz', 'pub_luc_boaz', 'pub_luc_boaz', 'nao_informado', 'Linhagem em Belém (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_boaz', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_boaz');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_boaz', 'pub_luc_obede', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_obede', 'pub_luc_obede', 'pub_luc_obede', 'nao_informado', 'Linhagem em Belém (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_obede', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_obede');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_obede', 'pub_luc_jesse', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jesse', 'pub_luc_jesse', 'pub_luc_jesse', 'nao_informado', 'Filhos de Jessé (Lc 3:32)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jesse', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jesse');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jesse', 'pub_luc_davi', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_davi', 'pub_luc_davi', 'pub_luc_davi', 'nao_informado', 'Davi gerou Natã (Lc 3:31)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_davi', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_davi');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_davi', 'pub_luc_nata', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_nata', 'pub_luc_nata', 'pub_luc_nata', 'nao_informado', 'Natã gerou Matatá (Lc 3:31)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_nata', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_nata');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_nata', 'pub_luc_matata', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_matata', 'pub_luc_matata', 'pub_luc_matata', 'nao_informado', 'Matatá gerou Mená (Lc 3:31)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_matata', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_matata');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matata', 'pub_luc_mena', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_mena', 'pub_luc_mena', 'pub_luc_mena', 'nao_informado', 'Mená gerou Meleia (Lc 3:31)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_mena', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_mena');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_mena', 'pub_luc_meleia', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_meleia', 'pub_luc_meleia', 'pub_luc_meleia', 'nao_informado', 'Meleia gerou Eliaquim (Lc 3:30)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_meleia', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_meleia');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_meleia', 'pub_luc_eliaquim', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_eliaquim', 'pub_luc_eliaquim', 'pub_luc_eliaquim', 'nao_informado', 'Eliaquim gerou Jonã (Lc 3:30)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_eliaquim', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_eliaquim');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_eliaquim', 'pub_luc_jona', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jona', 'pub_luc_jona', 'pub_luc_jona', 'nao_informado', 'Jonã gerou José (Lc 3:30)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jona', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jona');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jona', 'pub_luc_jose_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jose_antigo', 'pub_luc_jose_antigo', 'pub_luc_jose_antigo', 'nao_informado', 'José gerou Judá (Lc 3:30)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jose_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jose_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jose_antigo', 'pub_luc_juda_filho_jose', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_juda_filho_jose', 'pub_luc_juda_filho_jose', 'pub_luc_juda_filho_jose', 'nao_informado', 'Judá gerou Simeão (Lc 3:30)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_juda_filho_jose', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_juda_filho_jose');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_juda_filho_jose', 'pub_luc_simeao', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_simeao', 'pub_luc_simeao', 'pub_luc_simeao', 'nao_informado', 'Simeão gerou Levi (Lc 3:29)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_simeao', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_simeao');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_simeao', 'pub_luc_levi_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_levi_antigo', 'pub_luc_levi_antigo', 'pub_luc_levi_antigo', 'nao_informado', 'Levi gerou Matat (Lc 3:29)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_levi_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_levi_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_levi_antigo', 'pub_luc_matat_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_matat_antigo', 'pub_luc_matat_antigo', 'pub_luc_matat_antigo', 'nao_informado', 'Matat gerou Jorim (Lc 3:29)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_matat_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_matat_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matat_antigo', 'pub_luc_jorim', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jorim', 'pub_luc_jorim', 'pub_luc_jorim', 'nao_informado', 'Jorim gerou Eliezer (Lc 3:29)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jorim', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jorim');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jorim', 'pub_luc_eliezer', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_eliezer', 'pub_luc_eliezer', 'pub_luc_eliezer', 'nao_informado', 'Eliezer gerou Jesus/Josué (Lc 3:29)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_eliezer', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_eliezer');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_eliezer', 'pub_luc_jesus_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jesus_antigo', 'pub_luc_jesus_antigo', 'pub_luc_jesus_antigo', 'nao_informado', 'Jesus/Josué gerou Er (Lc 3:28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jesus_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jesus_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jesus_antigo', 'pub_luc_er', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_er', 'pub_luc_er', 'pub_luc_er', 'nao_informado', 'Er gerou Elmadã (Lc 3:28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_er', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_er');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_er', 'pub_luc_elmada', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_elmada', 'pub_luc_elmada', 'pub_luc_elmada', 'nao_informado', 'Elmadã gerou Cosã (Lc 3:28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_elmada', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_elmada');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_elmada', 'pub_luc_cosa', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_cosa', 'pub_luc_cosa', 'pub_luc_cosa', 'nao_informado', 'Cosã gerou Adi (Lc 3:28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_cosa', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_cosa');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_cosa', 'pub_luc_adi', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_adi', 'pub_luc_adi', 'pub_luc_adi', 'nao_informado', 'Adi gerou Melqui (Lc 3:28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_adi', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_adi');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_adi', 'pub_luc_melqui_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_melqui_antigo', 'pub_luc_melqui_antigo', 'pub_luc_melqui_antigo', 'nao_informado', 'Melqui gerou Neri (Lc 3:27-28)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_melqui_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_melqui_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_melqui_antigo', 'pub_luc_neri', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_neri', 'pub_luc_neri', 'pub_luc_neri', 'nao_informado', 'Neri gerou Salatiel (Lc 3:27)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_neri', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_neri');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_neri', 'pub_luc_salatiel', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_salatiel', 'pub_luc_salatiel', 'pub_luc_salatiel', 'nao_informado', 'Salatiel gerou Zorobabel (Lc 3:27)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_salatiel', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_salatiel');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_salatiel', 'pub_luc_zorobabel', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_zorobabel', 'pub_luc_zorobabel', 'pub_luc_zorobabel', 'nao_informado', 'Zorobabel gerou Resa (Lc 3:27)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_zorobabel', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_zorobabel');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_zorobabel', 'pub_luc_resa', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_resa', 'pub_luc_resa', 'pub_luc_resa', 'nao_informado', 'Resa gerou Joanã (Lc 3:27)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_resa', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_resa');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_resa', 'pub_luc_joana', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_joana', 'pub_luc_joana', 'pub_luc_joana', 'nao_informado', 'Joanã gerou Jodá (Lc 3:26)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_joana', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_joana');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_joana', 'pub_luc_joda', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_joda', 'pub_luc_joda', 'pub_luc_joda', 'nao_informado', 'Jodá gerou José (Lc 3:26)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_joda', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_joda');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_joda', 'pub_luc_jose_pos_exilio', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jose_pos_exilio', 'pub_luc_jose_pos_exilio', 'pub_luc_jose_pos_exilio', 'nao_informado', 'José gerou Semei (Lc 3:26)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jose_pos_exilio', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jose_pos_exilio');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jose_pos_exilio', 'pub_luc_semei', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_semei', 'pub_luc_semei', 'pub_luc_semei', 'nao_informado', 'Semei gerou Matatias (Lc 3:26)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_semei', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_semei');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_semei', 'pub_luc_matatias_antigo', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_matatias_antigo', 'pub_luc_matatias_antigo', 'pub_luc_matatias_antigo', 'nao_informado', 'Matatias gerou Maate (Lc 3:26)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_matatias_antigo', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_matatias_antigo');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matatias_antigo', 'pub_luc_maate', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_maate', 'pub_luc_maate', 'pub_luc_maate', 'nao_informado', 'Maate gerou Nagai (Lc 3:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_maate', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_maate');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_maate', 'pub_luc_nagai', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_nagai', 'pub_luc_nagai', 'pub_luc_nagai', 'nao_informado', 'Nagai gerou Esli (Lc 3:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_nagai', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_nagai');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_nagai', 'pub_luc_esli', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_esli', 'pub_luc_esli', 'pub_luc_esli', 'nao_informado', 'Esli gerou Naum (Lc 3:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_esli', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_esli');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_esli', 'pub_luc_naum', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_naum', 'pub_luc_naum', 'pub_luc_naum', 'nao_informado', 'Naum gerou Amós (Lc 3:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_naum', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_naum');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_naum', 'pub_luc_amos', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_amos', 'pub_luc_amos', 'pub_luc_amos', 'nao_informado', 'Amós gerou Matatias (Lc 3:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_amos', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_amos');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_amos', 'pub_luc_matatias_recente', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_matatias_recente', 'pub_luc_matatias_recente', 'pub_luc_matatias_recente', 'nao_informado', 'Matatias gerou José (Lc 3:24)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_matatias_recente', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_matatias_recente');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matatias_recente', 'pub_luc_jose_recente', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jose_recente', 'pub_luc_jose_recente', 'pub_luc_jose_recente', 'nao_informado', 'José gerou Janai (Lc 3:24)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jose_recente', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jose_recente');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jose_recente', 'pub_luc_janai', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_janai', 'pub_luc_janai', 'pub_luc_janai', 'nao_informado', 'Janai gerou Melqui (Lc 3:24)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_janai', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_janai');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_janai', 'pub_luc_melqui_recente', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_melqui_recente', 'pub_luc_melqui_recente', 'pub_luc_melqui_recente', 'nao_informado', 'Melqui gerou Levi (Lc 3:24)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_melqui_recente', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_melqui_recente');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_melqui_recente', 'pub_luc_levi_recente', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_levi_recente', 'pub_luc_levi_recente', 'pub_luc_levi_recente', 'nao_informado', 'Levi gerou Matat (Lc 3:24)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_levi_recente', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_levi_recente');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_levi_recente', 'pub_luc_matat_recente', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_matat_recente', 'pub_luc_matat_recente', 'pub_luc_matat_recente', 'nao_informado', 'Matat gerou Heli e a linhagem de Isabel (Lc 3:23-24; tradição patrística)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_matat_recente', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_matat_recente');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matat_recente', 'pub_luc_heli', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_matat_recente', 'pub_luc_isabel', 'biologico', 2);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_heli', 'pub_luc_heli', 'pub_luc_heli', 'nao_informado', 'Heli gerou José (legal), Clopas (irmão de José), Maria (Damasceno/Viterbo) e Salomé (Jo 19:25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_heli', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_heli');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_heli', 'pub_luc_jose', 'adotado', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_heli', 'pub_luc_clopas', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_heli', 'pub_luc_maria', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_heli', 'pub_luc_salome', 'biologico', 4);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jose_maria', 'pub_luc_jose', 'pub_luc_maria', 'casamento', 'Jesus, Filho de Deus e da Virgem Maria, sob custódia de São José (Lc 3:23)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jose_maria', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jose_maria');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jose_maria', 'pub_jesus_lucas', 'adotado', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_clopas_maria', 'pub_luc_clopas', 'pub_luc_maria_clopas', 'casamento', 'Clopas e Maria de Clopas geraram os apóstolos Tiago Menor, Judas Tadeu, José e Simão (os ''irmãos do Senhor'')');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_clopas_maria', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_clopas_maria');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_clopas_maria', 'pub_luc_tiago_menor', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_clopas_maria', 'pub_luc_judas_tadeu', 'biologico', 2);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_clopas_maria', 'pub_luc_jose_irmao', 'biologico', 3);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_clopas_maria', 'pub_luc_simao_irmao', 'biologico', 4);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_zebedeu_salome', 'pub_luc_zebedeu', 'pub_luc_salome', 'casamento', 'Zebedeu e Salomé geraram os apóstolos Tiago Maior e João Evangelista (Mt 4:21)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_zebedeu_salome', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_zebedeu_salome');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_zebedeu_salome', 'pub_luc_tiago_maior', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_zebedeu_salome', 'pub_luc_joao_evangelista', 'biologico', 2);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_zacarias_isabel', 'pub_luc_zacarias', 'pub_luc_isabel', 'casamento', 'Zacarias e Isabel geraram João Batista, precursor messiânico (Lc 1:5-25)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_zacarias_isabel', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_zacarias_isabel');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_zacarias_isabel', 'pub_luc_joao_batista', 'biologico', 1);
INSERT OR REPLACE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
VALUES ('pub_u_luc_jonas', 'pub_luc_jonas', 'pub_luc_jonas', 'nao_informado', 'Jonas gerou os apóstolos irmãos Simão Pedro e André (Mt 16:17; Jo 1:40)');
INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id) VALUES ('am_luc_u_pub_u_luc_jonas', 'pub_arv_jesus_lucas', NULL, 'pub_u_luc_jonas');
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jonas', 'pub_luc_pedro', 'biologico', 1);
INSERT OR REPLACE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
VALUES ('pub_u_luc_jonas', 'pub_luc_andre', 'biologico', 2);
