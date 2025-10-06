#!/bin/bash

## ─────────────────────────────────────────────────────────────────────────────
## Displays any upcoming meetings via Notion calendar
## When the icon is clicked the google meet link will open
## ─────────────────────────────────────────────────────────────────────────────
sketchybar --add item cron right
sketchybar --set cron \
  icon=" " \
  label="..." \
  update_freq=120 \
  script="${CONFIG_DIR}/plugins/cron.js" \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${EF_BG2_40}" \
  icon.padding_left=8 \
  label.padding_right=8
