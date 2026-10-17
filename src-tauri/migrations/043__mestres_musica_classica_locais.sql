-- 043__mestres_musica_classica_locais.sql
-- Cidades históricas e centros musicais europeus ligados a Bach, Mozart e Beethoven.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-at-baden', 'Baden bei Wien', 'Baixa Áustria', 'at', 48.0069, 16.2308, 'baden bei wien austria beethoven mozart'),
    ('loc-de-eisenach', 'Eisenach', 'Turíngia', 'de', 50.9747, 10.3244, 'eisenach thuringen bach'),
    ('loc-de-kothen', 'Köthen', 'Saxônia-Anhalt', 'de', 51.7533, 11.9744, 'kothen anhalt bach brandemburgo'),
    ('loc-at-rohrau', 'Rohrau', 'Baixa Áustria', 'at', 48.0667, 16.9500, 'rohrau austria haydn');
