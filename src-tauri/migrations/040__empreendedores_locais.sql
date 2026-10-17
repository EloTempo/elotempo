-- 040__empreendedores_locais.sql
-- Locais históricos e cidades ligadas aos grandes empreendedores e pioneiros industriais.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-us-tarrytown', 'Tarrytown', 'Nova York', 'us', 41.0762, -73.8587, 'tarrytown'),
    ('loc-us-sleepyhollow', 'Sleepy Hollow', 'Nova York', 'us', 41.0854, -73.8585, 'sleepy hollow'),
    ('loc-lt-vilnius', 'Vilnius', 'Vilnius', 'lt', 54.6872, 25.2797, 'vilnius'),
    ('loc-lt-kaunas', 'Kaunas', 'Kaunas', 'lt', 54.8985, 23.9036, 'kaunas'),
    ('loc-lt-zarasai', 'Zarasai', 'Utena', 'lt', 55.7333, 26.2500, 'zarasai');
