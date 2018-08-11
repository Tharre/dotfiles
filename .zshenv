# set LS_COLORS
eval "$(dircolors)"

typeset -U path
path=("$HOME/bin" $path[@])
export EDITOR=vim
export LESS='-R'
