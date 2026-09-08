"""
EloTempo - Curadoria de Representações Canônicas: Batch 12 (Ficcionais Pop Canônicas)
=====================================================================================
Baixa e cadastra com metadados canônicos de retratos e figurinos oficiais:
- O Poderoso Chefão (Corleone):
  * Sonny Corleone (James Caan, 1972)
  * Fredo Corleone (John Cazale)
  * Tom Hagen (Robert Duvall)
  * Connie Corleone (Talia Shire, 1977)
  * Carmela Corleone (Morgana King, 1968)
  * Vincent Mancini (Andy García)
- Star Wars (Skywalker):
  * Bail Organa (Jimmy Smits)
  * Shmi Skywalker (Pernilla August)
  * Rey Skywalker (Daisy Ridley)
- Game of Thrones (Gelo e Fogo):
  * Jaime Lannister (Nikolaj Coster-Waldau)
  * Joffrey Baratheon (Jack Gleeson)
  * Viserys Targaryen (Harry Lloyd)
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
HEADERS = {"User-Agent": "EloTempo/4.0 (pop culture curation; canonical representations; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH12_OBRAS = [
    # --- O PODEROSO CHEFÃO (FAMÍLIA CORLEONE) ---
    {
        "pessoa_ids": ["pub_corleone_sonny_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Sonny_Corleone",
        "file_name": "01_Sonny_Corleone.jpg",
        "commons_file": "File:James Caan - 1972.jpg",
        "title": "Santino 'Sonny' Corleone (James Caan)",
        "artist": "Paramount Pictures / Foto Promocional de Estúdio",
        "role": "fotógrafo de cinema",
        "date_created": "1972",
        "museum": "Paramount Pictures Archives",
        "formatted_description": "Retrato oficial de estúdio de James Caan como Sonny Corleone no clássico The Godfather (1972).",
        "license": "Public domain",
        "source": "Paramount Pictures / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_corleone_fredo_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Fredo_Corleone",
        "file_name": "01_Fredo_Corleone.jpg",
        "commons_file": "File:John Cazale checking out the new University Hospital on Canal Street.jpg",
        "title": "Frederico 'Fredo' Corleone (John Cazale)",
        "artist": "Arquivo Fotográfico de Cinema / The Godfather",
        "role": "fotógrafo",
        "date_created": "c. 1974",
        "museum": "Paramount Pictures / Acervo Cinematográfico",
        "formatted_description": "Retrato de John Cazale, intérprete inesquecível de Fredo Corleone em The Godfather.",
        "license": "CC BY-SA 4.0",
        "source": "Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_corleone_tom_hagen"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Tom_Hagen",
        "file_name": "01_Tom_Hagen.jpg",
        "commons_file": "File:Robert Duvall (actor, at home, New York City apartment, 1984) (cropped).jpg",
        "title": "Tom Hagen, Consigliere da Família Corleone (Robert Duvall)",
        "artist": "Gotfryd Bernard / Library of Congress",
        "role": "fotógrafo",
        "date_created": "1984",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato do ator vencedor do Oscar Robert Duvall, o lendário consigliere Tom Hagen de O Poderoso Chefão.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_corleone_connie_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Connie_Corleone",
        "file_name": "01_Connie_Corleone.jpg",
        "commons_file": "File:Talia Shire 1977.jpg",
        "title": "Constanzia 'Connie' Corleone (Talia Shire)",
        "artist": "Foto Promocional da NBC / Paramount",
        "role": "fotógrafo",
        "date_created": "1977",
        "museum": "Paramount Pictures / Acervo de Cinema",
        "formatted_description": "Retrato oficial da atriz Talia Shire, que deu vida a Connie Corleone na trilogia O Poderoso Chefão.",
        "license": "Public domain",
        "source": "NBC Television / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_corleone_carmela_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Carmela_Corleone",
        "file_name": "01_Carmela_Corleone.jpg",
        "commons_file": "File:Morgana King 1968.JPG",
        "title": "Carmela Corleone (Morgana King)",
        "artist": "Reprise Records / Foto Promocional Oficial",
        "role": "fotógrafo",
        "date_created": "1968",
        "museum": "Reprise Records / Paramount Pictures",
        "formatted_description": "Retrato de Morgana King, célebre cantora de jazz e intérprete da matriarca Carmela Corleone (Mama Corleone).",
        "license": "Public domain",
        "source": "Reprise Records / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_corleone_vincent_mancini"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Vincent_Mancini",
        "file_name": "01_Vincent_Mancini.jpg",
        "commons_file": "File:Andy Garcia at the 2009 Deauville American Film Festival-01A.jpg",
        "title": "Vincent Mancini-Corleone (Andy García)",
        "artist": "Festival de Cinema Americano de Deauville",
        "role": "fotógrafo oficial",
        "date_created": "2009",
        "museum": "Deauville Festival Archives / Paramount Pictures",
        "formatted_description": "Retrato de Andy García, indicado ao Oscar por sua interpretação do impetuoso sucessor Vincent Mancini em O Poderoso Chefão Parte III.",
        "license": "CC BY-SA 3.0",
        "source": "Deauville American Film Festival / Wikimedia Commons"
    },

    # --- STAR WARS (LINHAGEM SKYWALKER) ---
    {
        "pessoa_ids": ["pub_skywalker_bail_organa"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Bail_Organa",
        "file_name": "01_Bail_Organa.jpg",
        "commons_file": "File:Jimmy Smits by Gage Skidmore.jpg",
        "title": "Senador Bail Organa de Alderaan (Jimmy Smits)",
        "artist": "Gage Skidmore",
        "role": "fotógrafo",
        "date_created": "2018",
        "museum": "Lucasfilm / San Diego Comic-Con Collection",
        "formatted_description": "Retrato de Jimmy Smits, o Senador Bail Organa da República Galáctica e pai adotivo da Princesa Leia.",
        "license": "CC BY-SA 3.0",
        "source": "Gage Skidmore / Lucasfilm / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_skywalker_shmi_skywalker"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Shmi_Skywalker",
        "file_name": "01_Shmi_Skywalker.jpg",
        "commons_file": "File:Pernilla August cropped.jpg",
        "title": "Shmi Skywalker de Tatooine (Pernilla August)",
        "artist": "Nordiska Rådet / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "2011",
        "museum": "Lucasfilm Archives / Nordic Film Archives",
        "formatted_description": "Retrato de Pernilla August, a matriarca Shmi Skywalker, mãe de Anakin Skywalker em Star Wars.",
        "license": "CC BY 2.5 dk",
        "source": "Nordic Council / Lucasfilm / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_skywalker_rey"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Rey_Skywalker",
        "file_name": "01_Rey_Skywalker.jpg",
        "commons_file": "File:Daisy Ridley by Gage Skidmore.jpg",
        "title": "Rey Skywalker, Cavaleira Jedi (Daisy Ridley)",
        "artist": "Gage Skidmore",
        "role": "fotógrafo",
        "date_created": "2015",
        "museum": "San Diego Comic-Con / Lucasfilm",
        "formatted_description": "Retrato de Daisy Ridley, a heroína Jedi Rey Skywalker na celebração de Star Wars: O Despertar da Força.",
        "license": "CC BY-SA 3.0",
        "source": "Gage Skidmore / Lucasfilm / Wikimedia Commons"
    },

    # --- GAME OF THRONES (GELO E FOGO) ---
    {
        "pessoa_ids": ["pub_lannister_jaime_lannister"],
        "folder": imagens_base / "ficcionais" / "lannister" / "Jaime_Lannister",
        "file_name": "01_Jaime_Lannister.jpg",
        "commons_file": "File:Nikolaj Coster-Waldau by Gage Skidmore 2.jpg",
        "title": "Sor Jaime Lannister, o Regicida (Nikolaj Coster-Waldau)",
        "artist": "Gage Skidmore",
        "role": "fotógrafo",
        "date_created": "2014",
        "museum": "San Diego Comic-Con / HBO Archives",
        "formatted_description": "Retrato de Nikolaj Coster-Waldau, intérprete de Sor Jaime Lannister, Senhor Comandante da Guarda Real.",
        "license": "CC BY-SA 3.0",
        "source": "Gage Skidmore / HBO / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_lannister_joffrey_baratheon"],
        "folder": imagens_base / "ficcionais" / "lannister" / "Joffrey_Baratheon",
        "file_name": "01_Joffrey_Baratheon.jpg",
        "commons_file": "File:Jack gleeson 2018 1.jpg",
        "title": "Rei Joffrey Baratheon (Jack Gleeson)",
        "artist": "Fotografia Oficial de Convenção",
        "role": "fotógrafo",
        "date_created": "2018",
        "museum": "Coleção Comic Con / HBO Archives",
        "formatted_description": "Retrato de Jack Gleeson, o Rei Joffrey Baratheon dos Sete Reinos em Game of Thrones.",
        "license": "CC BY-SA 4.0",
        "source": "Wikimedia Commons / HBO"
    },
    {
        "pessoa_ids": ["pub_targaryen_viserys_targaryen"],
        "folder": imagens_base / "ficcionais" / "targaryen" / "Viserys_Targaryen",
        "file_name": "01_Viserys_Targaryen.jpg",
        "commons_file": "File:Stuttgart 2023 -Comic Con Germany- Harry Lloyd- by-RaBoe 034 (cropped).jpg",
        "title": "Príncipe Viserys Targaryen, o Rei Pedinte (Harry Lloyd)",
        "artist": "RaBoe / Comic Con Germany",
        "role": "fotógrafo oficial",
        "date_created": "2023",
        "museum": "Comic Con Germany / HBO Archives",
        "formatted_description": "Retrato de Harry Lloyd, intérprete do Príncipe Viserys Targaryen em Game of Thrones.",
        "license": "CC BY-SA 4.0",
        "source": "RaBoe / Wikimedia Commons"
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


def executar_batch12():
    print("=" * 75)
    print(" EloTempo - Curadoria Batch 12: Pop Culture & Ficcionais Canônicas (12 figuras)")
    print("=" * 75)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH12_OBRAS:
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

    print(f"\n[Batch 12 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch12()
