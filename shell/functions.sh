path_remove() {
    PATH=$(printf '%s' "$PATH" | awk -v RS=: -v ORS=: -v drop="$1" \
        '$0 != drop' | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink "$HOME/.shell.here")"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")" || return
}

pdf2md() {
    if [ "$#" -ne 1 ]; then
        printf 'Usage: pdf2md FILE.pdf\n' >&2
        return 1
    fi

    pdf=$1
    md="${pdf%.pdf}.md"

    pdftotext -raw -enc UTF-8 "$pdf" "$md" &&
        printf 'Created: %s\n' "$md"
}

tn-passer() {
    sudo tailscale up \
        --login-server=https://passer.schloschi.com \
        --accept-routes=true \
        --accept-dns=true \
        --force-reauth \
        "$@"
}

tn-corvus() {
    sudo tailscale up \
        --login-server=https://corvus.schloschi.com \
        --accept-routes=true \
        --accept-dns=true \
        --force-reauth \
        "$@"
}

tn-down() {
    sudo tailscale down
}

tn-status() {
    local url
    url=$(tailscale debug prefs 2>/dev/null | awk -F'"' '/"ControlURL"/ {print $4; exit}')
    case "$url" in
        *passer.schloschi.com*) printf 'tailnet: passer  (%s)\n' "$url" ;;
        *corvus.schloschi.com*) printf 'tailnet: corvus  (%s)\n' "$url" ;;
        '') printf 'tailnet: unknown (tailscaled not reachable)\n' ;;
        *) printf 'tailnet: other   (%s)\n' "$url" ;;
    esac
    tailscale status
}

