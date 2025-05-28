# Standard stuff
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# Ascend-specific stuff
## Path
export PATH="$HOME/google-cloud-sdk/bin:$PATH" # ugh
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

## Miscellaneous
ulimit -n 2560 # some bizarre issue
eval "$(fnm env --use-on-cd --shell zsh)" # Node nonsense

## Environment variables
export ASCEND_INFRA="$HOME/code/ascend-io/infra" # Infra repo location
# export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/shims ]] && export PATH="$PYENV_ROOT/shims:$PATH"
#export PATH="$HOME/code/ascend-io/source/bin:$PATH"
### Repos
export PRODUCT="ascend-io/product"
export CORE="ascend-io/ascend-core"
export BACKEND="ascend-io/ascend-backend"
export FRONTEND="ascend-io/ascend-ui"
export INFRA="ascend-io/ascend-infra"
export DOCS="ascend-io/ascend-docs"
export COMMUNITY="ascend-io/ascend-community-internal"
export BASECAMP="ascend-io/basecamp"

# Zsh autocomplete
autoload -Uz compinit
compinit

# Enable version control info
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{99}%b%f%c%u'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{196}*%f'
zstyle ':vcs_info:*' stagedstr '%F{118}+%f'

# Prompt configuration
setopt PROMPT_SUBST

# Colors with fallback for limited terminals
if [[ "$TERM" =~ "256color" ]] || [[ -n "$COLORTERM" ]] || [[ "$TERM" == "xterm-kitty" ]] || [[ $(tput colors 2>/dev/null) -ge 256 ]]; then
    # 256-color palette
    local violet='%F{99}'      # Bright violet
    local purple='%F{135}'     # Purple
    local cyan='%F{87}'        # Bright cyan
    local green='%F{118}'      # Bright green
    local yellow='%F{226}'     # Bright yellow
    local red='%F{196}'        # Bright red
    local white='%F{255}'      # White
else
    # Basic 16-color fallback - use different colors for distinction
    local violet='%F{blue}'    # Blue instead of magenta
    local purple='%F{magenta}' # Magenta
    local cyan='%F{cyan}'      # Cyan
    local green='%F{green}'    # Green
    local yellow='%F{yellow}'  # Yellow
    local red='%F{red}'        # Red
    local white='%F{white}'    # White
fi
local reset='%f'               # Reset color

# Container detection
container_indicator() {
    if [[ -n "$CONTAINER_ID" || -n "$HOSTNAME" && "$HOSTNAME" =~ ^[a-f0-9]{12}$ || -f /.dockerenv || -n "$CODESPACES" ]]; then
        echo "🤖 "
    fi
}

# Fish-style directory collapsing
fish_style_pwd() {
    local pwd_path="$PWD"
    local home_path="$HOME"
    
    # Replace home with ~
    if [[ "$pwd_path" == "$home_path"* ]]; then
        pwd_path="~${pwd_path#$home_path}"
    fi
    
    # If path is short enough, return as-is
    if [[ ${#pwd_path} -le 30 ]]; then
        echo "$pwd_path"
        return
    fi
    
    # Split path and collapse middle directories
    local parts=(${(s:/:)pwd_path})
    local result=""
    local parts_count=${#parts}
    
    if [[ $parts_count -le 3 ]]; then
        echo "$pwd_path"
        return
    fi
    
    # Always show first part (~ or /)
    result="${parts[1]}"
    
    # Collapse middle parts to first character
    for ((i=2; i<parts_count; i++)); do
        if [[ -n "${parts[i]}" ]]; then
            result="$result/${parts[i]:0:1}"
        fi
    done
    
    # Always show last part in full
    if [[ -n "${parts[parts_count]}" ]]; then
        result="$result/${parts[parts_count]}"
    fi
    
    echo "$result"
}

# Build the prompt
PROMPT='$(container_indicator)'               # Container indicator
PROMPT+="${violet}%n${reset}"                # Username
PROMPT+="${white}@${reset}"                  # @
PROMPT+="${purple}%m${reset}"                # Hostname
PROMPT+=" ${cyan}\$(fish_style_pwd)${reset}" # Directory
PROMPT+='${vcs_info_msg_0_}'                 # Git info
PROMPT+=" ${violet}❯${reset} "               # Prompt character

