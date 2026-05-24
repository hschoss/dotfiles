# dotfiles

my dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/) and
the structure is inspired by Anish Athalye's [Managing your dotfiles](https://anishathalye.com/managing-your-dotfiles/). You can use this
portable configuration on all Linux systems with bash, vim, tmux and git.

My machine-specific settings live in the
[dotfiles-local](https://github.com/hschoss/dotfiles) repo, which extends this
base configuration. 

## Installation

Before applying any configuration, run a dry run first. These commands simulate
the Stow operations without changing files:

```sh
./scripts/install-common.sh --dry-run
./scripts/install-dev.sh --dry-run
./scripts/install-server.sh --dry-run
```

After checking the dry-run output you can actually apply the profile you want.
Use only the profile that matches the machine you are setting up.

```sh
./scripts/install-common.sh
./scripts/install-dev.sh
./scripts/install-server.sh
```
Run the check script to validate the repo setup:

```
./scripts/check.sh
```

You can remove the managed symlinks with this script. Please dry-run first.

```sh
./scripts/unstow-all.sh --dry-run
./scripts/unstow-all.sh
```

## Making local Customizations

You can add local and machine-specific customization without changing this base
repository. The following files are sourced when present:
- `~/.bashrc` sources `~/.bashrc.local`
- `~/.bash_profile` sources `~/.bash_profile.local`
- `~/.tmux.conf` sources `~/.tmux.conf.local`
- `~/.vimrc` sources `~/.vimrc.local`
