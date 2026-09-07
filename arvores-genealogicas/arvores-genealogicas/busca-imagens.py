"""
============================================================
ELOTEMPO - BUSCADOR DE IMAGENS HISTÓRICAS
============================================================

Fluxo:

PASTA RAIZ
    ↓
Localiza arquivos TXT
    ↓
Extrai nomes das pessoas
    ↓
Pesquisa no Wikimedia Commons
    ↓
Seleciona imagens com melhor licença
    ↓
Baixa a imagem
    ↓
Cria um JSON ao lado da imagem
    ↓
Mantém também um catálogo geral JSON/CSV

Estrutura de saída:

_imagens_elotempo/
    brasileiras/
        familia-imperial/
            Dom_Pedro_II/
                01_Dom_Pedro_II.jpg
                01_Dom_Pedro_II.json
                02_Dom_Pedro_II.jpg
                02_Dom_Pedro_II.json

Dependências:

    pip install requests

Python:
    3.10+
"""

from __future__ import annotations

import csv
import json
import re
import time
import unicodedata
from datetime import datetime, timezone
from pathlib import Path
from tkinter import Tk, filedialog
from typing import Optional

import requests


# ============================================================
# CONFIGURAÇÕES
# ============================================================

MAX_IMAGES_PER_PERSON = 5

MIN_IMAGE_WIDTH = 300

REQUEST_TIMEOUT = 30

DELAY_BETWEEN_REQUESTS = 1.0

COMMONS_API = (
    "https://commons.wikimedia.org/w/api.php"
)

USER_AGENT = (
    "Elotempo/1.0 "
    "(historical-family-research-tool)"
)


# ============================================================
# UTILITÁRIOS
# ============================================================

def normalize_text(text: str) -> str:
    """
    Remove acentos e normaliza espaços.
    """

    text = unicodedata.normalize(
        "NFKD",
        text
    )

    text = "".join(
        char
        for char in text
        if not unicodedata.combining(char)
    )

    text = text.replace("\t", " ")

    text = re.sub(
        r"\s+",
        " ",
        text
    )

    return text.strip()


def safe_filename(text: str) -> str:
    """
    Converte texto em nome de arquivo válido.
    """

    text = re.sub(
        r'[<>:"/\\|?*]',
        "_",
        text
    )

    text = re.sub(
        r"\s+",
        "_",
        text
    )

    return text.strip(" ._")


def utc_now() -> str:
    """
    Retorna timestamp UTC ISO 8601.
    """

    return (
        datetime.now(timezone.utc)
        .isoformat()
    )


# ============================================================
# SELEÇÃO DA PASTA
# ============================================================

def select_root_directory() -> Optional[Path]:
    """
    Abre o seletor de diretório do Windows.
    """

    root = Tk()

    root.withdraw()

    root.attributes(
        "-topmost",
        True
    )

    selected = filedialog.askdirectory(
        title=(
            "Selecione a pasta raiz "
            "das famílias"
        )
    )

    root.destroy()

    if not selected:
        return None

    return Path(selected)


# ============================================================
# TXT
# ============================================================

def find_txt_files(
    root_dir: Path
) -> list[Path]:

    """
    Localiza todos os TXT recursivamente.
    """

    return sorted(
        path
        for path in root_dir.rglob("*.txt")
        if path.is_file()
    )


def read_text_file(
    path: Path
) -> str:

    """
    Tenta várias codificações.
    """

    encodings = [
        "utf-8-sig",
        "utf-8",
        "cp1252",
        "latin-1",
    ]

    for encoding in encodings:

        try:

            return path.read_text(
                encoding=encoding
            )

        except UnicodeDecodeError:

            continue

    return path.read_text(
        encoding="utf-8",
        errors="replace"
    )


# ============================================================
# EXTRAÇÃO DOS NOMES
# ============================================================

