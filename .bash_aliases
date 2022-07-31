# git hack
source /workspaces/codyspace/git.sh

# export PATH
export PATH="/usr/bin:$PATH" # ???

# fine
export EDITOR="vi"

# work
export org="dbt-labs"
export ORG=$org

# vscode annoyance
alias exit="exit 0"

# time savers 
alias v="vi"
alias l="less"
alias t="tree -aFC"
alias tl="tree -L 1 -aFC"
alias tt="tree -L 2 -aFC"
alias ttt="tree -L 3 -aFC"
alias ls="ls -1pG -a"

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
alias python="python3"
alias pip="pip3"
alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
#alias python="/usr/local/opt/python@3.9/bin/python3"
#alias pip="/usr/local/opt/python@3.9/bin/pip3"
alias jsonp="python -m json.tool"

# venvs
alias venvs="cd ~/venvs"
alias venv="python -m venv"
alias off="deactivate"
