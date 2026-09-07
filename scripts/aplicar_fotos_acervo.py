"""
EloTempo - Aplicador de Fotos do Acervo
========================================
Varre as imagens baixadas em `_imagens_elotempo/`, identifica com precisão
a qual pessoa cada imagem pertence no banco SQLite oficial (`acervo.sqlite`),
copia os arquivos para a pasta segura de mídia do Tauri (`%APPDATA%/com.elotempo.app/midia/`)
e atualiza:
  1. `documentos` (registro do anexo com tamanho, título e metadados de licença/fonte)
  2. `documento_vinculos` (vínculo formal documento <-> pessoa)
  3. `pessoas.foto_url` (foto de perfil principal que aparece no card da árvore e na ficha)

Este script é IDEMPOTENTE: pode ser executado repetidamente conforme novas
fotos forem sendo baixadas. Fotos já importadas não são duplicadas.
"""

import os
import sys
import glob
import json
import uuid
import shutil
import sqlite3
import unicodedata
from datetime import datetime, timezone
from pathlib import Path

# Garante suporte seguro a UTF-8 no Windows
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass


def normalizar(texto: str) -> str:
    """Normaliza texto removendo acentos, pontuações e espaços extras."""
    if not texto:
        return ""
    texto = unicodedata.normalize("NFKD", texto)
    texto = "".join(c for c in texto if not unicodedata.combining(c))
    texto = texto.lower()
    for ch in ".-'\"()[]{},:;/\\_":
        texto = texto.replace(ch, " ")
    return " ".join(texto.split())


def limpar_prefixos_titulo(texto: str) -> str:
    """Remove títulos de nobreza / clericais / honoríficos comuns."""
    prefixos = [
        "imperador ", "imperatriz ", "rei ", "rainha ", "principe ", "princesa ",
        "papa ", "dom ", "d ", "santa ", "santo ", "barao de ", "baronesa de ",
        "conde de ", "condessa de ", "duque de ", "duquesa de ", "presidente ",
        "farao ", "faraoh "
    ]
    norm = normalizar(texto)
    for p in prefixos:
        if norm.startswith(p):
            norm = norm[len(p):].strip()
    return norm


def obter_caminhos():
    """Localiza as pastas de dados e banco do EloTempo."""
    appdata = os.environ.get("APPDATA")
    if not appdata:
        raise RuntimeError("Variável de ambiente APPDATA não encontrada.")

    app_dir = Path(appdata) / "com.elotempo.app"
    db_path = app_dir / "acervo.sqlite"
    midia_dir = app_dir / "midia"

    # Diretório raiz do projeto
    raiz_script = Path(__file__).resolve().parent.parent
    imagens_dir = raiz_script / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"
    if not imagens_dir.exists():
        # Tenta variação de pasta se não estiver aninhado
        imagens_dir = raiz_script / "arvores-genealogicas" / "_imagens_elotempo"

    return db_path, midia_dir, imagens_dir


def carregar_indice_pessoas(conn: sqlite3.Connection):
    """Carrega pessoas do banco e constrói mapas para matching exato e heurístico."""
    cur = conn.cursor()
    cur.execute("SELECT id, nome, sobrenome, foto_url FROM pessoas")
    linhas = cur.fetchall()

    ids_existentes = set()
    mapa_nomes = {}
    pessoas_info = {}

    for pid, nome, sobrenome, foto_url in linhas:
        ids_existentes.add(pid)
        pessoas_info[pid] = {
            "id": pid,
            "nome": nome,
            "sobrenome": sobrenome,
            "foto_url": foto_url,
        }

        full_nome_sobrenome = f"{nome or ''} {sobrenome or ''}".strip()
        full_nome = f"{nome or ''}".strip()

        for candid in [full_nome_sobrenome, full_nome]:
            if candid:
                n1 = normalizar(candid)
                n2 = limpar_prefixos_titulo(candid)
                mapa_nomes[n1] = pid
                mapa_nomes[n2] = pid
                if "(" in candid:
                    sem_parenteses = candid.split("(")[0].strip()
                    mapa_nomes[normalizar(sem_parenteses)] = pid
                    mapa_nomes[limpar_prefixos_titulo(sem_parenteses)] = pid

    # Incorpora também nomes_pessoa se existirem
    try:
        cur.execute("SELECT pessoa_id, nome, sobrenome FROM nomes_pessoa")
        for pid, nome, sobrenome in cur.fetchall():
            if pid not in ids_existentes:
                continue
            for candid in [f"{nome or ''} {sobrenome or ''}".strip(), f"{nome or ''}".strip()]:
                if candid:
                    mapa_nomes[normalizar(candid)] = pid
                    mapa_nomes[limpar_prefixos_titulo(candid)] = pid
    except sqlite3.OperationalError:
        pass

    return ids_existentes, mapa_nomes, pessoas_info


