# git hack
source /workspaces/codyspace/git.sh

# YOU CANT SEE ME
export DO_NOT_TRACK=1

# vscode path
export cs="/workspaces/codyspace"
export cody="/workspaces/codyspace"
export codyspace="/workspaces/codyspace"

# export PATH
export PATH="/usr/bin:$PATH" # ???
export PATH="/root/bin:$PATH" # for snowsql
#export PATH="/home/vscode/bin:$PATH" # snowsql, old

# fine
export EDITOR="vi"

# work
export org="dbt-labs"
export ORG=$org

# vscode annoyance
alias exit="exit 0"

# snowy
alias snowsql="snowsql --authenticator externalbrowser"

# dbt stuff
alias dbtdocs="dbt docs generate && dbt docs serve"

# time savers 
alias v="vi"
alias l="less"
alias t="tree -aFC"
alias tl="tree -L 1 -aFC"
alias tt="tree -L 2 -aFC"
alias ttt="tree -L 3 -aFC"
alias ls="ls -1pG -a --color"
alias grep="grep --color"

# navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# quick mafs 
alias ali="code ~/.bash_aliases"
alias update="source ~/.bash_aliases && git config --global core.excludesfile ~/.gitignore"
alias gitignore="code ~/.gitignore"

# make life easier 
alias du="du -h -d1"
alias loc="cloc ."
alias find="find . -name"

# quick project access

# python stuff
#alias python="python3"
#alias pip="pip3"
alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
#alias python="/usr/local/opt/python@3.9/bin/python3"
#alias pip="/usr/local/opt/python@3.9/bin/pip3"
alias jsonp="python -m json.tool"

# venvs
alias venvs="cd $cs/venvs"
alias venv="python -m venv"
alias snowy="source $cs/venvs/snowy/bin/activate"
alias off="deactivate"
