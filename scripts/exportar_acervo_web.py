# -*- coding: utf-8 -*-
"""
Script de Exportação do Acervo Canônico para o Portal Web (EloTempo Fase 3).
Exporta as 78 árvores genealógicas públicas, perfis biográficos, obras culturais,
idiomas falados, linhas de contexto histórico e otimiza as fotos para a web.
"""

import sqlite3
import os
import sys
import json
import shutil
from pathlib import Path
from PIL import Image

Image.MAX_IMAGE_PIXELS = None  # Permite comprimir pinturas históricas em altíssima resolução para a web

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

# Caminhos
appdata_dir = Path(os.path.expandvars(r'%APPDATA%\com.elotempo.app'))
db_path = appdata_dir / "acervo.sqlite"
appdata_media = appdata_dir / "midia"

site_root = Path(r"e:\Trabalhos\Arvore Genealogica\elotempo-site")
acervo_dir = site_root / "acervo"
dados_dir = acervo_dir / "dados"
arvores_dir = dados_dir / "arvores"
web_media_dir = acervo_dir / "midia"

# Garantir diretórios
arvores_dir.mkdir(parents=True, exist_ok=True)
web_media_dir.mkdir(parents=True, exist_ok=True)

print(f"Conectando ao banco de dados: {db_path}")
conn = sqlite3.connect(db_path)
conn.row_factory = sqlite3.Row
cur = conn.cursor()

# 1. Carregar mapa de locais para enriquecimento
cur.execute("SELECT id, nome, uf, pais_id FROM locais")
locais_map = {row["id"]: {"nome": row["nome"], "uf": row["uf"], "pais_id": row["pais_id"]} for row in cur.fetchall()}

# 2. Carregar obras culturais agrupadas por pessoa
cur.execute("""
    SELECT id, pessoa_id, categoria, titulo, subtipo, ano, ano_fim, detalhes, local_id
    FROM obras_culturais
    ORDER BY ano ASC
""")
obras_por_pessoa = {}
for r in cur.fetchall():
    pid = r["pessoa_id"]
    lid = r["local_id"]
    local_info = locais_map.get(lid, {}) if lid else {}
    obra_dict = {
        "id": r["id"],
        "categoria": r["categoria"],
        "titulo": r["titulo"],
        "subtipo": r["subtipo"],
        "ano": r["ano"],
        "ano_fim": r["ano_fim"],
        "detalhes": r["detalhes"],
        "local_id": lid,
        "local_nome": local_info.get("nome")
    }
    obras_por_pessoa.setdefault(pid, []).append(obra_dict)

# 3. Carregar idiomas agrupados por pessoa
cur.execute("SELECT pessoa_id, idioma FROM idiomas_pessoa ORDER BY id")
idiomas_por_pessoa = {}
for r in cur.fetchall():
    idiomas_por_pessoa.setdefault(r["pessoa_id"], []).append(r["idioma"])

# 4. Carregar eventos agrupados por pessoa
cur.execute("""
    SELECT id, pessoa_id, tipo_evento, data_texto, ano_inicio, ano_fim, data_qualificador, local_id
    FROM eventos
    ORDER BY ano_inicio ASC
""")
eventos_por_pessoa = {}
for r in cur.fetchall():
    pid = r["pessoa_id"]
    if not pid:
        continue
    lid = r["local_id"]
    local_info = locais_map.get(lid, {}) if lid else {}
    ev_dict = {
        "id": r["id"],
        "tipo_evento": r["tipo_evento"],
        "data_texto": r["data_texto"],
        "ano_inicio": r["ano_inicio"],
        "ano_fim": r["ano_fim"],
        "qualificador": r["data_qualificador"],
        "local_id": lid,
        "local_nome": local_info.get("nome")
    }
    eventos_por_pessoa.setdefault(pid, []).append(ev_dict)

# 5. Processar e Otimizar Fotos de Pessoas Públicas
print("\nProcessando e otimizando retratos públicos para web...")
cur.execute("""
    SELECT DISTINCT p.id, p.foto_url
    FROM pessoas p
    WHERE p.is_publico = 1 AND p.foto_url IS NOT NULL
""")
fotos_publicas = cur.fetchall()
fotos_processadas = 0
bytes_economizados = 0

