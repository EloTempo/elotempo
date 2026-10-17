-- 042__pais_fundadores_estadistas_locais.sql
-- Locais históricos ligados aos Pais Fundadores e Estadistas das Américas (Independência do Brasil e EUA, Guerra Civil).

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-br-piraja', 'Pirajá', 'BA', 'br', -12.8942, -38.4594, 'piraja salvador bahia batalha'),
    ('loc-br-ipiranga', 'Riacho do Ipiranga', 'SP', 'br', -23.5850, -46.6097, 'ipiranga riacho sao paulo independencia'),
    ('loc-us-yorktown', 'Yorktown', 'VA', 'us', 37.2388, -76.5097, 'yorktown virginia batalha independencia'),
    ('loc-us-gettysburg', 'Gettysburg', 'PA', 'us', 39.8309, -77.2311, 'gettysburg pennsylvania discurso lincoln');
