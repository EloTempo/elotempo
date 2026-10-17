"""
EloTempo - Curadoria de Obras Históricas: Batch 16 (Grandes Gênios da Literatura e das Artes Clássicas)
=======================================================================================================
Baixa, otimiza e cadastra com metadados Schema v4.0 de mestres da pintura e arquivos oficiais europeus:
1. Família de Wolfgang Amadeus Mozart (7 obras):
   - Wolfgang Amadeus Mozart, Leopold Mozart, Anna Maria Pertl Mozart, Nannerl Mozart,
     Constanze Weber Mozart, Franz Xaver Wolfgang Mozart, Karl Thomas Mozart
2. Família de Ludwig van Beethoven (4 obras):
   - Ludwig van Beethoven, Johann van Beethoven, Nikolaus Johann van Beethoven, Karl van Beethoven (sobrinho)
3. Família de William Shakespeare (1 obra):
   - William Shakespeare (Retrato Chandos / National Portrait Gallery)
4. Família de Dante Alighieri (2 obras):
   - Dante Alighieri (Sandro Botticelli), Beatrice Portinari (Henry Holiday / Walker Art Gallery)
5. Família de Miguel de Cervantes (1 obra):
   - Miguel de Cervantes Saavedra (Juan de Jáuregui / Real Academia Española)
6. Família de Johann Wolfgang von Goethe (6 obras):
   - Johann Wolfgang von Goethe, Johann Caspar Goethe, Catharina Elisabeth Textor (Frau Rat),
     Cornelia Goethe, Christiane Vulpius, August von Goethe
7. Família de Victor Hugo (8 obras):
   - Victor Hugo, General Joseph Léopold Hugo, Sophie Trébuchet, Adèle Foucher,
     Léopoldine Hugo, Abel Hugo, François-Victor Hugo, Charles Hugo
"""

import os
import sys
import json
import uuid
import time
import sqlite3
import requests
from io import BytesIO
from datetime import datetime, timezone
from pathlib import Path
from PIL import Image

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; art and literature; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo" / "artes-literatura"

