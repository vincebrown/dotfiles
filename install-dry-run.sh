#!/usr/bin/env bash

set -e

echo "🔍 DRY RUN - No changes will be made"
echo "===================================="
echo ""
echo "🚀 Installing dotfiles..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ -f /etc/arch-release ]]; then
  OS="arch"
else
  echo "❌ Unsupported OS: $OSTYPE"
  exit 1
fi

echo "📦 Detected OS: $OS"

# Install packages based on OS
case $OS in
macos)
  if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew not found. Please install from https://brew.sh"
    exit 1
  fi
  echo ""
  echo "📦 Would run: brew bundle"
  echo "   Checking what would be installed..."
  brew bundle check || echo "   Some packages would be installed/updated"
  ;;
arch)
  echo ""
  echo "📦 Would run: sudo pacman -S --needed $(cat packages/arch.txt)"
  if [[ ! -f packages/arch.txt ]]; then
    echo "❌ packages/arch.txt not found"
    exit 1
  fi
  ;;
esac

# Check TPM
echo ""
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
  echo "📦 Would install TPM (Tmux Plugin Manager) to:"
  echo "   $HOME/.config/tmux/plugins/tpm"
else
  echo "✅ TPM already installed at:"
  echo "   $HOME/.config/tmux/plugins/tpm"
fi

# Stow configurations
echo ""
echo "🔗 Would create symlinks with stow..."
echo ""

# Get list of all directories (excluding hidden dirs and non-config dirs)
for dir in */; do
  dir=${dir%/} # Remove trailing slash

  # Skip non-config directories
  if [[ "$dir" == "packages" ]]; then
    continue
  fi

  echo "  → Would stow: $dir"
  
  # Use --no to simulate what would happen
  echo "     Running: stow --restow --no -t \"$HOME\" \"$dir\""
  stow --restow --no -t "$HOME" "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
  
  # Check current symlink status
  if [[ -L "$HOME/.config/$dir" ]] || [[ -L "$HOME/.$dir" ]]; then
    echo "     ✅ Already symlinked"
  fi
  echo ""
done

echo "===================================="
echo "✅ Dry run complete!"
echo ""
echo "This showed what would happen if you ran ./install.sh"
echo "No actual changes were made to your system."
