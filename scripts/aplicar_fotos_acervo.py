"""
EloTempo - Aplicador de Fotos do Acervo (v4.1)
==============================================
Varre as imagens baixadas em `_imagens_elotempo/`, identifica com precisão
a qual pessoa cada imagem pertence no banco SQLite oficial (`acervo.sqlite`),
utilizando escopo estrito por árvore (evitando poluição cruzada entre homônimos),
copia os arquivos para a pasta segura de mídia do Tauri (`%APPDATA%/com.elotempo.app/midia/`)
e atualiza:
  1. `documentos` (registro do anexo com tamanho, título limpo e metadados detalhados de pintor/escultor/data/acervo/licença/fonte)
  2. `documento_vinculos` (vínculo formal documento <-> pessoa)
  3. `pessoas.foto_url` (foto de perfil principal que aparece no card da árvore e na ficha, PRESERVANDO edições manuais do usuário)

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
import re
from datetime import datetime, timezone
from pathlib import Path

# Garante suporte seguro a UTF-8 no Windows
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass


FOLDER_TO_ARVORES = {
    'casa-imperial-japao': ['pub_arv_casa_imperial_japao'],
    'kong-confucio': ['pub_arv_kong_confucio'],
    'lurie': ['pub_arv_lurie'],
    'bach': ['pub_arv_bach'],
    'curie': ['pub_arv_curie'],
    'darwin': ['pub_arv_darwin'],
    'casa-de-davi': ['arv_biblica_david'],
    'jesus-genealogia': ['pub_arv_jesus_mateus', 'pub_arv_jesus_lucas'],
    'moises': ['pub_arv_moises'],
    'patriarcas-israel': ['pub_arv_patriarcas_israel'],
    'penteado': ['pub_arv_penteado'],
    'prado': ['pub_arv_prado'],
    'rio-branco': ['pub_arv_rio_branco'],
    'souza-queiros': ['pub_arv_souza_queiros'],
    'franco': ['pub_arv_franco'],
    'hitler': ['pub_arv_hitler'],
    'mao': ['pub_arv_mao'],
    'mussolini': ['pub_arv_mussolini'],
    'stalin': ['pub_arv_stalin'],
    'bush': ['pub_arv_bush'],
    'guinle': ['pub_arv_guinle'],
    'klabin': ['pub_arv_klabin'],
    'matarazzo': ['pub_arv_matarazzo'],
    'rockefeller': ['pub_arv_rockefeller'],
    'dinastia-18': ['pub_arv_dinastia_18'],
    'dinastia-19': ['pub_arv_dinastia_19'],
    'dinastias-21-23': ['pub_arv_dinastias_21_23'],
    'buendia': ['pub_arv_buendia'],
    'corleone': ['pub_arv_corleone'],
    'lannister': ['pub_arv_lannister'],
    'skywalker': ['pub_arv_skywalker'],
    'terra-cambara': ['pub_arv_terra_cambara'],
    'independencia-1822': ['pub_arv_independencia_1822'],
    'kennedy': ['pub_arv_kennedy'],
    'peron': ['pub_arv_peron'],
    'roosevelt': ['pub_arv_roosevelt'],
    'bourbon': ['pub_arv_bourbon'],
    'habsburgo': ['pub_arv_habsburgo'],
    'outras-monarquias': ['pub_arv_outras_monarquias'],
    'windsor': ['arv_real_britanica'],
}


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
        "papa ", "dom ", "dona ", "d ", "santa ", "santo ", "sao ", "barao de ", "baronesa de ",
        "conde de ", "condessa de ", "duque de ", "duquesa de ", "presidente ",
        "farao ", "faraoh ", "virgem "
    ]
    norm = normalizar(texto)
    for p in prefixos:
        if norm.startswith(p):
            norm = norm[len(p):].strip()
    return norm


def limpar_titulo_obra(titulo: str) -> str:
    """Limpa prefixos multilíngues do Commons e redundâncias entre aspas."""
    if not titulo:
        return ""
    t = re.sub(r"^(?:[a-zçáéíóú]+:\s*)+", "", titulo, flags=re.IGNORECASE)
    t = t.strip(' "«»')
    if '"' in t:
        partes = [p.strip(' "«»') for p in t.split('"') if p.strip(' "«»')]
        if partes:
            t = partes[0]
    return t.strip()


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
        imagens_dir = raiz_script / "arvores-genealogicas" / "_imagens_elotempo"

    return db_path, midia_dir, imagens_dir


def carregar_indice_pessoas(conn: sqlite3.Connection):
    """Carrega pessoas do banco, mapeamento de árvores e membros."""
    cur = conn.cursor()
    cur.execute("SELECT id, nome, sobrenome, foto_url FROM pessoas")
    linhas = cur.fetchall()

    ids_existentes = set()
    mapa_nomes = {}
    pessoas_info = {}

    def add_mapa(chave: str, pid: str):
        if not chave:
            return
        if chave not in mapa_nomes:
            mapa_nomes[chave] = []
        if pid not in mapa_nomes[chave]:
            mapa_nomes[chave].append(pid)

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
                add_mapa(n1, pid)
                add_mapa(n2, pid)
                if "(" in candid:
                    sem_parenteses = candid.split("(")[0].strip()
                    add_mapa(normalizar(sem_parenteses), pid)
                    add_mapa(limpar_prefixos_titulo(sem_parenteses), pid)

    # Carrega membros de cada árvore
    cur.execute("SELECT arvore_id, pessoa_id FROM arvore_membros")
    membros_por_arvore = {}
    for aid, pid in cur.fetchall():
        membros_por_arvore.setdefault(aid, set()).add(pid)

    return ids_existentes, mapa_nomes, pessoas_info, membros_por_arvore


def encontrar_pessoa_ids_escopo(jf_path: Path, meta: dict, imagens_dir: Path, pessoas_info: dict, membros_por_arvore: dict) -> list[str]:
    """Identifica com rigor os pessoa_ids no escopo da árvore correspondente."""
    try:
        rel = jf_path.relative_to(imagens_dir)
        cat, tree_name, person_folder, fname = rel.parts
    except Exception:
        # Fallback se caminho relativo diferir
        parts = jf_path.parts
        if "_imagens_elotempo" in parts:
            idx = parts.index("_imagens_elotempo")
            cat = parts[idx + 1]
            tree_name = parts[idx + 2]
            person_folder = parts[idx + 3]
        else:
            return []

    target_arvores = FOLDER_TO_ARVORES.get(tree_name, [])
    candidate_pids = set()
    for aid in target_arvores:
        candidate_pids.update(membros_por_arvore.get(aid, set()))

    # Filtra apenas pessoas válidas, ignorando placeholders desconhecidos
    candidate_pids = {
        p for p in candidate_pids
        if p and p in pessoas_info and not (p.startswith("pub_ph_") and pessoas_info[p]["nome"] == "Desconhecido")
    }

    person = meta.get("person", {})
    name_pub = person.get("name_public", "")
    block = person.get("block_title", "")
    name_reg = person.get("name_registered", "")

    found = []

    pfolder_norm = normalizar(person_folder).replace(" ", "_")
    pfolder_clean = limpar_prefixos_titulo(person_folder).replace(" ", "_")

    # Mapeamento canônico preciso para árvores bíblicas
    if tree_name == "jesus-genealogia":
        pf_low = normalizar(person_folder)
        if pf_low == "jesus de nazare":
            found = [p for p in ["pub_jesus_mateus", "pub_jesus_lucas"] if p in candidate_pids]
        elif pf_low in ["virgem maria de nazare", "maria de nazare"]:
            found = [p for p in ["pub_mat_maria", "pub_luc_maria"] if p in candidate_pids]
        elif pf_low in ["sao jose de nazare", "jose de nazare"]:
            found = [p for p in ["pub_mat_jose", "pub_luc_jose"] if p in candidate_pids]
        elif pf_low == "salomao":
            found = [p for p in ["pub_mat_salomao"] if p in candidate_pids]
        elif pf_low in ["rei david de israel", "david de israel"]:
            found = [p for p in ["pub_mat_davi", "pub_luc_davi"] if p in candidate_pids]
        elif pf_low == "abraao":
            found = [p for p in ["pub_mat_abraao", "pub_luc_abraao"] if p in candidate_pids]
        elif pf_low == "isaac":
            found = [p for p in ["pub_mat_isaac", "pub_luc_isaac"] if p in candidate_pids]
        elif "jaco" in pf_low:
            found = [p for p in ["pub_mat_jaco_patriarca", "pub_luc_jaco_patriarca"] if p in candidate_pids]
        elif pf_low == "juda":
            found = [p for p in ["pub_mat_juda", "pub_luc_juda"] if p in candidate_pids]
        elif pf_low == "boaz":
            found = [p for p in ["pub_mat_boaz", "pub_luc_boaz"] if p in candidate_pids]
        elif "joda" in pf_low:
            found = [p for p in ["pub_luc_jose_pos_exilio"] if p in candidate_pids]
        elif "matatias" in pf_low and "jose" in pf_low:
            found = [p for p in ["pub_luc_jose_recente"] if p in candidate_pids]
        elif "matatias" in pf_low and "amos" in pf_low:
            found = [p for p in ["pub_luc_matatias_recente"] if p in candidate_pids]
        elif "clopas" in pf_low:
            found = [p for p in ["pub_luc_maria_clopas"] if p in candidate_pids]
        elif "joao batista" in pf_low:
            found = [p for p in ["pub_luc_joao_batista"] if p in candidate_pids]
        elif "isabel" in pf_low:
            found = [p for p in ["pub_luc_isabel"] if p in candidate_pids]
        elif "zacarias" in pf_low:
            found = [p for p in ["pub_luc_zacarias"] if p in candidate_pids]
        elif "josafa" in pf_low:
            found = [p for p in ["pub_mat_josafa"] if p in candidate_pids]

    # 1. Checagem exata por sufixo de ID (evita falso positivo quando slug da árvore está no nome)
    if not found:
        for pid in candidate_pids:
            if pid.endswith(f"_{pfolder_norm}") or pid == f"pub_{pfolder_norm}":
                found.append(pid)
            elif pid.endswith(f"_{pfolder_clean}") or pid == f"pub_{pfolder_clean}":
                found.append(pid)

    # 2. Casamento por nomes estritamente dentro da árvore alvo
    if not found:
        names_to_try = [normalizar(name_pub), normalizar(person_folder), normalizar(block), normalizar(name_reg)]
        names_to_try += [limpar_prefixos_titulo(n) for n in names_to_try]
        for n in list(names_to_try):
            if "(" in n:
                names_to_try.append(normalizar(n.split("(")[0]))
                names_to_try.append(limpar_prefixos_titulo(n.split("(")[0]))

        for pid in candidate_pids:
            p_data = pessoas_info[pid]
            p_full = normalizar(f"{p_data['nome'] or ''} {p_data['sobrenome'] or ''}")
            p_clean = limpar_prefixos_titulo(p_full)
            p_nome = normalizar(p_data["nome"] or "")
            p_clean_nome = limpar_prefixos_titulo(p_nome)

            for nt in names_to_try:
                if not nt:
                    continue
                if nt == p_full or nt == p_clean or nt == p_nome or nt == p_clean_nome:
                    found.append(pid)
                    break
                if len(nt.split()) >= 2 and (nt in p_full or p_full in nt):
                    found.append(pid)
                    break

    return sorted(list(set(found)))


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
    print(" EloTempo - Vinculador de Fotos do Acervo (v4.1)")
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

    ids_existentes, mapa_nomes, pessoas_info, membros_por_arvore = carregar_indice_pessoas(conn)
    print(f"Total de pessoas no banco: {len(ids_existentes)}")

    # Localiza todos os arquivos .json
    json_files = sorted(list(imagens_dir.glob("*/*/*/*.json")))
    print(f"Arquivos JSON encontrados: {len(json_files)}")

    # Agrupa imagens por pessoa_id
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

        pessoa_ids = encontrar_pessoa_ids_escopo(jf, meta, imagens_dir, pessoas_info, membros_por_arvore)
        if not pessoa_ids:
            nao_identificados.append(jf)
            continue

        img_path = encontrar_arquivo_imagem(jf, meta)
        if not img_path or not img_path.exists():
            sem_imagem.append(jf)
            continue

        for pessoa_id in pessoa_ids:
            if pessoa_id not in por_pessoa:
                por_pessoa[pessoa_id] = []

            por_pessoa[pessoa_id].append({
                "jf": jf,
                "img": img_path,
                "meta": meta,
            })

    print(f"\nPessoas identificadas com fotos: {len(por_pessoa)}")
    if nao_identificados:
        print(f"Aviso: {len(nao_identificados)} metadados não casados com pessoas do banco:")
        for ni in nao_identificados:
            print(f"  - {ni}")
    if sem_imagem:
        print(f"Aviso: {len(sem_imagem)} metadados sem arquivo de imagem correspondente.")

    # Processa inserções e cópias
    total_copiados = 0
    total_vinculos = 0
    total_atualizados_meta = 0
    total_perfis_atualizados = 0

    for pessoa_id, itens in por_pessoa.items():
        itens.sort(key=lambda x: x["img"].name)

        p_info = pessoas_info[pessoa_id]
        nome_exibicao = f"{p_info['nome'] or ''} {p_info['sobrenome'] or ''}".strip()
        foto_url_atual = p_info["foto_url"]

        primeira_foto_caminho = None

        for idx, item in enumerate(itens):
            img_file = item["img"]
            meta = item["meta"]
            nome_original = img_file.name

            # Monta descrição e título aprimorados
            artwork = meta.get("artwork") or {}
            art_desc = artwork.get("formatted_description")
            art_title = artwork.get("title")
            clean_title = limpar_titulo_obra(art_title)

            rights = meta.get("rights", {})
            licenca = rights.get("license", "")
            autor = artwork.get("artist") or rights.get("author") or rights.get("artist") or ""
            fonte = meta.get("provenance", {}).get("source_provider") or meta.get("source_record", {}).get("declared_source")

            descricao_partes = []
            if art_desc:
                descricao_partes.append(f"Obra: {art_desc}")
            elif autor:
                descricao_partes.append(f"Autor: {autor}")
            if licenca:
                descricao_partes.append(f"Licença: {licenca}")
            if fonte:
                descricao_partes.append(f"Fonte: {fonte}")
            nova_desc = " | ".join(descricao_partes) if descricao_partes else None

            if clean_title and clean_title != nome_original:
                novo_titulo = f"Retrato: {clean_title} - {nome_exibicao}"
            else:
                novo_titulo = f"Retrato - {nome_exibicao}" if idx == 0 else f"Foto adicional - {nome_exibicao}"

            # Verifica se já está cadastrado para esta pessoa
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
                if nova_desc:
                    cur.execute(
                        "UPDATE documentos SET descricao = ?, titulo = ? WHERE id = ?",
                        (nova_desc, novo_titulo, doc_id),
                    )
                    total_atualizados_meta += 1
            else:
                ext = img_file.suffix.lower()
                doc_id = str(uuid.uuid4())
                nome_destino = f"{doc_id}{ext}"
                destino_completo = midia_dir / nome_destino

                shutil.copy2(img_file, destino_completo)
                tamanho_bytes = destino_completo.stat().st_size
                caminho_relativo = f"midia/{nome_destino}"
                agora = datetime.now(timezone.utc).isoformat()

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
                        novo_titulo,
                        nova_desc,
                        nome_original,
                        agora,
                    ),
                )

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

        # Atualiza foto de perfil APENAS se o usuário ainda não tiver definido uma foto manual
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
    print(f"Novos arquivos copiados para pasta de mídia:  {total_copiados}")
    print(f"Novos vínculos de documentos criados:        {total_vinculos}")
    print(f"Metadados de obras e descrições atualizados: {total_atualizados_meta}")
    print(f"Perfis vazios atualizados com foto padrão:   {total_perfis_atualizados}")

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT count(*) FROM pessoas WHERE foto_url IS NOT NULL AND foto_url != ''")
    com_foto = cur.fetchone()[0]
    print(f"Total geral de pessoas com foto no acervo:    {com_foto}")
    conn.close()


if __name__ == "__main__":
    aplicar_fotos()
