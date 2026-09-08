"""
EloTempo - Curadoria de Obras Clássicas: Batch 2 (Egito Antigo e Faraós)
=======================================================================
Baixa e cadastra com metadados de estatuária, relevos e máscaras dos maiores museus:
- 18ª Dinastia: Tutancâmon, Nefertiti, Akhenaton, Hatshepsut, Tutmés III, Amenófis III, Amosis I
- 19ª Dinastia: Ramsés II, Seti I, Nefertari, Ramessés I, Merneptah
- Dinastias 21 a 23: Psusenes I (máscara de ouro), Sheshonk I (relevo de Karnak)
"""

import os
import sys
import json
import uuid
import time
import shutil
import sqlite3
import requests
from datetime import datetime, timezone
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; egyptian pharaohs; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH2_OBRAS = [
    {
        "pessoa_ids": ["pub_dinastia_18_tutancamon"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Tutancâmon",
        "file_name": "01_Tutancâmon.jpg",
        "commons_file": "File:Tutankhamun-mask-retouched.jpg",
        "title": "Máscara Funerária de Tutancâmon em Ouro e Lápis-lazúli",
        "artist": "Ourives reais do Antigo Egito",
        "role": "escultor / ourives",
        "date_created": "c. 1323 a.C.",
        "museum": "Museu Egípcio do Cairo",
        "formatted_description": "Máscara mortuária em ouro maciço, lápis-lazúli e pedras semipreciosas (c. 1323 a.C.). Acervo: Museu Egípcio do Cairo.",
        "license": "CC BY-SA 3.0",
        "source": "Tumba KV62, Vale dos Reis; arqueologia egípcia"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_nefertiti"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Nefertiti",
        "file_name": "01_Nefertiti.jpg",
        "commons_file": "File:Nofretete Neues Museum.jpg",
        "title": "Busto da Rainha Nefertiti",
        "artist": "Tutemés (Tutmose)",
        "role": "escultor",
        "date_created": "c. 1345 a.C.",
        "museum": "Neues Museum, Berlim",
        "formatted_description": "Escultura em calcário estucado e policromado por Tutemés (c. 1345 a.C.). Acervo: Neues Museum, Berlim.",
        "license": "CC BY-SA 3.0",
        "source": "Oficina de Tutemés em Amarna; arqueologia egípcia"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_akhenaton"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Akhenaton",
        "file_name": "01_Akhenaton.jpg",
        "commons_file": "File:Statue of Akhenaten, Egyptian Museum, al-Qāhirah, CG, EGY (46992844015).jpg",
        "title": "Estátua Colossal de Akhenaton",
        "artist": "Escultores Reais de Amarna",
        "role": "escultor",
        "date_created": "c. 1350 a.C.",
        "museum": "Museu Egípcio do Cairo",
        "formatted_description": "Escultura em arenito do Faraó Akhenaton (c. 1350 a.C.). Acervo: Museu Egípcio do Cairo.",
        "license": "CC BY 2.0",
        "source": "Templo de Aton em Karnak; egiptologia"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_hatshepsut"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Hatshepsut",
        "file_name": "01_Hatshepsut.jpg",
        "commons_file": "File:The Female Pharaoh Hatshepsut MET DT534.jpg",
        "title": "Estátua Sedente da Faraó Hatshepsut",
        "artist": "Oficina Escultural Real de Tebas",
        "role": "escultor",
        "date_created": "c. 1479–1458 a.C.",
        "museum": "Metropolitan Museum of Art, Nova York",
        "formatted_description": "Estátua em calcário indurated da Faraó Hatshepsut (c. 1479-1458 a.C.). Acervo: Metropolitan Museum of Art, Nova York.",
        "license": "CC0 Public Domain",
        "source": "Deir el-Bahari; Metropolitan Museum of Art"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_tutmes_iii"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Tutmés_III",
        "file_name": "01_Tutmés_III.jpg",
        "commons_file": "File:Statue of Tuthmosis III, granodiorite - Museo Egizio Turin C 1376 p07.jpg",
        "title": "Estátua Triunfal de Tutmés III",
        "artist": "Escultores Reais de Tebas",
        "role": "escultor",
        "date_created": "c. 1450 a.C.",
        "museum": "Museo Egizio, Turim",
        "formatted_description": "Escultura em granodiorito do Faraó Tutmés III (c. 1450 a.C.). Acervo: Museo Egizio, Turim.",
        "license": "CC BY-SA 4.0",
        "source": "Karnak; Coleção Drovetti / Museo Egizio de Turim"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_amenofis_iii"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Amenófis_III",
        "file_name": "01_Amenófis_III.jpg",
        "commons_file": "File:Colossal granite head of Amenhotep III, British Museum.jpg",
        "title": "Cabeça Colossal de Amenófis III em Granito Vermelho",
        "artist": "Escultores Reais de Luxor",
        "role": "escultor",
        "date_created": "c. 1370 a.C.",
        "museum": "British Museum, Londres",
        "formatted_description": "Escultura colossal em granito vermelho de Amenófis III (c. 1370 a.C.). Acervo: British Museum, Londres.",
        "license": "CC BY-SA 2.0",
        "source": "Templo Mortuário de Kom el-Hettan, Tebas; British Museum"
    },
    {
        "pessoa_ids": ["pub_dinastia_18_amosis_i"],
        "folder": imagens_base / "faraos-egito" / "dinastia-18" / "Amosis_I",
        "file_name": "01_Amosis_I.jpg",
        "commons_file": "File:Ahmose I - StatueHead BrooklynMuseum.jpg",
        "title": "Cabeça do Faraó Ahmose I (Fundador da 18ª Dinastia)",
        "artist": "Escultores da 18ª Dinastia",
        "role": "escultor",
        "date_created": "c. 1539–1514 a.C.",
        "museum": "Brooklyn Museum, Nova York",
        "formatted_description": "Escultura em calcário de Ahmose I (c. 1539-1514 a.C.). Acervo: Brooklyn Museum, Nova York.",
        "license": "CC BY 3.0",
        "source": "Coleção Charles Edwin Wilbour; Brooklyn Museum"
    },
    {
        "pessoa_ids": ["pub_dinastia_19_ramesses_ii"],
        "folder": imagens_base / "faraos-egito" / "dinastia-19" / "Ramsés_II",
        "file_name": "01_Ramsés_II.jpg",
        "commons_file": "File:Statue of Ramses II from Karnak, granodiorite - C 1380 Museo Egizio (Turin) 09.jpg",
        "title": "Estátua Colossal de Ramsés II, o Grande",
        "artist": "Escultores Reais de Pi-Ramsés",
        "role": "escultor",
        "date_created": "c. 1270 a.C.",
        "museum": "Museo Egizio, Turim",
        "formatted_description": "Escultura monumental em granodiorito de Ramsés II de Karnak (c. 1270 a.C.). Acervo: Museo Egizio, Turim.",
        "license": "CC BY-SA 4.0",
        "source": "Karnak; Coleção Drovetti / Museo Egizio de Turim"
    },
    {
        "pessoa_ids": ["pub_dinastia_19_seti_i"],
        "folder": imagens_base / "faraos-egito" / "dinastia-19" / "Seti_I",
        "file_name": "01_Seti_I.jpg",
        "commons_file": "File:Seti I, Abydos.jpg",
        "title": "Relevo Policromado do Faraó Seti I",
        "artist": "Mestres de Relevo de Abidos",
        "role": "escultor / pintor",
        "date_created": "c. 1290 a.C.",
        "museum": "Templo Cenotáfio de Seti I, Abidos",
        "formatted_description": "Baixo-relevo em calcário policromado do Faraó Seti I (c. 1290 a.C.). Acervo: Templo de Seti I, Abidos.",
        "license": "CC BY-SA 3.0",
        "source": "Abidos; patrimônio histórico do Egito"
    },
    {
        "pessoa_ids": ["pub_dinastia_19_nefertari"],
        "folder": imagens_base / "faraos-egito" / "dinastia-19" / "Nefertari",
        "file_name": "01_Nefertari.jpg",
        "commons_file": "File:Queen Nefertari being led by Isis MET DP167142.jpg",
        "title": "A Rainha Nefertari Conduzida pela Deusa Ísis",
        "artist": "Pintores Reais do Vale das Rainhas",
        "role": "pintor",
        "date_created": "c. 1279–1213 a.C.",
        "museum": "Tumba QV66, Vale das Rainhas, Luxor",
        "formatted_description": "Afresco parietal policromado da Rainha Nefertari (c. 1250 a.C.). Acervo: Tumba QV66, Luxor / MET facsimile.",
        "license": "CC0 Public Domain",
        "source": "Vale das Rainhas, Luxor; Metropolitan Museum of Art"
    },
    {
        "pessoa_ids": ["pub_dinastia_19_ramesses_i"],
        "folder": imagens_base / "faraos-egito" / "dinastia-19" / "Ramessés_I",
        "file_name": "01_Ramessés_I.jpg",
        "commons_file": "File:Reliefs from the North Wall of a Chapel of Ramesses I MET DT277011.jpg",
        "title": "Relevos da Capela de Ramessés I diante de Osíris",
        "artist": "Escultores da 19ª Dinastia",
        "role": "escultor",
        "date_created": "c. 1295–1294 a.C.",
        "museum": "Metropolitan Museum of Art, Nova York",
        "formatted_description": "Relevo em calcário de Ramessés I (c. 1295 a.C.). Acervo: Metropolitan Museum of Art, Nova York.",
        "license": "CC0 Public Domain",
        "source": "Abidos; Metropolitan Museum of Art"
    },
    {
        "pessoa_ids": ["pub_dinastia_19_merneptah"],
        "folder": imagens_base / "faraos-egito" / "dinastia-19" / "Merneptah",
        "file_name": "01_Merneptah.jpg",
        "commons_file": "File:Colossal Statue of Amenhotep III Reinscribed by Merneptah MET 51268.jpg",
        "title": "Estátua Colossal do Faraó Merneptah",
        "artist": "Escultores Reais de Mênfis",
        "role": "escultor",
        "date_created": "c. 1213–1203 a.C.",
        "museum": "Metropolitan Museum of Art, Nova York",
        "formatted_description": "Escultura em granito do Faraó Merneptah (c. 1213 a.C.). Acervo: Metropolitan Museum of Art, Nova York.",
        "license": "CC0 Public Domain",
        "source": "Mênfis; Metropolitan Museum of Art"
    },
    {
        "pessoa_ids": ["pub_dinastias_21_23_psusennes_i"],
        "folder": imagens_base / "faraos-egito" / "dinastias-21-23" / "Psusenes_I",
        "file_name": "01_Psusenes_I.jpg",
        "commons_file": "File:Psusennes I's Funerary Mask in 2012 (gold).jpg",
        "title": "Máscara Funerária em Ouro de Psusenes I de Tânis",
        "artist": "Ourives Reais de Tânis",
        "role": "ourives / escultor",
        "date_created": "c. 1047–1001 a.C.",
        "museum": "Museu Egípcio do Cairo",
        "formatted_description": "Máscara mortuária em ouro e lápis-lazúli de Psusenes I (c. 1000 a.C.). Acervo: Museu Egípcio do Cairo.",
        "license": "CC BY-SA 3.0",
        "source": "Tumba Real NRT III de Tânis; arqueologia egípcia"
    },
    {
        "pessoa_ids": ["pub_dinastias_21_23_sheshonq_i"],
        "folder": imagens_base / "faraos-egito" / "dinastias-21-23" / "Sheshonk_I",
        "file_name": "01_Sheshonk_I.jpg",
        "commons_file": "File:Karnak Tempel 19.jpg",
        "title": "Relevo Triunfal do Faraó Sheshonk I (Shishak)",
        "artist": "Mestres de Karnak",
        "role": "escultor",
        "date_created": "c. 925 a.C.",
        "museum": "Templo de Amon em Karnak, Luxor",
        "formatted_description": "Relevo monumental triunfal do Faraó Sheshonk I (c. 925 a.C.). Acervo: Templo de Karnak, Luxor.",
        "license": "CC BY-SA 3.0",
        "source": "Pórtico Bubastita, Templo de Karnak; egiptologia"
    }
]


def resolver_url_commons(session: requests.Session, commons_file: str) -> str:
    params = {
        "action": "query",
        "format": "json",
        "titles": commons_file,
        "prop": "imageinfo",
        "iiprop": "url"
    }
    r = session.get(COMMONS_API, params=params, timeout=15).json()
    pages = r.get("query", {}).get("pages", {})
    for k, v in pages.items():
        if k != "-1" and "imageinfo" in v:
            return v["imageinfo"][0]["url"]
    return None


def executar_batch2():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 2: Egito Antigo & Faraós")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH2_OBRAS:
        folder = item["folder"]
        folder.mkdir(parents=True, exist_ok=True)
        img_dest = folder / item["file_name"]
        json_dest = folder / f"{item['file_name'].rsplit('.', 1)[0]}.json"

        # Download da imagem se não existir
        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print(f"  Resolvendo URL: {item['title']}...")
            url = resolver_url_commons(session, item["commons_file"])
            if not url:
                print(f"    ✕ Falha ao resolver URL da Commons para {item['commons_file']}")
                continue
            item["url"] = url

            print(f"  Baixando: {item['title']}...")
            time.sleep(1.0)
            try:
                resp = session.get(url, timeout=40)
                if resp.status_code == 200 and len(resp.content) > 5000:
                    img_dest.write_bytes(resp.content)
                    print(f"    ✓ Salvo com sucesso ({len(resp.content):,} bytes)")
                else:
                    print(f"    ✕ Falha no download (HTTP {resp.status_code})")
                    continue
            except Exception as e:
                print(f"    ✕ Erro no download: {e}")
                continue
        else:
            item["url"] = item.get("url") or f"https://commons.wikimedia.org/wiki/{item['commons_file']}"

        # Salva o arquivo JSON de metadados
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

        # Copia para %APPDATA%/midia com UUID
        ext = img_dest.suffix.lower()
        doc_id = str(uuid.uuid4())
        nome_destino = f"{doc_id}{ext}"
        midia_file = midia_dir / nome_destino
        shutil.copy2(img_dest, midia_file)
        caminho_relativo = f"midia/{nome_destino}"
        tamanho_bytes = midia_file.stat().st_size
        agora = datetime.now(timezone.utc).isoformat()

        titulo_doc = f"Retrato: {item['title']}"
        desc_doc = f"Obra: {item['formatted_description']} | Licença: {item['license']} | Fonte: {item['source']}"

        # Insere em documentos
        cur.execute("""
            INSERT INTO documentos (
                id, caminho_relativo, tipo_midia, tamanho_bytes,
                data_documento, titulo, descricao, nome_original, data_criacao
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            doc_id,
            caminho_relativo,
            "imagem",
            tamanho_bytes,
            None,
            titulo_doc,
            desc_doc,
            item["file_name"],
            agora
        ))

        # Vincula a cada pessoa_id e atualiza foto_url
        for pid in item["pessoa_ids"]:
            cur.execute("SELECT id, nome, sobrenome FROM pessoas WHERE id = ?", (pid,))
            p_row = cur.fetchone()
            if not p_row:
                continue

            # Cria vínculo formal
            vinc_id = str(uuid.uuid4())
            cur.execute("""
                INSERT INTO documento_vinculos (id, documento_id, pessoa_id, evento_id)
                VALUES (?, ?, ?, NULL)
            """, (vinc_id, doc_id, pid))

            # Atualiza foto_url oficial da pessoa
            cur.execute("UPDATE pessoas SET foto_url = ? WHERE id = ?", (caminho_relativo, pid))
            print(f"    -> Aplicado a {pid} ({p_row[1]} {p_row[2] or ''}): {item['title']}")
            total_aplicados += 1

    conn.commit()
    conn.close()

    print(f"\n[Batch 2 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch2()
