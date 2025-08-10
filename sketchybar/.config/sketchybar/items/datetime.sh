#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"

## ─────────────────────────────────────────────────────────────────────────────
## Displays the date and time.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item datetime right
sketchybar --set datetime \
  icon="󰃭" \
  update_freq=60 \
  script="${CONFIG_DIR}/plugins/datetime.sh" \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0_40}" \
  icon.padding_left=8 \
  label.padding_right=8
