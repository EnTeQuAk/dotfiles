# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Bash Completion
# ===============

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# sudo completion
complete -cf sudo

if [ -e "$HOME/.git-completion.bash" ]; then
  source "$HOME/.git-completion.bash"
fi

# Include custom 
export PATH=/usr/local/share/python:/usr/local/bin:$PATH


# PATH modifications
# ==================

if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# Support for local ruby gems
RUBY_GEM=$(ruby -rubygems -e "puts Gem.user_dir")/bin

if [ -d $RUBY_GEM ]; then
    PATH=$RUBY_GEM:"${PATH}"
fi

PATH="${RUBY_GEM}/bin":"${PATH}"

export PATH=/opt/android-sdk/tools:$PATH

export PATH=/opt/android-sdk/platform-tools/:$PATH

export ANDROID_NDK_ROOT=/opt/android-ndk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_NDK_ROOT:$ANDROID_SDK_ROOT:$PATH
export ANDROID_HOME=$ANDROID_SDK_ROOT


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
set ignoreeof on # Typing EOF (CTRL+D) will not exit interactive sessions

# export subl as our editor
export EDITOR="subl"

# integrate with ksshaskpass
if [ -f "/usr/bin/ksshaskpass" ]; then
    export SSH_ASKPASS="/usr/bin/ksshaskpass"
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# More search tools in bash
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward


# Alias definitions
# -----------------

alias acka='ag -a'
alias aga='ag -a'
alias cdpr='cd ~/Projects'

# convert permissions to octal - http://www.shell-fu.org/lister.php?id=205
alias lo='ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g''

# get an ordered list of subdirectory sizes
alias dux='du -skh ./* | sort -h | grep -v total && du -cskh ./* | grep --color=never total'

alias ..='cd ..' # Go up one directory
alias ...='cd ../..' # Go up two directories
alias l='ls -lah' # Long view, show hidden
alias la='ls -AF' # Compact view, show hidden
alias ll='ls -lFh' # Long view, no hidden

# Helpers
alias grep='grep --color=auto' # Always highlight grep search term
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

# enable color support of ls and also add handy aliases
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -halG'
alias ipy='python -c "import IPython; IPython.embed()"'
alias jpp='python -mjson.tool'
alias git='hub'


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
    vcprompt -f "[%n:%b%m] "
}

# Export the promt with advanced vcs information
export PS1='\[\e[33;1m\]$(_vcprompt)\[\e[0m\]\[\e[32;1m\]\w> \[\e[0m\]'



# Automatic virtualenv activation based on .venv config file with
# hook integration.
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper_lazy.sh
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENV_USE_DISTRIBUTE=1
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# Python development
export PYTHONDONTWRITEBYTECODE=1
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
            fi
        fi
        if [ -f "$PROJECT_ROOT/.venv_hook" ]; then
            source "$PROJECT_ROOT/.venv_hook"
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    cd "$@" && workon_cwd
}

alias cd="venv_cd"
