-- 024 — Linha do Tempo de Contexto: Independência do Brasil (1822)
--
-- Fontes: Museu Imperial; Arquivo Nacional; Biblioteca Nacional Digital; Museu Paulista/USP;
--         IHGB; Câmara dos Deputados; Academia Brasileira de Letras; Revista de História (USP).
--
-- Empacotada com o app e versionada como linha de contexto (fatia 07, seção 8).
-- Os gatilhos da migration 013 protegem esta referência contra alterações acidentais.

INSERT OR IGNORE INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-independencia-1822', 'historia', 'Independência do Brasil (1822)', 1, 1,
 'Cronologia documental da Independência e consolidação nacional (1820–1825). Fontes: Museu Imperial, Arquivo Nacional, IHGB, Museu Paulista e Câmara dos Deputados.');

INSERT OR IGNORE INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim, fonte_especifica) VALUES
('ind-1820-08-24', 'lt-independencia-1822', '24/08/1820', 'Revolução Liberal do Porto',
 'Militares e liberais portugueses rebelam-se no Porto exigindo o retorno imediato da Família Real a Lisboa, a redação de uma Constituição e a reversão do Brasil ao antigo estatuto colonial submisso.',
 'alta', 1820, 1820, 'Arquivo Nacional'),

('ind-1821-04-26', 'lt-independencia-1822', '26/04/1821', 'Retorno de D. João VI e Regência de D. Pedro',
 'D. João VI embarca de volta para Portugal sob pressão das Cortes, deixando seu herdeiro D. Pedro como Príncipe Regente do Brasil com o célebre conselho: "Se o Brasil se separar, antes seja para ti que me hás de respeitar, do que para algum desses aventureiros".',
 'alta', 1821, 1821, 'Museu Imperial'),

('ind-1821-12-09', 'lt-independencia-1822', '09/12/1821', 'Decretos das Cortes exigindo o retorno do Príncipe',
 'Chegam ao Rio de Janeiro os decretos nº 124 e 125 das Cortes de Lisboa extinguindo os órgãos de governo do Reino do Brasil e ordenando que o Príncipe Regente D. Pedro embarque imediatamente para a Europa.',
 'alta', 1821, 1821, 'IHGB'),

('ind-1822-01-09', 'lt-independencia-1822', '09/01/1822', 'Dia do Fico',
 'Respondendo à representação popular fluminense com milhares de assinaturas articulada por Joaquim Gonçalves Ledo e José Clemente Pereira, D. Pedro desobedece às Cortes: "Se é para o bem de todos e felicidade geral da Nação, estou pronto! Diga ao povo que fico!".',
 'alta', 1822, 1822, 'Revérbero Constitucional Fluminense'),

('ind-1822-01-16', 'lt-independencia-1822', '16/01/1822', 'Ministério dos Andradas',
 'D. Pedro nomeia o mineralogista e estadista santista José Bonifácio de Andrada e Silva como Ministro do Reino e Negócios Estrangeiros. É o primeiro gabinete governamental composto e liderado por brasileiros.',
 'alta', 1822, 1822, 'Câmara dos Deputados / IHGB'),

('ind-1822-02-19', 'lt-independencia-1822', '19/02/1822', 'Insurreição na Bahia e Mártir Sóror Joana Angélica',
 'Em Salvador, tropas do general português Madeira de Melo atacam rebeldes brasileiros. No Convento da Lapa, a abadessa Sóror Joana Angélica coloca o próprio corpo para proteger as noviças no claustro e é morta a golpes de baioneta, tornando-se a primeira mártir da Independência.',
 'alta', 1822, 1822, 'Convento da Lapa / Livro dos Heróis da Pátria'),

('ind-1822-05-04', 'lt-independencia-1822', '04/05/1822', 'Decreto do "Cumpra-se"',
 'Por proposta de José Bonifácio, D. Pedro decreta que nenhuma ordem, lei ou decisão das Cortes de Lisboa terá execução no Brasil sem a expressa anuência prévia e a fórmula do "Cumpra-se" do Príncipe Regente.',
 'alta', 1822, 1822, 'Coleção das Leis do Império do Brasil'),

('ind-1822-05-13', 'lt-independencia-1822', '13/05/1822', 'D. Pedro aclamado Defensor Perpétuo do Brasil',
 'O Senado da Câmara do Rio de Janeiro e a maçonaria congregada conferem solenemente ao Príncipe Regente o título cívico de "Defensor Perpétuo do Brasil", consolidando a aliança entre o trono e as elites emancipacionistas.',
 'alta', 1822, 1822, 'Biblioteca Nacional Digital'),

