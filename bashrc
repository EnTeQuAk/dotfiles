# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# Bash Completion
# ===============

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# sudo completion
complete -cf sudo

if [ -e "$HOME/.git-completion.bash" ]; then
  source "$HOME/.git-completion.bash"
fi

# Include custom
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PATH=/usr/local/heroku/bin:$PATH


# PATH modifications
# ==================

if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

if [ -d ~/.local/bin ] ; then
    PATH=~/.local/bin:"${PATH}"
fi

# Support for local ruby gems
RUBY_GEM=$(ruby -e "puts Gem.user_dir")/bin

if [ -d $RUBY_GEM ]; then
    PATH=$RUBY_GEM:"${PATH}"
fi

alias subl="subl -n ."

export PATH=/usr/bin/site_perl/:$PATH

export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_NDK_ROOT:$ANDROID_SDK_ROOT:$PATH
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

if [ -d ${HOME}/Projects/homebrew ]; then
	export PATH=${HOME}/Projects/homebrew/bin:${PATH}
fi

export PATH=$(npm bin):$PATH
export PATH=$PATH:/usr/lib/node_modules/.bin/

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

if [ -d ${HOME}/.cargo/bin ]; then
    export PATH=${HOME}/.cargo/bin:${PATH}
fi

# Global environment definitions
# ==============================

# History control
# --------------

unset HISTFILESIZE
export HISTCONTROL=ignoredups # Ignore duplicate entries in history
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"
shopt -s histappend # Append history instead of overwriting
shopt -s cdspell # Correct minor spelling errors in cd command
shopt -s dotglob # includes dotfiles in pathname expansion
shopt -s checkwinsize # If window size changes, redraw contents
shopt -s cmdhist # Multiline commands are a single command in history.
shopt -s extglob # Allows basic regexps in bash.

export EDITOR="vim"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# Typing EOF (ctrl+d) will not exit interactive sessions
set ignoreeof on
export IGNOREEOF=1


export PYTHONDONTWRITEBYTECODE=1
export LESS=FRSX


export WINEARCH=win32


# Alias definitions
# -----------------

alias acka='ag -a'
alias aga='ag -a'
alias cdpr='cd ~/Projects'

# convert permissions to octal - http://www.shell-fu.org/lister.php?id=205
alias lo='ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g''

# get an ordered list of subdirectory sizes
alias dux='du -skh ./* | sort -h | grep -v total && du -cskh ./* | grep total'

if [ "$(uname)" == "Darwin" ]; then
    alias ls='ls -GF'
else
    alias ls='ls -F --color'
fi

alias ..='cd ..' # Go up one directory
alias ...='cd ../..' # Go up two directories

alias l='ls -lah' # Long view, show hidden
alias la='ls -AF' # Compact view, show hidden
alias ll='ls -lFh' # Long view, no hidden

# Helpers
alias grep='grep' # Always highlight grep search term
#alias ping='ping -c 5' # Pings with 5 packets, not unlimited
alias df='df -h' # Disk free, in gigabytes, not bytes
alias du='du -h -c' # Calculate total disk usage for a folder

# Nifty extras
alias clr='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'
alias xo='xdg-open'
alias wtc="curl --silent 'http://whatthecommit.com/index.txt'"

# "last as root"
alias lr='su -c "$(history | tail -n 2 | head -n 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")"'

alias grep='grep'
alias fgrep='fgrep'
alias egrep='egrep'
alias ll='ls -halG'
alias ipy='python -c "import IPython; IPython.embed()"'
alias jpp='python -mjson.tool'
alias git='hub'
alias submod='subl $(git diff --name-only)'

# Git related shortcuts
alias gst='git st'
alias gci='git ci'
alias gco='git co'
alias gpu='git pu'
alias gbr='git br'
alias gdi='git diff'

# bash function to decompress archives - http://www.shell-fu.org/lister.php?id=375
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1;;
            *.tar.gz)    tar xvzf $1;;
            *.bz2)       bunzip2 $1;;
            *.rar)       unrar x $1;;
            *.gz)        gunzip $1;;
            *.tar)       tar xvf $1;;
            *.tbz2)      tar xvjf $1;;
            *.tgz)       tar xvzf $1;;
            *.zip)       unzip $1;;
            *.Z)         uncompress $1;;
            *.7z)        7za x $1;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# open up the bitbucket page for the current repository
bb() {
    local P="$(hg paths 2>/dev/null | grep 'bitbucket.org' | head -1)"
    local URL="$(echo $P | sed -e's|.*\(bitbucket.org.*\)|http://\1|')"
    [[ -n $URL ]] && firefox $URL || echo "No Bitbucket path found!"
}

