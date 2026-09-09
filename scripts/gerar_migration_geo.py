import urllib.request
import csv
import io
import os

print("Baixando coordenadas dos municípios brasileiros (IBGE)...")
url = 'https://raw.githubusercontent.com/kelvins/Municipios-Brasileiros/main/csv/municipios.csv'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
content = urllib.request.urlopen(req).read().decode('utf-8')

reader = csv.DictReader(io.StringIO(content))
ibge_coords = []
for row in reader:
    ibge_coords.append((row['codigo_ibge'], float(row['latitude']), float(row['longitude'])))

print(f"Lidos {len(ibge_coords)} municípios brasileiros com sucesso.")

cidades_historicas = [
    ('Lisboa', 'pt', 38.7223, -9.1393),
    ('Porto', 'pt', 41.1579, -8.6291),
    ('Coimbra', 'pt', 40.2033, -8.4103),
    ('Queluz', 'pt', 38.7566, -9.2545),
    ('Roma', 'it', 41.9028, 12.4964),
    ('Nápoles', 'it', 40.8518, 14.2681),
    ('Madrid', 'es', 40.4168, -3.7038),
    ('Berlim', 'de', 52.5200, 13.4050),
    ('Tóquio', 'jp', 35.6762, 139.6503),
    ('Paris', 'fr', 48.8566, 2.3522),
    ('Londres', 'gb', 51.5074, -0.1278),
]

caminho_saida = os.path.join(os.path.dirname(__file__), '..', 'src-tauri', 'migrations', '027__locais_coordenadas.sql')

with open(caminho_saida, 'w', encoding='utf-8') as f:
    f.write("-- 027 — Coordenadas Geográficas (Latitude e Longitude) para Municípios e Locais\n")
    f.write("--\n")
    f.write("-- Suporta a visualização de mapas interativos e trajetórias de vida.\n\n")
    f.write("ALTER TABLE locais ADD COLUMN latitude REAL;\n")
    f.write("ALTER TABLE locais ADD COLUMN longitude REAL;\n\n")
    f.write("CREATE INDEX IF NOT EXISTS ix_locais_geo ON locais (latitude, longitude) WHERE latitude IS NOT NULL;\n\n")

    f.write("-- Atualização dos municípios do IBGE com Latitude e Longitude\n")
    f.write("CREATE TEMP TABLE temp_geo (codigo_ibge TEXT PRIMARY KEY, lat REAL, lon REAL);\n")
    f.write("INSERT INTO temp_geo (codigo_ibge, lat, lon) VALUES\n")
    
    val_lines = []
    for cod, lat, lon in ibge_coords:
        val_lines.append(f"('{cod}', {lat}, {lon})")
    
    chunk_size = 500
    for i in range(0, len(val_lines), chunk_size):
        chunk = val_lines[i:i+chunk_size]
        if i > 0:
            f.write("INSERT INTO temp_geo (codigo_ibge, lat, lon) VALUES\n")
        f.write(",\n".join(chunk))
        f.write(";\n")

    f.write("\n-- Atualização em massa indexada dos municípios brasileiros\n")
    f.write("UPDATE locais SET\n")
    f.write("  latitude = (SELECT lat FROM temp_geo WHERE temp_geo.codigo_ibge = locais.codigo_ibge),\n")
    f.write("  longitude = (SELECT lon FROM temp_geo WHERE temp_geo.codigo_ibge = locais.codigo_ibge)\n")
    f.write("WHERE codigo_ibge IN (SELECT codigo_ibge FROM temp_geo);\n\n")
    f.write("DROP TABLE temp_geo;\n\n")

    f.write("-- Cidades históricas conhecidas que já possam existir no acervo\n")
    for nome, pais, lat, lon in cidades_historicas:
        f.write(f"UPDATE locais SET latitude = {lat}, longitude = {lon} WHERE nome = '{nome}' AND pais_id = '{pais}';\n")

print(f"Migration 027 gerada com sucesso em: {caminho_saida}")