OBRAS_BATCH16 = [
    # ==========================================
    # 1. FAMÍLIA DE MOZART (7 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_mozart_wolfgang"],
        "folder": imagens_base / "mozart" / "Wolfgang_Amadeus_Mozart",
        "file_name": "01_Wolfgang_Amadeus_Mozart.jpg",
        "commons_file": "File:Barbara Krafft - Porträt Wolfgang Amadeus Mozart (1819).jpg",
        "title": "Wolfgang Amadeus Mozart",
        "artist": "Barbara Krafft",
        "role": "pintora",
        "date_created": "1819",
        "museum": "Gesellschaft der Musikfreunde, Viena / Mozarteum Salzburgo",
        "formatted_description": "Célebre retrato póstumo a óleo de Wolfgang Amadeus Mozart pintado por Barbara Krafft sob orientação de sua irmã Nannerl. Acervo: Gesellschaft der Musikfreunde, Viena.",
        "license": "Public domain",
        "source": "Gesellschaft der Musikfreunde in Wien / Mozarteum Salzburg"
    },
    {
        "pessoa_ids": ["pub_mozart_leopold"],
        "folder": imagens_base / "mozart" / "Leopold_Mozart",
        "file_name": "01_Leopold_Mozart.jpg",
        "commons_file": "File:Leopold Mozart.jpg",
        "title": "Leopold Mozart, Vice-Mestre de Capela",
        "artist": "Pietro Antonio Lorenzoni",
        "role": "pintor",
        "date_created": "c. 1765",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato a óleo de Leopold Mozart por Pietro Antonio Lorenzoni, com violino e partitura na corte de Salzburgo. Acervo: Stiftung Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg"
    },
    {
        "pessoa_ids": ["pub_mozart_anna_maria"],
        "folder": imagens_base / "mozart" / "Anna_Maria_Mozart",
        "file_name": "01_Anna_Maria_Mozart.jpg",
        "commons_file": "File:Maria Anna Mozart (Lorenzoni).jpg",
        "title": "Anna Maria Pertl Mozart",
        "artist": "Pietro Antonio Lorenzoni",
        "role": "pintor",
        "date_created": "c. 1775",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato a óleo de Anna Maria Pertl Mozart, mãe de Wolfgang Amadeus Mozart, atribuído a Pietro Antonio Lorenzoni. Acervo: Stiftung Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg"
    },
    {
        "pessoa_ids": ["pub_mozart_nannerl"],
        "folder": imagens_base / "mozart" / "Nannerl_Mozart",
        "file_name": "01_Nannerl_Mozart.jpg",
        "commons_file": "File:Maria Anna Mozart (inconnu).jpg",
        "title": "Maria Anna Mozart (Nannerl)",
        "artist": "Pintor da Corte Austríaca",
        "role": "pintor",
        "date_created": "c. 1785",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato a óleo de Maria Anna Mozart (Nannerl) em traje de corte de Salzburgo. Acervo: Stiftung Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg"
    },
    {
        "pessoa_ids": ["pub_mozart_constanze"],
        "folder": imagens_base / "mozart" / "Constanze_Mozart",
        "file_name": "01_Constanze_Mozart.jpg",
        "commons_file": "File:Constanze Mozart by Lange 1782.jpg",
        "title": "Constanze Weber Mozart",
        "artist": "Joseph Lange",
        "role": "pintor",
        "date_created": "1782",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato de Constanze Weber pintado no ano de seu casamento com Mozart por seu cunhado, o ator e pintor Joseph Lange. Acervo: Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg / Hunterian Collection"
    },
    {
        "pessoa_ids": ["pub_mozart_franz_xaver"],
        "folder": imagens_base / "mozart" / "Franz_Xaver_Mozart",
        "file_name": "01_Franz_Xaver_Mozart.jpg",
        "commons_file": "File:Franz Xaver Mozart (Wolfgang Jr) 1825.jpg",
        "title": "Franz Xaver Wolfgang Mozart (Mozart Filho)",
        "artist": "Karl Schmuck",
        "role": "pintor",
        "date_created": "1825",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato a óleo de Franz Xaver Wolfgang Mozart (1791–1844), compositor e pianista romântico, por Karl Schmuck (1825). Acervo: Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg"
    },
    {
        "pessoa_ids": ["pub_mozart_karl"],
        "folder": imagens_base / "mozart" / "Karl_Thomas_Mozart",
        "file_name": "01_Karl_Thomas_Mozart.jpg",
        "commons_file": "File:Karl Thomas Mozart.jpg",
        "title": "Karl Thomas Mozart",
        "artist": "Ateliê Milanês Oitocentista",
        "role": "pintor",
        "date_created": "c. 1840",
        "museum": "Stiftung Mozarteum Salzburg, Áustria",
        "formatted_description": "Retrato a óleo de Karl Thomas Mozart, filho primogênito de Mozart, como oficial imperial em Milão. Acervo: Mozarteum Salzburg.",
        "license": "Public domain",
        "source": "Stiftung Mozarteum Salzburg"
    },

    # ==========================================
    # 2. FAMÍLIA DE BEETHOVEN (4 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_beethoven_ludwig"],
        "folder": imagens_base / "beethoven" / "Ludwig_van_Beethoven",
        "file_name": "01_Ludwig_van_Beethoven.jpg",
        "commons_file": "File:Joseph Karl Stieler's Beethoven mit dem Manuskript der Missa solemnis.jpg",
        "title": "Ludwig van Beethoven com a Missa Solemnis",
        "artist": "Joseph Karl Stieler",
        "role": "pintor",
        "date_created": "1820",
        "museum": "Beethoven-Haus Bonn, Alemanha",
        "formatted_description": "O célebre e mais autêntico retrato de Beethoven aos 49 anos segurando a partitura da Missa Solemnis por Joseph Karl Stieler (1820). Acervo: Beethoven-Haus Bonn.",
        "license": "Public domain",
        "source": "Beethoven-Haus Bonn, Alemanha"
    },
    {
        "pessoa_ids": ["pub_beethoven_johann"],
        "folder": imagens_base / "beethoven" / "Johann_van_Beethoven",
        "file_name": "01_Johann_van_Beethoven.jpg",
        "commons_file": "File:Johann von Beethoven.jpg",
        "title": "Johann van Beethoven, Músico de Corte",
        "artist": "Desenho da Corte Eleitoral de Colônia",
        "role": "desenhista",
        "date_created": "c. 1775",
        "museum": "Beethoven-Haus Bonn, Alemanha",
        "formatted_description": "Retrato de época de Johann van Beethoven, pai do compositor e tenor na corte eleitoral de Bonn. Acervo: Beethoven-Haus Bonn.",
        "license": "Public domain",
        "source": "Beethoven-Haus Bonn"
    },
    {
        "pessoa_ids": ["pub_beethoven_nikolaus"],
        "folder": imagens_base / "beethoven" / "Nikolaus_Johann_Beethoven",
        "file_name": "01_Nikolaus_Johann_Beethoven.jpg",
        "commons_file": "File:Nikolaus Johann van Beethoven.png",
        "title": "Nikolaus Johann van Beethoven",
        "artist": "Pintor Austríaco Oitocentista",
        "role": "pintor",
        "date_created": "c. 1825",
        "museum": "Beethoven-Haus Bonn, Alemanha",
        "formatted_description": "Retrato de Nikolaus Johann van Beethoven, irmão mais novo do compositor e farmacêutico em Viena e Linz. Acervo: Beethoven-Haus Bonn.",
        "license": "Public domain",
        "source": "Beethoven-Haus Bonn"
    },
    {
        "pessoa_ids": ["pub_beethoven_karl"],
        "folder": imagens_base / "beethoven" / "Karl_van_Beethoven",
        "file_name": "01_Karl_van_Beethoven.jpg",
        "commons_file": "File:Karl van Beethoven.PNG",
        "title": "Karl van Beethoven (Sobrinho de Beethoven)",
        "artist": "Ateliê Vienense",
        "role": "desenhista",
        "date_created": "c. 1825",
        "museum": "Beethoven-Haus Bonn, Alemanha",
        "formatted_description": "Retrato desenhado de época de Karl van Beethoven, sobrinho sob a guarda tutelar de Ludwig van Beethoven. Acervo: Beethoven-Haus Bonn.",
        "license": "Public domain",
        "source": "Beethoven-Haus Bonn"
    },

    # ==========================================
    # 3. FAMÍLIA DE SHAKESPEARE (1 obra)
    # ==========================================
    {
        "pessoa_ids": ["pub_shakespeare_william"],
        "folder": imagens_base / "shakespeare" / "William_Shakespeare",
        "file_name": "01_William_Shakespeare.jpg",
        "commons_file": "File:William Shakespeare by John Taylor, edited.jpg",
        "title": "William Shakespeare (Retrato Chandos)",
        "artist": "John Taylor",
        "role": "pintor",
        "date_created": "c. 1600–1610",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "O lendário Retrato Chandos de William Shakespeare atribuído a John Taylor, o único retrato aceito com forte base contemporânea de vida e a primeira aquisição na fundação da galeria (NPG 1).",
        "license": "Public domain",
        "source": "National Portrait Gallery, London (NPG 1)"
    },

    # ==========================================
    # 4. FAMÍLIA DE DANTE ALIGHIERI (2 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_dante_alighieri"],
        "folder": imagens_base / "dante" / "Dante_Alighieri",
        "file_name": "01_Dante_Alighieri.jpg",
        "commons_file": "File:Dante Alighieri's portrait by Sandro Botticelli.jpg",
        "title": "Dante Alighieri",
        "artist": "Sandro Botticelli",
        "role": "pintor",
        "date_created": "c. 1495",
        "museum": "Galleria degli Uffizi, Florença / Coleção Privada",
        "formatted_description": "Retrato monumental de Dante Alighieri em perfil com coroa de louros pelo mestre renascentista Sandro Botticelli (c. 1495). Acervo: Uffizi / Coleção Genebra.",
        "license": "Public domain",
        "source": "Galleria degli Uffizi, Florença / Coleção Privada Suíça"
    },
    {
        "pessoa_ids": ["pub_dante_beatrice_portinari"],
        "folder": imagens_base / "dante" / "Beatrice_Portinari",
        "file_name": "01_Beatrice_Portinari.jpg",
        "commons_file": "File:Henry Holiday - Dante and Beatrice - Google Art Project.jpg",
        "title": "O Encontro de Dante e Beatrice na Ponte Santa Trinita",
        "artist": "Henry Holiday",
        "role": "pintor",
        "date_created": "1883",
        "museum": "Walker Art Gallery, Liverpool, Reino Unido",
        "formatted_description": "Obra-prima pré-rafaelita de Henry Holiday retratando o histórico encontro do poeta Dante com Beatrice Portinari às margens do rio Arno em Florença. Acervo: Walker Art Gallery (WAG 3034).",
        "license": "Public domain",
        "source": "Walker Art Gallery, Liverpool / Google Art Project"
    },

    # ==========================================
    # 5. FAMÍLIA DE CERVANTES (1 obra)
    # ==========================================
    {
        "pessoa_ids": ["pub_cervantes_miguel"],
        "folder": imagens_base / "cervantes" / "Miguel_de_Cervantes",
        "file_name": "01_Miguel_de_Cervantes.jpg",
        "commons_file": "File:Cervantes Jáuregui.jpg",
        "title": "Miguel de Cervantes Saavedra",
        "artist": "Juan de Jáuregui (atribuído)",
        "role": "pintor",
        "date_created": "c. 1600",
        "museum": "Real Academia Española (RAE), Madrid",
        "formatted_description": "O célebre retrato de Miguel de Cervantes atribuído ao pintor Juan de Jáuregui, mencionado pelo próprio autor no prólogo das Novelas Exemplares. Acervo: Real Academia Española, Madrid.",
        "license": "Public domain",
        "source": "Real Academia Española, Madrid, Espanha"
    },

    # ==========================================
    # 6. FAMÍLIA DE GOETHE (6 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_goethe_johann_wolfgang"],
        "folder": imagens_base / "goethe" / "Johann_Wolfgang_Goethe",
        "file_name": "01_Johann_Wolfgang_Goethe.jpg",
        "commons_file": "File:Joseph Karl Stieler portrait de Johann Wolfgang von Goethe.jpg",
        "title": "Johann Wolfgang von Goethe aos 79 Anos",
        "artist": "Joseph Karl Stieler",
        "role": "pintor",
        "date_created": "1828",
        "museum": "Neue Pinakothek, Munique, Alemanha",
        "formatted_description": "O magistral retrato a óleo de Goethe aos 79 anos pintado para o Rei Ludwig I da Baviera por Joseph Karl Stieler (1828). Acervo: Neue Pinakothek, Munique (Inv. WAF 1052).",
        "license": "Public domain",
        "source": "Bayerische Staatsgemäldesammlungen - Neue Pinakothek, München"
    },
    {
        "pessoa_ids": ["pub_goethe_johann_caspar"],
        "folder": imagens_base / "goethe" / "Johann_Caspar_Goethe",
        "file_name": "01_Johann_Caspar_Goethe.jpg",
        "commons_file": "File:Johann Caspar Goethe by Schmoll, 1774.jpg",
        "title": "Johann Caspar Goethe, Conselheiro Imperial",
        "artist": "Johann Friedrich August Tischbein / Schmoll",
        "role": "pintor",
        "date_created": "1774",
        "museum": "Goethe-Nationalmuseum, Weimar, Alemanha",
        "formatted_description": "Retrato a óleo de Johann Caspar Goethe, pai do escritor e conselheiro imperial em Frankfurt. Acervo: Klassik Stiftung Weimar / Goethe-Nationalmuseum.",
        "license": "Public domain",
        "source": "Klassik Stiftung Weimar"
    },
    {
        "pessoa_ids": ["pub_goethe_catharina"],
        "folder": imagens_base / "goethe" / "Catharina_Elisabeth_Goethe",
        "file_name": "01_Catharina_Elisabeth_Goethe.jpg",
        "commons_file": "File:Catharina Elisabeth Goethe 1776.jpg",
        "title": "Catharina Elisabeth Textor Goethe (Frau Rat)",
        "artist": "Georg Oswald May",
        "role": "pintor",
        "date_created": "1776",
        "museum": "Historisches Museum Frankfurt, Alemanha",
        "formatted_description": "Retrato a óleo de Catharina Elisabeth Textor (Frau Rat Goethe), mãe de Goethe, aos 45 anos por Georg Oswald May (1776). Acervo: Historisches Museum Frankfurt.",
        "license": "Public domain",
        "source": "Historisches Museum Frankfurt"
    },
    {
        "pessoa_ids": ["pub_goethe_cornelia"],
        "folder": imagens_base / "goethe" / "Cornelia_Goethe",
        "file_name": "01_Cornelia_Goethe.jpg",
        "commons_file": "File:CorneliaGoetheWithBook.jpg",
        "title": "Cornelia Goethe com Livro",
        "artist": "Johann Ludwig Ernst Morgenstern",
        "role": "pintor",
        "date_created": "c. 1770",
        "museum": "Freies Deutsches Hochstift / Goethe-Museum Frankfurt",
        "formatted_description": "Retrato a óleo de Cornelia Goethe (1750–1777), irmã de Johann Wolfgang von Goethe, por Johann Ludwig Ernst Morgenstern. Acervo: Frankfurter Goethe-Museum.",
        "license": "Public domain",
        "source": "Freies Deutsches Hochstift / Frankfurter Goethe-Museum"
    },
    {
        "pessoa_ids": ["pub_goethe_christiane"],
        "folder": imagens_base / "goethe" / "Christiane_Vulpius",
        "file_name": "01_Christiane_Vulpius.jpg",
        "commons_file": "File:Christiane Vulpius Gemälde.jpg",
        "title": "Christiane Vulpius von Goethe",
        "artist": "Friedrich Bury",
        "role": "pintor",
        "date_created": "c. 1800",
        "museum": "Klassik Stiftung Weimar, Alemanha",
        "formatted_description": "Retrato a óleo de Christiane Vulpius por Friedrich Bury em Weimar. Acervo: Klassik Stiftung Weimar.",
        "license": "Public domain",
        "source": "Klassik Stiftung Weimar"
    },
    {
        "pessoa_ids": ["pub_goethe_august"],
        "folder": imagens_base / "goethe" / "August_von_Goethe",
        "file_name": "01_August_von_Goethe.jpg",
        "commons_file": "File:AugustVonGoethe.jpg",
        "title": "August von Goethe",
        "artist": "Louise Seidler",
        "role": "pintora",
        "date_created": "c. 1815",
        "museum": "Klassik Stiftung Weimar, Alemanha",
        "formatted_description": "Retrato a óleo de Julius August Walther von Goethe (1789–1830), filho único de Goethe, pela pintora da corte de Weimar Louise Seidler. Acervo: Klassik Stiftung Weimar.",
        "license": "Public domain",
        "source": "Klassik Stiftung Weimar"
    },

    # ==========================================
    # 7. FAMÍLIA DE VICTOR HUGO (8 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_hugo_victor"],
        "folder": imagens_base / "victor-hugo" / "Victor_Hugo",
        "file_name": "01_Victor_Hugo.jpg",
        "commons_file": "File:Victor Hugo by Étienne Carjat 1876 - full.jpg",
        "title": "Victor Hugo aos 74 Anos",
        "artist": "Étienne Carjat",
        "role": "fotógrafo",
        "date_created": "1876",
        "museum": "Maison de Victor Hugo, Paris / Bibliothèque nationale de France",
        "formatted_description": "O célebre e magistral retrato fotográfico de Victor Hugo em plano médio por Étienne Carjat (1876). Acervo: Maison de Victor Hugo / BnF.",
        "license": "Public domain",
        "source": "Bibliothèque nationale de France / Maison de Victor Hugo"
    },
    {
        "pessoa_ids": ["pub_hugo_joseph_leopold"],
        "folder": imagens_base / "victor-hugo" / "General_Joseph_Leopold_Hugo",
        "file_name": "01_General_Joseph_Leopold_Hugo.jpg",
        "commons_file": "File:Général Joseph-Leopold Sigisbert Hugo.jpg",
        "title": "General Joseph Léopold Sigisbert Hugo",
        "artist": "Jean-Baptiste Mauzaisse",
        "role": "pintor",
        "date_created": "c. 1820",
        "museum": "Musée national des châteaux de Versailles / Maison de Victor Hugo",
        "formatted_description": "Retrato em farda de gala do General do Império Joseph Léopold Hugo por Jean-Baptiste Mauzaisse. Acervo: Musée de Versailles.",
        "license": "Public domain",
        "source": "Musée national des châteaux de Versailles et de Trianon"
    },
    {
        "pessoa_ids": ["pub_hugo_sophie"],
        "folder": imagens_base / "victor-hugo" / "Sophie_Trebuchet_Hugo",
        "file_name": "01_Sophie_Trebuchet_Hugo.jpg",
        "commons_file": "File:Sophie Trébuchet.jpg",
        "title": "Sophie Trébuchet Hugo",
        "artist": "Pintor da Escola Francesa",
        "role": "miniaturista",
        "date_created": "c. 1805",
        "museum": "Maison de Victor Hugo, Paris",
        "formatted_description": "Retrato em miniatura de Sophie Trébuchet, mãe de Victor Hugo. Acervo: Maisons de Victor Hugo Paris-Guernsey.",
        "license": "Public domain",
        "source": "Maisons de Victor Hugo Paris-Guernsey / Paris Musées"
    },
    {
        "pessoa_ids": ["pub_hugo_adele_foucher"],
        "folder": imagens_base / "victor-hugo" / "Adele_Foucher_Hugo",
        "file_name": "01_Adele_Foucher_Hugo.jpg",
        "commons_file": "File:Adele Hugo by Louis Boulanger.jpg",
        "title": "Adèle Foucher Hugo",
        "artist": "Louis Boulanger",
        "role": "pintor",
        "date_created": "1839",
        "museum": "Maison de Victor Hugo, Paris",
        "formatted_description": "Retrato a óleo de Adèle Foucher, esposa de Victor Hugo, pelo pintor romântico Louis Boulanger (1839). Acervo: Maisons de Victor Hugo Paris-Guernsey.",
        "license": "Public domain",
        "source": "Paris Musées / Maisons de Victor Hugo"
    },
    {
        "pessoa_ids": ["pub_hugo_leopoldine"],
        "folder": imagens_base / "victor-hugo" / "Leopoldine_Hugo",
        "file_name": "01_Leopoldine_Hugo.jpg",
        "commons_file": "File:Auguste de Chatillon - Léopoldine Hugo.jpg",
        "title": "Léopoldine Hugo aos Quatro Anos com Livro de Orações",
        "artist": "Auguste de Châtillon",
        "role": "pintor",
        "date_created": "1835",
        "museum": "Maison de Victor Hugo, Paris",
        "formatted_description": "Célebre pintura de Léopoldine Hugo aos quatro anos de idade por Auguste de Châtillon (1835). Acervo: Maisons de Victor Hugo Paris-Guernsey (Inv. 28).",
        "license": "Public domain",
        "source": "Paris Musées / Maisons de Victor Hugo"
    },
    {
        "pessoa_ids": ["pub_hugo_abel"],
        "folder": imagens_base / "victor-hugo" / "Abel_Hugo",
        "file_name": "01_Abel_Hugo.jpg",
        "commons_file": "File:Duvidal de Montferrier - Abel Hugo (1798-1865).jpg",
        "title": "Abel Hugo, Historiador e Ensaísta",
        "artist": "Julie Duvidal de Montferrier",
        "role": "pintora",
        "date_created": "c. 1830",
        "museum": "Maison de Victor Hugo, Paris",
        "formatted_description": "Retrato de Abel Hugo, irmão mais velho de Victor Hugo, pintado por sua esposa Julie Duvidal de Montferrier. Acervo: Maisons de Victor Hugo Paris-Guernsey.",
        "license": "Public domain",
        "source": "Paris Musées / Maisons de Victor Hugo"
    },
    {
        "pessoa_ids": ["pub_hugo_francois_victor"],
        "folder": imagens_base / "victor-hugo" / "Francois_Victor_Hugo",
        "file_name": "01_Francois_Victor_Hugo.jpg",
        "commons_file": "File:François-Victor Hugo Jersey 1853-1855 Vacquerie.jpg",
        "title": "François-Victor Hugo no Exílio de Jersey",
        "artist": "Auguste Vacquerie & Charles Hugo",
        "role": "fotógrafo",
        "date_created": "1853",
        "museum": "Musée d'Orsay / Maison de Victor Hugo",
        "formatted_description": "Fotografia de François-Victor Hugo por Auguste Vacquerie e Charles Hugo na Marine Terrace em Jersey (1853). Acervo: Musée d'Orsay.",
        "license": "Public domain",
        "source": "Musée d'Orsay / Réunion des Musées Nationaux"
    },
    {
        "pessoa_ids": ["pub_hugo_charles"],
        "folder": imagens_base / "victor-hugo" / "Charles_Hugo",
        "file_name": "01_Charles_Hugo.jpg",
        "commons_file": "File:Recueil. Portraits de Victor Hugo et de ses familiers à Jersey, entre 1852 et 1855 - Charles Hugo ; A. Vacquerie - btv1b8452750c (123 of 136).jpg",
        "title": "Charles Hugo no Exílio de Jersey",
        "artist": "Atelier de Marine Terrace (Charles Hugo & Auguste Vacquerie)",
        "role": "fotógrafo",
        "date_created": "1853",
        "museum": "Bibliothèque nationale de France, Département des Estampes",
        "formatted_description": "Retrato fotográfico de Charles Hugo no ateliê pioneiro de Marine Terrace em Jersey (1853). Acervo: Bibliothèque nationale de France (btv1b8452750c).",
        "license": "Public domain",
        "source": "Bibliothèque nationale de France"
    }
]


