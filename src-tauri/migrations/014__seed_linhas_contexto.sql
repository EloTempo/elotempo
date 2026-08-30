-- 014 — Conteúdo das quatro primeiras linhas de contexto (fatia 07).
--
-- Empacotadas com o app e versionadas, como a seção 8 determina. Corrigir um
-- marco é escrever uma migration nova — os gatilhos da 013 recusam UPDATE e
-- DELETE, e é isso que dá rastro a uma referência bibliográfica.
--
-- SOBRE A RELEVÂNCIA
-- A gaveta mostra só `alta`; o estúdio (fatia futura) mostrará tudo. Aqui isso
-- vira uma salvaguarda editorial: marcos de que não tenho certeza entram como
-- `media` e **não sobem à gaveta** até serem conferidos. É melhor faltar um
-- marco do que afirmar uma data errada com ar de referência.
--
-- Só fatos: títulos, datas, nomes. Nenhum conteúdo protegido (seção 8).

-- =====================================================================
-- LINHA 1 — História do Brasil
-- Fonte: Instruções/linha-tempo-brasil.md, revisado pelo autor do projeto.
-- Conteúdo transcrito sem alteração.
-- =====================================================================
INSERT INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-brasil','historia','História do Brasil',1,1,
 'Marcos de amplo consenso historiográfico, da chegada dos portugueses (1500) à pandemia de COVID-19.');

INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim) VALUES
('br-1500','lt-brasil','1500','Chegada dos portugueses','Esquadra de Pedro Álvares Cabral aporta no litoral, na atual Bahia.','alta',1500,1500),
('br-1532','lt-brasil','1532','Fundação de São Vicente','Primeira vila portuguesa; início efetivo da colonização.','alta',1532,1532),
('br-1534','lt-brasil','1534','Capitanias hereditárias','Território dividido em lotes doados a donatários.','alta',1534,1534),
('br-1549','lt-brasil','1549','Governo-geral e Salvador','Tomé de Sousa; fundação de Salvador, primeira capital, e chegada dos jesuítas.','alta',1549,1549),
('br-1554','lt-brasil','1554','Fundação de São Paulo','Colégio jesuíta de São Paulo de Piratininga.','alta',1554,1554),
('br-1565','lt-brasil','1565','Fundação do Rio de Janeiro',NULL,'alta',1565,1565),
('br-1580','lt-brasil','1580–1640','União Ibérica','Coroas de Portugal e Espanha unidas.','alta',1580,1640),
('br-1630','lt-brasil','1630–1654','Brasil holandês','Ocupação neerlandesa em Pernambuco (Nova Holanda).','alta',1630,1654),
('br-1695','lt-brasil','c. 1695','Ouro em Minas Gerais','Início do ciclo do ouro.','alta',1690,1700),
('br-1763','lt-brasil','1763','Capital para o Rio','Transferência da capital de Salvador para o Rio de Janeiro.','alta',1763,1763),
('br-1789','lt-brasil','1789','Inconfidência Mineira','Movimento separatista; Tiradentes.','alta',1789,1789),
('br-1808','lt-brasil','1808','Chegada da Corte','Família real portuguesa no Brasil; abertura dos portos.','alta',1808,1808),
('br-1815','lt-brasil','1815','Reino Unido','Brasil elevado a Reino Unido de Portugal, Brasil e Algarves.','alta',1815,1815),
('br-1822','lt-brasil','1822','Independência','7 de setembro; D. Pedro I imperador.','alta',1822,1822),
('br-1824','lt-brasil','1824','Primeira Constituição','Constituição outorgada do Império.','alta',1824,1824),
('br-1831','lt-brasil','1831','Abdicação','D. Pedro I abdica; início do período regencial.','alta',1831,1831),
('br-1840','lt-brasil','1840','Golpe da Maioridade','D. Pedro II assume o trono.','alta',1840,1840),
('br-1850','lt-brasil','1850','Fim do tráfico','Lei Eusébio de Queirós; Lei de Terras.','alta',1850,1850),
('br-1864','lt-brasil','1864–1870','Guerra do Paraguai',NULL,'alta',1864,1870),
('br-1871','lt-brasil','1871','Lei do Ventre Livre',NULL,'alta',1871,1871),
('br-1888','lt-brasil','1888','Lei Áurea','Abolição da escravidão, 13 de maio.','alta',1888,1888),
('br-1889','lt-brasil','1889','Proclamação da República','15 de novembro.','alta',1889,1889),
('br-1891','lt-brasil','1891','Primeira Constituição republicana',NULL,'alta',1891,1891),
('br-1897','lt-brasil','1897','Fim da Guerra de Canudos',NULL,'alta',1897,1897),
('br-1930','lt-brasil','1930','Revolução de 1930','Getúlio Vargas ao poder.','alta',1930,1930),
('br-1932','lt-brasil','1932','Voto feminino','Código Eleitoral garante o voto às mulheres.','alta',1932,1932),
('br-1937','lt-brasil','1937–1945','Estado Novo','Ditadura de Vargas.','alta',1937,1945),
('br-1942','lt-brasil','1942–1945','Brasil na Segunda Guerra Mundial','A FEB combate na Itália.','alta',1942,1945),
('br-1945','lt-brasil','1945','Redemocratização','Fim do Estado Novo.','alta',1945,1945),
('br-1946','lt-brasil','1946','Nova Constituição',NULL,'alta',1946,1946),
('br-1960','lt-brasil','1960','Inauguração de Brasília','Nova capital federal.','alta',1960,1960),
('br-1964','lt-brasil','1964–1985','Regime militar','Golpe de 1964; o regime se estende até a Nova República.','alta',1964,1985),
('br-1968','lt-brasil','1968','AI-5','Endurecimento do regime.','alta',1968,1968),
('br-1985','lt-brasil','1985','Nova República','Fim do regime militar.','alta',1985,1985),
('br-1988','lt-brasil','1988','Constituição Cidadã','Constituição vigente.','alta',1988,1988),
('br-1989','lt-brasil','1989','Eleição direta','Primeira eleição presidencial direta desde 1960.','alta',1989,1989),
('br-1992','lt-brasil','1992','Impeachment de Collor',NULL,'alta',1992,1992),
('br-1994','lt-brasil','1994','Plano Real','Estabilização da moeda.','alta',1994,1994),
('br-2002','lt-brasil','2002','Eleição de Lula',NULL,'alta',2002,2002),
('br-2010','lt-brasil','2010','Eleição de Dilma','Primeira presidenta do Brasil.','alta',2010,2010),
('br-2016','lt-brasil','2016','Impeachment de Dilma',NULL,'alta',2016,2016),
('br-2019','lt-brasil','2019–2020','Pandemia de COVID-19','Surge no fim de 2019; chega ao Brasil em fevereiro e março de 2020.','alta',2019,2020);

