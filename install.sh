#!/usr/bin/env bash

set -e

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
  echo "📦 Installing packages via Homebrew..."
  brew bundle
  ;;
arch)
  echo "📦 Installing packages via pacman..."
  if [[ ! -f packages/arch.txt ]]; then
    echo "❌ packages/arch.txt not found"
    exit 1
  fi
  sudo pacman -S --needed $(cat packages/arch.txt)
  ;;
esac

# Install TPM for tmux if not present
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
  echo "📦 Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm \
    "$HOME/.config/tmux/plugins/tpm"
fi

# Stow configurations
echo "🔗 Creating symlinks with stow..."

# Get list of all directories (excluding hidden dirs and non-config dirs)
for dir in */; do
  dir=${dir%/} # Remove trailing slash

  # Skip non-config directories
  if [[ "$dir" == "packages" ]]; then
    continue
  fi

  echo "  → Stowing $dir"
  # Use --restow to handle already-stowed packages safely
  # --adopt would copy existing files into the stow package (we don't want this)
  stow --restow -t "$HOME" "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
done

echo "✅ Dotfiles installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your shell or run: exec \$SHELL"
echo "  2. Open tmux and press 'prefix + I' to install tmux plugins"
echo "     (prefix is Ctrl+a)"
