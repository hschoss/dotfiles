# dircolors
if command -v dircolors >/dev/null 2>&1 && command -v tput >/dev/null 2>&1; then
    colors="$(tput colors 2>/dev/null || printf 0)"
    if [ "$colors" -ge 8 ]; then
        if [ -r "$DOTFILES/shell/dircolors.solarized" ]; then
            eval "$(dircolors -b "$DOTFILES/shell/dircolors.solarized")"
        else
            eval "$(dircolors -b)"
        fi
    fi
    unset colors
fi
