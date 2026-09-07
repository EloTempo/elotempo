"""
ELOTEMPO — IMPORTADOR E BUSCADOR DE IMAGENS HISTÓRICAS (CURADORIA ESTRITA)
==========================================================================

Versão 3.0 aprimorada com precisão cirúrgica sem falsos positivos:
1. Wikidata Claims (P18 - Retrato Oficial Canônico curado por historiadores)
2. Wikidata Claims (P1543 - Monografia / Retrato histórico alternativo)
3. Wikipedia Lead Image (Infobox oficial a partir de artigo verificado da entidade)
4. Wikimedia Commons (P373 - Categoria Oficial dedicada à pessoa histórica)

REGRAS DE OURO:
- NUNCA pesquisa em fontes abertas não-curadas (Flickr, Openverse, etc.),
  eliminando completamente fotos de placas de rua, furacões, hotéis, shows e esportes.
- NUNCA aceita entidades Wikidata de tipos não-biográficos (ruas, cidades, anos,
  escolas, monumentos, furacões, desambiguações).
- Higienização estrita de aliases: nunca pesquisa anos em parênteses "(1872)" nem
  termos de parentesco "(tio)", "(filho)".
- Penalização severa (-60 pts) para confusão geracional (ex: Júnior vs Pai).
- Filtro rigoroso de palavras negativas (túmulos, brasões, bandeiras, mapas, moedas).

Instalação:
    pip install requests

Execução:
    python scripts/elotempo_imagens.py

Ou:
    python scripts/elotempo_imagens.py "arvores-genealogicas/arvores-genealogicas"
"""

import sys
from pathlib import Path

# Carrega e executa a implementação canônica em arvores-genealogicas
target = Path(__file__).resolve().parent.parent / "arvores-genealogicas" / "arvores-genealogicas" / "elotempo_imagens.py"
if target.exists():
    with open(target, encoding="utf-8") as f:
        code = compile(f.read(), str(target), "exec")
        exec(code, globals(), globals())
else:
    print(f"Arquivo principal não encontrado em {target}")
    sys.exit(1)
