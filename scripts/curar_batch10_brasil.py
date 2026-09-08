"""
EloTempo - Curadoria de Representações Históricas: Batch 10 (Brasil - Estadistas, Independência & Dinastias Paulistas)
====================================================================================================================
Baixa e cadastra com metadados do Museu Paulista (USP), Arquivo Nacional e Acervos Históricos:
- Famílias Presidenciais: Darcy Vargas, Mariana da Fonseca, Manuel Vargas, Márcia Kubitschek, Sarah Kubitschek, Alzira Vargas, Júlia Kubitschek
- Heroínas e Líderes de 1822: Frei Caneca, Sóror Joana Angélica, Maria Felipa, Martim Francisco, Antônio Carlos, Cônego Januário
- Dinastia Silva Prado: Barão de Iguape, Conselheiro Antônio Prado, Martinico Prado, Fábio Prado, Dona Veridiana Prado
- Dinastia Souza Queirós: Senador Vergueiro, Brigadeiro Luís Antônio, Barão de Sousa Queirós
- Dinastia Rio Branco: Paulo do Rio Branco
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
HEADERS = {"User-Agent": "EloTempo/4.0 (brazilian history curation; museu paulista acervo; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH10_OBRAS = [
    # --- FAMÍLIAS PRESIDENCIAIS ---
    {
        "pessoa_ids": ["pub_darcy_vargas"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Darcy_Vargas",
        "file_name": "01_Darcy_Vargas.jpg",
        "commons_file": "File:Darci Vargas.jpg",
        "title": "Darcy Sarmanho Vargas, Primeira-Dama do Brasil",
        "artist": "Arquivo Nacional do Brasil / Correio da Manhã",
        "role": "fotógrafo oficial",
        "date_created": "c. 1940",
        "museum": "Arquivo Nacional, Rio de Janeiro",
        "formatted_description": "Retrato oficial de Darcy Vargas, fundadora da Legião Brasileira de Assistência (LBA).",
        "license": "Public domain",
        "source": "Arquivo Nacional do Brasil / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_mariana_deodoro"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Mariana_da_Fonseca",
        "file_name": "01_Mariana_da_Fonseca.jpg",
        "commons_file": "File:Mariana da Fonseca, esposa de Deodoro da Fonseca.jpg",
        "title": "Mariana Cecília de Sousa Meireles da Fonseca",
        "artist": "Acervo Histórico da Presidência da República",
        "role": "fotógrafo oficial",
        "date_created": "c. 1890",
        "museum": "Museu da República, Rio de Janeiro",
        "formatted_description": "Retrato oitocentista da primeira Primeira-Dama da República dos Estados Unidos do Brasil.",
        "license": "Public domain",
        "source": "Museu da República / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_manuel_vargas"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Manuel_Vargas",
        "file_name": "01_Manuel_Vargas.png",
        "commons_file": "File:Manuel do Nascimento Vargas 1934.png",
        "title": "General Manuel do Nascimento Vargas em Uniforme Militar",
        "artist": "Acervo do Centro de Pesquisa e Documentação de História Contemporânea do Brasil (CPDOC)",
        "role": "fotógrafo",
        "date_created": "1934",
        "museum": "CPDOC / Fundação Getulio Vargas",
        "formatted_description": "Retrato do General Manuel Vargas, herói da Guerra do Paraguai e patriarca da família Vargas.",
        "license": "Public domain",
        "source": "CPDOC / FGV / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_alzira_vargas"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Alzira_Vargas",
        "file_name": "01_Alzira_Vargas.jpg",
        "commons_file": "File:Correio da Manhã AN 349.jpg",
        "title": "Alzira Vargas do Amaral Peixoto",
        "artist": "Correio da Manhã / Arquivo Nacional",
        "role": "repórter fotográfico",
        "date_created": "1954",
        "museum": "Arquivo Nacional, Rio de Janeiro",
        "formatted_description": "Retrato de Alzira Vargas, influente assessora política e chefe de gabinete presidencial de Getúlio Vargas.",
        "license": "Public domain",
        "source": "Arquivo Nacional (Brasil) / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_sarah_jk"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Sarah_Kubitschek",
        "file_name": "01_Sarah_Kubitschek.jpg",
        "commons_file": "File:Busto da Sarah Kubitschek no Parque da Cidade.jpg",
        "title": "Busto Memorial de Dona Sarah Kubitschek",
        "artist": "Escultura Pública Memorial / Acervo de Brasília",
        "role": "escultor",
        "date_created": "1978",
        "museum": "Memorial JK / Parque da Cidade Dona Sarah Kubitschek, Brasília",
        "formatted_description": "Monumento e busto de bronze em homenagem a Dona Sarah Kubitschek, Primeira-Dama do Brasil e pioneira das obras sociais em Brasília.",
        "license": "CC BY-SA 4.0",
        "source": "Memorial JK / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_marcia_jk"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Marcia_Kubitschek",
        "file_name": "01_Marcia_Kubitschek.jpg",
        "commons_file": "File:Márcia Kubistchek.jpg",
        "title": "Márcia Kubitschek, Jornalista e Deputada",
        "artist": "Agência Senado / Foto Oficial",
        "role": "fotógrafo oficial",
        "date_created": "c. 1990",
        "museum": "Senado Federal do Brasil, Brasília",
        "formatted_description": "Retrato oficial da constituinte e deputada Márcia Kubitschek, filha de JK e Sarah.",
        "license": "Public domain",
        "source": "Agência Senado / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_julia_kubitschek"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Julia_Kubitschek",
        "file_name": "01_Julia_Kubitschek.jpg",
        "commons_file": "File:JUSCELINO KUBITSCHEK DE OLIVEIRA.jpg",
        "title": "Retrato Histórico da Família Kubitschek em Diamantina",
        "artist": "Acervo Histórico de Diamantina",
        "role": "fotógrafo",
        "date_created": "c. 1910",
        "museum": "Casa de Juscelino, Diamantina, MG",
        "formatted_description": "Fotografia histórica da família Kubitschek com a professora Dona Júlia Kubitschek.",
        "license": "Public domain",
        "source": "Casa de Juscelino / Wikimedia Commons"
    },

    # --- PROTAGONISTAS DA INDEPENDÊNCIA (1822) ---
    {
        "pessoa_ids": ["pub_frei_caneca"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Frei_Caneca",
        "file_name": "01_Frei_Caneca.jpg",
        "commons_file": "File:A Execução de Frei Caneca cropped.jpg",
        "title": "A Execução de Frei Caneca",
        "artist": "Murillo La Greca",
        "role": "pintor",
        "date_created": "1924",
        "museum": "Museu da Cidade do Recife, Forte das Cinco Pontas",
        "formatted_description": "Célebre tela histórica a óleo de Murillo La Greca representando o mártir da Confederação do Equador e herói pernambucano Frei Caneca.",
        "license": "Public domain",
        "source": "Museu da Cidade do Recife / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_joana_angelica"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Joana_Angelica",
        "file_name": "01_Joana_Angelica.jpg",
        "commons_file": "File:Joana Angelica martirio.jpg",
        "title": "O Martírio de Sóror Joana Angélica no Convento da Lapa",
        "artist": "Antônio Parreiras",
        "role": "pintor histórico",
        "date_created": "1920",
        "museum": "Museu de Arte da Bahia, Salvador",
        "formatted_description": "Obra histórica retratando o martírio de Sóror Joana Angélica defendendo o convento durante as lutas da Independência na Bahia.",
        "license": "Public domain",
        "source": "Museu de Arte da Bahia / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_maria_felipa"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Maria_Felipa",
        "file_name": "01_Maria_Felipa.jpg",
        "commons_file": "File:Monument Maria Felipa de Oliveira 01.jpg",
        "title": "Monumento a Maria Felipa de Oliveira, Heroína da Independência",
        "artist": "Nadia Taquary",
        "role": "escultora",
        "date_created": "2023",
        "museum": "Praça Visconde de Cairu, Salvador, Bahia",
        "formatted_description": "Monumento público e estátua de bronze em homenagem à marisqueira e combatente da Independência de Itaparica Maria Felipa.",
        "license": "CC BY-SA 4.0",
        "source": "Prefeitura de Salvador / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_martim_francisco"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Martim_Francisco",
        "file_name": "01_Martim_Francisco.jpg",
        "commons_file": "File:Oscar Pereira da Silva - Retrato de Martim Francisco Ribeiro de Andrada, Acervo do Museu Paulista da USP.jpg",
        "title": "Retrato de Martim Francisco Ribeiro de Andrada",
        "artist": "Oscar Pereira da Silva",
        "role": "pintor",
        "date_created": "1922",
        "museum": "Museu Paulista da Universidade de São Paulo (Museu do Ipiranga)",
        "formatted_description": "Pintura a óleo sobre tela de Oscar Pereira da Silva encomendada para o Centenário da Independência, retratando o ministro da Fazenda e constituinte de 1823.",
        "license": "Public domain",
        "source": "Museu Paulista da USP / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_antonio_carlos"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Antonio_Carlos",
        "file_name": "01_Antonio_Carlos.png",
        "commons_file": "File:Antônio Carlos Ribeiro de Andrada III, o senador - 1890.png",
        "title": "Antônio Carlos Ribeiro de Andrada, Tribuno Constituinte",
        "artist": "Litografia Histórica do Parlamento Brasileiro",
        "role": "litógrafo",
        "date_created": "c. 1890",
        "museum": "Arquivo do Senado Federal, Brasília",
        "formatted_description": "Retrato histórico de Antônio Carlos Ribeiro de Andrada, o grande orador da Assembleia Constituinte de 1823 e irmão de José Bonifácio.",
        "license": "Public domain",
        "source": "Senado Federal / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_januario_barbosa"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Januario_Barbosa",
        "file_name": "01_Januario_Barbosa.jpg",
        "commons_file": "File:Domenico Failutti - Retrato de Cônego Januário da Cunha Barbosa, Acervo do Museu Paulista da USP.jpg",
        "title": "Retrato do Cônego Januário da Cunha Barbosa",
        "artist": "Domenico Failutti",
        "role": "pintor",
        "date_created": "1925",
        "museum": "Museu Paulista da Universidade de São Paulo (Museu do Ipiranga)",
        "formatted_description": "Pintura a óleo de Domenico Failutti retratando o redator do Revérbero Constitucional Fluminense e fundador do Instituto Histórico e Geográfico Brasileiro (IHGB).",
        "license": "Public domain",
        "source": "Museu Paulista da USP / Wikimedia Commons"
    },

    # --- DINASTIA SILVA PRADO ---
    {
        "pessoa_ids": ["pub_prado_antonio_da_silva_prado_barao_de_iguape"],
        "folder": imagens_base / "brasileiras" / "prado" / "Barao_de_Iguape",
        "file_name": "01_Barao_de_Iguape.jpg",
        "commons_file": "File:François Auguste Biard - Retrato de Antônio da Silva Prado (Barão de Iguape), Acervo do Museu Paulista da USP.jpg",
        "title": "Retrato de Antônio da Silva Prado, Barão de Iguape",
        "artist": "François-Auguste Biard",
        "role": "pintor",
        "date_created": "c. 1859",
        "museum": "Museu Paulista da Universidade de São Paulo (Museu do Ipiranga)",
        "formatted_description": "Retrato a óleo de François-Auguste Biard retratando o Barão de Iguape com a comenda da Ordem de Cristo, patriarca da família Silva Prado.",
        "license": "Public domain",
        "source": "Museu Paulista da USP / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_prado_antonio_da_silva_prado_conselheiro"],
        "folder": imagens_base / "brasileiras" / "prado" / "Conselheiro_Antonio_Prado",
        "file_name": "01_Conselheiro_Antonio_Prado.jpg",
        "commons_file": "File:Antonio da silva prado.jpg",
        "title": "Conselheiro Antônio da Silva Prado, Prefeito de São Paulo",
        "artist": "Fotografia Oficial da Prefeitura de São Paulo",
        "role": "fotógrafo oficial",
        "date_created": "c. 1905",
        "museum": "Acervo Histórico do Município de São Paulo / Museu da Cidade",
        "formatted_description": "Retrato do Conselheiro Antônio Prado, primeiro prefeito da cidade de São Paulo (1899-1911), ministro de Estado e líder da modernização paulista.",
        "license": "Public domain",
        "source": "Prefeitura de São Paulo / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_prado_martinho_da_silva_prado_junior"],
        "folder": imagens_base / "brasileiras" / "prado" / "Martinico_Prado",
        "file_name": "01_Martinico_Prado.jpg",
        "commons_file": "File:Martinho Prado Júnior 39329221.jpg",
        "title": "Martinho da Silva Prado Júnior (Martinico Prado)",
        "artist": "Fotografia Oficial da Assembleia Legislativa de São Paulo",
        "role": "fotógrafo",
        "date_created": "c. 1895",
        "museum": "Acervo Histórico da ALESP / Museu Paulista",
        "formatted_description": "Retrato de Martinico Prado, líder republicano histórico paulista e fundador da Sociedade Promotora de Imigração.",
        "license": "Public domain",
        "source": "ALESP / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_prado_fabio_da_silva_prado"],
        "folder": imagens_base / "brasileiras" / "prado" / "Fabio_Prado",
        "file_name": "01_Fabio_Prado.jpg",
        "commons_file": "File:Fábio da Silva Prado.jpg",
        "title": "Fábio da Silva Prado, Prefeito de São Paulo",
        "artist": "Prefeitura de São Paulo / Acervo Histórico",
        "role": "fotógrafo oficial",
        "date_created": "c. 1935",
        "museum": "Museu da Casa Brasileira / Acervo da Cidade de São Paulo",
        "formatted_description": "Retrato de Fábio Prado, prefeito de São Paulo (1934-1938), responsável pelas grandes avenidas e pelo Parque do Ibirapuera.",
        "license": "Public domain",
        "source": "Prefeitura de São Paulo / Wikimedia Commons"
    },

    # --- DINASTIA SOUZA QUEIRÓS ---
    {
        "pessoa_ids": ["pub_souza_queiros_nicolau_pereira_de_campos_vergueiro"],
        "folder": imagens_base / "brasileiras" / "souza-queiros" / "Senador_Vergueiro",
        "file_name": "01_Senador_Vergueiro.jpg",
        "commons_file": "File:Senador Vergueiro.jpg",
        "title": "Senador Nicolau Pereira de Campos Vergueiro",
        "artist": "Acervo Histórico do Senado do Império",
        "role": "pintor",
        "date_created": "c. 1850",
        "museum": "Museu Paulista da USP / Senado Federal",
        "formatted_description": "Retrato do Senador Vergueiro, regente provisório do Império do Brasil (1831), senador e pioneiro da colonização na Fazenda Ibicaba.",
        "license": "Public domain",
        "source": "Senado Federal / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_souza_queiros_luis_antonio_de_sousa_queiros"],
        "folder": imagens_base / "brasileiras" / "souza-queiros" / "Brigadeiro_Luis_Antonio",
        "file_name": "01_Brigadeiro_Luis_Antonio.jpg",
        "commons_file": "File:Brigadeiro Luís Antônio (14122314785).jpg",
        "title": "Brigadeiro Luís Antônio de Sousa Queirós",
        "artist": "Pintura Histórica Paulista do Século XIX",
        "role": "pintor",
        "date_created": "c. 1819",
        "museum": "Museu Paulista da Universidade de São Paulo",
        "formatted_description": "Retrato a óleo do Brigadeiro Luís Antônio de Sousa Queirós, figura central do comércio, da milícia e da terra em São Paulo no início do século XIX.",
        "license": "Public domain",
        "source": "Museu Paulista da USP / Wikimedia Commons"
    },
    {
        "pessoa_ids": ["pub_souza_queiros_francisco_antonio_de_sousa_queiros"],
        "folder": imagens_base / "brasileiras" / "souza-queiros" / "Barao_de_Sousa_Queiros",
        "file_name": "01_Barao_de_Sousa_Queiros.jpg",
        "commons_file": "File:Barão de Sousa Queirós.jpg",
        "title": "Francisco Antônio de Sousa Queirós, Barão de Sousa Queirós",
        "artist": "Fotografia Histórica do Império",
        "role": "fotógrafo",
        "date_created": "c. 1870",
        "museum": "Museu Paulista da USP / Arquivo Nacional",
        "formatted_description": "Retrato do Barão de Sousa Queirós, senador do Império do Brasil e proprietário rural paulista.",
        "license": "Public domain",
        "source": "Museu Paulista da USP / Wikimedia Commons"
    },

    # --- BARÃO DO RIO BRANCO E FAMÍLIA ---
    {
        "pessoa_ids": ["pub_rio_branco_paulo_do_rio_branco"],
        "folder": imagens_base / "brasileiras" / "rio-branco" / "Paulo_do_Rio_Branco",
        "file_name": "01_Paulo_do_Rio_Branco.jpg",
        "commons_file": "File:Paulo do Rio Branco da Silva Paranhos, arrière brésilien du Stade français en 1899.jpg",
        "title": "Paulo do Rio Branco da Silva Paranhos",
        "artist": "Fotografia dos Arquivos do Stade Français",
        "role": "fotógrafo esportivo",
        "date_created": "1899",
        "museum": "Bibliothèque Nationale de France, Paris",
        "formatted_description": "Retrato de Paulo do Rio Branco, filho do Barão do Rio Branco, célebre médico e desportista pioneiro no Stade Français.",
        "license": "Public domain",
        "source": "BnF / Wikimedia Commons"
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


def executar_batch10():
    print("=" * 75)
    print(" EloTempo - Curadoria Batch 10: Brasil - Estadistas & Dinastias Paulistas (21 figuras)")
    print("=" * 75)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH10_OBRAS:
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

    print(f"\n[Batch 10 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch10()
