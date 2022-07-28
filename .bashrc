# export PATH
export PATH="/usr/bin:$PATH" # ???

# fine
export EDITOR="vi"

# work
export org="dbt-labs"
export ORG=$org

# aliases
if [ -f ~/.bash-aliases ]; then
. ~/.bash-aliases
fi
