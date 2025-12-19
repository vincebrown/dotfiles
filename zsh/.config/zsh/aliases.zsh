# Add dockspace to apple app bar at bottom of screen
alias dockSpace="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock"

# alias ls with eza for better display
alias ls="eza --color=always -G -a --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lsP="eza --color=always -G -a --long --icons=always --no-filesize --no-user --no-time"
alias c="clear"

# Source config
alias sz="source ~/.zshrc"

# alias -h and --help with Bat for formatting
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias lsPkgScripts="bat package.json | jq '.scripts'"

# Tmux Aliases
tm() {
    if [ $# -eq 0 ]; then
        tmux list-sessions
        return
    fi

    if [ -n "$TMUX" ]; then
        # In tmux: switch or create+switch
        tmux switch-client -t "$1" 2>/dev/null || \
        tmux new-session -d -s "$1" \; switch-client -t "$1"
    else
        # Not in tmux: attach or create
        tmux attach-session -t "$1" 2>/dev/null || \
        tmux new-session -s "$1"
    fi
}
alias tmk='tmux kill-session -t'
alias tml='tmux list-sessions'
alias tmkall='tmux kill-server'
alias tmr='tmux rename-window'
alias tmrs='tmux rename-session'
alias tmd='tmux detach'

# Connect/create to session via sesh
tmc() {
    sesh connect $(sesh list | fzf)
}

# Git aliases

# git add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch' # Stage changes interactively
alias gau='git add --update' # Stage changes of tracked files only
alias gav='git add --verbose' # Stage changes and be verbose
alias gclean='git clean --interactive -d'

# git branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

# git checkout
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcb='git checkout -b'
alias gcB='git checkout -B'

# git commit
alias gcam='git commit --all --message'
alias gcmsg='git commit --message'
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'

# git config
alias gcf='git config --list'

# git diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# git log
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
alias glp='_git_log_prettily'
alias glg='git log --stat'
alias glgp='git log --stat --patch'

# git merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gms="git merge --squash"
alias gmff="git merge --ff-only"

# git pull
alias gf='git fetch'
alias gfsm='git fetch --recurse-submodules'
alias gl='git pull'
alias gpsm='git pull --recurse-submodules'
alias gpr='git pull --rebase'
alias gprv='git pull --rebase -v'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'

# git push
alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push --verbose'
alias gpu='git push upstream'

# git restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# git remove
alias grm='git rm'
alias grmc='git rm --cached'

# git status
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'

# git switch
alias gsw='git switch'
alias gswc='git switch --create'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