-- =====================================================================
-- LINHA 2 — Presidentes da República
-- Fonte: Instruções/linha-tempo-brasil.md. Intervalos de mandato; a saída de
-- cada um coincide com a posse do seguinte, salvo renúncia ou afastamento.
-- =====================================================================
INSERT INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-presidentes','politica','Presidentes da República',1,1,
 'A partir de João Figueiredo, por ter governado o início da década de 1980.');

INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim) VALUES
('pr-figueiredo','lt-presidentes','15/03/1979 – 15/03/1985','João Figueiredo','Último presidente do regime militar.','alta',1979,1985),
('pr-tancredo','lt-presidentes','1985','Tancredo Neves','Eleito pelo Colégio Eleitoral; faleceu antes de tomar posse.','alta',1985,1985),
('pr-sarney','lt-presidentes','15/03/1985 – 15/03/1990','José Sarney','Vice de Tancredo; assumiu em seu lugar.','alta',1985,1990),
('pr-collor','lt-presidentes','15/03/1990 – 29/12/1992','Fernando Collor de Mello','Renunciou durante o processo de impeachment.','alta',1990,1992),
('pr-itamar','lt-presidentes','29/12/1992 – 01/01/1995','Itamar Franco','Vice; assumiu após a saída de Collor.','alta',1992,1995),
('pr-fhc','lt-presidentes','01/01/1995 – 01/01/2003','Fernando Henrique Cardoso','Dois mandatos.','alta',1995,2003),
('pr-lula1','lt-presidentes','01/01/2003 – 01/01/2011','Luiz Inácio Lula da Silva','Dois mandatos.','alta',2003,2011),
('pr-dilma','lt-presidentes','01/01/2011 – 31/08/2016','Dilma Rousseff','Primeira presidenta; afastada por impeachment.','alta',2011,2016),
('pr-temer','lt-presidentes','31/08/2016 – 01/01/2019','Michel Temer','Vice; interino desde 12/05/2016, efetivado com o impeachment.','alta',2016,2019),
('pr-bolsonaro','lt-presidentes','01/01/2019 – 01/01/2023','Jair Bolsonaro',NULL,'alta',2019,2023),
('pr-lula3','lt-presidentes','01/01/2023 –','Luiz Inácio Lula da Silva','Terceiro mandato, não consecutivo.','alta',2023,2026);

