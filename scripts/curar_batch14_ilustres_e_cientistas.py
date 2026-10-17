"""
EloTempo - Curadoria de Obras Históricas: Batch 14 (Brasil Ilustre & Revolução Científica)
========================================================================================
Baixa e cadastra com metadados de mestres da pintura e arquivos oficiais:
1. Brasil Ilustre (23 obras):
   - Machado de Assis, Carolina Novais, Faustino Xavier de Novais
   - Santos-Dumont, Henrique Dumont, Francisca de Paula
   - Chiquinha Gonzaga
   - Ruy Barbosa, Maria Augusta Viana
   - Duque de Caxias, Ana Luísa (Duquesa), Brigadeiro Francisco de Lima e Silva, Luís Alves Filho
   - Visconde de Mauá, Maria Joaquina (Viscondessa)
   - Joaquim Nabuco, Senador Nabuco de Araújo, Carolina Nabuco, Maurício Nabuco
   - Oswaldo Cruz, Dona Miloca (Emília), Dr. Bento Gonçalves Cruz, Dr. Bento Oswaldo Cruz

2. Revolução Científica (12 obras):
   - Albert Einstein, Mileva Marić, Elsa Einstein, Pauline Koch, Hans Albert Einstein
   - Sir Isaac Newton
   - Galileo Galilei
   - Leonardo da Vinci
   - Nikola Tesla
   - Thomas Alva Edison, Mina Miller Edison, Charles Edison
"""

import os
import sys
import json
import uuid
import time
import shutil
import sqlite3
import requests
from io import BytesIO
from datetime import datetime, timezone
from pathlib import Path
from PIL import Image

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; brazilian history and scientific revolution; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

