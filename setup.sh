#!/bin/bash
set -e

echo "=== WSL Dotfiles Setup ==="

# ----------------------------
# 1. Configure apt proxy (for Clash mirrored networking)
echo "Setting up apt proxy..."
echo 'Acquire::http::Proxy "http://127.0.0.1:7897";
Acquire::https::Proxy "http://127.0.0.1:7897";' | sudo tee /etc/apt/apt.conf.d/proxy.conf > /dev/null

# ----------------------------
# 2. Install apt packages
echo "Installing packages..."
sudo apt update
sudo apt install -y zsh fzf fd-find bat ripgrep zsh-autosuggestions zsh-syntax-highlighting gh

# ----------------------------
# 3. Install tools to ~/.local/bin
mkdir -p ~/.local/bin

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin

echo "Installing eza..."
EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/eza.tar.gz -C /tmp
install /tmp/eza ~/.local/bin/
rm -f /tmp/eza /tmp/eza.tar.gz

echo "Installing zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# ----------------------------
# 4. Link dotfiles
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Linking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml

# ----------------------------
# 5. Set default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# ----------------------------
# 6. Git defaults
git config --global core.autocrlf input
git config --global core.eol lf

echo ""
echo "=== Done! Restart your terminal or run: exec zsh ==="
