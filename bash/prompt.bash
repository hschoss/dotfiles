ATTRIBUTE_BOLD='\[\e[1m\]'
ATTRIBUTE_RESET='\[\e[0m\]'
COLOR_DEFAULT='\[\e[39m\]'
COLOR_RED='\[\e[31m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'

# inspired by anishathalye
machine_name() {
    local name
    if [[ -f "$HOME/.name" ]] && [[ -O "$HOME/.name" ]]; then
        read -r name < "$HOME/.name"
    elif command -v hostname >/dev/null 2>&1; then
        name=$(hostname)
    elif [[ -n $HOSTNAME ]]; then
        name=$HOSTNAME
    else
        name=unknown
    fi
    # Strip anything but safe chars so a crafted ~/.name cannot inject
    # terminal escapes into PS1.
    printf '%s\n' "${name//[^A-Za-z0-9._-]/}"
}

PROMPT_DIRTRIM=3
PS1="\n${COLOR_BLUE}#${COLOR_DEFAULT} ${COLOR_CYAN}\\u${COLOR_DEFAULT} ${COLOR_GREEN}at${COLOR_DEFAULT} ${COLOR_MAGENTA}\$(machine_name)${COLOR_DEFAULT} ${COLOR_GREEN}in${COLOR_DEFAULT} ${COLOR_YELLOW}\w${COLOR_DEFAULT}\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)${COLOR_BLUE}>${COLOR_DEFAULT} "
PS2="${COLOR_BLUE}>${COLOR_DEFAULT} "


COLOR_GRAY='\e[38;5;246m'

demoprompt() {
    PROMPT_DIRTRIM=1
    PS1="${COLOR_GRAY}\w ${COLOR_BLUE}\$ "
    trap '[[ -t 1 ]] && tput sgr0' DEBUG
}
