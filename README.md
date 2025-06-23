# Dotfiles

Modern development environment for Ubuntu Linux. Terminal-first workflow with seamless integration between tmux, Neovim, and shell.

## Features

**Terminal Environment**
- Zsh with Oh My Zsh, syntax highlighting, and autosuggestions
- Tmux with Tokyo Night theme and vim navigation
- Alacritty terminal with multiple theme options
- Modern CLI tools: `eza`, `bat`, `ripgrep`, `zoxide`, `fzf`

**Development Tools**  
- PHP 8.3 with essential extensions
- Go, Rust, and Node.js (via NVM)
- Docker with user configuration
- Neovim (nightly) with LazyVim
- Project session management with tmuxp

**System Optimizations**
- Ubuntu debloating and service optimization
- 6GB swap file with zswap compression
- Memory management tuning
- GNOME shortcuts and dark theme

**Applications**
- 1Password, Google Chrome, Ghostty terminal
- Screenshot tool (Flameshot) with Print key binding
- Workspace navigation (Super+1-6)

## Installation

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/CaioDGallo/dotfiles/HEAD/setup-fresh-ubuntu.sh)"
```

Reboot after installation for full effect.

## Configuration Management

Uses GNU Stow for symlink management:

```bash
stow zsh      # Install shell config
stow tmux     # Install tmux config  
stow lazyvim  # Install Neovim config
```

## Key Aliases

```bash
ll            # Enhanced ls with git status
ff            # fzf with bat preview
dpp           # Pretty docker ps
tmp <project> # Load tmux project session
```

## License

MIT