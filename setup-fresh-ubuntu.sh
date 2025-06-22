#!/bin/bash

# Development Environment Setup Script
# Simple setup for PHP (Hyperf) and GoLang development

set -e  # Exit on any error

echo "🚀 Starting development environment setup..."
echo "This will install: PHP 8.3, Docker, development tools, and configure dotfiles"
echo ""

# Helper function for progress feedback
print_step() {
    echo ""
    echo "📦 $1..."
}

# Clone dotfiles first
print_step "Cloning dotfiles"
cd ~
if [ ! -d "dotfiles" ]; then
    git clone https://github.com/CaioDGallo/dotfiles.git
else
    echo "dotfiles directory already exists, skipping clone"
fi

# System update and basic tools
print_step "Updating system and installing basic tools"
sudo apt update
sudo apt install -y curl wget gpg ca-certificates

# Install PHP 8.3 with extensions
print_step "Installing PHP 8.3 with extensions"
sudo apt install -y --no-install-recommends php8.3 php8.3-cli php8.3-common \
    php8.3-mysql php8.3-zip php8.3-gd php8.3-mbstring php8.3-curl \
    php8.3-xml php8.3-bcmath

# Install Docker
print_step "Installing Docker"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker for current user
sudo groupadd docker 2>/dev/null || true  # Don't fail if group exists
sudo usermod -aG docker $USER

# Install development tools
print_step "Installing development tools"
sudo apt install -y ripgrep fd-find zsh bat tmux tmuxp stow rust-coreutils \
    lua5.4 luarocks

# Install mise (language version manager)
print_step "Installing mise"
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | \
    sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise

# Setup mise shell integration
echo 'eval "$(mise activate bash)"' >> ~/.bashrc

# Install programming languages via mise
print_step "Installing programming languages"
mise use -g go@1.24
mise use -g rust@latest
mise use -g node@22
mise use -g python@3.11
mise use -g java@openjdk-21

# Install Rust tools (only after Rust is installed)
print_step "Installing Rust tools"
cargo install eza bob zoxide xh du-dust yazi-cli yazi-fm

# Install fzf
print_step "Installing fzf"
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-zsh  # Avoid interactive prompts
fi

# Setup binary symlinks
print_step "Setting up binary symlinks"
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd
ln -sf /usr/bin/batcat ~/.local/bin/bat

# Install Oh My Zsh
print_step "Installing Oh My Zsh"
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Setup Neovim nightly
print_step "Setting up Neovim nightly"
bob use nightly

# Install Go tools
print_step "Installing Go tools"
go install github.com/jesseduffield/lazydocker@latest
go install github.com/jesseduffield/lazygit@latest

# Setup dotfiles
print_step "Configuring dotfiles"
cd ~/dotfiles
rm -rf ~/.config/nvim ~/.zshrc 2>/dev/null || true
stow lazyvim
stow tmux
stow tmuxp

# Install 1Password
print_step "Installing 1Password"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
    sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update
sudo apt install -y 1password

# Install Ghostty terminal
print_step "Installing Ghostty terminal"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

# Install Google Chrome (using modern method)
print_step "Installing Google Chrome"
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome.deb
rm /tmp/google-chrome.deb

# Verification
print_step "Verifying installations"
echo "✅ PHP version: $(php --version | head -n1)"
echo "✅ Docker version: $(docker --version)"
echo "✅ Go version: $(go version)"
echo "✅ Node version: $(node --version)"
echo "✅ Rust version: $(rustc --version)"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "⚠️  IMPORTANT: You need to log out and log back in for Docker group changes to take effect"
echo "💡 After logging back in, test Docker with: docker run hello-world"
echo "🔧 To use the new shell setup, run: exec zsh"
echo ""
echo "📋 Quick verification commands:"
echo "  mise list          # Show installed languages"
echo "  docker --version   # Test Docker"
echo "  php --version      # Test PHP"
echo "  go version         # Test Go"