def resolver_url_commons(session: requests.Session, commons_file: str) -> str | None:
    params = {
        "action": "query",
        "format": "json",
        "titles": commons_file,
        "prop": "imageinfo",
        "iiprop": "url|size|mime"
    }
    try:
        r = session.get(COMMONS_API, params=params, timeout=20)
        pages = r.json().get("query", {}).get("pages", {})
        for k, v in pages.items():
            if k != "-1" and "imageinfo" in v:
                return v["imageinfo"][0].get("url")
    except Exception as e:
        print(f"    ✕ Erro ao consultar API Commons: {e}")
    return None


def otimizar_imagem(bytes_orig: bytes, max_side: int = 1920) -> tuple[bytes, str]:
    im = Image.open(BytesIO(bytes_orig))
    formato_orig = im.format.upper() if im.format else "JPEG"

    w, h = im.size
    if max(w, h) > max_side:
        im.thumbnail((max_side, max_side), Image.Resampling.LANCZOS)

    if formato_orig in ("TIFF", "TIF") or (formato_orig == "PNG" and len(bytes_orig) > 5 * 1024 * 1024):
        if im.mode not in ("RGB", "L"):
            im = im.convert("RGB")
        out_buf = BytesIO()
        im.save(out_buf, format="JPEG", quality=95, optimize=True)
        return out_buf.getvalue(), ".jpg"

    if formato_orig == "PNG":
        out_buf = BytesIO()
        im.save(out_buf, format="PNG", optimize=True)
        return out_buf.getvalue(), ".png"

    if im.mode not in ("RGB", "L"):
        im = im.convert("RGB")
    out_buf = BytesIO()
    im.save(out_buf, format="JPEG", quality=95, optimize=True)
    return out_buf.getvalue(), ".jpg"


