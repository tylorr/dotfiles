# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.

env=~/.ssh/agent.env

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

agent_is_running() {
    if [ "$SSH_AUTH_SOCK" ]; then
        # ssh-add returns:
        #   0 = agent running, has keys
        #   1 = agent running, no keys
        #   2 = agent not running
        ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
    else
        false
    fi
}

agent_has_keys() {
    ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
    . "$env" >/dev/null
}

agent_start() {
    (umask 077; ssh-agent >"$env")
    . "$env" >/dev/null
}

if ! agent_is_running; then
    agent_load_env
fi

# if your keys are not stored in ~/.ssh/id_rsa or ~/.ssh/id_dsa, you'll need
# to paste the proper path after ssh-add
if ! agent_is_running; then
    agent_start
    ssh-add
elif ! agent_has_keys; then
    ssh-add
fi

unset env

# Git prompt and completion

export GIT_PS1_SHOWDIRTYSTATE=1
source ~/.git-completion.bash
source ~/.git-prompt.sh

# Custom bash prompt

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local exit="$?"
    PS1="\n"

    # prepend errno if it exists
    if [ $exit != 0 ]; then
        PS1+="\[\e[1;31m\]$exit\[\e[m\] "
    fi

    # Working directory with $HOME replaced with ~
    local short_path=$(echo "$PWD" | sed -E 's|'$HOME'|~|')

    # Shorten dirnames to 2 characters if short_path length is greather than 20
    if [ ${#short_path} -gt 20 ]; then
        short_path=$(echo "$short_path" | sed -E 's|/(.[^/]{0,1})[^/]*|/\1|g')
    fi

    # currrent git branch and dirty state
    local git_ps1=$(__git_ps1 " (%s)")

    local default="\[\e[m\]"
    local cyan="\[\e[36m\]"
    local green="\[\e[32m\]"
    local yellow="\[\e[33;1m\]"

    # username@host working_dir (git_branch)
    # $
    PS1+="$cyan\u$default@$green\h $yellow$short_path$git_ps1$default\n\$ "
}


eval "$(fasd --init auto)"

. $(brew --prefix)/opt/fzf/shell/key-bindings.bash
export FZF_DEFAULT_COMMAND='fd --type f --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --color=never'

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse
  --bind ctrl-f:page-down,ctrl-b:page-up
'

fzf_find_edit() {
    local file=$(
      fzf --no-multi --preview 'bat --color=always --line-range :500 {}'
      )
    if [[ -n $file ]]; then
        $EDITOR $file
    fi
}

alias ffe='fzf_find_edit'

fzf_z() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

alias z="fzf_z"

fzf_v() {
  local file
  file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

alias v="fzf_v"

fzf_git_log() {
    local commits=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $commits ]]; then
        local hashes=$(printf "$commits" | cut -d' ' -f2 | tr '\n' ' ')
        git show $hashes
    fi
}

alias gll='fzf_git_log'

fzf_git_log_pickaxe() {
     if [[ $# == 0 ]]; then
         echo 'Error: search term was not provided.'
         return
     fi
     local commits=$(
       git log --oneline --color=always -S "$@" |
         fzf --ansi --no-sort --height 100% \
             --preview "git show --color=always {1}"
       )
     if [[ -n $commits ]]; then
         local hashes=$(printf "$commits" | cut -d' ' -f1 | tr '\n' ' ')
         git show $hashes
     fi
 }

alias pickaxe='fzf_git_log_pickaxe'

