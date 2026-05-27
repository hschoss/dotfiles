#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

printf "Broken symlinks in repo:\n"
find . -xtype l -print

printf "\nStow simulate: common\n"
stow --target="$HOME" --simulate --verbose bash tmux vim git

printf "\nStow simulate: dev\n"
stow --target="$HOME" --simulate --verbose bash tmux vim nvim git cli

printf "\nStow simulate: server\n"
stow --target="$HOME" --simulate --verbose bash tmux vim git server

printf "\nGit status:\n"
git status --short --untracked-files=all
