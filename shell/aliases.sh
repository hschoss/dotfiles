# nice colors in coreutils output
alias ls='ls --color=auto'
alias sl='ls --color=auto'
alias grep='grep --color'

# local llm config
alias ais='ollama run qwen2.5-coder:7b'
alias aib='ollama run qwen3-coder:30b'

# protection against overwriting
alias cp='cp -i'
alias mv='mv -i'

alias info="info --vi-keys"

# zathura window and terminal usage
alias zathura='zathura --fork'

# Check if a file contains non-ascii characters
nonascii() {
    LC_ALL=C grep -n '[^[:print:][:space:]]' "${@}"
}
