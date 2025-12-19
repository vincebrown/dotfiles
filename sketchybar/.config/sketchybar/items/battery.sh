#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the battery charge, updated every:
## * 10 minutes
## * when the computer comes back from sleep
## * when the battery charge signals a change
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item battery right
sketchybar --set battery \
  update_freq=600 \
  script="${CONFIG_DIR}/plugins/battery.sh" \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0_40}" \
  icon.padding_left=8 \
  label.padding_right=8
sketchybar --subscribe battery system_woke power_source_change
