# Add custom completions directory to fpath
fpath=($HOME/zsh/completions $fpath)
autoload -Uz compinit
compinit

export XDG_CONFIG_HOME="$HOME/.config"

export LS_COLORS="$(vivid generate catppuccin-mocha)"
export COLORTERM=truecolor

# set cursor shape
echo -ne '\e[1 q'

# Default editor
export EDITOR=nvim

# Enable vi mode
bindkey -v

# Fix backspace bug when using vi mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char


export PATH="$PATH:/Users/vince.brown/.local/bin"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