def encontrar_pessoa_id(jf_path: Path, meta: dict, ids_existentes: set, mapa_nomes: dict):
    """Identifica o pessoa_id correspondente usando ID slugs, nomes e metadados."""
    person = meta.get("person", {})
    block_title = person.get("block_title", "")
    name_public = person.get("name_public", "")
    name_registered = person.get("name_registered", "")

    # 1. Tentar slugs de caminho (ex: pub_casa_imperial_japao_imperador_jimmu)
    parts = jf_path.parts
    if "_imagens_elotempo" in parts:
        idx = parts.index("_imagens_elotempo")
        if len(parts) >= idx + 4:
            tree_slug = parts[idx + 2].replace("-", "_").lower()
            person_folder = parts[idx + 3]
            person_slug = normalizar(person_folder).replace(" ", "_")
            clean_slug = limpar_prefixos_titulo(person_folder).replace(" ", "_")

            cand_ids = [
                f"pub_{tree_slug}_{person_slug}",
                f"pub_{person_slug}",
                f"pub_{tree_slug}_{clean_slug}",
                f"pub_{clean_slug}",
            ]
            for cid in cand_ids:
                if cid in ids_existentes:
                    return cid

    # 2. Tentar por nomes (público, bloco, registro)
    for candid in [name_public, block_title, name_registered]:
        if not candid:
            continue
        n_exato = normalizar(candid)
        if n_exato in mapa_nomes:
            return mapa_nomes[n_exato]

        n_limpo = limpar_prefixos_titulo(candid)
        if n_limpo in mapa_nomes:
            return mapa_nomes[n_limpo]

        if "(" in candid:
            sem_par = candid.split("(")[0].strip()
            if normalizar(sem_par) in mapa_nomes:
                return mapa_nomes[normalizar(sem_par)]
            if limpar_prefixos_titulo(sem_par) in mapa_nomes:
                return mapa_nomes[limpar_prefixos_titulo(sem_par)]

    return None


def encontrar_arquivo_imagem(jf_path: Path, meta: dict):
    """Localiza o arquivo de imagem correspondente ao JSON."""
    # 1. Verifica campo do JSON
    path_no_json = meta.get("image", {}).get("path")
    if path_no_json and os.path.isfile(path_no_json):
        return Path(path_no_json)

    # 2. Verifica arquivo irmão com o mesmo stem
    stem = jf_path.stem
    parent = jf_path.parent
    for ext in [".jpg", ".jpeg", ".png", ".webp", ".gif"]:
        candidato = parent / f"{stem}{ext}"
        if candidato.is_file():
            return candidato

    # 3. Qualquer imagem na mesma pasta cujo nome comece igual
    for f in parent.iterdir():
        if f.is_file() and f.stem == stem and f.suffix.lower() in [".jpg", ".jpeg", ".png", ".webp"]:
            return f

    return None


