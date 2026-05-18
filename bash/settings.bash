HISTSIZE=1048576
HISTFILE="$HOME/.bash_history"
SAVEHIST=$HISTSIZE
shopt -s histappend # append to history file

export BROWSER=firefox
export EDITOR=nvim
export INPUTRC="$HOME/.inputrc"
export PAGER=less
export SAGE_PNG_VIEWER=imv

set -o vi