# open up the github page for the current repository
gg() {
    local P="$(git remote -v 2>/dev/null | grep 'github.com' | head -1)"
    local URL="$(echo $P | sed -e's|.*\(github.com.*\)|http://\1|' | sed -e 's| (fetch)||' | sed -e 's|.com:|.com\/|' | sed -e 's|.git$||')"
    [[ -n $URL ]] && firefox $URL || echo "No GitHub path found!"
}

exip () {
    # gather external ip address
    echo -n "Current External IP: "
    curl -s -m 5 http://ipecho.net/plain
    echo
}


lsmod() {
  {
    echo "Module Size Ref UsedBy Stat Address"
    cat /proc/modules
  } | column -t
}


# Virtual Python Environment, VCS and Fancy Promt
# ===============================================

_vcprompt () {
    if [ "$VIRTUAL_ENV" ]; then
        out=$(vcprompt -f "[%n:%b%m ($(basename $VIRTUAL_ENV))] ")
    else
        out=$(vcprompt -f "[%n:%b%m] ")
    fi

    if [ "$out" == "" ]; then
        [[ -n "$VIRTUAL_ENV" ]] && echo "($(basename $VIRTUAL_ENV)) " || echo ""
    else
        echo "$out"
    fi
}


# Automatic virtualenv activation based on .venv config file with
# hook integration.
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export WORKON_HOME=$HOME/.virtualenvs
[ -r /usr/bin/virtualenvwrapper_lazy.sh  ] && . /usr/bin/virtualenvwrapper_lazy.sh
[ -r /usr/local/bin/virtualenvwrapper_lazy.sh  ] && . /usr/local/bin/virtualenvwrapper_lazy.sh

# For OSX with local homebrew
[ -r ~/Projects/homebrew/bin/virtualenvwrapper_lazy.sh  ] && . ~/Projects/homebrew/bin/virtualenvwrapper_lazy.sh

export VIRTUAL_ENV_DISABLE_PROMPT=1

export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# Python development
export PYTHONSTARTUP="$HOME/.pythonrc.py"


# Automatically a Projects virtual environments based on the
# directory name of the project. Virtual environment name will be identified
# by placing a .venv file in the project root with a virtualenv name in it.
# If a .venv_hook file exists it gets sourced.
function workon_cwd {
    if [ $? == 0 ]; then
        # Find the repo root and check for virtualenv name override
        PROJECT_ROOT=$(pwd)
        ENV_NAME="$(basename $(pwd))"
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"

                MANAGE_PY=$(find "$PROJECT_ROOT" -not -path '(*tox*|*.git*)' -name 'manage.py' -type f -print | head -n 1)
                if [ -e "$MANAGE_PY" ]
                then
                    alias django="python $MANAGE_PY"
                else
                    [ -n "`alias -p | grep '^alias django='`" ] && unalias django
                fi
           fi
           if [ -d "$PROJECT_ROOT/node_modules" ]; then
                export NODE_MODULES="$PROJECT_ROOT/node_modules"
                export PATH=$PROJECT_ROOT/node_modules/.bin:$PATH
           fi
        fi
        if [ -f "$PROJECT_ROOT/.venv_hook" ]; then
            source "$PROJECT_ROOT/.venv_hook"
        fi

    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
        [ -n "`alias -p | grep '^alias django='`" ] && unalias django
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    cd "$@" && workon_cwd
    history -a
}

alias cd="venv_cd"

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

from() { expect -c "spawn -noecho python
    expect \">>> \"
    send \"from $*\r\"
    interact +++ return"; }
    import() { expect -c "spawn -noecho python
    expect \">>> \"
    send \"import $*\r\"
    interact +++ return";
}


# Export the promt with advanced vcs information
export PS1='\[\e[33;1m\]$(_vcprompt)\[\e[0m\]\[\e[32;1m\]\w> \[\e[0m\]'

# integrate with ksshaskpass
if [ -f "/usr/bin/ksshaskpass" ]; then
    export SSH_ASKPASS="/usr/bin/ksshaskpass"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

export SPIDERMONKEY_INSTALLATION=~/.spidermonkey

gifify() {
    if [[ -n "$1" ]]; then
        ffmpeg -i $1 -r 20 -vcodec png out-static-%05d.png
        time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - >! $1.gif
        rm -f out-static*.png
    else
        echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
    fi
}

onmn() {
    echo "Next migration-number: $(ls src/olympia/migrations/ | cut -d '-' -f 1 | sort -rn | awk '{printf "%03d", $1 + 1; exit}')"
}

export PATH="/usr/local/sbin:$PATH"

# added by travis gem
[ -f /home/chris/.travis/travis.sh ] && source /home/chris/.travis/travis.sh
# source /usr/share/nvm/init-nvm.sh

export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin"  # Ditto.

export PATH="$HOME/.cargo/bin:$PATH"

source /usr/share/nvm/init-nvm.sh


export B2_ACCOUNT_ID=001e3682bee50b70000000001
export B2_ACCOUNT_KEY=K001XjGYEx14aoewSbL2z4hXGClfba4
