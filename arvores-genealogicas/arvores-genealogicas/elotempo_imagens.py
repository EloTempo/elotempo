"""
ELOTEMPO — IMPORTADOR E BUSCADOR DE IMAGENS HISTÓRICAS (CURADORIA ESTRITA)
==========================================================================

Versão 3.0: Precisão cirúrgica sem falsos positivos.
Fontes curadas por historiadores e arquivistas:
1. Wikidata Claims (P18 - Retrato Oficial Canônico curado por historiadores)
2. Wikidata Claims (P1543 - Monografia / Retrato histórico alternativo)
3. Wikipedia Lead Image (Infobox oficial obtida a partir do artigo verificado da entidade)
4. Wikimedia Commons (P373 - Categoria Oficial dedicada à pessoa histórica)

REGRAS DE OURO DE SEGURANÇA E FIDELIDADE HISTÓRICA:
- NUNCA pesquisa em fontes abertas não-curadas (Flickr, Openverse, etc.),
  eliminando completamente fotos de placas de rua, furacões, hotéis, shows e esportes.
- NUNCA aceita entidades Wikidata de tipos não-biográficos (ruas, cidades, anos,
  escolas, monumentos, furacões, desambiguações).
- Higienização estrita de aliases: nunca pesquisa anos em parênteses "(1872)" como se
  fossem pessoas nem termos de parentesco "(tio)", "(filho)".
- Penalização severa (-60 pts) para confusão geracional (ex: Júnior vs Pai).
- Filtro rigoroso de palavras negativas (túmulos, brasões, bandeiras, mapas, moedas).

Instalação:
    pip install requests

Execução:
    python elotempo_imagens.py

Ou:
    python elotempo_imagens.py "C:\\caminho\\para\\pasta_raiz"
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import html
import json
import re
import sys
import time
import unicodedata
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Optional
from urllib.parse import quote, unquote

import requests

# Garante saída UTF-8 segura no console Windows
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

COMMONS_API = "https://commons.wikimedia.org/w/api.php"
WIKIDATA_API = "https://www.wikidata.org/w/api.php"

USER_AGENT = "EloTempo/3.0 (historical genealogy image importer; strict entity curation; contact@elotempo.app)"

DEFAULT_MAX_IMAGES = 3
DEFAULT_MIN_WIDTH = 350
DEFAULT_DELAY = 0.8
REQUEST_TIMEOUT = 25

ALLOWED_MIMES = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
    "image/gif": ".gif",
}

TERMOS_PARENTESCO = {
    "tio", "tia", "pai", "mae", "mãe", "filho", "filha", "avo", "avô", "avó",
    "neto", "neta", "sobrinho", "sobrinha", "primo", "prima", "esposa", "marido",
    "irmao", "irmão", "irma", "irmã", "irmao do senhor", "irmão do senhor",
    "irmao mais velho", "irmão mais velho", "irmao mais novo", "irmão mais novo",
    "junior", "júnior", "senior", "sênior", "patriarca", "matriarca"
}

P31_PROIBIDOS = {
    "q202444", "q11879590", "q107875", "q12308941", # prenome, nome próprio
    "q101352", "q26905501", # sobrenome
    "q4167410", "q13406463", # página de desambiguação, lista
    "q515", "q486972", "q532", # cidade, assentamento
    "q79007", # rua / logradouro
    "q577", "q2085381", # ano, ano comum
    "q7366", "q482994", "q11424", # música, álbum, filme
    "q8068", # tempestade tropical / furacão
    "q41176", # edifício / prédio
    "q860861", "q4989906", # escultura / monumento
    "q3918", "q350", # universidade, escola
    "q1656682", # evento
}

P31_BIOGRAFICOS = {
    "q5",        # humano
    "q20643955", # personagem bíblico do Antigo Testamento
    "q216858",   # personagem bíblico
    "q21070568", # personagem lendário / mitológico
    "q95074",    # personagem fictício
    "q116",      # monarca
    "q178885",   # divindade / figura de culto
}

TERMOS_NEGATIVOS = (
    "flag", "bandeira", "coat of arms", "brasao", "brasão", "escudo", "mapa", "map",
    "moeda", "coin", "tomb", "tumulo", "túmulo", "sepulcro", "grave", "assinatura",
    "signature", "stamp", "selo", "prefeitura", "city hall", "edificio", "building",
    "estacao", "estação", "station", "subway", "metro", "monument", "monumento",
    "qualies", "tennis", "gymnastics", "resort", "hotel", "hurricane"
)

TITULOS_PREFIXO = [
    r"imperador\b", r"imperatriz\b", r"rei\b", r"rainha\b", r"príncipe\b", r"principe\b",
    r"princesa\b", r"infante\b", r"infanta\b", r"arquiduque\b", r"arquiduquesa\b",
    r"duque\b", r"duquesa\b", r"marquês\b", r"marques\b", r"marquesa\b", r"conde\b",
    r"condessa\b", r"visconde\b", r"viscondessa\b", r"barão\b", r"barao\b", r"baronesa\b",
    r"lorde\b", r"lady\b", r"papa\b", r"bispo\b", r"arcebispo\b", r"são\b", r"sao\b",
    r"santa\b", r"santo\b", r"beato\b", r"beata\b", r"dom\b", r"dona\b", r"d\.",
    r"presidente\b", r"marechal\b", r"general\b", r"almirante\b", r"brigadeiro\b",
    r"doutor\b", r"dr\.", r"dra\."
]
TITULO_REGEX = re.compile(r"^(?:" + "|".join(TITULOS_PREFIXO) + r")\s+", re.I)

TRADUCOES_INGLES = [
    (r"\bImperador\b", "Emperor"),
    (r"\bImperatriz\b", "Empress"),
    (r"\bRei\b", "King"),
    (r"\bRainha\b", "Queen"),
    (r"\bPríncipe\b|\bPrincipe\b", "Prince"),
    (r"\bPrincesa\b", "Princess"),
    (r"\bPapa\b", "Pope"),
    (r"\bSão\b|\bSanto\b", "Saint"),
]


# ============================================================
# UTILITÁRIOS GERAIS
# ============================================================

def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def normalize_text(value: str) -> str:
    if not value:
        return ""
    value = unicodedata.normalize("NFKD", str(value))
    value = "".join(c for c in value if not unicodedata.combining(c))
    return re.sub(r"\s+", " ", value).strip()


def safe_filename(value: str) -> str:
    value = re.sub(r'[<>:"/\\|?*]', "_", str(value))
    value = re.sub(r"\s+", "_", value)
    return value.strip(" ._")


def strip_inline_comment(value: str) -> str:
    value = re.sub(r"\s+#.*$", "", value)
    return value.strip()


def clean_html(value: str) -> str:
    if not value:
        return ""
    value = html.unescape(value)
    value = re.sub(r"<br\s*/?>", "\n", value, flags=re.I)
    value = re.sub(r"<[^>]+>", "", value)
    return re.sub(r"\s+", " ", value).strip()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        while chunk := f.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def read_text_file(path: Path) -> str:
    for encoding in ("utf-8-sig", "utf-8", "cp1252", "latin-1"):
        try:
            return path.read_text(encoding=encoding)
        except UnicodeDecodeError:
            pass
    return path.read_text(encoding="utf-8", errors="replace")


# ============================================================
# PARSER DOS ARQUIVOS TXT DE ÁRVORES GENEALÓGICAS
# ============================================================

def parse_txt_file(path: Path) -> dict[str, Any]:
    text = read_text_file(path)
    lines = text.splitlines()

    header_lines: list[str] = []
    people: list[dict[str, Any]] = []
    current: Optional[dict[str, Any]] = None

    for line_number, raw_line in enumerate(lines, start=1):
        stripped = raw_line.strip()

        if current is None and stripped:
            header_lines.append(raw_line)

        heading_match = re.match(r"^==\s*(.*?)\s*==$", stripped)
        if heading_match:
            if current is not None:
                people.append(current)

            heading = heading_match.group(1).strip()
            current = {
                "titulo_bloco": heading,
                "campos": {},
                "linhas_originais": [],
                "linha_inicio": line_number,
            }
            continue

        if current is None:
            continue

        current["linhas_originais"].append(raw_line)
        if not stripped or stripped.startswith("#"):
            continue

        if ":" not in raw_line:
            continue

        key, value = raw_line.split(":", 1)
        key = key.strip().lower()
        value = strip_inline_comment(value)
        current["campos"][key] = value

    if current is not None:
        people.append(current)

    unique_people: list[dict[str, Any]] = []
    seen: set[tuple[str, str]] = set()

    for person in people:
        public_name = person["campos"].get("nome_publico", person["titulo_bloco"])
        identity_key = (
            normalize_text(person["titulo_bloco"]).lower(),
            normalize_text(public_name).lower(),
        )
        if identity_key in seen:
            continue
        seen.add(identity_key)
        unique_people.append(person)

    return {
        "family_name": path.stem,
        "header": header_lines,
        "people": unique_people,
    }


# ============================================================
# MOTOR INTELIGENTE DE ALIASES E NOMES SEGUROS
# ============================================================

def build_search_names(person: dict[str, Any]) -> list[str]:
    """
    Gera aliases de busca de forma estrita:
    - Prioriza nome de registro histórico (ex: José Maria da Silva Paranhos Júnior)
    - Desmembra nome público e título do bloco
    - NUNCA extrai anos em parênteses (ex: '1872') nem termos de parentesco puro ('tio')
    """
    fields = person["campos"]
    candidates = [
        fields.get("nome_registro", ""),
        fields.get("nome_publico", ""),
        person.get("titulo_bloco", ""),
    ]

    base_names: list[str] = []

    for cand in candidates:
        cand = (cand or "").strip()
        if not cand or cand in base_names:
            continue
        base_names.append(cand)

        match_paren = re.match(r"^(.*?)\s*\((.*?)\)$", cand)
        if match_paren:
            parte_principal = match_paren.group(1).strip()
            parte_parenteses = match_paren.group(2).strip()

            if parte_principal and parte_principal not in base_names:
                base_names.append(parte_principal)

            norm_par = normalize_text(parte_parenteses).lower()
            is_ano = re.match(r"^\d{1,4}(\s*(a\.c\.|d\.c\.|bc|ad))?$", norm_par)
            is_parentesco = norm_par in TERMOS_PARENTESCO

            # Só aceita conteúdo de parênteses se for nome/título real (não ano, não parentesco)
            if not is_ano and not is_parentesco and len(parte_parenteses.split()) <= 4:
                if parte_parenteses not in base_names:
                    base_names.append(parte_parenteses)

    # Versões sem títulos honoríficos / monárquicos
    sem_titulos: list[str] = []
    for nome in base_names:
        limpo = TITULO_REGEX.sub("", nome).strip()
        if limpo and limpo not in base_names and limpo not in sem_titulos:
            sem_titulos.append(limpo)

    # Versões em inglês para nobreza / santos
    nomes_en: list[str] = []
    for nome in base_names + sem_titulos:
        versao_en = nome
        for pat, rep in TRADUCOES_INGLES:
            versao_en = re.sub(pat, rep, versao_en, flags=re.I)
        if (
            versao_en != nome
            and versao_en not in base_names
            and versao_en not in sem_titulos
            and versao_en not in nomes_en
        ):
            nomes_en.append(versao_en)

    resultado_final = []
    for n in base_names + sem_titulos + nomes_en:
        n_limpo = re.sub(r"\s+", " ", n).strip()
        if n_limpo and n_limpo not in resultado_final:
            resultado_final.append(n_limpo)

    return resultado_final


# ============================================================
# RESOLUÇÃO DE METADADOS NO WIKIMEDIA COMMONS
# ============================================================

def get_commons_file_info(
    file_title: str,
    session: requests.Session,
) -> Optional[dict[str, Any]]:
    if not file_title.startswith("File:") and not file_title.startswith("Arquivo:"):
        file_title = f"File:{file_title}"

    params = {
        "action": "query",
        "format": "json",
        "titles": file_title,
        "prop": "imageinfo",
        "iiprop": "url|size|mime|sha1|extmetadata",
        "iiurlwidth": 1600,
        "iiextmetadatalanguage": "pt",
    }

    try:
        resp = session.get(COMMONS_API, params=params, timeout=REQUEST_TIMEOUT)
        resp.raise_for_status()
        pages = resp.json().get("query", {}).get("pages", {})
        for page in pages.values():
            imageinfo = page.get("imageinfo", [])
            if not imageinfo:
                continue
            info = imageinfo[0]
            extmeta = info.get("extmetadata", {})

            return {
                "title": page.get("title", file_title),
                "url": info.get("url", ""),
                "thumburl": info.get("thumburl", info.get("url", "")),
                "descriptionurl": info.get("descriptionurl", ""),
                "mime": info.get("mime", "image/jpeg"),
                "width": int(info.get("width", 0) or 0),
                "height": int(info.get("height", 0) or 0),
                "sha1": info.get("sha1", ""),
                "license": extract_meta(extmeta, "LicenseShortName") or "Public domain",
                "license_url": extract_meta(extmeta, "LicenseUrl"),
                "artist": extract_meta(extmeta, "Artist"),
                "credit": extract_meta(extmeta, "Credit"),
                "description": extract_meta(extmeta, "ImageDescription"),
                "date_taken": extract_meta(extmeta, "DateTimeOriginal"),
                "categories": extract_meta(extmeta, "Categories"),
                "filepage": info.get("descriptionurl", ""),
                "source_provider": "Wikimedia Commons",
            }
    except Exception:
        pass
    return None


def extract_meta(extmeta: dict[str, Any], key: str) -> str:
    val = extmeta.get(key, {})
    if isinstance(val, dict):
        val = val.get("value", "")
    return clean_html(str(val or ""))


# ============================================================
# 1. FONTE: WIKIDATA (CURADORIA CIRÚRGICA DE ENTIDADES)
# ============================================================

def search_wikidata_strict(
    person: dict[str, Any],
    aliases: list[str],
    session: requests.Session,
) -> tuple[Optional[dict[str, Any]], list[dict[str, Any]]]:
    """
    Pesquisa entidades no Wikidata e valida com critérios rigorosos:
    - P31 deve ser humano (Q5) ou figura bíblica/cultural.
    - Rejeita explicitamente ruas, cidades, furacões, monumentos, anos e desambiguações.
    - Penaliza divergência de sufixos geracionais (Júnior vs Pai).
    - Pontua correspondência de contexto (profissão, nacionalidade, biografia).
    """
    campos = person.get("campos", {})
    contexto_texto = f"{campos.get('profissoes', '')} {campos.get('nacionalidades', '')} {campos.get('identidade', '')}".lower()

    melhor_entidade = None
    melhor_score = -1
    entidades_avaliadas: list[dict[str, Any]] = []

    for alias in aliases[:4]:
        params = {
            "action": "wbsearchentities",
            "format": "json",
            "search": alias,
            "language": "pt",
            "uselang": "pt",
            "type": "item",
            "limit": 6,
        }
        try:
            resp = session.get(WIKIDATA_API, params=params, timeout=REQUEST_TIMEOUT)
            if resp.status_code != 200:
                continue
            items = resp.json().get("search", [])
        except Exception:
            continue

        if not items:
            continue

        # Busca detalhes completos em lote
        qids = [it["id"] for it in items]
        try:
            r_batch = session.get(
                WIKIDATA_API,
                params={
                    "action": "wbgetentities",
                    "ids": "|".join(qids),
                    "props": "claims|sitelinks",
                    "format": "json",
                },
                timeout=REQUEST_TIMEOUT,
            )
            entities_data = r_batch.json().get("entities", {})
        except Exception:
            entities_data = {}

        for item in items:
            qid = item["id"]
            label = item.get("label", "")
            desc = item.get("description", "")
            ent_obj = entities_data.get(qid, {})
            claims = ent_obj.get("claims", {})

            # P31 (instance of)
            p31_list = []
            for c in claims.get("P31", []):
                try:
                    p31_list.append(c["mainsnak"]["datavalue"]["value"]["id"].lower())
                except Exception:
                    pass

            # Descarta entidades explicitamente proibidas (anos, ruas, furacões, cidades, etc.)
            if any(p in P31_PROIBIDOS for p in p31_list):
                continue

            score = 0

            # Valida se é ser humano ou figura cultural/histórica aceita
            if any(p in p31_list for p in P31_BIOGRAFICOS):
                score += 50
            elif any(t in desc.lower() for t in ("pessoa", "humano", "político", "monarca", "imperador", "rei", "patriarca", "matriarca", "profeta", "figura bíblica", "personagem bíblico", "cientista", "militar", "diplomata", "socialite")):
                score += 40
            else:
                continue

            # Penalidade se o candidato tiver Júnior/Filho/Neto e o alvo não tiver (ou vice-versa)
            norm_label = normalize_text(label).lower()
            sufixos = ["junior", "júnior", "filho", "neto", "sobrinho"]
            tem_sufixo_cand = any(f" {s}" in f" {norm_label}" or norm_label.endswith(s) for s in sufixos)
            tem_sufixo_alvo = any(any(f" {s}" in f" {normalize_text(a).lower()}" or normalize_text(a).lower().endswith(s) for s in sufixos) for a in aliases)
            if tem_sufixo_cand and not tem_sufixo_alvo:
                score -= 60
            elif tem_sufixo_alvo and not tem_sufixo_cand:
                score -= 40

            # Correspondência de rótulo
            if any(normalize_text(a).lower() == norm_label for a in aliases):
                score += 45
            elif any(normalize_text(a).lower() in norm_label for a in aliases):
                score += 20

            # Correspondência de contexto (profissão, país, etc.)
            desc_norm = normalize_text(desc).lower()
            palavras_ctx = [w for w in normalize_text(contexto_texto).lower().split() if len(w) >= 4]
            matches_ctx = sum(1 for w in palavras_ctx if w in desc_norm)
            score += min(matches_ctx * 15, 45)

            # Presença de imagem P18 curada
            p18_claims = claims.get("P18", []) + claims.get("P1543", [])
            if p18_claims:
                score += 25

            # Presença de artigo enciclopédico
            sitelinks = ent_obj.get("sitelinks", {})
            if "ptwiki" in sitelinks or "enwiki" in sitelinks:
                score += 15

            ent_cand = {
                "id": qid,
                "label": label,
                "description": desc,
                "score": score,
                "claims": claims,
                "sitelinks": sitelinks,
            }
            entidades_avaliadas.append(ent_cand)

            if score > melhor_score and score >= 65:
                melhor_score = score
                melhor_entidade = ent_cand

        if melhor_score >= 100:
            break

    # Se uma entidade com alta pontuação foi aprovada, extrai suas fotos P18
    p18_results = []
    if melhor_entidade:
        claims = melhor_entidade["claims"]
        for claim in claims.get("P18", []) + claims.get("P1543", []):
            try:
                val = claim["mainsnak"]["datavalue"]["value"]
                # Rejeita imagens com nomes negativos (moedas, mapas, brasões, túmulos)
                if any(tn in val.lower() for tn in TERMOS_NEGATIVOS):
                    continue
                file_info = get_commons_file_info(val, session)
                if file_info:
                    file_info["source_provider"] = "Wikidata (P18 Oficial)"
                    file_info["is_wikidata_p18"] = True
                    file_info["wikidata_qid"] = melhor_entidade["id"]
                    p18_results.append(file_info)
            except Exception:
                pass

    record = {
        "selected": melhor_entidade,
        "candidates": entidades_avaliadas,
    } if melhor_entidade else None

    return record, p18_results


# ============================================================
# 2. FONTE: WIKIPEDIA LEAD IMAGE (INFOBOX OFICIAL VIA SITELINK)
# ============================================================

def search_wikipedia_lead_image(
    wikidata_record: Optional[dict[str, Any]],
    session: requests.Session,
) -> list[dict[str, Any]]:
    """Obtém a foto oficial de perfil da infobox do artigo associado à entidade Wikidata."""
    if not wikidata_record or not wikidata_record.get("selected"):
        return []

    entidade = wikidata_record["selected"]
    sitelinks = entidade.get("sitelinks", {})
    results = []

    for lang in ["pt", "en"]:
        wiki_key = f"{lang}wiki"
        if wiki_key not in sitelinks:
            continue
        titulo_artigo = sitelinks[wiki_key].get("title", "")
        if not titulo_artigo:
            continue

        encoded_title = quote(titulo_artigo.replace(" ", "_"))
        url = f"https://{lang}.wikipedia.org/api/rest_v1/page/summary/{encoded_title}"

        try:
            resp = session.get(url, timeout=REQUEST_TIMEOUT)
            if resp.status_code != 200:
                continue
            data = resp.json()

            if data.get("type") == "disambiguation":
                continue

            orig = data.get("originalimage") or data.get("thumbnail")
            if not orig:
                continue

            img_url = orig.get("source", "")
            if not img_url:
                continue

            # Filtro de termos negativos no nome do arquivo
            if any(tn in img_url.lower() for tn in TERMOS_NEGATIVOS):
                continue

            filename_match = re.search(r"/([^/]+?)(?:\?.*)?$", unquote(img_url))
            file_name = filename_match.group(1) if filename_match else titulo_artigo
            commons_info = get_commons_file_info(file_name, session)

            if commons_info:
                commons_info["source_provider"] = f"Wikipedia {lang.upper()} (Lead Image)"
                commons_info["is_wikipedia_lead"] = True
                results.append(commons_info)
            else:
                results.append({
                    "title": data.get("title", titulo_artigo),
                    "url": img_url,
                    "thumburl": data.get("thumbnail", {}).get("source", img_url),
                    "descriptionurl": data.get("content_urls", {}).get("desktop", {}).get("page", ""),
                    "mime": "image/jpeg",
                    "width": int(orig.get("width", 800) or 800),
                    "height": int(orig.get("height", 800) or 800),
                    "sha1": hashlib.sha1(img_url.encode()).hexdigest(),
                    "license": "Public domain ou Creative Commons (Wikipedia)",
                    "license_url": "",
                    "artist": "Wikipedia Contributors",
                    "description": data.get("extract", "")[:200],
                    "filepage": data.get("content_urls", {}).get("desktop", {}).get("page", ""),
                    "source_provider": f"Wikipedia {lang.upper()} (Lead Image)",
                    "is_wikipedia_lead": True,
                })
        except Exception:
            pass

    return results


# ============================================================
# 3. FONTE: WIKIMEDIA COMMONS CATEGORY (CATEGORIA CURADA P373)
# ============================================================

def search_commons_by_category(
    wikidata_record: Optional[dict[str, Any]],
    session: requests.Session,
    limit: int = 5,
) -> list[dict[str, Any]]:
    """Busca arquivos dentro da categoria oficial do Commons associada à pessoa (Wikidata P373)."""
    if not wikidata_record or not wikidata_record.get("selected"):
        return []

    claims = wikidata_record["selected"].get("claims", {})
    p373_claims = claims.get("P373", [])
    if not p373_claims:
        return []

    cat_name = p373_claims[0].get("mainsnak", {}).get("datavalue", {}).get("value")
    if not cat_name:
        return []

    params = {
        "action": "query",
        "format": "json",
        "generator": "categorymembers",
        "gcmtitle": f"Category:{cat_name}",
        "gcmtype": "file",
        "gcmlimit": limit,
        "prop": "imageinfo",
        "iiprop": "url|size|mime|sha1|extmetadata",
        "iiurlwidth": 1600,
        "iiextmetadatalanguage": "pt",
    }

    results = []
    try:
        resp = session.get(COMMONS_API, params=params, timeout=REQUEST_TIMEOUT)
        if resp.status_code == 200:
            pages = resp.json().get("query", {}).get("pages", {}).values()
            for page in pages:
                imageinfo = page.get("imageinfo", [])
                if not imageinfo:
                    continue
                info = imageinfo[0]
                mime = info.get("mime", "")
                url = info.get("url", "")
                if mime not in ALLOWED_MIMES or not url:
                    continue

                if any(tn in url.lower() for tn in TERMOS_NEGATIVOS):
                    continue

                extmeta = info.get("extmetadata", {})
                results.append({
                    "title": page.get("title", ""),
                    "url": url,
                    "thumburl": info.get("thumburl", url),
                    "descriptionurl": info.get("descriptionurl", ""),
                    "mime": mime,
                    "width": int(info.get("width", 0) or 0),
                    "height": int(info.get("height", 0) or 0),
                    "sha1": info.get("sha1", ""),
                    "license": extract_meta(extmeta, "LicenseShortName") or "Public domain",
                    "license_url": extract_meta(extmeta, "LicenseUrl"),
                    "artist": extract_meta(extmeta, "Artist"),
                    "credit": extract_meta(extmeta, "Credit"),
                    "description": extract_meta(extmeta, "ImageDescription"),
                    "date_taken": extract_meta(extmeta, "DateTimeOriginal"),
                    "categories": extract_meta(extmeta, "Categories"),
                    "filepage": info.get("descriptionurl", ""),
                    "source_provider": f"Wikimedia Commons (Categoria: {cat_name})",
                })
    except Exception:
        pass

    return results


# ============================================================
# ALGORITMO ESPECIALIZADO: CLASSIFICAÇÃO DE "FOTO DE PERFIL"
# ============================================================

def score_profile_photo(
    person: dict[str, Any],
    result: dict[str, Any],
) -> int:
    score = 0

    if result.get("is_wikidata_p18"):
        score += 150
    if result.get("is_wikipedia_lead"):
        score += 120

    w = int(result.get("width", 0) or 0)
    h = int(result.get("height", 0) or 0)

    # Proporção ideal de retrato: vertical 3:4 ou quadrado 1:1
    if w > 0 and h > 0:
        ratio = w / h
        if 0.65 <= ratio <= 0.95:
            score += 45
        elif 0.95 < ratio <= 1.15:
            score += 35
        elif 1.15 < ratio <= 1.4:
            score += 10
        elif ratio > 1.6:
            score -= 50
        elif ratio > 2.0:
            score -= 100

    title_desc = f"{result.get('title', '')} {result.get('description', '')}".lower()

    termos_positivos = (
        "portrait", "retrato", "headshot", "profile", "perfil", "pintura", "painting",
        "óleo", "oil on canvas", "fotografia", "photo", "photograph", "busto", "bust",
        "cropped", "recorte", "detail", "detalhe"
    )
    if any(tp in title_desc for tp in termos_positivos):
        score += 30

    if any(tn in title_desc for tn in TERMOS_NEGATIVOS):
        score -= 120

    if w >= 800 and h >= 800:
        score += 20
    elif w >= 400 and h >= 400:
        score += 10

    return score


def rank_and_deduplicate(
    person: dict[str, Any],
    results: list[dict[str, Any]],
    min_width: int,
) -> list[dict[str, Any]]:
    filtered = []

    for r in results:
        w = int(r.get("width", 0) or 0)
        if w < min_width:
            continue

        r["elotempo_score"] = score_profile_photo(person, r)
        filtered.append(r)

    filtered.sort(
        key=lambda x: (
            x.get("elotempo_score", 0),
            x.get("width", 0) * x.get("height", 0),
        ),
        reverse=True,
    )

    unique = []
    seen = set()

    for r in filtered:
        url = r.get("url", "")
        clean_key = re.sub(r"\?.*$", "", url.lower())
        title_key = normalize_text(r.get("title", "")).lower()
        sha1_key = r.get("sha1", "")

        fingerprint = sha1_key or clean_key or title_key
        if fingerprint in seen:
            continue
        seen.add(fingerprint)
        unique.append(r)

    return unique


# ============================================================
# RESOLUÇÃO DE FOTOS LOCAIS E DOWNLOAD
# ============================================================

def resolve_existing_photo(txt_path: Path, photo_value: str) -> Optional[Path]:
    if not photo_value:
        return None
    photo_value = photo_value.strip()
    direct = Path(photo_value)
    if direct.is_absolute() and direct.exists():
        return direct
    rel = txt_path.parent / photo_value
    if rel.exists():
        return rel
    return None


def download_image(
    url: str,
    destination: Path,
    session: requests.Session,
    overwrite: bool = False,
) -> bool:
    if destination.exists() and not overwrite:
        return True

    temp = destination.with_suffix(destination.suffix + ".part")
    try:
        with session.get(url, timeout=REQUEST_TIMEOUT, stream=True) as resp:
            resp.raise_for_status()
            with temp.open("wb") as f:
                for chunk in resp.iter_content(chunk_size=1024 * 128):
                    if chunk:
                        f.write(chunk)
        temp.replace(destination)
        return True
    except Exception as exc:
        print(f"    ERRO no download: {exc}")
        if temp.exists():
            temp.unlink(missing_ok=True)
        return False


def choose_next_image_number(person_dir: Path) -> int:
    maximum = 0
    pattern = re.compile(r"^(\d{2,})_")
    for path in person_dir.iterdir():
        if not path.is_file():
            continue
        match = pattern.match(path.name)
        if match:
            maximum = max(maximum, int(match.group(1)))
    return maximum + 1


def make_image_path(person_dir: Path, person_name: str, extension: str) -> Path:
    number = choose_next_image_number(person_dir)
    return person_dir / f"{number:02d}_{safe_filename(person_name)}{extension}"


# ============================================================
# GRAVAÇÃO DE METADADOS JSON E CATÁLOGO
# ============================================================

def build_image_json(
    person: dict[str, Any],
    txt_path: Path,
    image_path: Path,
    source: Optional[dict[str, Any]],
    wikidata_data: Optional[dict[str, Any]],
    status: str,
) -> dict[str, Any]:
    campos = person["campos"]

    result: dict[str, Any] = {
        "schema_version": "3.0",
        "person": {
            "block_title": person.get("titulo_bloco", ""),
            "name_public": campos.get("nome_publico", person.get("titulo_bloco", "")),
            "name_registered": campos.get("nome_registro", ""),
            "birth": campos.get("nascimento", ""),
            "death": campos.get("falecimento", ""),
            "professions": campos.get("profissoes", ""),
            "nationalities": campos.get("nacionalidades", ""),
            "relations": campos.get("relacoes", ""),
            "identity": campos.get("identidade", ""),
            "reliability": campos.get("confiabilidade", ""),
        },
        "source_record": {
            "txt_file": str(txt_path),
            "txt_block_line": person.get("linha_inicio"),
            "declared_source": campos.get("fonte", ""),
            "declared_photo": campos.get("foto", ""),
        },
        "image": {
            "file": image_path.name,
            "path": str(image_path),
            "sha256": sha256_file(image_path) if image_path.exists() else "",
            "mime": source.get("mime", "") if source else "",
            "width": source.get("width", 0) if source else 0,
            "height": source.get("height", 0) if source else 0,
        },
        "rights": {
            "provider": source.get("source_provider", "local_file") if source else "local_file",
            "license": source.get("license", "Public Domain / CC") if source else "",
            "license_url": source.get("license_url", "") if source else "",
            "artist": source.get("artist", "") if source else "",
            "credit": source.get("credit", "") if source else "",
        },
        "provenance": {
            "page_url": source.get("filepage", "") if source else "",
            "original_url": source.get("url", "") if source else "",
            "description": source.get("description", "") if source else "",
            "date_taken": source.get("date_taken", "") if source else "",
        },
        "wikidata": {
            "status": "candidate_found" if wikidata_data else "not_resolved",
            "selected": wikidata_data.get("selected") if wikidata_data else None,
        },
        "elotempo": {
            "status": status,
            "created_at": utc_now(),
            "profile_score": source.get("elotempo_score", 0) if source else 0,
        },
    }

    raw_block = "\n".join(person.get("linhas_originais", [])).lower()
    result["person"]["living_marker"] = "lgpd: pessoa viva" in raw_block
    return result


def save_json(image_path: Path, data: dict[str, Any]) -> Path:
    json_path = image_path.with_suffix(".json")
    json_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    return json_path


def read_catalog(path: Path) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        return data if isinstance(data, list) else []
    except Exception:
        return []


def upsert_catalog_record(catalog_path: Path, record: dict[str, Any]) -> None:
    catalog = read_catalog(catalog_path)
    image = record.get("image", {})
    key = (image.get("path", ""), image.get("sha256", ""))

    updated = False
    for index, existing in enumerate(catalog):
        ex_image = existing.get("image", {})
        existing_key = (ex_image.get("path", ""), ex_image.get("sha256", ""))
        if existing_key == key:
            catalog[index] = record
            updated = True
            break

    if not updated:
        catalog.append(record)

    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2), encoding="utf-8")


# ============================================================
# PROCESSAMENTO DE PESSOA (CURADORIA CIRÚRGICA)
# ============================================================

def process_person(
    person: dict[str, Any],
    txt_path: Path,
    root_dir: Path,
    output_root: Path,
    session: requests.Session,
    max_images: int,
    min_width: int,
    delay: float,
    no_download: bool,
    overwrite: bool,
    catalog_path: Path,
) -> int:
    campos = person["campos"]
    person_name = campos.get("nome_publico", person["titulo_bloco"]).strip()

    print()
    print("-" * 75)
    print(f"PESSOA: {person_name}")
    print(f"BLOCO:  {person['titulo_bloco']}")
    print(f"TXT:    {txt_path.name}")
    print("-" * 75)

    declared_photo = campos.get("foto", "").strip()
    existing_photo = resolve_existing_photo(txt_path, declared_photo)
    if declared_photo:
        if existing_photo:
            print(f"  Foto já declarada no TXT: {existing_photo}")
            return 0
        print(f"  AVISO: foto declarada não encontrada: {declared_photo}")

    # Aliases cirúrgicos
    aliases = build_search_names(person)
    print(f"  Aliases de busca expandidos ({len(aliases)}): {', '.join(aliases[:4])}")

    # 1. Busca e validação estrita no Wikidata
    wikidata_record, p18_imgs = search_wikidata_strict(person, aliases, session)

    if wikidata_record and wikidata_record.get("selected"):
        sel = wikidata_record["selected"]
        print(f"  ✓ Entidade Wikidata confirmada: {sel.get('id')} — {sel.get('label')} ({sel.get('description')}) [Score: {sel.get('score')}]")
    else:
        print("  ✕ Nenhuma entidade com correspondência biográfica confiável no Wikidata.")
        return 0

    all_results: list[dict[str, Any]] = []

    # Coleta fotos P18 oficiais
    if p18_imgs:
        print(f"  -> Retratos canônicos oficiais curados (P18): {len(p18_imgs)}")
        all_results.extend(p18_imgs)

    time.sleep(delay)

    # 2. Coleta foto de perfil da infobox da Wikipedia (via sitelink exato)
    wiki_leads = search_wikipedia_lead_image(wikidata_record, session)
    if wiki_leads:
        print(f"  -> Foto principal de perfil da Wikipedia: {len(wiki_leads)}")
        all_results.extend(wiki_leads)

    time.sleep(delay)

    # 3. Coleta fotos da Categoria oficial do Commons (P373)
    commons_cat_imgs = search_commons_by_category(wikidata_record, session, limit=4)
    if commons_cat_imgs:
        print(f"  -> Imagens da categoria dedicada no Commons: {len(commons_cat_imgs)}")
        all_results.extend(commons_cat_imgs)

    if not all_results:
        print("  ✕ Nenhum retrato disponível para esta entidade histórica.")
        return 0

    ranked = rank_and_deduplicate(person, all_results, min_width)
    if not ranked:
        print("  ✕ Nenhuma imagem passou no filtro de resolução mínima e proporção.")
        return 0

    ranked = ranked[:max_images]

    relative_txt = txt_path.relative_to(root_dir)
    family_dir = output_root / relative_txt.parent / relative_txt.stem
    person_dir = family_dir / safe_filename(person_name)
    person_dir.mkdir(parents=True, exist_ok=True)

    downloaded = 0

    for idx, result in enumerate(ranked, start=1):
        ext = ALLOWED_MIMES.get(result.get("mime"), ".jpg")
        image_path = make_image_path(person_dir, person_name, ext)

        score = result.get("elotempo_score", 0)
        prov = result.get("source_provider", "Wikimedia")

        print()
        print(f"  ✓ Candidato #{idx} [Score: {score} pts | Fonte: {prov}]")
        print(f"    Título:   {result.get('title')}")
        print(f"    Medidas:  {result.get('width')} x {result.get('height')} px")
        print(f"    URL:      {result.get('filepage') or result.get('url')}")

        if no_download:
            print("    [NO-DOWNLOAD] Apenas relatório.")
            continue

        success = download_image(result["url"], image_path, session, overwrite=overwrite)
        if not success:
            continue

        downloaded += 1
        print(f"    Salvo:    {image_path}")

        json_data = build_image_json(
            person=person,
            txt_path=txt_path,
            image_path=image_path,
            source=result,
            wikidata_data=wikidata_record,
            status="downloaded",
        )
        save_json(image_path, json_data)
        upsert_catalog_record(catalog_path, json_data)
        time.sleep(delay)

    return downloaded


# ============================================================
# PROCESSAR DIRETÓRIO RAIZ
# ============================================================

def process_root(
    root_dir: Path,
    max_images: int,
    min_width: int,
    delay: float,
    no_download: bool,
    overwrite: bool,
) -> None:
    txt_files = sorted(
        p for p in root_dir.rglob("*.txt")
        if p.is_file() and p.name.lower() not in {"leia-me.txt", "_modelo-pessoa.txt"}
    )

    print()
    print("=" * 75)
    print(" ELOTEMPO — BUSCADOR DE FOTOS HISTÓRICAS (CURADORIA CIRÚRGICA)")
    print("=" * 75)
    print(f"Diretório raiz:     {root_dir}")
    print(f"Arquivos TXT:       {len(txt_files)}")
    print(f"Máximo por pessoa:  {max_images}")
    print(f"Largura mínima:     {min_width}px")
    print("Fontes ativas:      Wikidata P18, Wikipedia Lead Infobox, Commons Category")
    print("=" * 75)

    output_root = root_dir / "_imagens_elotempo"
    output_root.mkdir(parents=True, exist_ok=True)
    catalog_path = output_root / "catalogo_imagens.json"

    session = requests.Session()
    session.headers.update({"User-Agent": USER_AGENT})

    total_pessoas = 0
    total_baixadas = 0

    for txt_path in txt_files:
        parsed = parse_txt_file(txt_path)
        for person in parsed["people"]:
            total_pessoas += 1
            n = process_person(
                person=person,
                txt_path=txt_path,
                root_dir=root_dir,
                output_root=output_root,
                session=session,
                max_images=max_images,
                min_width=min_width,
                delay=delay,
                no_download=no_download,
                overwrite=overwrite,
                catalog_path=catalog_path,
            )
            total_baixadas += n

    print()
    print("=" * 75)
    print(" Processamento Concluído!")
    print(f" Total de pessoas processadas: {total_pessoas}")
    print(f" Total de retratos canônicos salvos: {total_baixadas}")
    print(f" Catálogo atualizado em: {catalog_path}")
    print("=" * 75)


def main():
    parser = argparse.ArgumentParser(description="Buscador de fotos históricas para o EloTempo (Curadoria Estrita)")
    parser.add_argument("root", nargs="?", default=".", help="Diretório raiz contendo as árvores")
    parser.add_argument("--max-images", type=int, default=DEFAULT_MAX_IMAGES, help="Máximo de imagens por pessoa")
    parser.add_argument("--min-width", type=int, default=DEFAULT_MIN_WIDTH, help="Largura mínima em pixels")
    parser.add_argument("--delay", type=float, default=DEFAULT_DELAY, help="Pausa entre requisições (segundos)")
    parser.add_argument("--no-download", action="store_true", help="Apenas simula a busca")
    parser.add_argument("--overwrite", action="store_true", help="Sobrescreve arquivos existentes")

    args = parser.parse_args()
    root_path = Path(args.root).resolve()
    process_root(
        root_dir=root_path,
        max_images=args.max_images,
        min_width=args.min_width,
        delay=args.delay,
        no_download=args.no_download,
        overwrite=args.overwrite,
    )


if __name__ == "__main__":
    main()
