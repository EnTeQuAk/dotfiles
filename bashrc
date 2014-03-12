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
export PATH=/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH


# PATH modifications
# ==================

if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

if [ -d ~/.local/bin ] ; then
    PATH=~/.local/bin:"${PATH}"
fi

# Support for local ruby gems
RUBY_GEM=$(ruby -rubygems -e "puts Gem.user_dir")/bin

if [ -d $RUBY_GEM ]; then
    PATH=$RUBY_GEM:"${PATH}"
fi

PATH="${RUBY_GEM}/bin":"${PATH}"

export PATH=/opt/android-sdk/tools:$PATH

export PATH=/opt/android-sdk/platform-tools/:$PATH

export PATH=/usr/bin/site_perl/:$PATH

export ANDROID_NDK_ROOT=/opt/android-ndk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_NDK_ROOT:$ANDROID_SDK_ROOT:$PATH
export ANDROID_HOME=$ANDROID_SDK_ROOT

export PATH=$(npm bin):./node_modules/.bin:$PATH

if [ -d ./node_modules ]; then
    export NODE_MODULES="./node_modules"
fi


# Global environment definitions
# ==============================

# History control
# --------------

export HISTCONTROL=erasedups # Ignore duplicate entries in history
export HISTSIZE=1000000 # Increases size of history
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"
shopt -s histappend # Append history instead of overwriting
shopt -s cdspell # Correct minor spelling errors in cd command
shopt -s dotglob # includes dotfiles in pathname expansion
shopt -s checkwinsize # If window size changes, redraw contents
shopt -s cmdhist # Multiline commands are a single command in history.
shopt -s extglob # Allows basic regexps in bash.

# export subl as our editor
export EDITOR="vim"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# Typing EOF (ctrl+d) will not exit interactive sessions
set ignoreeof on
export IGNOREEOF=1


export PYTHONDONTWRITEBYTECODE=1
export LESS=FRSX


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
alias ping='ping -c 5' # Pings with 5 packets, not unlimited
alias df='df -h' # Disk free, in gigabytes, not bytes
alias du='du -h -c' # Calculate total disk usage for a folder

# Nifty extras
alias servethis="python2 -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias clr='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."'
alias pypath='python -c "import sys; print(sys.path)" | tr "," "\n" | grep -v "egg"'
alias py2path='python2 -c "import sys; print(sys.path)" | tr "," "\n" | grep -v "egg"'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'
alias xo='xdg-open'
alias wtc="curl --silent 'http://whatthecommit.com/index.txt'"
alias rvim="gvim --remote-silent"

# "last as root"
alias lr='su -c "$(history | tail -n 2 | head -n 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")"'

alias grep='grep'
alias fgrep='fgrep'
alias egrep='egrep'
alias ll='ls -halG'
alias ipy='python -c "import IPython; IPython.embed()"'
alias jpp='python -mjson.tool'
alias git='hub'
alias lintdiff='pylint $(git diff --name-only)'
alias submod='sub $(git diff --name-only)'


# Git related shortcuts
alias gst='git st'
alias gci='git ci'
alias gco='git co'
alias gpu='git pu'
alias gbr='git br'
alias gdi='git diff'

function sub() {
    subl3 -n . "$@";
}

alias subl='sub'


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
        ENV_NAME=$(basename $(pwd))
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"

                MANAGE_PY=$(find "$PROJECT_ROOT" -name "manage.py" -type f)
                if [ -e "$MANAGE_PY" ]
                then
                    alias django="python $MANAGE_PY"
                else
                    [ -n "`alias -p | grep '^alias django='`" ] && unalias django
                fi
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
interact +++ return"; }


# Export the promt with advanced vcs information
export PS1='\[\e[33;1m\]$(_vcprompt)\[\e[0m\]\[\e[32;1m\]\w> \[\e[0m\]'

export PIP_REQUIRE_VIRTUALENV=false

# integrate with ksshaskpass
if [ -f "/usr/bin/ksshaskpass" ]; then
    export SSH_ASKPASS="/usr/bin/ksshaskpass"
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi

# added by travis gem
[ -f /home/ente/.travis/travis.sh ] && source /home/ente/.travis/travis.sh

export PATH=/tmp/packerbuild-1000/sencha-cmd/sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/4.0.1.45:$PATH

export SENCHA_CMD_3_0_0="/tmp/packerbuild-1000/sencha-cmd/sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/4.0.1.45"
