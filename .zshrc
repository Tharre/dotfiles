# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="custom"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/dotfiles/zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

## functions
function noproxy {
	unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ftp_proxy FTP_PROXY no_proxy

	# change dconf
	dconf reset -f /system/proxy/

	proxy_update
}

	function setproxy {
	base_proxy="proxy.domain.com"
	base_proxy_port=8080

	dconf_proxy="'$base_proxy'"
	env_proxy="http://$base_proxy:$base_proxy_port"

	http_proxy=$env_proxy
	HTTP_PROXY=$env_proxy
	https_proxy=$env_proxy
	HTTPS_PROXY=$env_proxy
	ftp_proxy=$env_proxy
	FTP_PROXY=$env_proxy
	no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	export http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ftp_proxy FTP_PROXY no_proxy

	# change dconf
	dconf write /system/proxy/mode "'manual'"
	dconf write /system/proxy/ignore-hosts "['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12']"
	dconf write /system/proxy/http/enabled true
	dconf write /system/proxy/http/host "$dconf_proxy"
	dconf write /system/proxy/http/port "$base_proxy_port"
	dconf write /system/proxy/https/host "$dconf_proxy"
	dconf write /system/proxy/https/port "$base_proxy_port"
	dconf write /system/proxy/ftp/host "$dconf_proxy"
	dconf write /system/proxy/ftp/port "$base_proxy_port"

	proxy_update
}

# restart/reload applications for proxy settings to take effect
function proxy_update {
	killall -q dropbox
	dropbox-cli start
}

function 256color_test {
	( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;
	for i in {0..256};
		do
		o=00$i;
		echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;
	done )
}

# requires youtube-dl, mpv
function play {
    # Skip DASH manifest for speed purposes. This might actually disable
    # being able to specify things like 'bestaudio' as the requested format,
    # but try anyway.
    # Use "$*" so that quoting the requested song isn't necessary.
    mpv $(youtube-dl --default-search=ytsearch: \
                     --max-downloads 1 \
                     --youtube-skip-dash-manifest \
                     --format="bestaudio/best" \
                     -g "$*") --no-video
}

# update
function update_dotfiles() {
	dotfiles="$HOME/dotfiles"
	epoch_file="$dotfiles/.updated"
	epoch_curr=$(date +'%s')
	[ -e "$epoch_file" ] && epoch_old=$(<"$epoch_file")
	epoch_diff=$(($epoch_curr - ${epoch_old:-0}))
	max_time=$((60 * 60 * 24 * 7))

	if [ $(($epoch_diff / $max_time)) -ne 0 ]; then
		echo "Updating dotfiles ..."

		cd "$dotfiles"
		git pull --rebase --stat origin master
		echo $epoch_curr > "$epoch_file"
		./install.sh
		cd -

		echo "Finished."
	fi
}

function suspend_after() {
	trap 'kill $!' INT TERM EXIT
	systemd-inhibit --what=handle-lid-switch sleep 1d &
	eval "$*"
	systemctl suspend
}

## PATH
export PATH=$PATH:$HOME/bin

## alias

alias xclip="xclip -selection c"
alias open="xdg-open"

## env
export EDITOR=vim

# force 256 color mode
if [ -n "$TMUX" ]; then
	export TERM=screen-256color
else
	export TERM=xterm-256color
fi

# use gpg-agent as ssh-agent
gpg-connect-agent /bye > /dev/null 2>&1
export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"

## zsh options

bindkey -M viins ' ' magic-space
setopt EXTENDED_GLOB
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE

## startup
update_dotfiles

if type "archey3" > /dev/null; then
	archey3 # nice system information and arch logo
fi

[ -e ~/TODO ] && cat ~/TODO
