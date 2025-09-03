#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACK_DIR = os.path.join(ROOT, "packs", "xray-vision")
BLOCKS_DIR = os.path.join(PACK_DIR, "textures", "blocks")

# Ores with colors for easy identification
ORES = {
    "coal_ore": (30, 30, 30),
    "deepslate_coal_ore": (30, 30, 30),

    "iron_ore": (216, 131, 79),
    "deepslate_iron_ore": (216, 131, 79),

    "copper_ore": (184, 115, 51),
    "deepslate_copper_ore": (184, 115, 51),

    "gold_ore": (255, 215, 0),
    "deepslate_gold_ore": (255, 215, 0),

    "redstone_ore": (230, 20, 20),
    "lit_redstone_ore": (255, 60, 60),
    "deepslate_redstone_ore": (230, 20, 20),

    "lapis_ore": (35, 97, 197),
    "deepslate_lapis_ore": (35, 97, 197),

    "emerald_ore": (30, 200, 120),
    "deepslate_emerald_ore": (30, 200, 120),

    "diamond_ore": (30, 220, 220),
    "deepslate_diamond_ore": (30, 220, 220),

    "nether_gold_ore": (255, 215, 0),
    "quartz_ore": (240, 240, 240),

    # Ancient debris has distinct top/side textures; color both
    "ancient_debris_side": (120, 60, 30),
    "ancient_debris_top": (120, 60, 30),
}

def ensure_dirs():
    os.makedirs(BLOCKS_DIR, exist_ok=True)

def make_transparent_block(name, size=16):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    path = os.path.join(BLOCKS_DIR, f"{name}.png")
    img.save(path)
    print(f"Wrote transparent: {path}")

def make_colored_ore(name, rgb, size=16):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Draw a bright filled square with a contrasting border
    fill = (rgb[0], rgb[1], rgb[2], 255)
    border = (255, 255, 255, 255) if sum(rgb) < 380 else (0, 0, 0, 255)

    margin = 1
    draw.rectangle([margin, margin, size - margin - 1, size - margin - 1], fill=fill, outline=border, width=1)

    # Add a diagonal stripe for extra visibility
    for i in range(0, size, 3):
        draw.line([(i, 0), (0, i)], fill=border, width=1)
        draw.line([(size - 1, i), (i, size - 1)], fill=border, width=1)

    path = os.path.join(BLOCKS_DIR, f"{name}.png")
    img.save(path)
    print(f"Wrote ore: {path}")

def make_pack_icon(size=256):
    img = Image.new("RGBA", (size, size), (16, 16, 16, 255))
    d = ImageDraw.Draw(img)

    # Simple “XRAY” text-like blocks
    colors = [
        (30, 220, 220, 255),   # diamond
        (255, 215, 0, 255),    # gold
        (35, 97, 197, 255),    # lapis
        (30, 200, 120, 255),   # emerald
        (230, 20, 20, 255),    # redstone
    ]
    # Draw colored squares
    s = size // 6
    margin = s // 2
    x = margin
    for c in colors:
        d.rectangle([x, margin, x + s, margin + s], fill=c, outline=(255, 255, 255, 255), width=4)
        x += s + margin // 2

    # Large “X” overlay
    d.line([(0, 0), (size, size)], fill=(255, 255, 255, 80), width=24)
    d.line([(size, 0), (0, size)], fill=(255, 255, 255, 80), width=24)

    path = os.path.join(PACK_DIR, "pack_icon.png")
    img.save(path)
    print(f"Wrote icon: {path}")

def main():
    ensure_dirs()
    for name in OPAQUE_TO_TRANSPARENT:
        make_transparent_block(name)

    for name, rgb in ORES.items():
        make_colored_ore(name, rgb)

    make_pack_icon()

if __name__ == "__main__":
    main()