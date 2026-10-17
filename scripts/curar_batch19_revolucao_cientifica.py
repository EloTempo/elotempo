# -*- coding: utf-8 -*-
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
HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; scientific revolution; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo" / "revolucao-cientifica"

pasta_einstein = imagens_base / "einstein"
pasta_galileu = imagens_base / "galileu"
pasta_davinci = imagens_base / "da-vinci"
pasta_edison = imagens_base / "edison"
pasta_curie = imagens_base / "curie"
pasta_darwin = imagens_base / "darwin"

OBRAS_BATCH19 = [
    # -------------------------------------------------------------
    # 1. Família Einstein
    # -------------------------------------------------------------
    {
        "folder": pasta_einstein / "Hermann_Einstein",
        "file_name": "01_Hermann_Einstein.jpg",
        "title": "Hermann Einstein",
        "artist": "Fotógrafo de estúdio alemão",
        "role": "fotógrafo",
        "date_created": "c. 1890",
        "museum": "Albert Einstein Archives / Hebrew University of Jerusalem",
        "formatted_description": "Retrato de estúdio de Hermann Einstein (1847–1902), comerciante e pioneiro da eletrotécnica na Alemanha e Itália, pai de Albert Einstein.",
        "license": "Public domain",
        "source": "Albert Einstein Archives / Wikimedia Commons",
        "commons_file": "File:Hermann einstein.jpg",
        "pessoa_ids": ["pub_einstein_hermann"]
    },
    {
        "folder": pasta_einstein / "Maja_Einstein",
        "file_name": "01_Maja_Einstein.jpg",
        "title": "Maja Einstein (Maria Einstein-Winteler)",
        "artist": "Fotógrafo suíço",
        "role": "fotógrafo",
        "date_created": "c. 1905",
        "museum": "Albert Einstein Archives / Bern Historical Museum",
        "formatted_description": "Retrato de Maja Einstein (1881–1951), doutora em filologia românica pela Universidade de Berna e irmã confidente de Albert Einstein.",
        "license": "Public domain",
        "source": "Albert Einstein Archives / Wikimedia Commons",
        "commons_file": "File:Maja Einstein 1900s.jpg",
        "pessoa_ids": ["pub_einstein_maja"]
    },

    # -------------------------------------------------------------
    # 2. Família Galilei
    # -------------------------------------------------------------
    {
        "folder": pasta_galileu / "Vincenzo_Galilei",
        "file_name": "01_Vincenzo_Galilei.jpg",
        "title": "Vincenzo Galilei",
        "artist": "Gravador florentino / Gravura da Coleção de Música",
        "role": "gravador",
        "date_created": "c. 1585",
        "museum": "Bibliothèque nationale de France (BnF), Département de la Musique, Paris",
        "formatted_description": "Retrato gravado de Vincenzo Galilei (c. 1520–1591), laudista, compositor e teórico musical da Camerata Fiorentina, pai de Galileu Galilei.",
        "license": "Public domain",
        "source": "Bibliothèque nationale de France (Gallica) / Wikimedia Commons",
        "commons_file": "File:Vincenzo Galilei - btv1b84180922.jpg",
        "pessoa_ids": ["pub_galilei_vincenzo"]
    },
    {
        "folder": pasta_galileu / "Virginia_Galilei",
        "file_name": "01_Virginia_Galilei.jpg",
        "title": "Virginia Galilei (Suor Maria Celeste)",
        "artist": "Pintor toscano seiscentista",
        "role": "pintor",
        "date_created": "c. 1630",
        "museum": "Wellcome Collection, Londres / Convento de São Mateus em Arcetri",
        "formatted_description": "Retrato tradicionalmente identificado como Suor Maria Celeste (Virginia Galilei, 1600–1634), filha primogênita e dileta correspondente epistolar de Galileu.",
        "license": "Public domain",
        "source": "Wellcome Collection / Wikimedia Commons",
        "commons_file": "File:Suor maria celeste.jpg",
        "pessoa_ids": ["pub_galilei_virginia"]
    },

    # -------------------------------------------------------------
    # 3. Família da Vinci
    # -------------------------------------------------------------
    {
        "folder": pasta_davinci / "Francesco_Melzi",
        "file_name": "01_Francesco_Melzi.jpg",
        "title": "Francesco Melzi (Retrato de Jovem Nobre)",
        "artist": "Giovanni Antonio Boltraffio / Escola de Leonardo da Vinci",
        "role": "pintor",
        "date_created": "c. 1510",
        "museum": "Pinacoteca Ambrosiana, Milão",
        "formatted_description": "Retrato renascentista de Francesco Melzi (1491–1570), nobre milanês, dileto discípulo e guardião de todos os manuscritos e códices de Leonardo da Vinci.",
        "license": "Public domain",
        "source": "Pinacoteca Ambrosiana / Wikimedia Commons",
        "commons_file": "File:Melzi Boltraffio.jpg",
        "pessoa_ids": ["pub_davinci_melzi"]
    },
    {
        "folder": pasta_davinci / "Gian_Giacomo_Caprotti",
        "file_name": "01_Gian_Giacomo_Caprotti.jpg",
        "title": "Gian Giacomo Caprotti (Salai)",
        "artist": "Leonardo da Vinci",
        "role": "desenhista",
        "date_created": "c. 1500",
        "museum": "Royal Collection Trust, Castelo de Windsor",
        "formatted_description": "Estudo fisionômico em sanguínea de Salai (Gian Giacomo Caprotti, c. 1480–1524), assistente, pupilo e modelo favorito de Leonardo por 25 anos.",
        "license": "Public domain",
        "source": "Royal Collection Trust / Wikimedia Commons",
        "commons_file": "File:Leonardo Salai.JPG",
        "pessoa_ids": ["pub_davinci_salai"]
    },

    # -------------------------------------------------------------
    # 4. Família Edison
    # -------------------------------------------------------------
    {
        "folder": pasta_edison / "Nancy_Elliott_Edison",
        "file_name": "01_Nancy_Elliott_Edison.jpg",
        "title": "Nancy Matthews Elliott Edison",
        "artist": "Fotógrafo de estúdio norte-americano",
        "role": "fotógrafo",
        "date_created": "c. 1865",
        "museum": "Library of Congress, Washington, D.C.",
        "formatted_description": "Retrato histórico de Nancy Matthews Elliott Edison (1810–1871), educadora e mãe de Thomas Edison, responsável pela formação autodidata do gênio.",
        "license": "Public domain (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Nancy Elliot - mother of T.A. Edison LCCN93508597.jpg",
        "pessoa_ids": ["pub_edison_nancy"]
    },
    {
        "folder": pasta_edison / "Mary_Stilwell_Edison",
        "file_name": "01_Mary_Stilwell_Edison.jpg",
        "title": "Mary Stilwell Edison",
        "artist": "Fotografia de estúdio de Newark",
        "role": "fotógrafo",
        "date_created": "c. 1875",
        "museum": "Thomas Edison National Historical Park, National Park Service, West Orange",
        "formatted_description": "Retrato de gabinete de Mary Stilwell Edison (1855–1884), primeira esposa de Thomas Edison e mãe de Marion, Thomas Jr. e William.",
        "license": "Public domain (National Park Service)",
        "source": "National Park Service / Wikimedia Commons",
        "commons_file": "File:Portrait of Mary Stilwell Edison. (6e69347ffcd345668b2a722b2b7491e4).jpg",
        "pessoa_ids": ["pub_edison_mary_stilwell"]
    },
    {
        "folder": pasta_edison / "Thomas_Edison_Jr",
        "file_name": "01_Thomas_Edison_Jr.jpg",
        "title": "Thomas Alva Edison Jr. (Dash)",
        "artist": "Fotógrafo de estúdio de Nova York",
        "role": "fotógrafo",
        "date_created": "c. 1895",
        "museum": "Library of Congress, Washington, D.C.",
        "formatted_description": "Retrato a três quartos de Thomas Alva Edison Jr. (1876–1935), primeiro filho homem de Thomas Edison, engenheiro e inventor elétrico.",
        "license": "Public domain (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Thomas A. Edison, Jr., three-quarter length portrait, facing slightly left LCCN93510884.jpg",
        "pessoa_ids": ["pub_edison_thomas_jr"]
    },
    {
        "folder": pasta_edison / "Marion_Estelle_Edison",
        "file_name": "01_Marion_Estelle_Edison.jpg",
        "title": "Marion Estelle Edison (Dot)",
        "artist": "Fotógrafo de estúdio",
        "role": "fotógrafo",
        "date_created": "c. 1888",
        "museum": "Thomas Edison National Historical Park, West Orange",
        "formatted_description": "Retrato fotográfico de Marion Estelle Edison Oeser (1873–1965), filha primogênita carinhosamente apelidada de Dot por Thomas Edison.",
        "license": "Public domain (National Park Service)",
        "source": "National Park Service / Wikimedia Commons",
        "commons_file": "File:Marion Estelle Edison. (c4f21134773c4f74b85798e4786ae8a1).jpg",
        "pessoa_ids": ["pub_edison_marion"]
    },

    # -------------------------------------------------------------
    # 5. Família Curie / Joliot-Curie
    # -------------------------------------------------------------
    {
        "folder": pasta_curie / "Eve_Curie",
        "file_name": "01_Eve_Curie.jpg",
        "title": "Ève Curie (1943)",
        "artist": "Fotógrafo oficial dos Aliados / Imprensa francesa livre",
        "role": "fotógrafo",
        "date_created": "1943",
        "museum": "Musée Curie / Institut Curie, Paris",
        "formatted_description": "Retrato de Ève Curie (1904–2007), escritora, pianista, correspondente de guerra e biógrafa de Marie Curie, conselheira da OTAN e UNICEF.",
        "license": "Public domain",
        "source": "Musée Curie / Wikimedia Commons",
        "commons_file": "File:Ève Curie (1943).jpg",
        "pessoa_ids": ["pub_curie_eve_curie"]
    },
    {
        "folder": pasta_curie / "Pierre_Joliot",
        "file_name": "01_Pierre_Joliot.jpg",
        "title": "Pierre Joliot, Membro da Academia das Ciências",
        "artist": "Fotógrafo oficial do CNRS / Collège de France",
        "role": "fotógrafo",
        "date_created": "c. 2005",
        "museum": "Académie des Sciences / Collège de France, Paris",
        "formatted_description": "Retrato de Pierre Joliot (n. 1932), biólogo celular francês, professor honorário do Collège de France e decano do Institut de Biologie Physico-Chimique.",
        "license": "Creative Commons Attribution-Share Alike 4.0 International",
        "source": "Académie des Sciences / Wikimedia Commons",
        "commons_file": "File:Pierre Joliot.jpg",
        "pessoa_ids": ["pub_curie_pierre_joliot"]
    },

    # -------------------------------------------------------------
    # 6. Família Darwin-Wedgwood
    # -------------------------------------------------------------
    {
        "folder": pasta_darwin / "Erasmus_Darwin",
        "file_name": "01_Erasmus_Darwin.jpg",
        "title": "Erasmus Darwin",
        "artist": "Joseph Wright of Derby",
        "role": "pintor",
        "date_created": "1792",
        "museum": "Birmingham Museum and Art Gallery / National Portrait Gallery, Londres",
        "formatted_description": "Retrato a óleo de Erasmus Darwin (1731–1802), médico, filósofo natural, poeta, cofundador da Lunar Society e avô de Charles Darwin.",
        "license": "Public domain",
        "source": "Birmingham Museum and Art Gallery / Wikimedia Commons",
        "commons_file": "File:Portrait of Erasmus Darwin by Joseph Wright of Derby (1792).jpg",
        "pessoa_ids": ["pub_darwin_erasmus_darwin"]
    },
    {
        "folder": pasta_darwin / "Robert_Waring_Darwin",
        "file_name": "01_Robert_Waring_Darwin.jpg",
        "title": "Dr. Robert Waring Darwin F.R.S.",
        "artist": "Gravador britânico a partir de pintura a óleo",
        "role": "gravador",
        "date_created": "c. 1825",
        "museum": "Wellcome Collection, Londres",
        "formatted_description": "Retrato de gabinete do Dr. Robert Waring Darwin (1766–1848), médico respeitado de Shrewsbury, membro da Royal Society e pai de Charles Darwin.",
        "license": "Public domain",
        "source": "Wellcome Collection / Wikimedia Commons",
        "commons_file": "File:Portrait of Robert Waring Darwin (1766 - 1848) Wellcome L0001575.jpg",
        "pessoa_ids": ["pub_darwin_robert_waring_darwin"]
    },
    {
        "folder": pasta_darwin / "Susannah_Darwin",
        "file_name": "01_Susannah_Darwin.jpg",
        "title": "Susannah Wedgwood Darwin",
        "artist": "Peter Paillou the younger",
        "role": "pintor miniaturista",
        "date_created": "c. 1795",
        "museum": "Fitzwilliam Museum, Universidade de Cambridge",
        "formatted_description": "Miniatura em marfim de Susannah Wedgwood (1765–1817), filha primogênita do ceramista Josiah Wedgwood I e mãe de Charles Darwin.",
        "license": "Public domain",
        "source": "Fitzwilliam Museum / Wikimedia Commons",
        "commons_file": "File:Peter Paillou the younger (1757-c.1832) - Susannah Wedgwood (1765–1817), Mother of Charles Darwin - PD.26-2010 - Fitzwilliam Museum.jpg",
        "pessoa_ids": ["pub_darwin_susannah_darwin"]
    },
    {
        "folder": pasta_darwin / "George_Howard_Darwin",
        "file_name": "01_George_Howard_Darwin.jpg",
        "title": "Sir George Howard Darwin F.R.S.",
        "artist": "Fotógrafo de estúdio de Cambridge",
        "role": "fotógrafo",
        "date_created": "c. 1900",
        "museum": "Trinity College, Cambridge / Smithsonian Institution",
        "formatted_description": "Retrato oficial em tom sépia de Sir George Howard Darwin (1845–1912), Plumian Professor de Astronomia em Cambridge e pioneiro do estudo das marés e órbita lunar.",
        "license": "Public domain",
        "source": "Smithsonian Institution Archives / Wikimedia Commons",
        "commons_file": "File:George Darwin sepia tone.jpg",
        "pessoa_ids": ["pub_darwin_george_howard_darwin"]
    },
    {
        "folder": pasta_darwin / "Francis_Darwin",
        "file_name": "01_Francis_Darwin.png",
        "title": "Sir Francis Darwin F.R.S.",
        "artist": "Sir William Rothenstein",
        "role": "desenhista",
        "date_created": "1903",
        "museum": "National Portrait Gallery, Londres",
        "formatted_description": "Desenho em giz de Sir Francis Darwin (1848–1925), botânico e fisiologista vegetal da Universidade de Cambridge, colaborador e biógrafo de Charles Darwin.",
        "license": "Public domain",
        "source": "National Portrait Gallery / Wikimedia Commons",
        "commons_file": "File:Francis Darwin - Rothenstein chalk drawing.png",
        "pessoa_ids": ["pub_darwin_francis_darwin"]
    },
    {
        "folder": pasta_darwin / "Leonard_Darwin",
        "file_name": "01_Leonard_Darwin.jpg",
        "title": "Major Leonard Darwin",
        "artist": "Harris & Ewing / Bain News Service",
        "role": "fotógrafo",
        "date_created": "c. 1915",
        "museum": "Library of Congress, Washington, D.C.",
        "formatted_description": "Retrato oficial do Major Leonard Darwin (1850–1943), oficial engenheiro do Exército Britânico, presidente da Royal Geographical Society e mentor de R.A. Fisher.",
        "license": "Public domain (Library of Congress)",
        "source": "Library of Congress / Wikimedia Commons",
        "commons_file": "File:Major Leonard Darwin LCCN2014687269.jpg",
        "pessoa_ids": ["pub_darwin_leonard_darwin"]
    },
    {
        "folder": pasta_darwin / "Horace_Darwin",
        "file_name": "01_Horace_Darwin.jpg",
        "title": "Sir Horace Darwin, Prefeito de Cambridge",
        "artist": "Fotógrafo de imprensa de Cambridge",
        "role": "fotógrafo",
        "date_created": "1897",
        "museum": "Cambridge City Council Archives / Cambridge Scientific Instrument Company",
        "formatted_description": "Retrato oficial de Sir Horace Darwin (1851–1928), engenheiro civil, prefeito de Cambridge e fundador da Cambridge Scientific Instrument Company.",
        "license": "Public domain",
        "source": "Cambridge Archives / Wikimedia Commons",
        "commons_file": "File:Horace Darwin Mayor 1897.jpg",
        "pessoa_ids": ["pub_darwin_horace_darwin"]
    }
]

