# -*- coding: utf-8 -*-
"""
Gera o sitemap.xml do EloTempo para indexação completa no Google e Bing.
Inclui a homepage, o portal do acervo e todas as 78 árvores genealógicas canônicas.
"""

import json
from pathlib import Path
from datetime import datetime

root = Path(r"e:\Trabalhos\Arvore Genealogica\elotempo-site")
catalogo_path = root / "acervo" / "dados" / "catalogo_arvores.json"
sitemap_path = root / "sitemap.xml"

with open(catalogo_path, encoding="utf-8") as f:
    catalogo = json.load(f)

today = datetime.now().strftime("%Y-%m-%d")

lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
    '  <!-- Página Principal / Landing Page Oficial -->',
    '  <url>',
    '    <loc>https://elotempo.org/</loc>',
    f'    <lastmod>{today}</lastmod>',
    '    <changefreq>weekly</changefreq>',
    '    <priority>1.0</priority>',
    '  </url>',
    '  <!-- Portal do Acervo Histórico Canônico -->',
    '  <url>',
    '    <loc>https://elotempo.org/acervo/</loc>',
    f'    <lastmod>{today}</lastmod>',
    '    <changefreq>weekly</changefreq>',
    '    <priority>0.9</priority>',
    '  </url>',
    '  <!-- 78 Linhagens e Árvores Genealógicas Canônicas -->'
]

for arv in catalogo:
    aid = arv["id"]
    lines.extend([
        '  <url>',
        f'    <loc>https://elotempo.org/acervo/?arvore={aid}</loc>',
        f'    <lastmod>{today}</lastmod>',
        '    <changefreq>monthly</changefreq>',
        '    <priority>0.8</priority>',
        '  </url>'
    ])

lines.append('</urlset>')

with open(sitemap_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Sitemap gerado com sucesso em {sitemap_path} ({len(catalogo) + 2} URLs).")