for row in fotos_publicas:
    rel_path = row["foto_url"]
    # Pode vir como "midia/uuid.jpg"
    filename = Path(rel_path).name
    orig_file = appdata_media / filename
    dest_file = web_media_dir / filename

    if orig_file.exists():
        try:
            # Se destino não existe ou é mais velho, converte/redimensiona
            if not dest_file.exists() or dest_file.stat().st_mtime < orig_file.stat().st_mtime:
                orig_size = orig_file.stat().st_size
                with Image.open(orig_file) as img:
                    # Converte para RGB se RGBA/P
                    if img.mode in ("RGBA", "P"):
                        img = img.convert("RGB")
                    # Redimensiona mantendo proporção até no máx 600x600
                    max_dim = 600
                    img.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
                    # Salva com compressão JPEG de alta qualidade e otimização
                    img.save(dest_file, "JPEG", quality=85, optimize=True)
                new_size = dest_file.stat().st_size
                bytes_economizados += (orig_size - new_size)
            fotos_processadas += 1
        except Exception as e:
            print(f"Aviso: Erro ao otimizar {orig_file.name}: {e}. Copiando arquivo original...")
            shutil.copy2(orig_file, dest_file)
            fotos_processadas += 1

print(f"Retratos otimizados com sucesso: {fotos_processadas}/{len(fotos_publicas)}")
print(f"Espaço economizado na otimização: {bytes_economizados / (1024*1024):.2f} MB")

# 6. Carregar Árvores Públicas e Exportar Dados Individuais
print("\nExportando as 78 árvores genealógicas públicas...")
cur.execute("""
    SELECT id, nome, descricao, raiz_pessoa_id, categoria, pais, periodo, tipo_tempo
    FROM arvores
    WHERE is_publico = 1
    ORDER BY categoria, nome
""")
arvores = cur.fetchall()

catalogo_arvores = []

