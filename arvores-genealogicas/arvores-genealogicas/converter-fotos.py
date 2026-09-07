#!/usr/bin/env python3
"""
Converte imagens de fotos-originais/ para WEBP otimizado em fotos/.
- Redimensiona para no máximo MAX_LADO px no maior lado (mantém proporção).
- Salva em webp com QUALIDADE definida.
Uso:  python3 converter-fotos.py
Requer: Pillow  (pip install pillow)
"""
from pathlib import Path
from PIL import Image

ORIG = Path("fotos-originais")
DEST = Path("fotos")
MAX_LADO = 512      # px no maior lado (retratos ficam nítidos e leves)
QUALIDADE = 80      # 0-100

EXTS = {".jpg", ".jpeg", ".png", ".bmp", ".tif", ".tiff", ".webp"}

def main():
    DEST.mkdir(exist_ok=True)
    encontrados = 0
    for img_path in sorted(ORIG.glob("*")):
        if img_path.suffix.lower() not in EXTS:
            continue
        encontrados += 1
        im = Image.open(img_path)
        if im.mode not in ("RGB", "RGBA"):
            im = im.convert("RGB")
        im.thumbnail((MAX_LADO, MAX_LADO))  # preserva proporção
        out = DEST / (img_path.stem + ".webp")
        im.save(out, "WEBP", quality=QUALIDADE, method=6)
        kb = out.stat().st_size / 1024
        print(f"{img_path.name}  ->  {out.name}  ({kb:.0f} KB, {im.width}x{im.height})")
    if encontrados == 0:
        print("Nada em fotos-originais/. Coloque as imagens lá e rode de novo.")

if __name__ == "__main__":
    main()