('ind-1822-06-03', 'lt-independencia-1822', '03/06/1822', 'Convocação da Assembleia Constituinte Brasileira',
 'D. Pedro atende à solicitação dos deputados do Conselho de Procuradores e convoca a primeira Assembleia Geral Constituinte e Legislativa do Brasil, ato equivalente à ruptura institucional de soberania com Lisboa.',
 'alta', 1822, 1822, 'Anais do Parlamento Brasileiro'),

('ind-1822-08-01', 'lt-independencia-1822', '01/08/1822', 'Manifesto aos Povos do Brasil',
 'Redigido pelo líder liberal Joaquim Gonçalves Ledo, o manifesto declara a união indissolúvel das províncias e alerta que o Brasil jamais voltará ao estado humilhante de colônia submissa.',
 'alta', 1822, 1822, 'Revérbero Constitucional Fluminense'),

('ind-1822-08-06', 'lt-independencia-1822', '06/08/1822', 'Manifesto às Nações Amigas',
 'Redigido pelo Ministro José Bonifácio, o manifesto expõe à Europa e aos governos mundiais a ilegitimidade das Cortes portuguesas e proclama o direito inalienável do Brasil à autodeterminação e soberania.',
 'alta', 1822, 1822, 'Cartas Andradinas / Arquivo Nacional'),

('ind-1822-08-14', 'lt-independencia-1822', '14/08/1822', 'Jornada a São Paulo e Regência de Dona Leopoldina',
 'D. Pedro parte a cavalo para apaziguar conflitos políticos na Província de São Paulo. A Princesa Dona Maria Leopoldina assume a Regência Interina do Brasil no Palácio de São Cristóvão com plenos poderes decisórios.',
 'alta', 1822, 1822, 'Museu Imperial'),

('ind-1822-08-25', 'lt-independencia-1822', '25/08/1822', 'Encontro com Domitila de Castro em São Paulo',
 'Em visita a São Paulo, D. Pedro conhece a jovem aristocrata paulista Domitila de Castro do Canto e Melo, iniciando uma célebre relação que a tornaria a futura Marquesa de Santos e figura de destaque na corte imperial.',
 'alta', 1822, 1822, 'Museu Paulista / Acervo Casa da Marquesa'),

('ind-1822-08-29', 'lt-independencia-1822', '29/08/1822', 'Resistência Armada e Guerra na Bahia',
 'No Recôncavo Baiano, patriotas organizam milícias de guerrilha contra as tropas lusitanas. Maria Quitéria de Jesus alista-se disfarçada como "Soldado Medeiros" no Regimento de Artilharia, enquanto Maria Felipa de Oliveira lidera marisqueiras e negros na queima de embarcações portuguesas em Itaparica.',
 'alta', 1822, 1822, 'Historiografia Militar da Bahia / Impressões Rebeldes'),

('ind-1822-09-02', 'lt-independencia-1822', '02/09/1822', 'Sessão Histórica do Conselho de Estado de Dona Leopoldina',
 'Diante de novos ultimatos e ameaças armadas de Lisboa, a Regente Dona Leopoldina reúne o Conselho de Estado no Paço Imperial e assina o decreto da separação definitiva: "O pomo está maduro, colhei-o já senão apodrece". As cartas urgentes são despachadas com o correio Paulo Bregaro em direção a D. Pedro.',
 'alta', 1822, 1822, 'Museu Imperial / Arquivo Nacional'),

('ind-1822-09-07', 'lt-independencia-1822', '07/09/1822', 'O Grito do Ipiranga',
 'Alcançado pelo correio Paulo Bregaro às margens do riacho Ipiranga em São Paulo, D. Pedro lê as cartas de Dona Leopoldina e José Bonifácio. Arrastando os laços azuis e brancos de Portugal de seu uniforme, saca a espada e brada: "Independência ou Morte! Laços fora, soldados! Estamos separados de Portugal!".',
 'alta', 1822, 1822, 'Museu Paulista / Museu Imperial'),

('ind-1822-09-21', 'lt-independencia-1822', '21/09/1822', 'Hino da Independência do Brasil',
 'Primeira apresentação pública do Hino da Independência, com partitura e melodia compostas pelo próprio D. Pedro I e versos patrióticos do poeta Evaristo da Veiga: "Brava gente brasileira! Longe vá temor servil: Ou ficar a pátria livre, ou morrer pelo Brasil!".',
 'alta', 1822, 1822, 'Biblioteca Nacional Digital'),

('ind-1822-10-12', 'lt-independencia-1822', '12/10/1822', 'Aclamação de Dom Pedro I Imperador Constitucional',
 'No dia em que completava 24 anos, perante uma multidão eufórica no Campo de Santana (atual Praça da República, Rio de Janeiro), D. Pedro é solenemente aclamado como o primeiro Imperador Constitucional e Defensor Perpétuo do Brasil.',
 'alta', 1822, 1822, 'Arquivo da Casa Imperial'),

