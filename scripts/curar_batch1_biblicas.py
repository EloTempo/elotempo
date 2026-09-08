"""
EloTempo - Curadoria de Obras Clássicas: Batch 1 (Linhagens Bíblicas & Patriarcas)
==================================================================================
Baixa e cadastra com metadados de mestres da arte mundial via Wikimedia Commons API:
- Bate-Seba, Rute, Tamar, Esaú, Raquel, Lia, Joquebede
- Reis Bíblicos: Jessé, Roboão, Asa, Josias, Ezequias, Zorobabel (Michelangelo Sistina)
- Patriarcas: Noé (Michelangelo), Enoque (Teófanes o Grego)
- Apóstolos do NT: Pedro (Caravaggio), André (Rubens), Tiago Maior (Guido Reni),
  Tiago Menor (El Greco), João Evangelista (El Greco), Santa Isabel (Ghirlandaio)
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; biblical masterworks; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH1_OBRAS = [
    {
        "pessoa_ids": ["pub_bate_seba", "pub_mat_bateseba"],
        "folder": imagens_base / "biblicas" / "casa-de-davi" / "Bate-Seba",
        "file_name": "01_Bate-Seba.png",
        "commons_file": "File:Amsterdam - Rijksmuseum - Late Rembrandt Exposition 2015 - Bathsheba at Her Bath 1654.png",
        "title": "Bate-Seba no Banho",
        "artist": "Rembrandt van Rijn",
        "role": "pintor",
        "date_created": "1654",
        "museum": "Museu do Louvre, Paris",
        "formatted_description": "Pintura por Rembrandt van Rijn (1654). Acervo: Museu do Louvre, Paris.",
        "license": "Public domain",
        "source": "2 Samuel 11; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_mat_rute"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Rute",
        "file_name": "01_Rute.jpg",
        "commons_file": "File:Hayez, Ruth (1853).jpg",
        "title": "Rute nos Campos de Boaz",
        "artist": "Francesco Hayez",
        "role": "pintor",
        "date_created": "1853",
        "museum": "Galleria d'Arte Moderna, Milão",
        "formatted_description": "Pintura por Francesco Hayez (1853). Acervo: Galleria d'Arte Moderna, Milão.",
        "license": "Public domain",
        "source": "Livro de Rute; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_mat_tamar"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Tamar",
        "file_name": "01_Tamar.jpg",
        "commons_file": "File:Horace Vernet-Judah n Tamar 1840.jpg",
        "title": "Judá e Tamar",
        "artist": "Horace Vernet",
        "role": "pintor",
        "date_created": "1840",
        "museum": "Wallace Collection, Londres",
        "formatted_description": "Pintura por Horace Vernet (1840). Acervo: Wallace Collection, Londres.",
        "license": "Public domain",
        "source": "Gênesis 38; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_patriarcas_israel_esau"],
        "folder": imagens_base / "biblicas" / "patriarcas-israel" / "Esaú",
        "file_name": "01_Esaú.jpg",
        "commons_file": "File:Rubens Reconciliation of Jacob and Esau.jpg",
        "title": "A Reconciliação de Jacó e Esaú",
        "artist": "Peter Paul Rubens",
        "role": "pintor",
        "date_created": "1624",
        "museum": "Staatsgalerie Schleissheim / Bayerische Staatsgemäldesammlungen",
        "formatted_description": "Pintura por Peter Paul Rubens (1624). Acervo: Staatsgalerie Schleissheim.",
        "license": "Public domain",
        "source": "Gênesis 33; tradição patriarcal"
    },
    {
        "pessoa_ids": ["pub_patriarcas_israel_raquel"],
        "folder": imagens_base / "biblicas" / "patriarcas-israel" / "Raquel",
        "file_name": "01_Raquel.jpg",
        "commons_file": "File:Rachel WilliamDyce.jpg",
        "title": "Jacó e Raquel no Poço",
        "artist": "William Dyce",
        "role": "pintor",
        "date_created": "1853",
        "museum": "Victoria and Albert Museum / Tate, Londres",
        "formatted_description": "Pintura por William Dyce (1853). Acervo: Victoria and Albert Museum, Londres.",
        "license": "Public domain",
        "source": "Gênesis 29; tradição patriarcal"
    },
    {
        "pessoa_ids": ["pub_patriarcas_israel_lia", "pub_mat_lia"],
        "folder": imagens_base / "biblicas" / "patriarcas-israel" / "Lia",
        "file_name": "01_Lia.jpg",
        "commons_file": "File:Hendrick ter Brugghen - Jacob Reproaching Laban - WGA22181.jpg",
        "title": "Jacó, Labão e Lia",
        "artist": "Hendrick ter Brugghen",
        "role": "pintor",
        "date_created": "1627",
        "museum": "National Gallery, Londres",
        "formatted_description": "Pintura por Hendrick ter Brugghen (1627). Acervo: National Gallery, Londres.",
        "license": "Public domain",
        "source": "Gênesis 29; tradição patriarcal"
    },
    {
        "pessoa_ids": ["pub_moises_joquebede"],
        "folder": imagens_base / "biblicas" / "moises" / "Joquebede",
        "file_name": "01_Joquebede.jpg",
        "commons_file": "File:Reproductie van een schilderij van Paul Delaroche, `Moïse exposé sur le Nil', RP-F-F25505-BP.jpg",
        "title": "Joquebede e Moisés no Nilo",
        "artist": "Paul Delaroche",
        "role": "pintor",
        "date_created": "1853",
        "museum": "Museu do Louvre / Wallace Collection",
        "formatted_description": "Pintura por Paul Delaroche (1853). Acervo: Museu do Louvre / Wallace Collection.",
        "license": "Public domain",
        "source": "Êxodo 2; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_jesse", "pub_mat_jesse", "pub_luc_jesse"],
        "folder": imagens_base / "biblicas" / "casa-de-davi" / "Jessé",
        "file_name": "01_Jessé.jpg",
        "commons_file": "File:Michelangelo, lunetta, Jesse - David - Solomon 01.jpg",
        "title": "Jessé, Davi e Salomão (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "Mateus 1 / 1 Samuel 16; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_rei_roboao", "pub_mat_roboao"],
        "folder": imagens_base / "biblicas" / "casa-de-davi" / "Roboão",
        "file_name": "01_Roboão.jpg",
        "commons_file": "File:Michelangelo, lunetta, Rehoboam - Abijah 01.jpg",
        "title": "Roboão e Abias (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "1 Reis 14 / Mateus 1; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_rei_asa", "pub_mat_asa"],
        "folder": imagens_base / "biblicas" / "casa-de-davi" / "Asa",
        "file_name": "01_Asa.jpg",
        "commons_file": "File:Michelangelo - Sistine chapel ceiling - Asa - Jehoshaphat - Joram.jpg",
        "title": "Asa, Josafá e Jorão (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "1 Reis 15 / Mateus 1; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_mat_josias"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Josias",
        "file_name": "01_Josias.jpg",
        "commons_file": "File:Michelangelo, lunetta, Josiah - Jechoniah - Shealtiel 01.jpg",
        "title": "Josias, Jeconias e Salatiel (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "2 Reis 22 / Mateus 1; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_mat_ezequias"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Ezequias",
        "file_name": "01_Ezequias.jpg",
        "commons_file": "File:Michelangelo - Sistine Chapel ceiling - Lunette \"Hezekiah - Manasseh - Amon\".jpg",
        "title": "Ezequias, Manassés e Amom (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "2 Reis 18 / Mateus 1; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_mat_zorobabel", "pub_luc_zorobabel"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Zorobabel",
        "file_name": "01_Zorobabel.jpg",
        "commons_file": "File:Michelangelo, lunetta, Zerubbabel - Abiud - Eliakim 01.jpg",
        "title": "Zorobabel, Abiúde e Eliaquim (Luneta)",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1511-1512",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1511-1512). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "Esdras 3 / Mateus 1; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_noe"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Noé",
        "file_name": "01_Noé.jpg",
        "commons_file": "File:Michelangelo, Sacrifice of Noah 01.jpg",
        "title": "O Sacrifício de Noé",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1509",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1509). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "Gênesis 8; afresco pontifício"
    },
    {
        "pessoa_ids": ["pub_enoque"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Enoque",
        "file_name": "01_Enoque.jpg",
        "commons_file": "File:Spas na Ilyine - Patriarch Enoch.jpg",
        "title": "Patriarca Enoque",
        "artist": "Teófanes, o Grego (Feofan Grek)",
        "role": "iconógrafo",
        "date_created": "1378",
        "museum": "Igreja da Transfiguração, Veliki Novgorod",
        "formatted_description": "Afresco / Ícone por Teófanes, o Grego (1378). Acervo: Igreja da Transfiguração.",
        "license": "Public domain",
        "source": "Gênesis 5; tradição ortodoxa"
    },
    {
        "pessoa_ids": ["pub_luc_pedro"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "São_Pedro",
        "file_name": "01_São_Pedro.jpg",
        "commons_file": "File:Martirio di San Pietro September 2015-1a.jpg",
        "title": "A Crucificação de São Pedro",
        "artist": "Caravaggio (Michelangelo Merisi da Caravaggio)",
        "role": "pintor",
        "date_created": "1601",
        "museum": "Basílica de Santa Maria del Popolo, Roma",
        "formatted_description": "Pintura por Caravaggio (1601). Acervo: Basílica de Santa Maria del Popolo, Roma.",
        "license": "Public domain",
        "source": "Evangelhos e Atos; patrística cristã"
    },
    {
        "pessoa_ids": ["pub_luc_andre"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Santo_André",
        "file_name": "01_Santo_André.jpg",
        "commons_file": "File:The Martyrdom of Saint Andrew. P.P. Rubens.jpg",
        "title": "O Martírio de Santo André",
        "artist": "Peter Paul Rubens",
        "role": "pintor",
        "date_created": "1628",
        "museum": "Fundación Carlos de Amberes, Madrid",
        "formatted_description": "Pintura por Peter Paul Rubens (1628). Acervo: Fundación Carlos de Amberes, Madrid.",
        "license": "Public domain",
        "source": "Evangelhos; patrística cristã"
    },
    {
        "pessoa_ids": ["pub_luc_tiago_maior"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "São_Tiago_Maior",
        "file_name": "01_São_Tiago_Maior.jpg",
        "commons_file": "File:Guido Reni - Saint James the Greater - Google Art Project.jpg",
        "title": "São Tiago Maior",
        "artist": "Guido Reni",
        "role": "pintor",
        "date_created": "1636-1638",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por Guido Reni (1636-1638). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Evangelhos e Atos; patrística cristã"
    },
    {
        "pessoa_ids": ["pub_luc_tiago_menor"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "São_Tiago_Menor",
        "file_name": "01_São_Tiago_Menor.jpg",
        "commons_file": "File:El Greco - St. James the Less (Glens Falls).JPG",
        "title": "São Tiago Menor",
        "artist": "El Greco (Doménikos Theotokópoulos)",
        "role": "pintor",
        "date_created": "1609",
        "museum": "The Hyde Collection, Glens Falls / Museu de El Greco, Toledo",
        "formatted_description": "Pintura por El Greco (1609). Acervo: The Hyde Collection.",
        "license": "Public domain",
        "source": "Evangelhos e Atos; patrística cristã"
    },
    {
        "pessoa_ids": ["pub_luc_joao_evangelista"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "São_João_Evangelista",
        "file_name": "01_São_João_Evangelista.jpg",
        "commons_file": "File:El Greco 043.jpg",
        "title": "São João Evangelista",
        "artist": "El Greco (Doménikos Theotokópoulos)",
        "role": "pintor",
        "date_created": "c. 1605",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por El Greco (c. 1605). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Evangelhos e Apocalipse; patrística cristã"
    },
    {
        "pessoa_ids": ["pub_luc_isabel"],
        "folder": imagens_base / "biblicas" / "jesus-genealogia" / "Santa_Isabel",
        "file_name": "01_Santa_Isabel.jpg",
        "commons_file": "File:La Visitation avec Marie-Jacobie et Marie-Salomé - Domenico Ghirlandaio - Musée du Louvre Peintures INV 297 ; MR 240 - avec cadre.jpg",
        "title": "A Visitação com Santa Isabel",
        "artist": "Domenico Ghirlandaio",
        "role": "pintor",
        "date_created": "1491",
        "museum": "Museu do Louvre, Paris",
        "formatted_description": "Pintura por Domenico Ghirlandaio (1491). Acervo: Museu do Louvre, Paris.",
        "license": "Public domain",
        "source": "Lucas 1; tradição bíblica"
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


def executar_batch1():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 1: Figuras Bíblicas & Mestres Clássicos")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH1_OBRAS:
        folder = item["folder"]
        folder.mkdir(parents=True, exist_ok=True)
        img_dest = folder / item["file_name"]
        json_dest = folder / f"{item['file_name'].rsplit('.', 1)[0]}.json"

        # Download da imagem se não existir ou for muito pequena
        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print(f"  Resolvendo URL: {item['title']} ({item['artist']})...")
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

    print(f"\n[Batch 1 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch1()
