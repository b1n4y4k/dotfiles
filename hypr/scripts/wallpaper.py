#!/usr/bin/env python3
# wallpaper-select — pygame wallpaper picker for awww
# place at ~/.config/hypr/scripts/wallpaper-select.py
# deps: python-pygame, awww

import os
import sys
import subprocess
import pygame
from pathlib import Path

# ── config ────────────────────────────────────────────────────────────────────
WALL_DIR   = Path(os.environ.get("WALLPAPER_DIR", Path.home() / "Pictures/wallpapers"))
THUMB_DIR  = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "wallpaper-thumbs-py"
WIN_W      = 960
WIN_H      = 540
BG         = (29,  32,  33)
BORDER     = (102, 92,  84)
BORDER_W   = 2
RADIUS     = 6
PAD        = 0
DOUBLE_MS  = 400   # double-click window in ms
TRANSITION = ["--transition-type",    "grow",
              "--transition-duration","1.2",
              "--transition-fps",     "60",
              "--transition-angle",   "30",
              "--transition-pos",     "0.5,0.5"]
EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".gif"}

# ── collect wallpapers ────────────────────────────────────────────────────────
walls = sorted([p for p in WALL_DIR.iterdir()
                if p.is_file() and p.suffix.lower() in EXTENSIONS])
if not walls:
    sys.exit(f"No wallpapers in {WALL_DIR}")

THUMB_DIR.mkdir(parents=True, exist_ok=True)

# ── ensure awww-daemon running ────────────────────────────────────────────────
result = subprocess.run(["pgrep", "-x", "awww-daemon"], capture_output=True)
if result.returncode != 0:
    subprocess.Popen(["awww-daemon"])
    import time; time.sleep(0.5)

# ── pygame init ───────────────────────────────────────────────────────────────
os.environ.setdefault("SDL_VIDEODRIVER", "wayland")
pygame.init()
screen = pygame.display.set_mode((WIN_W, WIN_H), pygame.NOFRAME)
pygame.display.set_caption("wallpaper-select")
clock  = pygame.time.Clock()

IMG_W = WIN_W - PAD * 2
IMG_H = WIN_H - PAD * 2
IMG_X = PAD
IMG_Y = PAD

# ── thumbnail loader ──────────────────────────────────────────────────────────
cache: dict[int, pygame.Surface] = {}

def load_thumb(idx: int) -> pygame.Surface:
    if idx in cache:
        return cache[idx]
    wall  = walls[idx]
    tpath = THUMB_DIR / (wall.stem + ".png")
    if not tpath.exists() or tpath.stat().st_mtime < wall.stat().st_mtime:
        subprocess.run([
            "convert", str(wall),
            "-thumbnail", f"{IMG_W}x{IMG_H}^",
            "-gravity", "center",
            "-extent",  f"{IMG_W}x{IMG_H}",
            str(tpath)
        ], capture_output=True)
    surf = pygame.image.load(str(tpath)).convert()
    surf = pygame.transform.smoothscale(surf, (IMG_W, IMG_H))
    cache[idx] = surf
    return surf

# ── draw ──────────────────────────────────────────────────────────────────────
def draw(idx: int):
    screen.fill(BG)
    img = load_thumb(idx)
    screen.blit(img, (IMG_X, IMG_Y))
    pygame.draw.rect(screen, BORDER, (0, 0, WIN_W, WIN_H), BORDER_W, RADIUS)
    pygame.display.flip()

# ── preload first ─────────────────────────────────────────────────────────────
cur = 0
screen.fill(BG)
pygame.display.flip()
load_thumb(cur)

# ── main loop ─────────────────────────────────────────────────────────────────
running     = True
applied     = False
last_click  = 0

while running:
    draw(cur)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        elif event.type == pygame.KEYDOWN:
            if event.key in (pygame.K_ESCAPE, pygame.K_q):
                running = False
            elif event.key in (pygame.K_RIGHT, pygame.K_l):
                cur = (cur + 1) % len(walls)
            elif event.key in (pygame.K_LEFT, pygame.K_h):
                cur = (cur - 1) % len(walls)
            elif event.key == pygame.K_RETURN:
                applied = True
                running = False

        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            mx, my = event.pos
            in_img = IMG_X <= mx <= IMG_X + IMG_W and IMG_Y <= my <= IMG_Y + IMG_H
            if not in_img:
                running = False
            else:
                now = pygame.time.get_ticks()
                if now - last_click < DOUBLE_MS:
                    applied = True
                    running = False
                last_click = now

    clock.tick(60)

pygame.quit()

if applied:
    subprocess.run(["awww", "img", str(walls[cur])] + TRANSITION)
