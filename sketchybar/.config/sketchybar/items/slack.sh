#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"
## ─────────────────────────────────────────────────────────────────────────────
## Displays the current slack layout with unread message count.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item slack right
sketchybar --set slack \
  icon="" \
  update_freq=60 \
  script="${CONFIG_DIR}/plugins/slack.sh" \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0_40}" \
  icon.padding_left=8 \
  label.padding_right=8
