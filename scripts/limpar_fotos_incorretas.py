"""
EloTempo - Limpeza de Fotos Incorretas
======================================
Identifica e remove fotos baixadas incorretamente por fontes não-curadas:
- Openverse (Flickr, Rawpixel, etc.)
- The Met / Art Institute of Chicago
- Imagens de bandeiras, anos, prefeituras, ruas, furacões, eventos modernos
- Remove os arquivos em `_imagens_elotempo/`
- Remove os arquivos copiados em `%APPDATA%/com.elotempo.app/midia/`
- Remove os registros em `documentos` e `documento_vinculos`
- Restaura `pessoas.foto_url = NULL` para perfis que tinham foto incorreta
"""

import os
import sys
import json
import glob
import shutil
import sqlite3
from pathlib import Path

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

def limpar_fotos_incorretas():
    raiz = Path(__file__).resolve().parent.parent
    imagens_dir = raiz / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"
    catalogo_json = imagens_dir / "catalogo_imagens.json"
    catalogo_csv = imagens_dir / "catalogo_imagens.csv"

    appdata = os.environ.get("APPDATA")
    app_dir = Path(appdata) / "com.elotempo.app"
    db_path = app_dir / "acervo.sqlite"
    midia_dir = app_dir / "midia"

    print("=" * 70)
    print(" EloTempo - Limpeza de Fotos Incorretas")
    print("=" * 70)

    # 1. Analisa os arquivos JSON individuais
    json_files = list(imagens_dir.glob("*/*/*/*.json"))
    print(f"Total de arquivos JSON em _imagens_elotempo: {len(json_files)}")

    removidos_origem = 0
    arquivos_removidos_originais = set()

    TERMOS_INVALIDOS = [
        "hurricane", "resort", "hotel", "rua ", "street", "avenida", "estacao", "estação",
        "subway", "metro", "gymnastics", "tennis", "qualies", "palacio campos eliseos",
        "city hall", "flag of israel", "anof.jpg", "anogf.jpg", "the horse fair",
        "death of socrates", "lady gaga", "biblioteca jose vasconcelos", "ted, janine",
        "metal dome", "castaways resort", "mission beach", "mary stevens park", "orphaned land"
    ]

    for jf in json_files:
        try:
            with open(jf, "r", encoding="utf-8", errors="ignore") as f:
                d = json.load(f)
        except Exception:
            continue

        prov = (d.get("rights", {}).get("provider") or "").lower()
        title = (d.get("image", {}).get("file") or "").lower()
        desc = (d.get("provenance", {}).get("description") or "").lower()
        page_url = (d.get("provenance", {}).get("page_url") or "").lower()
        comb = f"{title} {desc} {page_url}"

        # É incorreto se vier de Flickr/Rawpixel/Met/AIC ou contiver termos inválidos ou página de ano
        remover = False
        motivo = ""

        if "flickr" in prov or "rawpixel" in prov or "europeana" in prov:
            remover = True
            motivo = f"Fonte não-curada ({prov})"
        elif "the met" in prov or "metropolitan" in prov or "art institute" in prov:
            remover = True
            motivo = f"Fonte de museu sem correspondência biográfica ({prov})"
        elif any(ti in comb for ti in TERMOS_INVALIDOS):
            remover = True
            motivo = "Conteúdo não biográfico (rua/bandeira/furacão/esporte/música/ano)"
        elif "pt.wikipedia.org/wiki/18" in page_url or "pt.wikipedia.org/wiki/19" in page_url:
            remover = True
            motivo = "Página enciclopédica de ano, não de pessoa"
        elif "pt.wikipedia.org/wiki/arao" in page_url and "city_hall" in comb:
            remover = True
            motivo = "Prefeitura da cidade de Arao (Japão), não a figura bíblica Arão"

        if remover:
            img_path = Path(d.get("image", {}).get("path") or "")
            nome_original = d.get("image", {}).get("file") or jf.stem
            arquivos_removidos_originais.add(nome_original)

            # Remove imagem no diretório de download
            if img_path.exists() and img_path.is_file():
                try:
                    img_path.unlink()
                except Exception as e:
                    print(f"Erro ao remover {img_path}: {e}")

            # Remove sibling images com mesmo stem
            for ext in [".jpg", ".jpeg", ".png", ".webp", ".gif"]:
                irm = jf.with_suffix(ext)
                if irm.exists() and irm.is_file():
                    try:
                        irm.unlink()
                    except Exception:
                        pass

            # Remove o JSON
            try:
                jf.unlink()
                removidos_origem += 1
            except Exception:
                pass

    print(f"Arquivos incorretos removidos de _imagens_elotempo: {removidos_origem}")

    # Remove pastas vazias que ficaram sem fotos
    for p in imagens_dir.glob("*/*/*"):
        if p.is_dir() and not any(p.iterdir()):
            p.rmdir()

    # 2. Atualiza catalogo_imagens.json e catalogo_imagens.csv
    if catalogo_json.exists():
        try:
            with open(catalogo_json, "r", encoding="utf-8") as f:
                cat = json.load(f)
            cat_limpo = []
            for item in cat:
                f_name = item.get("image", {}).get("file")
                f_path = Path(item.get("image", {}).get("path", ""))
                prov = (item.get("rights", {}).get("provider") or "").lower()
                if "flickr" in prov or "metropolitan" in prov or "rawpixel" in prov:
                    continue
                if f_name in arquivos_removidos_originais:
                    continue
                if f_path.exists():
                    cat_limpo.append(item)

            with open(catalogo_json, "w", encoding="utf-8") as f:
                json.dump(cat_limpo, f, ensure_ascii=False, indent=2)
            print(f"Catálogo atualizado: {len(cat_limpo)} fotos legítimas restantes.")
        except Exception as e:
            print(f"Erro ao atualizar catálogo JSON: {e}")

    # 3. Limpeza no Banco SQLite e Pasta de Mídia do App
    if db_path.exists():
        conn = sqlite3.connect(db_path)
        cur = conn.cursor()

        # Localiza documentos cadastrados com nome_original removido ou descrição inválida
        cur.execute("SELECT id, caminho_relativo, nome_original, descricao FROM documentos")
        todos_docs = cur.fetchall()

        docs_para_remover = []
        for doc_id, caminho, nome_orig, desc in todos_docs:
            desc_l = (desc or "").lower()
            nome_l = (nome_orig or "").lower()
            comb = f"{desc_l} {nome_l}"

            deve_apagar = False
            if nome_orig in arquivos_removidos_originais:
                deve_apagar = True
            elif "flickr" in desc_l or "metropolitan" in desc_l or "openverse" in desc_l:
                deve_apagar = True
            elif any(ti in comb for ti in TERMOS_INVALIDOS):
                deve_apagar = True

            if deve_apagar:
                docs_para_remover.append((doc_id, caminho))

        print(f"\nDocumentos incorretos a remover do banco SQLite: {len(docs_para_remover)}")

        for doc_id, caminho in docs_para_remover:
            # Reseta foto_url na tabela pessoas se apontava para este arquivo
            cur.execute("UPDATE pessoas SET foto_url = NULL WHERE foto_url = ?", (caminho,))
            # Remove vinculo
            cur.execute("DELETE FROM documento_vinculos WHERE documento_id = ?", (doc_id,))
            # Remove documento
            cur.execute("DELETE FROM documentos WHERE id = ?", (doc_id,))

            # Remove arquivo físico em midia/
            if caminho:
                arq_fisico = app_dir / caminho
                if arq_fisico.exists() and arq_fisico.is_file():
                    try:
                        arq_fisico.unlink()
                    except Exception:
                        pass

        conn.commit()

        cur.execute("SELECT count(*) FROM pessoas WHERE foto_url IS NOT NULL AND foto_url != ''")
        pessoas_com_foto = cur.fetchone()[0]
        cur.execute("SELECT count(*) FROM documentos")
        docs_restantes = cur.fetchone()[0]
        conn.close()

        print(f"Fotos legítimas restantes em pessoas.foto_url: {pessoas_com_foto}")
        print(f"Documentos legítimos restantes no acervo: {docs_restantes}")

    print("\n" + "=" * 70)
    print(" Limpeza de fotos espúrias concluída com sucesso!")
    print("=" * 70)

if __name__ == "__main__":
    limpar_fotos_incorretas()
