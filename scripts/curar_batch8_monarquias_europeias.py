"""
EloTempo - Curadoria de Representações Históricas: Batch 8 (Monarquias Tradicionais Europeias)
=============================================================================================
Baixa e cadastra com metadados completos de obras e retratos oficiais:
- Bélgica: Albert II, Leopoldo III, Philippe, Paola, Astrid
- Mônaco: Grace Kelly, Rainier III, Alberto II
- Países Baixos: Willem-Alexander, Beatrix, Juliana, Claus, Bernhard
- Dinamarca: Cristiano IX, Luísa de Hesse, Cristiano X, Alexandrine, Frederico VIII, Frederico IX, Ingrid, Margrethe II, Henrik, Frederik X
- Noruega: Haakon VII, Maud de Gales, Olav V, Harald V, Märtha da Suécia
- Suécia: Carl XVI Gustaf, Gustavo Adolfo, Sibila, Carl, Ingeborg
- Luxemburgo: Jean, Joséphine-Charlotte, Henri
- Liechtenstein: Franz Josef II, Gina von Wilczek, Hans-Adam II
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
HEADERS = {"User-Agent": "EloTempo/4.0 (royal portrait curation; historical metadata; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH8_OBRAS = [
    # --- MÔNACO ---
    {
        "pessoa_ids": ["pub_monarquias_grace_kelly"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Grace_Kelly",
        "file_name": "01_Grace_Kelly.jpg",
        "commons_file": "File:Grace Kelly MGM photo.jpg",
        "title": "Grace Kelly, Princesa de Mônaco",
        "artist": "Metro-Goldwyn-Mayer / Howell Conant",
        "role": "fotógrafo oficial",
        "date_created": "1956",
        "museum": "Palais Princier de Monaco / Arquivos Oficiais de Mônaco",
        "formatted_description": "Retrato oficial da atriz e princesa consorte Grace de Mônaco.",
        "license": "Public domain",
        "source": "MGM / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_rainier_iii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainier_III",
        "file_name": "01_Rainier_III.jpg",
        "commons_file": "File:Wedding of Rainier III, Prince of Monaco, and Grace Kelly (2).jpg",
        "title": "Rainier III, Príncipe Soberano de Mônaco",
        "artist": "Fotografia Oficial do Palácio de Mônaco",
        "role": "fotógrafo oficial",
        "date_created": "1956",
        "museum": "Palais Princier de Monaco",
        "formatted_description": "Retrato de Sua Alteza Sereníssima o Príncipe Rainier III de Mônaco.",
        "license": "Public domain",
        "source": "Archives du Palais Princier / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_outras_monarquias_alberto_ii_de_monaco"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Alberto_II_Monaco",
        "file_name": "01_Alberto_II_Monaco.jpg",
        "commons_file": "File:Prince Albert II 2016.jpg",
        "title": "Alberto II, Príncipe Soberano de Mônaco",
        "artist": "Palais Princier de Monaco / Michael Alesi",
        "role": "fotógrafo oficial",
        "date_created": "2016",
        "museum": "Palais Princier de Monaco",
        "formatted_description": "Retrato oficial de Sua Alteza Sereníssima Alberto II de Mônaco.",
        "license": "CC BY-SA 4.0",
        "source": "Palais Princier de Monaco / Wikimedia Commons"
    },

    # --- PAÍSES BAIXOS ---
    {
        "pessoa_ids": ["pub_outras_monarquias_willem_alexander_dos_paises_baixos"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Willem-Alexander",
        "file_name": "01_Willem-Alexander.jpg",
        "commons_file": "File:Zijne Majesteit Koning Willem-Alexander met koningsmantel april 2013 (cropped).jpg",
        "title": "Rei Willem-Alexander dos Países Baixos com Manto Real",
        "artist": "Koos Breukel / Rijksvoorlichtingsdienst (RVD)",
        "role": "fotógrafo oficial da corte",
        "date_created": "2013",
        "museum": "Koninklijk Huis / Rijksmuseum, Amsterdã",
        "formatted_description": "Retrato oficial de investidura do Rei Willem-Alexander com o manto de arminho real.",
        "license": "CC BY 3.0 nl",
        "source": "Rijksvoorlichtingsdienst (RVD) / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_beatrix_holanda"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Princesa_Beatrix",
        "file_name": "01_Princesa_Beatrix.jpg",
        "commons_file": "File:Koningin Beatrix in Vries.jpg",
        "title": "Rainha Beatrix dos Países Baixos",
        "artist": "Nationaal Archief / Fotocollectie Anefo",
        "role": "fotógrafo oficial",
        "date_created": "1983",
        "museum": "Nationaal Archief, Haia",
        "formatted_description": "Retrato de Sua Majestade a Rainha Beatrix dos Países Baixos.",
        "license": "CC0 / Public domain",
        "source": "Nationaal Archief / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_juliana_holanda"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainha_Juliana",
        "file_name": "01_Rainha_Juliana.jpg",
        "commons_file": "File:Koningin Juliana (1949).jpg",
        "title": "Rainha Juliana dos Países Baixos",
        "artist": "Max Koot / Rijksvoorlichtingsdienst",
        "role": "fotógrafo da corte real",
        "date_created": "1949",
        "museum": "Nationaal Archief, Haia",
        "formatted_description": "Retrato oficial de investidura da Rainha Juliana dos Países Baixos.",
        "license": "Public domain",
        "source": "Nationaal Archief / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_claus"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Principe_Claus",
        "file_name": "01_Principe_Claus.jpg",
        "commons_file": "File:Prins Claus in 1966.jpg",
        "title": "Príncipe Claus dos Países Baixos",
        "artist": "Nationaal Archief / Jac. de Nijs",
        "role": "fotógrafo",
        "date_created": "1966",
        "museum": "Nationaal Archief, Haia",
        "formatted_description": "Retrato oficial do Príncipe Claus de Lippe-Biesterfeld, consorte da Rainha Beatrix.",
        "license": "CC0 / Public domain",
        "source": "Nationaal Archief / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_bernhard"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Principe_Bernhard",
        "file_name": "01_Principe_Bernhard.jpg",
        "commons_file": "File:Prince Bernhard of the Netherlands in 1942.jpg",
        "title": "Príncipe Bernhard de Lippe-Biesterfeld",
        "artist": "Fotografia Oficial das Forças Armadas Holandesas",
        "role": "fotógrafo",
        "date_created": "1942",
        "museum": "Nationaal Archief, Haia",
        "formatted_description": "Retrato em uniforme militar do Príncipe Bernhard dos Países Baixos.",
        "license": "Public domain",
        "source": "Nationaal Archief / Wikimedia Commons"
    },

    # --- BÉLGICA ---
    {
        "pessoa_ids": ["pub_outras_monarquias_philippe_da_belgica"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Philippe_Belgica",
        "file_name": "01_Philippe_Belgica.jpg",
        "commons_file": "File:King Philippe of Belgium (Belgian National Day, 2018).jpg",
        "title": "Rei Philippe da Bélgica em Uniforme de Gala",
        "artist": "Palácio Real de Bruxelas / Christian Lambiotte",
        "role": "fotógrafo oficial",
        "date_created": "2018",
        "museum": "Palais Royal de Bruxelles",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Philippe dos Belgas no Dia Nacional da Bélgica.",
        "license": "CC BY-SA 4.0",
        "source": "Chancellery of the Prime Minister of Belgium / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_albert_ii_belgica"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Albert_II_Belgica",
        "file_name": "01_Albert_II_Belgica.jpg",
        "commons_file": "File:Albert II, King of Belgium.jpg",
        "title": "Rei Albert II da Bélgica",
        "artist": "Palácio Real de Bruxelas",
        "role": "fotógrafo oficial",
        "date_created": "2001",
        "museum": "Palais Royal de Bruxelles",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Albert II da Bélgica.",
        "license": "CC BY 2.0",
        "source": "Belgian Royal Court / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_leopoldo_iii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Leopoldo_III_Belgica",
        "file_name": "01_Leopoldo_III_Belgica.jpg",
        "commons_file": "File:Leopold III (1934).jpg",
        "title": "Rei Leopoldo III da Bélgica",
        "artist": "Atelier d'Art Photographique de la Cour",
        "role": "fotógrafo da corte",
        "date_created": "1934",
        "museum": "Archives Générales du Royaume, Bruxelas",
        "formatted_description": "Retrato oficial de aclamação do Rei Leopoldo III da Bélgica.",
        "license": "Public domain",
        "source": "Archives Générales du Royaume / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_paola"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainha_Paola_Belgica",
        "file_name": "01_Rainha_Paola_Belgica.jpg",
        "commons_file": "File:Queen Paola of Belgium.jpg",
        "title": "Rainha Paola da Bélgica",
        "artist": "Corte Real Belga",
        "role": "fotógrafo da corte",
        "date_created": "2008",
        "museum": "Palais Royal de Bruxelles",
        "formatted_description": "Retrato de Sua Majestade a Rainha Paola dos Belgas.",
        "license": "CC BY-SA 3.0",
        "source": "Belgian Royal Collection / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_astrid_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainha_Astrid_Belgica",
        "file_name": "01_Rainha_Astrid_Belgica.jpg",
        "commons_file": "File:Crown princess Astrid 1926.jpg",
        "title": "Rainha Astrid da Bélgica (Princesa da Suécia)",
        "artist": "Fotografia da Corte Sueca e Belga",
        "role": "fotógrafo oficial",
        "date_created": "1926",
        "museum": "Kungliga biblioteket, Estocolmo",
        "formatted_description": "Retrato da Princesa Astrid da Suécia, Rainha Consorte dos Belgas.",
        "license": "Public domain",
        "source": "Kungliga biblioteket / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_josephine_charlotte"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Josephine_Charlotte",
        "file_name": "01_Josephine_Charlotte.jpg",
        "commons_file": "File:Visit by Joséphine Charlotte, Grand Duchess of Luxembourg, to the CEC (cropped).jpg",
        "title": "Grã-Duquesa Joséphine-Charlotte de Luxemburgo",
        "artist": "Comissão Europeia / Fotografia Oficial",
        "role": "fotógrafo",
        "date_created": "1989",
        "museum": "Arquivos da União Europeia / Palais Grand-Ducal",
        "formatted_description": "Retrato de Joséphine-Charlotte da Bélgica, Grã-Duquesa consorte de Luxemburgo.",
        "license": "CC BY 4.0",
        "source": "European Commission Audiovisual Service / Wikimedia Commons"
    },

    # --- DINAMARCA ---
    {
        "pessoa_ids": ["pub_monarquias_cristiano_ix"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Cristiano_IX",
        "file_name": "01_Cristiano_IX.jpg",
        "commons_file": "File:Christian IX of Denmark (1818-1906).jpg",
        "title": "Rei Cristiano IX da Dinamarca, O Sogro da Europa",
        "artist": "August Schiøtt / Georg Emil Hansen",
        "role": "pintor / fotógrafo da corte dinamarquesa",
        "date_created": "c. 1870",
        "museum": "Museu de História Nacional no Castelo de Frederiksborg, Hillerød",
        "formatted_description": "Retrato de Cristiano IX da Dinamarca, cujos filhos se tornaram reis e imperatrizes da Europa.",
        "license": "Public domain",
        "source": "Det Nationalhistoriske Museum på Frederiksborg Slot"
    },
    {
        "pessoa_ids": ["pub_monarquias_luisa_de_hesse"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Luisa_de_Hesse",
        "file_name": "01_Luisa_de_Hesse.jpg",
        "commons_file": "File:Queen Lujza of Denmark.jpg",
        "title": "Rainha Luísa de Hesse-Kassel, Rainha da Dinamarca",
        "artist": "Elisabeth Jerichau-Baumann",
        "role": "pintora da corte",
        "date_created": "c. 1865",
        "museum": "Castelo de Amalienborg, Copenhague",
        "formatted_description": "Retrato a óleo de Luísa de Hesse-Kassel, Rainha da Dinamarca e matriarca das famílias reais europeias.",
        "license": "Public domain",
        "source": "Kongernes Samling Amalienborg"
    },
    {
        "pessoa_ids": ["pub_monarquias_cristiano_x"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Cristiano_X",
        "file_name": "01_Cristiano_X.jpg",
        "commons_file": "File:Christian X of Denmark circa 1915.jpg",
        "title": "Rei Cristiano X da Dinamarca",
        "artist": "Fotografia da Corte Real Dinamarquesa",
        "role": "fotógrafo oficial",
        "date_created": "1915",
        "museum": "Det Kongelige Bibliotek, Copenhague",
        "formatted_description": "Retrato oficial do Rei Cristiano X em uniforme militar durante a Primeira Guerra Mundial.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_alexandrine"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Alexandrine_Mecklemburgo",
        "file_name": "01_Alexandrine_Mecklemburgo.jpg",
        "commons_file": "File:Queen Alexandrine of Denmark.jpg",
        "title": "Rainha Alexandrine de Mecklemburgo-Schwerin",
        "artist": "Peter Elfelt",
        "role": "fotógrafo real",
        "date_created": "c. 1912",
        "museum": "Det Kongelige Bibliotek, Copenhague",
        "formatted_description": "Retrato oficial da Rainha Alexandrine da Dinamarca com diadema de safiras.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_frederico_viii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Frederico_VIII",
        "file_name": "01_Frederico_VIII.jpg",
        "commons_file": "File:Frederik VIII of Denmark 1909.jpg",
        "title": "Rei Frederico VIII da Dinamarca",
        "artist": "Peter Elfelt",
        "role": "fotógrafo da corte",
        "date_created": "1909",
        "museum": "Det Kongelige Bibliotek, Copenhague",
        "formatted_description": "Retrato de gala do Rei Frederico VIII da Dinamarca.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_luisa_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Luisa_da_Suecia",
        "file_name": "01_Luisa_da_Suecia.jpg",
        "commons_file": "File:Queen Lovisa of Denmark.jpg",
        "title": "Rainha Luísa da Suécia (Rainha da Dinamarca)",
        "artist": "Fotografia da Corte Real",
        "role": "fotógrafo",
        "date_created": "c. 1906",
        "museum": "Det Kongelige Bibliotek, Copenhague",
        "formatted_description": "Retrato de Luísa da Suécia, consorte de Frederico VIII da Dinamarca.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_frederico_ix"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Frederico_IX",
        "file_name": "01_Frederico_IX.jpg",
        "commons_file": "File:Frederik IX (cropped) - Det Kongelige Bibliotek (KE062449).jpg",
        "title": "Rei Frederico IX da Dinamarca em Uniforme da Marinha",
        "artist": "Det Kongelige Bibliotek / Fotógrafo da Corte",
        "role": "fotógrafo",
        "date_created": "1954",
        "museum": "Det Kongelige Bibliotek, Copenhague",
        "formatted_description": "Retrato oficial do marinheiro e Rei Frederico IX da Dinamarca.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_ingrid_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainha_Ingrid",
        "file_name": "01_Rainha_Ingrid.jpg",
        "commons_file": "File:Ingrid of Sweden and Denmark 1954.jpg",
        "title": "Rainha Ingrid da Suécia, Rainha da Dinamarca",
        "artist": "Fotografia da Casa Real Dinamarquesa",
        "role": "fotógrafo",
        "date_created": "1954",
        "museum": "Castelo de Amalienborg, Copenhague",
        "formatted_description": "Retrato oficial da Rainha Ingrid, mãe da Rainha Margrethe II.",
        "license": "Public domain",
        "source": "Amalienborg Palace / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_margrethe_ii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Margrethe_II",
        "file_name": "01_Margrethe_II.jpg",
        "commons_file": "File:Drottning Margrethe av Danmark.jpg",
        "title": "Rainha Margrethe II da Dinamarca",
        "artist": "Governo Sueco / Foto Oficial Nórdica",
        "role": "fotógrafo oficial",
        "date_created": "2012",
        "museum": "Casa Real Dinamarquesa",
        "formatted_description": "Retrato oficial de Sua Majestade a Rainha Margrethe II da Dinamarca.",
        "license": "CC BY 2.0",
        "source": "Regeringskansliet / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_henrik"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Principe_Henrik",
        "file_name": "01_Principe_Henrik.jpg",
        "commons_file": "File:Henrik-Prince-Consort-of-Denmark-writing-on-something-142364994592.jpg",
        "title": "Príncipe Henrik da Dinamarca, Príncipe Consorte",
        "artist": "Arquivos de Imprensa da Escandinávia",
        "role": "fotógrafo",
        "date_created": "1970",
        "museum": "Det Kongelige Bibliotek",
        "formatted_description": "Retrato do Príncipe Consorte Henrik da Dinamarca (Conde Henri de Laborde de Monpezat).",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_outras_monarquias_frederik_x_da_dinamarca"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Frederik_X",
        "file_name": "01_Frederik_X.jpg",
        "commons_file": "File:State visit by King Frederik X of Denmark in 2024 03.jpg",
        "title": "Rei Frederik X da Dinamarca",
        "artist": "Governo Sueco / Visita de Estado",
        "role": "fotógrafo oficial",
        "date_created": "2024",
        "museum": "Casa Real da Dinamarca / Det Danske Kongehus",
        "formatted_description": "Retrato de Sua Majestade o Rei Frederik X da Dinamarca na sua ascensão ao trono em 2024.",
        "license": "CC BY-SA 4.0",
        "source": "Swedish Government / Kongehuset / Wikimedia Commons"
    },

    # --- NORUEGA ---
    {
        "pessoa_ids": ["pub_monarquias_haakon_vii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Haakon_VII",
        "file_name": "01_Haakon_VII.jpg",
        "commons_file": "File:Haakon VII FSA.jpg",
        "title": "Rei Haakon VII da Noruega",
        "artist": "Ernest Rude",
        "role": "fotógrafo da corte norueguesa",
        "date_created": "1906",
        "museum": "Nasjonalbiblioteket, Oslo",
        "formatted_description": "Retrato de aclamação do primeiro monarca da Noruega moderna independente.",
        "license": "Public domain",
        "source": "Nasjonalbiblioteket / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_maud_do_reino_unido"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Rainha_Maud",
        "file_name": "01_Rainha_Maud.jpg",
        "commons_file": "File:Maud of Wales, Queen of Norway.jpg",
        "title": "Rainha Maud de Gales, Rainha da Noruega",
        "artist": "Alexander Bassano",
        "role": "fotógrafo da corte",
        "date_created": "c. 1906",
        "museum": "National Portrait Gallery, Londres / Nasjonalbiblioteket, Oslo",
        "formatted_description": "Retrato da Rainha Maud da Noruega, filha do Rei Edward VII do Reino Unido.",
        "license": "Public domain",
        "source": "National Portrait Gallery / Nasjonalbiblioteket"
    },
    {
        "pessoa_ids": ["pub_monarquias_olav_v"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Olav_V",
        "file_name": "01_Olav_V.jpg",
        "commons_file": "File:Olav V of Norway.jpg",
        "title": "Rei Olav V da Noruega",
        "artist": "Fotografia Oficial da Corte Real Norueguesa",
        "role": "fotógrafo",
        "date_created": "1970",
        "museum": "Det Kongelige Slott, Oslo",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Olav V da Noruega.",
        "license": "CC BY-SA 4.0",
        "source": "Det Kongelige Hoff / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_outras_monarquias_harald_v_da_noruega"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Harald_V",
        "file_name": "01_Harald_V.jpg",
        "commons_file": "File:King Harald V of Norway (29741494632) (cropped).jpg",
        "title": "Rei Harald V da Noruega",
        "artist": "Sølve Sundsbø / Det Kongelige Hoff",
        "role": "fotógrafo oficial da corte",
        "date_created": "2016",
        "museum": "Det Kongelige Slott, Oslo",
        "formatted_description": "Retrato oficial com as condecorações da Ordem Real de Santo Olavo de Harald V.",
        "license": "CC BY-SA 4.0",
        "source": "Det Kongelige Hoff / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_martha_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Princesa_Martha_Suecia",
        "file_name": "01_Princesa_Martha_Suecia.jpg",
        "commons_file": "File:Märtha of Norway 1929.jpg",
        "title": "Princesa Märtha da Suécia (Princesa Herdeira da Noruega)",
        "artist": "Fotografia Oficial do Casamento Real",
        "role": "fotógrafo",
        "date_created": "1929",
        "museum": "Nasjonalbiblioteket, Oslo",
        "formatted_description": "Retrato da Princesa Märtha da Suécia, mãe do Rei Harald V da Noruega.",
        "license": "Public domain",
        "source": "Nasjonalbiblioteket / Wikimedia Commons"
    },

    # --- SUÉCIA ---
    {
        "pessoa_ids": ["pub_outras_monarquias_carl_xvi_gustaf_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Carl_XVI_Gustaf",
        "file_name": "01_Carl_XVI_Gustaf.jpg",
        "commons_file": "File:Carl XVI Gustaf of Sweden 2018 (42282165922) (cropped).jpg",
        "title": "Rei Carl XVI Gustaf da Suécia",
        "artist": "Kungahuset / Fotógrafo Oficial da Casa Real Sueca",
        "role": "fotógrafo oficial",
        "date_created": "2018",
        "museum": "Kungliga Slottet, Estocolmo",
        "formatted_description": "Retrato oficial de Sua Majestade o Rei Carl XVI Gustaf da Suécia.",
        "license": "CC BY 2.0",
        "source": "Kungahuset / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_gustavo_adolfo_duque"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Gustavo_Adolfo_Vasterbotten",
        "file_name": "01_Gustavo_Adolfo_Vasterbotten.jpg",
        "commons_file": "File:Prince Gustaf Adolf, Duke of Västerbotten.jpg",
        "title": "Príncipe Gustavo Adolfo, Duque de Västerbotten",
        "artist": "Fotógrafo da Corte Sueca",
        "role": "fotógrafo",
        "date_created": "1932",
        "museum": "Kungliga biblioteket, Estocolmo",
        "formatted_description": "Retrato do Príncipe Gustavo Adolfo da Suécia, pai do Rei Carl XVI Gustaf.",
        "license": "Public domain",
        "source": "Kungliga biblioteket / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_sibila_de_saxe"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Sibila_de_Saxe",
        "file_name": "01_Sibila_de_Saxe.jpg",
        "commons_file": "File:Princess Sibylla of Saxe-Coburg and Gotha.jpg",
        "title": "Princesa Sibila de Saxe-Coburgo-Gota",
        "artist": "Fotografia da Corte Real Sueca",
        "role": "fotógrafo",
        "date_created": "1932",
        "museum": "Kungliga biblioteket, Estocolmo",
        "formatted_description": "Retrato da Princesa Sibila, Duquesa de Västerbotten e mãe de Carl XVI Gustaf.",
        "license": "Public domain",
        "source": "Kungliga biblioteket / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_carol_da_suecia"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Principe_Carl_Suecia",
        "file_name": "01_Principe_Carl_Suecia.jpg",
        "commons_file": "File:Prince Carl, Duke of Västergötland (1861-1951).jpg",
        "title": "Príncipe Carl da Suécia, Duque de Västergötland",
        "artist": "Fotógrafo da Corte Real Sueca",
        "role": "fotógrafo",
        "date_created": "c. 1910",
        "museum": "Kungliga biblioteket, Estocolmo",
        "formatted_description": "Retrato do Príncipe Carl da Suécia, presidente da Cruz Vermelha Sueca.",
        "license": "Public domain",
        "source": "Kungliga biblioteket / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_ingeborg"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Princesa_Ingeborg",
        "file_name": "01_Princesa_Ingeborg.jpg",
        "commons_file": "File:Princess Ingeborg of Denmark.jpg",
        "title": "Princesa Ingeborg da Dinamarca (Duquesa de Västergötland)",
        "artist": "Fotografia da Casa Real",
        "role": "fotógrafo",
        "date_created": "c. 1897",
        "museum": "Det Kongelige Bibliotek / Kungliga biblioteket",
        "formatted_description": "Retrato de Ingeborg da Dinamarca, avó dos reis da Noruega e Bélgica.",
        "license": "Public domain",
        "source": "Det Kongelige Bibliotek / Wikimedia Commons"
    },

    # --- LUXEMBURGO ---
    {
        "pessoa_ids": ["pub_monarquias_jean_luxemburgo"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Grao_Duque_Jean",
        "file_name": "01_Grao_Duque_Jean.jpg",
        "commons_file": "File:Jean, Grand Duke of Luxembourg.jpg",
        "title": "Grão-Duque Jean de Luxemburgo",
        "artist": "Cour Grand-Ducale de Luxembourg",
        "role": "fotógrafo oficial",
        "date_created": "1964",
        "museum": "Palais Grand-Ducal, Luxemburgo",
        "formatted_description": "Retrato oficial de Sua Alteza Real o Grão-Duque Jean de Luxemburgo.",
        "license": "Public domain",
        "source": "Cour Grand-Ducale / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_outras_monarquias_henri_de_luxemburgo"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Grao_Duque_Henri",
        "file_name": "01_Grao_Duque_Henri.jpg",
        "commons_file": "File:Henri of Luxembourg (2009).jpg",
        "title": "Grão-Duque Henri de Luxemburgo",
        "artist": "Cour Grand-Ducale / Christian Aschman",
        "role": "fotógrafo oficial",
        "date_created": "2009",
        "museum": "Palais Grand-Ducal, Luxemburgo",
        "formatted_description": "Retrato de Sua Alteza Real o Grão-Duque Henri de Luxemburgo.",
        "license": "CC BY-SA 3.0",
        "source": "Cour Grand-Ducale de Luxembourg / Wikimedia Commons"
    },

    # --- LIECHTENSTEIN ---
    {
        "pessoa_ids": ["pub_monarquias_franz_josef_ii"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Franz_Josef_II",
        "file_name": "01_Franz_Josef_II.jpg",
        "commons_file": "File:Franz Josef II - en profil.jpg",
        "title": "Franz Josef II, Príncipe Soberano de Liechtenstein",
        "artist": "Fürstenhaus Liechtenstein",
        "role": "fotógrafo oficial",
        "date_created": "c. 1950",
        "museum": "Schloss Vaduz, Liechtenstein",
        "formatted_description": "Retrato oficial de Sua Alteza Sereníssima o Príncipe Franz Josef II de Liechtenstein.",
        "license": "Public domain",
        "source": "Fürstliche Sammlungen Liechtenstein / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_monarquias_gina"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Gina_von_Wilczek",
        "file_name": "01_Gina_von_Wilczek.jpg",
        "commons_file": "File:Georgina von Wilczek.jpg",
        "title": "Condessa Georgina (Gina) von Wilczek, Princesa de Liechtenstein",
        "artist": "Fürstenhaus Liechtenstein",
        "role": "fotógrafo oficial",
        "date_created": "1943",
        "museum": "Schloss Vaduz, Liechtenstein",
        "formatted_description": "Retrato oficial de Georgina von Wilczek, princesa consorte de Liechtenstein e mãe de Hans-Adam II.",
        "license": "Public domain",
        "source": "Fürstliche Sammlungen Liechtenstein / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_outras_monarquias_hans_adam_ii_de_liechtenstein"],
        "folder": imagens_base / "realeza-europeia" / "outras-monarquias" / "Hans-Adam_II",
        "file_name": "01_Hans-Adam_II.jpg",
        "commons_file": "File:Fürst Hans-Adam II. von und zu Liechtenstein.jpg",
        "title": "Hans-Adam II, Príncipe Soberano de Liechtenstein",
        "artist": "Fürstenhaus Liechtenstein / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "2004",
        "museum": "Schloss Vaduz, Liechtenstein",
        "formatted_description": "Retrato de Sua Alteza Sereníssima o Príncipe Soberano Hans-Adam II de Liechtenstein.",
        "license": "CC BY-SA 3.0",
        "source": "Fürstliche Sammlungen Liechtenstein / Wikimedia Commons"
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


def executar_batch8():
    print("=" * 75)
    print(" EloTempo - Curadoria Batch 8: Monarquias Tradicionais Europeias (40 figuras)")
    print("=" * 75)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH8_OBRAS:
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

    print(f"\n[Batch 8 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch8()
