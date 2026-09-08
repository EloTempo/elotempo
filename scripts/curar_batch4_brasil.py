"""
EloTempo - Curadoria de Obras Clássicas: Batch 4 (História do Brasil & Presidentes)
==================================================================================
Baixa e cadastra com metadados de mestres da arte brasileira e retratos oficiais de Estado:
- Independência 1822: José Bonifácio (Oscar Pereira da Silva), Leopoldina, Maria Quitéria (Failutti),
  Marquesa de Santos (Scholze), Joaquim Gonçalves Ledo, Carlota Joaquina (Sequeira)
- Império do Brasil: D. Pedro II (Pedro Américo), Imperatriz Teresa Cristina, Princesa Isabel (1887), Conde d'Eu
- Presidentes da República: Marechal Deodoro (Antonio Felix da Costa), Getúlio Vargas (1930), Juscelino Kubitschek (Faixa Presidencial)
- Diplomatas & Patronos: Visconde do Rio Branco (1879)
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; brazilian history; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

BATCH4_OBRAS = [
    {
        "pessoa_ids": ["pub_jose_bonifacio"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "José_Bonifácio",
        "file_name": "01_José_Bonifácio.jpg",
        "commons_file": "File:Oscar Pereira da Silva - Retrato de José Bonifácio de Andrada e Silva, Acervo do Museu Paulista da USP.jpg",
        "title": "José Bonifácio de Andrada e Silva, o Patriarca da Independência",
        "artist": "Oscar Pereira da Silva",
        "role": "pintor",
        "date_created": "1922",
        "museum": "Museu Paulista da USP (Museu do Ipiranga), São Paulo",
        "formatted_description": "Pintura a óleo por Oscar Pereira da Silva (1922). Acervo: Museu Paulista da USP.",
        "license": "CC BY-SA 4.0",
        "source": "Museu Paulista da Universidade de São Paulo"
    },
    {
        "pessoa_ids": ["pub_leopoldina"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Maria_Leopoldina",
        "file_name": "01_Maria_Leopoldina.jpg",
        "commons_file": "File:Retrato de D. Maria Leopoldina de Habsburgo.jpg",
        "title": "Imperatriz D. Maria Leopoldina do Brasil",
        "artist": "Pintor da Corte Imperial Brasileira",
        "role": "pintor",
        "date_created": "c. 1822",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato oficial da primeira Imperatriz do Brasil (c. 1822). Acervo: Museu Histórico Nacional, RJ.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; Império do Brasil"
    },
    {
        "pessoa_ids": ["pub_pedro2"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "D_Pedro_II",
        "file_name": "01_D_Pedro_II.jpg",
        "commons_file": "File:Pedro Américo - D. Pedro II na abertura da Assembléia Geral.jpg",
        "title": "D. Pedro II na Abertura da Assembleia Geral",
        "artist": "Pedro Américo",
        "role": "pintor",
        "date_created": "1872",
        "museum": "Museu Imperial de Petrópolis",
        "formatted_description": "Pintura monumental a óleo por Pedro Américo (1872). Acervo: Museu Imperial, Petrópolis.",
        "license": "Public domain",
        "source": "Museu Imperial de Petrópolis; IBRAM"
    },
    {
        "pessoa_ids": ["pub_isabel"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Princesa_Isabel",
        "file_name": "01_Princesa_Isabel.jpg",
        "commons_file": "File:Isabel, Princess Imperial of Brazil, c.1887.jpg",
        "title": "D. Isabel, Princesa Imperial do Brasil, a Redentora",
        "artist": "Retrato de Gabinete Imperial",
        "role": "fotógrafo",
        "date_created": "c. 1887",
        "museum": "Museu Imperial de Petrópolis / Coleção Família Imperial",
        "formatted_description": "Fotografia oficial de gabinete da Princesa Imperial D. Isabel (c. 1887). Acervo: Museu Imperial, Petrópolis.",
        "license": "Public domain",
        "source": "Museu Imperial de Petrópolis; Império do Brasil"
    },
    {
        "pessoa_ids": ["pub_teresa"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Teresa_Cristina",
        "file_name": "01_Teresa_Cristina.jpg",
        "commons_file": "File:Retrato da Imperatriz Teresa Cristina, 1875.jpg",
        "title": "Imperatriz Teresa Cristina das Duas Sicílias, Mãe dos Brasileiros",
        "artist": "Pintor da Real Câmara Imperial",
        "role": "pintor",
        "date_created": "1875",
        "museum": "Museu Imperial de Petrópolis",
        "formatted_description": "Retrato oficial da Imperatriz Teresa Cristina (1875). Acervo: Museu Imperial, Petrópolis.",
        "license": "Public domain",
        "source": "Museu Imperial; IBRAM"
    },
    {
        "pessoa_ids": ["pub_conde_deu"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Conde_dEu",
        "file_name": "01_Conde_dEu.jpg",
        "commons_file": "File:Conde d'Eu, da coleção Museu Histórico Nacional.jpg",
        "title": "Gastão de Orléans, Conde d'Eu",
        "artist": "Retrato Militar Imperial",
        "role": "fotógrafo",
        "date_created": "c. 1870",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato em farda de Marechal do Exército Brasileiro (c. 1870). Acervo: Museu Histórico Nacional, RJ.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; IBRAM"
    },
    {
        "pessoa_ids": ["pub_maria_quiteria"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Maria_Quitéria",
        "file_name": "01_Maria_Quitéria.jpg",
        "commons_file": "File:Domenico Failutti - Retrato de Maria Quitéria de Jesus Medeiros, Acervo do Museu Paulista da USP.jpg",
        "title": "Maria Quitéria de Jesus, Heroína da Independência",
        "artist": "Domenico Failutti",
        "role": "pintor",
        "date_created": "1920",
        "museum": "Museu Paulista da USP, São Paulo",
        "formatted_description": "Pintura a óleo por Domenico Failutti (1920) com base na gravura de Augustus Earle (1824). Acervo: Museu Paulista da USP.",
        "license": "CC BY-SA 4.0",
        "source": "Museu Paulista da Universidade de São Paulo"
    },
    {
        "pessoa_ids": ["pub_marquesa_santos"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Marquesa_de_Santos",
        "file_name": "01_Marquesa_de_Santos.jpg",
        "commons_file": "File:Scholze, Maximiliano - Retrato de Domitila de Castro Canto e Melo (Marquesa de Santos).jpg",
        "title": "Domitila de Castro Canto e Melo, Marquesa de Santos",
        "artist": "Maximiliano Scholze",
        "role": "pintor",
        "date_created": "séc. XIX",
        "museum": "Museu da Cidade de São Paulo / Solar da Marquesa",
        "formatted_description": "Pintura a óleo por Maximiliano Scholze. Acervo: Museu da Cidade de São Paulo.",
        "license": "Public domain",
        "source": "Museu da Cidade de São Paulo"
    },
    {
        "pessoa_ids": ["pub_goncalves_ledo"],
        "folder": imagens_base / "historia-brasil" / "independencia-1822" / "Gonçalves_Ledo",
        "file_name": "01_Gonçalves_Ledo.jpg",
        "commons_file": "File:Oscar Pereira da Silva - Retrato de Joaquim Gonçalves Ledo, Acervo do Museu Paulista da USP.jpg",
        "title": "Joaquim Gonçalves Ledo, Artífice da Independência",
        "artist": "Oscar Pereira da Silva",
        "role": "pintor",
        "date_created": "1925",
        "museum": "Museu Paulista da USP, São Paulo",
        "formatted_description": "Pintura por Oscar Pereira da Silva (1925). Acervo: Museu Paulista da USP.",
        "license": "CC BY-SA 4.0",
        "source": "Museu Paulista da Universidade de São Paulo"
    },
    {
        "pessoa_ids": ["pub_carlota", "pub_indep_carlota_joaquina"],
        "folder": imagens_base / "realeza-europeia" / "braganca" / "Carlota_Joaquina",
        "file_name": "01_Carlota_Joaquina.jpg",
        "commons_file": "File:Domingos Sequeira - D. Carlota Joaquina.jpg",
        "title": "Rainha D. Carlota Joaquina",
        "artist": "Domingos Sequeira",
        "role": "pintor",
        "date_created": "c. 1810",
        "museum": "Palácio Nacional de Queluz, Portugal",
        "formatted_description": "Pintura a óleo por Domingos Sequeira (c. 1810). Acervo: Palácio Nacional de Queluz.",
        "license": "Public domain",
        "source": "Palácio Nacional de Queluz; Parques de Sintra"
    },
    {
        "pessoa_ids": ["pub_deodoro"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Deodoro_da_Fonseca",
        "file_name": "01_Deodoro_da_Fonseca.jpg",
        "commons_file": "File:Antonio Felix da Costa - Retrato do Marechal Deodoro, 1890.jpg",
        "title": "Marechal Deodoro da Fonseca, 1º Presidente do Brasil",
        "artist": "Antônio Félix da Costa",
        "role": "pintor",
        "date_created": "1890",
        "museum": "Museu da República (Palácio do Catete), Rio de Janeiro",
        "formatted_description": "Pintura oficial de posse republicana por Antônio Félix da Costa (1890). Acervo: Museu da República, RJ.",
        "license": "Public domain",
        "source": "Museu da República; IBRAM"
    },
    {
        "pessoa_ids": ["pub_vargas"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Getúlio_Vargas",
        "file_name": "01_Getúlio_Vargas.jpg",
        "commons_file": "File:Getulio Vargas (1930) (cropped).jpg",
        "title": "Getúlio Dornelles Vargas, Presidente da República",
        "artist": "Fotografia Oficial de Estado",
        "role": "fotógrafo",
        "date_created": "1930",
        "museum": "Arquivo Nacional / CPDOC-FGV",
        "formatted_description": "Retrato oficial da Presidência da República (1930). Acervo: Arquivo Nacional, Rio de Janeiro.",
        "license": "Public domain",
        "source": "Arquivo Nacional do Brasil"
    },
    {
        "pessoa_ids": ["pub_jk"],
        "folder": imagens_base / "politicas" / "presidentes-brasil" / "Juscelino_Kubitschek",
        "file_name": "01_Juscelino_Kubitschek.jpg",
        "commons_file": "File:Juscelino Kubitschek com a faixa presidencial.jpg",
        "title": "Juscelino Kubitschek de Oliveira com a Faixa Presidencial",
        "artist": "Fotografia Oficial da Presidência da República",
        "role": "fotógrafo",
        "date_created": "1956",
        "museum": "Memorial JK, Brasília / Arquivo Nacional",
        "formatted_description": "Retrato oficial de Estado de Juscelino Kubitschek (1956). Acervo: Memorial JK / Arquivo Nacional.",
        "license": "Public domain",
        "source": "Presidência da República do Brasil / Memorial JK"
    },
    {
        "pessoa_ids": ["pub_rio_branco_jose_maria_da_silva_paranhos_visconde_do_rio_branco"],
        "folder": imagens_base / "brasileiras" / "rio-branco" / "Visconde_do_Rio_Branco",
        "file_name": "01_Visconde_do_Rio_Branco.jpg",
        "commons_file": "File:Visconde do Rio Branco 1879.jpg",
        "title": "José Maria da Silva Paranhos, Visconde do Rio Branco",
        "artist": "Fotografia de Gabinete do Império",
        "role": "fotógrafo",
        "date_created": "1879",
        "museum": "Museu Histórico Nacional, Rio de Janeiro",
        "formatted_description": "Retrato oficial de gabinete do Visconde do Rio Branco (1879). Acervo: Museu Histórico Nacional, RJ.",
        "license": "Public domain",
        "source": "Museu Histórico Nacional; Império do Brasil"
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


def executar_batch4():
    print("=" * 70)
    print(" EloTempo - Curadoria Batch 4: História do Brasil & Presidentes")
    print("=" * 70)

    session = requests.Session()
    session.headers.update(HEADERS)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    total_aplicados = 0

    for item in BATCH4_OBRAS:
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

    print(f"\n[Batch 4 Concluído] Total de vínculos aplicados: {total_aplicados}")


if __name__ == "__main__":
    executar_batch4()
