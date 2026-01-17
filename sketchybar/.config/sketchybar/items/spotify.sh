#!/usr/bin/env bash
## ─────────────────────────────────────────────────────────────────────────────
## Displays current Spotify track (Artist - Song) when open.
## Hidden when Spotify is not running.
## Uses Spotify's playback state change notification for instant updates.
## ─────────────────────────────────────────────────────────────────────────────

sketchybar --add event spotify_change "com.spotify.client.PlaybackStateChanged"
sketchybar --add item spotify right
sketchybar --set spotify \
  icon="󰓇" \
  icon.padding_left=8 \
  label.padding_right=8 \
  background.corner_radius=5 \
  background.height=20 \
  background.color="${SURFACE_0_40}" \
  drawing=off \
  label.max_chars=40 \
  label.scroll_duration=200 \
  scroll_texts=on \
  script="${CONFIG_DIR}/plugins/spotify.sh" \
  --subscribe spotify spotify_change

# TODO: Revisit scroll_texts - currently clips last character with max_chars
# See: https://github.com/FelixKratz/SketchyBar/issues
# Uncomment and add to --set above to enable:
#   label.max_chars=40 \
#   label.scroll_duration=200 \
#   scroll_texts=on \
