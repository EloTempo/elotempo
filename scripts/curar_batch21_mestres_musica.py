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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; classical music; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

pasta_bach = imagens_base / "ciencia-artes" / "bach"

OBRAS_BATCH21 = [
    {
        "folder": pasta_bach / "Johann_Ambrosius_Bach",
        "file_name": "01_Johann_Ambrosius_Bach.jpg",
        "title": "Johann Ambrosius Bach",
        "artist": "Atribuído a Johann David Herlicius (c. 1685)",
        "role": "pintor",
        "date_created": "c. 1685",
        "museum": "Bachhaus Eisenach / Staatsbibliothek zu Berlin",
        "formatted_description": "Retrato a óleo de Johann Ambrosius Bach (1645–1695), mestre de música e trompetista da corte de Eisenach, pai e primeiro instrutor de Johann Sebastian Bach.",
        "license": "Public domain",
        "source": "Bachhaus Eisenach / Wikimedia Commons",
        "commons_file": "File:Johann Ambrosius Bach.jpg",
        "pessoa_ids": ["pub_bach_johann_ambrosius_bach"]
    },
    {
        "folder": pasta_bach / "Johann_Christoph_Friedrich_Bach",
        "file_name": "01_Johann_Christoph_Friedrich_Bach.jpg",
        "title": "Johann Christoph Friedrich Bach (O Bach de Bückeburg)",
        "artist": "Georg David Matthieu (1737–1778)",
        "role": "pintor",
        "date_created": "1774",
        "museum": "Schloss Bückeburg / Coleção Schaumburg-Lippe",
        "formatted_description": "Retrato a óleo de Johann Christoph Friedrich Bach (1732–1795), cravista e Konzertmeister na corte de Schaumburg-Lippe em Bückeburg.",
        "license": "Public domain",
        "source": "Schloss Bückeburg / Wikimedia Commons",
        "commons_file": "File:Johann Christoph Friedrich Bach.jpg",
        "pessoa_ids": ["pub_bach_johann_christoph_friedrich_bach"]
    }
]

def resolver_url_commons(session, commons_file):
    params = {
        "action": "query",
        "titles": commons_file,
        "prop": "imageinfo",
        "iiprop": "url|size",
        "format": "json"
    }
    try:
        r = session.get(COMMONS_API, params=params, timeout=30)
        data = r.json()
        pages = data.get("query", {}).get("pages", {})
        for _, page in pages.items():
            if "imageinfo" in page and len(page["imageinfo"]) > 0:
                return page["imageinfo"][0].get("url")
    except Exception as e:
        print(f"    [Erro API Commons]: {e}")
    return None

def otimizar_imagem(raw_bytes, max_dim=1920):
    img = Image.open(BytesIO(raw_bytes))
    if img.mode in ("RGBA", "P"):
        if img.mode == "RGBA":
            img.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
            out = BytesIO()
            img.save(out, format="PNG", optimize=True)
            return out.getvalue(), ".png"
        img = img.convert("RGB")
    elif img.mode != "RGB":
        img = img.convert("RGB")

    img.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
    out = BytesIO()
    img.save(out, format="JPEG", quality=95, optimize=True)
    return out.getvalue(), ".jpg"

def main():
    print("=" * 75)
    print("CURADORIA ARQUIVÍSTICA SCHEMA v4.0 - BATCH 21: MESTRES DA MÚSICA CLÁSSICA")
    print("=" * 75)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    session = requests.Session()
    session.headers.update(HEADERS)

    total_obras = len(OBRAS_BATCH21)
    sucessos = 0

    for idx, item in enumerate(OBRAS_BATCH21, 1):
        print(f"\n[{idx}/{total_obras}] {item['title']}")
        print(f"  commons_file: {item['commons_file']}")

        item["folder"].mkdir(parents=True, exist_ok=True)
        img_dest = item["folder"] / item["file_name"]
        json_dest = item["folder"] / (img_dest.stem + ".json")

        img_bytes = None

        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print("  Resolvendo URL direta no Wikimedia Commons...")
            url = resolver_url_commons(session, item["commons_file"])
            if not url:
                print(f"    [FALHA] Não foi possível resolver URL para {item['commons_file']}")
                continue
            item["url"] = url

            print(f"  Baixando imagem institucional ({url.split('/')[-1][:50]}...)...")
            time.sleep(1.0)

            raw_bytes = None
            for attempt in range(3):
                try:
                    resp = session.get(url, timeout=60)
                    if resp.status_code == 200 and len(resp.content) > 5000:
                        raw_bytes = resp.content
                        break
                    elif resp.status_code == 429:
                        wait = 6 * (attempt + 1)
                        print(f"    [HTTP 429] Aguardando {wait}s...")
                        time.sleep(wait)
                    else:
                        print(f"    [HTTP {resp.status_code}] Tentando novamente...")
                        time.sleep(3)
                except Exception as e:
                    print(f"    [Erro Download attempt {attempt+1}]: {e}")
                    time.sleep(3)

            if not raw_bytes:
                print(f"    [FALHA] Não foi possível baixar {item['commons_file']}")
                continue

            print(f"    [OK] Download concluído: {len(raw_bytes):,} bytes originais.")
            img_bytes, novo_ext = otimizar_imagem(raw_bytes)
            if novo_ext != img_dest.suffix.lower():
                img_dest = img_dest.with_suffix(novo_ext)
                item["file_name"] = img_dest.name
                json_dest = item["folder"] / (img_dest.stem + ".json")

            img_dest.write_bytes(img_bytes)
            print(f"    [OK] Imagem tratada e salva: {img_dest.name} ({len(img_bytes):,} bytes)")
        else:
            print(f"    [OK] Imagem já existente em disco: {img_dest.name}")
            img_bytes = img_dest.read_bytes()
            item["url"] = item.get("url") or f"https://commons.wikimedia.org/wiki/{item['commons_file']}"

        # 1. Metadados Schema 4.0
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
    print("CURADORIA BATCH 21 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()