-- =====================================================================
-- LINHA 3 — A moeda de cada época
-- Intervalos contíguos: é o que mostra a troca de dinheiro como a vida real a
-- sentiu. "O dinheiro do bolso dele se chamava mil-réis" situa uma pessoa numa
-- época melhor do que muita data.
-- =====================================================================
INSERT INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-moeda','moeda','A moeda de cada época',1,1,
 'Padrões monetários brasileiros. Os anos marcam a vigência de cada padrão.');

INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim) VALUES
('mo-reis','lt-moeda','até 1942','Réis (mil-réis)','A moeda do Império e da Primeira República. Escrevia-se 1:000$000 para um conto de réis.','alta',1808,1942),
('mo-cruzeiro1','lt-moeda','1942–1967','Cruzeiro','Substitui o mil-réis na reforma de 1942.','alta',1942,1967),
('mo-cruzeiro-novo','lt-moeda','1967–1970','Cruzeiro Novo','Corta três zeros do cruzeiro.','alta',1967,1970),
('mo-cruzeiro2','lt-moeda','1970–1986','Cruzeiro','Volta a se chamar apenas cruzeiro.','alta',1970,1986),
('mo-cruzado','lt-moeda','1986–1989','Cruzado','Plano Cruzado.','alta',1986,1989),
('mo-cruzado-novo','lt-moeda','1989–1990','Cruzado Novo','Plano Verão.','alta',1989,1990),
('mo-cruzeiro3','lt-moeda','1990–1993','Cruzeiro','Plano Collor.','alta',1990,1993),
('mo-cruzeiro-real','lt-moeda','1993–1994','Cruzeiro Real','Transição para o Real.','alta',1993,1994),
('mo-real','lt-moeda','1994 –','Real','Plano Real; moeda vigente.','alta',1994,2026);

-- =====================================================================
-- LINHA 4 — Tecnologias de acesso público
--
-- ATENÇÃO À CURADORIA: as datas de chegada ao Brasil diferem das mundiais, e é
-- onde a redação automática mais erra. Só entram como `alta` os marcos de
-- consenso amplo; os demais ficam em `media` e NÃO aparecem na gaveta até
-- serem conferidos por quem mantém o acervo.
-- =====================================================================
INSERT INTO linhas_tempo (id, categoria, titulo, is_contexto, is_bloqueada, fonte_referencia) VALUES
('lt-tecnologia','tecnologia','Tecnologias de acesso público',1,1,
 'Chegada ao Brasil, não invenção. Marcos em relevância "media" aguardam conferência.');

INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim) VALUES
('tec-radio','lt-tecnologia','1922','Rádio no Brasil','Primeira transmissão pública, nas comemorações do centenário da Independência.','alta',1922,1922),
('tec-tv','lt-tecnologia','1950','Televisão no Brasil','TV Tupi, primeira emissora do país e da América do Sul.','alta',1950,1950),
('tec-tv-cores','lt-tecnologia','1972','TV em cores','Primeiras transmissões em cores no Brasil.','alta',1972,1972),
('tec-internet','lt-tecnologia','1995','Internet comercial no Brasil','Abertura da internet ao público, além do meio acadêmico.','alta',1995,1995),
-- Daqui para baixo, aguardando conferência. Ficam fora da gaveta.
('tec-automovel','lt-tecnologia','1957','Automóvel de fabricação nacional','Início da produção em escala no país.','media',1957,1957),
('tec-geladeira','lt-tecnologia','década de 1950','Geladeira no lar brasileiro','Difusão nos centros urbanos.','media',1950,1960),
('tec-telefone','lt-tecnologia','década de 1970','Telefone residencial','Difusão; a linha telefônica era bem de valor patrimonial.','media',1970,1980),
('tec-videocassete','lt-tecnologia','década de 1980','Videocassete',NULL,'media',1980,1990),
('tec-pc','lt-tecnologia','década de 1980','Computador pessoal',NULL,'media',1980,1990),
('tec-celular','lt-tecnologia','1990','Telefonia celular no Brasil','Primeiras operações comerciais.','media',1990,1990),
('tec-banda-larga','lt-tecnologia','início dos anos 2000','Internet em banda larga',NULL,'media',2000,2005),
('tec-smartphone','lt-tecnologia','a partir de 2008','Smartphone','Difusão do celular com internet.','media',2008,2015);
