# Git Worktree Utilities
# Provides convenient functions for managing git worktrees with automatic setup
#
# Worktrees are created in a sibling directory named: ${repo-name}-worktrees
# Example: ~/Repos/phoenix-bff -> ~/Repos/phoenix-bff-worktrees/feature-branch

# Configuration - customize these as needed
GWT_ENV_FILES="${GWT_ENV_FILES:-.env .env.local}"  # Space-separated list of env files to copy
GWT_COPY_FILES="${GWT_COPY_FILES:-}"  # Additional files to copy (space-separated)
GWT_AUTO_INSTALL="${GWT_AUTO_INSTALL:-true}"  # Auto-run package manager install

# ============================================================================
# Colors
# ============================================================================

# Color codes (works in zsh)
_gwt_colors() {
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_RED=$'\033[31m'
    C_GREEN=$'\033[32m'
    C_YELLOW=$'\033[33m'
    C_BLUE=$'\033[34m'
    C_MAGENTA=$'\033[35m'
    C_CYAN=$'\033[36m'
    C_WHITE=$'\033[37m'
}
_gwt_colors

# ============================================================================
# Core Functions
# ============================================================================

# Get the root of the main worktree (bare repo or main working directory)
# Always returns an absolute path
function _gwt_get_main_root() {
    # First, try the simple case - regular repo or worktree
    local toplevel
    toplevel=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -n "$toplevel" ]]; then
        echo "$toplevel"
        return 0
    fi

    # If --show-toplevel fails, we might be in a bare repo
    local git_dir
    git_dir=$(git rev-parse --git-dir 2>/dev/null) || return 1

    # Bare repo - git_dir IS the repo
    if [[ "$git_dir" == "." ]]; then
        pwd
    else
        (cd "$git_dir" && pwd)
    fi
}

# Get the actual main repo root (handles being called from a worktree directory)
function _gwt_get_actual_main_root() {
    local main_root
    main_root=$(_gwt_get_main_root) || return 1

    local repo_name
    repo_name=$(basename "$main_root")

    # If we're in a worktrees directory, find the actual main repo
    if [[ "$repo_name" == *"-worktrees" ]]; then
        local base_name="${repo_name%-worktrees}"
        local actual_main="$(dirname "$main_root")/$base_name"
        if [[ -d "$actual_main/.git" ]] || [[ -f "$actual_main/.git" ]]; then
            echo "$actual_main"
            return 0
        fi
    fi

    echo "$main_root"
}

# Get the worktrees directory path (sibling to main repo, named ${repo}-worktrees)
function _gwt_get_worktrees_dir() {
    local main_root
    main_root=$(_gwt_get_actual_main_root) || return 1

    local repo_name
    repo_name=$(basename "$main_root")

    echo "$(dirname "$main_root")/${repo_name}-worktrees"
}

# Ensure worktrees directory exists and return the path
# Messages go to stderr, only the path goes to stdout
function _gwt_ensure_worktrees_dir() {
    local worktrees_dir
    worktrees_dir=$(_gwt_get_worktrees_dir) || return 1

    if [[ ! -d "$worktrees_dir" ]]; then
        mkdir -p "$worktrees_dir"
        echo "Created worktrees directory: $worktrees_dir" >&2
    fi

    echo "$worktrees_dir"
}

# Detect package manager and return install command
function _gwt_get_install_cmd() {
    local dir="$1"

    if [[ -f "$dir/bun.lockb" ]]; then
        echo "bun install"
    elif [[ -f "$dir/pnpm-lock.yaml" ]]; then
        echo "pnpm install"
    elif [[ -f "$dir/yarn.lock" ]]; then
        echo "yarn install"
    elif [[ -f "$dir/package-lock.json" ]] || [[ -f "$dir/package.json" ]]; then
        echo "npm install"
    fi
}

