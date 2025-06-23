# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for Ubuntu Linux development environments, using GNU Stow for symlink management. The setup focuses on modern CLI tools, terminal-based development workflow, and seamless integration between tmux, Neovim, and shell environments.

## Installation and Setup Commands

### Fresh System Setup
```bash
# One-command installation for fresh Ubuntu systems
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/CaioDGallo/dotfiles/HEAD/setup-fresh-ubuntu.sh)"
```

### Stow Management
```bash
# Install specific configurations
stow <app-name>  # e.g., stow zsh, stow tmux, stow alacritty

# Remove configurations
stow -D <app-name>

# Reinstall configurations
stow -R <app-name>
```

### Common Development Commands
```bash
# Tmux session management
tmn <session-name>     # Create new session
tma <session-name>     # Attach to session (create if doesn't exist)
tms <session-name>     # Switch to session
tml                    # List sessions
tmp <project>          # Load tmuxp project session

# File navigation and management
ll                     # Enhanced ls with eza (shows git status, icons)
ff                     # fzf with bat preview
ffn                    # Open selected files in nvim via fzf

# Docker workflow
dpp                    # Pretty docker ps output
lzd                    # Open lazydocker
```

## Architecture and Structure

### Configuration Organization
Each application has its own directory that mirrors the home directory structure:
- `zsh/` - Shell configuration with extensive aliases and modern tool integrations
- `tmux/` - Terminal multiplexer with Tokyo Night theme and vim navigation
- `tmuxp/` - Project-specific tmux session templates
- `alacritty/` - Terminal emulator with multiple theme options
- `lazyvim/` - LazyVim configuration
- `nvim/` - Alternative Neovim setup (Kickstart-based)
- `vscode/` - VSCode profile exports

### Key Integration Points
- **Tmux + Neovim**: Seamless pane navigation via vim-tmux-navigator
- **Shell Integration**: Modern Rust-based CLI tools (eza, bat, ripgrep, zoxide, fzf)
- **Theme Consistency**: Tokyo Night theme across tmux, Alacritty, and Neovim
- **Session Management**: tmuxp templates for different projects (orch-go, orch-hyperf, sharktank)

### Development Environment
Configured for full-stack development with:
- **Languages**: PHP 8.3, Go, Rust, Node.js (via NVM), TypeScript, Lua
- **Tools**: Docker, Git, Neovim, Tmux
- **Modern CLI replacements**: eza (ls), bat (cat), ripgrep (grep), zoxide (cd), xh (curl)

## Modification Guidelines

### Adding New Configurations
1. Create new directory with app name
2. Mirror home directory structure inside
3. Place config files in appropriate subdirectories
4. Test with `stow <app-name>`

### Modifying Existing Configs
- Always test changes in isolation before committing
- Maintain theme consistency (Tokyo Night)
- Preserve vim-tmux-navigator integration patterns
- Keep alias naming conventions in zsh config

### Setup Script Updates
When modifying `setup-fresh-ubuntu.sh`:
- Test on clean Ubuntu system
- Maintain dependency installation order
- Preserve stow integration at the end
- Update README.md dependencies list if needed