"""
EloTempo - Curadoria de Obras Históricas: Batch 15 (Grandes Lideranças Mundiais e Fundadores de Nações)
======================================================================================================
Baixa, otimiza e cadastra com metadados Schema v4.0 de mestres da pintura e arquivos oficiais nacionais:
1. Casa Imperial de Bonaparte (12 obras):
   - Carlo Buonaparte, Letizia Ramolino, José Bonaparte, Napoleão I, Josefina de Beauharnais,
     Maria Luísa da Áustria, Napoleão II (Rei de Roma), Lucien Bonaparte, Louis Bonaparte,
     Hortense de Beauharnais, Napoleão III, Jérôme Bonaparte
2. Família de George Washington (4 obras):
   - George Washington, Martha Washington, Lawrence Washington, John Parke Custis (Jacky)
3. Família de Thomas Jefferson (2 obras):
   - Thomas Jefferson, Martha Jefferson Randolph (Patsy)
4. Família de Benjamin Franklin (3 obras):
   - Benjamin Franklin, William Franklin, Sarah Franklin Bache (Sally)
5. Família de Abraham Lincoln (4 obras):
   - Abraham Lincoln, Mary Todd Lincoln, Robert Todd Lincoln, Sarah Bush Johnston Lincoln
6. Família de Sir Winston Churchill (6 obras):
   - Lord Randolph Churchill, Lady Jennie Jerome, Sir Winston Churchill, Clementine Churchill,
     Randolph Churchill (filho), Mary Churchill (Lady Soames)
7. Família de Mahatma Gandhi (5 obras):
   - Karamchand Gandhi (Kaba), Mohandas Karamchand Gandhi, Kasturba Gandhi, Manilal Gandhi, Devdas Gandhi
8. Família de Nelson Mandela (4 obras):
   - Nelson Rolihlahla Mandela, Evelyn Ntoko Mase, Winnie Madikizela-Mandela, Graça Machel Mandela
9. Família de Martin Luther King Jr. (6 obras):
   - Martin Luther King Sr., Alberta Williams King, Martin Luther King Jr., Coretta Scott King,
     Martin Luther King III, Bernice Albertine King
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; world leaders; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo" / "liderancas-mundiais"

OBRAS_BATCH15 = [
    # ==========================================
    # 1. CASA IMPERIAL DE BONAPARTE (12 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_bonaparte_carlo"],
        "folder": imagens_base / "bonaparte" / "Carlo_Buonaparte",
        "file_name": "01_Carlo_Buonaparte.jpg",
        "commons_file": "File:Carlo Buonaparte.jpg",
        "title": "Carlo Maria Buonaparte, Nobre e Magistrado Corso",
        "artist": "Ateliê Corso / Coleção Napoleônica",
        "role": "pintor",
        "date_created": "c. 1775",
        "museum": "Musée national de la Maison Bonaparte, Ajaccio",
        "formatted_description": "Retrato a óleo de Carlo Maria Buonaparte (1746–1785), pai de Napoleão Bonaparte. Acervo: Maison Bonaparte, Ajaccio, Córsega.",
        "license": "Public domain",
        "source": "Musée national de la Maison Bonaparte, Ajaccio, Córsega"
    },
    {
        "pessoa_ids": ["pub_bonaparte_letizia"],
        "folder": imagens_base / "bonaparte" / "Letizia_Ramolino",
        "file_name": "01_Letizia_Ramolino.jpg",
        "commons_file": "File:François Pascal Simon Gérard - Madame Mère (Maria Laetitia Ramolino Bonaparte, 1750 - 1836) - NG 2461 - National Galleries of Scotland.jpg",
        "title": "Maria Letizia Ramolino, Madame Mère de l'Empereur",
        "artist": "François Gérard",
        "role": "pintor",
        "date_created": "c. 1800–1804",
        "museum": "National Galleries of Scotland, Edimburgo",
        "formatted_description": "Retrato neoclássico de Maria Letizia Ramolino por François Gérard. Acervo: National Galleries of Scotland (NG 2461).",
        "license": "Public domain",
        "source": "National Galleries of Scotland"
    },
    {
        "pessoa_ids": ["pub_bonaparte_jose"],
        "folder": imagens_base / "bonaparte" / "Jose_Bonaparte",
        "file_name": "01_Jose_Bonaparte.jpg",
        "commons_file": "File:Joseph-Bonaparte.jpg",
        "title": "José Bonaparte, Rei de Nápoles e da Espanha",
        "artist": "François Gérard",
        "role": "pintor",
        "date_created": "c. 1808",
        "museum": "Musée national des châteaux de Versailles et de Trianon",
        "formatted_description": "Retrato solene de José Bonaparte por François Gérard (c. 1808). Acervo: Châteaux de Versailles et de Trianon.",
        "license": "Public domain",
        "source": "Musée national des châteaux de Versailles et de Trianon"
    },
    {
        "pessoa_ids": ["pub_bonaparte_napoleao"],
        "folder": imagens_base / "bonaparte" / "Napoleao_Bonaparte",
        "file_name": "01_Napoleao_Bonaparte.jpg",
        "commons_file": "File:Jacques-Louis David - The Emperor Napoleon in His Study at the Tuileries - Google Art Project.jpg",
        "title": "Napoleão I em Seu Gabinete de Trabalho nas Tulherias",
        "artist": "Jacques-Louis David",
        "role": "pintor",
        "date_created": "1812",
        "museum": "National Gallery of Art, Washington D.C.",
        "formatted_description": "Obra-prima de Jacques-Louis David retratando Napoleão Bonaparte aos 43 anos em uniforme de coronel dos granadeiros a cavalo. Acervo: National Gallery of Art (Coleção Samuel H. Kress).",
        "license": "Public domain",
        "source": "National Gallery of Art, Washington D.C. / Google Art Project"
    },
    {
        "pessoa_ids": ["pub_bonaparte_josefina"],
        "folder": imagens_base / "bonaparte" / "Josefina_de_Beauharnais",
        "file_name": "01_Josefina_de_Beauharnais.jpg",
        "commons_file": "File:Baron François Gérard - Joséphine in coronation costume - Google Art Project.jpg",
        "title": "A Imperatriz Josefina em Traje de Coroação",
        "artist": "Baron François Gérard",
        "role": "pintor",
        "date_created": "1807–1808",
        "museum": "Musée national du château de Malmaison / Musée de Versailles",
        "formatted_description": "Retrato cerimonial da Imperatriz Josefina de Beauharnais em manto de coroação bordado a ouro por François Gérard. Acervo: Château de Fontainebleau / Malmaison.",
        "license": "Public domain",
        "source": "Réunion des Musées Nationaux / Google Art Project"
    },
    {
        "pessoa_ids": ["pub_bonaparte_maria_luisa"],
        "folder": imagens_base / "bonaparte" / "Maria_Luisa_da_Austria",
        "file_name": "01_Maria_Luisa_da_Austria.jpg",
        "commons_file": "File:Empress Marie Louise of the French.jpg",
        "title": "Maria Luísa da Áustria, Imperatriz dos Franceses",
        "artist": "Jean-Baptiste Isabey / François Gérard",
        "role": "pintor",
        "date_created": "c. 1812",
        "museum": "Musée national du château de Versailles",
        "formatted_description": "Retrato imperial de Maria Luísa da Áustria, segunda esposa de Napoleão I e Duquesa Soberana de Parma. Acervo: Musée de Versailles.",
        "license": "Public domain",
        "source": "Musée national des châteaux de Versailles et de Trianon"
    },
    {
        "pessoa_ids": ["pub_bonaparte_napoleao2"],
        "folder": imagens_base / "bonaparte" / "Napoleao_II",
        "file_name": "01_Napoleao_II.jpg",
        "commons_file": "File:Michael Moritz Daffinger - Der Herzog von Reichstadt - 2085 - Österreichische Galerie Belvedere.jpg",
        "title": "Napoleão II, Rei de Roma e Duque de Reichstadt",
        "artist": "Moritz Michael Daffinger",
        "role": "pintor",
        "date_created": "c. 1830",
        "museum": "Österreichische Galerie Belvedere, Viena",
        "formatted_description": "Retrato a óleo de Napoleão II (1811–1832), filho único de Napoleão I e Maria Luísa, em uniforme militar austríaco. Acervo: Österreichische Galerie Belvedere, Viena (Inv. 2085).",
        "license": "Public domain",
        "source": "Österreichische Galerie Belvedere, Viena, Áustria"
    },
    {
        "pessoa_ids": ["pub_bonaparte_lucien"],
        "folder": imagens_base / "bonaparte" / "Lucien_Bonaparte",
        "file_name": "01_Lucien_Bonaparte.jpg",
        "commons_file": "File:Robert Lefèvre - Lucien Bonaparte, Prince de Canino (1755-1840).jpg",
        "title": "Lucien Bonaparte, Príncipe de Canino e Musignano",
        "artist": "Robert Lefèvre",
        "role": "pintor",
        "date_created": "c. 1800",
        "museum": "Musée national des châteaux de Versailles et de Trianon",
        "formatted_description": "Retrato de Lucien Bonaparte, presidente do Conselho dos Quinhentos e Príncipe de Canino, por Robert Lefèvre. Acervo: Musée de Versailles.",
        "license": "Public domain",
        "source": "Musée national des châteaux de Versailles et de Trianon"
    },
    {
        "pessoa_ids": ["pub_bonaparte_louis"],
        "folder": imagens_base / "bonaparte" / "Louis_Bonaparte",
        "file_name": "01_Louis_Bonaparte.jpg",
        "commons_file": "File:LouisBonaparte Holland.jpg",
        "title": "Louis Bonaparte, Rei da Holanda",
        "artist": "Charles Howard Hodges",
        "role": "pintor",
        "date_created": "1809",
        "museum": "Rijksmuseum, Amsterdã",
        "formatted_description": "Retrato monumental de Louis Bonaparte como Rei da Holanda por Charles Howard Hodges (1809). Acervo: Rijksmuseum, Amsterdã (SK-A-3877).",
        "license": "Public domain",
        "source": "Rijksmuseum, Amsterdã, Países Baixos"
    },
    {
        "pessoa_ids": ["pub_bonaparte_hortense"],
        "folder": imagens_base / "bonaparte" / "Hortense_de_Beauharnais",
        "file_name": "01_Hortense_de_Beauharnais.jpg",
        "commons_file": "File:François Pascal Simon Gérard 002.jpg",
        "title": "Hortense de Beauharnais, Rainha da Holanda",
        "artist": "Baron François Gérard",
        "role": "pintor",
        "date_created": "c. 1806",
        "museum": "Musée de Malmaison / Rijksmuseum",
        "formatted_description": "Retrato de Hortense de Beauharnais, Rainha da Holanda e mãe de Napoleão III, por François Gérard (c. 1806). Acervo: Musée national des châteaux de Malmaison et de Bois-Préau.",
        "license": "Public domain",
        "source": "Réunion des Musées Nationaux"
    },
    {
        "pessoa_ids": ["pub_bonaparte_napoleao3"],
        "folder": imagens_base / "bonaparte" / "Napoleao_III",
        "file_name": "01_Napoleao_III.jpg",
        "commons_file": "File:Franz Xaver Winterhalter Napoleon III.jpg",
        "title": "Napoleão III, Imperador dos Franceses",
        "artist": "Franz Xaver Winterhalter",
        "role": "pintor",
        "date_created": "1853",
        "museum": "Musée de la Légion d'Honneur / Musée d'Orsay",
        "formatted_description": "Retrato cerimonial de Napoleão III por Franz Xaver Winterhalter (1853), ápice do Segundo Império Francês. Acervo: Musée d'Orsay / Légion d'Honneur.",
        "license": "Public domain",
        "source": "Musée de l'Armée / Musée de la Légion d'Honneur, Paris"
    },
    {
        "pessoa_ids": ["pub_bonaparte_jerome"],
        "folder": imagens_base / "bonaparte" / "Jerome_Bonaparte",
        "file_name": "01_Jerome_Bonaparte.jpg",
        "commons_file": "File:King Jerome Bonaparte.jpg",
        "title": "Jérôme Bonaparte, Rei da Vestfália",
        "artist": "Baron François Gérard",
        "role": "pintor",
        "date_created": "c. 1810",
        "museum": "Musée de Versailles / Château de Wilhelmshöhe",
        "formatted_description": "Retrato de Jérôme Bonaparte como Soberano da Vestfália por François Gérard. Acervo: Musée de Versailles.",
        "license": "Public domain",
        "source": "Musée national des châteaux de Versailles et de Trianon"
    },

    # ==========================================
    # 2. FAMÍLIA DE GEORGE WASHINGTON (4 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_washington_george"],
        "folder": imagens_base / "washington" / "George_Washington",
        "file_name": "01_George_Washington.jpg",
        "commons_file": "File:Gilbert Stuart - George Washington (Lansdowne Portrait) - Google Art Project.jpg",
        "title": "George Washington (Retrato Lansdowne)",
        "artist": "Gilbert Stuart",
        "role": "pintor",
        "date_created": "1796",
        "museum": "National Portrait Gallery, Smithsonian Institution, Washington D.C.",
        "formatted_description": "O monumental retrato Lansdowne por Gilbert Stuart (1796), a representação mais celebrada do primeiro Presidente dos EUA. Acervo: National Portrait Gallery, Smithsonian Institution (NPG.2001.13).",
        "license": "Public domain",
        "source": "National Portrait Gallery, Smithsonian Institution / Google Art Project"
    },
    {
        "pessoa_ids": ["pub_washington_martha"],
        "folder": imagens_base / "washington" / "Martha_Washington",
        "file_name": "01_Martha_Washington.jpg",
        "commons_file": "File:Gilbert Stuart - Martha Washington (The Athenaeum Portrait) - Google Art Project.jpg",
        "title": "Martha Dandridge Custis Washington (Retrato Athenaeum)",
        "artist": "Gilbert Stuart",
        "role": "pintor",
        "date_created": "1796",
        "museum": "Museum of Fine Arts, Boston / National Portrait Gallery, Smithsonian",
        "formatted_description": "Retrato da Primeira-Dama Martha Washington por Gilbert Stuart (1796). Acervo conjunto: Museum of Fine Arts, Boston e National Portrait Gallery, Washington D.C.",
        "license": "Public domain",
        "source": "Museum of Fine Arts, Boston / Google Art Project"
    },
    {
        "pessoa_ids": ["pub_washington_lawrence"],
        "folder": imagens_base / "washington" / "Lawrence_Washington",
        "file_name": "01_Lawrence_Washington.jpg",
        "commons_file": "File:Lawrence Washington.jpg",
        "title": "Lawrence Washington, Capitão e Mentor de Mount Vernon",
        "artist": "John Wollaston",
        "role": "pintor",
        "date_created": "c. 1748",
        "museum": "Mount Vernon Ladies' Association",
        "formatted_description": "Retrato colonial a óleo de Lawrence Washington (1718–1752), irmão mais velho e mentor militar de George Washington. Acervo: Mount Vernon Ladies' Association.",
        "license": "Public domain",
        "source": "Mount Vernon Ladies' Association, Virginia"
    },
    {
        "pessoa_ids": ["pub_washington_jacky_custis"],
        "folder": imagens_base / "washington" / "Jacky_Custis",
        "file_name": "01_Jacky_Custis.jpg",
        "commons_file": "File:Miniature of John Parke Custis on ivory (NYPL b12349151-417890).jpg",
        "title": "John Parke Custis (Jacky Custis)",
        "artist": "Charles Willson Peale",
        "role": "miniaturista",
        "date_created": "c. 1774",
        "museum": "The New York Public Library / Mount Vernon Collection",
        "formatted_description": "Miniatura em aquarela sobre marfim de John Parke Custis por Charles Willson Peale (c. 1774). Acervo: The New York Public Library.",
        "license": "Public domain",
        "source": "The New York Public Library, Manuscripts and Archives Division"
    },

    # ==========================================
    # 3. FAMÍLIA DE THOMAS JEFFERSON (2 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_jefferson_thomas"],
        "folder": imagens_base / "jefferson" / "Thomas_Jefferson",
        "file_name": "01_Thomas_Jefferson.jpg",
        "commons_file": "File:Official Presidential portrait of Thomas Jefferson (by Rembrandt Peale, 1800).jpg",
        "title": "Thomas Jefferson, 3º Presidente dos Estados Unidos",
        "artist": "Rembrandt Peale",
        "role": "pintor",
        "date_created": "1800",
        "museum": "White House Historical Association / The White House Collection",
        "formatted_description": "Retrato oficial de Thomas Jefferson aos 57 anos por Rembrandt Peale (1800), ano de sua eleição presidencial. Acervo: The White House Collection, Washington D.C.",
        "license": "Public domain",
        "source": "White House Historical Association / Library of Congress"
    },
    {
        "pessoa_ids": ["pub_jefferson_martha_patsy"],
        "folder": imagens_base / "jefferson" / "Martha_Patsy_Jefferson",
        "file_name": "01_Martha_Patsy_Jefferson.jpg",
        "commons_file": "File:Martha Jefferson Randolph, daughter of Thomas Jefferson LCCN2014648297.jpg",
        "title": "Martha Jefferson Randolph (Patsy)",
        "artist": "Thomas Sully",
        "role": "pintor",
        "date_created": "1836",
        "museum": "Thomas Jefferson Foundation, Monticello / Library of Congress",
        "formatted_description": "Retrato de Martha Jefferson Randolph por Thomas Sully (1836). Acervo: Monticello / Library of Congress (LC-USZ62-110023).",
        "license": "Public domain",
        "source": "Thomas Jefferson Foundation / Library of Congress"
    },

    # ==========================================
    # 4. FAMÍLIA DE BENJAMIN FRANKLIN (3 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_franklin_benjamin"],
        "folder": imagens_base / "franklin" / "Benjamin_Franklin",
        "file_name": "01_Benjamin_Franklin.jpg",
        "commons_file": "File:Benjamin Franklin by Joseph Duplessis 1778.jpg",
        "title": "Benjamin Franklin em Paris",
        "artist": "Joseph Duplessis",
        "role": "pintor",
        "date_created": "1778",
        "museum": "Metropolitan Museum of Art, Nova York",
        "formatted_description": "O célebre retrato de Benjamin Franklin com gola de pele por Joseph Duplessis (1778), pintado durante sua missão diplomática em Paris. Acervo: Metropolitan Museum of Art (Inv. 20.76).",
        "license": "Public domain",
        "source": "Metropolitan Museum of Art, New York"
    },
    {
        "pessoa_ids": ["pub_franklin_william"],
        "folder": imagens_base / "franklin" / "William_Franklin",
        "file_name": "01_William_Franklin.jpg",
        "commons_file": "File:William Franklin, Governor of New Jersey (NYPL b13049825-424716).jpg",
        "title": "William Franklin, Último Governador Real de Nova Jersey",
        "artist": "Mather Brown / Ateliê Britânico",
        "role": "pintor",
        "date_created": "c. 1775–1780",
        "museum": "The New York Public Library / American Philosophical Society",
        "formatted_description": "Retrato de William Franklin, filho de Benjamin Franklin e governador colonial lealista de Nova Jersey. Acervo: The New York Public Library.",
        "license": "Public domain",
        "source": "The New York Public Library, Print Collection"
    },
    {
        "pessoa_ids": ["pub_franklin_sarah_sally"],
        "folder": imagens_base / "franklin" / "Sarah_Sally_Bache",
        "file_name": "01_Sarah_Sally_Bache.jpg",
        "commons_file": "File:Hoppner - Sarah Franklin Bache - with frame.jpg",
        "title": "Sarah Franklin Bache (Sally Franklin)",
        "artist": "John Hoppner",
        "role": "pintor",
        "date_created": "1793",
        "museum": "Metropolitan Museum of Art, Nova York",
        "formatted_description": "Retrato de Sarah Franklin Bache por John Hoppner (1793), líder patriota e filha devotada de Benjamin Franklin. Acervo: Metropolitan Museum of Art (Inv. 01.2).",
        "license": "Public domain",
        "source": "Metropolitan Museum of Art, New York"
    },

    # ==========================================
    # 5. FAMÍLIA DE ABRAHAM LINCOLN (4 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_lincoln_abraham"],
        "folder": imagens_base / "lincoln" / "Abraham_Lincoln",
        "file_name": "01_Abraham_Lincoln.jpg",
        "commons_file": "File:Abraham Lincoln head on shoulders photo portrait.jpg",
        "title": "Abraham Lincoln, 16º Presidente dos Estados Unidos",
        "artist": "Alexander Gardner",
        "role": "fotógrafo",
        "date_created": "8 de novembro de 1863",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Célebre retrato fotográfico de Abraham Lincoln realizado por Alexander Gardner onze dias antes do Discurso de Gettysburg. Acervo: Library of Congress (LC-DIG-ppmsca-19305).",
        "license": "Public domain",
        "source": "Library of Congress, Washington D.C."
    },
    {
        "pessoa_ids": ["pub_lincoln_mary_todd"],
        "folder": imagens_base / "lincoln" / "Mary_Todd_Lincoln",
        "file_name": "01_Mary_Todd_Lincoln.jpg",
        "commons_file": "File:Mary Todd Lincoln) - Brady LCCN2008680392.jpg",
        "title": "Mary Todd Lincoln em Traje de Gala na Casa Branca",
        "artist": "Mathew B. Brady",
        "role": "fotógrafo",
        "date_created": "1861",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato fotográfico de corpo inteiro da Primeira-Dama Mary Todd Lincoln pelo ateliê de Mathew Brady (1861). Acervo: Library of Congress (LC-DIG-cwpbh-03874).",
        "license": "Public domain",
        "source": "Library of Congress, Washington D.C."
    },
    {
        "pessoa_ids": ["pub_lincoln_robert_todd"],
        "folder": imagens_base / "lincoln" / "Robert_Todd_Lincoln",
        "file_name": "01_Robert_Todd_Lincoln.jpg",
        "commons_file": "File:Robert Todd Lincoln, Brady-Handy bw photo portrait, ca1870-1880-Edit1.jpg",
        "title": "Robert Todd Lincoln, Secretário da Guerra dos EUA",
        "artist": "Levin C. Handy / Brady-Handy Studio",
        "role": "fotógrafo",
        "date_created": "c. 1875",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato fotográfico de estúdio de Robert Todd Lincoln pela coleção Brady-Handy. Acervo: Library of Congress (LC-DIG-cwpbh-01314).",
        "license": "Public domain",
        "source": "Library of Congress, Washington D.C."
    },
    {
        "pessoa_ids": ["pub_lincoln_sarah_bush"],
        "folder": imagens_base / "lincoln" / "Sarah_Bush_Lincoln",
        "file_name": "01_Sarah_Bush_Lincoln.jpg",
        "commons_file": "File:Sarah Bush Johnston Lincoln.JPG",
        "title": "Sarah Bush Johnston Lincoln, Madrasta e Tutora de Lincoln",
        "artist": "Samuel G. Alschuler",
        "role": "fotógrafo",
        "date_created": "1865",
        "museum": "Illinois State Historical Library, Springfield",
        "formatted_description": "Raro retrato fotográfico de Sarah Bush Johnston Lincoln aos 77 anos por Samuel G. Alschuler (1865). Acervo: Illinois State Historical Library.",
        "license": "Public domain",
        "source": "Illinois State Historical Library, Springfield IL"
    },

    # ==========================================
    # 6. SIR WINSTON CHURCHILL (6 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_churchill_randolph"],
        "folder": imagens_base / "churchill" / "Lord_Randolph_Churchill",
        "file_name": "01_Lord_Randolph_Churchill.jpg",
        "commons_file": "File:Portrait of Lord Randolph Churchill.jpg",
        "title": "Lord Randolph Churchill, Chanceler do Tesouro",
        "artist": "Bassano Ltd",
        "role": "fotógrafo",
        "date_created": "c. 1886",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato fotográfico oficial de Lord Randolph Henry Spencer-Churchill por Bassano Ltd. Acervo: National Portrait Gallery, Londres (NPG x18105).",
        "license": "Public domain",
        "source": "National Portrait Gallery, London"
    },
    {
        "pessoa_ids": ["pub_churchill_jennie"],
        "folder": imagens_base / "churchill" / "Jennie_Jerome",
        "file_name": "01_Jennie_Jerome.jpg",
        "commons_file": "File:Lady Jennie Spencer-Churchill (1854-1921) (A).jpg",
        "title": "Jennie Jerome, Lady Randolph Churchill",
        "artist": "W. & D. Downey",
        "role": "fotógrafo",
        "date_created": "c. 1885",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato de estúdio da socialite e autora Jennie Jerome por W. & D. Downey em Londres. Acervo: National Portrait Gallery, Londres.",
        "license": "Public domain",
        "source": "National Portrait Gallery, London"
    },
    {
        "pessoa_ids": ["pub_churchill_winston"],
        "folder": imagens_base / "churchill" / "Winston_Churchill",
        "file_name": "01_Winston_Churchill.jpg",
        "commons_file": "File:Sir Winston Churchill - 19086236948.jpg",
        "title": "Sir Winston Churchill (The Roaring Lion)",
        "artist": "Yousuf Karsh",
        "role": "fotógrafo",
        "date_created": "30 de dezembro de 1941",
        "museum": "Library and Archives Canada / National Portrait Gallery, Londres",
        "formatted_description": "O icônico retrato 'The Roaring Lion' de Winston Churchill capturado por Yousuf Karsh no Parlamento de Ottawa após o histórico discurso de 1941. Acervo: Library and Archives Canada.",
        "license": "Public domain",
        "source": "Library and Archives Canada / Yousuf Karsh Estate"
    },
    {
        "pessoa_ids": ["pub_churchill_clementine"],
        "folder": imagens_base / "churchill" / "Clementine_Churchill",
        "file_name": "01_Clementine_Churchill.jpg",
        "commons_file": "File:Clementine Churchill 1915.jpg",
        "title": "Clementine Hozier Churchill, Baronesa Spencer-Churchill",
        "artist": "Bassano Ltd",
        "role": "fotógrafo",
        "date_created": "1915",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Retrato de estúdio de Clementine Churchill por Bassano Ltd em 1915. Acervo: National Portrait Gallery, Londres (NPG x18107).",
        "license": "Public domain",
        "source": "National Portrait Gallery, London"
    },
    {
        "pessoa_ids": ["pub_churchill_randolph_son"],
        "folder": imagens_base / "churchill" / "Randolph_Churchill_Son",
        "file_name": "01_Randolph_Churchill_Son.jpg",
        "commons_file": "File:Cecil Beaton Photographs- Political and Military Personalities; Churchill, Randolph Frederick Edward Spencer CBM1585.jpg",
        "title": "Major Randolph Churchill em Fardamento Militar",
        "artist": "Cecil Beaton",
        "role": "fotógrafo",
        "date_created": "c. 1942",
        "museum": "Imperial War Museum, Londres",
        "formatted_description": "Retrato de Randolph Churchill em uniforme de oficial britânico pelo célebre fotógrafo Cecil Beaton. Acervo: Imperial War Museum (CBM 1585).",
        "license": "Public domain",
        "source": "Imperial War Museum, London / Ministry of Information"
    },
    {
        "pessoa_ids": ["pub_churchill_mary"],
        "folder": imagens_base / "churchill" / "Mary_Churchill",
        "file_name": "01_Mary_Churchill.jpg",
        "commons_file": "File:Mary Soames (1965).jpg",
        "title": "Mary Churchill, Lady Soames",
        "artist": "Eric Koch / Anefo",
        "role": "fotógrafo",
        "date_created": "1965",
        "museum": "Nationaal Archief, Haia, Países Baixos",
        "formatted_description": "Retrato de Mary Churchill (Lady Soames) por Eric Koch / Anefo (1965). Acervo: Nationaal Archief (2.24.01.05 / 918-3810).",
        "license": "CC0 / Public domain",
        "source": "Nationaal Archief, Holanda"
    },

    # ==========================================
    # 7. FAMÍLIA DE MAHATMA GANDHI (5 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_gandhi_karamchand"],
        "folder": imagens_base / "gandhi" / "Karamchand_Gandhi",
        "file_name": "01_Karamchand_Gandhi.jpg",
        "commons_file": "File:Karamchand Gandhi.jpg",
        "title": "Karamchand Gandhi (Kaba Gandhi), Diwan de Porbandar e Rajkot",
        "artist": "Fotógrafo da Corte de Kathiawad",
        "role": "fotógrafo",
        "date_created": "c. 1880",
        "museum": "Kaba Gandhi No Delo / Sabarmati Ashram Archives",
        "formatted_description": "Histórico retrato fotográfico do Século XIX de Karamchand Gandhi, primeiro-ministro principesco e pai de Mahatma Gandhi. Acervo: Sabarmati Ashram.",
        "license": "Public domain",
        "source": "Sabarmati Ashram Preservation and Memorial Trust, Ahmedabad"
    },
    {
        "pessoa_ids": ["pub_gandhi_mohandas"],
        "folder": imagens_base / "gandhi" / "Mohandas_Gandhi",
        "file_name": "01_Mohandas_Gandhi.jpg",
        "commons_file": "File:Mahatma-Gandhi, studio, 1931.jpg",
        "title": "Mahatma Gandhi em Londres",
        "artist": "Elliott & Fry / Central Press Photos",
        "role": "fotógrafo",
        "date_created": "1931",
        "museum": "National Portrait Gallery, Londres / National Gandhi Museum, Nova Déli",
        "formatted_description": "Retrato fotográfico de estúdio de Mahatma Gandhi em Londres durante a Segunda Conferência da Mesa Redonda (1931). Acervo: National Gandhi Museum.",
        "license": "Public domain",
        "source": "Central Press / National Portrait Gallery"
    },
    {
        "pessoa_ids": ["pub_gandhi_kasturba"],
        "folder": imagens_base / "gandhi" / "Kasturba_Gandhi",
        "file_name": "01_Kasturba_Gandhi.jpg",
        "commons_file": "File:Kasturba Gandhi (2).jpg",
        "title": "Kasturba Gandhi (Ba)",
        "artist": "Ateliê Sabarmati / Arquivo Fotográfico Nacional",
        "role": "fotógrafo",
        "date_created": "c. 1930",
        "museum": "National Gandhi Museum, Nova Déli",
        "formatted_description": "Retrato solene de Kasturba Gandhi (1869–1944), líder ativista e esteio moral do movimento de libertação indiano. Acervo: National Gandhi Museum.",
        "license": "Public domain",
        "source": "National Gandhi Museum and Memorial Trust, New Delhi"
    },
    {
        "pessoa_ids": ["pub_gandhi_manilal"],
        "folder": imagens_base / "gandhi" / "Manilal_Gandhi",
        "file_name": "01_Manilal_Gandhi.jpg",
        "commons_file": "File:Manilal Gandhi, 1925 photo by Underwood & Underwood (cropped).jpg",
        "title": "Manilal Gandhi, Editor do Indian Opinion",
        "artist": "Underwood & Underwood",
        "role": "fotógrafo",
        "date_created": "1925",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato fotográfico de Manilal Gandhi por Underwood & Underwood (1925), líder comunitário na África do Sul. Acervo: Library of Congress (LC-USZ62-113220).",
        "license": "Public domain",
        "source": "Library of Congress, Washington D.C."
    },
    {
        "pessoa_ids": ["pub_gandhi_devdas"],
        "folder": imagens_base / "gandhi" / "Devdas_Gandhi",
        "file_name": "01_Devdas_Gandhi.jpg",
        "commons_file": "File:Devdas Gandhi at a dinner in honour of the Iranian Press Delegation during their visit to New Delhi.jpg",
        "title": "Devdas Gandhi, Editor-Chefe do Hindustan Times",
        "artist": "Photo Division, Ministry of Information & Broadcasting",
        "role": "fotógrafo",
        "date_created": "1952",
        "museum": "National Archives of India / Photo Division, New Delhi",
        "formatted_description": "Retrato fotográfico de Devdas Gandhi pela Photo Division da Índia (1952). Acervo: National Archives of India.",
        "license": "Public domain (Government of India)",
        "source": "Photo Division, Government of India"
    },

    # ==========================================
    # 8. FAMÍLIA DE NELSON MANDELA (4 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_mandela_nelson"],
        "folder": imagens_base / "mandela" / "Nelson_Mandela",
        "file_name": "01_Nelson_Mandela.jpg",
        "commons_file": "File:Nelson Mandela 1994.jpg",
        "title": "Nelson Mandela, Presidente da África do Sul",
        "artist": "South African Government Information Service (GCIS)",
        "role": "fotógrafo",
        "date_created": "1994",
        "museum": "Government Communication and Information System (GCIS), Pretória",
        "formatted_description": "Retrato presidencial oficial de Nelson Mandela em 1994, marcando a vitória contra o apartheid e a aurora da nova África do Sul democrática. Acervo: GCIS, Pretória.",
        "license": "Public domain / CC BY-SA (Government of South Africa)",
        "source": "South African Government Information Service (GCIS)"
    },
    {
        "pessoa_ids": ["pub_mandela_evelyn"],
        "folder": imagens_base / "mandela" / "Evelyn_Mase",
        "file_name": "01_Evelyn_Mase.jpg",
        "commons_file": "File:Mandela e Evelyn 1944.jpg",
        "title": "Evelyn Ntoko Mase Mandela",
        "artist": "Fotógrafo de Soweto / Acervo Familiar Mandela",
        "role": "fotógrafo",
        "date_created": "1944",
        "museum": "Nelson Mandela Foundation, Johanesburgo",
        "formatted_description": "Retrato de casamento de Evelyn Mase e Nelson Mandela (1944). Acervo: Nelson Mandela Foundation.",
        "license": "Public domain",
        "source": "Nelson Mandela Foundation / South African History Online"
    },
    {
        "pessoa_ids": ["pub_mandela_winnie"],
        "folder": imagens_base / "mandela" / "Winnie_Mandela",
        "file_name": "01_Winnie_Mandela.jpg",
        "commons_file": "File:Winnie Mandela 190814.jpg",
        "title": "Winnie Madikizela-Mandela, Mãe da Nação",
        "artist": "Arquivo Histórico Sul-Africano / Robben Island Museum",
        "role": "fotógrafo",
        "date_created": "c. 1986",
        "museum": "Robben Island Museum / South African History Online",
        "formatted_description": "Retrato de Winnie Madikizela-Mandela durante as mobilizações populares contra o regime segregacionista. Acervo: South African History Online.",
        "license": "Public domain",
        "source": "South African History Online (SAHO)"
    },
    {
        "pessoa_ids": ["pub_mandela_graca"],
        "folder": imagens_base / "mandela" / "Graca_Machel",
        "file_name": "01_Graca_Machel.jpg",
        "commons_file": "File:Graca Machel, World Economic Forum on Africa 2010.jpg",
        "title": "Graça Machel, Humanitária e Jurista",
        "artist": "World Economic Forum / Eric Miller",
        "role": "fotógrafo",
        "date_created": "2010",
        "museum": "World Economic Forum Archives",
        "formatted_description": "Retrato fotográfico de Graça Machel por Eric Miller no World Economic Forum on Africa (2010). Acervo: World Economic Forum.",
        "license": "Creative Commons Attribution-Share Alike 2.0 Generic",
        "source": "World Economic Forum (swiss-image.ch)"
    },

    # ==========================================
    # 9. FAMÍLIA DE MARTIN LUTHER KING JR. (6 obras)
    # ==========================================
    {
        "pessoa_ids": ["pub_mlk_martin_sr"],
        "folder": imagens_base / "mlk" / "Martin_Luther_King_Sr",
        "file_name": "01_Martin_Luther_King_Sr.jpg",
        "commons_file": "File:Martin Luther King Sr, c1977-81.jpg",
        "title": "Rev. Martin Luther King Sr. (Daddy King)",
        "artist": "Jimmy Carter Presidential Library and Museum",
        "role": "fotógrafo",
        "date_created": "c. 1978",
        "museum": "Jimmy Carter Presidential Library and Museum, Atlanta",
        "formatted_description": "Retrato oficial do Rev. Martin Luther King Sr. pelo fotógrafo da Casa Branca durante a administração Carter. Acervo: Jimmy Carter Presidential Library (NLJC-WHPO-A6305).",
        "license": "Public domain",
        "source": "Jimmy Carter Presidential Library, National Archives and Records Administration (NARA)"
    },
    {
        "pessoa_ids": ["pub_mlk_alberta"],
        "folder": imagens_base / "mlk" / "Alberta_Williams_King",
        "file_name": "01_Alberta_Williams_King.jpg",
        "commons_file": "File:Martin Luther King, Henry Elkins, and Alberta Williams King at Ebenezer, 1962 (cropped).png",
        "title": "Alberta Williams King na Igreja Batista Ebenezer",
        "artist": "Donald L. Hollowell Collection / Atlanta History Center",
        "role": "fotógrafo",
        "date_created": "1962",
        "museum": "Ebenezer Baptist Church Archives / Library of Congress",
        "formatted_description": "Retrato de Alberta Williams King, diretora musical da histórica Igreja Batista Ebenezer e mãe de MLK Jr. (1962). Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Ebenezer Baptist Church / Library of Congress"
    },
    {
        "pessoa_ids": ["pub_mlk_martin"],
        "folder": imagens_base / "mlk" / "Martin_Luther_King_Jr",
        "file_name": "01_Martin_Luther_King_Jr.jpg",
        "commons_file": "File:Martin Luther King press conference 01269u edit.jpg",
        "title": "Dr. Martin Luther King Jr. em Washington D.C.",
        "artist": "Marion S. Trikosko",
        "role": "fotógrafo",
        "date_created": "26 de março de 1964",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato magistral de Martin Luther King Jr. por Marion S. Trikosko em Washington D.C. após encontro histórico no Capitólio sobre a Lei dos Direitos Civis. Acervo: Library of Congress (LC-DIG-ppmsc-01269).",
        "license": "Public domain",
        "source": "Library of Congress, Prints and Photographs Division (U.S. News & World Report Collection)"
    },
    {
        "pessoa_ids": ["pub_mlk_coretta"],
        "folder": imagens_base / "mlk" / "Coretta_Scott_King",
        "file_name": "01_Coretta_Scott_King.jpg",
        "commons_file": "File:Coretta Scott King 1964.jpg",
        "title": "Coretta Scott King, Líder dos Direitos Civis",
        "artist": "Marion S. Trikosko / Warren K. Leffler",
        "role": "fotógrafo",
        "date_created": "1964",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato fotográfico de Coretta Scott King em 1964 pela equipe da Library of Congress (LC-DIG-ppmsc-01270). Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress, Prints and Photographs Division"
    },
    {
        "pessoa_ids": ["pub_mlk_martin3"],
        "folder": imagens_base / "mlk" / "Martin_Luther_King_III",
        "file_name": "01_Martin_Luther_King_III.jpg",
        "commons_file": "File:Martin Luther King III at the unveiling of The Embrace 52625621619 o (1).jpg",
        "title": "Martin Luther King III, Defensor dos Direitos Humanos",
        "artist": "Paul Rutherford / City of Boston",
        "role": "fotógrafo",
        "date_created": "2023",
        "museum": "King Center Archives / City of Boston Records",
        "formatted_description": "Fotografia documental de Martin Luther King III durante homenagem pública aos pais em Boston (2023). Acervo: City of Boston.",
        "license": "Creative Commons Attribution 2.0 Generic",
        "source": "Mayor's Office, City of Boston"
    },
    {
        "pessoa_ids": ["pub_mlk_bernice"],
        "folder": imagens_base / "mlk" / "Bernice_King",
        "file_name": "01_Bernice_King.jpg",
        "commons_file": "File:Bernice King at LBJ Presidential Library and Mueseum, 2014.png",
        "title": "Rev. Bernice Albertine King, CEO do The King Center",
        "artist": "Lauren Gerson / LBJ Presidential Library",
        "role": "fotógrafo",
        "date_created": "2014",
        "museum": "Lyndon Baines Johnson Presidential Library, Austin TX",
        "formatted_description": "Retrato de Bernice Albertine King na Cúpula dos Direitos Civis na Biblioteca Presidencial Lyndon B. Johnson (2014). Acervo: LBJ Presidential Library.",
        "license": "Public domain (U.S. Federal Government)",
        "source": "Lyndon Baines Johnson Presidential Library and Museum"
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
    """
    Garante que a imagem está em formato padrão (.jpg ou .png),
    redimensionando se for gigantesca (ex: 235MB de Washington) para no máximo 1920px,
    mantendo resolução e nitidez cristalinas para a interface.
    Converte TIFF para JPEG de alta qualidade (95%).
    """
    im = Image.open(BytesIO(bytes_orig))
    formato_orig = im.format.upper() if im.format else "JPEG"

    # Redimensiona se for maior que max_side
    w, h = im.size
    if max(w, h) > max_side:
        im.thumbnail((max_side, max_side), Image.Resampling.LANCZOS)

    # Se for TIFF ou se for PNG muito pesado (> 5MB), converte para JPEG 95%
    if formato_orig in ("TIFF", "TIF") or (formato_orig == "PNG" and len(bytes_orig) > 5 * 1024 * 1024):
        if im.mode not in ("RGB", "L"):
            im = im.convert("RGB")
        out_buf = BytesIO()
        im.save(out_buf, format="JPEG", quality=95, optimize=True)
        return out_buf.getvalue(), ".jpg"

    # Se for PNG mantemos PNG (se não for excessivamente gigante)
    if formato_orig == "PNG":
        out_buf = BytesIO()
        im.save(out_buf, format="PNG", optimize=True)
        return out_buf.getvalue(), ".png"

    # JPEG padrão
    if im.mode not in ("RGB", "L"):
        im = im.convert("RGB")
    out_buf = BytesIO()
    im.save(out_buf, format="JPEG", quality=95, optimize=True)
    return out_buf.getvalue(), ".jpg"


def executar_curadoria():
    print("=" * 75)
    print("ELO TEMPO: CURADORIA BATCH 15 - GRANDES LIDERANÇAS MUNDIAIS & FUNDADORES")
    print("=" * 75)
    print(f"Total de obras a processar: {len(OBRAS_BATCH15)}")
    print(f"Banco de dados: {db_path}")
    print(f"Pasta de Mídia: {midia_dir}")
    print(f"Base de Imagens: {imagens_base}\n")

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_sucesso = 0
    total_vinculos = 0

    for i, item in enumerate(OBRAS_BATCH15, 1):
        print(f"\n[{i:02d}/{len(OBRAS_BATCH15):02d}] {item['title']}")
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
                    
                    # Otimização inteligente
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

        # 1. Salva metadados Schema 4.0
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
    print("CURADORIA BATCH 15 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {total_sucesso}/{len(OBRAS_BATCH15)}")
    print(f"Total de pessoas vinculadas com fotos atualizadas: {total_vinculos}")
    print("=" * 75)


if __name__ == "__main__":
    executar_curadoria()
