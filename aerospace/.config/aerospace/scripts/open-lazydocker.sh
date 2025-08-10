#!/bin/bash

# ~/bin/open-lazydocker.sh
open -na /Applications/Ghostty.app --args -e lazydocker
sleep 1

# The newly opened window should be focused, so move the focused window
aerospace move-node-to-workspace 4
aerospace workspace 4
