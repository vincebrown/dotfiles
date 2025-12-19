#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"

## Displays number of Slack direct unread notifications.
SLACK_STATUS_LABEL=$(lsappinfo info -only StatusLabel Slack | sed -n 's/.*"label"="\(.*\)".*/\1/p')

sketchybar --set "$NAME" label="${SLACK_STATUS_LABEL}" label.color="${RED}"
