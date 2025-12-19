# Dotfiles

My personal configuration files for macOS and Linux development environments.

## Quick Setup

Clone this repository:

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the install script:

```bash
./install.sh
```

The script will:
- Detect your OS (macOS or Arch Linux)
- Install all required packages
- Set up tmux plugin manager (TPM)
- Create symlinks for all configurations using stow

After installation:
1. Restart your shell: `exec $SHELL`
2. Open tmux and press `Ctrl+a` then `I` to install tmux plugins

## Manual Setup

### macOS

Install dependencies using Homebrew:

```bash
brew bundle
```

### Arch Linux

Install dependencies using pacman:

```bash
sudo pacman -S --needed $(cat packages/arch.txt)
```

Note: `sesh` may need to be installed from AUR

### Symlink Configurations

Use stow to symlink configurations:

```bash
# Install all configurations
stow */

# Or install specific configurations
stow -t "$HOME" nvim
stow -t "$HOME" zsh
stow -t "$HOME" tmux
```

## Configurations Included

- **aerospace** - Window manager configuration
- **bat** - Syntax highlighting for cat command
- **borders** - Window border styling
- **ghostty** - Terminal emulator settings
- **nvim** - Neovim editor configuration
- **sketchybar** - macOS menu bar replacement
- **starship** - Cross-shell prompt
- **tmux** - Terminal multiplexer configuration
- **yazi** - Terminal file manager
- **zsh** - Shell configuration and aliases
