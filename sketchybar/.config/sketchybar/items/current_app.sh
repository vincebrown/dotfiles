#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the current focused application.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item current_app center
sketchybar --set current_app \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0}" \
  label.color="${SUBTEXT_0}" \
  update_freq=1 \
  script="${CONFIG_DIR}/plugins/current_app.sh"
