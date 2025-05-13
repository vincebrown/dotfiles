#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the battery charge.
## ─────────────────────────────────────────────────────────────────────────────
_SSDF_SB_PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
_SSDF_SB_CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "" = "${_SSDF_SB_PERCENTAGE}" ]; then
  exit 0
fi

case "${_SSDF_SB_PERCENTAGE}" in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ "" != "${_SSDF_SB_CHARGING}" ]]; then
  ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${_SSDF_SB_PERCENTAGE}%"
