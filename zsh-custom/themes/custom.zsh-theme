# custom.zsh-theme
# based on the af-magic theme

local return_code="%(?..%{$fg[red]%}:%?%{$reset_color%})"

# primary prompt
PROMPT='$FG[032]%(8~"[..]/")%7~\
$(git_prompt_info) \
$FG[105]%1(j.[%j] .)%(!.#.$)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075] ("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[214]*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

