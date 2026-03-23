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
Requires a writable `/nix` directory (ask your sysadmin or check if it already
exists as a shared store on your cluster).

```bash
# Requires curl and git (pre-installed on most clusters)
curl -fsSL https://raw.githubusercontent.com/simondanielsson/dotfiles/main/install-nix.sh | bash
```

## Notes

- Nix is sourced for all zsh sessions via `~/.zshenv` (written by the script).
- To garbage-collect old Nix generations: `nix profile wipe-history --older-than 7d && nix store gc`

# Bootstrap without sudo (Lustre/HPC clusters, via Spack)

Use `install-spack.sh` on clusters where `/nix` is unavailable or not writable
(e.g. Lustre-based HPC systems). Spack is cloned entirely into your home
directory — no root, no `/nix` required.

```bash
# Requires curl (or wget) and git (pre-installed on most clusters)
curl -fsSL https://raw.githubusercontent.com/simondanielsson/dotfiles/main/install-spack.sh | bash
```

Spack builds from source by default, so the first run can be slow. If your
cluster already has a shared Spack installation, you can reuse its pre-built
packages by adding it as an upstream before running the script:

```bash
spack mirror add cluster-upstream /path/to/cluster/spack/mirror
```

After either no-sudo script completes, configure your **local** `~/.ssh/config`
to launch zsh automatically for interactive sessions (avoids needing to change
the login shell on the cluster):

```
Host my_cluster
    ...
    RequestTTY yes
    RemoteCommand zsh -l
```

Then reconnect and you'll drop straight into zsh with all tools available.

## Notes

- Spack and `~/.local/bin` are added to PATH via `~/.zshenv` and `~/.bashrc`.
- To activate the tool environment manually: `spack env activate dotfiles`
- To add a new package: `spack add <pkg> && spack install`
- To garbage-collect old Spack builds: `spack gc`