def extract_names_from_txt(
    text: str
) -> list[str]:

    """
    Tenta identificar nomes de pessoas
    dentro do arquivo TXT.
    """

    names = []

    ignored_prefixes = {
        "data",
        "nascimento",
        "falecimento",
        "profissão",
        "profissao",
        "observação",
        "observacao",
        "observações",
        "observacoes",
        "fonte",
        "nota",
        "pai",
        "mãe",
        "mae",
        "filhos",
        "filhas",
        "irmãos",
        "irmaos",
        "irmãs",
        "irmas",
        "esposa",
        "esposo",
        "marido",
        "mulher",
    }

    for raw_line in text.splitlines():

        line = raw_line.strip()

        if not line:
            continue

        # Remove bullets e numeração
        line = re.sub(
            r"^[\-\*\•\→\►\▪\d\.\)\s]+",
            "",
            line
        ).strip()

        if not line:
            continue

        # Exemplos:
        #
        # João da Silva: informações
        # Maria José - informações
        #
        candidate = re.split(
            r"\s+[|:–—-]\s+",
            line,
            maxsplit=1
        )[0].strip()

        if not candidate:
            continue

        normalized = normalize_text(
            candidate
        )

        words = normalized.split()

        # Nome normalmente terá pelo menos
        # duas palavras.
        if len(words) < 2:
            continue

        if len(words) > 10:
            continue

        first_word = words[0].lower()

        if first_word in ignored_prefixes:
            continue

        # Evita frases descritivas
        if re.search(
            r"\b("
            r"nasceu|"
            r"morreu|"
            r"viveu|"
            r"foi|"
            r"era|"
            r"nascido|"
            r"falecido"
            r")\b",
            normalized,
            re.IGNORECASE
        ):
            continue

        # Precisa conter letras.
        if not re.search(
            r"[A-Za-zÀ-ÿ]",
            candidate
        ):
            continue

        if candidate not in names:

            names.append(
                candidate
            )

    return names


def extract_people_from_txt(
    path: Path
) -> list[str]:

    text = read_text_file(path)

    return extract_names_from_txt(
        text
    )


# ============================================================
# WIKIMEDIA COMMONS
# ============================================================

def search_commons(
    person_name: str,
    limit: int = 30
) -> list[dict]:

    """
    Pesquisa arquivos de imagem no Wikimedia Commons.
    """

    params = {

        "action": "query",

        "format": "json",

        "generator": "search",

        "gsrsearch": (
            f'"{person_name}" portrait'
        ),

        "gsrnamespace": 6,

        "gsrlimit": limit,

        "prop": "imageinfo",

        "iiprop": (
            "url|size|mime|extmetadata"
        ),

        "iiurlwidth": 1600,
    }

    response = requests.get(

        COMMONS_API,

        params=params,

        timeout=REQUEST_TIMEOUT,

        headers={
            "User-Agent": USER_AGENT
        }
    )

    response.raise_for_status()

    data = response.json()

    results = []

    pages = (
        data
        .get("query", {})
        .get("pages", {})
    )

    for page in pages.values():

        imageinfo = page.get(
            "imageinfo"
        )

        if not imageinfo:
            continue

        info = imageinfo[0]

        width = info.get(
            "width",
            0
        )

        height = info.get(
            "height",
            0
        )

        if width < MIN_IMAGE_WIDTH:
            continue

        metadata = info.get(
            "extmetadata",
            {}
        )

        def metadata_value(
            key: str
        ) -> str:

            return (
                metadata
                .get(key, {})
                .get("value", "")
            )

        license_name = metadata_value(
            "LicenseShortName"
        )

        artist = metadata_value(
            "Artist"
        )

        date_taken = metadata_value(
            "DateTimeOriginal"
        )

        credit = metadata_value(
            "Credit"
        )

        description = metadata_value(
            "ImageDescription"
        )

        categories = metadata_value(
            "Categories"
        )

        image_url = (
            info.get("thumburl")
            or info.get("url")
        )

        original_url = info.get(
            "url",
            ""
        )

        description_url = info.get(
            "descriptionurl",
            ""
        )

        if not image_url:
            continue

        results.append({

            "title": page.get(
                "title",
                ""
            ),

            "url": image_url,

            "original_url": original_url,

            "descriptionurl":
                description_url,

            "width": width,

            "height": height,

            "mime": info.get(
                "mime",
                ""
            ),

            "license":
                license_name,

            "artist":
                artist,

            "date_taken":
                date_taken,

            "credit":
                credit,

            "description":
                description,

            "categories":
                categories,
        })

    return results


# ============================================================
# LICENÇAS
# ============================================================

def license_score(
    license_name: str
) -> int:

    """
    Pontuação para priorizar licenças.
    """

    license_lower = (
        license_name
        .lower()
        .strip()
    )

    if not license_lower:
        return 0

    if "public domain" in license_lower:
        return 100

    if "cc0" in license_lower:
        return 95

    if "pd-art" in license_lower:
        return 95

    if "pd-old" in license_lower:
        return 90

    if "cc by-sa" in license_lower:
        return 75

    if "cc by" in license_lower:
        return 70

    return 10