# Copy env and config files from main repo to worktree
function _gwt_copy_files() {
    local source_dir="$1"
    local target_dir="$2"
    local files_to_copy=($=GWT_ENV_FILES $=GWT_COPY_FILES)
    local copied=()

    for file in $files_to_copy; do
        if [[ -f "$source_dir/$file" ]]; then
            cp "$source_dir/$file" "$target_dir/$file"
            copied+=("$file")
        fi
    done

    if [[ ${#copied[@]} -gt 0 ]]; then
        echo "  Copied: ${copied[*]}"
    fi
}

# Get GitHub repo info (owner/repo) from remote
function _gwt_get_gh_repo() {
    local main_root="$1"
    local remote_url
    remote_url=$(cd "$main_root" && git remote get-url origin 2>/dev/null) || return 1

    # Extract owner/repo from various URL formats
    if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
        echo "${match[1]}/${match[2]}"
    fi
}

# Get PR info for a branch using gh cli
function _gwt_get_pr_info() {
    local branch="$1"
    local repo="$2"

    # Check if gh is available
    command -v gh &>/dev/null || return 1

    # Get PR info (number, state, reviewDecision)
    local pr_json
    pr_json=$(gh pr view "$branch" --repo "$repo" --json number,state,reviewDecision,url 2>/dev/null) || return 1

    local pr_num pr_state pr_review
    pr_num=$(echo "$pr_json" | jq -r '.number' 2>/dev/null)
    pr_state=$(echo "$pr_json" | jq -r '.state' 2>/dev/null)
    pr_review=$(echo "$pr_json" | jq -r '.reviewDecision // empty' 2>/dev/null)

    [[ -z "$pr_num" || "$pr_num" == "null" ]] && return 1

    # Build status string
    local pr_status="#${pr_num}"

    case "$pr_state" in
        OPEN)
            pr_status="${C_GREEN}${pr_status} open${C_RESET}"
            ;;
        MERGED)
            pr_status="${C_MAGENTA}${pr_status} merged${C_RESET}"
            ;;
        CLOSED)
            pr_status="${C_RED}${pr_status} closed${C_RESET}"
            ;;
    esac

    # Add review status
    case "$pr_review" in
        APPROVED)
            pr_status="${pr_status} ${C_GREEN}approved${C_RESET}"
            ;;
        CHANGES_REQUESTED)
            pr_status="${pr_status} ${C_RED}changes requested${C_RESET}"
            ;;
        REVIEW_REQUIRED)
            pr_status="${pr_status} ${C_YELLOW}review required${C_RESET}"
            ;;
    esac

    echo "$pr_status"
}

