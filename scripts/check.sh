#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

printf "Tracked-but-should-be-ignored (regression check):\n"
leaked=$(git ls-files -i --exclude-standard --cached || true)
if [ -n "$leaked" ]; then
    printf '%s\n' "$leaked" >&2
    printf 'FAIL: files above are tracked but would be ignored by .gitignore.\n' >&2
    printf 'This usually means .gitignore was tightened without untracking them.\n' >&2
    exit 1
fi
printf '  (none)\n'

printf "\nBroken symlinks in repo:\n"
find . -xtype l -print

printf "\nRoot dotfiles:\n"
for root_link in .bash_profile .bashrc .inputrc .tmux.conf .vimrc; do
    if [ -e "$root_link" ]; then
        printf "OK: %s\n" "$root_link"
    else
        printf "MISSING: %s\n" "$root_link"
    fi
done

printf "\nStow simulate:\n"
stow --target="$HOME" --simulate --verbose git

printf "\nGit status:\n"
git status --short --untracked-files=all
