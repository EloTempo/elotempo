"""
EloTempo - Curadoria de Obras Clássicas: Batch 3 (Realeza Europeia: Habsburgo, Bragança, Windsor e Bourbon)
=============================================================================================================
Baixa e cadastra com metadados de mestres da arte régia (Ticiano, Sofonisba, Winterhalter, Vigée Le Brun,
Lawrence, Debret, Simplício de Sá, Hayter, Beaton, Sorolla):
- Habsburgo: Carlos V, Filipe II, Maria Antonieta, Sissi (Winterhalter oficial), Francisco José I, Carlos II
- Bragança: D. Pedro I, D. João VI, Carlota Joaquina, D. Maria I, D. Miguel I, D. Maria II, D. Pedro V
- Windsor: Vitória, Alberto, Edward VII, George V, George VI, Rainha Mãe, Elizabeth II, Philip, Charles III, Diana, William, Catherine
- Bourbon: Felipe VI, Vitória Eugénia
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; european royalty; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH3_OBRAS = [
    # --- HABSBURGO ---
    {
        "pessoa_ids": ["pub_habsburgo_carlos_v"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Carlos_V",
        "file_name": "01_Carlos_V.jpg",
        "commons_file": "File:Carlos V en Mühlberg, by Titian, from Prado in Google Earth.jpg",
        "title": "Carlos V a Cavalo em Mühlberg",
        "artist": "Ticiano (Tiziano Vecellio)",
        "role": "pintor",
        "date_created": "1548",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura a óleo por Ticiano (1548). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Coleção Real Espanhola; Museu do Prado"
    },
    {
        "pessoa_ids": ["pub_habsburgo_filipe_ii"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Filipe_II",
        "file_name": "01_Filipe_II.jpg",
        "commons_file": "File:Portrait of Philip II of Spain by Sofonisba Anguissola - 002b.jpg",
        "title": "Filipe II, Rei da Espanha",
        "artist": "Sofonisba Anguissola",
        "role": "pintora",
        "date_created": "1573",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por Sofonisba Anguissola (1573). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Coleção Real Espanhola; Museu do Prado"
    },
    {
        "pessoa_ids": ["pub_habsburgo_maria_antonieta"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Maria_Antonieta",
        "file_name": "01_Maria_Antonieta.jpg",
        "commons_file": "File:Louise Elisabeth Vigée-Lebrun - Marie-Antoinette dit « à la Rose » - Google Art Project.jpg",
        "title": "Maria Antonieta com uma Rosa",
        "artist": "Élisabeth Vigée Le Brun",
        "role": "pintora",
        "date_created": "1783",
        "museum": "Palácio de Versalhes",
        "formatted_description": "Pintura por Élisabeth Vigée Le Brun (1783). Acervo: Palácio de Versalhes.",
        "license": "Public domain",
        "source": "Palácio de Versalhes; história da França"
    },
    {
        "pessoa_ids": ["pub_habsburgo_isabel_da_baviera_sissi"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Imperatriz_Sissi",
        "file_name": "01_Imperatriz_Sissi.jpg",
        "commons_file": "File:Elisabeth of Austria, by Franz Xaver Winterhalter.jpg",
        "title": "Imperatriz Isabel da Áustria (Sissi) com Estrelas de Diamante",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor",
        "date_created": "1865",
        "museum": "Palácio Imperial de Hofburg, Viena",
        "formatted_description": "Pintura monumental por Franz Xaver Winterhalter (1865). Acervo: Palácio Imperial de Hofburg, Viena.",
        "license": "Public domain",
        "source": "Coleção Imperial Austríaca; Hofburg"
    },
    {
        "pessoa_ids": ["pub_habsburgo_francisco_jose_i"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Francisco_José_I",
        "file_name": "01_Francisco_José_I.jpg",
        "commons_file": "File:Portrait of Franz Joseph I by Franz Xaver Winterhalter.jpg",
        "title": "Imperador Francisco José I da Áustria",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor",
        "date_created": "1865",
        "museum": "Palácio Imperial de Hofburg, Viena",
        "formatted_description": "Pintura por Franz Xaver Winterhalter (1865). Acervo: Palácio de Hofburg, Viena.",
        "license": "Public domain",
        "source": "Coleção Imperial Austríaca; Hofburg"
    },
    {
        "pessoa_ids": ["pub_habsburgo_carlos_ii_da_espanha"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Carlos_II",
        "file_name": "01_Carlos_II.jpg",
        "commons_file": "File:Juan Carreno de Miranda 023.jpg",
        "title": "Carlos II da Espanha",
        "artist": "Juan Carreño de Miranda",
        "role": "pintor",
        "date_created": "1685",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por Juan Carreño de Miranda (1685). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Museu do Prado; história da Espanha"
    },

    # --- CASA REAL DE PORTUGAL (BRAGANÇA) ---
    {
        "pessoa_ids": ["pub_pedro1", "pub_indep_pedro_i", "pub_imp_pedro_i"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Pedro_I",
        "file_name": "01_D_Pedro_I.jpg",
        "commons_file": "File:Portrait of D. Pedro I (1826) - Google Art Project.jpg",
        "title": "D. Pedro I do Brasil e IV de Portugal em Grande Traje Imperial",
        "artist": "Simplício Rodrigues de Sá",
        "role": "pintor",
        "date_created": "1826",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Pintura a óleo por Simplício Rodrigues de Sá (1826). Acervo: Museu Histórico Nacional, RJ.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; Império do Brasil"
    },
    {
        "pessoa_ids": ["pub_joao6", "pub_indep_joao_vi"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_João_VI",
        "file_name": "01_D_João_VI.jpg",
        "commons_file": "File:Jean-Baptiste Debret - Retrato de D. João VI (MNBA 2). João VI .jpg",
        "title": "D. João VI, Rei do Reino Unido de Portugal, Brasil e Algarves",
        "artist": "Jean-Baptiste Debret",
        "role": "pintor",
        "date_created": "1817",
        "museum": "Museu Nacional de Belas Artes, Rio de Janeiro",
        "formatted_description": "Pintura por Jean-Baptiste Debret (1817). Acervo: Museu Nacional de Belas Artes, RJ.",
        "license": "Public domain",
        "source": "Missão Artística Francesa; MNBA"
    },
    {
        "pessoa_ids": ["pub_carlota", "pub_indep_carlota_joaquina"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Carlota_Joaquina",
        "file_name": "01_Carlota_Joaquina.jpg",
        "commons_file": "File:Carlota Joaquina of Spain - Vicente López y Portaña.jpg",
        "title": "Rainha Carlota Joaquina de Bourbon",
        "artist": "Vicente López y Portaña",
        "role": "pintor",
        "date_created": "c. 1823",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por Vicente López y Portaña (c. 1823). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Museu do Prado; história de Portugal e Espanha"
    },
    {
        "pessoa_ids": ["pub_maria1_pt"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Maria_I",
        "file_name": "01_D_Maria_I.jpg",
        "commons_file": "File:Maria I, Queen of Portugal - Giuseppe Troni, atribuído (Turim, 1739-Lisboa, 1810) - Google Cultural Institute.jpg",
        "title": "D. Maria I, Rainha de Portugal",
        "artist": "Giuseppe Troni",
        "role": "pintor",
        "date_created": "1783",
        "museum": "Palácio Nacional de Queluz, Portugal",
        "formatted_description": "Pintura por Giuseppe Troni (1783). Acervo: Palácio Nacional de Queluz.",
        "license": "Public domain",
        "source": "Palácio Nacional de Queluz; Parques de Sintra"
    },
    {
        "pessoa_ids": ["pub_miguel1"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Miguel_I",
        "file_name": "01_D_Miguel_I.jpg",
        "commons_file": "File:Dom Miguel I of Portugal.jpg",
        "title": "D. Miguel I, Rei de Portugal",
        "artist": "Pintor da Câmara Real Portuguesa",
        "role": "pintor",
        "date_created": "c. 1828",
        "museum": "Palácio das Necessidades, Lisboa",
        "formatted_description": "Retrato oficial em farda de Marechal-General (c. 1828). Acervo: Palácio das Necessidades.",
        "license": "Public domain",
        "source": "História de Portugal; Casa de Bragança"
    },
    {
        "pessoa_ids": ["pub_maria2"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Maria_II",
        "file_name": "01_D_Maria_II.jpg",
        "commons_file": "File:Sir Thomas Lawrence (1769-1830) - Maria II, Da Gloria, Queen of Portugal (1819-1853) - RCIN 401414 - Royal Collection.jpg",
        "title": "D. Maria II, Rainha de Portugal",
        "artist": "Sir Thomas Lawrence",
        "role": "pintor",
        "date_created": "1829",
        "museum": "Royal Collection Trust, Reino Unido",
        "formatted_description": "Pintura por Sir Thomas Lawrence (1829). Acervo: Royal Collection Trust.",
        "license": "Public domain",
        "source": "Royal Collection Trust; encomendada por George IV"
    },
    {
        "pessoa_ids": ["pub_pedro5_pt"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Pedro_V",
        "file_name": "01_D_Pedro_V.jpg",
        "commons_file": "File:Pedro V, King of Portugal - Winterhalter 1854.jpg",
        "title": "D. Pedro V, Rei de Portugal (O Esperançoso)",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor",
        "date_created": "1854",
        "museum": "Palácio Nacional da Ajuda, Lisboa",
        "formatted_description": "Pintura por Franz Xaver Winterhalter (1854). Acervo: Palácio Nacional da Ajuda.",
        "license": "Public domain",
        "source": "Palácio Nacional da Ajuda; Casa de Bragança"
    },

    # --- CASA REAL BRITÂNICA (WINDSOR) ---
    {
        "pessoa_ids": ["pub_vitoria_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rainha_Vitória",
        "file_name": "01_Rainha_Vitória.jpg",
        "commons_file": "File:George Hayter - Queen Victoria Taking the Coronation Oath, June 28, 1838 - Google Art Project.jpg",
        "title": "Rainha Vitória no Juramento de Coroação",
        "artist": "Sir George Hayter",
        "role": "pintor",
        "date_created": "1838",
        "museum": "Royal Collection Trust, Reino Unido",
        "formatted_description": "Pintura por Sir George Hayter (1838). Acervo: Royal Collection Trust.",
        "license": "Public domain",
        "source": "Royal Collection Trust; história britânica"
    },
    {
        "pessoa_ids": ["pub_alberto_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Príncipe_Alberto",
        "file_name": "01_Príncipe_Alberto.jpg",
        "commons_file": "File:Franz-Xaver Winterhalter - Albert de Saxe-Cobourg-Gotha, prince consort (1819-1861) - MV 4676 - Museum of the History of France.jpg",
        "title": "Príncipe Alberto de Saxe-Coburgo-Gota, Príncipe Consorte",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor",
        "date_created": "1842",
        "museum": "Royal Collection / Versalhes",
        "formatted_description": "Pintura por Franz Xaver Winterhalter (1842). Acervo: Royal Collection.",
        "license": "Public domain",
        "source": "Royal Collection Trust; Império Britânico"
    },
    {
        "pessoa_ids": ["pub_elizabeth2_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rainha_Elizabeth_II",
        "file_name": "01_Rainha_Elizabeth_II.png",
        "commons_file": "File:Elizabeth II coronation portrait.png",
        "title": "Rainha Elizabeth II em Trajes de Coroação com as Joias da Coroa",
        "artist": "Cecil Beaton",
        "role": "fotógrafo",
        "date_created": "1953",
        "museum": "Royal Collection Trust / Victoria and Albert Museum",
        "formatted_description": "Fotografia oficial de coroação por Cecil Beaton (1953). Acervo: Royal Collection Trust.",
        "license": "Public domain (Crown Copyright expirado)",
        "source": "Palácio de Buckingham; Royal Collection"
    },
    {
        "pessoa_ids": ["pub_elizabeth_mae_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rainha_Mãe_Elizabeth",
        "file_name": "01_Rainha_Mãe_Elizabeth.jpg",
        "commons_file": "File:Queen Elizabeth Bowes Lyon in Coronation Robes by Sir Gerald Kelly.jpg",
        "title": "Rainha Elizabeth Bowes-Lyon em Trajes de Coroação",
        "artist": "Sir Gerald Kelly",
        "role": "pintor",
        "date_created": "1938",
        "museum": "Royal Collection Trust",
        "formatted_description": "Pintura a óleo por Sir Gerald Kelly (1938). Acervo: Royal Collection Trust.",
        "license": "Public domain",
        "source": "Royal Collection Trust"
    },
    {
        "pessoa_ids": ["pub_charles3_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rei_Charles_III",
        "file_name": "01_Rei_Charles_III.jpg",
        "commons_file": "File:King Charles III (July 2023).jpg",
        "title": "Rei Charles III do Reino Unido",
        "artist": "Fotografia oficial régia",
        "role": "fotógrafo",
        "date_created": "2023",
        "museum": "Palácio de Buckingham",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Charles III (2023). Acervo: Palácio de Buckingham.",
        "license": "CC BY 2.0",
        "source": "Governo do Reino Unido / Casa Real"
    },
    {
        "pessoa_ids": ["pub_diana_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Princesa_Diana",
        "file_name": "01_Princesa_Diana.jpg",
        "commons_file": "File:Princess Diana 1985.jpg",
        "title": "Diana, Princesa de Gales",
        "artist": "Fotografia oficial da Casa de Gales",
        "role": "fotógrafo",
        "date_created": "1985",
        "museum": "Arquivo Nacional / Coleção Real",
        "formatted_description": "Retrato oficial de Diana, Princesa de Gales (1985). Acervo: Palácio de Kensington.",
        "license": "Public domain",
        "source": "White House / US National Archives"
    },
    {
        "pessoa_ids": ["pub_william_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Príncipe_William",
        "file_name": "01_Príncipe_William.jpg",
        "commons_file": "File:Prince William (9874180764).jpg",
        "title": "Príncipe William, Príncipe de Gales",
        "artist": "Fotografia oficial",
        "role": "fotógrafo",
        "date_created": "2013",
        "museum": "Palácio de Kensington",
        "formatted_description": "Retrato oficial de Sua Alteza Real o Príncipe William (2013). Acervo: Palácio de Kensington.",
        "license": "CC BY 2.0",
        "source": "Ministério da Defesa / Casa de Gales"
    },
    {
        "pessoa_ids": ["pub_catherine_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Princesa_Catherine",
        "file_name": "01_Princesa_Catherine.jpg",
        "commons_file": "File:2023 Princess of Wales (cropped)02.JPG",
        "title": "Catherine, Princesa de Gales (Kate Middleton)",
        "artist": "Fotografia oficial da Casa de Gales",
        "role": "fotógrafo",
        "date_created": "2023",
        "museum": "Palácio de Kensington",
        "formatted_description": "Retrato oficial de Catherine, Princesa de Gales (2023). Acervo: Palácio de Kensington.",
        "license": "CC BY-SA 4.0",
        "source": "Casa de Gales / Palácio de Kensington"
    },

    # --- BOURBON (ESPANHA) ---
    {
        "pessoa_ids": ["pub_bourbon_felipe_vi"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Felipe_VI",
        "file_name": "01_Felipe_VI.jpg",
        "commons_file": "File:SM El Rey Don Felipe VI (cropped).jpg",
        "title": "Felipe VI, Rei da Espanha",
        "artist": "Estela de Castro / Casa Real Espanhola",
        "role": "fotógrafa",
        "date_created": "2020",
        "museum": "Palácio Real de Madrid",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Felipe VI da Espanha por Estela de Castro (2020). Acervo: Palácio Real de Madrid.",
        "license": "CC BY 4.0",
        "source": "Casa de Su Majestad el Rey de España"
    },
    {
        "pessoa_ids": ["pub_bourbon_vitoria_eugenia"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Vitória_Eugénia",
        "file_name": "01_Vitória_Eugénia.jpg",
        "commons_file": "File:Joaquín Sorolla y Bastida - Victoria Eugenia, Queen of Spain - A54 - Hispanic Society of America.jpg",
        "title": "Vitória Eugénia de Battenberg, Rainha da Espanha",
        "artist": "Joaquín Sorolla",
        "role": "pintor",
        "date_created": "1911",
        "museum": "Hispanic Society of America, Nova York",
        "formatted_description": "Pintura impressionista por Joaquín Sorolla (1911). Acervo: Hispanic Society of America.",
        "license": "Public domain",
        "source": "Hispanic Society of America; monarquia espanhola"
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


def executar_batch3():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 3: Realeza Europeia & Monarquias Tradicionais")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH3_OBRAS:
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

    print(f"\n[Batch 3 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch3()
