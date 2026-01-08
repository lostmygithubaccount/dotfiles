# =============================================================================
# ascend (work)
# =============================================================================

# machine type detection
if [[ $(hostname) == *"ascend"* ]]; then
    export MACHINE_TYPE="WORK"
else
    export MACHINE_TYPE="LIFE"
fi

## exports
export AIO=$HOME/code/ascend-io
export ASCEND_INFRA="$HOME/code/ascend-io/infra"

### repos
export PRODUCT="ascend-io/product"
export CORE="ascend-io/ascend-core"
export BACKEND="ascend-io/ascend-backend"
export FRONTEND="ascend-io/ascend-ui"
export INFRA="ascend-io/ascend-infra"
export DOCS="ascend-io/ascend-docs"
export COMMUNITY="ascend-io/ascend-community-internal"
export BASECAMP="ascend-io/basecamp"

### path
export PATH="$HOME/google-cloud-sdk/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

### homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="$HOME/.linuxbrew/bin:$PATH"
fi

### misc
ulimit -n 2560 # some bizarre issue
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

### TODO: fix underlying fnm shenanigans
alias claude="/Users/cody/.local/bin/claude"

## functions
function ascendio() {
    cd $HOME/code/ascend-io
}

function aio() {
    ascendio
}

function p() {
    cd $AIO/product
}

function init {
    cd $AIO/product/initiatives
}

function workspaces() {
    cd $AIO/workspaces
}

function ws() {
    workspaces
}

function cw() {
    create-workspace "$@"
}

function bw() {
    boot-workspace "$@"
}

function kw() {
    tmux kill-session "$@"
}

function dw() {
    delete-workspace "$@"
}

function dwe() {
    delete-workspace -y && exit "$@"
}

function kt() {
    kubectl "$@"
}

function kpr() {
    kubectl get pod -L ascend.io/runtime-id -L ascend.io/runtime-kind -L ascend.io/environment-id $@
}

function kpro() {
    kpr -n ottos-expeditions $@
}

# =============================================================================
# general
# =============================================================================

## exports

### path
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

### editor
export EDITOR="nvim"
export VISUAL=nvim

### python
export PYTHONBREAKPOINT="IPython.embed"
export PYTHONDONTWRITEBYTECODE=1
export OLLAMA_HOME="$HOME/.ollama"

### locations
export GHH=$HOME/code/lostmygithubaccount
export DKDC=$GHH/dkdc
export BIN="$GHH/bin"
export FILES="$GHH/files"
export LAKE="$GHH/lake"

mkdir -p $LAKE

### docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64

### ls colors
if [[ "$OSTYPE" == "darwin"* ]]; then
    export LSCOLORS=Gxfxcxdxbxegedabagacad
else
    export LS_COLORS="di=01;36:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;34:cd=01;34:su=30;41:sg=30;46:tw=30;42:ow=30;43"
fi

export PATH="$BIN:$PATH"

## functions

### config
function ali() {
    v $HOME/.bash_aliases
}

function update() {
    . $HOME/.zshrc
    git config --global core.excludesfile ~/.gitignore
}

function gitignore() {
    v $HOME/.gitignore
}

function vimrc() {
    v $HOME/.config/nvim/init.lua
}

function tmuxc() {
    v $HOME/.tmux.conf
}

function ipyrc() {
    v $HOME/.ipython/profile_default/ipython_config.py
}

function uvrc() {
    v $HOME/.config/uv/uv.toml
}

### movement
function data() {
    cd $HOME/data
}

function profiles() {
    cd $HOME/profiles
}

function secrets() {
    cd $HOME/secrets
}

function vaults() {
    cd $HOME/vaults
}

function down() {
    cd $HOME/Downloads
}

function desk() {
    cd $HOME/Desktop
}

function docs() {
    cd $HOME/Documents
}

function ghh() {
    cd $GHH
}

function bin() {
    cd $GHH/bin
}

function lake() {
    cd $LAKE
}

function websites() {
    cd $DKDC/websites
}

function dkdc.dev() {
    cd $GHH/dkdc.dev
}

function blog() {
    cd $GHH/dkdc.dev/content/posts
}

function posts() {
    blog
}

function wip() {
    cd $GHH/dkdc.dev/content/wip
}

function dkdc.io() {
    cd $GHH/dkdc.io
}

function dotfiles() {
    cd $AIO/codai
}

function files() {
    cd $FILES
}

function pri() {
    v $FILES/pri.md
}

function todo() {
    if [[ "$MACHINE_TYPE" == "WORK" ]]; then
        v $FILES/work.md
    else
        v $FILES/life.md
    fi
}