for arv in arvores:
    aid = arv["id"]
    raiz_id = arv["raiz_pessoa_id"]

    # Membros da árvore
    cur.execute("""
        SELECT DISTINCT p.id, p.nome, p.sobrenome, p.sexo, p.minibiografia, p.is_vivo,
                        p.is_placeholder, p.foto_url, p.categoria, p.tipo_tempo
        FROM arvore_membros am
        JOIN pessoas p ON am.pessoa_id = p.id
        WHERE am.arvore_id = ?
        ORDER BY p.nome
    """, (aid,))
    membros_raw = cur.fetchall()

    membros_list = []
    raiz_info = None

    for m in membros_raw:
        pid = m["id"]
        evs = eventos_por_pessoa.get(pid, [])
        nasc = next((e for e in evs if e["tipo_evento"] == "nascimento"), None)
        falec = next((e for e in evs if e["tipo_evento"] in ("falecimento", "morte")), None)

        foto_web = f"midia/{Path(m['foto_url']).name}" if m["foto_url"] else None

        p_data = {
            "id": pid,
            "nome": m["nome"],
            "sobrenome": m["sobrenome"],
            "nome_completo": f"{m['nome']} {m['sobrenome'] or ''}".strip(),
            "sexo": m["sexo"],
            "minibiografia": m["minibiografia"],
            "is_vivo": bool(m["is_vivo"]),
            "is_placeholder": bool(m["is_placeholder"]),
            "foto_url": foto_web,
            "tipo_tempo": m["tipo_tempo"] or arv["tipo_tempo"],
            "categoria": m["categoria"],
            "ano_nascimento": nasc["ano_inicio"] if nasc else None,
            "ano_falecimento": falec["ano_inicio"] if falec else None,
            "data_nascimento_texto": nasc["data_texto"] if nasc else None,
            "data_falecimento_texto": falec["data_texto"] if falec else None,
            "local_nascimento": nasc["local_nome"] if nasc else None,
            "local_falecimento": falec["local_nome"] if falec else None,
            "obras": obras_por_pessoa.get(pid, []),
            "idiomas": idiomas_por_pessoa.get(pid, []),
            "eventos": evs
        }
        membros_list.append(p_data)

        if pid == raiz_id:
            raiz_info = p_data

    if not raiz_info and membros_list:
        raiz_info = membros_list[0]

    # Uniões da árvore
    cur.execute("""
        SELECT DISTINCT u.id, u.slot_masculino_id, u.slot_feminino_id, u.estado_vinculo, u.nota
        FROM unioes u
        WHERE u.slot_masculino_id IN (SELECT pessoa_id FROM arvore_membros WHERE arvore_id = ?)
           OR u.slot_feminino_id IN (SELECT pessoa_id FROM arvore_membros WHERE arvore_id = ?)
    """, (aid, aid))
    unioes_raw = cur.fetchall()

    unioes_list = []
    unioes_ids = [u["id"] for u in unioes_raw]

    # Filhos das uniões
    filhos_por_uniao = {}
    if unioes_ids:
        placeholders = ",".join(["?"] * len(unioes_ids))
        cur.execute(f"""
            SELECT uniao_id, pessoa_id, tipo_vinculo, ordem
            FROM uniao_filhos
            WHERE uniao_id IN ({placeholders})
            ORDER BY ordem ASC
        """, unioes_ids)
        for f in cur.fetchall():
            filhos_por_uniao.setdefault(f["uniao_id"], []).append({
                "pessoa_id": f["pessoa_id"],
                "tipo_vinculo": f["tipo_vinculo"],
                "ordem": f["ordem"]
            })

    for u in unioes_raw:
        uid = u["id"]
        unioes_list.append({
            "id": uid,
            "masculino_id": u["slot_masculino_id"],
            "feminino_id": u["slot_feminino_id"],
            "estado_vinculo": u["estado_vinculo"],
            "nota": u["nota"],
            "filhos": filhos_por_uniao.get(uid, [])
        })

    # Objeto completo da árvore
    arvore_detalhes = {
        "id": aid,
        "nome": arv["nome"],
        "descricao": arv["descricao"],
        "categoria": arv["categoria"],
        "pais": arv["pais"],
        "periodo": arv["periodo"],
        "tipo_tempo": arv["tipo_tempo"],
        "raiz_pessoa_id": raiz_id,
        "total_membros": len(membros_list),
        "total_unioes": len(unioes_list),
        "membros": membros_list,
        "unioes": unioes_list
    }

    # Salva arquivo individual da árvore
    tree_file = arvores_dir / f"{aid}.json"
    with open(tree_file, "w", encoding="utf-8") as f:
        json.dump(arvore_detalhes, f, ensure_ascii=False, indent=2)

    # Adiciona ao catálogo geral leve
    catalogo_arvores.append({
        "id": aid,
        "nome": arv["nome"],
        "descricao": arv["descricao"],
        "categoria": arv["categoria"],
        "pais": arv["pais"],
        "periodo": arv["periodo"],
        "tipo_tempo": arv["tipo_tempo"],
        "total_membros": len(membros_list),
        "total_obras": sum(len(m["obras"]) for m in membros_list),
        "membros_busca": [m["nome_completo"] for m in membros_list],
        "raiz": {
            "id": raiz_info["id"] if raiz_info else None,
            "nome": raiz_info["nome_completo"] if raiz_info else "Linhagem Histórica",
            "foto_url": raiz_info["foto_url"] if raiz_info else None,
            "ano_nascimento": raiz_info["ano_nascimento"] if raiz_info else None,
            "ano_falecimento": raiz_info["ano_falecimento"] if raiz_info else None
        } if raiz_info else None
    })

# Salva catálogo mestre
catalogo_file = dados_dir / "catalogo_arvores.json"
with open(catalogo_file, "w", encoding="utf-8") as f:
    json.dump(catalogo_arvores, f, ensure_ascii=False, indent=2)
print(f"Catálogo das 78 árvores gerado em: {catalogo_file}")

