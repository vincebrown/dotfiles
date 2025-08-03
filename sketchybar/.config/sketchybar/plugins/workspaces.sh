#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/catppuccin-mocha.sh"

## If the AeroSpace Workspace is the one in focus, then highlight it.
WORKSPACE_ID=$1
WORKSPACE_FOCUSED="${FOCUSED_WORKSPACE}"
if [[ -z "${WORKSPACE_FOCUSED}" ]]; then
  WORKSPACE_FOCUSED=$(aerospace list-workspaces --focused)
fi

if [ "${WORKSPACE_ID}" = "${WORKSPACE_FOCUSED}" ]; then
  sketchybar --set "$NAME" \
    label.color="${MAUVE}" \
    background.color="${SURFACE_1}"
else
  sketchybar --set "$NAME" background.drawing=off \
    label.color="${SUBTEXT_0}" \
    background.color="${SURFACE_0}"
fi
