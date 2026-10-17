-- 036__revolucao_cientifica_locais.sql
-- Locais históricos e cidades ligadas à Revolução Científica e Invenção Tecnológica.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-de-ulm', 'Ulm', 'Baden-Württemberg', 'de', 48.4011, 9.9876, 'ulm'),
    ('loc-us-princeton', 'Princeton', 'NJ', 'us', 40.3573, -74.6672, 'princeton'),
    ('loc-gb-woolsthorpe', 'Woolsthorpe-by-Colsterworth', 'Lincolnshire', 'gb', 52.8080, -0.6300, 'woolsthorpe by colsterworth'),
    ('loc-gb-grantham', 'Grantham', 'Lincolnshire', 'gb', 52.9113, -0.6409, 'grantham'),
    ('loc-it-arcetri', 'Arcetri', 'Toscana', 'it', 43.7533, 11.2558, 'arcetri'),
    ('loc-it-vinci', 'Vinci', 'Toscana', 'it', 43.7844, 10.9258, 'vinci'),
    ('loc-fr-amboise', 'Amboise', 'Indre-et-Loire', 'fr', 47.4132, 0.9831, 'amboise'),
    ('loc-hr-smiljan', 'Smiljan', 'Lika-Senj', 'hr', 44.5644, 15.3189, 'smiljan'),
    ('loc-hr-gospic', 'Gospić', 'Lika-Senj', 'hr', 44.5461, 15.3747, 'gospic'),
    ('loc-us-milan-oh', 'Milan', 'OH', 'us', 41.2989, -82.6010, 'milan'),
    ('loc-us-porthuron', 'Port Huron', 'MI', 'us', 42.9709, -82.4249, 'port huron'),
    ('loc-us-menlopark', 'Menlo Park', 'NJ', 'us', 40.5573, -74.3418, 'menlo park'),
    ('loc-us-westorange', 'West Orange', 'NJ', 'us', 40.7987, -74.2390, 'west orange'),
    ('loc-us-coloradosprings', 'Colorado Springs', 'CO', 'us', 38.8339, -104.8214, 'colorado springs'),
    ('loc-us-fortmyers', 'Fort Myers', 'FL', 'us', 26.6406, -81.8723, 'fort myers');
