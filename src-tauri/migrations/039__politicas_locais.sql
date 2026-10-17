-- 039__politicas_locais.sql
-- Locais históricos e cidades ligadas às grandes dinastias políticas do Século XX.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-us-rye', 'Rye', 'Nova York', 'us', 40.9807, -73.6837, 'rye'),
    ('loc-ie-newross', 'New Ross', 'Wexford', 'ie', 52.3964, -6.9442, 'new ross'),
    ('loc-ie-dunganstown', 'Dunganstown', 'Wexford', 'ie', 52.3667, -6.9500, 'dunganstown'),
    ('loc-ar-riogallegos', 'Río Gallegos', 'Santa Cruz', 'ar', -51.6230, -69.2168, 'rio gallegos'),
    ('loc-ar-giles', 'San Andrés de Giles', 'Buenos Aires', 'ar', -35.9833, -59.4500, 'san andres de giles');
