# Neovim 0.11 Configuration

A standalone Neovim 0.11 configuration with no framework dependencies (no NvChad).
Uses the native Neovim 0.11 LSP API, lazy.nvim for plugin management, and a custom
NvChad-inspired Night Owl colorscheme.

## Quick Install (Linux / macOS)

### 1. Install Neovim 0.11

```bash
# Download (adjust URL for your platform — see https://github.com/neovim/neovim/releases)
# Linux x64:
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim

# macOS (Apple Silicon):
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
sudo mv nvim-macos-arm64 /opt/nvim

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="/opt/nvim/bin:$PATH"
```

Verify: `nvim --version` should show `v0.11.x`.

### 2. Install system dependencies

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install -y \
  git curl unzip wget \
  gcc g++ make cmake \
  ripgrep fd-find \
  nodejs npm \
  python3 python3-pip python3-venv \
  xclip  # clipboard support

# macOS (Homebrew)
brew install git curl ripgrep fd node python3
```

| Tool | Why |
|------|-----|
| `git` | Plugin manager (lazy.nvim) clones plugins |
| `gcc`/`make`/`cmake` | Build telescope-fzf-native, avante.nvim |
| `ripgrep` (`rg`) | Telescope live grep (`<leader>fw`) |
| `fd` | Telescope find files (`<leader>ff`) |
| `node`/`npm` | Several LSP servers (html, css, typescript, etc.) |
| `python3`/`pip` | Pyrefly LSP, debugpy, formatters |
| `xclip` (Linux) | System clipboard (`unnamedplus`) |

### 3. Install a Nerd Font

Icons in the statusline, file tree, and bufferline require a [Nerd Font](https://www.nerdfonts.com/).

```bash
# Example: JetBrains Mono or Agave Nerd Font Mono
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar xf JetBrainsMono.tar.xz
fc-cache -fv
```

Then set your terminal emulator's font to "JetBrainsMono Nerd Font".

### 4. Clone this config

```bash
# As the primary config:
git clone <this-repo-url> ~/.config/nvim

# Or as an isolated config (won't interfere with existing nvim):
git clone <this-repo-url> ~/.config/nvim-v11
alias nvim11='NVIM_APPNAME=nvim-v11 nvim'
```

### 5. First launch

```bash
nvim   # (or nvim11 if using isolated config)
```

On first launch, lazy.nvim will:
1. Bootstrap itself automatically
2. Clone and install all plugins
3. Run `:TSUpdate` to install Treesitter parsers

Wait for everything to finish (you'll see a Lazy UI popup), then **restart Neovim**.

### 6. Install LSP servers and tools

```vim
:Mason
:MasonInstallAll
```

### 7. Build telescope-fzf-native (if not auto-built)

If fuzzy finding is slow or throws an error about `libfzf`:

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim   # or nvim-v11 instead of nvim
make
```

## Config Structure

```
~/.config/nvim/
├── init.lua                  # Entry point: bootstraps lazy.nvim, loads modules
├── lua/
│   ├── options.lua           # vim.opt / vim.g settings
│   ├── keymaps.lua           # All keybindings (vim.keymap.set)
│   ├── autocmds.lua          # Autocommands
│   ├── lsp.lua               # Native Neovim 0.11 LSP setup (diagnostics, keymaps, enable)
│   └── plugins/
│       └── init.lua          # All plugin specs for lazy.nvim
├── lsp/                      # Auto-discovered LSP server configs (Neovim 0.11 feature)
│   ├── pyrefly.lua           # Python
│   ├── gopls.lua             # Go
│   ├── lua_ls.lua            # Lua
│   ├── ts_ls.lua             # TypeScript/JS
│   ├── html.lua              # HTML
│   ├── cssls.lua             # CSS
│   ├── cssmodules_ls.lua     # CSS Modules
│   ├── eslint.lua            # ESLint
│   ├── svelte.lua            # Svelte
│   ├── tailwindcss.lua       # Tailwind CSS
│   ├── emmet_language_server.lua  # Emmet
│   └── ocamllsp.lua          # OCaml
├── colors/
│   └── nightowl-nvchad.lua   # Custom Night Owl colorscheme (NvChad palette)
├── spell/                    # Spell checking dictionaries
└── lazy-lock.json            # Plugin version lockfile
```

## Key Bindings

Leader key: `<Space>`

### General

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | Normal | Save file |
| `<C-c>` | Normal | Copy entire file |
| `<Esc>` | Normal | Clear search highlights |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<C-d>` / `<C-u>` | Normal | Scroll half-page + center |
| `<leader>n` | Normal | Toggle line numbers |
| `<leader>rn` | Normal | Toggle relative numbers |
| `<leader>/` | Normal/Visual | Toggle comment |
| `<S-Tab>` | Normal | Next buffer |
| `<leader>x` | Normal | Close buffer |
| `<leader>fm` | Normal | Format file (LSP) |
| `§` | Normal/Visual | End of line (`$`) — Swedish keyboard |

### LSP (active when LSP attaches)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | List references |
| `<C-k>` | Hover documentation |
| `<leader>ls` | Signature help |
| `<leader>D` | Type definition |
| `<leader>ra` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>lf` | Floating diagnostic |
| `[d` / `]d` | Prev/next diagnostic |

### File Navigation

| Key | Action |
|-----|--------|
| `<C-n>` | Toggle file tree (NvimTree) |
| `<leader>e` | Focus file tree |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fw` | Live grep (Telescope) |
| `<leader>fb` | Find buffers |
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fz` | Fuzzy find in current buffer |

### Harpoon

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to Harpoon |
| `<C-e>` | Harpoon quick menu |
| `H/J/K/L` | Jump to Harpoon file 1/2/3/4 |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start debugger |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>dq` | Close DAP session |
| `<leader>do` | Toggle DAP UI |
| `<leader>dh` | Eval under cursor |
| `<leader>dt` | Debug test method (Python) |
| `<leader>djs` | Load `.vscode/launch.json` |

### Git

| Key | Action |
|-----|--------|
| `<leader>cm` | Git commits (Telescope) |
| `<leader>gt` | Git status (Telescope) |
| `]c` / `[c` | Next/prev git hunk |
| `<leader>rh` | Reset hunk |
| `<leader>ph` | Preview hunk |
| `<leader>td` | Toggle deleted lines |

### Terminal (NvTerm)

| Key | Action |
|-----|--------|
| `<leader>ö` | Toggle floating terminal |
| `<A-h>` | Toggle horizontal terminal |
| `<A-v>` | Toggle vertical terminal |
| `<leader>h` | New horizontal terminal |
| `<leader>v` | New vertical terminal |
| `<C-x>` | Escape terminal mode |

## Troubleshooting

### No syntax highlighting
Treesitter parsers may not be installed. Run `:TSInstall all` or open a file and
check `:checkhealth nvim-treesitter`.

### LSP not attaching
Run `:checkhealth vim.lsp` to see active clients. Ensure the server is installed
via `:Mason`. Check logs with `:lua vim.cmd('e ' .. vim.lsp.get_log_path())`.

### telescope-fzf-native errors
Rebuild it: `cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make`

### Clipboard not working (Linux)
Install `xclip` or `xsel`: `sudo apt install xclip`
