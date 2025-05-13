#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-macchiato.sh"

## ─────────────────────────────────────────────────────────────────────────────
## Displays numbder of Slack direct unread notifications.
## ─────────────────────────────────────────────────────────────────────────────
_SSDF_SB_SLACK_STATUS_LABEL=$(lsappinfo info -only StatusLabel Slack | sed -n 's/.*"label"="\(.*\)".*/\1/p')

sketchybar --set "$NAME" label="${_SSDF_SB_SLACK_STATUS_LABEL}" label.color="${_SSDF_CM_RED}"
