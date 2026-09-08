"""
EloTempo - Curadoria de Obras e Retratos Históricos: Batch 9 (Realeza Expandida & Dinastias Imperiais)
======================================================================================================
Baixa e cadastra com metadados estruturados completos:
- Habsburgo (7 figuras): Carlos I, Filipe o Belo, Francisco Ferdinando, Joana a Louca, Karl von Habsburg, Maria Teresa, Otto von Habsburg
- Windsor (7 figuras): Rainha Alexandra, Edward VII, George V, George VI, Príncipe George, Rainha Mary, Príncipe Philip
- Bourbon (6 figuras): Juan Carlos I, Juan de Borbón, Princesa Leonor, Rainha Letizia, Maria das Mercedes, Rainha Sofia
- Imperial Brasil (6 figuras): Antônio Gastão, Princesa Francisca, Condessa Januária, Princesa Leopoldina, Príncipe Luís, Príncipe Pedro de Alcântara
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
HEADERS = {"User-Agent": "EloTempo/4.0 (royal and imperial curation; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH9_OBRAS = [
    # --- HABSBURGO ---
    {
        "pessoa_ids": ["pub_habsburgo_carlos_i_da_austria"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Carlos_I_Austria",
        "file_name": "01_Carlos_I_Austria.png",
        "commons_file": "File:Emperor karl of austria-hungary 1917.png",
        "title": "Imperador Carlos I da Áustria e Rei Carlos IV da Hungria",
        "artist": "Fotografia Oficial Imperial Austro-Húngara",
        "role": "fotógrafo oficial",
        "date_created": "1917",
        "museum": "Österreichische Nationalbibliothek, Viena",
        "formatted_description": "Retrato oficial em uniforme de marechal de campo do Beato Carlos I, último monarca dos Habsburgos.",
        "license": "Public domain",
        "source": "Österreichische Nationalbibliothek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_filipe_o_belo"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Filipe_o_Belo",
        "file_name": "01_Filipe_o_Belo.jpg",
        "commons_file": "File:Flemish School (c. 1500) - Philip the Handsome (1478-1506) - RCIN 403438 - Royal Collection.jpg",
        "title": "Filipe I de Castela, o Belo",
        "artist": "Mestre da Lenda de Santa Madalena (Escola Flamenga)",
        "role": "pintor da corte de Borgonha",
        "date_created": "c. 1500",
        "museum": "Royal Collection, Castelo de Windsor",
        "formatted_description": "Pintura a óleo sobre painel representando Filipe I, Duque de Borgonha e Rei de Castela, portando o Colar da Ordem do Tosão de Ouro.",
        "license": "Public domain",
        "source": "Royal Collection Trust / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_francisco_ferdinando"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Francisco_Ferdinando",
        "file_name": "01_Francisco_Ferdinando.jpg",
        "commons_file": "File:Ferdinand Schmutzer - Franz Ferdinand von Österreich-Este, um 1914.jpg",
        "title": "Arquiduque Francisco Ferdinando da Áustria-Este",
        "artist": "Ferdinand Schmutzer",
        "role": "gravador e pintor",
        "date_created": "1914",
        "museum": "Heeresgeschichtliches Museum, Viena",
        "formatted_description": "Retrato oficial do herdeiro do trono austro-húngaro cujo assassinato em Sarajevo desencadeou a Primeira Guerra Mundial.",
        "license": "Public domain",
        "source": "Heeresgeschichtliches Museum / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_joana_de_castela"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Joana_a_Louca",
        "file_name": "01_Joana_a_Louca.jpg",
        "commons_file": "File:Marquard Wocher - Portrait of Joanna, Queen of Castile - NG.M.00084 - National Museum of Art, Architecture and Design (cropped).jpg",
        "title": "Rainha Joana I de Castela e Aragão (a Louca)",
        "artist": "Marquard Wocher (segundo Juan de Flandes)",
        "role": "pintor",
        "date_created": "c. 1500",
        "museum": "Museu Nacional de Arte, Arquitetura e Design, Oslo / Museu do Prado, Madri",
        "formatted_description": "Retrato a óleo de D. Joana, a Louca, Rainha de Castela e mãe do Imperador Carlos V.",
        "license": "Public domain",
        "source": "National Museum of Art Oslo / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_karl_von_habsburgo"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Karl_von_Habsburgo",
        "file_name": "01_Karl_von_Habsburgo.jpg",
        "commons_file": "File:Karl von Habsburg.MEP.jpg",
        "title": "Karl von Habsburg, Chefe da Casa de Habsburgo-Lorena",
        "artist": "Parlamento Europeu / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "1996",
        "museum": "Parlamento Europeu, Estrasburgo",
        "formatted_description": "Retrato oficial de Karl von Habsburg, Grão-Mestre da Ordem do Tosão de Ouro e deputado europeu.",
        "license": "Public domain",
        "source": "European Parliament / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_maria_teresa"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Maria_Teresa_Austria",
        "file_name": "01_Maria_Teresa_Austria.png",
        "commons_file": "File:Meytens - Empress Maria Theresa - Hofburg, Maria-Theresien-Zimmer.png",
        "title": "Imperatriz Maria Teresa da Áustria em Traje Imperial",
        "artist": "Martin van Meytens",
        "role": "pintor da corte imperial",
        "date_created": "c. 1750",
        "museum": "Palácio Imperial de Hofburg, Viena",
        "formatted_description": "Retrato monumental a óleo da soberana dos domínios dos Habsburgos, Rainha da Hungria e Boêmia.",
        "license": "Public domain",
        "source": "Hofburg Wien / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_habsburgo_otto_von_habsburgo"],
        "folder": imagens_base / "realeza-europeia" / "habsburgo" / "Otto_von_Habsburgo",
        "file_name": "01_Otto_von_Habsburgo.jpg",
        "commons_file": "File:Oliver Mark - Otto Habsburg-Lothringen, Pöcking 2006.jpg",
        "title": "Otto von Habsburg, Príncipe Herdeiro Austro-Húngaro",
        "artist": "Oliver Mark",
        "role": "fotógrafo de arte",
        "date_created": "2006",
        "museum": "Acervo Fundação Otto von Habsburg, Budapeste",
        "formatted_description": "Retrato magistral de Sua Alteza Imperial Otto von Habsburg, presidente da União Pan-Europeia Internacional.",
        "license": "CC BY-SA 4.0",
        "source": "Oliver Mark / Wikimedia Commons"
    },

    # --- WINDSOR ---
    {
        "pessoa_ids": ["pub_alexandra_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rainha_Alexandra",
        "file_name": "01_Rainha_Alexandra.jpg",
        "commons_file": "File:Queen Alexandra, the Princess of Wales.jpg",
        "title": "Rainha Alexandra do Reino Unido (Princesa da Dinamarca)",
        "artist": "W. & D. Downey",
        "role": "fotógrafos da corte real",
        "date_created": "c. 1901",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato da Rainha Alexandra com diadema real de diamantes e gargantilha de pérolas.",
        "license": "Public domain",
        "source": "National Portrait Gallery / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_edward7_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rei_Edward_VII",
        "file_name": "01_Rei_Edward_VII.jpg",
        "commons_file": "File:King Edward VII - Fildes 1902.jpg",
        "title": "Rei Edward VII do Reino Unido e Imperador da Índia",
        "artist": "Sir Samuel Luke Fildes",
        "role": "pintor oficial da corte",
        "date_created": "1902",
        "museum": "Royal Collection, Castelo de Windsor",
        "formatted_description": "Retrato solene de coroação de Sua Majestade o Rei Edward VII em vestes régias da Ordem da Jarreteira.",
        "license": "Public domain",
        "source": "Royal Collection Trust / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_george5_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rei_George_V",
        "file_name": "01_Rei_George_V.jpg",
        "commons_file": "File:Portrait of H.M. King George V (1911).jpg",
        "title": "Rei George V do Reino Unido em Manto de Coroação",
        "artist": "Sir Samuel Luke Fildes",
        "role": "pintor da corte",
        "date_created": "1911",
        "museum": "Royal Collection / National Portrait Gallery, Londres",
        "formatted_description": "Retrato oficial de coroação do fundador da Casa de Windsor com a Coroa Imperial de Estado e o Cetro com a Cruz.",
        "license": "Public domain",
        "source": "Royal Collection Trust / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_george6_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rei_George_VI",
        "file_name": "01_Rei_George_VI.jpg",
        "commons_file": "File:George VI, King-Emperor.jpg",
        "title": "Rei George VI do Reino Unido, Rei e Imperador",
        "artist": "Bertram Park",
        "role": "fotógrafo oficial da corte",
        "date_created": "1937",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato oficial de investidura de George VI com a Coroa Imperial de Estado e manto real.",
        "license": "Public domain",
        "source": "National Portrait Gallery / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_george_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Principe_George",
        "file_name": "01_Principe_George.jpg",
        "commons_file": "File:Prince George of Wales (cropped).jpg",
        "title": "Príncipe George de Gales",
        "artist": "Palácio de Kensington / Foto Oficial Real",
        "role": "fotógrafo oficial",
        "date_created": "2023",
        "museum": "Kensington Palace / Royal Collection",
        "formatted_description": "Retrato oficial de Sua Alteza Real o Príncipe George de Gales por ocasião das celebrações da Coroação.",
        "license": "CC BY 2.0",
        "source": "Kensington Palace / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_mary_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Rainha_Mary",
        "file_name": "01_Rainha_Mary.jpg",
        "commons_file": "File:Queen Mary of the United Kingdom, c. 1911.jpg",
        "title": "Rainha Mary de Teck, Rainha Consorte do Reino Unido",
        "artist": "W. & D. Downey",
        "role": "fotógrafos da corte real",
        "date_created": "1911",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato de coroação da Rainha Mary com as joias da Coroa britânica.",
        "license": "Public domain",
        "source": "National Portrait Gallery / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_philip_uk"],
        "folder": imagens_base / "realeza-europeia" / "windsor" / "Principe_Philip",
        "file_name": "01_Principe_Philip.jpg",
        "commons_file": "File:Duke of Edinburgh 33 Allan Warren.jpg",
        "title": "Príncipe Philip, Duque de Edimburgo em Uniforme de Gala",
        "artist": "Allan Warren",
        "role": "fotógrafo de retratos da corte",
        "date_created": "1992",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato de Sua Alteza Real o Príncipe Philip, Duque de Edimburgo, com as insígnias da Jarreteira e condecorações navais.",
        "license": "CC BY-SA 3.0",
        "source": "Allan Warren / Wikimedia Commons"
    },

    # --- BOURBON ---
    {
        "pessoa_ids": ["pub_bourbon_juan_carlos_i"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Juan_Carlos_I",
        "file_name": "01_Juan_Carlos_I.jpg",
        "commons_file": "File:Juan Carlos I of Spain 2007.jpg",
        "title": "Rei Juan Carlos I da Espanha",
        "artist": "Casa Real de España / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "2007",
        "museum": "Palacio de la Zarzuela, Madri",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei D. Juan Carlos I de Espanha.",
        "license": "CC BY-SA 3.0",
        "source": "Casa de S.M. el Rey / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bourbon_juan_de_borbon"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Juan_de_Borbon",
        "file_name": "01_Juan_de_Borbon.jpg",
        "commons_file": "File:Confirmación Junta Nobles Linajes Don Juan de Borbón, conde de Barcelona (cropped).jpg",
        "title": "Juan de Borbón, Conde de Barcelona",
        "artist": "Junta de Nobles Linajes / Arquivo Histórico",
        "role": "fotógrafo oficial",
        "date_created": "c. 1970",
        "museum": "Palacio Real de Madrid",
        "formatted_description": "Retrato de D. Juan de Borbón e Battenberg, Conde de Barcelona, chefe da Casa Real espanhola.",
        "license": "CC BY-SA 4.0",
        "source": "Archivo Histórico / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bourbon_leonor_princesa_das_asturias"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Princesa_Leonor",
        "file_name": "01_Princesa_Leonor.jpg",
        "commons_file": "File:Leonor de Borbón en 2023 (cropped).jpg",
        "title": "Leonor de Borbón, Princesa das Astúrias",
        "artist": "Casa Real de España / Foto Oficial no Congresso dos Deputados",
        "role": "fotógrafo oficial",
        "date_created": "2023",
        "museum": "Palacio de la Zarzuela, Madri",
        "formatted_description": "Retrato de Sua Alteza Real a Princesa Leonor por ocasião de seu juramento à Constituição espanhola de 1978.",
        "license": "CC BY 4.0",
        "source": "Congreso de los Diputados / Casa Real / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bourbon_letizia"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Rainha_Letizia",
        "file_name": "01_Rainha_Letizia.jpg",
        "commons_file": "File:Queen Letizia - 2019 (cropped).jpg",
        "title": "Rainha Letizia da Espanha",
        "artist": "Casa Real de España / Estela de Castro",
        "role": "fotógrafa oficial",
        "date_created": "2019",
        "museum": "Palacio Real de Madrid",
        "formatted_description": "Retrato oficial de gala de Sua Majestade a Rainha Letizia da Espanha com a Tiara Flor de Lis.",
        "license": "CC BY 4.0",
        "source": "Casa de S.M. el Rey / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bourbon_maria_das_mercedes"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Maria_das_Mercedes",
        "file_name": "01_Maria_das_Mercedes.jpg",
        "commons_file": "File:Infanta María de las Mercedes, Countess of Barcelona.jpg",
        "title": "Maria das Mercedes de Bourbon-Duas Sicílias, Condessa de Barcelona",
        "artist": "Fotografia Oficial da Casa Real Espanhola",
        "role": "fotógrafo",
        "date_created": "c. 1950",
        "museum": "Palacio Real de Madrid",
        "formatted_description": "Retrato de D. Maria das Mercedes, condessa consorte de Barcelona e mãe do Rei Juan Carlos I.",
        "license": "Public domain",
        "source": "Patrimonio Nacional / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_bourbon_rainha_sofia"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Rainha_Sofia",
        "file_name": "01_Rainha_Sofia.jpg",
        "commons_file": "File:Queen Sophia of Spain 2008.jpg",
        "title": "Rainha Sofia da Espanha (Princesa da Grécia e Dinamarca)",
        "artist": "Governo da Espanha / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "2008",
        "museum": "Palacio de la Zarzuela, Madri",
        "formatted_description": "Retrato oficial de Sua Majestade a Rainha Dona Sofia da Espanha.",
        "license": "CC BY-SA 3.0",
        "source": "Casa Real de España / Wikimedia Commons"
    },

    # --- IMPERIAL BRASIL ---
    {
        "pessoa_ids": ["pub_antonio_orleans"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Antonio_Gastao",
        "file_name": "01_Antonio_Gastao.jpg",
        "commons_file": "File:Prince Antoine d'orleans et Braganza, Mc Art.IWMART4654.jpg",
        "title": "Príncipe Antônio Gastão de Orléans e Bragança em Uniforme de Aviador",
        "artist": "Imperial War Museums / Fotógrafo e Artista Militar",
        "role": "artista militar",
        "date_created": "1918",
        "museum": "Imperial War Museums, Londres",
        "formatted_description": "Retrato a óleo de D. Antônio Gastão de Orléans e Bragança, neto de D. Pedro II, tenente aviador da Força Aérea Britânica (RFC).",
        "license": "Public domain",
        "source": "Imperial War Museum ART4654 / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_francisca"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Princesa_Francisca",
        "file_name": "01_Princesa_Francisca.jpg",
        "commons_file": "File:1844 portrait of Princess Francisca of Brazil (later Princess of Joinville) by Franz Xaver Winterhalter (Versailles).jpg",
        "title": "D. Francisca de Bragança, Princesa de Joinville",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor da corte de Luís Filipe I",
        "date_created": "1844",
        "museum": "Château de Versailles, França",
        "formatted_description": "Magnífica obra a óleo de Franz Xaver Winterhalter retratando a Princesa Francisca do Brasil, filha de D. Pedro I e Imperatriz Leopoldina.",
        "license": "Public domain",
        "source": "Musée National des Châteaux de Versailles et de Trianon"
    },
    {
        "pessoa_ids": ["pub_januaria"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Januaria_de_Braganca",
        "file_name": "01_Januaria_de_Braganca.jpg",
        "commons_file": "File:Januaria of Brazil 1865.jpg",
        "title": "D. Januária de Bragança, Princesa Imperial do Brasil e Condessa de Áquila",
        "artist": "Fotógrafo da Corte Napolitana e Imperial",
        "role": "fotógrafo oficial",
        "date_created": "1865",
        "museum": "Museu Imperial, Petrópolis / Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato fotográfico oitocentista de D. Januária, Princesa Imperial do Brasil.",
        "license": "Public domain",
        "source": "Museu Imperial de Petrópolis / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_leopoldina_filha"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Princesa_Leopoldina",
        "file_name": "01_Princesa_Leopoldina.jpg",
        "commons_file": "File:Princesa Leopoldina de Bragança, filha de Pedro II do Brasil (AI-enhanced).jpg",
        "title": "Princesa Leopoldina de Bragança, Duquesa de Saxe",
        "artist": "Joaquim Insley Pacheco / Acervo da Casa Imperial",
        "role": "fotógrafo da corte imperial brasileira",
        "date_created": "c. 1864",
        "museum": "Museu Imperial, Petrópolis",
        "formatted_description": "Retrato de D. Leopoldina de Bragança, filha de D. Pedro II e D. Teresa Cristina, duquesa de Saxe-Coburgo-Gota.",
        "license": "Public domain",
        "source": "Museu Imperial / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_luis_orleans"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Luis_de_Orleans",
        "file_name": "01_Luis_de_Orleans.jpg",
        "commons_file": "File:Luís de Orleãs e Bragança (2).jpg",
        "title": "D. Luís de Orléans e Bragança, o Príncipe Perfeito",
        "artist": "Atelier Nadar / Acervo Imperial",
        "role": "fotógrafo da corte",
        "date_created": "c. 1908",
        "museum": "Museu Imperial, Petrópolis / Bibliothèque Nationale de France",
        "formatted_description": "Retrato de D. Luís de Orléans e Bragança, herdeiro presuntivo da Princesa Isabel, herói condecorado da Primeira Guerra Mundial.",
        "license": "Public domain",
        "source": "Museu Imperial / BnF"
    },
    {
        "pessoa_ids": ["pub_pedro_alcantara"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Pedro_de_Alcantara",
        "file_name": "01_Pedro_de_Alcantara.jpg",
        "commons_file": "File:Pedro de Alcântara, Prince of Grão-Pará.jpg",
        "title": "D. Pedro de Alcântara de Orléans e Bragança, Príncipe do Grão-Pará",
        "artist": "Acervo Fotográfico da Casa Imperial Brasileira",
        "role": "fotógrafo",
        "date_created": "c. 1900",
        "museum": "Museu Imperial, Petrópolis",
        "formatted_description": "Retrato oficial de D. Pedro de Alcântara, filho primogênito da Princesa Isabel e do Conde d'Eu.",
        "license": "Public domain",
        "source": "Museu Imperial / Wikimedia Commons"
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


def executar_batch9():
    print("=" * 75)
    print(" EloTempo - Curadoria Batch 9: Realeza Expandida (26 figuras)")
    print("=" * 75)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH9_OBRAS:
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

    print(f"\n[Batch 9 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch9()