# 7. Exportar Linhas de Tempo e Marcos de Contexto
print("\nExportando Linhas de Tempo e Marcos Históricos de Contexto...")
cur.execute("""
    SELECT id, categoria, titulo, is_contexto, escopo, icone, fonte_referencia
    FROM linhas_tempo
    WHERE is_contexto = 1
    ORDER BY categoria, titulo
""")
linhas_tempo_raw = cur.fetchall()

# Normalização de categorias de linha de tempo
MAPA_CATEGORIAS_LT = {
    "historia": "História do Brasil",
    "moeda": "Moedas & Economia",
    "politica": "Poder e Governo",
    "tecnologia": "Tecnologia e Inovação",
    "projeto": "História Geral"
}

linhas_ids = [lt["id"] for lt in linhas_tempo_raw]
eventos_por_linha = {}
if linhas_ids:
    placeholders = ",".join(["?"] * len(linhas_ids))
    cur.execute(f"""
        SELECT id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim
        FROM eventos_linha
        WHERE linha_id IN ({placeholders})
        ORDER BY ano_inicio ASC
    """, linhas_ids)
    for el in cur.fetchall():
        eventos_por_linha.setdefault(el["linha_id"], []).append({
            "id": el["id"],
            "data_periodo_texto": el["data_periodo_texto"],
            "titulo": el["titulo"],
            "descricao": el["descricao"],
            "relevancia": el["relevancia"],
            "ano_inicio": el["ano_inicio"],
            "ano_fim": el["ano_fim"]
        })

linhas_tempo_list = []
total_marcos = 0
for lt in linhas_tempo_raw:
    lid = lt["id"]
    marcos = eventos_por_linha.get(lid, [])
    total_marcos += len(marcos)
    linhas_tempo_list.append({
        "id": lid,
        "categoria": MAPA_CATEGORIAS_LT.get(lt["categoria"], lt["categoria"]),
        "titulo": lt["titulo"],
        "is_contexto": bool(lt["is_contexto"]),
        "escopo": lt["escopo"],
        "icone": lt["icone"],
        "fonte_referencia": lt["fonte_referencia"],
        "total_marcos": len(marcos),
        "marcos": marcos
    })

linhas_file = dados_dir / "linhas_tempo.json"
with open(linhas_file, "w", encoding="utf-8") as f:
    json.dump(linhas_tempo_list, f, ensure_ascii=False, indent=2)
print(f"Linhas de tempo geradas em: {linhas_file} ({len(linhas_tempo_list)} linhas, {total_marcos} marcos)")

# 8. Estatísticas Globais Auditadas
cur.execute("SELECT COUNT(*) FROM pessoas WHERE is_publico = 1")
total_pessoas = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM obras_culturais")
total_obras = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM idiomas_pessoa")
total_idiomas = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM locais")
total_locais = cur.fetchone()[0]

estatisticas = {
    "total_arvores": len(catalogo_arvores),
    "total_pessoas": total_pessoas,
    "total_retratos": fotos_processadas,
    "total_obras": total_obras,
    "total_idiomas": total_idiomas,
    "total_locais": total_locais,
    "total_linhas_tempo": len(linhas_tempo_list),
    "total_marcos_contexto": total_marcos,
    "versao_software": "1.1.0"
}

stats_file = dados_dir / "estatisticas.json"
with open(stats_file, "w", encoding="utf-8") as f:
    json.dump(estatisticas, f, ensure_ascii=False, indent=2)

print("\n=== RESUMO DA EXPORTAÇÃO WEB CONCLUÍDA ===")
print(f"Árvores Exportadas: {len(catalogo_arvores)}")
print(f"Pessoas Públicas: {total_pessoas}")
print(f"Retratos Web Otimizados: {fotos_processadas}")
print(f"Obras Culturais: {total_obras}")
print(f"Idiomas Registrados: {total_idiomas}")
print(f"Linhas de Contexto: {len(linhas_tempo_list)} ({total_marcos} marcos)")
print(f"Local dos dados: {dados_dir}")
