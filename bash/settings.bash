HISTSIZE=1048576
HISTFILE="$HOME/.bash_history"
SAVEHIST=$HISTSIZE
HISTCONTROL=ignoredups:ignorespace:erasedups
HISTIGNORE='pass:*:*TOKEN*:*SECRET*:*PASSWORD*:*AWS_*:*API_KEY*:*BEARER*'
HISTTIMEFORMAT='%F %T '

shopt -s histappend # append to history file

umask 077           # new files/dirs private by default

export BROWSER=firefox
export EDITOR=vim
export INPUTRC="$HOME/.inputrc"
export PAGER=less
export SAGE_PNG_VIEWER=imv

set -o vi


# Reload readline config for interactive bash
if [[ $- == *i* ]]; then
  bind -f "$INPUTRC"
fi
