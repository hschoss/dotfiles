# Use nice colors in coreutils output
alias ls='ls --color=auto'
alias grep='grep --color'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# cd to git root directory
alias cdgr='cd "$(git root)"'

# Kubernetes usage
alias k='kubectl'
alias t="talosctl"

# Vim related settings
unalias vim 2>/dev/null || true

alias info="info --vi-keys"

# Check if a file contains non-ascii characters
nonascii() {
    LC_ALL=C grep -n '[^[:print:][:space:]]' "${@}"
}
