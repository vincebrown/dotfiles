#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/everforest.sh"

## ─────────────────────────────────────────────────────────────────────────────
## Displays the date and time in `YYYY-MM-DD HH:MM` format.
## ─────────────────────────────────────────────────────────────────────────────
sketchybar --set "$NAME" label="$(date +'%m/%d/%y %I:%M %p')" label.color="${EF_GRAY2}" icon.color="${EF_GRAY2}"
