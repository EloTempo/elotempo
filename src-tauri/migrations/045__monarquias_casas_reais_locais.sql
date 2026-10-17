-- 045__monarquias_casas_reais_locais.sql
-- Sedes dinásticas, centros palacianos e panteões reais das grandes monarquias europeias:
-- San Lorenzo de El Escorial, Castelo de Windsor, Castelo de Balmoral, Mônaco, Vaduz, Luxemburgo e Pau.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-es-escorial', 'San Lorenzo de El Escorial', 'Comunidade de Madrid', 'es', 40.5890, -4.1478, 'el escorial san lorenzo filipe ii panteao monarquia espanha habsburgo bourbon'),
    ('loc-gb-windsor', 'Windsor', 'Berkshire', 'gb', 51.4839, -0.6044, 'windsor castelo berkshire inglaterra reino unido monarquia vitoria elizabeth'),
    ('loc-gb-balmoral', 'Castelo de Balmoral (Crathie)', 'Aberdeenshire', 'gb', 57.0397, -3.2282, 'balmoral crathie aberdeenshire escocia highlands vitoria elizabeth residencia real'),
    ('loc-mc-monaco', 'Mônaco-Ville (Monte Carlo)', 'Mônaco', 'mc', 43.7311, 7.4197, 'monaco monte carlo principado palacio principes grimaldi rainier grace kelly'),
    ('loc-li-vaduz', 'Vaduz', 'Vaduz', 'li', 47.1410, 9.5215, 'vaduz liechtenstein principado castelo de vaduz hans adam'),
    ('loc-lu-luxembourg', 'Cidade de Luxemburgo', 'Luxemburgo', 'lu', 49.6116, 6.1319, 'luxemburgo luxembourg grao-ducado palacio grao-ducal'),
    ('loc-fr-pau', 'Pau', 'Pirenéus Atlânticos', 'fr', 43.2951, -0.3708, 'pau bearn pireneus atlanticos berco henrique iv castelo de pau frança');
