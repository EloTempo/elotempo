"""
EloTempo - Curadoria de Representações Históricas: Batch 11 (Grandes Empreendedores & Dinastias Globais)
========================================================================================================
Baixa e cadastra com metadados estruturados:
- Dinastia Bush: George H. W. Bush, George W. Bush, Barbara Bush, Laura Bush, Jeb Bush, Prescott Bush, Samuel P. Bush, George P. Bush, Jenna Bush, Dorothy Walker Bush
- Dinastia Rockefeller: John D. Rockefeller Jr., Abby Aldrich Rockefeller, David Rockefeller, William Rockefeller, John D. Rockefeller III, Jay Rockefeller, Laurance Rockefeller
- Dinastia Matarazzo: Francisco Matarazzo Jr. (Conde Chiquinho), Ermelino Matarazzo
- Família Guinle: Eduardo Palassin Guinle, Guilhermina Coutinho Guinle, Jorginho Guinle
- Família Klabin-Lafer: Maurício Freeman Klabin, Horácio Lafer, Celso Lafer
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
HEADERS = {"User-Agent": "EloTempo/4.0 (entrepreneurs curation; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH11_OBRAS = [
    # --- DINASTIA BUSH ---
    {
        "pessoa_ids": ["pub_bush_george_h_w_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "George_H_W_Bush",
        "file_name": "01_George_H_W_Bush.jpg",
        "commons_file": "File:Official portrait of President George H W Bush January 1992.jpg",
        "title": "George H. W. Bush, 41º Presidente dos Estados Unidos",
        "artist": "David Valdez / Casa Branca",
        "role": "fotógrafo oficial da Casa Branca",
        "date_created": "1992",
        "museum": "White House Historical Association / Library of Congress",
        "formatted_description": "Retrato oficial da Casa Branca de George H. W. Bush no Salão Oval.",
        "license": "Public domain",
        "source": "White House / Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_george_w_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "George_W_Bush",
        "file_name": "01_George_W_Bush.png",
        "commons_file": "File:George W. Bush 2003 (4x5).png",
        "title": "George W. Bush, 43º Presidente dos Estados Unidos",
        "artist": "Eric Draper / Casa Branca",
        "role": "fotógrafo oficial da Casa Branca",
        "date_created": "2003",
        "museum": "White House Historical Association / National Archives and Records Administration (NARA)",
        "formatted_description": "Retrato oficial presidencial de George W. Bush.",
        "license": "Public domain",
        "source": "White House / NARA / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_barbara_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Barbara_Bush",
        "file_name": "01_Barbara_Bush.jpg",
        "commons_file": "File:Barbara Bush, official portrait (1992) (cropped).jpg",
        "title": "Barbara Bush, Primeira-Dama dos Estados Unidos",
        "artist": "Casa Branca / David Valdez",
        "role": "fotógrafo oficial",
        "date_created": "1992",
        "museum": "White House Historical Association / George H. W. Bush Presidential Library",
        "formatted_description": "Retrato oficial de Barbara Pierce Bush com colar de pérolas triplo.",
        "license": "Public domain",
        "source": "White House / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_laura_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Laura_Bush",
        "file_name": "01_Laura_Bush.jpg",
        "commons_file": "File:Laura Bush portrait.jpg",
        "title": "Laura Welch Bush, Primeira-Dama dos Estados Unidos",
        "artist": "Casa Branca / Krisanne Johnson",
        "role": "fotógrafa oficial",
        "date_created": "2005",
        "museum": "George W. Bush Presidential Library / NARA",
        "formatted_description": "Retrato oficial da Casa Branca de Laura Welch Bush.",
        "license": "Public domain",
        "source": "White House / NARA / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_jeb_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Jeb_Bush",
        "file_name": "01_Jeb_Bush.jpg",
        "commons_file": "File:Jeb Bush by Gage Skidmore 8.jpg",
        "title": "Jeb Bush, 43º Governador da Flórida",
        "artist": "Gage Skidmore",
        "role": "fotógrafo",
        "date_created": "2015",
        "museum": "Coleção Gage Skidmore / Wikimedia Commons",
        "formatted_description": "Retrato de John Ellis 'Jeb' Bush.",
        "license": "CC BY-SA 3.0",
        "source": "Gage Skidmore / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_prescott_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Prescott_Bush",
        "file_name": "01_Prescott_Bush.jpg",
        "commons_file": "File:PrescottBush.jpg",
        "title": "Senador Prescott Bush",
        "artist": "Senado dos Estados Unidos / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "c. 1955",
        "museum": "United States Senate Historical Office, Washington, D.C.",
        "formatted_description": "Retrato de Prescott Bush, senador por Connecticut e fundador da linhagem política da família Bush.",
        "license": "Public domain",
        "source": "U.S. Senate Historical Office / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_samuel_p_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Samuel_P_Bush",
        "file_name": "01_Samuel_P_Bush.jpg",
        "commons_file": "File:Drawing Of Samuel P. Bush.jpg",
        "title": "Samuel Prescott Bush, Patriarca Industrial",
        "artist": "Ilustração e Retrato Histórico Industrial",
        "role": "ilustrador",
        "date_created": "c. 1918",
        "museum": "Buckeye Steel Castings Archives / Library of Congress",
        "formatted_description": "Retrato histórico de Samuel P. Bush, pioneiro industrial do aço e assessor da War Industries Board na 1ª Guerra.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_george_p_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "George_P_Bush",
        "file_name": "01_George_P_Bush.jpg",
        "commons_file": "File:George P. Bush crop.jpg",
        "title": "George P. Bush, Comissário do Texas",
        "artist": "Texas General Land Office",
        "role": "fotógrafo oficial",
        "date_created": "2015",
        "museum": "Texas State Archives, Austin",
        "formatted_description": "Retrato oficial de George Prescott Bush, filho de Jeb Bush.",
        "license": "Public domain",
        "source": "Texas General Land Office / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_jenna_bush_hager"],
        "folder": imagens_base / "empreendedores" / "bush" / "Jenna_Bush",
        "file_name": "01_Jenna_Bush.jpg",
        "commons_file": "File:Jenna Bush Hager 2017 2.jpg",
        "title": "Jenna Bush Hager, Jornalista e Autora",
        "artist": "Montclair Film Festival / Foto Editorial",
        "role": "fotógrafo",
        "date_created": "2017",
        "museum": "Coleção Editorial NBC / Wikimedia Commons",
        "formatted_description": "Retrato de Jenna Welch Bush Hager, filha de George W. Bush.",
        "license": "CC BY 2.0",
        "source": "Montclair Film / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bush_dorothy_walker_bush"],
        "folder": imagens_base / "empreendedores" / "bush" / "Dorothy_Walker_Bush",
        "file_name": "01_Dorothy_Walker_Bush.jpg",
        "commons_file": "File:Prescott and Dorothy Bush 1952.jpg",
        "title": "Dorothy Walker Bush, Matriarca da Família Bush",
        "artist": "Fotografia Histórica da Família Bush",
        "role": "fotógrafo",
        "date_created": "1952",
        "museum": "George H. W. Bush Presidential Library",
        "formatted_description": "Retrato de Dorothy Walker Bush, mãe de George H. W. Bush.",
        "license": "Public domain",
        "source": "Bush Presidential Library / Wikimedia Commons"
    },

    # --- DINASTIA ROCKEFELLER ---
    {
        "pessoa_ids": ["pub_rockefeller_john_d_rockefeller_jr"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "John_D_Rockefeller_Jr",
        "file_name": "01_John_D_Rockefeller_Jr.jpg",
        "commons_file": "File:John D. Rockefeller Jr. cph.3a03736.jpg",
        "title": "John D. Rockefeller Jr., Filantropo e Construtor",
        "artist": "Underwood & Underwood / Bain News Service",
        "role": "fotógrafo",
        "date_created": "c. 1920",
        "museum": "Library of Congress, Washington, D.C. / Rockefeller Archive Center",
        "formatted_description": "Retrato de estúdio de John D. Rockefeller Jr., idealizador do Rockefeller Center e grande filantropo das artes e preservação histórica.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_abby_aldrich_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "Abby_Aldrich_Rockefeller",
        "file_name": "01_Abby_Aldrich_Rockefeller.jpg",
        "commons_file": "File:Abigail Rockefeller 1893.jpg",
        "title": "Abby Aldrich Rockefeller, Cofundadora do MoMA",
        "artist": "Retrato Fotográfico Oitocentista",
        "role": "fotógrafo",
        "date_created": "1893",
        "museum": "Museum of Modern Art (MoMA), Nova York / Rockefeller Archive Center",
        "formatted_description": "Retrato da patrona das artes modernistas Abby Aldrich Rockefeller, principal fundadora do MoMA.",
        "license": "Public domain",
        "source": "Rockefeller Archive Center / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_david_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "David_Rockefeller",
        "file_name": "01_David_Rockefeller.jpg",
        "commons_file": "File:Investcorp, Dr. Jawad Hashim, David Rockefeller, Nemir Kirdar.jpg",
        "title": "David Rockefeller, Presidente do Chase Manhattan Bank",
        "artist": "Fotografia Corporativa Oficial",
        "role": "fotógrafo",
        "date_created": "1982",
        "museum": "Rockefeller Archive Center / Chase Historical Collection",
        "formatted_description": "Retrato de David Rockefeller, banqueiro internacional e estadista econômico global.",
        "license": "CC BY-SA 4.0",
        "source": "Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_william_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "William_Rockefeller",
        "file_name": "01_William_Rockefeller.jpg",
        "commons_file": "File:William Rockefeller.jpg",
        "title": "William Rockefeller Jr., Cofundador da Standard Oil",
        "artist": "Pach Brothers",
        "role": "fotógrafos de retratos",
        "date_created": "c. 1910",
        "museum": "Library of Congress / National Portrait Gallery, Washington, D.C.",
        "formatted_description": "Retrato de estúdio de William Rockefeller Jr., financista e cofundador da Standard Oil.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_john_d_rockefeller_iii"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "John_D_Rockefeller_III",
        "file_name": "01_John_D_Rockefeller_III.jpg",
        "commons_file": "File:POPULATION GROWTH COMMISSION. Press Conf. Charm. John Rockefeller, III.jpg",
        "title": "John D. Rockefeller III, Presidente da Lincoln Center",
        "artist": "Thomas J. O'Halloran / U.S. News & World Report",
        "role": "repórter fotográfico",
        "date_created": "1972",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato de John D. Rockefeller III, líder filantrópico e criador do Lincoln Center for the Performing Arts.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_john_d_rockefeller_iv"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "Jay_Rockefeller",
        "file_name": "01_Jay_Rockefeller.jpg",
        "commons_file": "File:Jay Rockefeller official photo.jpg",
        "title": "Jay Rockefeller (John D. Rockefeller IV), Senador dos EUA",
        "artist": "Senado dos Estados Unidos / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "2009",
        "museum": "United States Senate Historical Office, Washington, D.C.",
        "formatted_description": "Retrato oficial do senador John D. 'Jay' Rockefeller IV, bisneto do fundador da Standard Oil.",
        "license": "Public domain",
        "source": "U.S. Senate / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_rockefeller_laurance_rockefeller"],
        "folder": imagens_base / "empreendedores" / "rockefeller" / "Laurance_Rockefeller",
        "file_name": "01_Laurance_Rockefeller.jpg",
        "commons_file": "File:Laurance S. Rockefeller NYWTS.jpg",
        "title": "Laurance Spelman Rockefeller, Pioneiro do Capital de Risco",
        "artist": "Phil Stanziola / New York World-Telegram and the Sun",
        "role": "fotógrafo de imprensa",
        "date_created": "1960",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato de Laurance S. Rockefeller, grande conservacionista e pioneiro do capital de risco tecnológico.",
        "license": "Public domain",
        "source": "Library of Congress / Wikimedia Commons"
    },

    # --- DINASTIA MATARAZZO ---
    {
        "pessoa_ids": ["pub_matarazzo_francisco_matarazzo_junior"],
        "folder": imagens_base / "empreendedores" / "matarazzo" / "Francisco_Matarazzo_Jr",
        "file_name": "01_Francisco_Matarazzo_Jr.jpg",
        "commons_file": "File:Francisco Matarazzo Jr (1945).jpg",
        "title": "Conde Francisco Matarazzo Júnior (Conde Chiquinho)",
        "artist": "Agência Nacional / Arquivo Nacional do Brasil",
        "role": "fotógrafo oficial",
        "date_created": "1945",
        "museum": "Arquivo Nacional, Rio de Janeiro",
        "formatted_description": "Retrato do Conde Francisco Matarazzo Júnior, líder das Indústrias Reunidas Francisco Matarazzo (IRFM) por mais de quatro décadas.",
        "license": "Public domain",
        "source": "Arquivo Nacional (Brasil) / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_matarazzo_ermelino_matarazzo"],
        "folder": imagens_base / "empreendedores" / "matarazzo" / "Ermelino_Matarazzo",
        "file_name": "01_Ermelino_Matarazzo.jpg",
        "commons_file": "File:Comendador Ermelino Matarazzo.jpg",
        "title": "Comendador Ermelino Matarazzo",
        "artist": "Acervo Histórico Matarazzo",
        "role": "fotógrafo",
        "date_created": "c. 1915",
        "museum": "Museu da Cidade de São Paulo / Acervo Histórico",
        "formatted_description": "Retrato do industrial paulista Ermelino Matarazzo, filho do Conde Francesco Matarazzo.",
        "license": "Public domain",
        "source": "Acervo Histórico / Wikimedia Commons"
    },

    # --- FAMÍLIA GUINLE ---
    {
        "pessoa_ids": ["pub_guinle_eduardo_palassin_guinle", "pub_guinle_guilhermina_coutinho_da_silva"],
        "folder": imagens_base / "empreendedores" / "guinle" / "Eduardo_e_Guilhermina_Guinle",
        "file_name": "01_Eduardo_e_Guilhermina_Guinle.png",
        "commons_file": "File:Eduardo Palassin Guinle (1846-1912) e esposa Guilhermina (1854-1925).png",
        "title": "Eduardo Palassin Guinle e Guilhermina Coutinho Guinle",
        "artist": "Atelier Fotográfico da Corte Imperial e Republicana",
        "role": "fotógrafo",
        "date_created": "c. 1900",
        "museum": "Fundação Palácio Laranjeiras / Museu Histórico Nacional",
        "formatted_description": "Retrato histórico do pioneiro da Companhia Docas de Santos Eduardo Palassin Guinle e de sua esposa Guilhermina Coutinho da Silva.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_guinle_jorge_guinle"],
        "folder": imagens_base / "empreendedores" / "guinle" / "Jorge_Guinle",
        "file_name": "01_Jorge_Guinle.jpg",
        "commons_file": "File:Jorge Guinle O Cruzeiro 3 nov 1945 pag 29.jpg",
        "title": "Jorge 'Jorginho' Guinle no Rio de Janeiro",
        "artist": "Revista O Cruzeiro / Jean Manzon",
        "role": "fotógrafo",
        "date_created": "1945",
        "museum": "Arquivo da Revista O Cruzeiro / Biblioteca Nacional do Brasil",
        "formatted_description": "Retrato da juventude de Jorginho Guinle, o lendário anfitrião do Copacabana Palace e historiador do jazz.",
        "license": "Public domain",
        "source": "O Cruzeiro / Wikimedia Commons"
    },

    # --- FAMÍLIA KLABIN-LAFER ---
    {
        "pessoa_ids": ["pub_klabin_mauricio_freeman_klabin"],
        "folder": imagens_base / "empreendedores" / "klabin" / "Mauricio_Klabin",
        "file_name": "01_Mauricio_Klabin.jpg",
        "commons_file": "File:Retrato de corpo inteiro de Bertha Osband ao lado de Maurício Freemann Klabin.jpg",
        "title": "Maurício Freeman Klabin, Fundador da Klabin",
        "artist": "Fotografia Histórica de Família",
        "role": "fotógrafo",
        "date_created": "c. 1910",
        "museum": "Memorial Klabin / Arquivo Histórico Judaico Brasileiro",
        "formatted_description": "Retrato histórico do imigrante e grande pioneiro industrial do papel Maurício Freeman Klabin.",
        "license": "Public domain",
        "source": "Memorial Klabin / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_klabin_horacio_lafer"],
        "folder": imagens_base / "empreendedores" / "klabin" / "Horacio_Lafer",
        "file_name": "01_Horacio_Lafer.jpg",
        "commons_file": "File:Horácio Lafer.jpg",
        "title": "Horácio Lafer, Ministro da Fazenda e das Relações Exteriores",
        "artist": "Agência Nacional / Arquivo Nacional do Brasil",
        "role": "fotógrafo oficial",
        "date_created": "c. 1951",
        "museum": "Arquivo Nacional, Rio de Janeiro",
        "formatted_description": "Retrato oficial de Horácio Lafer, líder industrial da Klabin e eminente ministro de Estado.",
        "license": "Public domain",
        "source": "Arquivo Nacional / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_klabin_celso_lafer"],
        "folder": imagens_base / "empreendedores" / "klabin" / "Celso_Lafer",
        "file_name": "01_Celso_Lafer.jpg",
        "commons_file": "File:Celso Lafer na Comissão Relações Exteriores do Senado.jpg",
        "title": "Celso Lafer, Jurista e Chanceler do Brasil",
        "artist": "Agência Senado / Moreira Mariz",
        "role": "fotógrafo oficial",
        "date_created": "2001",
        "museum": "Senado Federal / Academia Brasileira de Letras",
        "formatted_description": "Retrato de Celso Lafer, ministro das Relações Exteriores, acadêmico da ABL e professor emérito da USP.",
        "license": "CC BY 2.0",
        "source": "Agência Senado / Wikimedia Commons"
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


def executar_batch11():
    print("=" * 75)
    print(" EloTempo - Curadoria Batch 11: Empreendedores & Dinastias Globais (25 figuras)")
    print("=" * 75)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH11_OBRAS:
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

    print(f"\n[Batch 11 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch11()