def license_requires_review(
    license_name: str
) -> bool:

    """
    Determina se precisamos de revisão manual.

    Uma licença vazia ou pouco clara será marcada
    para revisão.
    """

    score = license_score(
        license_name
    )

    return score < 70


# ============================================================
# SELEÇÃO DAS MELHORES IMAGENS
# ============================================================

def select_best_images(
    results: list[dict],
    max_images: int = MAX_IMAGES_PER_PERSON
) -> list[dict]:

    for item in results:

        license_score_value = (
            license_score(
                item.get(
                    "license",
                    ""
                )
            )
        )

        resolution_score = (
            item.get("width", 0)
            *
            item.get("height", 0)
        )

        item["_score"] = (
            license_score_value
            *
            10_000_000
            +
            resolution_score
        )

    results.sort(
        key=lambda item:
            item["_score"],
        reverse=True
    )

    return results[:max_images]


# ============================================================
# EXTENSÃO
# ============================================================

def extension_from_mime(
    mime: str
) -> str:

    mime = mime.lower()

    if "jpeg" in mime:
        return ".jpg"

    if "jpg" in mime:
        return ".jpg"

    if "png" in mime:
        return ".png"

    if "webp" in mime:
        return ".webp"

    if "gif" in mime:
        return ".gif"

    return ".jpg"


# ============================================================
# DOWNLOAD
# ============================================================

def download_image(
    url: str,
    destination: Path
) -> bool:

    try:

        response = requests.get(

            url,

            timeout=REQUEST_TIMEOUT,

            headers={
                "User-Agent": USER_AGENT
            }
        )

        response.raise_for_status()

        # Confirma que recebemos algum conteúdo.
        if not response.content:
            return False

        destination.write_bytes(
            response.content
        )

        return True

    except Exception as error:

        print(
            f"[ERRO DOWNLOAD] {url}"
        )

        print(
            f"Detalhes: {error}"
        )

        return False


# ============================================================
# JSON INDIVIDUAL DA IMAGEM
# ============================================================

def create_image_json(
    person_name: str,
    txt_file: Path,
    image_data: dict,
    image_path: Path
) -> dict:

    """
    Cria a estrutura definitiva do JSON
    associado à imagem.
    """

    license_name = image_data.get(
        "license",
        ""
    )

    json_data = {

        # ----------------------------------------------------
        # IDENTIDADE
        # ----------------------------------------------------

        "person_name": person_name,

        "source_family_file": str(
            txt_file
        ),

        # ----------------------------------------------------
        # ARQUIVO LOCAL
        # ----------------------------------------------------

        "image_file": image_path.name,

        "image_path": str(
            image_path
        ),

        # ----------------------------------------------------
        # ORIGEM
        # ----------------------------------------------------

        "source": {

            "provider":
                "Wikimedia Commons",

            "page_url":
                image_data.get(
                    "descriptionurl",
                    ""
                ),

            "original_url":
                image_data.get(
                    "original_url",
                    ""
                ),
        },

        # ----------------------------------------------------
        # LICENÇA
        # ----------------------------------------------------

        "license": {

            "name":
                license_name,

            "artist":
                image_data.get(
                    "artist",
                    ""
                ),

            "credit":
                image_data.get(
                    "credit",
                    ""
                ),

            "review_required":
                license_requires_review(
                    license_name
                ),
        },

        # ----------------------------------------------------
        # DADOS HISTÓRICOS
        # ----------------------------------------------------

        "historical": {

            "date_taken":
                image_data.get(
                    "date_taken",
                    ""
                ),

            "description":
                image_data.get(
                    "description",
                    ""
                ),

            "categories":
                image_data.get(
                    "categories",
                    ""
                ),
        },

        # ----------------------------------------------------
        # IMAGEM
        # ----------------------------------------------------

        "image": {

            "width":
                image_data.get(
                    "width",
                    0
                ),

            "height":
                image_data.get(
                    "height",
                    0
                ),

            "mime":
                image_data.get(
                    "mime",
                    ""
                ),
        },

        # ----------------------------------------------------
        # CONTROLE DO ELOTEMPO
        # ----------------------------------------------------

        "elotempo": {

            "status":
                "downloaded",

            "review_required":
                license_requires_review(
                    license_name
                ),

            "downloaded_at":
                utc_now(),

            "source_type":
                "historical-public-image",

            "provider":
                "wikimedia-commons",
        }
    }

    return json_data


def save_image_json(
    image_path: Path,
    json_data: dict
) -> Path:

    """
    Cria o JSON com o mesmo nome da imagem.

    Exemplo:

        01_Dom_Pedro_II.jpg
        01_Dom_Pedro_II.json
    """

    json_path = image_path.with_suffix(
        ".json"
    )

    json_path.write_text(

        json.dumps(
            json_data,
            ensure_ascii=False,
            indent=2
        ),

        encoding="utf-8"
    )

    return json_path


