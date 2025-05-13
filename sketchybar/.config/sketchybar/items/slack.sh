#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the current slack layout with unread message count.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item slack right
sketchybar --set slack icon="" update_freq=60 script="${CONFIG_DIR}/plugins/slack.sh"

