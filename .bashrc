# ~/.bashrc

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

dot_source() {
    [ -r "$DOTFILES/$1" ] && source "$DOTFILES/$1"
}

# Functions
dot_source shell/functions.sh

# Local customizations before shared settings
[ -r "$HOME/.shell_local_before" ] && source "$HOME/.shell_local_before"
[ -r "$HOME/.bashrc_local_before" ] && source "$HOME/.bashrc_local_before"

# Settings
dot_source bash/settings.bash

# PATH setup and external tool settings
dot_source shell/bootstrap.sh
dot_source shell/external.sh

# Aliases
dot_source shell/aliases.sh

# Prompt and interactive plugins
dot_source bash/prompt.bash
dot_source bash/plugins.bash

# Local customizations after shared settings
[ -r "$HOME/.shell_local_after" ] && source "$HOME/.shell_local_after"
[ -r "$HOME/.bashrc_local_after" ] && source "$HOME/.bashrc_local_after"

# Private customizations, intentionally not checked in
[ -r "$HOME/.shell_private" ] && source "$HOME/.shell_private"

unset -f dot_source
