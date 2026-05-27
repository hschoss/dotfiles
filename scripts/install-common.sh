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

link_root_file() {
    source_path="$repo_root/$1"
    target_path="$HOME/$1"

    if [ ! -e "$source_path" ]; then
        printf "missing source: %s\n" "$source_path" >&2
        exit 1
    fi

    if [ -L "$target_path" ]; then
        current_target=$(readlink "$target_path")
        case "$current_target" in
            .dotfiles/*|"$repo_root"/*)
                printf "LINK: %s -> .dotfiles/%s\n" "$target_path" "$1"
                [ "$dry_run" = true ] || ln -sfn ".dotfiles/$1" "$target_path"
                return 0
                ;;
            *)
                printf "conflict: %s points to %s\n" "$target_path" "$current_target" >&2
                exit 1
                ;;
        esac
    elif [ -e "$target_path" ]; then
        if cmp -s "$source_path" "$target_path"; then
            printf "ADOPT: %s -> .dotfiles/%s\n" "$target_path" "$1"
            if [ "$dry_run" != true ]; then
                rm "$target_path"
                ln -s ".dotfiles/$1" "$target_path"
            fi
            return 0
        fi
        printf "conflict: %s exists and differs from %s\n" "$target_path" "$source_path" >&2
        exit 1
    fi

    printf "LINK: %s -> .dotfiles/%s\n" "$target_path" "$1"
    [ "$dry_run" = true ] || ln -s ".dotfiles/$1" "$target_path"
}

printf "Linking root dotfiles: %s\n" "$root_links"
for root_link in $root_links; do
    link_root_file "$root_link"
done

printf "Stowing packages: %s\n" "$packages"
if [ "$dry_run" = true ]; then
    stow --no-folding --target="$HOME" --simulate --verbose $packages
else
    stow --no-folding --target="$HOME" $packages
fi