# Build worktree info for fzf/display
# Returns: branch|path|status_summary|ahead_behind|pr_info
function _gwt_build_worktree_info() {
    local main_root="$1"
    local show_pr="${2:-false}"
    local gh_repo=""

    if [[ "$show_pr" == "true" ]]; then
        gh_repo=$(_gwt_get_gh_repo "$main_root")
    fi

    (cd "$main_root" && git worktree list --porcelain) | while read -r line; do
        case "$line" in
            worktree\ *)
                current_path="${line#worktree }"
                ;;
            branch\ *)
                current_branch="${line#branch refs/heads/}"

                # Get status
                local status_text=""
                local status_color=""
                if [[ -d "$current_path" ]]; then
                    local status_output
                    status_output=$(cd "$current_path" && git status --porcelain 2>/dev/null)
                    if [[ -n "$status_output" ]]; then
                        local modified=$(echo "$status_output" | grep -c "^ M\|^M ")
                        local added=$(echo "$status_output" | grep -c "^A \|^??")
                        local deleted=$(echo "$status_output" | grep -c "^ D\|^D ")
                        status_text="${modified}M ${added}A ${deleted}D"
                        status_color="$C_RED"
                    else
                        status_text="clean"
                        status_color="$C_GREEN"
                    fi
                fi

                # Get ahead/behind
                local sync_text=""
                local sync_color=""
                local upstream
                upstream=$(cd "$current_path" && git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
                if [[ -n "$upstream" ]]; then
                    local ahead_behind
                    ahead_behind=$(cd "$current_path" && git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
                    local ahead=$(echo "$ahead_behind" | cut -f1)
                    local behind=$(echo "$ahead_behind" | cut -f2)
                    if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
                        [[ "$ahead" -gt 0 ]] && sync_text="↑${ahead}"
                        [[ "$behind" -gt 0 ]] && sync_text="${sync_text}↓${behind}"
                        if [[ "$behind" -gt 0 ]]; then
                            sync_color="$C_YELLOW"
                        else
                            sync_color="$C_CYAN"
                        fi
                    fi
                fi

                # Get PR info if requested
                local pr_text=""
                if [[ -n "$gh_repo" ]]; then
                    pr_text=$(_gwt_get_pr_info "$current_branch" "$gh_repo")
                fi

                # Output structured info
                echo "${current_branch}|${current_path}|${status_color}${status_text}${C_RESET}|${sync_color}${sync_text}${C_RESET}|${pr_text}"
                ;;
        esac
    done
}

# ============================================================================
# Main Commands
# ============================================================================

# Add a new worktree
# Usage: gwt-add <branch-name> [base-branch]
# Examples:
#   gwt-add feature/my-feature          # Creates worktree from current branch
#   gwt-add feature/my-feature main     # Creates worktree from main
#   gwt-add bugfix/issue-123 develop    # Creates worktree from develop
function gwt-add() {
    local branch_name="$1"
    local base_branch="${2:-HEAD}"

    if [[ -z "$branch_name" ]]; then
        echo "Usage: gwt-add <branch-name> [base-branch]"
        echo ""
        echo "Examples:"
        echo "  gwt-add feature/my-feature          # Branch from current HEAD"
        echo "  gwt-add feature/my-feature main     # Branch from main"
        echo "  gwt-add bugfix/issue-123 develop    # Branch from develop"
        return 1
    fi

    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "Error: Not in a git repository"
        return 1
    }

    # Ensure worktrees directory exists
    local worktrees_dir
    worktrees_dir=$(_gwt_ensure_worktrees_dir) || return 1

    # Clean branch name for directory (replace / with -)
    local dir_name="${branch_name//\//-}"
    local worktree_path="$worktrees_dir/$dir_name"

    echo "${C_BOLD}Creating worktree for branch: ${C_CYAN}$branch_name${C_RESET}"
    echo "  ${C_DIM}Main repo:${C_RESET} $main_root"
    echo "  ${C_DIM}Location:${C_RESET}  $worktree_path"
    echo "  ${C_DIM}Base:${C_RESET}      $base_branch"
    echo ""

    # Need to run git commands from the main repo
    (
        cd "$main_root" || exit 1

        # Check if branch already exists
        if git show-ref --verify --quiet "refs/heads/$branch_name" 2>/dev/null; then
            # Branch exists, check out existing branch
            echo "${C_YELLOW}-> Branch exists, creating worktree...${C_RESET}"
            git worktree add "$worktree_path" "$branch_name"
        else
            # Create new branch
            echo "${C_GREEN}-> Creating new branch and worktree...${C_RESET}"
            git worktree add -b "$branch_name" "$worktree_path" "$base_branch"
        fi
    ) || return 1

    echo ""

    # Copy env files
    echo "${C_BLUE}-> Copying configuration files...${C_RESET}"
    _gwt_copy_files "$main_root" "$worktree_path"

    # Auto install dependencies
    if [[ "$GWT_AUTO_INSTALL" == "true" ]]; then
        local install_cmd
        install_cmd=$(_gwt_get_install_cmd "$worktree_path")

        if [[ -n "$install_cmd" ]]; then
            echo ""
            # Trust mise configuration if present
            if [[ -f "$worktree_path/.mise.toml" ]] || [[ -f "$worktree_path/.tool-versions" ]]; then
                echo "${C_BLUE}-> Trusting mise configuration...${C_RESET}"
                (cd "$worktree_path" && mise trust)
            fi
            echo "${C_BLUE}-> Installing dependencies ($install_cmd)...${C_RESET}"
            (cd "$worktree_path" && eval "$install_cmd")
        fi
    fi

    echo ""
    echo "${C_GREEN}${C_BOLD}Worktree created successfully!${C_RESET}"
    echo ""
    echo "To switch to the worktree:"
    echo "  ${C_CYAN}cd $worktree_path${C_RESET}"
}

