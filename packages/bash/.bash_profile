# ~/.bash_profile

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

if [ -f "$HOME/.bash_profile.local" ]; then
    . "$HOME/.bash_profile.local"
fi