def aplicar_fotos():
    db_path, midia_dir, imagens_dir = obter_caminhos()

    print("=" * 70)
    print(" EloTempo - Vinculador de Fotos do Acervo")
    print("=" * 70)
    print(f"Banco de dados: {db_path}")
    print(f"Pasta de mídia: {midia_dir}")
    print(f"Origem imagens: {imagens_dir}")

    if not db_path.exists():
        print(f"ERRO: Banco de dados não encontrado em {db_path}")
        return

    if not imagens_dir.exists():
        print(f"ERRO: Pasta de imagens não encontrada em {imagens_dir}")
        return

    # Garante pasta de mídia criada
    midia_dir.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    ids_existentes, mapa_nomes, pessoas_info = carregar_indice_pessoas(conn)
    print(f"Total de pessoas no banco: {len(ids_existentes)}")

    # Carrega documentos já cadastrados para evitar duplicidade
    cur.execute("SELECT id, caminho_relativo, nome_original FROM documentos")
    docs_existentes = cur.fetchall()
    nomes_originais_cadastrados = {doc[2] for doc in docs_existentes if doc[2]}
    caminhos_cadastrados = {doc[1] for doc in docs_existentes if doc[1]}

    # Localiza todos os arquivos .json
    json_files = sorted(list(imagens_dir.glob("*/*/*/*.json")))
    print(f"Arquivos JSON encontrados: {len(json_files)}")

    # Agrupa imagens por pessoa_id
    # pessoa_id -> list of (jf_path, img_path, meta, is_primary_candidate)
    por_pessoa = {}
    nao_identificados = []
    sem_imagem = []

    for jf in json_files:
        try:
            with open(jf, "r", encoding="utf-8", errors="ignore") as f:
                meta = json.load(f)
        except Exception as e:
            print(f"Aviso: erro ao ler {jf}: {e}")
            continue

        pessoa_id = encontrar_pessoa_id(jf, meta, ids_existentes, mapa_nomes)
        if not pessoa_id:
            nao_identificados.append(jf)
            continue

        img_path = encontrar_arquivo_imagem(jf, meta)
        if not img_path or not img_path.exists():
            sem_imagem.append(jf)
            continue

        if pessoa_id not in por_pessoa:
            por_pessoa[pessoa_id] = []

        por_pessoa[pessoa_id].append({
            "jf": jf,
            "img": img_path,
            "meta": meta,
        })

    print(f"\nPessoas identificadas com fotos: {len(por_pessoa)}")
    if nao_identificados:
        print(f"Aviso: {len(nao_identificados)} metadados não casados com pessoas do banco.")
    if sem_imagem:
        print(f"Aviso: {len(sem_imagem)} metadados sem arquivo de imagem correspondente.")

    # Processa inserções e cópias
    total_copiados = 0
    total_vinculos = 0
    total_perfis_atualizados = 0

    for pessoa_id, itens in por_pessoa.items():
        # Ordena itens por nome de arquivo (01_... vem antes de 02_...)
        itens.sort(key=lambda x: x["img"].name)

        p_info = pessoas_info[pessoa_id]
        nome_exibicao = f"{p_info['nome'] or ''} {p_info['sobrenome'] or ''}".strip()
        foto_url_atual = p_info["foto_url"]

        primeira_foto_caminho = None

        for idx, item in enumerate(itens):
            img_file = item["img"]
            meta = item["meta"]
            nome_original = img_file.name

            # Verifica se já está cadastrado
            doc_id = None
            caminho_relativo = None

            cur.execute(
                """
                SELECT d.id, d.caminho_relativo 
                FROM documentos d
                JOIN documento_vinculos v ON v.documento_id = d.id
                WHERE v.pessoa_id = ? AND d.nome_original = ?
                """,
                (pessoa_id, nome_original),
            )
            ja_cadastrado = cur.fetchone()

            if ja_cadastrado:
                doc_id, caminho_relativo = ja_cadastrado
            else:
                # Gera novo ID e copia arquivo para APPDATA/midia
                ext = img_file.suffix.lower()
                doc_id = str(uuid.uuid4())
                nome_destino = f"{doc_id}{ext}"
                destino_completo = midia_dir / nome_destino

                shutil.copy2(img_file, destino_completo)
                tamanho_bytes = destino_completo.stat().st_size
                caminho_relativo = f"midia/{nome_destino}"

                # Metadados de título e descrição
                titulo = f"Retrato - {nome_exibicao}" if idx == 0 else f"Foto adicional - {nome_exibicao}"
                rights = meta.get("rights", {})
                licenca = rights.get("license", "")
                autor = rights.get("author", "")
                descricao_partes = []
                if autor:
                    descricao_partes.append(f"Autor: {autor}")
                if licenca:
                    descricao_partes.append(f"Licença: {licenca}")
                fonte = meta.get("provenance", {}).get("source_provider") or meta.get("source_record", {}).get("declared_source")
                if fonte:
                    descricao_partes.append(f"Fonte: {fonte}")
                descricao = " | ".join(descricao_partes) if descricao_partes else None

                agora = datetime.now(timezone.utc).isoformat()

                # Insere em documentos
                cur.execute(
                    """
                    INSERT INTO documentos (
                        id, caminho_relativo, tipo_midia, tamanho_bytes,
                        data_documento, titulo, descricao, nome_original, data_criacao
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        doc_id,
                        caminho_relativo,
                        "imagem",
                        tamanho_bytes,
                        None,
                        titulo,
                        descricao,
                        nome_original,
                        agora,
                    ),
                )

                # Insere em documento_vinculos
                vinculo_id = str(uuid.uuid4())
                cur.execute(
                    """
                    INSERT INTO documento_vinculos (id, documento_id, pessoa_id, evento_id)
                    VALUES (?, ?, ?, NULL)
                    """,
                    (vinculo_id, doc_id, pessoa_id),
                )

                total_copiados += 1
                total_vinculos += 1

            if idx == 0:
                primeira_foto_caminho = caminho_relativo

        # Atualiza a foto_url da pessoa se estiver vazia ou se primeira foto definida
        if primeira_foto_caminho and (not foto_url_atual or foto_url_atual == ""):
            cur.execute(
                "UPDATE pessoas SET foto_url = ? WHERE id = ?",
                (primeira_foto_caminho, pessoa_id),
            )
            pessoas_info[pessoa_id]["foto_url"] = primeira_foto_caminho
            total_perfis_atualizados += 1

    conn.commit()
    conn.close()

    print("\n" + "=" * 70)
    print(" Sincronização Concluída com Sucesso!")
    print("=" * 70)
    print(f"Novos arquivos copiados para pasta de mídia: {total_copiados}")
    print(f"Novos vínculos de documentos criados:       {total_vinculos}")
    print(f"Perfis atualizados com foto principal:      {total_perfis_atualizados}")

    # Exibe resumo de pessoas com foto agora
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT count(*) FROM pessoas WHERE foto_url IS NOT NULL AND foto_url != ''")
    com_foto = cur.fetchone()[0]
    print(f"Total geral de pessoas com foto no acervo:   {com_foto}")

    print("\nAmostra de pessoas com fotos aplicadas:")
    cur.execute(
        """
        SELECT p.id, p.nome, p.sobrenome, p.foto_url 
        FROM pessoas p 
        WHERE p.foto_url IS NOT NULL AND p.foto_url != '' 
        LIMIT 10
        """
    )
    for r in cur.fetchall():
        print(f"  • {r[1]} {r[2] or ''} -> {r[3]}")
    conn.close()


if __name__ == "__main__":
    aplicar_fotos()
