#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the date and time.
##
## Using `\udb80\udcf0` (calendar and clock) icon.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item datetime right
sketchybar --set datetime icon="󰃰" update_freq=60 script="${CONFIG_DIR}/plugins/datetime.sh"

