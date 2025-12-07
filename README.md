# Dotfiles

My personal configuration files for macOS development environment.

## Setup

Clone this repository to your home directory:

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install dependencies using Homebrew:

```bash
brew bundle
```

Use stow to symlink configurations:

```bash
# Install all configurations
stow */

# Or install specific configurations
stow -t="$HOME" nvim
stow -t="$HOME" zsh
stow -t="$HOME" ghostty
```

## Configurations Included

- **aerospace** - Window manager configuration
- **bat** - Syntax highlighting for cat command
- **borders** - Window border styling
- **ghostty** - Terminal emulator settings
- **nvim** - Neovim editor configuration
- **sketchybar** - macOS menu bar replacement
- **starship** - Cross-shell prompt
- **yazi** - Terminal file manager
- **zsh** - Shell configuration and aliases
