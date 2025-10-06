#!/usr/bin/env bash
source "${CONFIG_DIR}/themes/everforest.sh"

## If the AeroSpace Workspace is the one in focus, then highlight it.
WORKSPACE_ID=$1
WORKSPACE_FOCUSED="${FOCUSED_WORKSPACE}"
if [[ -z "${WORKSPACE_FOCUSED}" ]]; then
  WORKSPACE_FOCUSED=$(aerospace list-workspaces --focused)
fi

if [ "${WORKSPACE_ID}" = "${WORKSPACE_FOCUSED}" ]; then
  sketchybar --set "$NAME" \
    label.color="${EF_BLUE}" \
    background.color="${EF_BG0}"
else
  sketchybar --set "$NAME" background.drawing=off \
    label.color="${EF_GRAY2}" \
    background.color="${EF_BG2_40}"
fi
