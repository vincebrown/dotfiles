#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays AeroSpace Workspaces.
## ─────────────────────────────────────────────────────────────────────────────
sketchybar --add event aerospace_workspace_change

_ssdf_ws_icon() {
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

for _SSDF_WS_ID in $(aerospace list-workspaces --all); do
    _SSDF_WS_ICON=$(_ssdf_ws_icon "${_SSDF_WS_ID}")

    sketchybar --add item "workspace.${_SSDF_WS_ID}" left
    sketchybar --subscribe "workspace.${_SSDF_WS_ID}" aerospace_workspace_change
    sketchybar --set "workspace.${_SSDF_WS_ID}" \
        background.corner_radius=5 \
        background.height=20 \
        background.color="${_SSDF_CM_SURFACE_0}" \
        label.color="${_SSDF_CM_SUBTEXT_0}" \
        label="${_SSDF_WS_ID}: ${_SSDF_WS_ICON}" \
        script="${CONFIG_DIR}/plugins/workspaces.sh ${_SSDF_WS_ID}"
done
