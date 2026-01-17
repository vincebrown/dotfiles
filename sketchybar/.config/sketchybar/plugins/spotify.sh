#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Spotify plugin - shows "Artist - Track" when Spotify is open.
## ─────────────────────────────────────────────────────────────────────────────

# Check if Spotify is running
if ! pgrep -x "Spotify" > /dev/null; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Get track info (will fail gracefully if no track)
ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)

# Hide if no track info available
if [ -z "$TRACK" ] || [ "$TRACK" = "missing value" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Handle podcasts (no artist)
if [ -z "$ARTIST" ] || [ "$ARTIST" = "missing value" ]; then
  LABEL="$TRACK"
else
  LABEL="$ARTIST - $TRACK"
fi

sketchybar --set "$NAME" label="$LABEL" drawing=on
