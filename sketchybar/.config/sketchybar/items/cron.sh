#!/bin/bash

# Notion Calendar
sketchybar --add item cron right
sketchybar --set cron icon=" " label="..."  update_freq=120 script="${CONFIG_DIR}/plugins/cron.js"
