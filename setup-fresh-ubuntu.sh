#!/bin/bash

# Development Environment Setup Script

set -e # Exit on any error

echo "🚀 Starting development environment setup..."
echo "This will install: PHP 8.3, Docker, development tools, and configure dotfiles"
echo ""

# Helper functions for progress feedback
print_step() {
  echo ""
  echo "📦 $1..."
}

print_success() {
  echo "✅ $1"
}

# System update and basic tools
print_step "Updating system and installing basic tools"
sudo apt update
sudo apt install -y curl wget gpg ca-certificates git

# Clone dotfiles first
print_step "Cloning dotfiles"
cd ~
if [ ! -d "dotfiles" ]; then
  git clone https://github.com/CaioDGallo/dotfiles.git
else
  echo "dotfiles directory already exists, skipping clone"
fi

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
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker for current user
sudo groupadd docker 2>/dev/null || true # Don't fail if group exists
sudo usermod -aG docker $USER

# Install development tools
print_step "Installing development tools"
sudo apt install -y ripgrep fd-find zsh bat tmux tmuxp stow rust-coreutils \
  lua5.4 luarocks flameshot

# Make zsh the default shell
sudo chsh -s $(which zsh)

# Setup dotfiles
print_step "Configuring dotfiles"
cd ~/dotfiles
rm -rf ~/.config/nvim ~/.zshrc 2>/dev/null || true
stow zsh
stow lazyvim
stow tmux
stow tmuxp
cd ..

# Install programming languages
print_step "Installing programming languages"

# Install golang
if command -v go >/dev/null 2>&1; then
  GO_VERSION=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
  echo "Go is already installed (version: $GO_VERSION)"
else
  # Remove previous installation (if exists)
  sudo rm -rf /usr/local/go

  # Download and extract (replace with your architecture if needed)
  cd /tmp
  wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz

  # Add to PATH (add to ~/.profile or ~/.bashrc for persistence)
  export PATH=$PATH:/usr/local/go/bin

  # Verify installation
  go version

  cd ~
fi

# Install Rust
if command -v rustc >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
  RUST_VERSION=$(rustc --version 2>/dev/null | awk '{print $2}')
  print_success "Rust is already installed (version: $RUST_VERSION)"
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source ~/.cargo/env
fi

# Install Node
if command -v node >/dev/null 2>&1; then
  NODE_VERSION=$(node --version 2>/dev/null)
  print_success "Node.js is already installed (version: $NODE_VERSION)"