# ============================================================
# CATÁLOGO GERAL
# ============================================================

def append_to_global_catalog(
    metadata_file: Path,
    json_data: dict
):

    """
    Mantém um catálogo geral além dos
    JSONs individuais.
    """

    records = []

    if metadata_file.exists():

        try:

            records = json.loads(
                metadata_file.read_text(
                    encoding="utf-8"
                )
            )

        except Exception:

            records = []

    records.append(
        json_data
    )

    metadata_file.write_text(

        json.dumps(
            records,
            ensure_ascii=False,
            indent=2
        ),

        encoding="utf-8"
    )


# ============================================================
# PROCESSAR UMA PESSOA
# ============================================================

def process_person(
    person_name: str,
    txt_file: Path,
    family_output_dir: Path,
    metadata_file: Path
):

    print()
    print("=" * 70)
    print(
        f"Pessoa: {person_name}"
    )
    print(
        f"Família: {txt_file.name}"
    )
    print("=" * 70)

    # --------------------------------------------------------
    # Pesquisa
    # --------------------------------------------------------

    try:

        search_results = search_commons(
            person_name
        )

    except Exception as error:

        print(
            f"[ERRO API] {error}"
        )

        return

    if not search_results:

        print(
            "Nenhuma imagem encontrada."
        )

        return

    # --------------------------------------------------------
    # Seleciona melhores resultados
    # --------------------------------------------------------

    best_images = select_best_images(
        search_results
    )

    # --------------------------------------------------------
    # Pasta da pessoa
    # --------------------------------------------------------

    person_folder = (
        family_output_dir
        /
        safe_filename(person_name)
    )

    person_folder.mkdir(
        parents=True,
        exist_ok=True
    )

    # --------------------------------------------------------
    # Downloads
    # --------------------------------------------------------

    for index, image in enumerate(
        best_images,
        start=1
    ):

        extension = (
            extension_from_mime(
                image.get(
                    "mime",
                    ""
                )
            )
        )

        filename = (
            f"{index:02d}_"
            f"{safe_filename(person_name)}"
            f"{extension}"
        )

        image_path = (
            person_folder
            /
            filename
        )

        print()
        print(
            f"Imagem {index}"
        )

        print(
            f"Arquivo: {filename}"
        )

        print(
            "Licença:",
            image.get(
                "license"
            )
            or
            "NÃO IDENTIFICADA"
        )

        # ----------------------------------------------------
        # Download
        # ----------------------------------------------------

        if image_path.exists():

            print(
                "Imagem já existe. "
                "Pulando download."
            )

        else:

            success = download_image(
                image["url"],
                image_path
            )

            if not success:
                continue

            print(
                f"Imagem salva: "
                f"{image_path}"
            )

        # ----------------------------------------------------
        # JSON
        # ----------------------------------------------------

        json_data = create_image_json(

            person_name=person_name,

            txt_file=txt_file,

            image_data=image,

            image_path=image_path
        )

        json_path = save_image_json(

            image_path,

            json_data
        )

        print(
            f"JSON salvo: {json_path}"
        )

        if json_data["elotempo"][
            "review_required"
        ]:

            print(
                "⚠ ATENÇÃO: "
                "licença requer revisão manual."
            )

        else:

            print(
                "✓ Licença considerada "
                "adequada para revisão padrão."
            )

        # ----------------------------------------------------
        # Catálogo geral
        # ----------------------------------------------------

        append_to_global_catalog(

            metadata_file,

            json_data
        )

        time.sleep(
            DELAY_BETWEEN_REQUESTS
        )


# ============================================================
# CONVERTER CATÁLOGO PARA CSV
# ============================================================

