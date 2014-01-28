
env=~/.ssh/agent.env

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

# Start ssh-agent if it is not running

if ! agent_is_running; then
    agent_load_env
fi

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
