#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays the hostname.
## ─────────────────────────────────────────────────────────────────────────────
_SSDF_SB_HOSTNAME=$(hostname)
if [ "KFH7X7T56W" = "${_SSDF_SB_HOSTNAME}" ]; then
    _SSDF_SB_HOSTNAME="nui-rama"
fi

# sketchybar --set "$NAME" label="${_SSDF_SB_HOSTNAME}"
sketchybar --set "$NAME" label="Vince"
