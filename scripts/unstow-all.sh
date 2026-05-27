#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

dry_run=false
if [ "${1:-}" = "--dry-run" ]; then
    dry_run=true
    shift
fi

if [ "$#" -ne 0 ]; then
    printf "usage: %s [--dry-run]\n" "$0" >&2
    exit 2
fi

root_links=".bash_profile .bashrc .inputrc .tmux.conf .vimrc"
packages="git"

unlink_root_file() {
    target_path="$HOME/$1"

    if [ ! -L "$target_path" ]; then
        [ -e "$target_path" ] && printf "skip: %s is not a symlink\n" "$target_path"
        return 0
    fi

    current_target=$(readlink "$target_path")
    if [ "$current_target" = ".dotfiles/$1" ] || [ "$current_target" = "$repo_root/$1" ]; then
        printf "UNLINK: %s\n" "$target_path"
        [ "$dry_run" = true ] || rm "$target_path"
    else
        printf "skip: %s points to %s\n" "$target_path" "$current_target"
    fi
}

printf "Unlinking root dotfiles: %s\n" "$root_links"
for root_link in $root_links; do
    unlink_root_file "$root_link"
done

printf "Unstowing packages: %s\n" "$packages"
if [ "$dry_run" = true ]; then
    stow --target="$HOME" --delete --simulate --verbose $packages
else
    stow --target="$HOME" --delete $packages
fi