function notes() {
    v $FILES/notes.md
}

function readinglist() {
    v $FILES/readinglist.md
}

function rlist() {
    readinglist
}

function ..() {
    cd ..
}

function ...() {
    cd ../..
}

function ....() {
    cd ../../..
}

### core
function e() {
    exit
}

function c() {
    clear
}

function cdesk() {
    rm -r $HOME/Desktop/*
}

function s() {
    duckdb "$@"
}

function todos() {
    grep -i "TODO" "$@"
}

function drafts() {
    grep ".*draft.*true.*" "$@"
}

function v() {
    nvim "$@"
}

function vt() {
    v -c "T" "$@"
}

function m() {
    tmux "$@"
}

function r() {
    ranger "$@"
}

function links() {
    dkdc-links "$@"
}

function o() {
    links "$@"
}

function grep() {
    rg --hidden --glob "!public" --glob "!.env" --glob "!.git" --glob "!dist" --glob "!target" --glob "!ascend-out" "$@"
}

function g() {
    grep "$@"
}

function gi() {
    grep -i "$@"
}

function top() {
    btop "$@"
}

function du() {
    command du -h -d1 "$@" | sort -h
}

function loc() {
    scc "$@"
}

function find() {
    command find . -name "$@"
}

function f() {
    find "$@"
}

function glow() {
    command glow -p "$@"
}

function preview() {
    go-grip "$@"
}

function pr() {
    preview "$@"
}

function l() {
    less "$@"
}

function cat() {
    bat --color=always "$@"
}

function tree() {
    if [ -f .rgignore ]; then
        command tree -F --gitignore --gitfile .rgignore "$@"
    else
        command tree -F --gitignore "$@"
    fi
}

function t() {
    tree "$@"
}

function tl() {
    tree -L 1 "$@"
}

function tt() {
    tree -L 2 "$@"
}

function ttt() {
    tree -L 3 "$@"
}

function tttt() {
    tree -L 4 "$@"
}

function ls() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        command ls -1GhFA "$@"
    else
        command ls -1 --color=auto -hFA "$@"
    fi
}

function lsl() {
    ls -l "$@"
}

function fr() {
    if [ $# -ne 2 ]; then
        echo "Usage: fr <find_pattern> <replace_pattern>"
        return 1
    fi

    find_pattern="$1"
    replace_pattern="$2"

    if [[ "$(uname)" == "Darwin" ]]; then
        grep -l "$find_pattern" * 2>/dev/null | xargs -I{} sed -i '' "s/$find_pattern/$replace_pattern/g" {}
    else
        grep -l "$find_pattern" * 2>/dev/null | xargs -I{} sed -i "s/$find_pattern/$replace_pattern/g" {}
    fi

    echo "Replaced \"$find_pattern\" with \"$replace_pattern\" in matching files"
}

function rsync() {
    command rsync -av --exclude-from='.gitignore' "$@"
}

### git
function gs() {
    git status "$@"
}

function gw() {
    git switch "$@"
}

function gn() {
    git switch -c "$@"
}

function gm() {
    git switch main
}

function gb() {
    git branch "$@"
}

function ga() {
    git add .
}

function gA() {
    git add -A
}

function cc() {
    git commit
}

function qs() {
    git add . && git commit -m 'qs'
}

function ss() {
    qs
}

function gc() {
    git commit -m "$@"
}

function gp() {
    git push "$@"
}

function gpf() {
    git push --force "$@"
}

function gl() {
    git log "$@"
}

function gr() {
    git rebase -i origin/main "$@"
}

function diff() {
    git diff --color-words --no-index "$@"
}

function git400() {
    git config http.postBuffer 524288000
}

function gitfucked() {
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    if [ -z "$repo_name" ]; then
        echo "not in a git repository"
        return 1
    fi

    for i in {1..3}; do
        echo -n "are you sure you want to nuke the repo '$repo_name' at $(pwd)? [Y/N] "
        read response
        if [[ ! "$response" =~ ^[Y]$ ]]; then
            echo "operation cancelled"
            return 1
        fi
    done

    git update-ref -d HEAD && git add -A && git commit -m "initial commit" && git push --force
    echo "repository '$repo_name' has been reset"
}

### github
function ghprc() {
    local repo="${1:-}"
    local pr_number="${2:-}"
    local org="${3:-}"

    if [[ -z "$org" ]]; then
        org=$(gh repo view --json owner --jq '.owner.login' 2>/dev/null) || org=""
    fi
    if [[ -z "$repo" ]]; then
        repo=$(gh repo view --json name --jq '.name' 2>/dev/null) || repo=""
    fi
    if [[ -z "$pr_number" ]]; then
        pr_number=$(gh pr view --json number --jq '.number' 2>/dev/null) || pr_number=""
    fi

    if [[ -z "$org" ]]; then
        echo "Error: org not specified and could not determine from current repository." >&2
        return 1
    fi
    if [[ -z "$repo" ]]; then
        echo "Error: repo not specified and could not determine current repository." >&2
        return 1
    fi
    if [[ -z "$pr_number" ]]; then
        echo "Error: PR number not specified and could not determine current pull request." >&2
        return 1
    fi

    gh api --paginate -H "Accept: application/vnd.github+json" \
        "/repos/${org}/${repo}/pulls/${pr_number}/comments" |
        jq -r '
            .[] |
            "Reviewer: \(.user.login)
File:     \(.path) (line \(.line // "N/A"))
Diff:
\(.diff_hunk)
Comment:
\(.body)
-------------------------------------------------------------------------------"
        '
}

function prit() {
    echo "# PR description\n" > pr.md
    gh pr view >> pr.md
    echo "# PR comments\n" >> pr.md
    gh pr view -c >> pr.md
    echo "# PR diff\n" >> pr.md
    gh pr diff >> pr.md
    echo "# PR review comments\n" >> pr.md
    ghprc >> pr.md
}

### ai
function ai() {
    claude --dangerously-skip-permissions "$@"
}

function ai2() {
    codex -a never "$@"
}

function ai3() {
    gemini --yolo "$@"
}

### python
function wp() {
    which python
}

function wp3() {
    which python3
}

function venv() {
    uv venv "$@"
}

function on() {
    . .venv/bin/activate
}

function off() {
    deactivate
}

### docker
function cya() {
    docker rm -f $(docker ps -aq) 2>/dev/null && echo "All containers killed and removed" || echo "No containers found"
}

### media
function mp4() {
    local input_file="$1"
    local output_file="$2"

    if [ -z "$input_file" ]; then
        echo "Error: Input file is required"
        echo "Usage: mp4 input_file [output_file]"
        return 1
    fi

    if [ -z "$output_file" ]; then
        local base_name="${input_file%.*}"
        output_file="${base_name}.mp4"
    fi

    echo "Converting $input_file to $output_file..."
    ffmpeg -i "$input_file" -c:v libsvtav1 -crf 30 -preset 8 -c:a aac -movflags +faststart "$output_file"

    if [ $? -eq 0 ]; then
        echo "Conversion completed successfully"
        return 0
    else
        echo "Conversion failed"
        return 1
    fi
}

function gif() {
    local input_file="$1"
    local output_file="$2"

    if [ -t 1 ]; then
        yellow="\033[1;33m"
        red="\033[1;31m"
        cyan="\033[1;36m"
        reset="\033[0m"
    else
        yellow=""
        red=""
        cyan=""
        reset=""
    fi

    if [ -z "$input_file" ]; then
        echo -e "${yellow}Error: Input file is required${reset}" >&2
        echo -e "Easily convert a video to a gif using ffmpeg. This will optimize the color palette to" >&2
        echo -e "keep it looking good, and drop the framerate to 10fps to keep the file size down." >&2
        echo -e "${yellow}Usage: gif input_file [output_file]${reset}" >&2
        return 1
    fi

    if [ -z "$output_file" ]; then
        local base_name="${input_file%.*}"
        output_file="${base_name}.gif"
    fi

    if [ ! -f "$input_file" ]; then
        echo -e "${red}Error: Input file does not exist ${cyan}'$input_file'${reset}" >&2
        echo -e "${yellow}Usage: gif input_file [output_file]${reset}" >&2
        return 1
    fi

    echo "Converting $input_file to $output_file..."
    ffmpeg -i "$input_file" \
        -filter_complex "[0:v] fps=10,scale=640:-1:flags=lanczos,palettegen [p]; \
        [0:v] fps=10,scale=640:-1:flags=lanczos [x]; \
        [x][p] paletteuse" \
        "$output_file"

    if [ $? -eq 0 ]; then
        echo "Conversion completed successfully"
        return 0
    else
        echo "Conversion failed"
        return 1
    fi
}

### misc
function temp() {
    v temp.md
}

function vtemp() {
    v $FILES/temp.md
}

function rand() {
    openssl rand -base64 32
}

function dkcd() {
    dkdc "$@"
}

function dk() {
    dkdc "$@"
}

