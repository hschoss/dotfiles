if mise_path=$(command -v mise 2>/dev/null); then
    case "$mise_path" in
        "$HOME"/.local/bin/*|"$HOME"/bin/*|/usr/bin/*|/usr/local/bin/*)
            eval "$("$mise_path" activate bash)"
            ;;
    esac
    unset mise_path
fi

if rbenv_path=$(command -v rbenv 2>/dev/null); then
    case "$rbenv_path" in
        "$HOME"/.rbenv/bin/*|"$HOME"/.local/bin/*|"$HOME"/bin/*|/usr/bin/*|/usr/local/bin/*)
            eval "$("$rbenv_path" init -)"
            ;;
    esac
    unset rbenv_path
fi
