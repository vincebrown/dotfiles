# Source homebrew first as other files may depend on tools that were downloaded from it
source ~/.config/zsh/tools/homebrew.zsh

# General
# Conditionally source tokens file is ignored in .gitignore (github etc..)
[[ -f ~/.config/zsh/tokens.zsh ]] && source ~/.config/zsh/tokens.zsh

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
if [[ -f "~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
fi

# Repos
# conditionally load repo specific config files if they exist
if [[ -d "~/.config/zsh/repos" ]]; then
  for file in ~/.config/zsh/repos/*.zsh; do
    [[ -f "$file" ]] && source "$file"
  done
fi

# Utils
source ~/.config/zsh/utils/hh-env.zsh
source ~/.config/zsh/utils/ffv.zsh



# This plugin must be sourced at the bottom of the .zshrc
if [[ -f "~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
  source "~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi

alias claude="/Users/vince.brown/.claude/local/claude"
