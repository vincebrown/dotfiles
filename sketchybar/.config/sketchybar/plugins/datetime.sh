#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the date and time in `YYYY-MM-DD HH:MM` format.
## ─────────────────────────────────────────────────────────────────────────────
sketchybar --set "$NAME" label="$(date +'%m/%d/%y %H:%M')"
