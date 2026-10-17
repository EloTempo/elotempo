# -*- coding: utf-8 -*-
import os
import sys
import json
import uuid
import time
import sqlite3
import requests
from io import BytesIO
from pathlib import Path
from PIL import Image

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; literature; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"
pasta_goethe = imagens_base / "artes-literatura" / "goethe"

OBRAS_BATCH22 = [
    {
        "folder": pasta_goethe / "Ottilie_von_Goethe",
        "file_name": "01_Ottilie_von_Goethe.jpg",
        "title": "Ottilie von Goethe geb. von Pogwisch aos 17 Anos",
        "artist": "Franz Heinrich Müller (1793–1866)",
        "role": "desenhista",
        "date_created": "1813",
        "museum": "Klassik Stiftung Weimar / Freies Deutsches Hochstift, Frankfurt",
        "formatted_description": "Retrato a giz de Ottilie von Pogwisch (1796–1872), mais tarde Ottilie von Goethe, aos dezessete anos, por Franz Heinrich Müller (1813). Acervo: Freies Deutsches Hochstift / Klassik Stiftung Weimar.",
        "license": "Public domain",
        "source": "Freies Deutsches Hochstift / Klassik Stiftung Weimar / Wikimedia Commons",
        "commons_file": "File:Ottilie von Goethe by Franz Heinrich Müller.jpg",
        "pessoa_ids": ["pub_goethe_ottilie"]
    }
]

def get_commons_url(commons_title):
    params = {
        "action": "query",
        "titles": commons_title,
        "prop": "imageinfo",
        "iiprop": "url|mime",
        "format": "json"
    }
    r = requests.get(COMMONS_API, params=params, headers=HEADERS, timeout=30)
    data = r.json()
    pages = data.get("query", {}).get("pages", {})
    for _, page_data in pages.items():
        imageinfo = page_data.get("imageinfo", [])
        if imageinfo:
            return imageinfo[0]["url"]
    return None

def download_and_optimize(url, max_dim=1920, quality=95):
    r = requests.get(url, headers=HEADERS, timeout=60)
    r.raise_for_status()
    img = Image.open(BytesIO(r.content))
    
    # Converte RGBA para RGB se necessário
    if img.mode in ("RGBA", "P"):
        img = img.convert("RGB")
        
    w, h = img.size
    if max(w, h) > max_dim:
        scale = max_dim / max(w, h)
        new_w = int(w * scale)
        new_h = int(h * scale)
        img = img.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
    out = BytesIO()
    img.save(out, format="JPEG", quality=quality, optimize=True)
    return out.getvalue()

def main():
    print("=" * 75)
    print("CURADORIA ARQUIVÍSTICA BATCH 22 - GRANDES GÊNIOS DA LITERATURA")
    print("=" * 75)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    sucessos = 0
    total_obras = len(OBRAS_BATCH22)

    for idx, item in enumerate(OBRAS_BATCH22, 1):
        print(f"\n[{idx}/{total_obras}] Processando: {item['title']}")
        target_folder = item["folder"]
        target_folder.mkdir(parents=True, exist_ok=True)

        img_dest = target_folder / item["file_name"]
        json_dest = target_folder / (Path(item["file_name"]).stem + ".json")

        # Busca URL original no Commons
        url = get_commons_url(item["commons_file"])
        if not url:
            print(f"    [ERRO] Não foi possível obter URL para {item['commons_file']}")
            continue
        print(f"    URL obtida: {url}")
        item["url"] = url

        # Baixa e otimiza
        print(f"    Baixando e otimizando imagem...")
        img_bytes = download_and_optimize(url)
        img_dest.write_bytes(img_bytes)
        print(f"    [OK] Salvo em: {img_dest} ({len(img_bytes)} bytes)")

        # 1. Cria metadata Schema v4.0
        meta_json = {
            "schema_version": "4.0",
            "artwork": {
                "artist": item["artist"],
                "role": item["role"],
                "date_created": item["date_created"],
                "title": item["title"],
                "museum": item["museum"],
                "formatted_description": item["formatted_description"]
            },
            "rights": {
                "license": item["license"],
                "author": item["artist"]
            },
            "provenance": {
                "original_url": item.get("url", ""),
                "source_provider": item["source"],
                "commons_file": item["commons_file"]
            }
        }
        json_dest.write_text(json.dumps(meta_json, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"    [OK] Metadados Schema 4.0 gravados: {json_dest.name}")

        # 2. Copia para %APPDATA%/midia/ com UUID
        ext = img_dest.suffix.lower()
        doc_id = str(uuid.uuid4())
        nome_midia = f"{doc_id}{ext}"
        midia_file = midia_dir / nome_midia
        midia_file.write_bytes(img_bytes)
        caminho_relativo = f"midia/{nome_midia}"
        tamanho_bytes = len(img_bytes)

        titulo_doc = f"Retrato: {item['title']}"
        desc_doc = f"Obra: {item['formatted_description']} | Licença: {item['license']} | Fonte: {item['source']}"

        # 3. Insere registro em 'documentos'
        cur.execute("""
            INSERT OR REPLACE INTO documentos (
                id, caminho_relativo, tipo_midia, tamanho_bytes,
                data_documento, titulo, descricao, nome_original, data_criacao
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        """, (
            doc_id,
            caminho_relativo,
            "imagem",
            tamanho_bytes,
            item["date_created"],
            titulo_doc,
            desc_doc,
            item["file_name"]
        ))

        # 4. Vincula em 'documento_vinculos' e atualiza 'pessoas.foto_url'
        for pid in item["pessoa_ids"]:
            vinculo_id = f"vinc_{doc_id[:8]}_{pid}"
            cur.execute("""
                INSERT OR REPLACE INTO documento_vinculos (
                    id, documento_id, pessoa_id, evento_id
                ) VALUES (?, ?, ?, NULL)
            """, (vinculo_id, doc_id, pid))

            cur.execute("""
                UPDATE pessoas
                SET foto_url = ?
                WHERE id = ?
            """, (caminho_relativo, pid))
            print(f"    -> Foto vinculada à pessoa: [{pid}]")

        conn.commit()
        sucessos += 1

    conn.close()
    print("\n" + "=" * 75)
    print("CURADORIA BATCH 22 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()
