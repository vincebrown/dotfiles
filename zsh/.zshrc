# Source homebrew first as other files may depend on tools that were downloaded from it
source ~/.config/zsh/tools/homebrew.zsh

# General
# Conditionally source tokens file is ignored in .gitignore (github etc..)
[[ -f "$HOME/.config/zsh/tokens.zsh" ]] && source "$HOME/.config/zsh/tokens.zsh"

source ~/.config/zsh/env.zsh
source ~/.config/zsh/keybinds.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/zstyle.zsh

# Tools
source ~/.config/zsh/tools/mise.zsh
source ~/.config/zsh/tools/starship.zsh
source ~/.config/zsh/tools/thefuck.zsh
source ~/.config/zsh/tools/zoxide.zsh
source ~/.config/zsh/tools/eza.zsh
source ~/.config/zsh/tools/carapace.zsh
source ~/.config/zsh/tools/fzf.zsh
source ~/.config/zsh/tools/yazi.zsh

# Plugins
local fzf_tab_plugin="$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
if [[ -f "$fzf_tab_plugin" ]]; then
  source "$fzf_tab_plugin"
fi

# Repos
# conditionally load repo specific config files if they exist
local repo_config_dir="$HOME/.config/zsh/repos"
if [[ -d "$repo_config_dir" ]]; then
  # (N) = nullglob: if no files match, the loop doesn't run (no error)
  # (.) = regular files only
  for file in "$repo_config_dir"/*.zsh(N.); do
    source "$file"
  done
fi

# Utils
source ~/.config/zsh/utils/hh-env.zsh
source ~/.config/zsh/utils/ffv.zsh
source ~/.config/zsh/utils/git-clean-branches.zsh



# This plugin must be sourced at the bottom of the .zshrc
local syntax_highlighting_plugin="$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
if [[ -f "$syntax_highlighting_plugin" ]]; then
  source "$syntax_highlighting_plugin"
fi

