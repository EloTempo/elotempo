-- 044__grandes_genios_literatura_locais.sql
-- Centros históricos e palcos biográficos dos grandes gênios da literatura universal:
-- Argel (Cervantes), Weimar (Goethe), Estrasburgo (Goethe), Lepanto (Cervantes) e Jersey (Victor Hugo).

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-dz-algiers', 'Argel (Algiers)', 'Argel', 'dz', 36.7538, 3.0588, 'argel algiers algeria cervantes cativeiro'),
    ('loc-de-weimar', 'Weimar', 'Turíngia', 'de', 50.9803, 11.3290, 'weimar turingia thuringen goethe schiller classicismo'),
    ('loc-de-strasbourg', 'Estrasburgo (Strasbourg)', 'Alsácia', 'fr', 48.5734, 7.7521, 'estrasburgo strasbourg alsace goethe direito herder'),
    ('loc-gr-lepanto', 'Golfo de Lepanto (Náupacto)', 'Aetólia-Acarnânia', 'gr', 38.3917, 21.8278, 'lepanto naupactus grecia cervantes batalha 1571 liga santa'),
    ('loc-gb-jersey', 'Saint Helier (Jersey)', 'Jersey', 'gb', 49.1867, -2.1067, 'saint helier jersey ilhas do canal victor hugo exilio fotografia marine terrace');
