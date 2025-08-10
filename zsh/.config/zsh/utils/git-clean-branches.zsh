#!/usr/bin/env zsh

# Git branch cleanup utility - simplified working version
function git_clean_branches() {
  # Check if we're in a git repo
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a git repository" >&2
    return 1
  fi

  # Parse arguments
  local days_old=14
  local show_all=false

  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--all" ]]; then
      show_all=true
      shift
    elif [[ "$1" == "--days" ]]; then
      days_old="${2:-14}"
      shift 2
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
      echo "Usage: git_clean_branches [--all] [--days N]"
      echo "  --all     Show all branches"
      echo "  --days N  Consider branches older than N days as stale (default: 14)"
      return 0
    else
      shift
    fi
  done

  # Get current and default branch
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local default_branch="main"
  if ! git show-ref --verify --quiet refs/heads/main; then
    if git show-ref --verify --quiet refs/heads/master; then
      default_branch="master"
    fi
  fi

  echo "Current branch: $current_branch"
  echo "Default branch: $default_branch"
  echo "Days threshold: $days_old"
  echo ""

  # Create a temp file for branch data
  local tmpfile=$(mktemp)

  # Process branches and write to temp file
  git for-each-ref --format='%(refname:short)|%(committerdate:iso8601)' refs/heads | while IFS='|' read -r branch date; do
    # Skip current and main/master
    if [[ "$branch" == "$current_branch" ]] || [[ "$branch" == "main" ]] || [[ "$branch" == "master" ]]; then
      continue
    fi

    # Get branch details
    local last_commit=$(git log -1 --format="%s" "$branch" 2>/dev/null | head -c 50)
    local author=$(git log -1 --format="%an" "$branch" 2>/dev/null)
    local relative=$(git log -1 --format="%cr" "$branch" 2>/dev/null)

    # Check if merged
    local merged="unmerged"
    if git branch --merged "$default_branch" | grep -q "^[* ]*$branch$"; then
      merged="merged"
    fi

    # Calculate days old
    local date_part="${date%% *}"
    local days_since=0
    if [[ -n "$date_part" ]]; then
      # Simple date calculation for macOS
      local commit_epoch=$(date -j -f "%Y-%m-%d" "$date_part" "+%s" 2>/dev/null)
      local current_epoch=$(date "+%s")
      if [[ -n "$commit_epoch" ]]; then
        days_since=$(( (current_epoch - commit_epoch) / 86400 ))
      fi
    fi

    # Build display string
    local branch_status=""
    if [[ "$merged" == "merged" ]]; then
      branch_status="✓"
    else
      branch_status="○"
    fi

    if [[ $days_since -ge $days_old ]]; then
      branch_status="${branch_status}⚠"
    fi

    # Save to temp file if it should be shown
    if [[ "$show_all" == true ]] || [[ $days_since -ge $days_old ]]; then
      printf "%s %-30s [%s] (%s) - %s by %s\n" "$branch_status" "$branch" "$merged" "$relative" "$last_commit" "$author" >> "$tmpfile"
    fi
  done

  # Check if we have any branches to show
  if [[ ! -s "$tmpfile" ]]; then
    echo "No branches found for cleanup."
    rm -f "$tmpfile"
    return 0
  fi

  echo "Select branches to delete (Tab to select multiple, Enter to confirm):"
  echo ""

  # Use fzf to select branches
  local selected=$(cat "$tmpfile" | fzf --multi --ansi)

  rm -f "$tmpfile"

  if [[ -z "$selected" ]]; then
    echo "No branches selected."
    return 0
  fi

  # Extract branch names and delete
  echo ""
  echo "Selected branches to delete:"
  echo "$selected" | while read -r line; do
    local branch=$(echo "$line" | awk '{print $2}')
    echo "  - $branch"
  done

  echo ""
  echo -n "Proceed with deletion? [y/N] "
  read -r confirm

  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Cancelled."
    return 0
  fi

  echo "$selected" | while read -r line; do
    local branch=$(echo "$line" | awk '{print $2}')
    echo -n "Deleting $branch... "
    if git branch -D "$branch" 2>/dev/null; then
      echo "✓"
    else
      echo "✗ (failed)"
    fi
  done
}

alias gitClean='git_clean_branches'
