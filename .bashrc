# ~/.bashrc

alias scan='./buero/script/scan-to-review-pdf.sh'


if [ -z "${DOTFILES_HOME:-}" ]; then
    dotfiles_source="${BASH_SOURCE[0]:-$0}"
    while [ -L "$dotfiles_source" ]; do
        dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$dotfiles_source")" && pwd)
        dotfiles_target=$(readlink "$dotfiles_source")
        case "$dotfiles_target" in
            /*) dotfiles_source="$dotfiles_target" ;;
            *) dotfiles_source="$dotfiles_dir/$dotfiles_target" ;;
        esac
    done
    DOTFILES_HOME=$(CDPATH= cd -- "$(dirname -- "$dotfiles_source")" && pwd)
fi

dot_source() {
    [ -r "$DOTFILES_HOME/$1" ] && source "$DOTFILES_HOME/$1"
}

source_private() {
    [ -f "$1" ] || return 0
    [ -r "$1" ] || return 0
    [ -O "$1" ] || return 0

    local mode group_perm other_perm
    mode=$(stat -c %a "$1" 2>/dev/null) || return 0
    group_perm=${mode: -2:1}
    other_perm=${mode: -1}
    case "$group_perm$other_perm" in
        [2367]?|?[2367]) return 0 ;;
    esac

    source "$1"
}

# functions
dot_source shell/functions.sh

# local customizations before shared settings
source_private "$HOME/.shell_local_before"
source_private "$HOME/.bashrc_local_before"

# settings
dot_source bash/settings.bash

# PATH setup and external tool settings
dot_source shell/bootstrap.sh
dot_source shell/external.sh

# aliases
dot_source shell/aliases.sh

# Prompt and interactive plugins
dot_source bash/prompt.bash
dot_source bash/plugins.bash

# Local customizations after shared settings
source_private "$HOME/.shell_local_after"
source_private "$HOME/.bashrc_local_after"

# Private customizations, intentionally not checked in
source_private "$HOME/.shell_private"

for local_shell_file in "$HOME/.config/shell/local/"*.sh "$HOME/.local/share/dotfiles-local/"*.sh; do
    source_private "$local_shell_file"
done

source_private "$HOME/.bashrc.local"

unset local_shell_file
unset dotfiles_dir
unset dotfiles_source
unset dotfiles_target
unset -f source_private
unset -f dot_source
