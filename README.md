# dotfiles

These are my dotfiles. Feel free to use whatever you want.

# Bootstrap

```bash
# To test:
# docker run -it ubuntu:24.04 bash
apt-get update && apt-get install -y curl sudo
curl -fsSL https://raw.githubusercontent.com/simondanielsson/dotfiles/main/install.sh | bash
```

# Install neovim

The config is only tested with Neovim 10.2. On Linux x86:

```bash
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```

or on Mac ARM:

```bash
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-macos-arm64.tar.gz
sudo rm -rf /opt/nvim-macos-arm64
sudo tar -C /opt -xzf nvim-macos-arm64.tar.gz
```

and add it to your `PATH`

```bash
export PATH="$PATH:/opt/nvim-linux64/bin"
```

