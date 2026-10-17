# -*- coding: utf-8 -*-
import os
import sys
import json
import uuid
import time
import sqlite3
import requests
from io import BytesIO
from datetime import datetime, timezone
from pathlib import Path
from PIL import Image

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; industrial pioneers; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo" / "empreendedores"

pasta_rockefeller = imagens_base / "rockefeller"
pasta_matarazzo = imagens_base / "matarazzo"
pasta_klabin = imagens_base / "klabin"
pasta_guinle = imagens_base / "guinle"

OBRAS_BATCH18 = [
    # -------------------------------------------------------------
    # 1. Família Rockefeller
    # -------------------------------------------------------------
    {
        "folder": pasta_rockefeller / "Laura_Spelman_Rockefeller",
        "file_name": "01_Laura_Spelman_Rockefeller.jpg",
        "title": "Laura Spelman Rockefeller",
        "artist": "James Jebusa Shannon",
        "role": "pintor",
        "date_created": "c. 1910",
        "museum": "Rockefeller Archive Center, Sleepy Hollow, Nova York",
        "formatted_description": "Retrato a óleo de Laura Spelman Rockefeller, filantropa, abolicionista e patrona do Spelman College, pintado por James Jebusa Shannon.",
        "license": "Public domain",
        "source": "Rockefeller Archive Center / Wikimedia Commons",
        "commons_file": "File:James Jebusa Shannon - Laura Spelman Rockefeller.jpg",
        "pessoa_ids": ["pub_rockefeller_laura_spelman_rockefeller"]
    },
    {
        "folder": pasta_rockefeller / "Winthrop_Rockefeller",
        "file_name": "01_Winthrop_Rockefeller.jpg",
        "title": "Winthrop Rockefeller (37º Governador do Arkansas)",
        "artist": "Fotógrafo Oficial do Estado do Arkansas",
        "role": "fotógrafo",
        "date_created": "1967",
        "museum": "Arkansas State Archives / National Governors Association",
        "formatted_description": "Retrato oficial de Winthrop Rockefeller como 37º Governador do Arkansas, pioneiro da integração racial e filantropia sulista.",
        "license": "Public domain",
        "source": "Arkansas State Archives / Wikimedia Commons",
        "commons_file": "File:Winthrop Rockefeller 1967.jpg",
        "pessoa_ids": ["pub_rockefeller_winthrop_rockefeller"]
    },

    # -------------------------------------------------------------
    # 2. Família Matarazzo
    # -------------------------------------------------------------
    {
        "folder": pasta_matarazzo / "Ciccillo_Matarazzo",
        "file_name": "01_Ciccillo_Matarazzo.jpg",
        "title": "Francisco Matarazzo Sobrinho (Ciccillo Matarazzo) na VII Bienal de São Paulo",
        "artist": "Fotógrafo do Arquivo Nacional / Agência Nacional",
        "role": "fotógrafo",
        "date_created": "1963",
        "museum": "Arquivo Nacional, Rio de Janeiro / Fundo Agência Nacional",
        "formatted_description": "Retrato de Francisco Matarazzo Sobrinho (Ciccillo), mecenas, fundador da Bienal de São Paulo, do MAM-SP e dos Estúdios Vera Cruz.",
        "license": "Public domain (Arquivo Nacional / Fundo Agência Nacional)",
        "source": "Arquivo Nacional / Wikimedia Commons",
        "commons_file": "File:Francisco Matarazzo Sobrinho na VII Bienal de Artes de São Paulo (cropped).tif",
        "pessoa_ids": ["pub_matarazzo_ciccillo_matarazzo"]
    },
    {
        "folder": pasta_matarazzo / "Eduardo_Matarazzo_Suplicy",
        "file_name": "01_Eduardo_Matarazzo_Suplicy.jpg",
        "title": "Eduardo Matarazzo Suplicy, Senador da República",
        "artist": "Roosewelt Pinheiro / Agência Brasil",
        "role": "fotógrafo",
        "date_created": "2006",
        "museum": "Agência Brasil / Senado Federal",
        "formatted_description": "Retrato oficial de Eduardo Matarazzo Suplicy, economista, professor universitário e senador pelo Estado de São Paulo, autor da Renda Básica de Cidadania.",
        "license": "Creative Commons Attribution 2.5 Brazil (CC BY 2.5 BR)",
        "source": "Agência Brasil / Wikimedia Commons",
        "commons_file": "File:Eduardo Suplicy, senador por SP.jpg",
        "pessoa_ids": ["pub_matarazzo_eduardo_matarazzo_suplicy"]
    },

    # -------------------------------------------------------------
    # 3. Família Klabin-Lafer
    # -------------------------------------------------------------
    {
        "folder": pasta_klabin / "Ema_Gordon_Klabin",
        "file_name": "01_Ema_Gordon_Klabin.jpg",
        "title": "Ema Gordon Klabin",
        "artist": "Acervo Fundação Cultural Ema Gordon Klabin",
        "role": "fotógrafo",
        "date_created": "c. 1950",
        "museum": "Fundação Cultural Ema Gordon Klabin, São Paulo",
        "formatted_description": "Retrato histórico de Ema Gordon Klabin, mecenas, colecionadora de arte e criadora da fundação cultural com acervo clássico e moderno.",
        "license": "Creative Commons Attribution-Share Alike 4.0 International",
        "source": "Fundação Cultural Ema Gordon Klabin / Wikimedia Commons",
        "commons_file": "File:Ema klabin 2.JPG",
        "pessoa_ids": ["pub_klabin_ema_gordon_klabin"]
    },
    {
        "folder": pasta_klabin / "Eva_Klabin",
        "file_name": "01_Eva_Klabin.jpg",
        "title": "Eva Klabin (1929)",
        "artist": "Fotógrafo de estúdio europeu",
        "role": "fotógrafo",
        "date_created": "1929",
        "museum": "Fundação Eva Klabin, Rio de Janeiro",
        "formatted_description": "Retrato da colecionadora de arte Eva Klabin em 1929. Seu acervo no Rio de Janeiro reúne mais de mil peças de arte greco-romana, renascentista e oriental.",
        "license": "Creative Commons Attribution-Share Alike 4.0 International",
        "source": "Fundação Eva Klabin / Wikimedia Commons",
        "commons_file": "File:Eva Klabin, 1929.jpg",
        "pessoa_ids": ["pub_klabin_eva_klabin"]
    },
    {
        "folder": pasta_klabin / "Lasar_Segall",
        "file_name": "01_Lasar_Segall.jpg",
        "title": "Lasar Segall (1929)",
        "artist": "Fotógrafo de estúdio / Acervo Museu Lasar Segall",
        "role": "fotógrafo",
        "date_created": "1929",
        "museum": "Museu Lasar Segall / IBRAM, São Paulo",
        "formatted_description": "Retrato do pintor, gravador e escultor modernista Lasar Segall, expoente do expressionismo no Brasil e marido de Jenny Klabin.",
        "license": "Public domain",
        "source": "Museu Lasar Segall / Wikimedia Commons",
        "commons_file": "File:Lasar seg@ll29a.jpg",
        "pessoa_ids": ["pub_klabin_lasar_segall"]
    },
    {
        "folder": pasta_klabin / "Jenny_Klabin_Segall",
        "file_name": "01_Jenny_Klabin_Segall.jpg",
        "title": "Jenny Klabin Segall com Lasar Segall",
        "artist": "Acervo Museu Lasar Segall",
        "role": "fotógrafo",
        "date_created": "c. 1930",
        "museum": "Museu Lasar Segall / IBRAM, São Paulo",
        "formatted_description": "Retrato histórico da tradutora, escritora e mecenas Jenny Klabin Segall, tradutora de Fausto de Goethe, Molière e Corneille para o português.",
        "license": "Public domain",
        "source": "Museu Lasar Segall / Wikimedia Commons",
        "commons_file": "File:Lasar Segall e Jenny Klabin Segall.jpg",
        "pessoa_ids": ["pub_klabin_jenny_klabin_segall"]
    },
    {
        "folder": pasta_klabin / "Gregori_Warchavchik",
        "file_name": "01_Gregori_Warchavchik.jpg",
        "title": "Gregori Warchavchik",
        "artist": "Fotógrafo do Correio da Manhã / Fundo Correio da Manhã",
        "role": "fotógrafo",
        "date_created": "c. 1935",
        "museum": "Arquivo Nacional, Rio de Janeiro / Fundo Correio da Manhã",
        "formatted_description": "Retrato do arquiteto Gregori Warchavchik, pioneiro da arquitetura moderna no Brasil, projetista da histórica Casa Modernista da Rua Santa Cruz.",
        "license": "Public domain (Arquivo Nacional)",
        "source": "Arquivo Nacional / Wikimedia Commons",
        "commons_file": "File:Gregori Warchavchik, Fundo Correio da Manhã.tif",
        "pessoa_ids": ["pub_klabin_gregori_warchavchik"]
    },
    {
        "folder": pasta_klabin / "Mina_Klabin_Warchavchik",
        "file_name": "01_Mina_Klabin_Warchavchik.png",
        "title": "Mina Klabin Warchavchik",
        "artist": "Fotógrafo histórico / Acervo Klabin-Warchavchik",
        "role": "fotógrafo",
        "date_created": "c. 1928",
        "museum": "Acervo Arquitetura Paulistana / Coleção Família Warchavchik",
        "formatted_description": "Retrato da paisagista Mina Klabin Warchavchik, pioneira do paisagismo moderno brasileiro com flora nativa tropical na Casa Modernista.",
        "license": "Creative Commons Attribution-Share Alike 4.0 International",
        "source": "Wikimedia Commons",
        "commons_file": "File:Mina Klabin Warchavchik - Pictopen.png",
        "pessoa_ids": ["pub_klabin_mina_klabin_warchavchik"]
    },
    {
        "folder": pasta_klabin / "Israel_Klabin",
        "file_name": "01_Israel_Klabin.jpg",
        "title": "Israel Klabin, Prefeito do Rio de Janeiro",
        "artist": "Fotógrafo Oficial da Prefeitura da Cidade do Rio de Janeiro",
        "role": "fotógrafo",
        "date_created": "1979",
        "museum": "Arquivo Geral da Cidade do Rio de Janeiro",
        "formatted_description": "Retrato oficial do engenheiro, ambientalista, empresário industrial e 35º Prefeito do Rio de Janeiro, Israel Klabin.",
        "license": "Public domain (Governo Municipal do Rio de Janeiro)",
        "source": "Prefeitura do Rio de Janeiro / Wikimedia Commons",
        "commons_file": "File:Israel Klabin Rio Prefeitura.jpg",
        "pessoa_ids": ["pub_klabin_israel_klabin"]
    },
    {
        "folder": pasta_klabin / "Hessel_Klabin",
        "file_name": "01_Hessel_Klabin.jpg",
        "title": "Hessel Klabin",
        "artist": "Acervo Histórico Klabin / Fotografia de Época",
        "role": "fotógrafo",
        "date_created": "c. 1920",
        "museum": "Centro de Memória Klabin, São Paulo",
        "formatted_description": "Retrato de Hessel Klabin, cofundador da Klabin Irmãos & Cia., pioneiro da fabricação nacional de papel e celulose no Brasil.",
        "license": "Public domain",
        "source": "Centro de Memória Klabin / Wikimedia Commons",
        "commons_file": "File:Hessel Klabin.jpg",
        "pessoa_ids": ["pub_klabin_hessel_klabin"]
    },

    # -------------------------------------------------------------
    # 4. Família Guinle
    # -------------------------------------------------------------
    {
        "folder": pasta_guinle / "Guilherme_Guinle",
        "file_name": "01_Guilherme_Guinle.jpg",
        "title": "Guilherme Guinle, Presidente da Companhia Siderúrgica Nacional",
        "artist": "Fotógrafo da Agência Nacional / Fundo Agência Nacional",
        "role": "fotógrafo",
        "date_created": "1941",
        "museum": "Arquivo Nacional, Rio de Janeiro / Fundo Agência Nacional",
        "formatted_description": "Retrato oficial de Guilherme Guinle, líder industrial, primeiro presidente da CSN (Volta Redonda) e mecenas da ciência e saúde pública.",
        "license": "Public domain (Arquivo Nacional / Agência Nacional)",
        "source": "Arquivo Nacional / Wikimedia Commons",
        "commons_file": "File:Guilherme Guinle (1941).tif",
        "pessoa_ids": ["pub_guinle_guilherme_guinle"]
    },
    {
        "folder": pasta_guinle / "Octavio_Guinle",
        "file_name": "01_Octavio_Guinle.jpg",
        "title": "Octávio Guinle",
        "artist": "Fotógrafo da revista Careta",
        "role": "fotógrafo",
        "date_created": "1927",
        "museum": "Coleção Periódicos / Fundação Biblioteca Nacional",
        "formatted_description": "Retrato de Octávio Guinle em 1927, fundador do histórico Copacabana Palace no Rio de Janeiro.",
        "license": "Public domain",
        "source": "Revista Careta / Biblioteca Nacional / Wikimedia Commons",
        "commons_file": "File:1927 Octávio Guinle.jpg",
        "pessoa_ids": ["pub_guinle_octavio_guinle"]
    },
    {
        "folder": pasta_guinle / "Carlos_Guinle",
        "file_name": "01_Carlos_Guinle.jpg",
        "title": "Carlos Guinle (Monsieur Carlos Guinle)",
        "artist": "Fotografia de estúdio parisiense",
        "role": "fotógrafo",
        "date_created": "c. 1912",
        "museum": "Acervo Família Guinle / Fundo Histórico Fluminense",
        "formatted_description": "Retrato de Carlos Guinle em Paris, empresário e investidor que construiu o Palácio das Laranjeiras no Rio de Janeiro.",
        "license": "Public domain",
        "source": "Fundo Histórico / Wikimedia Commons",
        "commons_file": "File:Monsieur Carlos Guinle.jpg",
        "pessoa_ids": ["pub_guinle_carlos_guinle"]
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
    print("CURADORIA ARQUIVÍSTICA SCHEMA v4.0 - BATCH 18: EMPREENDEDORES & PIONEIROS")
    print("=" * 75)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    session = requests.Session()
    session.headers.update(HEADERS)

    total_obras = len(OBRAS_BATCH18)
    sucessos = 0

    for idx, item in enumerate(OBRAS_BATCH18, 1):
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

            print(f"  Baixando imagem institucional ({url.split('/')[-1][:50]}...)...\n")
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
    print("CURADORIA BATCH 18 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()