OBRAS_BATCH14 = [
    # ==========================================
    # BRASIL ILUSTRE
    # ==========================================
    # 1. Machado de Assis
    {
        "pessoa_ids": ["pub_machado_de_assis"],
        "folder": imagens_base / "brasil-ilustre" / "machado-de-assis" / "Machado_de_Assis",
        "file_name": "01_Machado_de_Assis.jpg",
        "commons_file": "File:Machado de Assis by Marc Ferrez.jpg",
        "title": "Joaquim Maria Machado de Assis",
        "artist": "Marc Ferrez",
        "role": "fotógrafo",
        "date_created": "c. 1890",
        "museum": "Fundação Biblioteca Nacional / Academia Brasileira de Letras",
        "formatted_description": "Retrato fotográfico de gabinete por Marc Ferrez (c. 1890). Acervo: Biblioteca Nacional do Brasil e Academia Brasileira de Letras.",
        "license": "Public domain",
        "source": "Acervo Marc Ferrez; Fundação Biblioteca Nacional"
    },
    {
        "pessoa_ids": ["pub_machado_carolina_novais"],
        "folder": imagens_base / "brasil-ilustre" / "machado-de-assis" / "Carolina_Novais",
        "file_name": "01_Carolina_Novais.jpg",
        "commons_file": "File:Carolina Amor de Machado.jpg",
        "title": "Carolina Augusta Xavier de Novais",
        "artist": "Fotógrafo da Corte Fluminense",
        "role": "fotógrafo",
        "date_created": "c. 1869",
        "museum": "Academia Brasileira de Letras / Coleção Machado de Assis",
        "formatted_description": "Retrato de época de Carolina Xavier de Novais, esposa e companheira de Machado de Assis. Acervo: Academia Brasileira de Letras.",
        "license": "Public domain",
        "source": "Academia Brasileira de Letras"
    },
    {
        "pessoa_ids": ["pub_machado_faustino_novais"],
        "folder": imagens_base / "brasil-ilustre" / "machado-de-assis" / "Faustino_Novais",
        "file_name": "01_Faustino_Novais.jpg",
        "commons_file": "File:Faustino Xavier de Novaes.jpg",
        "title": "Faustino Xavier de Novais",
        "artist": "Litografia do Século XIX",
        "role": "litógrafo",
        "date_created": "c. 1865",
        "museum": "Biblioteca Nacional de Portugal / Arquivo Histórico",
        "formatted_description": "Retrato litográfico do poeta e jornalista Faustino Xavier de Novais, cunhado de Machado de Assis. Acervo: Biblioteca Nacional de Portugal.",
        "license": "Public domain",
        "source": "Biblioteca Nacional de Portugal"
    },

    # 2. Alberto Santos Dumont
    {
        "pessoa_ids": ["pub_dumont_alberto_santos"],
        "folder": imagens_base / "brasil-ilustre" / "santos-dumont" / "Alberto_Santos_Dumont",
        "file_name": "01_Alberto_Santos_Dumont.jpg",
        "commons_file": "File:Alberto Santos-Dumont by Nadar.jpg",
        "title": "Alberto Santos-Dumont em Paris",
        "artist": "Nadar (Gaspard-Félix Tournachon)",
        "role": "fotógrafo",
        "date_created": "c. 1900",
        "museum": "Atelier Nadar / Bibliothèque nationale de France",
        "formatted_description": "Retrato fotográfico pelo célebre fotógrafo e aeronauta Nadar em Paris (c. 1900). Acervo: Bibliothèque nationale de France (BnF).",
        "license": "Public domain",
        "source": "Bibliothèque nationale de France (BnF)"
    },
    {
        "pessoa_ids": ["pub_dumont_henrique"],
        "folder": imagens_base / "brasil-ilustre" / "santos-dumont" / "Henrique_Dumont",
        "file_name": "01_Henrique_Dumont.jpg",
        "commons_file": "File:M. Henrique Santos Dumont - Pai de Santos Dumont - 1-13798-0000-0000, Acervo do Museu Paulista da USP.jpg",
        "title": "Henrique Dumont, o Rei do Café",
        "artist": "Acervo Iconográfico do Museu Paulista",
        "role": "fotógrafo",
        "date_created": "c. 1885",
        "museum": "Museu Paulista da Universidade de São Paulo (Museu do Ipiranga)",
        "formatted_description": "Retrato fotográfico de Henrique Dumont, pioneiro da ferrovia e cafeicultura paulista e pai do inventor. Acervo: Museu Paulista da USP.",
        "license": "CC BY-SA 4.0",
        "source": "Museu Paulista da Universidade de São Paulo"
    },
    {
        "pessoa_ids": ["pub_dumont_francisca_paula"],
        "folder": imagens_base / "brasil-ilustre" / "santos-dumont" / "Francisca_Paula",
        "file_name": "01_Francisca_Paula.jpg",
        "commons_file": "File:Francisca de Paula - Mãe de Santos Dumont - 1-13797-0000-0000, Acervo do Museu Paulista da USP.jpg",
        "title": "Francisca de Paula Santos Dumont",
        "artist": "Acervo Iconográfico do Museu Paulista",
        "role": "fotógrafo",
        "date_created": "c. 1885",
        "museum": "Museu Paulista da Universidade de São Paulo (Museu do Ipiranga)",
        "formatted_description": "Retrato fotográfico de Francisca de Paula Santos, mãe de Alberto Santos-Dumont. Acervo: Museu Paulista da USP.",
        "license": "CC BY-SA 4.0",
        "source": "Museu Paulista da Universidade de São Paulo"
    },

    # 3. Chiquinha Gonzaga
    {
        "pessoa_ids": ["pub_gonzaga_chiquinha"],
        "folder": imagens_base / "brasil-ilustre" / "chiquinha-gonzaga" / "Chiquinha_Gonzaga",
        "file_name": "01_Chiquinha_Gonzaga.jpg",
        "commons_file": "File:Chiquinha Gonzaga portrait 1877.jpg",
        "title": "Francisca Edwiges Neves Gonzaga (Chiquinha Gonzaga)",
        "artist": "Insley Pacheco / Gabinete Fotográfico Imperial",
        "role": "fotógrafo",
        "date_created": "1877",
        "museum": "Instituto Moreira Salles / SBAT",
        "formatted_description": "Retrato fotográfico de estúdio de Chiquinha Gonzaga ao piano (1877). Acervo: Instituto Moreira Salles e Sociedade Brasileira de Autores Teatrais.",
        "license": "Public domain",
        "source": "Instituto Moreira Salles (IMS); SBAT"
    },

    # 4. Ruy Barbosa
    {
        "pessoa_ids": ["pub_ruy_barbosa"],
        "folder": imagens_base / "brasil-ilustre" / "ruy-barbosa" / "Ruy_Barbosa",
        "file_name": "01_Ruy_Barbosa.jpg",
        "commons_file": "File:Rui Barbosa.jpg",
        "title": "Ruy Barbosa de Oliveira, o Águia de Haia",
        "artist": "Retrato Oficial de Estado",
        "role": "fotógrafo",
        "date_created": "c. 1907",
        "museum": "Fundação Casa de Rui Barbosa, Rio de Janeiro",
        "formatted_description": "Retrato oficial de Ruy Barbosa, jurista, diplomata e delegado plenipotenciário do Brasil na II Conferência de Paz de Haia. Acervo: Casa de Rui Barbosa.",
        "license": "Public domain",
        "source": "Fundação Casa de Rui Barbosa"
    },
    {
        "pessoa_ids": ["pub_ruy_maria_augusta_viana"],
        "folder": imagens_base / "brasil-ilustre" / "ruy-barbosa" / "Maria_Augusta_Viana",
        "file_name": "01_Maria_Augusta_Viana.png",
        "commons_file": "File:O conselheiro Ruy Barbosa, sua esposa e sua filha - Brasil-Portugal (1Jan1908).png",
        "title": "Dona Maria Augusta Viana Bandeira Barbosa",
        "artist": "Revista Brasil-Portugal",
        "role": "fotógrafo",
        "date_created": "1908",
        "museum": "Hemeroteca Digital / Fundação Casa de Rui Barbosa",
        "formatted_description": "Fotografia de época de Dona Maria Augusta Viana Bandeira Barbosa com o Conselheiro Ruy Barbosa em Haia e Lisboa (1908).",
        "license": "Public domain",
        "source": "Revista Brasil-Portugal (1 de Janeiro de 1908)"
    },

    # 5. Duque de Caxias
    {
        "pessoa_ids": ["pub_caxias_luis_alves"],
        "folder": imagens_base / "brasil-ilustre" / "duque-de-caxias" / "Luis_Alves_Duque_de_Caxias",
        "file_name": "01_Luis_Alves_Duque_de_Caxias.jpg",
        "commons_file": "File:Ernst Papf – Retrato de Luís Alves de Lima e Silva, Duque de Caxias (1871).jpg",
        "title": "Luís Alves de Lima e Silva, Duque de Caxias, Patrono do Exército",
        "artist": "Ernst Papf",
        "role": "pintor",
        "date_created": "1871",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato a óleo magistral de Ernst Papf (1871) representando o Duque de Caxias fardado com todas as condecorações imperiais. Acervo: Museu Histórico Nacional.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; IBRAM"
    },
    {
        "pessoa_ids": ["pub_caxias_ana_luisa_loreto"],
        "folder": imagens_base / "brasil-ilustre" / "duque-de-caxias" / "Ana_Luisa_Duquesa_de_Caxias",
        "file_name": "01_Ana_Luisa_Duquesa_de_Caxias.jpg",
        "commons_file": "File:Duquesa de Caxias, da coleção Museu Histórico Nacional.jpg",
        "title": "Ana Luísa de Loreto Carneiro Vianna, Duquesa de Caxias",
        "artist": "Pintor da Corte Imperial Fluminense",
        "role": "pintor",
        "date_created": "c. 1850",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato a óleo de Ana Luísa de Loreto Carneiro Vianna, Duquesa de Caxias. Acervo: Museu Histórico Nacional.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; Coleção Família Lima e Silva"
    },
    {
        "pessoa_ids": ["pub_caxias_francisco_de_lima_e_silva"],
        "folder": imagens_base / "brasil-ilustre" / "duque-de-caxias" / "Brigadeiro_Francisco_Lima_e_Silva",
        "file_name": "01_Brigadeiro_Francisco_Lima_e_Silva.jpg",
        "commons_file": "File:Brigadeiro Francisco de Lima e Silva, da coleção Museu Histórico Nacional.jpg",
        "title": "Brigadeiro Francisco de Lima e Silva, Regente do Império",
        "artist": "Arnaud Julien Pallière (atrib.)",
        "role": "pintor",
        "date_created": "c. 1831",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato a óleo do Brigadeiro Francisco de Lima e Silva, pai do Duque de Caxias e membro da Regência Trina Provisória e Permanente (1831-1835). Acervo: MHN.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; Império do Brasil"
    },
    {
        "pessoa_ids": ["pub_caxias_luis_alves_filho"],
        "folder": imagens_base / "brasil-ilustre" / "duque-de-caxias" / "Luis_Alves_Filho",
        "file_name": "01_Luis_Alves_Filho.jpg",
        "commons_file": "File:Luis alves son of caxias.jpg",
        "title": "Luís Alves de Lima e Silva Filho",
        "artist": "Fotógrafo Imperial do Rio de Janeiro",
        "role": "fotógrafo",
        "date_created": "c. 1860",
        "museum": "Museu Histórico Nacional / Coleção Duque de Caxias",
        "formatted_description": "Retrato de estúdio oitocentista do único filho varão do Duque de Caxias. Acervo: Museu Histórico Nacional.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional"
    },

    # 6. Visconde de Mauá
    {
        "pessoa_ids": ["pub_maua_irineu_evangelista"],
        "folder": imagens_base / "brasil-ilustre" / "visconde-de-maua" / "Visconde_de_Maua",
        "file_name": "01_Visconde_de_Maua.png",
        "commons_file": "File:Irineu evangelista de sousa the viscount of maua.png",
        "title": "Irineu Evangelista de Sousa, Visconde de Mauá",
        "artist": "Retrato Oficial do Segundo Reinado",
        "role": "fotógrafo",
        "date_created": "c. 1870",
        "museum": "Museu Histórico Nacional / Coleção Imperial",
        "formatted_description": "Retrato de estúdio do Visconde de Mauá, patrono da indústria brasileira, fundador da primeira ferrovia e estaleiro naval do país. Acervo: MHN.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional, Rio de Janeiro"
    },
    {
        "pessoa_ids": ["pub_maua_maria_joaquina"],
        "folder": imagens_base / "brasil-ilustre" / "visconde-de-maua" / "Viscondessa_de_Maua",
        "file_name": "01_Viscondessa_de_Maua.jpg",
        "commons_file": "File:Maria Joaquina de Sousa.jpg",
        "title": "Maria Joaquina de Sousa, Viscondessa de Mauá",
        "artist": "Retrato de Gabinete Fluminense",
        "role": "fotógrafo",
        "date_created": "c. 1875",
        "museum": "Museu Histórico Nacional / Acervo Mauá",
        "formatted_description": "Retrato fotográfico de Maria Joaquina de Sousa (Dona May), Viscondessa de Mauá. Acervo: Museu Histórico Nacional.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional, Rio de Janeiro"
    },

    # 7. Joaquim Nabuco
    {
        "pessoa_ids": ["pub_nabuco_joaquim_nabuco"],
        "folder": imagens_base / "brasil-ilustre" / "joaquim-nabuco" / "Joaquim_Nabuco",
        "file_name": "01_Joaquim_Nabuco.jpg",
        "commons_file": "File:Ambassador joaquim nabuco in court dress.jpg",
        "title": "Joaquim Aurélio Barreto Nabuco de Araújo, Embaixador do Brasil",
        "artist": "Harris & Ewing Photographers",
        "role": "fotógrafo",
        "date_created": "c. 1906",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato oficial em trajes diplomáticos de corte de Joaquim Nabuco, tribuno da abolição e primeiro embaixador brasileiro em Washington. Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress (EUA), LC-DIG-hec-00276"
    },
    {
        "pessoa_ids": ["pub_nabuco_jose_tomas_de_araujo"],
        "folder": imagens_base / "brasil-ilustre" / "joaquim-nabuco" / "Senador_Nabuco_de_Araujo",
        "file_name": "01_Senador_Nabuco_de_Araujo.jpg",
        "commons_file": "File:José Thomaz Nabuco D'Araujo - Litografia (cropped).jpg",
        "title": "Senador José Tomás Nabuco de Araújo Filho",
        "artist": "Sébastien Auguste Sisson (litógrafo)",
        "role": "litógrafo",
        "date_created": "c. 1861",
        "museum": "Fundação Biblioteca Nacional / Galeria dos Brasileiros Ilustres",
        "formatted_description": "Litografia por S. A. Sisson retratando o Conselheiro e Senador do Império José Tomás Nabuco de Araújo, ministro da Justiça de D. Pedro II. Acervo: Biblioteca Nacional.",
        "license": "Public domain",
        "source": "Fundação Biblioteca Nacional, Rio de Janeiro"
    },
    {
        "pessoa_ids": ["pub_nabuco_carolina_nabuco"],
        "folder": imagens_base / "brasil-ilustre" / "joaquim-nabuco" / "Carolina_Nabuco",
        "file_name": "01_Carolina_Nabuco.jpg",
        "commons_file": "File:Carolina Nabuco (1959).tif",
        "title": "Carolina Nabuco, Escritora e Biógrafa",
        "artist": "Correio da Manhã / Arquivo Nacional",
        "role": "fotógrafo",
        "date_created": "1959",
        "museum": "Arquivo Nacional do Brasil, Fundo Correio da Manhã",
        "formatted_description": "Retrato fotográfico da célebre escritora, tradutora e romancista Carolina Nabuco (1959). Acervo: Arquivo Nacional do Brasil (BR RJANRIO PH.0.FOT.03816).",
        "license": "Public domain",
        "source": "Arquivo Nacional do Brasil"
    },
    {
        "pessoa_ids": ["pub_nabuco_mauricio_nabuco"],
        "folder": imagens_base / "brasil-ilustre" / "joaquim-nabuco" / "Mauricio_Nabuco",
        "file_name": "01_Mauricio_Nabuco.jpg",
        "commons_file": "File:Maurício Nabuco (1938).tif",
        "title": "Maurício Nabuco, Embaixador do Brasil",
        "artist": "Correio da Manhã / Arquivo Nacional",
        "role": "fotógrafo",
        "date_created": "1938",
        "museum": "Arquivo Nacional do Brasil, Fundo Correio da Manhã",
        "formatted_description": "Retrato oficial do embaixador Maurício Nabuco (1938), Secretário-Geral do Itamaraty e embaixador em Washington. Acervo: Arquivo Nacional (BR RJANRIO PH.0.FOT.03817).",
        "license": "Public domain",
        "source": "Arquivo Nacional do Brasil"
    },

    # 8. Oswaldo Cruz
    {
        "pessoa_ids": ["pub_cruz_oswaldo_cruz"],
        "folder": imagens_base / "brasil-ilustre" / "oswaldo-cruz" / "Oswaldo_Cruz",
        "file_name": "01_Oswaldo_Cruz.jpg",
        "commons_file": "File:Retrato de Oswaldo Cruz sentado, Casa de Oswaldo Cruz (BR RJCOC FO-01-02-08).jpg",
        "title": "Dr. Oswaldo Gonçalves Cruz, Sanitarista e Cientista",
        "artist": "Casa de Oswaldo Cruz / Acervo Fotográfico",
        "role": "fotógrafo",
        "date_created": "c. 1910",
        "museum": "Fundação Oswaldo Cruz (Fiocruz), Casa de Oswaldo Cruz",
        "formatted_description": "Retrato de Oswaldo Cruz sentado em seu gabinete em Manguinhos (c. 1910). Acervo: Casa de Oswaldo Cruz / Fiocruz (BR RJCOC FO-01-02-08).",
        "license": "Public domain",
        "source": "Casa de Oswaldo Cruz / Fiocruz"
    },
    {
        "pessoa_ids": ["pub_cruz_emilia_fonseca"],
        "folder": imagens_base / "brasil-ilustre" / "oswaldo-cruz" / "Emilia_da_Fonseca_Cruz",
        "file_name": "01_Emilia_da_Fonseca_Cruz.jpg",
        "commons_file": "File:Emília da Fonseca Cruz, Casa de Oswaldo Cruz (BR RJCOC OC-DP-04-02).jpg",
        "title": "Emília da Fonseca Cruz (Dona Miloca)",
        "artist": "Casa de Oswaldo Cruz / Acervo Fotográfico",
        "role": "fotógrafo",
        "date_created": "c. 1905",
        "museum": "Fundação Oswaldo Cruz (Fiocruz), Casa de Oswaldo Cruz",
        "formatted_description": "Retrato de época de Emília da Fonseca Cruz, companheira do cientista por toda a vida. Acervo: Casa de Oswaldo Cruz / Fiocruz (BR RJCOC OC-DP-04-02).",
        "license": "Public domain",
        "source": "Casa de Oswaldo Cruz / Fiocruz"
    },
    {
        "pessoa_ids": ["pub_cruz_bento_goncalves"],
        "folder": imagens_base / "brasil-ilustre" / "oswaldo-cruz" / "Bento_Goncalves_Cruz",
        "file_name": "01_Bento_Goncalves_Cruz.jpg",
        "commons_file": "File:Retrato de Bento Gonçalves Cruz, Casa de Oswaldo Cruz (MV 3.1 7).jpg",
        "title": "Dr. Bento Gonçalves Cruz, Médico da Corte",
        "artist": "Casa de Oswaldo Cruz / Museu da Vida",
        "role": "fotógrafo",
        "date_created": "c. 1880",
        "museum": "Fundação Oswaldo Cruz (Fiocruz), Museu da Vida",
        "formatted_description": "Retrato fotográfico do Dr. Bento Gonçalves Cruz, médico do Império do Brasil e pai de Oswaldo Cruz. Acervo: Casa de Oswaldo Cruz / Fiocruz (MV 3.1 7).",
        "license": "Public domain",
        "source": "Casa de Oswaldo Cruz / Fiocruz"
    },
    {
        "pessoa_ids": ["pub_cruz_bento_oswaldo"],
        "folder": imagens_base / "brasil-ilustre" / "oswaldo-cruz" / "Bento_Oswaldo_Cruz",
        "file_name": "01_Bento_Oswaldo_Cruz.jpg",
        "commons_file": "File:Bento Oswaldo Cruz, filho de Oswaldo Cruz, Casa de Oswaldo Cruz (BR RJCOC 02-10-20-15-001-002).jpg",
        "title": "Bento Oswaldo Cruz, Médico e Pesquisador",
        "artist": "Casa de Oswaldo Cruz / Acervo Fotográfico",
        "role": "fotógrafo",
        "date_created": "c. 1920",
        "museum": "Fundação Oswaldo Cruz (Fiocruz), Casa de Oswaldo Cruz",
        "formatted_description": "Retrato de Bento Oswaldo Cruz em seu laboratório em Manguinhos (c. 1920). Acervo: Casa de Oswaldo Cruz / Fiocruz (BR RJCOC 02-10-20-15-001-002).",
        "license": "Public domain",
        "source": "Casa de Oswaldo Cruz / Fiocruz"
    },

    # ==========================================
    # REVOLUÇÃO CIENTÍFICA & INVENÇÃO TECNOLÓGICA
    # ==========================================
    # 9. Albert Einstein
    {
        "pessoa_ids": ["pub_einstein_albert"],
        "folder": imagens_base / "revolucao-cientifica" / "einstein" / "Albert_Einstein",
        "file_name": "01_Albert_Einstein.jpg",
        "commons_file": "File:Albert Einstein Head.jpg",
        "title": "Albert Einstein, Físico Teórico e Prêmio Nobel",
        "artist": "Ferdinand Schmutzer / Retrato Oficial",
        "role": "fotógrafo",
        "date_created": "1921",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Célebre retrato de Albert Einstein no ano do anúncio do seu Prêmio Nobel de Física (1921). Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress (EUA)"
    },
    {
        "pessoa_ids": ["pub_einstein_mileva_maric"],
        "folder": imagens_base / "revolucao-cientifica" / "einstein" / "Mileva_Maric",
        "file_name": "01_Mileva_Maric.jpg",
        "commons_file": "File:Mileva Maric.jpg",
        "title": "Mileva Marić Einstein, Física e Matemática",
        "artist": "Atelier Fotográfico de Zurique",
        "role": "fotógrafo",
        "date_created": "1896",
        "museum": "ETH Zürich / Arquivos Einstein",
        "formatted_description": "Retrato de estúdio da física e matemática Mileva Marić no Politécnico de Zurique (1896). Acervo: Eidgenössische Technische Hochschule Zürich (ETH).",
        "license": "Public domain",
        "source": "ETH-Bibliothek Zürich"
    },
    {
        "pessoa_ids": ["pub_einstein_elsa"],
        "folder": imagens_base / "revolucao-cientifica" / "einstein" / "Elsa_Einstein",
        "file_name": "01_Elsa_Einstein.jpg",
        "commons_file": "File:Bundesarchiv Bild 102-00486A, Elsa Einstein.jpg",
        "title": "Elsa Einstein",
        "artist": "Arquivo Federal Alemão (Bundesarchiv)",
        "role": "fotógrafo",
        "date_created": "c. 1920",
        "museum": "Bundesarchiv, Koblenz",
        "formatted_description": "Retrato oficial de Elsa Löwenthal Einstein. Acervo: Arquivo Federal da Alemanha (Bundesarchiv, Bild 102-00486A).",
        "license": "CC BY-SA 3.0 DE",
        "source": "Deutsches Bundesarchiv"
    },
    {
        "pessoa_ids": ["pub_einstein_pauline_koch"],
        "folder": imagens_base / "revolucao-cientifica" / "einstein" / "Pauline_Koch",
        "file_name": "01_Pauline_Koch.jpg",
        "commons_file": "File:Pauline Koch.jpg",
        "title": "Pauline Koch Einstein",
        "artist": "Atelier Fotográfico de Ulm",
        "role": "fotógrafo",
        "date_created": "c. 1880",
        "museum": "Albert Einstein Archives / Hebrew University of Jerusalem",
        "formatted_description": "Retrato oitocentista de Pauline Koch, mãe de Albert Einstein. Acervo: Arquivos Albert Einstein na Universidade Hebraica de Jerusalém.",
        "license": "Public domain",
        "source": "Albert Einstein Archives, The Hebrew University of Jerusalem"
    },
    {
        "pessoa_ids": ["pub_einstein_hans_albert"],
        "folder": imagens_base / "revolucao-cientifica" / "einstein" / "Hans_Albert_Einstein",
        "file_name": "01_Hans_Albert_Einstein.jpg",
        "commons_file": "File:Hans-Albert-Einstein-1953.jpg",
        "title": "Hans Albert Einstein, Engenheiro e Professor na UC Berkeley",
        "artist": "University of California, Berkeley",
        "role": "fotógrafo",
        "date_created": "1953",
        "museum": "UC Berkeley Archives / Water Resources Center Archives",
        "formatted_description": "Retrato acadêmico de Hans Albert Einstein (1953), pioneiro da engenharia de transporte de sedimentos e professor em Berkeley. Acervo: UC Berkeley.",
        "license": "Public domain",
        "source": "University of California, Berkeley"
    },

    # 10. Sir Isaac Newton
    {
        "pessoa_ids": ["pub_newton_isaac"],
        "folder": imagens_base / "revolucao-cientifica" / "newton" / "Isaac_Newton",
        "file_name": "01_Isaac_Newton.jpg",
        "commons_file": "File:GodfreyKneller-IsaacNewton-1689.jpg",
        "title": "Sir Isaac Newton, Físico, Matemático e Filósofo Natural",
        "artist": "Sir Godfrey Kneller",
        "role": "pintor",
        "date_created": "1689",
        "museum": "Farleigh House / Portsmouth Collection",
        "formatted_description": "Retrato a óleo clássico por Sir Godfrey Kneller (1689), pintado no auge da publicação dos 'Philosophiae Naturalis Principia Mathematica'. Coleção Portsmouth.",
        "license": "Public domain",
        "source": "Portsmouth Collection; National Portrait Gallery"
    },

    # 11. Galileu Galilei
    {
        "pessoa_ids": ["pub_galilei_galileo"],
        "folder": imagens_base / "revolucao-cientifica" / "galileu" / "Galileo_Galilei",
        "file_name": "01_Galileo_Galilei.jpg",
        "commons_file": "File:Justus Sustermans - Portrait of Galileo Galilei (Uffizi).jpg",
        "title": "Galileo Galilei, Astrônomo, Físico e Matemático",
        "artist": "Justus Sustermans",
        "role": "pintor",
        "date_created": "1636",
        "museum": "Galleria degli Uffizi, Florença",
        "formatted_description": "Retrato magistral a óleo de Galileo Galilei por Justus Sustermans (1636). Acervo permanente da Galleria degli Uffizi, Florença.",
        "license": "Public domain",
        "source": "Galleria degli Uffizi, Florença"
    },

    # 12. Leonardo da Vinci
    {
        "pessoa_ids": ["pub_davinci_leonardo"],
        "folder": imagens_base / "revolucao-cientifica" / "da-vinci" / "Leonardo_da_Vinci",
        "file_name": "01_Leonardo_da_Vinci.jpg",
        "commons_file": "File:Leonardo da Vinci - presumed self-portrait - lossless.png",
        "title": "Leonardo da Vinci (Presumido Autorretrato)",
        "artist": "Leonardo da Vinci",
        "role": "desenhista",
        "date_created": "c. 1512",
        "museum": "Biblioteca Reale, Turim",
        "formatted_description": "Célebre desenho em sanguina vermelha sobre papel (c. 1512), universalmente reverenciado como o autorretrato do gênio renascentista. Acervo: Biblioteca Reale di Torino (Inv. 15571).",
        "license": "Public domain",
        "source": "Biblioteca Reale di Torino, Itália"
    },

    # 13. Nikola Tesla
    {
        "pessoa_ids": ["pub_tesla_nikola"],
        "folder": imagens_base / "revolucao-cientifica" / "tesla" / "Nikola_Tesla",
        "file_name": "01_Nikola_Tesla.jpg",
        "commons_file": "File:Tesla Sarony.jpg",
        "title": "Nikola Tesla, Físico, Engenheiro e Inventor",
        "artist": "Napoleon Sarony",
        "role": "fotógrafo",
        "date_created": "1890",
        "museum": "Sarony Studio, Nova York / Library of Congress",
        "formatted_description": "Retrato icônico de Nikola Tesla aos 34 anos por Napoleon Sarony (1890), época da criação dos motores de indução e corrente alternada. Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Sarony Studios, Nova York; Library of Congress"
    },

    # 14. Thomas Alva Edison
    {
        "pessoa_ids": ["pub_edison_thomas"],
        "folder": imagens_base / "revolucao-cientifica" / "edison" / "Thomas_Edison",
        "file_name": "01_Thomas_Edison.jpg",
        "commons_file": "File:Thomas Edison2.jpg",
        "title": "Thomas Alva Edison com o Fonógrafo",
        "artist": "Louis Bachrach / Bachrach Studios",
        "role": "fotógrafo",
        "date_created": "1922",
        "museum": "Library of Congress / National Park Service",
        "formatted_description": "Retrato de estúdio de Thomas Edison por Louis Bachrach (1922). Acervo: Library of Congress (LC-USZ62-55342).",
        "license": "Public domain",
        "source": "Library of Congress, Prints and Photographs Division"
    },
    {
        "pessoa_ids": ["pub_edison_mina_miller"],
        "folder": imagens_base / "revolucao-cientifica" / "edison" / "Mina_Miller_Edison",
        "file_name": "01_Mina_Miller_Edison.jpg",
        "commons_file": "File:Mrs. T.A. Edison LCCN2014700516 (cropped).jpg",
        "title": "Mina Miller Edison",
        "artist": "George Grantham Bain Collection",
        "role": "fotógrafo",
        "date_created": "c. 1915",
        "museum": "Library of Congress, Prints and Photographs Division",
        "formatted_description": "Retrato de época de Mina Miller Edison, esposa do inventor e notável líder cívica e conservacionista. Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress, Bain Collection"
    },
    {
        "pessoa_ids": ["pub_edison_charles"],
        "folder": imagens_base / "revolucao-cientifica" / "edison" / "Charles_Edison",
        "file_name": "01_Charles_Edison.jpg",
        "commons_file": "File:Charles Edison.jpg",
        "title": "Charles Edison, 42º Governador de Nova Jersey e Secretário da Marinha",
        "artist": "Harris & Ewing Photographers",
        "role": "fotógrafo",
        "date_created": "c. 1940",
        "museum": "Library of Congress, Harris & Ewing Collection",
        "formatted_description": "Retrato oficial de Charles Edison, estadista, Secretário da Marinha dos EUA e Governador de Nova Jersey. Acervo: Library of Congress.",
        "license": "Public domain",
        "source": "Library of Congress, Prints and Photographs Division"
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
    redimensionando se for gigantesca (ex: 50MB) para no máximo 1920px,
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
    print("=" * 70)
    print("ELO TEMPO: CURADORIA BATCH 14 - BRASIL ILUSTRE & REVOLUÇÃO CIENTÍFICA")
    print("=" * 70)
    print(f"Total de obras a processar: {len(OBRAS_BATCH14)}")
    print(f"Banco de dados: {db_path}")
    print(f"Pasta de Mídia: {midia_dir}")
    print(f"Base de Imagens: {imagens_base}\n")

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_sucesso = 0
    total_vinculos = 0

    for i, item in enumerate(OBRAS_BATCH14, 1):
        print(f"\n[{i:02d}/{len(OBRAS_BATCH14):02d}] {item['title']}")
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
                resp = session.get(url, timeout=45)
                if resp.status_code == 200 and len(resp.content) > 5000:
                    raw_bytes = resp.content
                    print(f"    ✓ Download concluído: {len(raw_bytes):,} bytes originais.")
                    
                    # Otimização inteligente (converte TIFF e PNGs de 50MB para alta definição compacta)
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

    print("\n" + "=" * 70)
    print(f"CURADORIA BATCH 14 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {total_sucesso}/{len(OBRAS_BATCH14)}")
    print(f"Total de pessoas vinculadas com fotos atualizadas: {total_vinculos}")
    print("=" * 70)


if __name__ == "__main__":
    executar_curadoria()
