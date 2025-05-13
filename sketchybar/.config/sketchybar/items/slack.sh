#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the current slack layout.
##
## Using `\uf198` (nf-fa-slack) icon.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item slack right
sketchybar --set slack icon="" update_freq=60 script="${CONFIG_DIR}/plugins/slack.sh"