else
  # Download and install nvm (check for latest version)
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/nvm_completion" ] && \. "$NVM_DIR/nvm_completion"

  # Install latest LTS version (currently 22.x)
  nvm install --lts

  # Use the LTS version
  nvm use --lts

  # Set as default for new shells
  nvm alias default lts/*
fi

# Install Rust tools (only after Rust is installed)
print_step "Installing Rust tools"
cargo install eza zoxide xh du-dust yazi-cli bob-nvim

# Install Atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Install fzf
print_step "Installing fzf"
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --completion --key-bindings --no-update-rc
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

# Install Zsh Syntax Highlighting
if [ ! -d ".oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting directory already exists, skipping clone"
fi

# Install Zsh AutoSuggestions
if [ ! -d ".oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions directory already exists, skipping clone"
fi

# Setup Neovim nightly
print_step "Setting up Neovim nightly"
bob use nightly

# Install 1Password
print_step "Installing 1Password"
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
  sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
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

# Install Obsidian
flatpak install -y flathub md.obsidian.Obsidian

# Install Go tools
print_step "Installing Go tools"
go install github.com/jesseduffield/lazydocker@latest
go install github.com/jesseduffield/lazygit@latest

# Configure GNOME desktop settings
print_step "Setting up GNOME shortcuts and preferences"

# Navigate to workspace 1
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
# Navigate to workspace 2
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
# Navigate to workspace 3
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
# Navigate to workspace 4
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
# Navigate to workspace 5
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
# Navigate to workspace 6
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

# Move window to workspace 1
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
# Move window to workspace 2
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
# Move window to workspace 3
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
# Move window to workspace 4
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
# Move window to workspace 5
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
# Move window to workspace 6
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"

gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

# Favorite apps for dock
apps=(
  "google-chrome.desktop"
  "Ghostty.desktop"
  "WhatsApp.desktop"
  "md.obsidian.Obsidian.desktop"
  "1password.desktop"
  "org.gnome.Settings.desktop"
)

# Array to hold installed favorite apps
installed_apps=()

# Directory where .desktop files are typically stored
desktop_dirs=(
  "/var/lib/flatpak/exports/share/applications"
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

# Check if a .desktop file exists for each app
for app in "${apps[@]}"; do
  for dir in "${desktop_dirs[@]}"; do
    if [ -f "$dir/$app" ]; then
      installed_apps+=("$app")
      break
    fi
  done
done

# Convert the array to a format suitable for gsettings
favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set the favorite apps
gsettings set org.gnome.shell favorite-apps "$favorites_list"

# Apply Ubuntu system optimizations
print_step "Applying Ubuntu optimizations"
# Debloat system
sudo apt remove -y aisleriot gnome-mahjongg gnome-mines rhythmbox totem
sudo apt remove -y apport whoopsie ubuntu-report

# Optimize services
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl disable plymouth-quit-wait.service
sudo systemctl disable snapd.service

# Clean system
print_step "Cleaning system packages"
sudo apt autoremove -y && sudo apt autoclean

# Apply SWAP optimizations
print_step "Optimizing swap configuration"
# Configuration
SWAP_SIZE="6G" # Adjust as needed (4G-8G recommended)
SWAPPINESS=10
ENABLE_HIBERNATION=false # Set to true if needed

# Remove default small swap
sudo swapoff /swap.img 2>/dev/null || true
sudo rm -f /swap.img

# Create optimized swap file
echo "Creating ${SWAP_SIZE} swap file..."
sudo fallocate -l "$SWAP_SIZE" /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Configure fstab
sudo cp /etc/fstab /etc/fstab.backup
sudo sed -i '/swap/d' /etc/fstab
echo '/swapfile none swap sw,discard=once 0 0' | sudo tee -a /etc/fstab

# Optimize kernel parameters (consolidated)
sudo tee /etc/sysctl.d/99-swap-optimization.conf <<EOF
vm.swappiness=$SWAPPINESS
vm.vfs_cache_pressure=50
vm.dirty_ratio=15
vm.dirty_background_ratio=5
vm.page-cluster=0
EOF

# Enable zswap (consolidated configuration)
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=zsmalloc zswap.max_pool_percent=80/' /etc/default/grub
sudo update-grub

# Configure hibernation if requested
if [[ "$ENABLE_HIBERNATION" == "true" ]]; then
  echo "Configuring hibernation support..."
  ROOT_UUID=$(findmnt -n -o UUID /)
  SWAP_OFFSET=$(sudo filefrag -v /swapfile | awk 'NR==4{print $4}' | cut -d. -f1)

  sudo sed -i "s/zswap.max_pool_percent=80/& resume=UUID=$ROOT_UUID resume_offset=$SWAP_OFFSET/" /etc/default/grub
  echo "RESUME=UUID=$ROOT_UUID resume_offset=$SWAP_OFFSET" | sudo tee /etc/initramfs-tools/conf.d/resume
  sudo update-grub
  sudo update-initramfs -u
fi

# Apply sysctl changes
sudo sysctl -p /etc/sysctl.d/99-swap-optimization.conf

print_success "Swap optimization complete! Current configuration:"
sudo swapon --show
free -h
echo "Note: Reboot required for all changes to take effect."

# Apply color scheme and theme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

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
echo "  docker --version   # Test Docker"
echo "  php --version      # Test PHP"
echo "  go version         # Test Go"
echo ""
echo "⚠️⚠️⚠️ Remember to run: source ~/.zshrc"
