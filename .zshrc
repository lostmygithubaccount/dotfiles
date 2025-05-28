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

