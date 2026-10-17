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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; founders & statesmen; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

pasta_washington = imagens_base / "liderancas-mundiais" / "washington"
pasta_franklin = imagens_base / "liderancas-mundiais" / "franklin"
pasta_independencia = imagens_base / "historia-brasil" / "independencia-1822"

OBRAS_BATCH20 = [
    # 1. Mary Ball Washington
    {
        "folder": pasta_washington / "Mary_Ball_Washington",
        "file_name": "01_Mary_Ball_Washington.jpg",
        "title": "Mary Ball Washington",
        "artist": "Robert Edge Pine (1730–1788)",
        "role": "pintor",
        "date_created": "c. 1786",
        "museum": "Mount Vernon Ladies' Association / Coleção de Mount Vernon",
        "formatted_description": "Retrato a óleo de Mary Ball Washington (1708–1789), matriarca da Virgínia colonial e mãe de George Washington, executado em Mount Vernon.",
        "license": "Public domain",
        "source": "Mount Vernon / Wikimedia Commons",
        "commons_file": "File:Mary Ball Washington(Pine)FXD.jpg",
        "pessoa_ids": ["pub_washington_mary_ball"]
    },
    # 2. Deborah Read Franklin
    {
        "folder": pasta_franklin / "Deborah_Read_Franklin",
        "file_name": "01_Deborah_Read_Franklin.jpg",
        "title": "Deborah Read Franklin",
        "artist": "Atribuído a Benjamin Wilson (1721–1788) e Matthew Pratt (1734–1805)",
        "role": "pintor",
        "date_created": "c. 1759",
        "museum": "American Philosophical Society, Filadélfia, Pensilvânia",
        "formatted_description": "Retrato a óleo de Deborah Read Rogers Franklin (c. 1705–1774), companheira, administradora dos negócios postais e tipográficos e esposa de Benjamin Franklin.",
        "license": "Public domain",
        "source": "American Philosophical Society / Wikimedia Commons",
        "commons_file": "File:Deborah Read Franklin.jpg",
        "pessoa_ids": ["pub_franklin_deborah_read"]
    },
    # 3. Gabriela Frederica Ribeiro de Andrada
    {
        "folder": pasta_independencia / "Gabriela_Frederica",
        "file_name": "01_Gabriela_Frederica_Andrada.jpg",
        "title": "Dona Gabriela Frederica Ribeiro de Andrada",
        "artist": "Desconhecido (Século XIX)",
        "role": "pintor",
        "date_created": "c. 1830–1850",
        "museum": "Acervo Histórico dos Andradas / Acervo Iconográfico Brasileiro",
        "formatted_description": "Retrato histórico oitocentista de Dona Gabriela Frederica Ribeiro de Andrada (1798–1874), filha dileta de José Bonifácio de Andrada e Silva e consorte de Martim Francisco Ribeiro de Andrada.",
        "license": "Public domain",
        "source": "Acervo Iconográfico / Wikimedia Commons",
        "commons_file": "File:Gabrielafrederica.jpg",
        "pessoa_ids": ["pub_gabriela_andrada"]
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
    print("CURADORIA ARQUIVÍSTICA SCHEMA v4.0 - BATCH 20: PAIS FUNDADORES & ESTADISTAS")
    print("=" * 75)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    session = requests.Session()
    session.headers.update(HEADERS)

    total_obras = len(OBRAS_BATCH20)
    sucessos = 0

    for idx, item in enumerate(OBRAS_BATCH20, 1):
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
    print("CURADORIA BATCH 20 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()