def executar_curadoria():
    print("=" * 75)
    print("ELO TEMPO: CURADORIA BATCH 16 - LITERATURA E ARTES CLÁSSICAS")
    print("=" * 75)
    print(f"Total de obras a processar: {len(OBRAS_BATCH16)}")
    print(f"Banco de dados: {db_path}")
    print(f"Pasta de Mídia: {midia_dir}")
    print(f"Base de Imagens: {imagens_base}\n")

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_sucesso = 0
    total_vinculos = 0

    for i, item in enumerate(OBRAS_BATCH16, 1):
        print(f"\n[{i:02d}/{len(OBRAS_BATCH16):02d}] {item['title']}")
        print(f"  Pessoas vinculadas: {item['pessoa_ids']}")
        print(f"  Fonte Commons: {item['commons_file']}")

        # Garante pasta de destino
        item["folder"].mkdir(parents=True, exist_ok=True)
        img_dest = item["folder"] / item["file_name"]
        json_dest = item["folder"] / (img_dest.stem + ".json")

        img_bytes = None

        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print("  Resolvendo URL direta no Wikimedia Commons...")
            url = resolver_url_commons(session, item["commons_file"])
            if not url:
                print(f"    ✕ Falha ao resolver URL para {item['commons_file']}")
                continue
            item["url"] = url

            print(f"  Baixando imagem institucional ({url.split('/')[-1]})...")
            time.sleep(0.8)
            try:
                resp = session.get(url, timeout=60)
                if resp.status_code == 200 and len(resp.content) > 5000:
                    raw_bytes = resp.content
                    print(f"    ✓ Download concluído: {len(raw_bytes):,} bytes originais.")
                    
                    img_bytes, novo_ext = otimizar_imagem(raw_bytes)
                    if novo_ext != img_dest.suffix.lower():
                        img_dest = img_dest.with_suffix(novo_ext)
                        item["file_name"] = img_dest.name
                        json_dest = item["folder"] / (img_dest.stem + ".json")

                    img_dest.write_bytes(img_bytes)
                    print(f"    ✓ Imagem tratada e salva: {img_dest.name} ({len(img_bytes):,} bytes)")
                else:
                    print(f"    ✕ Falha no download (HTTP {resp.status_code})")
                    continue
            except Exception as e:
                print(f"    ✕ Erro no download: {e}")
                continue
        else:
            print(f"    ✓ Imagem já existente em disco: {img_dest.name}")
            img_bytes = img_dest.read_bytes()
            item["url"] = item.get("url") or f"https://commons.wikimedia.org/wiki/{item['commons_file']}"

        # 1. Metadados Schema 4.0
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
        print(f"    ✓ Metadados Schema 4.0 gravados: {json_dest.name}")

        # 2. Copia para %APPDATA%/midia/ com UUID
        ext = img_dest.suffix.lower()
        doc_id = str(uuid.uuid4())
        nome_midia = f"{doc_id}{ext}"
        midia_file = midia_dir / nome_midia
        midia_file.write_bytes(img_bytes)
        caminho_relativo = f"midia/{nome_midia}"
        tamanho_bytes = len(img_bytes)
        agora = datetime.now(timezone.utc).isoformat()

        titulo_doc = f"Retrato: {item['title']}"
        desc_doc = f"Obra: {item['formatted_description']} | Licença: {item['license']} | Fonte: {item['source']}"

        # 3. Insere registro em 'documentos'
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
            item["date_created"],
            titulo_doc,
            desc_doc,
            item["file_name"],
            agora
        ))

        # 4. Vincula a cada pessoa_id e atualiza foto_url
        for pid in item["pessoa_ids"]:
            cur.execute("SELECT id, nome, sobrenome FROM pessoas WHERE id = ?", (pid,))
            p_row = cur.fetchone()
            if not p_row:
                print(f"    ⚠ Aviso: pessoa {pid} não encontrada na tabela 'pessoas'!")
                continue

            vinc_id = str(uuid.uuid4())
            cur.execute("""
                INSERT INTO documento_vinculos (id, documento_id, pessoa_id, evento_id)
                VALUES (?, ?, ?, NULL)
            """, (vinc_id, doc_id, pid))

            cur.execute("UPDATE pessoas SET foto_url = ? WHERE id = ?", (caminho_relativo, pid))
            print(f"    -> Foto aplicada à pessoa [{pid}] ({p_row[1]} {p_row[2] or ''})")
            total_vinculos += 1

        total_sucesso += 1

    conn.commit()
    conn.close()

    print("\n" + "=" * 75)
    print("CURADORIA BATCH 16 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {total_sucesso}/{len(OBRAS_BATCH16)}")
    print(f"Total de pessoas vinculadas com fotos atualizadas: {total_vinculos}")
    print("=" * 75)


if __name__ == "__main__":
    executar_curadoria()
