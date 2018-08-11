ZSH_HOME="${ZDOTDIR:-$HOME}"
fpath=( "$ZSH_HOME/.zsh" "$ZSH_HOME/.zsh/zsh-completions/src" $fpath )

autoload -U compaudit compinit
compinit -d "${XDG_CONFIG_HOME:-$HOME/.config}/zcompdump"

## aliases
autoload -Uz run-help
unalias run-help
alias help=run-help
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias history='fc -l 1'
alias xclip="xclip -selection c"
alias open="xdg-open"
alias wee='WEECHAT_PASSPHRASE="$(pass personal/weechat)" weechat'
alias which-command='whence'

## zsh options
setopt extended_glob
setopt long_list_jobs # TODO:?
setopt interactivecomments
bindkey -e
bindkey '^r' history-incremental-search-backward
bindkey ' ' magic-space # expand !! and alike

# this still doesn't catch some attacks, see:
# https://thejh.net/misc/website-terminal-copy-paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

## history
HISTFILE="$ZSH_HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=$HISTSIZE
setopt extended_history
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first

## completion
zmodload zsh/complist
bindkey -M menuselect '^o' accept-and-infer-next-history # TODO:
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
setopt complete_aliases
unsetopt menu_complete

zmodload zsh/terminfo
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

setopt PROMPT_SUBST
autoload -Uz promptinit
promptinit
prompt 'custom'

unset ZSH_HOME

## functions
function 256color_test {
    ( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;
    for i in {0..256};
        do
        o=00$i;
        echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;
    done )
}

function title {
    case "$TERM" in
      cygwin|xterm*|putty*|rxvt*|ansi)
        print -Pn "\e]1;$1:q\a"
        ;;
      screen*)
        print -Pn "\ek$1:q\e\\"
        ;;
      *)
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
            echoti tsl
            print -Pn "$1"
            echoti fsl
        fi
        ;;
    esac
}

function set_title_precmd {
    title "%15<..<%~%<<" $ZSH_THEME_TERM_TITLE_IDLE
}

function set_tilte_preexec {
    setopt extended_glob

    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    local LINE="${2:gs/%/%%}"

    title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(set_title_precmd)
preexec_functions+=(set_tilte_preexec)

# zshenv may not be attached to a tty, so we set this here instead
export GPG_TTY="$(tty)"

# if $SSH_AUTH_SOCK is not set or not pointing to a socket, use gpg-agent
if [ ! -S "$SSH_AUTH_SOCK" ] && type "gpgconf" > /dev/null; then
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
fi

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

## startup
update_dotfiles
