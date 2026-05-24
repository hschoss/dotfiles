#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

printf "Broken symlinks in repo:\n"
find . -xtype l -print

printf "\nStow simulate: common\n"
stow --dir=packages --target="$HOME" --simulate --verbose bash tmux vim git

printf "\nStow simulate: dev\n"
stow --dir=packages --target="$HOME" --simulate --verbose bash tmux vim nvim git cli

printf "\nStow simulate: server\n"
stow --dir=packages --target="$HOME" --simulate --verbose bash tmux vim git server

printf "\nPackage tree:\n"
find packages -maxdepth 4 -print | sort

printf "\nGit status:\n"
git status --short --untracked-files=all
