#!/usr/bin/env bash

source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"
# Displays the battery charge.

# Extract battery percentage: get battery info, find digits+%, remove % symbol
PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "" = "${PERCENTAGE}" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
9[0-9] | 100)
  ICON=""
  LABEL_COLOR="${GREEN}"
  ICON_COLOR="${GREEN}"
  ;;
[6-8][0-9])
  ICON=""
  LABEL_COLOR="${YELLOW}"
  ICON_COLOR="${YELLOW}"
  ;;
[3-5][0-9])
  ICON=""
  LABEL_COLOR="${PEACH}"
  ICON_COLOR="${PEACH}"
  ;;
[1-2][0-9])
  ICON=""
  LABEL_COLOR="${RED}"
  ICON_COLOR="${RED}"
  ;;
*)
  ICON=""
  LABEL_COLOR="${RED}"
  ICON_COLOR="${RED}"
  ;;
esac

if [[ -n "${CHARGING}" ]]; then
  ICON="󱐋"
fi

sketchybar --set "${NAME}" icon="${ICON}" label="${PERCENTAGE}%" label.color="${LABEL_COLOR}" icon.color="${ICON_COLOR}"
