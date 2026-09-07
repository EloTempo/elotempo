#!/usr/bin/env python3
"""
Gera todos os ícones do aplicativo Elotempo em src-tauri/icons/
a partir da geometria oficial e paleta refinada da Peça A.

Desenha em 4x (2048x2048) e faz downsampling com filtro Lanczos para
antialiasing com qualidade de estúdio em todas as resoluções.
"""

from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
ICONS_DIR = ROOT / "src-tauri" / "icons"

def desenhar_icone(tamanho_alvo, escala=4):
    canvas = 512 * escala
    img = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Cores oficiais da nova identidade Elotempo:
    # Fundo: Azul Masculino / Primário (#2563EB)
    # Símbolo e nós: Branco Cristalino Puro (#FFFFFF)
    cor_fundo = (37, 99, 235, 255)       # #2563EB (Azul da representação masculina)
    cor_simbolo = (255, 255, 255, 255)   # #FFFFFF (Branco cristalino puro)

    # Fundo Squircle arredondado
    raio_borda = 115 * escala
    draw.rounded_rectangle(
        [0, 0, canvas - 1, canvas - 1],
        radius=raio_borda,
        fill=cor_fundo
    )

    # Ajuste óptico: ícones pequenos (< 64px) precisam de traço mais robusto e nós maiores
    eh_pequeno = tamanho_alvo <= 48
    stroke_base = 44 if eh_pequeno else 30
    r_no_base = 42 if eh_pequeno else 33
    fork_spread = 15 if eh_pequeno else 0

    stroke_width = int(stroke_base * escala)
    r_no = int(r_no_base * escala)

    # Coordenadas com proporções generosas
    x_left = 160
    x_mid = 232
    x_right = 356

    y_top = 130
    y_mid = 256
    y_bot = 382

    y_fork_up = 256 - 52 - fork_spread
    y_fork_dn = 256 + 52 + fork_spread

    def pt(x, y):
        return (int(x * escala), int(y * escala))

    def desenhar_linha(p1, p2):
        draw.line([pt(*p1), pt(*p2)], fill=cor_simbolo, width=stroke_width, joint="round")

    def desenhar_no(p):
        cx, cy = pt(*p)
        draw.ellipse([cx - r_no, cy - r_no, cx + r_no, cy + r_no], fill=cor_simbolo)

    # 1. Traços (Linhas) em Branco Puro
    # Tronco vertical
    desenhar_linha((x_left, y_top), (x_left, y_bot))
    # Ramo superior
    desenhar_linha((x_left, y_top), (x_right, y_top))
    # Elo intermediário e bifurcação
    desenhar_linha((x_left, y_mid), (x_mid, y_mid))
    desenhar_linha((x_mid, y_mid), (x_right, y_fork_up))
    desenhar_linha((x_mid, y_mid), (x_right, y_fork_dn))
    # Ramo inferior
    desenhar_linha((x_left, y_bot), (x_right, y_bot))

    # 2. Nós (Círculos cheios) em Branco Puro
    desenhar_no((x_left, y_top))
    desenhar_no((x_right, y_top))

    desenhar_no((x_left, y_mid))
    desenhar_no((x_mid, y_mid))
    desenhar_no((x_right, y_fork_up))
    desenhar_no((x_right, y_fork_dn))

    desenhar_no((x_left, y_bot))
    desenhar_no((x_right, y_bot))

    return img.resize((tamanho_alvo, tamanho_alvo), Image.Resampling.LANCZOS)

def main():
    ICONS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Gerando icones em: {ICONS_DIR}")

    # Lista de arquivos PNG necessários
    png_targets = {
        "icon.png": 512,
        "128x128@2x.png": 256,
        "128x128.png": 128,
        "64x64.png": 64,
        "32x32.png": 32,
        # Formatos Store Windows
        "StoreLogo.png": 50,
        "Square30x30Logo.png": 30,
        "Square44x44Logo.png": 44,
        "Square71x71Logo.png": 71,
        "Square89x89Logo.png": 89,
        "Square107x107Logo.png": 107,
        "Square142x142Logo.png": 142,
        "Square150x150Logo.png": 150,
        "Square284x284Logo.png": 284,
        "Square310x310Logo.png": 310,
    }

    for name, size in png_targets.items():
        img = desenhar_icone(size)
        out_path = ICONS_DIR / name
        img.save(out_path, "PNG")
        print(f"  [OK] {name} ({size}x{size})")

    # Gerar icon.ico multi-resolução com camadas calibradas
    ico_frames = [
        desenhar_icone(16),
        desenhar_icone(24),
        desenhar_icone(32),
        desenhar_icone(48),
        desenhar_icone(64),
        desenhar_icone(128),
        desenhar_icone(256),
    ]
    ico_path = ICONS_DIR / "icon.ico"
    ico_frames[-1].save(
        ico_path,
        format="ICO",
        append_images=ico_frames[:-1]
    )
    print("  [OK] icon.ico (16, 24, 32, 48, 64, 128, 256 px calibrados individualmente)")
    print("Todos os icones foram gerados com sucesso!")

if __name__ == "__main__":
    main()
