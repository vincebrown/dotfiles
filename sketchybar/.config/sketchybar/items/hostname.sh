#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays hostname.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item hostname left
sketchybar --set hostname icon="" script="${CONFIG_DIR}/plugins/hostname.sh"

