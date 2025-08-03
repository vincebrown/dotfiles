#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"

# Get the current focused application
CURRENT_APP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# Update the item with the current app name
sketchybar --set "$NAME" \
  label="${CURRENT_APP}" \
  label.color="${GREEN}" \
  icon.padding_left=0 \
  icon.padding_right=0 \
  label.padding_left=8 \
  label.padding_right=8 \
  background.color="${SURFACE_1}"