def resolver_url_commons(session, commons_file):
    params = {
        "action": "query",
        "titles": commons_file,
        "prop": "imageinfo",
        "iiprop": "url|size",
        "format": "json"
    }
    try:
        r = session.get(COMMONS_API, params=params, timeout=30)
        data = r.json()
        pages = data.get("query", {}).get("pages", {})
        for _, page in pages.items():
            if "imageinfo" in page and len(page["imageinfo"]) > 0:
                return page["imageinfo"][0].get("url")
    except Exception as e:
        print(f"    [Erro API Commons]: {e}")
    return None

def otimizar_imagem(raw_bytes, max_dim=1920):
    img = Image.open(BytesIO(raw_bytes))
    if img.mode in ("RGBA", "P"):
        if img.mode == "RGBA":
            img.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
            out = BytesIO()
            img.save(out, format="PNG", optimize=True)
            return out.getvalue(), ".png"
        img = img.convert("RGB")
    elif img.mode != "RGB":
        img = img.convert("RGB")

    img.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
    out = BytesIO()
    img.save(out, format="JPEG", quality=95, optimize=True)
    return out.getvalue(), ".jpg"

def main():
    print("=" * 75)
    print("CURADORIA ARQUIVÍSTICA SCHEMA v4.0 - BATCH 19: REVOLUÇÃO CIENTÍFICA")
    print("=" * 75)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    session = requests.Session()
    session.headers.update(HEADERS)

    total_obras = len(OBRAS_BATCH19)
    sucessos = 0

    for idx, item in enumerate(OBRAS_BATCH19, 1):
        print(f"\n[{idx}/{total_obras}] {item['title']}")
        print(f"  commons_file: {item['commons_file']}")

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

            print(f"  Baixando imagem institucional ({url.split('/')[-1][:50]}...)...\n")
            time.sleep(1.0)

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
    print("CURADORIA BATCH 19 CONCLUÍDA COM SUCESSO!")
    print(f"Total de obras inseridas: {sucessos}/{total_obras}")
    print("=" * 75)

if __name__ == "__main__":
    main()