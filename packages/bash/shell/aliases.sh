# nice colors in coreutils output
alias ls='ls --color=auto'
alias sl='ls --color=auto'
alias grep='grep --color'

# protection against overwriting
alias cp='cp -i'
alias mv='mv -i'

alias info="info --vi-keys"

# Check if a file contains non-ascii characters
nonascii() {
    LC_ALL=C grep -n '[^[:print:][:space:]]' "${@}"
}
