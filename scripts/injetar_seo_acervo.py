# -*- coding: utf-8 -*-
"""
Injeta dados estruturados Schema.org (CollectionPage, Dataset, ItemList)
e metadados sociais e semânticos em elotempo-site/acervo/index.html.
"""

import json
import re
from pathlib import Path

site_root = Path(r"e:\Trabalhos\Arvore Genealogica\elotempo-site")
catalogo_path = site_root / "acervo" / "dados" / "catalogo_arvores.json"
acervo_html_path = site_root / "acervo" / "index.html"

with open(catalogo_path, encoding="utf-8") as f:
    catalogo = json.load(f)

# Monta o ItemList do Schema.org com as 78 linhagens
item_list_elements = []
for i, arv in enumerate(catalogo, 1):
    item_list_elements.append({
        "@type": "ListItem",
        "position": i,
        "name": arv["nome"],
        "description": arv.get("descricao", "")[:180],
        "url": f"https://elotempo.org/acervo/?arvore={arv['id']}"
    })

schema_data = {
    "@context": "https://schema.org",
    "@graph": [
        {
            "@type": "CollectionPage",
            "@id": "https://elotempo.org/acervo/#collection",
            "url": "https://elotempo.org/acervo/",
            "name": "Acervo Canônico da Humanidade — EloTempo",
            "description": "Explore 78 árvores genealógicas públicas da história brasileira e mundial, trajetórias biográficas, obras capitais e 37 linhas do tempo de contexto histórico diretamente no navegador.",
            "isPartOf": {
                "@type": "WebSite",
                "@id": "https://elotempo.org/#website",
                "name": "EloTempo",
                "url": "https://elotempo.org/"
            }
        },
        {
            "@type": "Dataset",
            "@id": "https://elotempo.org/acervo/#dataset",
            "name": "Acervo Histórico e Genealógico Canônico EloTempo",
            "description": "Base canônica pública contendo 78 genealogias consolidadas, dados vitais de figuras históricas, produções culturais e 431 marcos de contexto cronológico universal.",
            "license": "https://creativecommons.org/licenses/by-sa/4.0/",
            "creator": {
                "@type": "Organization",
                "name": "EloTempo",
                "url": "https://elotempo.org/"
            }
        },
        {
            "@type": "ItemList",
            "@id": "https://elotempo.org/acervo/#itemlist",
            "name": "Catálogo de Linhagens Históricas Canônicas (78 Árvores)",
            "numberOfItems": len(catalogo),
            "itemListElement": item_list_elements
        }
    ]
}

schema_json = json.dumps(schema_data, ensure_ascii=False, indent=2)

# Monta o bloco HTML semântico para rastreadores (crawler index)
crawler_links = []
for arv in catalogo:
    nome = arv["nome"]
    cat = arv.get("categoria", "")
    pais = arv.get("pais", "")
    periodo = arv.get("periodo", "")
    aid = arv["id"]
    crawler_links.append(
        f'        <li><a href="?arvore={aid}"><strong>{nome}</strong> ({cat}{", " + pais if pais else ""}{" · " + periodo if periodo else ""})</a></li>'
    )

crawler_html = f"""
    <!-- Índice Semântico Acessível para Robôs de Busca (SEO Crawler Index) -->
    <noscript>
      <section class="seo-crawler-index" style="padding: 2rem; background: #F8FAFC; border-top: 1px solid #E2E8F0; margin-top: 3rem;">
        <div style="max-width: 1000px; margin: 0 auto;">
          <h2>Catálogo das 78 Linhagens Históricas Canônicas</h2>
          <p>Consulte diretamente as árvores genealógicas e trajetórias de figuras marcantes da história:</p>
          <ul style="columns: 2; column-gap: 2rem; line-height: 1.8; font-size: 0.9rem;">
{chr(10).join(crawler_links)}
          </ul>
        </div>
      </section>
    </noscript>
"""

with open(acervo_html_path, "r", encoding="utf-8") as f:
    content = f.read()

# Substitui o bloco head com SEO completo
new_head_meta = f"""  <title>Acervo Canônico da Humanidade — 78 Árvores Genealógicas e 37 Linhas do Tempo | EloTempo</title>
  
  <meta name="description" content="Consulte gratuitamente 78 árvores genealógicas públicas da história brasileira e mundial (Machado de Assis, Dom Pedro II, Santos Dumont, Einstein, Newton) e 37 linhas do tempo cronológicas direto no navegador.">
  <meta name="keywords" content="árvore genealógica histórica, genealogia machado de assis, arvore dom pedro ii, linhagem einstein, santos dumont arvore genealogica, historia do brasil linha do tempo, acervo canonico, genealogia publica, elotempo">
  <meta name="author" content="Gabriel Nascimento">
  <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
  <meta name="theme-color" content="#0B1D3A">
  <link rel="canonical" href="https://elotempo.org/acervo/">

  <!-- Open Graph / Redes Sociais / WhatsApp / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="EloTempo">
  <meta property="og:locale" content="pt_BR">
  <meta property="og:url" content="https://elotempo.org/acervo/">
  <meta property="og:title" content="Acervo Histórico da Humanidade — 78 Árvores Genealógicas & 37 Linhas do Tempo">
  <meta property="og:description" content="Consulte gratuitamente 78 árvores genealógicas públicas da história brasileira e mundial e 37 linhas do tempo cronológicas direto no seu navegador.">
  <meta property="og:image" content="https://elotempo.org/assets/og-image.png">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:image:alt" content="Acervo Canônico da Humanidade — EloTempo">

  <!-- Twitter Cards -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:url" content="https://elotempo.org/acervo/">
  <meta name="twitter:title" content="Acervo Histórico da Humanidade — 78 Famílias & 37 Linhas do Tempo | EloTempo">
  <meta name="twitter:description" content="Explore linhagens históricas consolidadas, biografias ilustres e marcos mundiais sem instalar nada.">
  <meta name="twitter:image" content="https://elotempo.org/assets/og-image.png">

  <!-- Favicon -->
  <link rel="icon" type="image/svg+xml" href="../assets/favicon.svg">
  <link rel="alternate icon" href="../favicon.ico">

  <!-- Tipografia Oficial: Sora + Inter + IBM Plex Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=Inter:wght@400;500;600;700&family=Sora:wght@400;500;600;700&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="style.css?v=20260913_v4">

  <!-- Dados Estruturados Schema.org (JSON-LD) para Indexação do Acervo -->
  <script type="application/ld+json">
{schema_json}
  </script>"""

# Substitui entre <title> e <link rel="stylesheet" href="style.css...
pattern_head = r'<title>.*?<link rel="stylesheet" href="style\.css.*?>'
content = re.sub(pattern_head, new_head_meta, content, flags=re.DOTALL)

# Injeta o bloco noscript antes de </main> se ainda não existir
if "seo-crawler-index" not in content:
    content = content.replace("</main>", f"{crawler_html}\n  </main>")

with open(acervo_html_path, "w", encoding="utf-8") as f:
    f.write(content)

print("SEO atualizado com sucesso em elotempo-site/acervo/index.html!")
