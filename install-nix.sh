#!/usr/bin/env bash
# install-nix.sh — no-sudo bootstrap for shared HPC/Slurm nodes via Nix
# Requires: curl, git (usually pre-installed on clusters)
set -euo pipefail

DOTFILES_REPO="https://github.com/simondanielsson/dotfiles.git"
DOTFILES_DIR="$HOME/.config"
NVIM_VERSION="v0.11.6"
NODE_MAJOR=22

# ─── Helpers ────────────────────────────────────────────────────────────────
info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[OK]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[ERR]\033[0m   %s\n' "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  NVIM_ARCH="x86_64" ;;
  aarch64) NVIM_ARCH="arm64" ;;
  armv7l)  NVIM_ARCH="armv7l" ;;
  *) err "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# ─── Nix ─────────────────────────────────────────────────────────────────────
# Install single-user Nix (no daemon, no root required).
# On many clusters /nix already exists as a shared store — the installer detects
# this automatically and skips re-creation.
if ! command_exists nix; then
  info "Installing Nix (single-user, no root)..."
  curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  ok "Nix installed"
fi

# Source nix into the current shell so subsequent nix commands are available.
NIX_SH="$HOME/.nix-profile/etc/profile.d/nix.sh"
if [ -f "$NIX_SH" ]; then
  # shellcheck source=/dev/null
  source "$NIX_SH"
else
  err "Could not find nix.sh at ${NIX_SH}. Nix installation may have failed."
  exit 1
fi

ok "Nix $(nix --version) is active"

# Ensure nix is sourced in future zsh sessions.
# The Nix installer only adds itself to ~/.bash_profile; on clusters where the
# login shell is zsh (or bash exec's into zsh) ~/.zshenv is the right place.
NIX_ZSHENV_MARKER="# nix — added by install-nix.sh"
if ! grep -qF "$NIX_ZSHENV_MARKER" "$HOME/.zshenv" 2>/dev/null; then
  printf '\n%s\n[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"\n' \
    "$NIX_ZSHENV_MARKER" >> "$HOME/.zshenv"
  ok "Added nix sourcing to ~/.zshenv"
fi

# Enable nix-command and flakes (required for `nix profile add`).
# Writing to ~/.config/nix/nix.conf is user-local and needs no root.
NIX_CONF="$HOME/.config/nix/nix.conf"
mkdir -p "$(dirname "$NIX_CONF")"
if ! grep -q "nix-command" "$NIX_CONF" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
  ok "Enabled nix-command and flakes in ${NIX_CONF}"
fi

# ─── System packages via nix profile ─────────────────────────────────────────
# `nix profile add` installs into ~/.nix-profile (user-local, no root).
# We install each package only if its binary is not already on PATH.

nix_install() {
  local pkg="$1" bin="${2:-$1}"
  if command_exists "$bin"; then
    ok "${bin} already installed"
  else
    info "Installing ${pkg}..."
    nix profile add "nixpkgs#${pkg}"
    ok "${pkg} installed"
  fi
}

# Core utilities (replaces apt block)
nix_install git
nix_install curl
nix_install wget
nix_install unzip
nix_install zsh
nix_install tmux
nix_install ripgrep rg
nix_install fd
nix_install bat
nix_install fzf
nix_install eza
nix_install delta
nix_install cmake
nix_install gettext
nix_install fontconfig fc-cache
nix_install python3 python3

# Node.js (needed by some LSPs / nvim plugins)
nix_install "nodejs_${NODE_MAJOR}" node

# ─── uv (Python package manager) ─────────────────────────────────────────────
if ! command_exists uv; then
  info "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # shellcheck source=/dev/null
  source "$HOME/.local/bin/env"
  ok "uv installed"
else
  ok "uv already installed ($(uv --version))"
fi

# ─── Neovim ───────────────────────────────────────────────────────────────────
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

# ─── Nerd fonts ───────────────────────────────────────────────────────────────
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

# ─── Dotfiles ─────────────────────────────────────────────────────────────────
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  info "Cloning dotfiles into ${DOTFILES_DIR}..."
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

# ─── Oh My Zsh + plugins ─────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh installed"
else
  ok "Oh My Zsh already installed"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
  ok "Powerlevel10k installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  ok "zsh-autosuggestions installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]; then
  info "Installing zsh-bat..."
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
  ok "zsh-bat installed"
fi

# ─── bat theme ───────────────────────────────────────────────────────────────
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

# ─── TPM ─────────────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed"
else
  ok "TPM already installed"
fi

# ─── Default shell ────────────────────────────────────────────────────────────
# chsh requires root on most clusters.
# zsh is launched for interactive sessions via `RemoteCommand zsh -l` in the
# local ~/.ssh/config — no changes to the login shell are needed here.
info "Default shell: bash (login shell unchanged — zsh launched via SSH RemoteCommand)"

echo ""
info "=========================================="
info "  Bootstrap complete!"
info "=========================================="
echo ""
info "Post-install steps:"
info "  1. Ensure your local ~/.ssh/config has RequestTTY+RemoteCommand for cluster hosts"
info "  2. Open tmux and press C-a + I to install tmux plugins"
info "  3. Open nvim — Lazy will auto-install plugins on first launch"
info "  4. Run :MasonInstallAll in nvim to install LSP servers"
echo ""
info "Note: .zshenv was NOT symlinked (it contains macOS-specific config)."
info "If you need pyenv or other PATH entries, add them to ~/.zshenv manually."
echo ""
info "Nix tip: to garbage-collect old package generations run:"
info "  nix profile wipe-history --older-than 7d && nix store gc"
echo ""
