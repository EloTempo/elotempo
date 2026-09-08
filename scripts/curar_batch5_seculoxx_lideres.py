"""
EloTempo - Curadoria de Obras Clássicas: Batch 5 (Século XX, Líderes e Chefes de Estado)
========================================================================================
Baixa e cadastra com metadados de fotografias e retratos oficiais de arquivo histórico:
- Chefes de Estado dos EUA: JFK (White House), Jackie Kennedy, Robert F. Kennedy,
  Theodore Roosevelt (Pach Bros / Casa Branca), FDR (1944 Color), Eleanor Roosevelt
- Argentina: Juan Domingo Perón & Eva Perón (Numa Ayrinhac, Museu do Bicentenário),
  Isabel Perón (faixa presidencial oficial)
- Figuras Históricas do Século XX: Josef Stalin, Mao Zedong, Benito Mussolini, Adolf Hitler
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; 20th century leaders; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH5_OBRAS = [
    {
        "pessoa_ids": ["pub_kennedy_john_f_kennedy"],
        "folder": imagens_base / "politicas" / "kennedy" / "John_F_Kennedy",
        "file_name": "01_John_F_Kennedy.jpg",
        "commons_file": "File:John F Kennedy Official Portrait.jpg",
        "title": "John F. Kennedy, 35º Presidente dos Estados Unidos",
        "artist": "Alfred Eisenstaedt / Fotografia Oficial da Casa Branca",
        "role": "fotógrafo",
        "date_created": "1961",
        "museum": "Biblioteca Presidencial John F. Kennedy, Boston",
        "formatted_description": "Retrato oficial da Presidência dos EUA (1961). Acervo: Casa Branca / JFK Library.",
        "license": "Public domain",
        "source": "Casa Branca; JFK Presidential Library"
    },
    {
        "pessoa_ids": ["pub_kennedy_jacqueline_kennedy_onassis"],
        "folder": imagens_base / "politicas" / "kennedy" / "Jacqueline_Kennedy",
        "file_name": "01_Jacqueline_Kennedy.png",
        "commons_file": "File:Jacqueline Kennedy in Diplomatic Reception Room, 1961.png",
        "title": "Jacqueline Bouvier Kennedy, Primeira-Dama dos Estados Unidos",
        "artist": "Fotografia Oficial da Casa Branca",
        "role": "fotógrafo",
        "date_created": "1961",
        "museum": "Casa Branca, Washington D.C.",
        "formatted_description": "Retrato oficial no Salão de Recepção Diplomática (1961). Acervo: Casa Branca.",
        "license": "Public domain",
        "source": "Casa Branca; Arquivos Nacionais dos EUA (NARA)"
    },
    {
        "pessoa_ids": ["pub_kennedy_robert_f_kennedy"],
        "folder": imagens_base / "politicas" / "kennedy" / "Robert_F_Kennedy",
        "file_name": "01_Robert_F_Kennedy.jpg",
        "commons_file": "File:RFK Portrait 3x4 (rotated).jpg",
        "title": "Robert F. Kennedy, Procurador-Geral e Senador dos EUA",
        "artist": "Fotografia Oficial do Departamento de Justiça",
        "role": "fotógrafo",
        "date_created": "c. 1963",
        "museum": "Departamento de Justiça dos EUA / NARA",
        "formatted_description": "Retrato oficial de Robert F. Kennedy (c. 1963). Acervo: Arquivos Nacionais dos EUA.",
        "license": "Public domain",
        "source": "US Department of Justice / NARA"
    },
    {
        "pessoa_ids": ["pub_roosevelt_theodore_roosevelt"],
        "folder": imagens_base / "politicas" / "roosevelt" / "Theodore_Roosevelt",
        "file_name": "01_Theodore_Roosevelt.jpg",
        "commons_file": "File:Theodore Roosevelt by the Pach Bros.jpg",
        "title": "Theodore Roosevelt, 26º Presidente dos Estados Unidos",
        "artist": "Pach Brothers",
        "role": "fotógrafo",
        "date_created": "1904",
        "museum": "Biblioteca do Congresso, Washington D.C.",
        "formatted_description": "Fotografia oficial de gabinete por Pach Brothers (1904). Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress, Prints and Photographs Division"
    },
    {
        "pessoa_ids": ["pub_roosevelt_franklin_d_roosevelt"],
        "folder": imagens_base / "politicas" / "roosevelt" / "Franklin_D_Roosevelt",
        "file_name": "01_Franklin_D_Roosevelt.jpg",
        "commons_file": "File:FDR 1944 Color Portrait.jpg",
        "title": "Franklin D. Roosevelt, 32º Presidente dos Estados Unidos",
        "artist": "Leon A. Perskie",
        "role": "fotógrafo",
        "date_created": "1944",
        "museum": "FDR Presidential Library, Hyde Park",
        "formatted_description": "Retrato fotográfico a cores por Leon A. Perskie (1944). Acervo: FDR Presidential Library.",
        "license": "Public domain",
        "source": "FDR Presidential Library and Museum / NARA"
    },
    {
        "pessoa_ids": ["pub_roosevelt_eleanor_roosevelt"],
        "folder": imagens_base / "politicas" / "roosevelt" / "Eleanor_Roosevelt",
        "file_name": "01_Eleanor_Roosevelt.jpg",
        "commons_file": "File:Eleanor-Roosevelt-WH-Portrait.jpg",
        "title": "Eleanor Roosevelt, Primeira-Dama e Diplomata dos Direitos Humanos",
        "artist": "Fotografia Oficial da Casa Branca",
        "role": "fotógrafo",
        "date_created": "1933",
        "museum": "Casa Branca, Washington D.C. / FDR Library",
        "formatted_description": "Retrato oficial da Casa Branca (1933). Acervo: FDR Presidential Library.",
        "license": "Public domain",
        "source": "Casa Branca; NARA"
    },
    {
        "pessoa_ids": ["pub_peron_juan_domingo_peron"],
        "folder": imagens_base / "politicas" / "peron" / "Juan_Domingo_Perón",
        "file_name": "01_Juan_Domingo_Perón.jpg",
        "commons_file": "File:Museo del Bicentenario - \"Retrato de Juan Domingo Perón y Eva Duarte\", Numa Ayrinhac.jpg",
        "title": "Juan Domingo Perón e Eva Perón",
        "artist": "Numa Ayrinhac",
        "role": "pintor",
        "date_created": "1948",
        "museum": "Museo del Bicentenario, Casa Rosada, Buenos Aires",
        "formatted_description": "Pintura oficial por Numa Ayrinhac (1948). Acervo: Museo del Bicentenario, Buenos Aires.",
        "license": "Public domain",
        "source": "Presidência da Nação Argentina / Museo del Bicentenario"
    },
    {
        "pessoa_ids": ["pub_peron_eva_peron"],
        "folder": imagens_base / "politicas" / "peron" / "Eva_Perón",
        "file_name": "01_Eva_Perón.jpg",
        "commons_file": "File:Museo del Bicentenario - \"Retrato de Juan Domingo Perón y Eva Duarte\", Numa Ayrinhac.jpg",
        "title": "Eva Duarte de Perón (Evita)",
        "artist": "Numa Ayrinhac",
        "role": "pintor",
        "date_created": "1948",
        "museum": "Museo del Bicentenario, Buenos Aires",
        "formatted_description": "Pintura oficial por Numa Ayrinhac (1948). Acervo: Museo del Bicentenario.",
        "license": "Public domain",
        "source": "Presidência da Nação Argentina / Museo del Bicentenario"
    },
    {
        "pessoa_ids": ["pub_peron_isabel_peron"],
        "folder": imagens_base / "politicas" / "peron" / "Isabel_Perón",
        "file_name": "01_Isabel_Perón.png",
        "commons_file": "File:Isabel peron banda presidencial y bastón.png",
        "title": "María Estela Martínez de Perón (Isabelita) com a Faixa Presidencial",
        "artist": "Fotografia Oficial da Presidência Argentina",
        "role": "fotógrafo",
        "date_created": "1974",
        "museum": "Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato oficial com faixa e bastão presidencial (1974). Acervo: Archivo General de la Nación Argentina.",
        "license": "Public domain",
        "source": "Archivo General de la Nación (Argentina)"
    },
    {
        "pessoa_ids": ["pub_stalin_stalin"],
        "folder": imagens_base / "ditadores" / "stalin" / "Josef_Stalin",
        "file_name": "01_Josef_Stalin.jpg",
        "commons_file": "File:Joseph Stalin official portrait.jpg",
        "title": "Josef Vissarionovitch Stalin",
        "artist": "Retrato Oficial Soviético",
        "role": "fotógrafo",
        "date_created": "c. 1945",
        "museum": "Arquivo Estatal da Federação Russa (GARF)",
        "formatted_description": "Retrato oficial como Generalíssimo da União Soviética (c. 1945). Acervo: Arquivo Estatal Russo.",
        "license": "Public domain",
        "source": "Agência de Notícias TASS / Arquivo Estatal Soviético"
    },
    {
        "pessoa_ids": ["pub_mao_mao_zedong"],
        "folder": imagens_base / "ditadores" / "mao" / "Mao_Zedong",
        "file_name": "01_Mao_Zedong.jpg",
        "commons_file": "File:Portrait of Chairman Mao on Tiananmen Gatetower.jpg",
        "title": "Retrato do Presidente Mao Tsé-Tung",
        "artist": "Zhang Zhenshi e oficina",
        "role": "pintor",
        "date_created": "1950",
        "museum": "Portão de Tiananmen, Pequim / Museu Nacional da China",
        "formatted_description": "Pintura a óleo monumental do Presidente Mao (1950). Acervo: Porta da Paz Celestial, Pequim.",
        "license": "CC BY-SA 3.0",
        "source": "Museu Nacional da China"
    },
    {
        "pessoa_ids": ["pub_mussolini_benito_mussolini"],
        "folder": imagens_base / "ditadores" / "mussolini" / "Benito_Mussolini",
        "file_name": "01_Benito_Mussolini.jpg",
        "commons_file": "File:Benito Mussolini colored.jpg",
        "title": "Benito Mussolini",
        "artist": "Istituto Luce / Arquivo Histórico Italiano",
        "role": "fotógrafo",
        "date_created": "c. 1935",
        "museum": "Archivio Centrale dello Stato, Roma",
        "formatted_description": "Fotografia oficial de Benito Mussolini (c. 1935). Acervo: Archivio Centrale dello Stato, Roma.",
        "license": "Public domain",
        "source": "Istituto Nazionale Luce / Archivio Centrale dello Stato"
    },
    {
        "pessoa_ids": ["pub_hitler_adolf_hitler"],
        "folder": imagens_base / "ditadores" / "hitler" / "Adolf_Hitler",
        "file_name": "01_Adolf_Hitler.jpg",
        "commons_file": "File:Adolf Hitler 1938 Portrait (3x4 cropped).jpg",
        "title": "Adolf Hitler",
        "artist": "Heinrich Hoffmann",
        "role": "fotógrafo",
        "date_created": "1938",
        "museum": "Bundesarchiv, Koblenz",
        "formatted_description": "Fotografia oficial por Heinrich Hoffmann (1938). Acervo: Arquivo Federal Alemão (Bundesarchiv).",
        "license": "CC BY-SA 3.0 DE",
        "source": "Deutsches Bundesarchiv, Bild 183-H1216-0500-002"
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


def executar_batch5():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 5: Século XX, Líderes & Chefes de Estado")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH5_OBRAS:
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

    print(f"\n[Batch 5 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch5()
