#!/usr/bin/env bash
# install-spack.sh — no-sudo bootstrap for HPC/Lustre cluster nodes via Spack
# Requires only: bash, curl or wget, git (almost always pre-installed on clusters)
# Does NOT require /nix, sudo, or any pre-existing package manager.
set -euo pipefail

DOTFILES_REPO="https://github.com/simondanielsson/dotfiles.git"
DOTFILES_DIR="$HOME/.config"
NVIM_VERSION="v0.11.6"
NODE_MAJOR=22
SPACK_DIR="$HOME/.spack-install"

# ─── Helpers ─────────────────────────────────────────────────────────────────
info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[OK]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[ERR]\033[0m   %s\n' "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

# Prefer wget if available, fall back to curl
fetch() {
  local url="$1" dest="$2"
  if command_exists wget; then
    wget -q "$url" -O "$dest"
  else
    curl -fsSL "$url" -o "$dest"
  fi
}

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  NVIM_ARCH="x86_64" ;;
  aarch64) NVIM_ARCH="arm64" ;;
  armv7l)  NVIM_ARCH="armv7l" ;;
  *) err "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# ─── Spack ───────────────────────────────────────────────────────────────────
if [ ! -d "$SPACK_DIR" ]; then
  info "Cloning Spack into ${SPACK_DIR}..."
  git clone --depth=1 --branch=releases/v0.23 https://github.com/spack/spack.git "$SPACK_DIR"
  ok "Spack cloned"
else
  ok "Spack already present at ${SPACK_DIR}"
fi

# Source spack into the current shell
source "$SPACK_DIR/share/spack/setup-env.sh"
ok "Spack $(spack --version) is active"

# Persist spack activation in shell rc files
SPACK_SOURCE="source \"${SPACK_DIR}/share/spack/setup-env.sh\""
SPACK_MARKER="# spack — added by install-spack.sh"

for RC in "$HOME/.zshenv" "$HOME/.bashrc"; do
  touch "$RC" 2>/dev/null || { warn "Cannot create ${RC} — skipping"; continue; }
  if ! grep -qF "$SPACK_MARKER" "$RC" 2>/dev/null; then
    printf '\n%s\n%s\n' "$SPACK_MARKER" "$SPACK_SOURCE" >> "$RC"
    ok "Added spack sourcing to ${RC}"
  fi
done

# Disable zsh compaudit on clusters (LDAP/NIS groups may not be resolvable)
touch "$HOME/.zshenv" 2>/dev/null || true
if ! grep -q "ZSH_DISABLE_COMPFIX" "$HOME/.zshenv" 2>/dev/null; then
  echo 'ZSH_DISABLE_COMPFIX=true' >> "$HOME/.zshenv"
  ok "Set ZSH_DISABLE_COMPFIX=true in ~/.zshenv"
fi

# ─── Spack environment ───────────────────────────────────────────────────────
# Use a named Spack environment so all tools are grouped and easy to rebuild.
# Spack manages the environment in ~/.spack/environments/dotfiles (no path arg needed).
if ! spack env list 2>/dev/null | grep -qE '^\s*dotfiles\s*$'; then
  info "Creating Spack environment 'dotfiles'..."
  spack env create dotfiles
  ok "Spack environment 'dotfiles' created"
else
  ok "Spack environment 'dotfiles' already exists"
fi

spack env activate dotfiles

# Detect system compilers so Spack writes clean compiler config entries.
# Must happen before concretize — avoids a Spack 0.23 bug where the auto-detected
# gcc entry includes a 'languages:=' variant that the spec parser then rejects.
info "Detecting system compilers..."
spack compiler find 2>&1 | grep -v "^$" || true

# ─── Concretize & install packages ───────────────────────────────────────────
# spack_add installs a package only if its binary is not already on PATH.
spack_add() {
  local spec="$1" bin="${2:-}"
  # derive binary name from the package name if not given
  if [ -z "$bin" ]; then
    bin="${spec%%@*}"   # strip version constraint
    bin="${bin%%+*}"    # strip variants
    bin="${bin%% *}"    # strip trailing whitespace / extra specs
  fi

  if command_exists "$bin"; then
    ok "${bin} already on PATH — skipping spack install"
  else
    info "Adding ${spec} to Spack environment..."
    spack add "$spec"
  fi
}