# Remove a worktree
# Usage: gwt-remove <branch-name> [--force]
function gwt-remove() {
    local branch_name="$1"
    local force_flag=""

    # Check for --force flag
    if [[ "$1" == "--force" ]] || [[ "$2" == "--force" ]]; then
        force_flag="--force"
        [[ "$1" == "--force" ]] && branch_name="$2"
    fi

    if [[ -z "$branch_name" ]]; then
        echo "Usage: gwt-remove <branch-name> [--force]"
        echo ""
        echo "Options:"
        echo "  --force    Remove even if worktree has uncommitted changes"
        return 1
    fi

    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "Error: Not in a git repository"
        return 1
    }

    local worktrees_dir
    worktrees_dir=$(_gwt_get_worktrees_dir)

    local dir_name="${branch_name//\//-}"
    local worktree_path="$worktrees_dir/$dir_name"

    if [[ ! -d "$worktree_path" ]]; then
        echo "${C_RED}Error: Worktree not found at $worktree_path${C_RESET}"
        echo ""
        echo "Available worktrees:"
        gwt-list
        return 1
    fi

    echo "${C_BOLD}Removing worktree: ${C_YELLOW}$worktree_path${C_RESET}"

    # Check for uncommitted changes
    if [[ -z "$force_flag" ]]; then
        local wt_status
        wt_status=$(cd "$worktree_path" && git status --porcelain 2>/dev/null)
        if [[ -n "$wt_status" ]]; then
            echo ""
            echo "${C_RED}Warning: Worktree has uncommitted changes:${C_RESET}"
            echo "$wt_status" | head -10
            echo ""
            read -q "REPLY?Remove anyway? (y/N) "
            echo ""
            [[ "$REPLY" != "y" ]] && return 1
            force_flag="--force"
        fi
    fi

    # Run from main repo
    (cd "$main_root" && git worktree remove $force_flag "$worktree_path") || return 1

    echo "${C_GREEN}Worktree removed${C_RESET}"

    # Optionally delete the branch
    echo ""
    read -q "REPLY?Delete branch '$branch_name'? (y/N) "
    echo ""
    if [[ "$REPLY" == "y" ]]; then
        (cd "$main_root" && git branch -d "$branch_name" 2>/dev/null) || {
            echo "${C_YELLOW}Branch not fully merged. Force delete? (y/N)${C_RESET} "
            read -q "REPLY?"
            echo ""
            [[ "$REPLY" == "y" ]] && (cd "$main_root" && git branch -D "$branch_name")
        }
    fi
}

# List all worktrees
# Usage: gwt-list
function gwt-list() {
    local main_root
    main_root=$(_gwt_get_actual_main_root) 2>/dev/null

    if [[ -z "$main_root" ]]; then
        echo "${C_RED}Error: Not in a git repository${C_RESET}"
        return 1
    fi

    echo "${C_BOLD}Git Worktrees for: ${C_CYAN}$(basename "$main_root")${C_RESET}"
    echo ""

    local info
    while IFS='|' read -r branch path wt_status sync pr_info; do
        [[ -z "$branch" ]] && continue

        # Format output
        printf "  ${C_BOLD}${C_BLUE}%-30s${C_RESET}" "[$branch]"
        printf " %s" "$wt_status"
        [[ -n "$sync" ]] && printf " %s" "$sync"
        echo ""
        printf "    ${C_DIM}%s${C_RESET}\n" "$path"
    done < <(_gwt_build_worktree_info "$main_root" false)
}

# Switch to a worktree by branch name (with fzf support)
# Usage: gwt-cd [branch-name]
function gwt-cd() {
    local branch_name="$1"

    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "${C_RED}Error: Not in a git repository${C_RESET}"
        return 1
    }

    # If no branch specified and fzf is available, use interactive selection
    if [[ -z "$branch_name" ]] && command -v fzf &>/dev/null; then
        local selected
        selected=$(_gwt_build_worktree_info "$main_root" false | \
            fzf --ansi \
                --delimiter='|' \
                --with-nth=1,3,4 \
                --preview='echo "Path: {2}"; echo ""; cd {2} && git log --oneline -5' \
                --preview-window=right:50% \
                --header='Select worktree (enter to switch)' \
                --prompt='Worktree> ')

        [[ -z "$selected" ]] && return 0

        branch_name=$(echo "$selected" | cut -d'|' -f1)
    fi

    if [[ -z "$branch_name" ]]; then
        echo "Usage: gwt-cd <branch-name>"
        echo ""
        echo "${C_DIM}Tip: Run without arguments to use fzf picker${C_RESET}"
        echo ""
        gwt-list
        return 1
    fi

    # First try to find by branch name in git worktree list
    local worktree_path
    worktree_path=$(cd "$main_root" && git worktree list --porcelain | grep -B2 "branch refs/heads/$branch_name$" | grep "^worktree" | head -1 | cut -d' ' -f2-)

    # If not found, try the expected directory path
    if [[ -z "$worktree_path" ]]; then
        local worktrees_dir
        worktrees_dir=$(_gwt_get_worktrees_dir)
        local dir_name="${branch_name//\//-}"
        worktree_path="$worktrees_dir/$dir_name"
    fi

    if [[ -d "$worktree_path" ]]; then
        cd "$worktree_path"
        echo "${C_GREEN}Switched to:${C_RESET} $worktree_path"
        echo "${C_DIM}Branch:${C_RESET} $(git branch --show-current)"
    else
        echo "${C_RED}Error: Worktree not found for branch '$branch_name'${C_RESET}"
        echo ""
        gwt-list
        return 1
    fi
}

