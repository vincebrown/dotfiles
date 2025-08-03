#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays AeroSpace Workspaces.
## ─────────────────────────────────────────────────────────────────────────────
sketchybar --add event aerospace_workspace_change

workspace_icon() {
  case "$1" in
  1) printf "" ;; # Terminal
  2) printf "" ;; # Browser
  3) printf "" ;; # Slack
  4) printf "" ;; # Github
  5) printf "󰙏" ;; # Obsidian
  6) printf "" ;; # Music
  *) printf "󰚌" ;;
  esac
}

for WORKSPACE_ID in $(aerospace list-workspaces --all); do
  WS_ICON=$(workspace_icon "${WORKSPACE_ID}")

  sketchybar --add item "workspace.${WORKSPACE_ID}" left
  sketchybar --subscribe "workspace.${WORKSPACE_ID}" aerospace_workspace_change
  sketchybar --set "workspace.${WORKSPACE_ID}" \
    background.corner_radius=5 \
    background.height=20 \
    background.color="${SURFACE_0}" \
    label.color="${SUBTEXT_0}" \
    label="${WORKSPACE_ID}: ${WS_ICON}" \
    script="${CONFIG_DIR}/plugins/workspaces.sh ${WORKSPACE_ID}"
done
