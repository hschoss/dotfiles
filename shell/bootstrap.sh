# Prefer tools under ~/.local/bin (pipx, cargo install, etc.) over
# system versions. Personal scripts in ~/bin come LAST so a stray file
# there cannot shadow system commands like ssh, sudo, or git.
path_prepend "$HOME/.local/bin"
path_append  "$HOME/bin"
