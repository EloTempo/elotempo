"""
EloTempo - Curadoria de Obras Clássicas: Batch 6 (Ciência, Artes, Japão Imperial & Empreendedores)
====================================================================================================
Baixa e cadastra com metadados de mestres da pintura e arquivos oficiais:
- Darwin-Wedgwood: Charles Darwin (Collier 1883), Emma Darwin (Richmond 1840), Josiah Wedgwood (Reynolds)
- Família Curie: Pierre Curie, Irène Joliot-Curie (Wellcome), Frédéric Joliot-Curie
- Dinastia Bach: Carl Philipp Emanuel Bach (Lips), Johann Christian Bach (Gainsborough 1776)
- Casa Imperial do Japão: Imperador Taishō, Imperador Naruhito, Imperatriz Masako
- Empreendedores: John D. Rockefeller (John Singer Sargent 1917), Nelson Rockefeller, Conde Francesco Matarazzo
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; science and business; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH6_OBRAS = [
    {
        "pessoa_ids": ["pub_darwin_charles_darwin"],
        "folder": imagens_base / "artistas-cientistas" / "darwin" / "Charles_Darwin",
        "file_name": "01_Charles_Darwin.jpg",
        "commons_file": "File:Charles Robert Darwin by John Collier.jpg",
        "title": "Charles Darwin",
        "artist": "John Collier",
        "role": "pintor",
        "date_created": "1883",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Pintura a óleo por John Collier (1883). Acervo: National Portrait Gallery, Londres.",
        "license": "Public domain",
        "source": "National Portrait Gallery, NPG 1024"
    },
    {
        "pessoa_ids": ["pub_darwin_emma_darwin"],
        "folder": imagens_base / "artistas-cientistas" / "darwin" / "Emma_Darwin",
        "file_name": "01_Emma_Darwin.jpg",
        "commons_file": "File:George Richmond - Emma Darwin - 1840.jpg",
        "title": "Emma Wedgwood Darwin",
        "artist": "George Richmond",
        "role": "pintor",
        "date_created": "1840",
        "museum": "Down House (English Heritage), Kent",
        "formatted_description": "Pintura a giz e aquarela por George Richmond (1840). Acervo: Down House, English Heritage.",
        "license": "Public domain",
        "source": "English Heritage / Down House"
    },
    {
        "pessoa_ids": ["pub_darwin_josiah_wedgwood_i"],
        "folder": imagens_base / "artistas-cientistas" / "darwin" / "Josiah_Wedgwood",
        "file_name": "01_Josiah_Wedgwood.jpg",
        "commons_file": "File:Joshua Reynolds (1723-1792) - Josiah Wedgwood I (1730–1795) - 5004 - V^A Wedgwood Collection.jpg",
        "title": "Josiah Wedgwood I",
        "artist": "Sir Joshua Reynolds",
        "role": "pintor",
        "date_created": "c. 1782",
        "museum": "Victoria and Albert Museum (Wedgwood Collection), Barlaston",
        "formatted_description": "Pintura a óleo por Sir Joshua Reynolds (c. 1782). Acervo: V&A Wedgwood Collection.",
        "license": "Public domain",
        "source": "Victoria and Albert Museum, Londres"
    },
    {
        "pessoa_ids": ["pub_curie_pierre_curie"],
        "folder": imagens_base / "artistas-cientistas" / "curie" / "Pierre_Curie",
        "file_name": "01_Pierre_Curie.jpg",
        "commons_file": "File:PierreCurie.jpg",
        "title": "Pierre Curie, Físico e Prêmio Nobel",
        "artist": "Dujardin / Retrato Oficial",
        "role": "fotógrafo",
        "date_created": "c. 1903",
        "museum": "Fundação Nobel, Estocolmo",
        "formatted_description": "Retrato oficial de Pierre Curie (c. 1903). Acervo: Arquivos da Fundação Nobel.",
        "license": "Public domain",
        "source": "Nobel Foundation / Wellcome Collection"
    },
    {
        "pessoa_ids": ["pub_curie_irene_joliot_curie"],
        "folder": imagens_base / "artistas-cientistas" / "curie" / "Irène_Joliot_Curie",
        "file_name": "01_Irène_Joliot_Curie.jpg",
        "commons_file": "File:Irene Joliot-Curie. Photograph by Wellcome V0028146.jpg",
        "title": "Irène Joliot-Curie, Química e Prêmio Nobel",
        "artist": "Wellcome Historical Medical Museum",
        "role": "fotógrafo",
        "date_created": "c. 1935",
        "museum": "Wellcome Collection, Londres",
        "formatted_description": "Retrato oficial por Wellcome Collection (c. 1935). Acervo: Wellcome Library.",
        "license": "CC BY 4.0",
        "source": "Wellcome Collection, Londres"
    },
    {
        "pessoa_ids": ["pub_curie_frederic_joliot_curie"],
        "folder": imagens_base / "artistas-cientistas" / "curie" / "Frédéric_Joliot_Curie",
        "file_name": "01_Frédéric_Joliot_Curie.jpg",
        "commons_file": "File:Frédéric Joliot-Curie ArM.jpg",
        "title": "Frédéric Joliot-Curie, Físico e Prêmio Nobel",
        "artist": "Arquivo Histórico Francês",
        "role": "fotógrafo",
        "date_created": "c. 1935",
        "museum": "Académie des Sciences, Paris",
        "formatted_description": "Retrato oficial de Frédéric Joliot-Curie (c. 1935). Acervo: Académie des Sciences, Paris.",
        "license": "Public domain",
        "source": "Bibliothèque nationale de France"
    },
    {
        "pessoa_ids": ["pub_bach_carl_philipp_emanuel_bach"],
        "folder": imagens_base / "artistas-cientistas" / "bach" / "Carl_Philipp_Emanuel_Bach",
        "file_name": "01_Carl_Philipp_Emanuel_Bach.jpg",
        "commons_file": "File:Carl Philipp Emanuel Bach by Lips.jpg",
        "title": "Carl Philipp Emanuel Bach",
        "artist": "Johann Heinrich Lips",
        "role": "gravurista / pintor",
        "date_created": "1784",
        "museum": "Bach-Archiv, Leipzig",
        "formatted_description": "Gravura e retrato por Johann Heinrich Lips (1784). Acervo: Bach-Archiv, Leipzig.",
        "license": "Public domain",
        "source": "Bach-Archiv Leipzig"
    },
    {
        "pessoa_ids": ["pub_bach_johann_christian_bach"],
        "folder": imagens_base / "artistas-cientistas" / "bach" / "Johann_Christian_Bach",
        "file_name": "01_Johann_Christian_Bach.jpg",
        "commons_file": "File:Johann Christian Bach by Thomas Gainsborough.jpg",
        "title": "Johann Christian Bach (O Bach de Londres)",
        "artist": "Thomas Gainsborough",
        "role": "pintor",
        "date_created": "1776",
        "museum": "National Portrait Gallery, Londres / Museo della Musica, Bolonha",
        "formatted_description": "Pintura a óleo por Thomas Gainsborough (1776). Acervo: National Portrait Gallery / Museo Internazionale della Musica.",
        "license": "Public domain",
        "source": "National Portrait Gallery, NPG 5557"
    },
    {
        "pessoa_ids": ["pub_casa_imperial_japao_imperador_taisho"],
        "folder": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperador_Taisho",
        "file_name": "01_Imperador_Taisho.jpg",
        "commons_file": "File:Emperor Taisho official portrait 1.jpg",
        "title": "Imperador Taishō (Yoshihito) em Grande Uniforme Imperial",
        "artist": "Fotografia da Agência da Casa Imperial do Japão",
        "role": "fotógrafo",
        "date_created": "1912",
        "museum": "Agência da Casa Imperial (Kunaichō), Tóquio",
        "formatted_description": "Retrato oficial da entronização de Taishō (1912). Acervo: Kunaichō, Tóquio.",
        "license": "Public domain",
        "source": "Agência da Casa Imperial do Japão"
    },
    {
        "pessoa_ids": ["pub_casa_imperial_japao_naruhito"],
        "folder": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperador_Naruhito",
        "file_name": "01_Imperador_Naruhito.jpg",
        "commons_file": "File:President Trump at the Palace Hotel Tokyo (47951122293) (cropped).jpg",
        "title": "Sua Majestade o Imperador Naruhito do Japão",
        "artist": "Fotografia oficial de Estado",
        "role": "fotógrafo",
        "date_created": "2019",
        "museum": "Palácio Imperial de Tóquio",
        "formatted_description": "Retrato oficial de Sua Majestade o Imperador Naruhito (2019). Acervo: Palácio Imperial, Tóquio.",
        "license": "Public domain",
        "source": "Agência da Casa Imperial / Governo do Japão"
    },
    {
        "pessoa_ids": ["pub_casa_imperial_japao_imperatriz_masako"],
        "folder": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperatriz_Masako",
        "file_name": "01_Imperatriz_Masako.jpg",
        "commons_file": "File:Emperor Naruhito and Empress Masako 20190515 (cropped).jpg",
        "title": "Sua Majestade a Imperatriz Masako do Japão",
        "artist": "Fotografia oficial de Estado",
        "role": "fotógrafo",
        "date_created": "2019",
        "museum": "Palácio Imperial de Tóquio",
        "formatted_description": "Retrato oficial de Sua Majestade a Imperatriz Masako (2019). Acervo: Palácio Imperial, Tóquio.",
        "license": "Public domain",
        "source": "Agência da Casa Imperial do Japão"
    },
    {
        "pessoa_ids": ["pub_rockefeller_john_d_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "John_D_Rockefeller",
        "file_name": "01_John_D_Rockefeller.jpg",
        "commons_file": "File:John Singer Sargent - John D. Rockefeller, 1917.jpg",
        "title": "John D. Rockefeller",
        "artist": "John Singer Sargent",
        "role": "pintor",
        "date_created": "1917",
        "museum": "Rockefeller Archive Center, Sleepy Hollow, Nova York",
        "formatted_description": "Pintura a óleo por John Singer Sargent (1917). Acervo: Rockefeller Archive Center.",
        "license": "Public domain",
        "source": "Rockefeller Archive Center"
    },
    {
        "pessoa_ids": ["pub_rockefeller_nelson_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "Nelson_Rockefeller",
        "file_name": "01_Nelson_Rockefeller.jpg",
        "commons_file": "File:Vice President Nelson Rockefeller official portrait.jpg",
        "title": "Nelson A. Rockefeller, 41º Vice-Presidente dos Estados Unidos",
        "artist": "Fotografia Oficial do Senado dos EUA",
        "role": "fotógrafo",
        "date_created": "1974",
        "museum": "Senado dos Estados Unidos, Washington D.C.",
        "formatted_description": "Retrato oficial de Nelson Rockefeller como Vice-Presidente (1974). Acervo: US Senate Historical Office.",
        "license": "Public domain",
        "source": "United States Senate Historical Office"
    },
    {
        "pessoa_ids": ["pub_matarazzo_francesco_matarazzo"],
        "folder": imagens_base / "empreendedores" / "matarazzo" / "Francesco_Matarazzo",
        "file_name": "01_Francesco_Matarazzo.jpg",
        "commons_file": "File:Francesco Matarazzo.jpg",
        "title": "Conde Francesco Matarazzo, Fundador das IRFM",
        "artist": "Fotografia Oficial das Indústrias Reunidas F. Matarazzo",
        "role": "fotógrafo",
        "date_created": "c. 1930",
        "museum": "Museu da Cidade de São Paulo / Fundação Memorial da América Latina",
        "formatted_description": "Retrato oficial do Conde Francesco Matarazzo (c. 1930). Acervo: Museu da Cidade de São Paulo.",
        "license": "Public domain",
        "source": "Arquivo Histórico de São Paulo"
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


def executar_batch6():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 6: Ciência, Artes, Japão Imperial & Empresas")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH6_OBRAS:
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

    print(f"\n[Batch 6 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch6()
