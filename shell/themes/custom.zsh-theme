# custom.zsh-theme
# based on the af-magic theme

local return_code="%(?..%{$fg[red]%}:%?%{$reset_color%})"

# primary prompt
PROMPT='$FG[032]%(7~"[..]/")%7~\
$(git_prompt_info) \
$FG[105]%1(j.[%j] .)%(!.#.$)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# right prompt
#if type "virtualenv_prompt_info" > /dev/null
#then
	#RPROMPT='$(virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'
#else
	#RPROMPT='$my_gray%n@%m%{$reset_color%}%'
#fi

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075] ("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

