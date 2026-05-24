# Dotfiles

my dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/).

The structure of my dotfiles is motivated by thhis Anish Athalye [post](https://anishathalye.com/managing-your-dotfiles/). This configuration is safe to use on all Linux systems with bash, vim, tmux and git.

my machine-specific and private settings are in the [dotfiles-local](https://github.com/hschoss/dotfiles) repo, which extends this base configuration. 

## Packages
- `bash`: `.bashrc`, `.bash_profile`, `.inputrc`, `bash/`, and `shell/`
- `tmux`: `.tmux.conf`
- `vim`: `.vimrc`
- `nvim`: `.config/nvim/`
- `git`: `.config/git/` and safe `.config/gh/config.yml`
- `cli`: portable CLI config such as `yt-dlp`
- `server`: minimal server-safe package placeholder

## first: dry run

These commands only simulate Stow operations. If they work you can apply them.

```sh
./scripts/install-common.sh --dry-run
./scripts/install-dev.sh --dry-run
./scripts/install-server.sh --dry-run
```

## next: apply the config

Run one profile after checking the dry-run output:

```sh
./scripts/install-common.sh
./scripts/install-dev.sh
./scripts/install-server.sh
```

## eventually: unstow

```sh
./scripts/unstow-all.sh --dry-run
./scripts/unstow-all.sh
```

# 
```sh
./scripts/check.sh
```

The check script prints broken symlinks inside the repo, runs Stow simulations for common/dev/server profiles, prints the package tree, and shows Git status.

## Making local Customizations

You can make local customizations for some programs by editing these files:

- `~/.bashrc` sources `~/.bashrc.local`
- `~/.bash_profile` sources `~/.bash_profile.local`
- `~/.tmux.conf` sources `~/.tmux.conf.local`
- `~/.vimrc` sources `~/.vimrc.local`
- shell startup also sources readable `*.sh` files from `~/.config/shell/local/` and `~/.local/share/dotfiles-local/`


