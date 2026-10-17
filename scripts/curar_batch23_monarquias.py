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

appdata = os.environ.get("APPDATA")
app_dir = Path(appdata) / "com.elotempo.app"
db_path = app_dir / "acervo.sqlite"

METAS_BATCH23 = [
    {
        "json_path": imagens_base / "realeza-europeia" / "bourbon" / "Afonso_XIII" / "01_Afonso_XIII.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Antonio Cánovas del Castillo y Vallejo (Kaulak)",
                "role": "fotógrafo",
                "date_created": "1916",
                "title": "Retrato Oficial de Afonso XIII de Espanha",
                "museum": "Museu Nacional d'Art de Catalunya, Barcelona",
                "formatted_description": "Retrato fotográfico oficial do Rei Afonso XIII de Espanha (1886–1941) em grande uniforme militar de gala por Kaulak (1916). Acervo: Museu Nacional d'Art de Catalunya."
            },
            "rights": {
                "license": "Public domain",
                "author": "Kaulak (1862–1933)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/f/f5/Rey_Alfonso_XIII_de_Espa%C3%B1a%2C_by_Kaulak.jpg",
                "source_provider": "Museu Nacional d'Art de Catalunya / Wikimedia Commons",
                "commons_file": "File:Rey Alfonso XIII de España, by Kaulak.jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Akihito_(Imperador_Emérito)" / "01_Akihito_(Imperador_Emérito).json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Agência da Casa Imperial do Japão (Kunaichō)",
                "role": "fotografia oficial",
                "date_created": "c. 1990",
                "title": "Sua Majestade Imperial Akihito, Imperador do Japão",
                "museum": "Agência da Casa Imperial do Japão (Kunaichō), Tóquio",
                "formatted_description": "Fotografia oficial de Sua Majestade o Imperador Akihito (Heisei), 125º Imperador do Japão, biólogo marinho e promotor da reconciliação pacífica na Ásia."
            },
            "rights": {
                "license": "Public domain / Fair use oficial governamental",
                "author": "Kunaichō (Imperial Household Agency)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/6/69/Emperor_Akihito_%281989%29.jpg",
                "source_provider": "Imperial Household Agency / Wikimedia Commons",
                "commons_file": "File:Emperor Akihito (1989).jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperador_Meiji" / "01_Imperador_Meiji.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Edoardo Chiossone (gravador) / Uchida Kuichi (fotógrafo)",
                "role": "gravador e desenhista",
                "date_created": "1888",
                "title": "Retrato Oficial do Imperador Meiji (Mutsuhito)",
                "museum": "Museu Imperial de Quioto / Agência da Casa Imperial, Tóquio",
                "formatted_description": "Célebre retrato oficial em conté e gravura de Sua Majestade o Imperador Meiji (1852–1912), artífice da modernização do Japão, baseado na fotografia de Uchida Kuichi por Edoardo Chiossone (1888)."
            },
            "rights": {
                "license": "Public domain",
                "author": "Edoardo Chiossone (1833–1898)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/7/7b/Meiji_tenno1.jpg",
                "source_provider": "Imperial Household Agency / Wikimedia Commons",
                "commons_file": "File:Meiji tenno1.jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperador_Shōwa_(Hirohito)" / "01_Imperador_Shōwa_(Hirohito).json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Agência da Casa Imperial do Japão (Kunaichō)",
                "role": "fotografia oficial de Estado",
                "date_created": "c. 1935",
                "title": "Imperador Shōwa (Hirohito) em Grande Uniforme de Gala",
                "museum": "Agência da Casa Imperial do Japão, Tóquio",
                "formatted_description": "Fotografia oficial de Estado de Sua Majestade o Imperador Shōwa (Hirohito, 1901–1989) condecorado com o Colar da Suprema Ordem do Crisântemo."
            },
            "rights": {
                "license": "Public domain",
                "author": "Kunaichō (Imperial Household Agency)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/e/e9/Hirohito_in_dress_uniform.jpg",
                "source_provider": "Imperial Household Agency / Wikimedia Commons",
                "commons_file": "File:Hirohito in dress uniform.jpg"
            }
        }
    },
    {
        "json_path": imagens_base / "antigas-e-grandes" / "casa-imperial-japao" / "Imperador_Jimmu" / "01_Imperador_Jimmu.json",
        "schema_v4": {
            "schema_version": "4.0",
            "artwork": {
                "artist": "Tsukioka Yoshitoshi (1839–1892)",
                "role": "gravador ukiyo-e",
                "date_created": "1880",
                "title": "Imperador Jimmu e o Pássaro Dourado (Kinshi)",
                "museum": "Museu Nacional de Tóquio / Coleções Tradicionais Japonesas",
                "formatted_description": "Gravura xilográfica ukiyo-e retratando o lendário Imperador Jimmu, fundador mítico do Império do Japão (660 a.C.), com o arco sagrado e o pássaro dourado divino, por Tsukioka Yoshitoshi (1880)."
            },
            "rights": {
                "license": "Public domain",
                "author": "Tsukioka Yoshitoshi (1839–1892)"
            },
            "provenance": {
                "original_url": "https://upload.wikimedia.org/wikipedia/commons/8/87/Emperor_Jimmu.jpg",
                "source_provider": "Tokyo National Museum / Wikimedia Commons",
                "commons_file": "File:Emperor Jimmu.jpg"
            }
        }
    }
]

def main():
    print("="*75)
    print("BATCH 23 - PADRONIZAÇÃO ARQUIVÍSTICA SCHEMA v4.0 DE MONARQUIAS")
    print("="*75)
    
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    
    atualizados = 0
    for item in METAS_BATCH23:
        jp = item["json_path"]
        if jp.exists() or jp.parent.exists():
            jp.parent.mkdir(parents=True, exist_ok=True)
            jp.write_text(json.dumps(item["schema_v4"], ensure_ascii=False, indent=2), encoding="utf-8")
            print(f"  [OK] Gravado Schema v4.0 em: {jp.relative_to(imagens_base)}")
            atualizados += 1
        else:
            print(f"  [AVISO] Pasta não encontrada: {jp}")
            
    conn.close()
    print(f"\nTotal de arquivos padronizados no Batch 23: {atualizados}/{len(METAS_BATCH23)}")

if __name__ == "__main__":
    main()
