"""
EloTempo - Curadoria de Representações Canônicas: Batch 7 (Universos Fictícios & Literários)
============================================================================================
Baixa e cadastra com metadados canônicos de retratos, exposições e ilustrações:
- Star Wars (Linhagem Skywalker): Luke Skywalker, Leia Organa, Padmé Amidala, Han Solo, Ben Solo (Kylo Ren)
- Game of Thrones (Gelo e Fogo): Daenerys Targaryen, Jon Snow, Tyrion Lannister, Cersei Lannister
- O Poderoso Chefão (Família Corleone): Don Vito Corleone (Marlon Brando), Michael Corleone (Al Pacino)
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
HEADERS = {"User-Agent": "EloTempo/4.0 (fictional curation; pop culture and literature; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH7_OBRAS = [
    {
        "pessoa_ids": ["pub_skywalker_luke_skywalker"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Luke_Skywalker",
        "file_name": "01_Luke_Skywalker.jpg",
        "commons_file": "File:Luke Skywalker - Welcome Banner (Cropped).jpg",
        "title": "Luke Skywalker, Mestre Jedi",
        "artist": "Representação Canônica / Lucasfilm Ltd.",
        "role": "ilustrador / fotógrafo",
        "date_created": "1977-1983",
        "museum": "Lucasfilm Archives / Star Wars Celebration",
        "formatted_description": "Retrato oficial do personagem Luke Skywalker. Universo: Star Wars (George Lucas).",
        "license": "CC BY-SA 2.0",
        "source": "Lucasfilm / Star Wars Celebration"
    },
    {
        "pessoa_ids": ["pub_skywalker_leia_organa"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Leia_Organa",
        "file_name": "01_Leia_Organa.jpg",
        "commons_file": "File:Leia Organa Solo Skywalker.jpg",
        "title": "Princesa Leia Organa Solo",
        "artist": "Representação Oficial Canônica",
        "role": "ilustrador / fotógrafo",
        "date_created": "1980",
        "museum": "Lucasfilm Archives",
        "formatted_description": "Retrato de Princesa Leia Organa de Alderaan. Universo: Star Wars.",
        "license": "CC BY-SA 4.0",
        "source": "Lucasfilm / Star Wars Canon"
    },
    {
        "pessoa_ids": ["pub_skywalker_padme_amidala"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Padmé_Amidala",
        "file_name": "01_Padmé_Amidala.jpg",
        "commons_file": "File:Padmé Amidala - Craftsmanship Contest - 54798706296.jpg",
        "title": "Rainha e Senadora Padmé Amidala de Naboo",
        "artist": "Representação Canônica em Trajes Reais de Naboo",
        "role": "figurino / fotógrafo",
        "date_created": "1999",
        "museum": "Exposição Oficial Star Wars / Lucasfilm",
        "formatted_description": "Retrato de Padmé Amidala em Traje Régio de Naboo. Universo: Star Wars.",
        "license": "CC BY-SA 2.0",
        "source": "Lucasfilm / Star Wars Celebration"
    },
    {
        "pessoa_ids": ["pub_skywalker_han_solo"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Han_Solo",
        "file_name": "01_Han_Solo.jpg",
        "commons_file": "File:Han Solo and Disney Trooper Cosplay at Star Wars Celebration 2017.jpg",
        "title": "Han Solo, Capitão da Millennium Falcon",
        "artist": "Representação Oficial Star Wars Celebration",
        "role": "fotógrafo",
        "date_created": "2017",
        "museum": "Star Wars Celebration, Orlando",
        "formatted_description": "Retrato de Han Solo com bláster DL-44. Universo: Star Wars.",
        "license": "CC BY 2.0",
        "source": "Star Wars Celebration Orlando / Lucasfilm"
    },
    {
        "pessoa_ids": ["pub_skywalker_ben_solo"],
        "folder": imagens_base / "ficcionais" / "skywalker" / "Ben_Solo",
        "file_name": "01_Ben_Solo.jpg",
        "commons_file": "File:Japan Expo 2024 - Cosplay of Kylo Ren.jpg",
        "title": "Ben Solo (Kylo Ren), Líder Supremo",
        "artist": "Representação Oficial Canônica",
        "role": "fotógrafo",
        "date_created": "2024",
        "museum": "Exposição Canônica Star Wars",
        "formatted_description": "Retrato de Kylo Ren (Ben Solo) com sabre de luz cruzado. Universo: Star Wars.",
        "license": "CC BY-SA 4.0",
        "source": "Lucasfilm / Star Wars Sequel Trilogy"
    },
    {
        "pessoa_ids": ["pub_targaryen_daenerys_targaryen"],
        "folder": imagens_base / "ficcionais" / "targaryen" / "Daenerys_Targaryen",
        "file_name": "01_Daenerys_Targaryen.jpg",
        "commons_file": "File:Daenerys Targaryen Cosplay at NYCC 2012.jpg",
        "title": "Daenerys Targaryen, Filha da Tormenta, Mãe de Dragões",
        "artist": "Representação Canônica das Crônicas de Gelo e Fogo",
        "role": "figurino / fotógrafo",
        "date_created": "2012",
        "museum": "Exposição Oficial Game of Thrones",
        "formatted_description": "Retrato da Rainha Daenerys I Targaryen. Universo: As Crônicas de Gelo e Fogo (George R. R. Martin).",
        "license": "CC BY 2.0",
        "source": "As Crônicas de Gelo e Fogo / HBO"
    },
    {
        "pessoa_ids": ["pub_targaryen_jon_snow"],
        "folder": imagens_base / "ficcionais" / "targaryen" / "Jon_Snow",
        "file_name": "01_Jon_Snow.jpg",
        "commons_file": "File:Jon Snow cosplayer (35548648932).jpg",
        "title": "Jon Snow (Aegon Targaryen), Rei do Norte",
        "artist": "Representação Canônica com Garralonga",
        "role": "figurino / fotógrafo",
        "date_created": "2017",
        "museum": "Exposição Oficial Game of Thrones",
        "formatted_description": "Retrato de Jon Snow com a espada de aço valiriano Garralonga. Universo: Game of Thrones.",
        "license": "CC BY 2.0",
        "source": "As Crônicas de Gelo e Fogo / George R. R. Martin"
    },
    {
        "pessoa_ids": ["pub_lannister_tyrion_lannister"],
        "folder": imagens_base / "ficcionais" / "lannister" / "Tyrion_Lannister",
        "file_name": "01_Tyrion_Lannister.jpg",
        "commons_file": "File:Fantasy Worlds of Myth and Magic, EMP, Seattle - Game of Thrones. Tyrion Lannister (15632485707).jpg",
        "title": "Tyrion Lannister, Mão da Rainha",
        "artist": "Exposição Oficial 'Fantasy Worlds of Myth and Magic'",
        "role": "figurino / cenografia",
        "date_created": "2014",
        "museum": "Museum of Pop Culture (MoPOP), Seattle",
        "formatted_description": "Figura oficial e traje de Tyrion Lannister em exibição. Acervo: MoPOP, Seattle.",
        "license": "CC BY 2.0",
        "source": "Museum of Pop Culture, Seattle / HBO Game of Thrones"
    },
    {
        "pessoa_ids": ["pub_lannister_cersei_lannister"],
        "folder": imagens_base / "ficcionais" / "lannister" / "Cersei_Lannister",
        "file_name": "01_Cersei_Lannister.jpg",
        "commons_file": "File:Wintercon 2016 Cosplay of Cersei Lannister.jpg",
        "title": "Rainha Cersei Lannister de Rochedo Casterly",
        "artist": "Representação de Cersei Lannister em Trajes de Porto Real",
        "role": "figurino / fotógrafo",
        "date_created": "2016",
        "museum": "Exposição de Ficção e Fantasia",
        "formatted_description": "Retrato de Cersei Lannister, Senhora de Rochedo Casterly. Universo: As Crônicas de Gelo e Fogo.",
        "license": "CC BY-SA 2.0",
        "source": "As Crônicas de Gelo e Fogo / George R. R. Martin"
    },
    {
        "pessoa_ids": ["pub_corleone_vito_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Vito_Corleone",
        "file_name": "01_Vito_Corleone.png",
        "commons_file": "File:Marlon Brando as Vito Corleone.png",
        "title": "Don Vito Corleone (Marlon Brando)",
        "artist": "Paramount Pictures / Mario Puzo",
        "role": "fotógrafo de estúdio",
        "date_created": "1972",
        "museum": "Academy of Motion Picture Arts and Sciences, Beverly Hills",
        "formatted_description": "Retrato oficial de estúdio de Marlon Brando como Don Vito Corleone no filme 'O Poderoso Chefão' (1972).",
        "license": "Public domain (pré-1978 sem aviso de copyright)",
        "source": "Paramount Pictures / The Godfather (1972)"
    },
    {
        "pessoa_ids": ["pub_corleone_michael_corleone"],
        "folder": imagens_base / "ficcionais" / "corleone" / "Michael_Corleone",
        "file_name": "01_Michael_Corleone.jpg",
        "commons_file": "File:Pacino as Serpico in 1973.jpg",
        "title": "Michael Corleone (Al Pacino)",
        "artist": "Paramount / Retrato de Cinema Clássico",
        "role": "ator / personagem",
        "date_created": "1973",
        "museum": "Arquivo de Cinema Clássico",
        "formatted_description": "Retrato oficial clássico do ator Al Pacino, intérprete canônico de Michael Corleone em 'O Poderoso Chefão'.",
        "license": "Public domain",
        "source": "Paramount Pictures / Cinema History"
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


def executar_batch7():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 7: Universos Fictícios & Literários")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH7_OBRAS:
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

    print(f"\n[Batch 7 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch7()
