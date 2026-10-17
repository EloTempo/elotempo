-- 041__revolucao_cientifica_darwin_curie_locais.sql
-- Locais históricos e cidades ligadas aos pioneiros da física, química e evolução (Curie e Darwin-Wedgwood).

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-gb-stokeontrent', 'Stoke-on-Trent', 'Staffordshire', 'gb', 53.0027, -2.1794, 'stoke on trent etruria'),
    ('loc-fr-sceaux', 'Sceaux', 'Hauts-de-Seine', 'fr', 48.7772, 2.2961, 'sceaux'),
    ('loc-fr-arcueil', 'Arcueil', 'Val-de-Marne', 'fr', 48.8078, 2.3347, 'arcueil');
