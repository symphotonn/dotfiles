#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ----------------------------
# Detect OS
detect_os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
ARCH=$(uname -m)

echo "=== Dotfiles Setup (OS: $OS, Arch: $ARCH) ==="

# ----------------------------
# Detect proxy (Clash on WSL uses mirrored networking)
PROXY=""
if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "[WSL detected]"
  if curl -so /dev/null --connect-timeout 2 http://127.0.0.1:7897 2>/dev/null; then
    PROXY="http://127.0.0.1:7897"
    echo "Clash proxy detected at $PROXY"
  fi
fi

# ----------------------------
# Install packages
install_packages() {
  case "$OS" in
    ubuntu|debian)
      if [[ -n "$PROXY" ]]; then
        echo "Configuring apt proxy..."
        echo "Acquire::http::Proxy \"$PROXY\";
Acquire::https::Proxy \"$PROXY\";" | sudo tee /etc/apt/apt.conf.d/proxy.conf > /dev/null
      fi
      sudo apt update
      sudo apt install -y zsh tmux fzf fd-find bat ripgrep \
        zsh-autosuggestions zsh-syntax-highlighting gh git curl
      ;;
    fedora)
      sudo dnf install -y zsh tmux fzf fd-find bat ripgrep \
        zsh-autosuggestions zsh-syntax-highlighting gh git curl
      ;;
    arch|manjaro)
      sudo pacman -Syu --noconfirm zsh tmux fzf fd bat ripgrep \
        zsh-autosuggestions zsh-syntax-highlighting github-cli git curl
      ;;
    macos)
      if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew install zsh tmux fzf fd bat ripgrep eza zoxide starship \
        zsh-autosuggestions zsh-syntax-highlighting gh git
      ;;
    *)
      echo "Unknown OS: $OS — install packages manually"
      echo "Needed: zsh tmux fzf fd bat ripgrep gh git curl"
      return 1
      ;;
  esac
}

echo "Installing packages..."
install_packages

# ----------------------------
# Install tools to ~/.local/bin (skip on macOS, brew handles it)
mkdir -p ~/.local/bin

if [[ "$OS" != "macos" ]]; then
  # Determine binary suffix
  case "$ARCH" in
    x86_64)  TARGET="x86_64-unknown-linux-musl" ;;
    aarch64) TARGET="aarch64-unknown-linux-musl" ;;
    *)       echo "Unsupported arch: $ARCH"; exit 1 ;;
  esac

  CURL_OPTS=""
  if [[ -n "$PROXY" ]]; then
    CURL_OPTS="-x $PROXY"
  fi

  echo "Installing starship..."
  curl $CURL_OPTS -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin

  echo "Installing eza..."
  EZA_VERSION=$(curl $CURL_OPTS -s https://api.github.com/repos/eza-community/eza/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
  curl $CURL_OPTS -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_${TARGET}.tar.gz"
  tar xf /tmp/eza.tar.gz -C /tmp
  install /tmp/eza ~/.local/bin/
  rm -f /tmp/eza /tmp/eza.tar.gz

  echo "Installing zoxide..."
  curl $CURL_OPTS -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ----------------------------
# Link dotfiles
echo "Linking dotfiles..."

backup_and_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "  Backing up $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  $dst -> $src"
}

backup_and_link "$DOTFILES_DIR/.zshrc" ~/.zshrc
backup_and_link "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config
backup_and_link "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml

# ----------------------------
# Platform-specific zsh plugin paths differ — create shims if needed
ZSH_PLUGINS_DIR="$DOTFILES_DIR/zsh-compat.zsh"
cat > "$ZSH_PLUGINS_DIR" << 'COMPAT'
# Auto-detect zsh plugin paths per platform
for dir in \
  /usr/share/zsh-autosuggestions \
  /usr/share/zsh/plugins/zsh-autosuggestions \
  /opt/homebrew/share/zsh-autosuggestions \
  /usr/local/share/zsh-autosuggestions; do
  [[ -f "$dir/zsh-autosuggestions.zsh" ]] && source "$dir/zsh-autosuggestions.zsh" && break
done

for dir in \
  /usr/share/zsh-syntax-highlighting \
  /usr/share/zsh/plugins/zsh-syntax-highlighting \
  /opt/homebrew/share/zsh-syntax-highlighting \
  /usr/local/share/zsh-syntax-highlighting; do
  [[ -f "$dir/zsh-syntax-highlighting.zsh" ]] && source "$dir/zsh-syntax-highlighting.zsh" && break
done

# fzf keybindings
for dir in \
  /usr/share/doc/fzf/examples \
  /usr/share/fzf \
  /opt/homebrew/opt/fzf/shell \
  /usr/local/opt/fzf/shell; do
  [[ -f "$dir/key-bindings.zsh" ]] && source "$dir/key-bindings.zsh" && break
done

for dir in \
  /usr/share/doc/fzf/examples \
  /usr/share/fzf \
  /opt/homebrew/opt/fzf/shell \
  /usr/local/opt/fzf/shell; do
  [[ -f "$dir/completion.zsh" ]] && source "$dir/completion.zsh" && break
done
COMPAT

# ----------------------------
# Set default shell
if [[ "$SHELL" != *"zsh"* ]]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# ----------------------------
# Git defaults
git config --global core.autocrlf input
git config --global core.eol lf
git config --global init.defaultBranch main

echo ""
echo "=== Done! Restart your terminal or run: exec zsh ==="
