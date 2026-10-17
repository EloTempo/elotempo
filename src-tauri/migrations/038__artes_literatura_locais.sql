-- 038__artes_literatura_locais.sql
-- Locais históricos e cidades ligadas aos grandes gênios da Literatura e Artes Clássicas.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-gb-stratford', 'Stratford-upon-Avon', 'Warwickshire', 'gb', 52.1917, -1.7083, 'stratford-upon-avon'),
    ('loc-es-alcala', 'Alcalá de Henares', 'Madrid', 'es', 40.4819, -3.3635, 'alcala de henares'),
    ('loc-es-esquivias', 'Esquivias', 'Toledo', 'es', 40.1017, -3.7661, 'esquivias'),
    ('loc-fr-besancon', 'Besançon', 'Doubs', 'fr', 47.2378, 6.0241, 'besancon'),
    ('loc-gg-guernsey', 'Saint Peter Port', 'Guernsey', 'gb', 49.4583, -2.5350, 'saint peter port guernsey'),
    ('loc-de-augsburg', 'Augsburg', 'Baviera', 'de', 48.3705, 10.8978, 'augsburg'),
    ('loc-at-st-gilgen', 'Sankt Gilgen', 'Salzburgo', 'at', 47.7667, 13.3667, 'sankt gilgen'),
    ('loc-de-wetzlar', 'Wetzlar', 'Hesse', 'de', 50.5667, 8.5000, 'wetzlar'),
    ('loc-fr-villequier', 'Villequier', 'Sena Marítimo', 'fr', 49.5133, 0.6728, 'villequier');
