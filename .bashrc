
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
    local EXIT="$?"
    PS1="\n"

    # prepend errno if it exists
    if [ $EXIT != 0 ]; then
        PS1+="\[\e[1;31m\]$EXIT\[\e[m\] "
    fi

    # working directory with paths shortened to two characters and $HOME replaced with '~'
    local SHORT_PATH=$(echo "$PWD" | sed -E -e 's|'$HOME'|~|' -e 's|/(..)[^/]*|/\1|g')

    # currrent git branch and dirty state
    local GIT_PS1=$(__git_ps1 " (%s)")

    local RESET="\[\e[m\]"
    local CYAN="\[\e[36m\]"
    local GREEN="\[\e[32m\]"
    local YELLOW="\[\e[33;1m\]"

    PS1+="$CYAN\u$RESET@$GREEN\h $YELLOW$SHORT_PATH$GIT_PS1$RESET\n\$ "
}
