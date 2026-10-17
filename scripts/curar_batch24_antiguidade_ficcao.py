# -*- coding: utf-8 -*-
import os
import sys
import json
import sqlite3
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

root_dir = Path(r"e:\Trabalhos\Arvore Genealogica")
imagens_base = root_dir / "arvores-genealogicas" / "arvores-genealogicas" / "_imagens_elotempo"

METAS_BATCH24 = [
    {
        "json_path": imagens_base / "antigas-e-grandes" / "kong-confucio" / "Confúcio" / "01_Confúcio.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Wu Daozi (atribuído, séc. VIII) / Gravura imperial clássica",
                "role": "pintor da corte Tang",
                "date_created": "c. 720 (Cópia da Dinastia Ming)",
                "title": "Confúcio ensinando (Kong Fuzi)",
                "museum": "Templo de Confúcio, Qufu / Museu Nacional do Palácio, Taipei",
                "formatted_description": "Retrato clássico tradicional de Confúcio (551 a.C.–479 a.C.), filósofo, pedagogo e patrono da sabedoria confucionista chinesa, em postura de mestre reverente com mãos unidas."
            },
            "rights": {
                "license": "Public domain",
                "author": "Wu Daozi (680–759)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/9/90/Confucius_Tang_Dynasty.jpg",
                "source_provider": "National Palace Museum / Wikimedia Commons",
                "commons_file": "File:Confucius Tang Dynasty.jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "biblicas" / "patriarcas-israel" / "Isaac" / "01_Isaac.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Caravaggio (Michelangelo Merisi da Caravaggio)",
                "role": "pintor barroco",
                "date_created": "1603",
                "title": "O Sacrifício de Isaac",
                "museum": "Galleria degli Uffizi, Florença",
                "formatted_description": "Pintura a óleo sobre tela retratando o patriarca bíblico Isaac e Abraão por Caravaggio (1603). Acervo: Galleria degli Uffizi, Florença."
            },
            "rights": {
                "license": "Public domain",
                "author": "Caravaggio (1571–1610)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/c/c5/Sacrificio_di_Isacco_%28Caravaggio_Uffizi%29.jpg",
                "source_provider": "Galleria degli Uffizi / Wikimedia Commons",
                "commons_file": "File:Sacrificio di Isacco (Caravaggio Uffizi).jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "ficcionais" / "lannister" / "Tywin_Lannister" / "01_Tywin_Lannister.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "HBO / George R.R. Martin Iconography (Charles Dance como Tywin Lannister)",
                "role": "fotografia de produção e caracterização",
                "date_created": "2011",
                "title": "Lord Tywin Lannister, Protetor do Oeste",
                "museum": "Coleção Visual Oficial Game of Thrones / A Song of Ice and Fire",
                "formatted_description": "Retrato oficial de caracterização de Lord Tywin Lannister, patriarca da Casa Lannister e Mão do Rei, interpretado pelo ator Charles Dance."
            },
            "rights": {
                "license": "Fair use cultural / Produção cenográfica",
                "author": "HBO Television"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/en/5/52/Tywin_Lannister-Charles_Dance.jpg",
                "source_provider": "HBO / Wikimedia",
                "commons_file": "File:Tywin Lannister-Charles Dance.jpg"
            }
        }
    }
]

def main():
    print("="*75)
    print("BATCH 24 - PADRONIZAÇÃO SCHEMA v4.0 DE ANTIGUIDADE, BÍBLIA E FICÇÃO")
    print("="*75)
    
    atualizados = 0
    for item in METAS_BATCH24:
        jp = item["json_path"]
        if jp.exists() or jp.parent.exists():
            jp.parent.mkdir(parents=True, exist_ok=True)
            jp.write_text(json.dumps(item["schema_v4"], ensure_ascii=False, indent=2), encoding="utf-8")
            print(f"  [OK] Gravado Schema v4.0 em: {jp.name}")
            atualizados += 1
        else:
            print(f"  [AVISO] Pasta não encontrada: {jp}")
            
    print(f"\nTotal de arquivos padronizados no Batch 24: {atualizados}/{len(METAS_BATCH24)}")

if __name__ == "__main__":
    main()
