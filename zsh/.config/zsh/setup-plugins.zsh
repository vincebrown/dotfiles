#!/usr/bin/env zsh

# Where the plugins will live
PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins"
mkdir -p "$PLUGIN_DIR"

# Helper to clone a plugin if it’s not already present
function clone_if_missing() {
  local repo=$1
  # Gets the last part of the repo (e.g. "zsh-autosuggestions")
  local plugin_name=${repo:t:r}
  local target="${PLUGIN_DIR}/${plugin_name}"

  if [[ ! -d "$target" ]]; then
    git clone "https://github.com/${repo}.git" "$target"
  fi
}

# Plugins to install
clone_if_missing "junegunn/fzf-git.sh"
clone_if_missing "Aloxaf/fzf-tab"
clone_if_missing "zsh-users/zsh-syntax-highlighting"
