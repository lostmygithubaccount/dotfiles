# =============================================================================
# initialization
# =============================================================================

## load environment variables from .env file if it exists
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

## load bash aliases if the file exists
if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# =============================================================================
# zsh configuration
# =============================================================================

## autocomplete
autoload -Uz compinit
compinit

## kubectl autocomplete
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

## vi mode
bindkey -v

## vcs_info (fast mode with change indicators)
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b%c%u'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{160}*%f'
zstyle ':vcs_info:*' stagedstr '%F{30}+%f'

# =============================================================================
# prompt
# =============================================================================

## configuration
setopt PROMPT_SUBST

## colors
local bg_time='%K{236}'
local fg_time='%F{255}'
local bg_elapsed='%K{240}'
local fg_elapsed='%F{255}'
local bg_user='%K{99}'
local fg_user='%F{255}'
local bg_path='%K{135}'
local fg_path='%F{255}'
local bg_git_clean='%K{87}'
local fg_git_clean='%F{0}'
local bg_git_dirty='%K{213}'
local fg_git_dirty='%F{0}'
local reset='%k%f'

## powerline separators
local sep_right=''
local sep_left=''

## helpers
container_indicator() {
    if [[ -n "$CONTAINER_ID" || -n "$HOSTNAME" && "$HOSTNAME" =~ ^[a-f0-9]{12}$ || -f /.dockerenv || -n "$CODESPACES" ]]; then
        echo "🤖 "
    fi
}

fish_style_pwd() {
    local pwd_path="$PWD"
    local home_path="$HOME"

    # replace home with ~
    if [[ "$pwd_path" == "$home_path"* ]]; then
        pwd_path="~${pwd_path#$home_path}"
    fi

    # if path is short enough, return as-is
    if [[ ${#pwd_path} -le 32 ]]; then
        echo "$pwd_path"
        return
    fi

    # split path and collapse middle directories
    local parts=(${(s:/:)pwd_path})
    local result=""
    local parts_count=${#parts}

    if [[ $parts_count -le 4 ]]; then
        echo "$pwd_path"
        return
    fi

    # always show first part (~ or /)
    result="${parts[1]}"

    # always show second part in full if it exists
    if [[ -n "${parts[2]}" ]]; then
        result="$result/${parts[2]}"
    fi

    # collapse middle parts to first character (skip first, second, and last two)
    for ((i=3; i<parts_count-1; i++)); do
        if [[ -n "${parts[i]}" ]]; then
            result="$result/${parts[i]:0:1}"
        fi
    done

    # always show last two parts in full
    if [[ parts_count -ge 2 && -n "${parts[parts_count-1]}" ]]; then
        result="$result/${parts[parts_count-1]}"
    fi
    if [[ -n "${parts[parts_count]}" ]]; then
        result="$result/${parts[parts_count]}"
    fi

    echo "$result"
}

git_prompt_info() {
    if [[ -n "${vcs_info_msg_0_}" ]]; then
        local git_info="${vcs_info_msg_0_}"

        # check if repo has any changes (staged or unstaged)
        if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
            echo "${bg_git_dirty}${fg_git_dirty} ${git_info} ${reset}%F{213}${sep_right}${reset}"
        else
            echo "${bg_git_clean}${fg_git_clean} ${git_info} ${reset}%F{87}${sep_right}${reset}"
        fi
    else
        echo "%F{135}${sep_right}${reset}"
    fi
}

get_timestamp() {
    TZ=UTC date '+%Y/%m/%d %H:%M:%S'
}

get_elapsed_time() {
    if [[ -n $_last_command_duration ]]; then
        echo "$_last_command_duration"
    fi
}

## hooks
typeset -g _command_start_time
typeset -g _last_command_duration

preexec() {
    _command_start_time=$SECONDS
    _last_command_duration=""
}

precmd() {
    vcs_info

    if [[ -n $_command_start_time ]]; then
        local elapsed=$(( SECONDS - _command_start_time ))
        _last_command_duration=$(printf "%d" $elapsed)
        unset _command_start_time
    fi
}

## build prompt
PROMPT='$(container_indicator)'
PROMPT+="${bg_user}${fg_user} %n@%m ${reset}%F{99}${sep_right}${reset}"
PROMPT+="${bg_path}${fg_path} \$(fish_style_pwd) ${reset}%F{135}${sep_right}${reset}"
PROMPT+="\$(git_prompt_info)"
PROMPT+="${bg_time}${fg_time} \$(get_timestamp) ${reset}%F{236}${sep_right}${reset}"
PROMPT+="\$([ -n \"\$(get_elapsed_time)\" ] && echo \"${bg_elapsed}${fg_elapsed} \$(get_elapsed_time) ${reset}%F{240}${sep_right}${reset}\")"
PROMPT+=$'\n'
PROMPT+="%F{99}❯%f "