('ind-1822-10-25', 'lt-independencia-1822', '25/10/1822', 'Cisão Maçônica e Fechamento do Grande Oriente',
 'A rivalidade ferrenha entre a facção maçônica Azul (conservadora/monarquista, liderada pelos Andradas) e a Vermelha (liberal-republicana, liderada por Gonçalves Ledo) culmina na dissolução e no fechamento temporário das lojas maçônicas por decreto imperial.',
 'alta', 1822, 1822, 'Revista de História (USP)'),

('ind-1822-12-01', 'lt-independencia-1822', '01/12/1822', 'Sagração e Coroação Imperial de Dom Pedro I',
 'Realizada com rito católico pontifical na Capela Imperial do Rio de Janeiro a consagração e coroação solene de Dom Pedro I como Monarca soberano do Império do Brasil.',
 'alta', 1822, 1822, 'Arquivo Nacional'),

('ind-1823-03-13', 'lt-independencia-1822', '13/03/1823', 'Batalha do Jenipapo (Piauí)',
 'Nas barrancas do rio Jenipapo, vaqueiros e sertanejos armados de foices, machados e espingardas enfrentam as tropas de linha do brigadeiro português João José da Cunha Fidié, impedindo a fragmentação do Norte e consolidando a unidade territorial brasileira.',
 'alta', 1823, 1823, 'Exército Brasileiro / IHGB'),

('ind-1823-05-03', 'lt-independencia-1822', '03/05/1823', 'Abertura da Assembleia Constituinte de 1823',
 'Instalação solene dos trabalhos da Assembleia Constituinte, onde os deputados Antônio Carlos, Martim Francisco e José Bonifácio lideram a redação do primeiro anteprojeto constitucional brasileiro (a "Constituição da Mandioca").',
 'alta', 1823, 1823, 'Câmara dos Deputados'),

('ind-1823-07-02', 'lt-independencia-1822', '02/07/1823', 'Dois de Julho e Vitória na Guerra da Bahia',
 'Após mais de um ano de sangrentos combates terrestres e navais, o Exército Pacificador entra vitorioso em Salvador com a capitulação e expulsão das forças portuguesas de Madeira de Melo. Maria Quitéria é condecorada por bravura e aclamada como símbolo militar.',
 'alta', 1823, 1823, 'Arquivo Público do Estado da Bahia'),

('ind-1823-11-12', 'lt-independencia-1822', '12/11/1823', 'A Noite da Agonia e Dissolução da Constituinte',
 'Conflitos agudos de prerrogativas entre os deputados liberais e o Imperador levam D. Pedro I a ordenar o cerco militar do parlamento com canhões e cavalaria. A Assembleia é dissolvida à força; os irmãos José Bonifácio, Antônio Carlos e Martim Francisco são presos na Fortaleza da Laje e banidos para o exílio na França.',
 'alta', 1823, 1823, 'Anais do Parlamento / Cartas Andradinas'),

('ind-1824-03-25', 'lt-independencia-1822', '25/03/1824', 'Outorga da Constituição Imperial de 1824',
 'D. Pedro I outorga solenemente a primeira Constituição do Império do Brasil, estruturada em quatro poderes de Estado (Executivo, Legislativo, Judiciário e o exclusivo Poder Moderador reservado ao Imperador).',
 'alta', 1824, 1824, 'Constituição Política do Império do Brasil'),

('ind-1824-07-02', 'lt-independencia-1822', '02/07/1824', 'Confederação do Equador em Pernambuco',
 'Em reação à dissolução arbitrária da Constituinte e à imposição da Carta de 1824, insurrecionistas no Nordeste proclamam a Confederação do Equador sob a liderança intelectual do frade carmelita e jornalista Frei Caneca.',
 'alta', 1824, 1824, 'Typhis Pernambucano / Biblioteca do Senado'),

('ind-1825-01-13', 'lt-independencia-1822', '13/01/1825', 'Martírio de Frei Caneca no Recife',
 'Após o esmagamento militar da Confederação do Equador pelas forças imperiais, Frei Caneca é condenado à forca. Três carrascos recusam-se a enforcar o padre carmelita, que acaba sendo fuzilado no Forte das Cinco Pontas em Recife.',
 'alta', 1825, 1825, 'Biblioteca Digital do Senado'),

('ind-1825-08-29', 'lt-independencia-1822', '29/08/1825', 'Tratado de Paz e Reconhecimento de Portugal',
 'Após mediação diplomática britânica conduzida por Sir Charles Stuart, o Reino de Portugal assina o Tratado do Rio de Janeiro reconhecendo formal e definitivamente o Império do Brasil como nação independente.',
 'alta', 1825, 1825, 'Arquivo Histórico do Itamaraty');
