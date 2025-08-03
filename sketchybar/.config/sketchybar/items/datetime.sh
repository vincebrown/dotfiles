#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the date and time.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item datetime right
sketchybar --set datetime icon="󰃭" update_freq=60 script="${CONFIG_DIR}/plugins/datetime.sh"
