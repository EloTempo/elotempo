"""
EloTempo - Curadoria e Aplicação de Obras de Arte Clássica (Mestres)
===================================================================
1. Remove imagens anacrônicas incorretas (ex.: Rebeca Grynspan da ONU).
2. Baixa pinturas e afrescos autênticos dos maiores mestres da história
   (Poussin, Tiepolo, Michelangelo, Cranach, Ticiano, Bouguereau, Pourbus,
   Rubens, Velázquez, Rigaud, Meléndez, Callet).
3. Gera metadados de obra de arte (pintor, data, museu, técnica, licença).
4. Insere em `documentos` e `documento_vinculos`.
5. Substitui `pessoas.foto_url` para as personalidades públicas da antiguidade
   e realeza, exibindo os retratos oficiais com metadados completos no app.
"""

import os
import sys
import json
import uuid
import shutil
import sqlite3
import requests
from datetime import datetime, timezone
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

HEADERS = {"User-Agent": "EloTempo/4.0 (historical curation; strict anti-anachronism; contact@elotempo.app)"}

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"
midia_dir = app_dir / "midia"
midia_dir.mkdir(parents=True, exist_ok=True)

root_dir = Path(__file__).resolve().parent.parent
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

# Lista de novas obras para baixar e aplicar
NOVAS_OBRAS = [
    {
        "pessoa_ids": ["pub_patriarcas_israel_rebeca", "pub_mat_rebeca"],
        "folder": imagens_base / "biblicas" / "patriarcas-israel" / "Rebeca",
        "file_name": "01_Rebeca.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/8/8c/Eli%C3%A9zer_et_R%C3%A9becca_-_Nicolas_Poussin_-_Mus%C3%A9e_du_Louvre_Peintures_INV_7270_%3B_MR_2315.jpg",
        "title": "Éliézer et Rébecca",
        "artist": "Nicolas Poussin",
        "role": "pintor",
        "date_created": "1648",
        "museum": "Museu do Louvre, Paris",
        "formatted_description": "Pintura por Nicolas Poussin (1648). Acervo: Museu do Louvre, Paris.",
        "license": "Public domain",
        "source": "Gênesis 24; tradição patriarcal",
        "clean_old_patterns": ["UN_Trade_and_Development", "Rebeca_Grynspan", "Gustavobarreto-un", "02_Rebeca.jpg"]
    },
    {
        "pessoa_ids": ["pub_patriarcas_israel_sara", "pub_mat_sara"],
        "folder": imagens_base / "biblicas" / "patriarcas-israel" / "Sara",
        "file_name": "01_Sara.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/8/88/Tiepolo_G.B._%281727-1728%29%2C_Sara_e_l%27angelo%2C_Udine.jpg",
        "title": "Sara e o Anjo",
        "artist": "Giovanni Battista Tiepolo",
        "role": "pintor",
        "date_created": "1726-1728",
        "museum": "Palazzo Patriarcale, Udine",
        "formatted_description": "Pintura por Giovanni Battista Tiepolo (1726-1728). Acervo: Palazzo Patriarcale, Udine.",
        "license": "Public domain",
        "source": "Gênesis 18; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_adao"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Adão",
        "file_name": "01_Adão.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/d/d4/Michelangelo%2C_Creation_of_Adam_03.jpg",
        "title": "A Criação de Adão",
        "artist": "Michelangelo",
        "role": "pintor",
        "date_created": "1510",
        "museum": "Capela Sistina, Vaticano",
        "formatted_description": "Afresco por Michelangelo (1510). Acervo: Capela Sistina, Vaticano.",
        "license": "Public domain",
        "source": "Gênesis 2; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_eva"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Eva",
        "file_name": "01_Eva.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/e/e7/Adam_and_Eve%2C_by_Lucas_Cranach_the_Elder%2C_1526%2C_oil_on_wood_-_Courtauld_Institute_of_Art%2C_London_-_DSC00844.jpg",
        "title": "Adão e Eva",
        "artist": "Lucas Cranach, o Velho",
        "role": "pintor",
        "date_created": "1526",
        "museum": "Courtauld Institute of Art, Londres",
        "formatted_description": "Pintura por Lucas Cranach, o Velho (1526). Acervo: Courtauld Institute of Art, Londres.",
        "license": "Public domain",
        "source": "Gênesis 3; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_caim"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Caim",
        "file_name": "01_Caim.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/1/1b/Titian_-_Cain_and_Abel.JPG",
        "title": "Caim e Abel",
        "artist": "Ticiano (Tiziano Vecellio)",
        "role": "pintor",
        "date_created": "1542-1544",
        "museum": "Basílica de Santa Maria della Salute, Veneza",
        "formatted_description": "Pintura por Ticiano (1542-1544). Acervo: Basílica de Santa Maria della Salute, Veneza.",
        "license": "Public domain",
        "source": "Gênesis 4; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_abel"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Abel",
        "file_name": "01_Abel.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/9/9f/Bouguereau-The_First_Mourning-1888.jpg",
        "title": "O Primeiro Luto (Adão e Eva encontrando Abel)",
        "artist": "William-Adolphe Bouguereau",
        "role": "pintor",
        "date_created": "1888",
        "museum": "Museo Nacional de Bellas Artes, Buenos Aires",
        "formatted_description": "Pintura por William-Adolphe Bouguereau (1888). Acervo: Museo Nacional de Bellas Artes.",
        "license": "Public domain",
        "source": "Gênesis 4; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_sete"],
        "folder": imagens_base / "biblicas" / "genealogia-de-adao" / "Sete",
        "file_name": "01_Sete.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/8/88/Spas_na_Ilyine_-_Patriarch_Seth_2_%28cropped%29.jpg",
        "title": "Patriarca Sete",
        "artist": "Teófanes, o Grego (Feofan Grek)",
        "role": "iconógrafo",
        "date_created": "1378",
        "museum": "Igreja da Transfiguração, Veliki Novgorod",
        "formatted_description": "Afresco / Ícone por Teófanes, o Grego (1378). Acervo: Igreja da Transfiguração.",
        "license": "Public domain",
        "source": "Gênesis 5; tradição bíblica"
    },
    {
        "pessoa_ids": ["pub_bourbon_henrique_iv_da_franca"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Henrique_IV",
        "file_name": "01_Henrique_IV.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/5/58/Frans_Pourbus_%28II%29_-_Henry_IV%2C_King_of_France_in_Black_Dress_-_WGA18234.jpg",
        "title": "Henrique IV, Rei da França",
        "artist": "Frans Pourbus, o Jovem",
        "role": "pintor",
        "date_created": "1610",
        "museum": "Museu do Louvre, Paris",
        "formatted_description": "Pintura por Frans Pourbus, o Jovem (1610). Acervo: Museu do Louvre, Paris.",
        "license": "Public domain",
        "source": "Dinastia Bourbon; história da França"
    },
    {
        "pessoa_ids": ["pub_bourbon_maria_de_medici"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Maria_de_Médici",
        "file_name": "01_Maria_de_Médici.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/9/9a/Frans_Pourbus%2C_the_Younger_-_Marie_de_M%C3%A9dicis_-_1920.1034_-_Art_Institute_of_Chicago.jpg",
        "title": "Maria de Médici, Rainha Consorte da França",
        "artist": "Frans Pourbus, o Jovem",
        "role": "pintor",
        "date_created": "1616",
        "museum": "Art Institute of Chicago / Louvre",
        "formatted_description": "Pintura por Frans Pourbus, o Jovem (1616). Acervo: Art Institute of Chicago.",
        "license": "Public domain",
        "source": "Dinastia Bourbon; história da França"
    },
    {
        "pessoa_ids": ["pub_bourbon_luis_xiv"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Luís_XIV",
        "file_name": "01_Luís_XIV.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/3/37/Louis_XIV_Rigaud_Cond%C3%A9_Chantilly.jpg",
        "title": "Luís XIV, o Rei Sol",
        "artist": "Hyacinthe Rigaud",
        "role": "pintor",
        "date_created": "1701",
        "museum": "Museu Condé, Chantilly / Louvre",
        "formatted_description": "Pintura por Hyacinthe Rigaud (1701). Acervo: Museu Condé / Louvre.",
        "license": "Public domain",
        "source": "Dinastia Bourbon; história da França"
    },
    {
        "pessoa_ids": ["pub_bourbon_maria_teresa_da_espanha"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Maria_Teresa_da_Espanha",
        "file_name": "01_Maria_Teresa_da_Espanha.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/1/15/Diego_Vel%C3%A1zquez_030.jpg",
        "title": "Infanta Maria Teresa da Espanha, Rainha Consorte da França",
        "artist": "Diego Velázquez",
        "role": "pintor",
        "date_created": "1652-1653",
        "museum": "Kunsthistorisches Museum, Viena",
        "formatted_description": "Pintura por Diego Velázquez (1652-1653). Acervo: Kunsthistorisches Museum, Viena.",
        "license": "Public domain",
        "source": "Dinastia Bourbon / Habsburgo"
    },
    {
        "pessoa_ids": ["pub_bourbon_filipe_v_da_espanha"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Filipe_V",
        "file_name": "01_Filipe_V.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/5/5f/Hyacinthe_Rigaud_-_Philippe_V%2C_roi_d%27Espagne_%281683-1746%29_-_Google_Art_Project.jpg",
        "title": "Filipe V, Rei da Espanha",
        "artist": "Hyacinthe Rigaud",
        "role": "pintor",
        "date_created": "1700-1701",
        "museum": "Palácio de Versalhes",
        "formatted_description": "Pintura por Hyacinthe Rigaud (1700-1701). Acervo: Palácio de Versalhes.",
        "license": "Public domain",
        "source": "Dinastia Bourbon da Espanha"
    },
    {
        "pessoa_ids": ["pub_bourbon_maria_luisa_de_saboia"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Maria_Luísa_de_Saboia",
        "file_name": "01_Maria_Luísa_de_Saboia.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/2/21/Mar%C3%ADa_Luisa_Gabriela_de_Saboya%2C_reina_consorte_de_Espa%C3%B1a_%28Museo_del_Prado%29.jpg",
        "title": "Maria Luísa Gabriela de Saboia, Rainha Consorte da Espanha",
        "artist": "Miguel Jacinto Meléndez",
        "role": "pintor",
        "date_created": "c. 1712",
        "museum": "Museu do Prado, Madrid",
        "formatted_description": "Pintura por Miguel Jacinto Meléndez (c. 1712). Acervo: Museu do Prado, Madrid.",
        "license": "Public domain",
        "source": "Dinastia Bourbon da Espanha"
    },
    {
        "pessoa_ids": ["pub_bourbon_luis_xvi"],
        "folder": imagens_base / "realeza-europeia" / "bourbon" / "Luís_XVI",
        "file_name": "01_Luís_XVI.jpg",
        "url": "https://upload.wikimedia.org/wikipedia/commons/c/ce/Antoine-Fran%C3%A7ois_Callet_-_Louis_XVI%2C_roi_de_France_et_de_Navarre_%281754-1793%29%2C_rev%C3%AAtu_du_grand_costume_royal_en_1779_-_Google_Art_Project.jpg",
        "title": "Luís XVI em Trajes de Coroação Real",
        "artist": "Antoine-François Callet",
        "role": "pintor",
        "date_created": "1778-1779",
        "museum": "Museu do Prado / Versalhes",
        "formatted_description": "Pintura por Antoine-François Callet (1778-1779). Acervo: Palácio de Versalhes.",
        "license": "Public domain",
        "source": "Dinastia Bourbon; história da França"
    }
]


def executar_curadoria():
    print("=" * 70)
    print(" EloTempo - Curadoria e Aplicação de Obras de Arte Clássica")
    print("=" * 70)
    print(f"Banco de dados: {db_path}")
    print(f"Pasta de mídia: {midia_dir}")

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    # 1. Limpa a imagem incorreta da Rebeca Grynspan (UN)
    print("\n[Passo 1] Limpando imagem incorreta de Rebeca (ONU)...")
    cur.execute("""
        SELECT d.id, d.caminho_relativo, dv.id, p.id 
        FROM documentos d
        LEFT JOIN documento_vinculos dv ON dv.documento_id = d.id
        LEFT JOIN pessoas p ON p.id = dv.pessoa_id
        WHERE d.descricao LIKE '%Gustavobarreto-un%' 
           OR d.descricao LIKE '%Rebeca_Grynspan%'
           OR d.nome_original = '02_Rebeca.jpg'
    """)
    rows_bad = cur.fetchall()
    for doc_id, rel_path, vinc_id, pid in rows_bad:
        if vinc_id:
            cur.execute("DELETE FROM documento_vinculos WHERE id = ?", (vinc_id,))
        cur.execute("DELETE FROM documentos WHERE id = ?", (doc_id,))
        if rel_path:
            full_midia = app_dir / rel_path
            if full_midia.exists():
                full_midia.unlink(missing_ok=True)
                print(f"  Removido arquivo de mídia incorreto: {full_midia.name}")
        if pid:
            cur.execute("UPDATE pessoas SET foto_url = NULL WHERE id = ?", (pid,))
            print(f"  Resetado foto_url de {pid}")

    # Remove o arquivo 02_Rebeca.jpg em _imagens_elotempo
    rebeca_folder = imagens_base / "biblicas" / "patriarcas-israel" / "Rebeca"
    for bad_f in ["02_Rebeca.jpg", "02_Rebeca.json"]:
        p_bad = rebeca_folder / bad_f
        if p_bad.exists():
            p_bad.unlink(missing_ok=True)
            print(f"  Removido arquivo local de Rebeca: {bad_f}")

    # 2. Baixa e cadastra as novas obras de arte
    print("\n[Passo 2] Baixando e cadastrando novas obras de mestres...")
    for item in NOVAS_OBRAS:
        folder = item["folder"]
        folder.mkdir(parents=True, exist_ok=True)
        img_dest = folder / item["file_name"]
        json_dest = folder / f"{item['file_name'].rsplit('.', 1)[0]}.json"

        # Download da imagem se não existir
        if not img_dest.exists() or img_dest.stat().st_size < 5000:
            print(f"  Baixando: {item['title']} ({item['artist']})...")
            try:
                resp = requests.get(item["url"], headers=HEADERS, timeout=30)
                if resp.status_code == 200 and len(resp.content) > 5000:
                    img_dest.write_bytes(resp.content)
                    print(f"    ✓ Salvo com sucesso ({len(resp.content):,} bytes)")
                else:
                    print(f"    ✕ Falha no download (HTTP {resp.status_code})")
                    continue
            except Exception as e:
                print(f"    ✕ Erro no download: {e}")
                continue

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
                "original_url": item["url"],
                "source_provider": item["source"]
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

            # Cria vínculo
            vinc_id = str(uuid.uuid4())
            cur.execute("""
                INSERT INTO documento_vinculos (id, documento_id, pessoa_id, evento_id)
                VALUES (?, ?, ?, NULL)
            """, (vinc_id, doc_id, pid))

            # Atualiza foto_url da pessoa
            cur.execute("UPDATE pessoas SET foto_url = ? WHERE id = ?", (caminho_relativo, pid))
            print(f"    -> Aplicado a {pid} ({p_row[1]} {p_row[2] or ''}): {item['title']}")

    # 3. Atualiza os retratos clássicos principais das figuras centrais já baixadas
    print("\n[Passo 3] Definindo fotos principais oficiais com metadados para Jesus, Maria, José, Davi, Salomão...")
    RETRATOS_OFICIAIS = [
        # Jesus de Nazaré -> Mosaico de Cefalù Pantocrator
        (["pub_jesus_mateus", "pub_jesus_lucas"], "01_Jesus_de_Nazaré.jpg"),
        # Virgem Maria -> Botticelli (1468-1470)
        (["pub_mat_maria", "pub_luc_maria"], "01_Virgem_Maria_de_Nazaré.jpg"),
        # São José -> Guido Reni (1620s)
        (["pub_mat_jose", "pub_luc_jose"], "01_São_José_de_Nazaré.jpg"),
        # Rei Davi -> Gerard van Honthorst (1622)
        (["pub_mat_davi", "pub_luc_davi", "pub_rei_david"], "01_Rei_David_de_Israel.jpg"),
        # Salomão -> Simeon Solomon (1872/1874)
        (["pub_mat_salomao", "pub_rei_salomao"], "01_Salomão.jpg"),
        # Abraão -> Rembrandt (1635)
        (["pub_mat_abraao", "pub_luc_abraao", "pub_patriarcas_israel_abraao"], "02_Abraão.jpg"),
        # Isaac -> Gerrit Willemsz. Horst (1638)
        (["pub_mat_isaac", "pub_luc_isaac", "pub_patriarcas_israel_isaac"], "04_Isaac.jpg"),
        # Jacó -> Jan Victors (1652)
        (["pub_mat_jaco_patriarca", "pub_luc_jaco_patriarca", "pub_patriarcas_israel_jaco"], "01_Jacó_(Israel).jpg"),
        # Judá -> Horace Vernet (1840)
        (["pub_mat_juda", "pub_luc_juda", "pub_patriarcas_israel_juda"], "01_Judá.jpg"),
        # Boaz -> Rembrandt (1643)
        (["pub_mat_boaz", "pub_luc_boaz"], "01_Boaz.jpg"),
        # João Batista -> Ticiano (1540)
        (["pub_luc_joao_batista"], "03_João_Batista.jpg"),
        # Zacarias -> José de Ribera (1634)
        (["pub_luc_zacarias"], "02_Zacarias.jpg")
    ]

    for pids, nome_orig in RETRATOS_OFICIAIS:
        # Localiza o documento no banco
        cur.execute("SELECT id, caminho_relativo, titulo, descricao FROM documentos WHERE nome_original = ? ORDER BY data_criacao DESC LIMIT 1", (nome_orig,))
        doc_row = cur.fetchone()
        if not doc_row:
            print(f"  Aviso: Documento {nome_orig} não encontrado no banco.")
            continue
        doc_id, caminho_relativo, doc_tit, doc_desc = doc_row

        for pid in pids:
            cur.execute("SELECT id, nome, sobrenome FROM pessoas WHERE id = ?", (pid,))
            p_row = cur.fetchone()
            if not p_row:
                continue

            # Garante vínculo em documento_vinculos
            cur.execute("SELECT id FROM documento_vinculos WHERE documento_id = ? AND pessoa_id = ?", (doc_id, pid))
            if not cur.fetchone():
                vinc_id = str(uuid.uuid4())
                cur.execute("INSERT INTO documento_vinculos (id, documento_id, pessoa_id, evento_id) VALUES (?, ?, ?, NULL)", (vinc_id, doc_id, pid))

            # Atualiza foto_url
            cur.execute("UPDATE pessoas SET foto_url = ? WHERE id = ?", (caminho_relativo, pid))
            print(f"  ✓ {p_row[1]} {p_row[2] or ''} ({pid}) -> {caminho_relativo} ({nome_orig})")

    conn.commit()
    conn.close()

    print("\n" + "=" * 70)
    print(" Curadoria Concluída com Sucesso!")
    print("=" * 70)

    # Exibe resumo de conferência
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    print("\nConferência das personalidades:")
    alvos = [
        "pub_jesus_mateus", "pub_mat_maria", "pub_mat_jose",
        "pub_patriarcas_israel_abraao", "pub_patriarcas_israel_sara",
        "pub_patriarcas_israel_isaac", "pub_patriarcas_israel_rebeca",
        "pub_adao", "pub_eva", "pub_caim", "pub_abel", "pub_sete",
        "pub_bourbon_henrique_iv_da_franca", "pub_bourbon_maria_de_medici",
        "pub_bourbon_luis_xiv", "pub_bourbon_maria_teresa_da_espanha",
        "pub_bourbon_filipe_v_da_espanha", "pub_bourbon_maria_luisa_de_saboia",
        "pub_bourbon_luis_xvi"
    ]
    for aid in alvos:
        cur.execute("SELECT id, nome, sobrenome, foto_url FROM pessoas WHERE id = ?", (aid,))
        r = cur.fetchone()
        if r:
            cur.execute("SELECT count(*) FROM documento_vinculos WHERE pessoa_id = ?", (aid,))
            ndocs = cur.fetchone()[0]
            print(f"  • {r[1]} {r[2] or ''} ({r[0]}): foto={r[3]} | docs={ndocs}")
    conn.close()


if __name__ == "__main__":
    executar_curadoria()
