# dotfiles

These are my dotfiles. Feel free to use whatever you want.

# Bootstrap with sudo priveleges

```bash
# To test:
# docker run -it ubuntu:24.04 bash
apt-get update && apt-get install -y curl sudo
curl -fsSL https://raw.githubusercontent.com/simondanielsson/dotfiles/main/install.sh | bash
source $HOME/.local/bin/env
```

# Bootstrap without sudo (HPC/Slurm clusters, via Nix)

Use `install-nix.sh` on shared nodes where you don't have root. It installs
everything into `~/.nix-profile` and `~/.local` — no system-wide changes.

```bash
# Requires curl and git (pre-installed on most clusters)
curl -fsSL https://raw.githubusercontent.com/simondanielsson/dotfiles/main/install-nix.sh | bash
```

After the script completes, configure your **local** `~/.ssh/config` to launch
zsh automatically for interactive sessions (avoids needing to change the login
shell on the cluster):

```
Host my_cluster
    ...
    RequestTTY yes
    RemoteCommand zsh -l
```

Then reconnect and you'll drop straight into zsh with all tools available.

## Notes

- Nix is sourced for all zsh sessions via `~/.zshenv` (written by the script).
- To garbage-collect old Nix generations: `nix profile wipe-history --older-than 7d && nix store gc`
