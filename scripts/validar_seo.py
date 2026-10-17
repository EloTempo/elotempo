# -*- coding: utf-8 -*-
"""
Validador de integridade e sintaxe de SEO para o EloTempo.
Testa JSON-LD, sitemap.xml, robots.txt e metadados.
"""

import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path
import sys

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

site_root = Path(r"e:\Trabalhos\Arvore Genealogica\elotempo-site")

# 1. Validar robots.txt
robots_path = site_root / "robots.txt"
assert robots_path.exists(), "robots.txt não existe!"
robots_content = robots_path.read_text(encoding="utf-8")
assert "Sitemap: https://elotempo.org/sitemap.xml" in robots_content, "robots.txt sem sitemap!"
print("✓ robots.txt válido e apontando para o sitemap.")

# 2. Validar sitemap.xml
sitemap_path = site_root / "sitemap.xml"
assert sitemap_path.exists(), "sitemap.xml não existe!"
tree = ET.parse(sitemap_path)
root = tree.getroot()
urls = [elem.text for elem in root.findall(".//{http://www.sitemaps.org/schemas/sitemap/0.9}loc")]
assert len(urls) >= 80, f"Esperado ao menos 80 URLs no sitemap, encontrado: {len(urls)}"
print(f"✓ sitemap.xml válido com {len(urls)} URLs mapeadas.")

# 3. Validar index.html JSON-LD
index_path = site_root / "index.html"
index_content = index_path.read_text(encoding="utf-8")
matches = re.findall(r'<script type="application/ld\+json">(.*?)</script>', index_content, re.DOTALL)
assert len(matches) > 0, "Nenhum script JSON-LD encontrado em index.html"
for i, m in enumerate(matches, 1):
    data = json.loads(m.strip())
    types = [x.get("@type") for x in data.get("@graph", [])]
    print(f"✓ index.html JSON-LD #{i} válido: {types}")

# 4. Validar acervo/index.html SEO & JSON-LD
acervo_path = site_root / "acervo" / "index.html"
assert acervo_path.exists(), "acervo/index.html não existe!"
acervo_content = acervo_path.read_text(encoding="utf-8")
assert "og:title" in acervo_content, "OpenGraph ausente em acervo/index.html!"
assert "twitter:card" in acervo_content, "Twitter Card ausente em acervo/index.html!"
assert "seo-crawler-index" in acervo_content, "Índice de rastreamento para crawlers ausente!"

acervo_matches = re.findall(r'<script type="application/ld\+json">(.*?)</script>', acervo_content, re.DOTALL)
assert len(acervo_matches) > 0, "Nenhum script JSON-LD encontrado em acervo/index.html"
for i, m in enumerate(acervo_matches, 1):
    data = json.loads(m.strip())
    types = [x.get("@type") for x in data.get("@graph", [])]
    print(f"✓ acervo/index.html JSON-LD #{i} válido: {types}")
    # Checar ItemList de 78 itens
    for g in data.get("@graph", []):
        if g.get("@type") == "ItemList":
            total = len(g.get("itemListElement", []))
            assert total == 78, f"Esperado 78 árvores no ItemList do acervo, encontrado: {total}"
            print(f"  ✓ ItemList com exatamente {total} linhagens históricas mapeadas individualmente.")

print("\n✓ Todos os testes de SEO técnico e semântico passaram com 100% de sucesso!")

