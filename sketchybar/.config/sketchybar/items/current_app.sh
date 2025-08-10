#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the current focused application.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add event front_app_switched --add item current_app center
sketchybar --set current_app \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0_40}" \
  label.color="${GREEN}" \
  icon.padding_left=0 \
  icon.padding_right=0 \
  label.padding_left=8 \
  label.padding_right=8 \
  script="${CONFIG_DIR}/plugins/current_app.sh" \
  --subscribe current_app front_app_switched
