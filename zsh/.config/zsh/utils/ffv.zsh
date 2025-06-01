#!/bin/zsh

#-----------------------------------------------------------------------------
#       █▀▀ ▄▀█ █▀ ▀█▀ █▀▀ █ █   █▀▀ █▀   █░█ █▀▀ █▀█ █▄▄ █▀█ █▀ █▀▀
#       █▀  █▀█ ▄█  █  █▀  █ █▄▄ ██▄ ▄█   ▀▄▀ ██▄ █▀▄ █▄█ █▄█ ▄█ ██▄
#
# Usage:        ffv [path file or folder]
#
# Arguments:    --help : prints usage info
#               -h : prints usage info
#
# Description:  ZSH script which is a combination of 'mkdir' and 'touch'.
#               It can create directory structures and files simultaneously
#               and lists the created objects using eza.
#
# Dependencies: zsh, eza
#
# Examples:     - Single file:
#                   ffv file
#               - Single directory:
#                   ffv dir/
#               - Multiple files:
#                   ffv file1 file2 file3
#               - Multiple directories:
#                   ffv dir1/ dir2/ dir3/
#               - File in a directory
#                   ffv dir/file
#               - Directory in a directory
#                   ffv dir1/dir2/
#               - Multiple files in multiple directories
#                   ffv dir1/dir2/file1 dir3/file2
#               - If your shell supports brace expansion e.g bash, zsh, fish
#                   ffv dir1/{dir2/{file1,file2}.txt,dir3/file3.txt}
#-----------------------------------------------------------------------------

ffv() {
  if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    echo "Usage: ffv [path file or folder]"
    echo "For more information, run: ffv --help"
    return 1
  fi

  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage:    ffv [path file or folder]"
    echo "Examples: - Single file:
              ffv file
          - Single directory:
              ffv dir/
          - Multiple files:
              ffv file1 file2 file3
          - Multiple directories:
              ffv dir1/ dir2/ dir3/
          - File in a directory
              ffv dir/file
          - Directory in a directory
              ffv dir1/dir2/
          - Multiple files in multiple directories
              ffv dir1/dir2/file1 dir3/file2
          - If your shell supports brace expansion e.g bash, zsh, fish
              ffv dir1/{dir2/{file1,file2}.txt,dir3/file3.txt}"
    return 0
  fi

  # Create directory structures and files
  for item_path in "$@"; do
    if [[ "$item_path" == */ ]]; then
      mkdir -p "$item_path"
    fi
    parent_dir=$(dirname "$item_path")
    if [[ -n "$parent_dir" ]] && [[ ! -d "$parent_dir" ]]; then
      mkdir -p "$parent_dir"
    fi
    touch "$item_path"
  done

  # Get the created files and folder names and print them
  local unique_names=()
  for arg in "$@"; do
    name="${arg%%/*}"
    if [[ -n "$name" ]]; then
      if [[ ! " ${unique_names[*]} " =~ $name ]]; then
        unique_names+=("$name")
      fi
    fi
  done

  # Use eza for displaying
  if command -v eza &>/dev/null; then
    eza -aU --no-user --no-filesize --no-permissions --tree --icons \
      --group-directories-first "${unique_names[@]}"
  else
    ls -ARl --color=always "${unique_names[@]}"
  fi
}