# Clean up stale worktree references
# Usage: gwt-prune
function gwt-prune() {
    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "${C_RED}Error: Not in a git repository${C_RESET}"
        return 1
    }

    echo "${C_BOLD}Pruning stale worktree references...${C_RESET}"
    (cd "$main_root" && git worktree prune -v)
    echo "${C_GREEN}Done${C_RESET}"
}

# Clone a repo as bare and set up for worktree workflow
# Usage: gwt-clone <repo-url> [directory-name]
function gwt-clone() {
    local repo_url="$1"
    local dir_name="$2"

    if [[ -z "$repo_url" ]]; then
        echo "Usage: gwt-clone <repo-url> [directory-name]"
        echo ""
        echo "Clones a repository as a bare repo optimized for worktree workflow."
        echo "Creates a 'main' worktree automatically."
        return 1
    fi

    # Extract repo name from URL if not provided
    if [[ -z "$dir_name" ]]; then
        dir_name=$(basename "$repo_url" .git)
    fi

    local bare_dir="${dir_name}.git"

    echo "${C_BOLD}Cloning $repo_url as bare repository...${C_RESET}"
    git clone --bare "$repo_url" "$bare_dir" || return 1

    cd "$bare_dir" || return 1

    # Set up remote tracking
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    # Determine default branch
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    [[ -z "$default_branch" ]] && default_branch="main"

    echo ""
    echo "${C_BLUE}Creating worktree for $default_branch...${C_RESET}"
    git worktree add "../$dir_name" "$default_branch"

    echo ""
    echo "${C_GREEN}${C_BOLD}Repository set up for worktree workflow!${C_RESET}"
    echo ""
    echo "Structure:"
    echo "  ${C_DIM}$bare_dir/${C_RESET}     (bare repo - don't work here)"
    echo "  ${C_CYAN}$dir_name/${C_RESET}     (main worktree)"
    echo ""
    echo "Next steps:"
    echo "  ${C_CYAN}cd ../$dir_name${C_RESET}"
    echo "  ${C_CYAN}gwt-add feature/my-feature${C_RESET}"
}

# Show status of all worktrees (with colors and PR info)
# Usage: gwt-status [--no-pr]
function gwt-status() {
    local show_pr="true"
    [[ "$1" == "--no-pr" ]] && show_pr="false"

    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "${C_RED}Error: Not in a git repository${C_RESET}"
        return 1
    }

    echo "${C_BOLD}Worktree Status for: ${C_CYAN}$(basename "$main_root")${C_RESET}"
    echo ""

    local info
    while IFS='|' read -r branch path wt_status sync pr_info; do
        [[ -z "$branch" ]] && continue

        # Branch header
        echo "${C_BOLD}${C_BLUE}[$branch]${C_RESET} ${C_DIM}$path${C_RESET}"

        # Status line
        printf "  "
        if [[ "$wt_status" == *"clean"* ]]; then
            printf "${C_GREEN}✓ clean${C_RESET}"
        else
            printf "${C_RED}✗ %s${C_RESET}" "$wt_status"
        fi

        # Sync status
        if [[ -n "$sync" && "$sync" != $'\033[0m' ]]; then
            printf "  %s" "$sync"
        fi

        echo ""

        # PR info
        if [[ -n "$pr_info" ]]; then
            echo "  ${C_DIM}PR:${C_RESET} $pr_info"
        fi

        echo ""
    done < <(_gwt_build_worktree_info "$main_root" "$show_pr")
}

# Fetch and update all worktrees
# Usage: gwt-fetch
function gwt-fetch() {
    local main_root
    main_root=$(_gwt_get_actual_main_root) || {
        echo "${C_RED}Error: Not in a git repository${C_RESET}"
        return 1
    }

    echo "${C_BOLD}Fetching updates for all worktrees...${C_RESET}"
    echo ""

    (cd "$main_root" && git fetch --all --prune)

    echo ""
    echo "${C_BOLD}Worktree status after fetch:${C_RESET}"
    gwt-status --no-pr
}

# ============================================================================
# Aliases
# ============================================================================

alias gwa='gwt-add'
alias gwr='gwt-remove'
alias gwl='gwt-list'
alias gws='gwt-status'
alias gwc='gwt-cd'
alias gwf='gwt-fetch'
alias gwp='gwt-prune'
