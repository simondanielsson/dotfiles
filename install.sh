#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/simondanielsson/dotfiles.git"
DOTFILES_DIR="$HOME/.config"
NVIM_VERSION="v0.11.6"
NODE_MAJOR=22

# Prevent interactive prompts from apt (e.g. tzdata timezone selection)
export DEBIAN_FRONTEND=noninteractive

# ─── Helpers ────────────────────────────────────────────────────────────────
info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[OK]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[ERR]\033[0m   %s\n' "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  DEB_ARCH="amd64"; NVIM_ARCH="x86_64" ;;
  aarch64) DEB_ARCH="arm64"; NVIM_ARCH="arm64" ;;
  armv7l)  DEB_ARCH="armhf"; NVIM_ARCH="armv7l" ;;
  *) err "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# System packages
info "Updating apt and installing system packages..."
sudo ln -fs /usr/share/zoneinfo/UTC /etc/localtime
sudo apt-get update -qq
sudo apt-get install -y -qq \
  git curl wget unzip build-essential \
  zsh tmux \
  ripgrep fd-find bat fzf \
  python3 python3-pip python3-venv \
  cmake gettext \
  fontconfig \
  gpg \
  ncurses-term # provides tmux-256color terminfo for truecolor support

if command_exists batcat && ! command_exists bat; then
  sudo ln -sf "$(which batcat)" /usr/local/bin/bat
  ok "Symlinked batcat → bat"
fi

if command_exists fdfind && ! command_exists fd; then
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  ok "Symlinked fdfind → fd"
fi

ok "System packages installed"

# We don't actually need node in most cases, just for some LSPs/nvim pluings
# if ! command_exists node; then
#   info "Installing Node.js ${NODE_MAJOR}.x..."
#   curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
#   sudo apt-get install -y -qq nodejs
#   ok "Node.js $(node --version) installed"
# else
#   ok "Node.js already installed ($(node --version))"
# fi

if ! command_exists eza; then
  info "Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq eza
  ok "eza installed"
else
  ok "eza already installed"
fi

if ! command_exists delta; then
  info "Installing git-delta..."
  DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  DELTA_DEB="git-delta_${DELTA_VERSION}_${DEB_ARCH}.deb"
  wget -q "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_DEB}" -O "/tmp/${DELTA_DEB}"
  sudo dpkg -i "/tmp/${DELTA_DEB}"
  rm -f "/tmp/${DELTA_DEB}"
  ok "delta ${DELTA_VERSION} installed"
else
  ok "delta already installed"
fi

# Nerd fonts
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list 2>/dev/null | grep -qi "Agave"; then
  info "Installing Agave Nerd Font..."
  mkdir -p "$FONT_DIR"
  FONT_ZIP="/tmp/AgaveNerdFont.zip"
  wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Agave.zip" -O "$FONT_ZIP"
  unzip -o -q "$FONT_ZIP" -d "$FONT_DIR"
  rm -f "$FONT_ZIP"
  fc-cache -f "$FONT_DIR" 2>/dev/null || true
  ok "Agave Nerd Font installed"
else
  ok "Agave Nerd Font already installed"
fi

# ─── uv (Python package manager) ────────────────────────────────────────────
if ! command_exists uv; then
  info "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ok "uv installed"
else
  ok "uv already installed"
fi

NVIM_INSTALL_DIR="$HOME/nvim-0.11"
if [ ! -d "$NVIM_INSTALL_DIR" ]; then
  info "Installing Neovim ${NVIM_VERSION}..."
  NVIM_TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
  NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TARBALL}"
  info "  Downloading ${NVIM_URL}"
  if ! wget "${NVIM_URL}" -O "/tmp/${NVIM_TARBALL}"; then
    err "Failed to download Neovim from ${NVIM_URL}"
    exit 1
  fi
  mkdir -p "$NVIM_INSTALL_DIR"
  tar -xzf "/tmp/${NVIM_TARBALL}" --strip-components=1 -C "$NVIM_INSTALL_DIR"
  rm -f "/tmp/${NVIM_TARBALL}"
  ok "Neovim installed to ${NVIM_INSTALL_DIR}"
else
  ok "Neovim already present at ${NVIM_INSTALL_DIR}"
fi

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  info "Cloning dotfiles into ${DOTFILES_DIR}..."
  # Back up existing ~/.config if it exists but isn't the dotfiles repo
  if [ -d "$DOTFILES_DIR" ]; then
    warn "${DOTFILES_DIR} exists but is not the dotfiles repo — backing up to ${DOTFILES_DIR}.bak"
    mv "$DOTFILES_DIR" "${DOTFILES_DIR}.bak"
  fi
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  ok "Dotfiles cloned"
else
  ok "Dotfiles repo already present at ${DOTFILES_DIR}"
fi

info "Creating symlinks..."
symlink() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    warn "Backing up existing ${dst} → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -s "$src" "$dst"
  ok "  ${dst} → ${src}"
}
symlink "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.p10k.zsh"  "$HOME/.p10k.zsh"
symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh installed"
else
  ok "Oh My Zsh already installed"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
  ok "Powerlevel10k installed"
fi

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  ok "zsh-autosuggestions installed"
fi

# zsh-bat
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]; then
  info "Installing zsh-bat..."
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
  ok "zsh-bat installed"
fi

# Bat theme
BAT_THEMES_DIR="$(bat --config-dir 2>/dev/null || echo "$HOME/.config/bat")/themes"
if [ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]; then
  info "Downloading bat Catppuccin Mocha theme..."
  mkdir -p "$BAT_THEMES_DIR"
  wget -q "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" \
    -O "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme"
  bat cache --build 2>/dev/null || true
  ok "bat theme installed"
else
  ok "bat theme already present"
fi

# Tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed — press prefix + I inside tmux to install plugins"
else
  ok "TPM already installed"
fi

# Set default shell to zsh
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  sudo chsh -s "$ZSH_PATH" "$(whoami)" 2>/dev/null || chsh -s "$ZSH_PATH" || true
  ok "Default shell set to zsh (takes effect on next login)"
else
  ok "zsh is already the default shell"
fi

echo ""
info "=========================================="
info "  Bootstrap complete!"
info "=========================================="
echo ""
info "Post-install steps:"
info "  1. Log out and back in (or run 'zsh') to start using your new shell"
info "  2. Open tmux and press C-a + I to install tmux plugins"
info "  3. Open nvim — Lazy will auto-install plugins on first launch"
info "  4. Run :MasonInstallAll in nvim to install LSP servers"
echo ""
info "Note: .zshenv was NOT symlinked (it contains macOS-specific config)."
info "If you need pyenv or other PATH entries, add them to ~/.zshenv manually."
echo ""