# Core CLI tools
spack_add "git"
spack_add "curl"
spack_add "wget"
spack_add "unzip"
spack_add "zsh"
spack_add "tmux"
spack_add "ripgrep"        "rg"
spack_add "fd"
spack_add "bat"
spack_add "fzf"
spack_add "eza"            "eza"      # may not be in all spack mirrors; fallback below
spack_add "git-delta"      "delta"
spack_add "cmake"
spack_add "gettext"
spack_add "fontconfig"     "fc-cache"
spack_add "python"         "python3"
spack_add "node-js@${NODE_MAJOR}" "node"

info "Concretizing and installing Spack environment (this may take a while on first run)..."
spack concretize 2>&1 | tail -5
spack install --fail-fast 2>&1 | grep -E '^\[|^==> |^Error' || true
ok "Spack packages installed"

# Some tools may not yet be in every Spack mirror; fall back to pre-built binaries.
if ! command_exists eza; then
  warn "eza not available via Spack — downloading pre-built binary..."
  EZA_URL="https://github.com/eza-community/eza/releases/latest/download/eza_${ARCH}-unknown-linux-musl.tar.gz"
  EZA_TMP="/tmp/eza.tar.gz"
  fetch "$EZA_URL" "$EZA_TMP"
  mkdir -p "$HOME/.local/bin"
  tar -xzf "$EZA_TMP" -C "$HOME/.local/bin" eza
  rm -f "$EZA_TMP"
  ok "eza installed to ~/.local/bin"
fi

# ─── uv (Python package manager) ─────────────────────────────────────────────
if ! command_exists uv; then
  info "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # shellcheck source=/dev/null
  [ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
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
  if ! fetch "$NVIM_URL" "/tmp/${NVIM_TARBALL}"; then
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

# Expose nvim on PATH via ~/.local/bin
mkdir -p "$HOME/.local/bin"
if [ ! -e "$HOME/.local/bin/nvim" ]; then
  ln -s "$NVIM_INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
  ok "Symlinked nvim to ~/.local/bin/nvim"
fi

# ─── Ensure ~/.local/bin is on PATH ──────────────────────────────────────────
LOCAL_BIN_SOURCE='export PATH="$HOME/.local/bin:$PATH"'
LOCAL_BIN_MARKER="# local bin — added by install-spack.sh"
for RC in "$HOME/.zshenv" "$HOME/.bashrc"; do
  touch "$RC" 2>/dev/null || { warn "Cannot create ${RC} — skipping"; continue; }
  if ! grep -qF "$LOCAL_BIN_MARKER" "$RC" 2>/dev/null; then
    printf '\n%s\n%s\n' "$LOCAL_BIN_MARKER" "$LOCAL_BIN_SOURCE" >> "$RC"
    ok "Added ~/.local/bin to PATH in ${RC}"
  fi
done
export PATH="$HOME/.local/bin:$PATH"

# ─── Nerd fonts ───────────────────────────────────────────────────────────────
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list 2>/dev/null | grep -qi "Agave"; then
  info "Installing Agave Nerd Font..."
  mkdir -p "$FONT_DIR"
  FONT_ZIP="/tmp/AgaveNerdFont.zip"
  fetch "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Agave.zip" "$FONT_ZIP"
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

# ─── Oh My Zsh + plugins ──────────────────────────────────────────────────────
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
  fetch "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" \
    "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme"
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

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
info "=========================================="
info "  Bootstrap complete!"
info "=========================================="
echo ""
info "Post-install steps:"
info "  1. Source your shell config or open a new session:"
info "       source ~/.zshenv  (zsh)   OR   source ~/.bashrc  (bash)"
info "  2. Open tmux and press C-a + I to install tmux plugins"
info "  3. Open nvim — Lazy will auto-install plugins on first launch"
info "  4. Run :MasonInstallAll in nvim to install LSP servers"
echo ""
info "Spack tips:"
info "  • Activate the env manually: spack env activate dotfiles"
info "  • Add a new package:         spack add <pkg> && spack install"
info "  • Remove a package:          spack remove <pkg> && spack install"
info "  • Garbage-collect old builds: spack gc"
echo ""
info "Note: .zshenv was NOT symlinked (it may contain machine-specific config)."
info "If you need pyenv or other PATH entries, add them to ~/.zshenv manually."
echo ""
