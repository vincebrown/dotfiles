#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays hostname.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item hostname left
sketchybar --set hostname icon="" icon.color="${EF_AQUA}" script="${CONFIG_DIR}/plugins/hostname.sh" padding_right=16
