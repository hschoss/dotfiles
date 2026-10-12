# dircolors
if command -v dircolors >/dev/null 2>&1 && command -v tput >/dev/null 2>&1; then
    colors="$(tput colors 2>/dev/null || printf 0)"
    if [ "$colors" -ge 8 ]; then
        dircolors_file="${DOTFILES_HOME:-$HOME/.dotfiles}/shell/dircolors.elflord"
        if [ -r "$dircolors_file" ] && [ -O "$dircolors_file" ]; then
            eval "$(dircolors -b "$dircolors_file")"
        else
            eval "$(dircolors -b)"
        fi
        unset dircolors_file
    fi
    unset colors
fi