def create_global_csv(
    metadata_file: Path,
    csv_file: Path
):

    if not metadata_file.exists():
        return

    try:

        records = json.loads(
            metadata_file.read_text(
                encoding="utf-8"
            )
        )

    except Exception:

        return

    if not records:
        return

    rows = []

    for record in records:

        rows.append({

            "person_name":
                record.get(
                    "person_name",
                    ""
                ),

            "image_file":
                record.get(
                    "image_file",
                    ""
                ),

            "image_path":
                record.get(
                    "image_path",
                    ""
                ),

            "provider":
                record.get(
                    "source",
                    {}
                ).get(
                    "provider",
                    ""
                ),

            "page_url":
                record.get(
                    "source",
                    {}
                ).get(
                    "page_url",
                    ""
                ),

            "original_url":
                record.get(
                    "source",
                    {}
                ).get(
                    "original_url",
                    ""
                ),

            "license":
                record.get(
                    "license",
                    {}
                ).get(
                    "name",
                    ""
                ),

            "artist":
                record.get(
                    "license",
                    {}
                ).get(
                    "artist",
                    ""
                ),

            "review_required":
                record.get(
                    "license",
                    {}
                ).get(
                    "review_required",
                    False
                ),

            "width":
                record.get(
                    "image",
                    {}
                ).get(
                    "width",
                    ""
                ),

            "height":
                record.get(
                    "image",
                    {}
                ).get(
                    "height",
                    ""
                ),

            "mime":
                record.get(
                    "image",
                    {}
                ).get(
                    "mime",
                    ""
                ),

            "downloaded_at":
                record.get(
                    "elotempo",
                    {}
                ).get(
                    "downloaded_at",
                    ""
                ),
        })

    fieldnames = list(
        rows[0].keys()
    )

    with csv_file.open(
        "w",
        encoding="utf-8-sig",
        newline=""
    ) as file:

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()

        writer.writerows(
            rows
        )


# ============================================================
# PROCESSAR TODAS AS FAMÍLIAS
# ============================================================

def process_all(
    root_dir: Path
):

    print()
    print("=" * 70)
    print(
        "ELOTEMPO - BUSCADOR "
        "DE IMAGENS HISTÓRICAS"
    )
    print("=" * 70)

    print()
    print(
        f"Pasta raiz:\n{root_dir}"
    )

    # --------------------------------------------------------
    # TXT
    # --------------------------------------------------------

    txt_files = find_txt_files(
        root_dir
    )

    print()
    print(
        f"Arquivos TXT encontrados: "
        f"{len(txt_files)}"
    )

    if not txt_files:

        print(
            "Nenhum TXT encontrado."
        )

        return

    # --------------------------------------------------------
    # Pasta de saída
    # --------------------------------------------------------

    output_root = (
        root_dir
        /
        "_imagens_elotempo"
    )

    output_root.mkdir(
        parents=True,
        exist_ok=True
    )

    # --------------------------------------------------------
    # Catálogo geral
    # --------------------------------------------------------

    metadata_file = (
        output_root
        /
        "catalogo_imagens.json"
    )

    csv_file = (
        output_root
        /
        "catalogo_imagens.csv"
    )

    # --------------------------------------------------------
    # Processamento
    # --------------------------------------------------------

    for txt_file in txt_files:

        print()
        print("#" * 70)

        print(
            f"ARQUIVO: {txt_file.name}"
        )

        print(
            f"LOCAL: {txt_file}"
        )

        print("#" * 70)

        names = extract_people_from_txt(
            txt_file
        )

        print()
        print(
            f"Pessoas identificadas: "
            f"{len(names)}"
        )

        if not names:

            continue

        # ----------------------------------------------------
        # Mantém a estrutura original
        # ----------------------------------------------------

        relative_folder = (
            txt_file.parent.relative_to(
                root_dir
            )
        )

        family_name = (
            txt_file.stem
        )

        family_output_dir = (
            output_root
            /
            relative_folder
            /
            family_name
        )

        family_output_dir.mkdir(
            parents=True,
            exist_ok=True
        )

        # ----------------------------------------------------
        # Pessoas
        # ----------------------------------------------------

        for person_name in names:

            process_person(

                person_name,

                txt_file,

                family_output_dir,

                metadata_file
            )

    # --------------------------------------------------------
    # CSV
    # --------------------------------------------------------

    create_global_csv(

        metadata_file,

        csv_file
    )

    # --------------------------------------------------------
    # Final
    # --------------------------------------------------------

    print()
    print("=" * 70)
    print(
        "PROCESSAMENTO CONCLUÍDO"
    )
    print("=" * 70)

    print()
    print(
        f"Imagens e JSONs:\n"
        f"{output_root}"
    )

    print()
    print(
        f"Catálogo geral JSON:\n"
        f"{metadata_file}"
    )

    print()
    print(
        f"Catálogo geral CSV:\n"
        f"{csv_file}"
    )


# ============================================================
# MAIN
# ============================================================

def main():

    root_dir = (
        select_root_directory()
    )

    if root_dir is None:

        print(
            "Nenhuma pasta selecionada."
        )

        return

    process_all(
        root_dir
    )


if __name__ == "__main__":

    main()