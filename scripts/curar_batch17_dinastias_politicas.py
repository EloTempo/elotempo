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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; political dynasties; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo" / "politicas"

pasta_kennedy = imagens_base / "kennedy"
pasta_roosevelt = imagens_base / "roosevelt"
pasta_bush = imagens_base / "bush"
pasta_peron = imagens_base / "peron"

OBRAS_BATCH17 = [
    # -------------------------------------------------------------
    # 1. Família Kennedy (18 obras)
    # -------------------------------------------------------------
    {
        "folder": pasta_kennedy,
        "file_name": "01_John_F_Kennedy.jpg",
        "title": "John F. Kennedy (35º Presidente dos Estados Unidos)",
        "artist": "Fotógrafo Oficial da Casa Branca",
        "role": "Fotografia Oficial",
        "date_created": "1961",
        "museum": "John F. Kennedy Presidential Library and Museum, Boston",
        "formatted_description": "Retrato oficial a cores do 35º Presidente dos Estados Unidos, John Fitzgerald Kennedy.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "John F. Kennedy Presidential Library / Wikimedia Commons",
        "commons_file": "File:John F Kennedy Official Portrait.jpg",
        "pessoa_ids": ["pub_kennedy_john_f_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Jacqueline_Kennedy_Onassis.jpg",
        "title": "Jacqueline Bouvier Kennedy na Casa Branca",
        "artist": "Cecil Stoughton",
        "role": "Fotografia Oficial",
        "date_created": "1961",
        "museum": "John F. Kennedy Presidential Library and Museum, Boston",
        "formatted_description": "Retrato oficial a cores da Primeira-Dama Jacqueline Bouvier Kennedy no Salão Amarelo da Casa Branca.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "John F. Kennedy Presidential Library / Wikimedia Commons",
        "commons_file": "File:Jackie Kennedy Color Portrait (4x5 cropped).jpg",
        "pessoa_ids": ["pub_kennedy_jacqueline_kennedy_onassis"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Robert_F_Kennedy.jpg",
        "title": "Robert F. Kennedy, Procurador-Geral dos Estados Unidos",
        "artist": "Fotógrafo Oficial do Departamento de Justiça",
        "role": "Fotografia Oficial",
        "date_created": "1963",
        "museum": "Department of Justice / John F. Kennedy Presidential Library",
        "formatted_description": "Retrato oficial de Robert Francis 'Bobby' Kennedy como 64º Procurador-Geral dos Estados Unidos.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "U.S. Department of Justice / Wikimedia Commons",
        "commons_file": "File:Robert Kennedy 1963.jpg",
        "pessoa_ids": ["pub_kennedy_robert_f_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Edward_Ted_Kennedy.jpg",
        "title": "Edward M. 'Ted' Kennedy no Senado dos Estados Unidos",
        "artist": "Fotógrafo Oficial do Senado dos EUA",
        "role": "Fotografia Oficial",
        "date_created": "c. 1970",
        "museum": "United States Senate Historical Office / Library of Congress",
        "formatted_description": "Retrato oficial do Senador por Massachusetts Edward Moore 'Ted' Kennedy, o Leão do Senado.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "U.S. Senate Historical Office / Wikimedia Commons",
        "commons_file": "File:Ted Kennedy, official photo portrait crop.jpg",
        "pessoa_ids": ["pub_kennedy_edward_m_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Joseph_P_Kennedy_Sr.jpg",
        "title": "Joseph P. Kennedy Sr., Embaixador no Reino Unido",
        "artist": "Harris & Ewing",
        "role": "Fotografia Histórica",
        "date_created": "1938",
        "museum": "Library of Congress, Washington, D.C.",
        "formatted_description": "Retrato oficial do patriarca Joseph Patrick Kennedy Sr. como Embaixador dos Estados Unidos na Corte de St. James.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Joseph P. Kennedy, Sr. 1938.jpg",
        "pessoa_ids": ["pub_kennedy_joseph_p_kennedy_sr"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Rose_Fitzgerald_Kennedy.jpg",
        "title": "Rose Fitzgerald Kennedy",
        "artist": "Fotógrafo de imprensa norte-americano",
        "role": "Fotografia Histórica",
        "date_created": "1967",
        "museum": "John F. Kennedy Presidential Library, Boston",
        "formatted_description": "Retrato da matriarca do clã Kennedy, Condessa Papal Rose Elizabeth Fitzgerald Kennedy.",
        "license": "Domínio Público",
        "source": "John F. Kennedy Presidential Library / Wikimedia Commons",
        "commons_file": "File:Rose Kennedy 1967.JPG",
        "pessoa_ids": ["pub_kennedy_rose_fitzgerald_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Joseph_P_Kennedy_Jr.jpg",
        "title": "Tenente Joseph P. Kennedy Jr., US Navy",
        "artist": "Marinha dos Estados Unidos (US Navy)",
        "role": "Fotografia Militar Oficial",
        "date_created": "c. 1943",
        "museum": "National Archives and Records Administration / JFK Library",
        "formatted_description": "Retrato militar em uniforme naval do aviador Tenente Joseph Patrick Kennedy Jr., condecorado com a Cruz da Marinha.",
        "license": "Domínio Público (US Navy)",
        "source": "National Archives and Records Administration / Wikimedia Commons",
        "commons_file": "File:Lt. Joseph P. Kennedy, Jr. Navy.JPG",
        "pessoa_ids": ["pub_kennedy_joseph_p_kennedy_jr"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Eunice_Kennedy_Shriver.jpg",
        "title": "Eunice Kennedy Shriver, Fundadora das Special Olympics",
        "artist": "Fotógrafo Oficial da Casa Branca",
        "role": "Fotografia Oficial",
        "date_created": "1982",
        "museum": "Ronald Reagan Presidential Library / National Archives",
        "formatted_description": "Retrato de Eunice Mary Kennedy Shriver, pioneira global na defesa dos direitos e inclusão de pessoas com deficiência intelectual.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "Ronald Reagan Presidential Library / Wikimedia Commons",
        "commons_file": "File:Eunice Shriver - 1982 (cropped).jpg",
        "pessoa_ids": ["pub_kennedy_eunice_kennedy_shriver"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Sargent_Shriver.jpg",
        "title": "R. Sargent Shriver, Diretor do Peace Corps",
        "artist": "Fotógrafo Oficial do Peace Corps",
        "role": "Fotografia Oficial",
        "date_created": "1961",
        "museum": "Peace Corps / National Archives and Records Administration",
        "formatted_description": "Retrato oficial de Robert Sargent Shriver Jr., diplomata, idealizador do Head Start e primeiro diretor do Peace Corps.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "Peace Corps / Wikimedia Commons",
        "commons_file": "File:Sargent Shriver 1961.jpg",
        "pessoa_ids": ["pub_kennedy_sargent_shriver"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Caroline_Kennedy.jpg",
        "title": "Caroline Kennedy, Embaixadora dos Estados Unidos",
        "artist": "Departamento de Estado dos EUA",
        "role": "Fotografia Oficial Diplomática",
        "date_created": "2013",
        "museum": "U.S. Department of State",
        "formatted_description": "Retrato oficial de Caroline Bouvier Kennedy como Embaixadora dos Estados Unidos no Japão.",
        "license": "Domínio Público (Departamento de Estado dos EUA)",
        "source": "U.S. Department of State / Wikimedia Commons",
        "commons_file": "File:Caroline Kennedy, U.S. Ambassador.jpg",
        "pessoa_ids": ["pub_kennedy_caroline_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_John_F_Kennedy_Jr.jpg",
        "title": "John F. Kennedy Jr.",
        "artist": "Alan Light",
        "role": "Fotografia",
        "date_created": "1999",
        "museum": "Acervo Alan Light / Wikimedia Commons",
        "formatted_description": "Retrato do advogado e jornalista John Fitzgerald Kennedy Jr., fundador da inovadora revista política George.",
        "license": "Creative Commons Attribution 2.0 Generic",
        "source": "Wikimedia Commons / Alan Light",
        "commons_file": "File:John Kennedy Jr 1999.jpg",
        "pessoa_ids": ["pub_kennedy_john_f_kennedy_jr"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_John_Francis_Fitzgerald.jpg",
        "title": "John F. 'Honey Fitz' Fitzgerald, Prefeito de Boston",
        "artist": "Theodore C. Marceau",
        "role": "Fotografia de Estúdio",
        "date_created": "c. 1910",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato formal de John Francis 'Honey Fitz' Fitzgerald, lendário prefeito de Boston, congressista e avô de JFK.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:John F. Fitzgerald, mayor of Boston, three-quarter length portrait, seated, facing right) - Theo. C. Marceau, N.Y LCCN89709225.jpg",
        "pessoa_ids": ["pub_kennedy_john_francis_fitzgerald"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Patrick_Joseph_Kennedy.png",
        "title": "P. J. Kennedy, Senador Estadual de Massachusetts",
        "artist": "Fotógrafo de Boston",
        "role": "Retrato Histórico",
        "date_created": "1903",
        "museum": "State Library of Massachusetts / Boston Public Library",
        "formatted_description": "Retrato do líder político comunitário e senador estadual Patrick Joseph 'P. J.' Kennedy.",
        "license": "Domínio Público",
        "source": "State Library of Massachusetts / Wikimedia Commons",
        "commons_file": "File:Patrick J. Kennedy 1903.png",
        "pessoa_ids": ["pub_kennedy_patrick_joseph_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Kathleen_Kick_Kennedy.jpg",
        "title": "Kathleen 'Kick' Kennedy, Marquesa de Hartington",
        "artist": "Fotógrafo da Corte Britânica",
        "role": "Fotografia Histórica",
        "date_created": "c. 1944",
        "museum": "Chatsworth House / Devonshire Collection",
        "formatted_description": "Retrato formal de Kathleen Agnes 'Kick' Kennedy, voluntária da Cruz Vermelha e Marquesa de Hartington.",
        "license": "Domínio Público",
        "source": "Devonshire Collection / Wikimedia Commons",
        "commons_file": "File:Lady Hartington.jpg",
        "pessoa_ids": ["pub_kennedy_kathleen_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Ethel_Skakel_Kennedy.jpg",
        "title": "Ethel Skakel Kennedy",
        "artist": "Warren K. Leffler",
        "role": "Fotografia de Imprensa",
        "date_created": "1967",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato de Ethel Skakel Kennedy, ativista de direitos humanos e fundadora do RFK Center for Justice and Human Rights.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Ethel Kennedy 1.jpg",
        "pessoa_ids": ["pub_kennedy_ethel_skakel_kennedy"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Robert_F_Kennedy_Jr.jpg",
        "title": "Robert F. Kennedy Jr.",
        "artist": "Fotógrafo Oficial do Governo dos EUA",
        "role": "Fotografia Oficial",
        "date_created": "2025",
        "museum": "Department of Health and Human Services / National Archives",
        "formatted_description": "Retrato oficial de Robert Francis Kennedy Jr.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "Department of Health and Human Services / Wikimedia Commons",
        "commons_file": "File:Robert F. Kennedy Jr., official portrait (2025) (cropped 3-4).jpg",
        "pessoa_ids": ["pub_kennedy_robert_f_kennedy_jr"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Maria_Shriver.jpg",
        "title": "Maria Shriver",
        "artist": "Gage Skidmore",
        "role": "Fotografia",
        "date_created": "2019",
        "museum": "Acervo Gage Skidmore / Wikimedia Commons",
        "formatted_description": "Retrato da jornalista premiada com o Peabody e ex-Primeira-Dama da Califórnia Maria Owings Shriver.",
        "license": "Creative Commons Attribution-Share Alike 3.0 Unported",
        "source": "Wikimedia Commons / Gage Skidmore",
        "commons_file": "File:Maria Shriver by Gage Skidmore.jpg",
        "pessoa_ids": ["pub_kennedy_maria_shriver"]
    },
    {
        "folder": pasta_kennedy,
        "file_name": "01_Patrick_J_Kennedy.jpg",
        "title": "Patrick J. Kennedy, Congressista por Rhode Island",
        "artist": "Câmara dos Representantes dos EUA",
        "role": "Fotografia Oficial do Congresso",
        "date_created": "c. 2005",
        "museum": "U.S. House of Representatives Historical Office",
        "formatted_description": "Retrato oficial de Patrick Joseph Kennedy II como membro da Câmara dos Representantes dos Estados Unidos.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "U.S. House of Representatives / Wikimedia Commons",
        "commons_file": "File:PatrickKennedy.JPG",
        "pessoa_ids": ["pub_kennedy_patrick_j_kennedy"]
    },

    # -------------------------------------------------------------
    # 2. Dinastia Roosevelt (15 obras)
    # -------------------------------------------------------------
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Theodore_Roosevelt.jpg",
        "title": "Theodore Roosevelt (26º Presidente dos Estados Unidos)",
        "artist": "Pach Brothers",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "1904",
        "museum": "Library of Congress / National Portrait Gallery",
        "formatted_description": "O célebre retrato de Theodore Roosevelt em pose firme e determinada pelos irmãos Pach em 1904.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Theodore Roosevelt by the Pach Bros.jpg",
        "pessoa_ids": ["pub_roosevelt_theodore_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Edith_Kermit_Carow_Roosevelt.jpg",
        "title": "Edith Kermit Carow Roosevelt",
        "artist": "Theobald Chartran",
        "role": "Pintura Oficial a Óleo",
        "date_created": "1902",
        "museum": "White House Historical Association, Washington, D.C.",
        "formatted_description": "Pintura oficial a óleo da Primeira-Dama Edith Kermit Carow Roosevelt nos jardins da Casa Branca.",
        "license": "Domínio Público",
        "source": "White House Historical Association / Wikimedia Commons",
        "commons_file": "File:Edith Roosevelt Official Portrait.jpg",
        "pessoa_ids": ["pub_roosevelt_edith_kermit_carow_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Franklin_Delano_Roosevelt.jpg",
        "title": "Franklin Delano Roosevelt (32º Presidente dos Estados Unidos)",
        "artist": "Vincenzo Laviosa",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "1933",
        "museum": "Franklin D. Roosevelt Presidential Library and Museum, Hyde Park",
        "formatted_description": "Retrato oficial do Presidente Franklin Delano Roosevelt no início de seu mandato histórico em 1933.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "Franklin D. Roosevelt Presidential Library / Wikimedia Commons",
        "commons_file": "File:FDR in 1933.jpg",
        "pessoa_ids": ["pub_roosevelt_franklin_d_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Anna_Eleanor_Roosevelt.jpg",
        "title": "Anna Eleanor Roosevelt",
        "artist": "Fotógrafo Oficial da Casa Branca",
        "role": "Fotografia Oficial",
        "date_created": "1933",
        "museum": "Franklin D. Roosevelt Presidential Library, Hyde Park",
        "formatted_description": "Retrato oficial de Anna Eleanor Roosevelt, diplomata, ativista humanitária e Primeira-Dama dos Estados Unidos.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "Franklin D. Roosevelt Presidential Library / Wikimedia Commons",
        "commons_file": "File:Eleanor Roosevelt portrait 1933.jpg",
        "pessoa_ids": ["pub_roosevelt_eleanor_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Alice_Roosevelt_Longworth.jpg",
        "title": "Alice Roosevelt Longworth",
        "artist": "Frances Benjamin Johnston",
        "role": "Fotografia de Estúdio",
        "date_created": "c. 1903",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato elegante de Alice Roosevelt Longworth, a célebre 'Princesa Alice', por Frances Benjamin Johnston.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Alice Roosevelt Longworth, three-quarter length portrait, seated, facing slightly left LCCN92522324.jpg",
        "pessoa_ids": ["pub_roosevelt_alice_roosevelt_longworth"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Theodore_Roosevelt_Jr.jpg",
        "title": "General Theodore Roosevelt Jr.",
        "artist": "Exército dos Estados Unidos (U.S. Army)",
        "role": "Fotografia Militar Oficial",
        "date_created": "c. 1944",
        "museum": "National Archives and Records Administration",
        "formatted_description": "Retrato em uniforme militar do General de Brigada Theodore Roosevelt Jr., herói do Dia D na Normandia.",
        "license": "Domínio Público (U.S. Army)",
        "source": "National Archives and Records Administration / Wikimedia Commons",
        "commons_file": "File:Theodore Roosevelt, Jr. (1887-1944) (3463996377).jpg",
        "pessoa_ids": ["pub_roosevelt_theodore_roosevelt_jr"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Kermit_Roosevelt.jpg",
        "title": "Kermit Roosevelt, Explorador e Militar",
        "artist": "Bain News Service",
        "role": "Fotografia Histórica",
        "date_created": "1926",
        "museum": "Library of Congress, George Grantham Bain Collection",
        "formatted_description": "Retrato do explorador, autor e veterano militar Kermit Roosevelt, participante da Expedição Roosevelt-Rondon.",
        "license": "Domínio Público (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Kermit Roosevelt 1926.jpg",
        "pessoa_ids": ["pub_roosevelt_kermit_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Quentin_Roosevelt.jpg",
        "title": "Tenente Quentin Roosevelt na França",
        "artist": "U.S. Army Air Service",
        "role": "Fotografia Militar Histórica",
        "date_created": "1918",
        "museum": "National Archives and Records Administration",
        "formatted_description": "Retrato do Tenente aviador Quentin Roosevelt em sua aeronave Nieuport durante a Primeira Guerra Mundial.",
        "license": "Domínio Público (U.S. Army)",
        "source": "National Archives and Records Administration / Wikimedia Commons",
        "commons_file": "File:Quentin Roosevelt in Nieuport trainer.jpg",
        "pessoa_ids": ["pub_roosevelt_quentin_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Sara_Delano_Roosevelt.jpg",
        "title": "Sara Ann Delano Roosevelt",
        "artist": "Fotógrafo de Nova York",
        "role": "Retrato de Família",
        "date_created": "c. 1900",
        "museum": "Franklin D. Roosevelt Presidential Library, Hyde Park",
        "formatted_description": "Retrato da matriarca de Hyde Park Sara Ann Delano Roosevelt, mãe devota de Franklin D. Roosevelt.",
        "license": "Domínio Público",
        "source": "Franklin D. Roosevelt Presidential Library / Wikimedia Commons",
        "commons_file": "File:Sara Delano (1854-1941) portrait.jpg",
        "pessoa_ids": ["pub_roosevelt_sara_delano_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Theodore_Roosevelt_Sr.jpg",
        "title": "Theodore Roosevelt Sr., Filantropo de Nova York",
        "artist": "Fotógrafo de estúdio",
        "role": "Fotografia Histórica",
        "date_created": "c. 1870",
        "museum": "National Park Service / Sagamore Hill National Historic Site",
        "formatted_description": "Retrato formal do empresário e filantropo Theodore Roosevelt Sr., cofundador do Museu Americano de História Natural.",
        "license": "Domínio Público (NPS)",
        "source": "National Park Service / Wikimedia Commons",
        "commons_file": "File:Portrait of Theodore Roosevelt, Sr. (e4ca9c8c-5023-4449-af2b-db44da700528).jpg",
        "pessoa_ids": ["pub_roosevelt_theodore_roosevelt_sr"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Martha_Bulloch_Roosevelt.jpg",
        "title": "Martha 'Mittie' Bulloch Roosevelt",
        "artist": "Fotógrafo de estúdio",
        "role": "Fotografia Histórica",
        "date_created": "c. 1860",
        "museum": "National Park Service / Theodore Roosevelt Birthplace NHS",
        "formatted_description": "Retrato de estúdio da socialite georgiana Martha 'Mittie' Bulloch, mãe de Theodore Roosevelt.",
        "license": "Domínio Público (NPS)",
        "source": "National Park Service / Wikimedia Commons",
        "commons_file": "File:Martha Bulloch, studio portrait.jpg",
        "pessoa_ids": ["pub_roosevelt_martha_bulloch_roosevelt"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Alice_Hathaway_Lee_Roosevelt.jpg",
        "title": "Alice Hathaway Lee Roosevelt",
        "artist": "Fotógrafo de Boston",
        "role": "Fotografia Histórica",
        "date_created": "c. 1880",
        "museum": "Harvard University Archives / Sagamore Hill NHS",
        "formatted_description": "Retrato da jovem Alice Hathaway Lee Roosevelt em sua juventude em Boston.",
        "license": "Domínio Público",
        "source": "Harvard University Archives / Wikimedia Commons",
        "commons_file": "File:Alice Hathaway Roosevelt 1.jpg",
        "pessoa_ids": ["pub_roosevelt_alice_lee"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Anna_Rebecca_Hall_Roosevelt.jpg",
        "title": "Anna Rebecca Hall Roosevelt",
        "artist": "Fotógrafo de Nova York",
        "role": "Fotografia Histórica",
        "date_created": "c. 1885",
        "museum": "Franklin D. Roosevelt Presidential Library, Hyde Park",
        "formatted_description": "Retrato de Anna Rebecca Hall Roosevelt, socialite nova-iorquina e mãe de Eleanor Roosevelt.",
        "license": "Domínio Público",
        "source": "Franklin D. Roosevelt Presidential Library / Wikimedia Commons",
        "commons_file": "File:Anna Rebecca Hall.jpg",
        "pessoa_ids": ["pub_roosevelt_anna_hall"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_Franklin_D_Roosevelt_Jr.jpg",
        "title": "Franklin D. Roosevelt Jr., Congressista por Nova York",
        "artist": "U.S. House of Representatives",
        "role": "Fotografia Oficial do Congresso",
        "date_created": "c. 1950",
        "museum": "U.S. House of Representatives Historical Office",
        "formatted_description": "Retrato oficial de Franklin Delano Roosevelt Jr. como membro da Câmara dos Representantes dos Estados Unidos.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "U.S. House of Representatives / Wikimedia Commons",
        "commons_file": "File:Franklin D. Roosevelt Jr. (US Congressman from New York).jpg",
        "pessoa_ids": ["pub_roosevelt_franklin_d_roosevelt_jr"]
    },
    {
        "folder": pasta_roosevelt,
        "file_name": "01_James_Roosevelt_II.jpg",
        "title": "Coronel James Roosevelt, USMC",
        "artist": "Corpo de Fuzileiros Navais dos EUA (USMC)",
        "role": "Fotografia Militar Oficial",
        "date_created": "c. 1944",
        "museum": "Franklin D. Roosevelt Presidential Library / USMC Archives",
        "formatted_description": "Retrato militar em uniforme naval do oficial dos fuzileiros navais James Roosevelt, condecorado com a Navy Cross.",
        "license": "Domínio Público (USMC)",
        "source": "Franklin D. Roosevelt Presidential Library / Wikimedia Commons",
        "commons_file": "File:James Roosevelt.jpg",
        "pessoa_ids": ["pub_roosevelt_james_roosevelt_ii"]
    },

    # -------------------------------------------------------------
    # 3. Dinastia Bush (10 obras)
    # -------------------------------------------------------------
    {
        "folder": pasta_bush,
        "file_name": "01_George_H_W_Bush.jpg",
        "title": "George H. W. Bush (41º Presidente dos Estados Unidos)",
        "artist": "David Valdez / Casa Branca",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "1992",
        "museum": "George H. W. Bush Presidential Library, College Station",
        "formatted_description": "Retrato oficial a cores do Presidente George Herbert Walker Bush na Casa Branca em janeiro de 1992.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "George H. W. Bush Presidential Library / Wikimedia Commons",
        "commons_file": "File:Official portrait of President George H W Bush January 1992.jpg",
        "pessoa_ids": ["pub_bush_george_h_w_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Barbara_Bush.jpg",
        "title": "Barbara Pierce Bush na Casa Branca",
        "artist": "David Valdez / Casa Branca",
        "role": "Fotografia Oficial",
        "date_created": "1992",
        "museum": "George H. W. Bush Presidential Library, College Station",
        "formatted_description": "Retrato oficial da Primeira-Dama Barbara Pierce Bush em traje formal azul na Casa Branca.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "George H. W. Bush Presidential Library / Wikimedia Commons",
        "commons_file": "File:Barbara Bush, official portrait (1992).jpg",
        "pessoa_ids": ["pub_bush_barbara_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_George_W_Bush.png",
        "title": "George W. Bush (43º Presidente dos Estados Unidos)",
        "artist": "Eric Draper / Casa Branca",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "2003",
        "museum": "George W. Bush Presidential Library, Dallas",
        "formatted_description": "Retrato oficial do Presidente George Walker Bush no Salão Oval da Casa Branca.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "George W. Bush Presidential Library / Wikimedia Commons",
        "commons_file": "File:George W. Bush 2003 (4x5).png",
        "pessoa_ids": ["pub_bush_george_w_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Laura_Bush.jpg",
        "title": "Laura Welch Bush",
        "artist": "Krisanne Johnson / Casa Branca",
        "role": "Fotografia Oficial",
        "date_created": "2005",
        "museum": "George W. Bush Presidential Library, Dallas",
        "formatted_description": "Retrato oficial da Primeira-Dama Laura Welch Bush na Sala Amarela da Casa Branca.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "George W. Bush Presidential Library / Wikimedia Commons",
        "commons_file": "File:Laura Bush portrait.jpg",
        "pessoa_ids": ["pub_bush_laura_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Prescott_Bush.jpg",
        "title": "Prescott Bush, Senador por Connecticut",
        "artist": "Fotógrafo Oficial do Senado dos EUA",
        "role": "Fotografia Oficial",
        "date_created": "c. 1953",
        "museum": "United States Senate Historical Office / Library of Congress",
        "formatted_description": "Retrato oficial do Senador norte-americano por Connecticut e banqueiro Prescott Sheldon Bush.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "U.S. Senate Historical Office / Wikimedia Commons",
        "commons_file": "File:PrescottBush.jpg",
        "pessoa_ids": ["pub_bush_prescott_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Jeb_Bush.jpg",
        "title": "Jeb Bush, 43º Governador da Flórida",
        "artist": "Florida State Archives",
        "role": "Fotografia Oficial Governamental",
        "date_created": "1998",
        "museum": "Florida Memory Project / State Archives of Florida",
        "formatted_description": "Retrato oficial a cores de John Ellis 'Jeb' Bush por ocasião de sua eleição como Governador da Flórida.",
        "license": "Domínio Público (State Archives of Florida)",
        "source": "State Archives of Florida / Wikimedia Commons",
        "commons_file": "File:Color Portrait of Florida Governor-elect Jeb Bush.jpg",
        "pessoa_ids": ["pub_bush_jeb_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Columba_Bush.jpg",
        "title": "Columba Garnica Gallo Bush",
        "artist": "Florida Governor's Office",
        "role": "Fotografia Oficial",
        "date_created": "c. 2002",
        "museum": "State Archives of Florida",
        "formatted_description": "Retrato oficial de Columba Garnica Gallo Bush como Primeira-Dama do Estado da Flórida.",
        "license": "Domínio Público (State of Florida)",
        "source": "State Archives of Florida / Wikimedia Commons",
        "commons_file": "File:Columba Bush (1).jpg",
        "pessoa_ids": ["pub_bush_columba"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_George_P_Bush.jpg",
        "title": "George P. Bush",
        "artist": "George H. W. Bush Presidential Library",
        "role": "Fotografia de Família Oficial",
        "date_created": "1992",
        "museum": "National Archives and Records Administration",
        "formatted_description": "Retrato jovem de George Prescott Bush, futuro Comissário de Terras do Estado do Texas.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "George H. W. Bush Presidential Library / Wikimedia Commons",
        "commons_file": "File:George P. Bush in 19992 (186455).jpg",
        "pessoa_ids": ["pub_bush_george_p_bush"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Jenna_Bush_Hager.jpg",
        "title": "Jenna Bush na Casa Branca",
        "artist": "White House Photo Office",
        "role": "Fotografia Oficial",
        "date_created": "2004",
        "museum": "George W. Bush Presidential Library, Dallas",
        "formatted_description": "Retrato oficial de Jenna Welch Bush na Casa Branca.",
        "license": "Domínio Público (Governo Federal dos EUA)",
        "source": "White House Photo Office / Wikimedia Commons",
        "commons_file": "File:Portrait of Barbara and Jenna Bush.jpg",
        "pessoa_ids": ["pub_bush_jenna_bush_hager"]
    },
    {
        "folder": pasta_bush,
        "file_name": "01_Barbara_Pierce_Bush_Jr.jpg",
        "title": "Barbara Pierce Bush, Cofundadora do Global Health Corps",
        "artist": "Max Gersh / Forbes Philanthropy Summit",
        "role": "Fotografia",
        "date_created": "2016",
        "museum": "Wikimedia Commons",
        "formatted_description": "Retrato da ativista de saúde pública global Barbara Pierce Bush Jr.",
        "license": "Creative Commons Attribution-Share Alike 4.0 International",
        "source": "Wikimedia Commons / Max Gersh",
        "commons_file": "File:Barbara Bush, Philanthropy Summit 2016 (3x4a).jpg",
        "pessoa_ids": ["pub_bush_barbara_pierce_bush"]
    },

    # -------------------------------------------------------------
    # 4. Família Perón (6 obras)
    # -------------------------------------------------------------
    {
        "folder": pasta_peron,
        "file_name": "01_Juan_Domingo_Peron.jpg",
        "title": "General Juan Domingo Perón (Presidente da Argentina)",
        "artist": "Presidencia de la Nación Argentina",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "c. 1946",
        "museum": "Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato oficial do General Juan Domingo Perón com faixa e condecorações presidenciais da República Argentina.",
        "license": "Domínio Público (República Argentina / AGN)",
        "source": "Archivo General de la Nación Argentina / Wikimedia Commons",
        "commons_file": "File:Juan Domingo Perón.jpg",
        "pessoa_ids": ["pub_peron_juan_domingo_peron"]
    },
    {
        "folder": pasta_peron,
        "file_name": "01_Eva_Peron.jpg",
        "title": "Eva Perón 'Evita', Líder Espiritual da Nação",
        "artist": "Annemarie Heinrich / Ateliê Presidencial",
        "role": "Retrato Oficial a Cores",
        "date_created": "c. 1950",
        "museum": "Museo Evita / Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato canônico a cores de Eva Duarte de Perón com seus característicos cabelos dourados e traje de gala.",
        "license": "Domínio Público (República Argentina / AGN)",
        "source": "Archivo General de la Nación Argentina / Wikimedia Commons",
        "commons_file": "File:Evita color.jpg",
        "pessoa_ids": ["pub_peron_eva_peron"]
    },
    {
        "folder": pasta_peron,
        "file_name": "01_Isabel_Peron.jpg",
        "title": "María Estela Martínez de Perón 'Isabelita'",
        "artist": "Presidencia de la Nación Argentina",
        "role": "Fotografia Oficial Presidencial",
        "date_created": "1974",
        "museum": "Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato oficial de Isabel Perón, primeira mulher a assumir a chefia de Estado republicana em todo o continente americano.",
        "license": "Domínio Público (República Argentina / AGN)",
        "source": "Presidencia de la Nación Argentina / AGN / Wikimedia Commons",
        "commons_file": "File:Isabel Martinez de Peron.jpg",
        "pessoa_ids": ["pub_peron_isabel_peron"]
    },
    {
        "folder": pasta_peron,
        "file_name": "01_Aurelia_Tizon.jpg",
        "title": "Aurelia 'Potota' Tizón",
        "artist": "Fotógrafo familiar",
        "role": "Fotografia Histórica",
        "date_created": "c. 1930",
        "museum": "Archivo General de la Nación, Buenos Aires / Museo Histórico 17 de Octubre",
        "formatted_description": "Retrato de época da primeira esposa de Juan Domingo Perón, a professora e desenhista Aurelia Tizón.",
        "license": "Domínio Público (República Argentina)",
        "source": "Archivo General de la Nación Argentina / Wikimedia Commons",
        "commons_file": "File:Peron y Aurelia Tizon.jpg",
        "pessoa_ids": ["pub_peron_aurelia_tizon"]
    },
    {
        "folder": pasta_peron,
        "file_name": "01_Juana_Sosa_Toledo.jpg",
        "title": "Juana Sosa Toledo de Perón",
        "artist": "Fotógrafo patagônico",
        "role": "Fotografia Histórica",
        "date_created": "c. 1920",
        "museum": "Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato de Juana Sosa Toledo, mãe do Presidente Juan Domingo Perón.",
        "license": "Domínio Público (República Argentina)",
        "source": "Archivo General de la Nación Argentina / Wikimedia Commons",
        "commons_file": "File:Juana Sosa Toledo.jpg",
        "pessoa_ids": ["pub_peron_juana_sosa_toledo"]
    },
    {
        "folder": pasta_peron,
        "file_name": "01_Juan_Duarte_Juancito.png",
        "title": "Juan Ramón 'Juancito' Duarte",
        "artist": "Fotografia Oficial da Casa Rosada",
        "role": "Fotografia Histórica",
        "date_created": "c. 1948",
        "museum": "Archivo General de la Nación, Buenos Aires",
        "formatted_description": "Retrato de Juan Ramón Duarte, irmão confidente de Evita e secretário particular da presidência argentina.",
        "license": "Domínio Público (República Argentina / AGN)",
        "source": "Archivo General de la Nación Argentina / Wikimedia Commons",
        "commons_file": "File:Juan Domingo Perón con Juan Duarte, hermano de Evita.png",
        "pessoa_ids": ["pub_peron_juan_duarte_irmao"]
    }
]

def resolver_url_commons(session, file_title):
    params = {
        "action": "query",
        "titles": file_title,
        "prop": "imageinfo",
        "iiprop": "url|mime|size",
        "format": "json"
    }
    for attempt in range(3):
        try:
            resp = session.get(COMMONS_API, params=params, headers=HEADERS, timeout=30)
            if resp.status_code == 429:
                wait_time = 5 * (attempt + 1)
                print(f"    [Rate-limit 429] Aguardando {wait_time}s...")
                time.sleep(wait_time)
                continue
            data = resp.json()
            pages = data.get("query", {}).get("pages", {})
            for pid, page in pages.items():
                if pid != "-1" and "imageinfo" in page:
                    return page["imageinfo"][0]["url"]
        except Exception as e:
            print(f"    [Erro API attempt {attempt+1}]: {e}")
            time.sleep(2)
    return None

def otimizar_imagem(raw_bytes, max_dim=1920):
    im = Image.open(BytesIO(raw_bytes))
    formato_original = im.format
    
    if im.mode in ("RGBA", "P"):
        if formato_original == "PNG":
            novo_formato = "PNG"
            ext = ".png"
        else:
            im = im.convert("RGB")
            novo_formato = "JPEG"
            ext = ".jpg"
    elif im.mode != "RGB":
        im = im.convert("RGB")
        novo_formato = "JPEG"
        ext = ".jpg"
    else:
        novo_formato = "JPEG"
        ext = ".jpg"

    w, h = im.size
    if max(w, h) > max_dim:
        scale = max_dim / max(w, h)
        novo_w = int(w * scale)
        novo_h = int(h * scale)
        im = im.resize((novo_w, novo_h), Image.Resampling.LANCZOS)
        print(f"    [OK] Redimensionado de {w}x{h} para {novo_w}x{novo_h}")
    else:
        print(f"    [OK] Dimensões mantidas: {w}x{h}")

    out_buf = BytesIO()
    if novo_formato == "PNG":
        im.save(out_buf, format="PNG", optimize=True)
    else:
        im.save(out_buf, format="JPEG", quality=95, optimize=True)

    return out_buf.getvalue(), ext

def main():
    conn = sqlite3.connect(str(db_path))
    cur = conn.cursor()
    cur.execute("PRAGMA foreign_keys = ON")

    session = requests.Session()
    session.headers.update(HEADERS)

    total_obras = len(OBRAS_BATCH17)
    sucessos = 0

    print("=" * 75)
    print(f"INICIANDO CURADORIA BATCH 17: GRANDES DINASTIAS POLÍTICAS DO SÉCULO XX ({total_obras} obras)")
    print("=" * 75)

    for i, item in enumerate(OBRAS_BATCH17, 1):
        print(f"\n[{i:02d}/{total_obras:02d}] {item['title']}")
        print(f"  Pessoas vinculadas: {item['pessoa_ids']}")
        print(f"  Fonte Commons: {item['commons_file']}")

        item["folder"].mkdir(parents=True, exist_ok=True)
        img_dest = item["folder"] / item["file_name"]
        json_dest = item["folder"] / (img_dest.stem + ".json")

        img_bytes = None

        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print("  Resolvendo URL direta no Wikimedia Commons...")
            url = resolver_url_commons(session, item["commons_file"])
            if not url:
                print(f"    [FALHA] Não foi possível resolver URL para {item['commons_file']}")
                continue
            item["url"] = url

            print(f"  Baixando imagem institucional ({url.split('/')[-1][:50]}...)...")
            time.sleep(1.5)
            
            raw_bytes = None
            for attempt in range(3):
                try:
                    resp = session.get(url, timeout=60)
                    if resp.status_code == 200 and len(resp.content) > 5000:
                        raw_bytes = resp.content
                        break
                    elif resp.status_code == 429:
                        wait = 6 * (attempt + 1)
                        print(f"    [HTTP 429] Aguardando {wait}s...")
                        time.sleep(wait)
                    else:
                        print(f"    [HTTP {resp.status_code}] Tentando novamente...")
                        time.sleep(3)
                except Exception as e:
                    print(f"    [Erro Download attempt {attempt+1}]: {e}")
                    time.sleep(3)

            if not raw_bytes:
                print(f"    [FALHA] Não foi possível baixar {item['commons_file']}")
                continue

            print(f"    [OK] Download concluído: {len(raw_bytes):,} bytes originais.")
            img_bytes, novo_ext = otimizar_imagem(raw_bytes)
            if novo_ext != img_dest.suffix.lower():
                img_dest = img_dest.with_suffix(novo_ext)
                item["file_name"] = img_dest.name
                json_dest = item["folder"] / (img_dest.stem + ".json")

            img_dest.write_bytes(img_bytes)
            print(f"    [OK] Imagem tratada e salva: {img_dest.name} ({len(img_bytes):,} bytes)")
        else:
            print(f"    [OK] Imagem já existente em disco: {img_dest.name}")
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
        print(f"    [OK] Metadados Schema 4.0 gravados: {json_dest.name}")

        # 2. Copia para %APPDATA%/midia/ com UUID
        ext = img_dest.suffix.lower()
        doc_id = str(uuid.uuid4())
        nome_midia = f"{doc_id}{ext}"
        midia_file = midia_dir / nome_midia
        midia_file.write_bytes(img_bytes)
        caminho_relativo = f"midia/{nome_midia}"
        tamanho_bytes = len(img_bytes)

        titulo_doc = f"Retrato: {item['title']}"
        desc_doc = f"Obra: {item['formatted_description']} | Licença: {item['license']} | Fonte: {item['source']}"

        # 3. Insere registro em 'documentos'
        cur.execute("""
            INSERT OR REPLACE INTO documentos (
                id, caminho_relativo, tipo_midia, tamanho_bytes,
                data_documento, titulo, descricao, nome_original, data_criacao
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        """, (
            doc_id,
            caminho_relativo,
            "imagem",
            tamanho_bytes,
            item["date_created"],
            titulo_doc,
            desc_doc,
            item["file_name"]
        ))

        # 4. Vincula em 'documento_vinculos' e atualiza 'pessoas.foto_url'
        for pid in item["pessoa_ids"]:
            vinculo_id = f"vinc_{doc_id[:8]}_{pid}"
            cur.execute("""
                INSERT OR REPLACE INTO documento_vinculos (
                    id, documento_id, pessoa_id, evento_id
                ) VALUES (?, ?, ?, NULL)
            """, (vinculo_id, doc_id, pid))

            cur.execute("""
                UPDATE pessoas
                SET foto_url = ?
                WHERE id = ?
            """, (caminho_relativo, pid))
            print(f"    -> Foto vinculada à pessoa: [{pid}]")

        conn.commit()
        sucessos += 1

    conn.close()
    print("\n" + "=" * 75)
    print("CURADORIA BATCH 17 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()
