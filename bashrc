# .bashrc

export PATH=/usr/local/share/python:/usr/local/bin:$PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# sudo completion
complete -cf sudo

# set PATH so it includes user's private bin if it exists
if [ -d ~/.bin ] ; then
    PATH=~/.bin:"${PATH}"
fi

if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

if [ -d /usr/sbin ] ; then
	PATH=/usr/sbin:"${PATH}"
fi

if [ -d ~/.local/bin ]; then
	PATH=~/.local/bin:"${PATH}"
fi

if [ -d ~/bin/Sencha/Cmd/3.0.0.250/sencha ]; then
    PATH=~/bin/Sencha/Cmd/3.0.0.250/sencha:"${PATH}"
fi

[ -d /usr/bin/site_perl ] && PATH=$PATH:/usr/bin/site_perl
[ -d /usr/lib/perl5/site_perl/bin ] && PATH=$PATH:/usr/lib/perl5/site_perl/bin

[ -d /usr/bin/vendor_perl ] && PATH=$PATH:/usr/bin/vendor_perl
[ -d /usr/lib/perl5/vendor_perl/bin ] && PATH=$PATH:/usr/lib/perl5/vendor_perl/bin

[ -d /usr/bin/core_perl ] && PATH=$PATH:/usr/bin/core_perl

#RUBY_GEM=$(ruby -rubygems -e "puts Gem.user_dir")/bin
#
#if [ -d $RUBY_GEM ]; then
#    PATH=$RUBY_GEM:"${PATH}"
#fi

PATH=~/.gem/ruby/2.0.0/bin:"${PATH}"
PATH=/usr/lib/ruby/gems/2.0.0:"${PATH}"


if [ -d /usr/local/heroku/bin ]; then
    PATH=/usr/local/heroku/bin:"${PATH}"
fi


# Global environment definitions
# ------------------------------

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# export vim as our editor
export EDITOR="vim"

# integrate with ksshaskpass
if [ -f "/usr/bin/ksshaskpass" ]; then
    export SSH_ASKPASS="/usr/bin/ksshaskpass"
fi

export HISTCONTROL=erasedups # Ignore duplicate entries in history
export HISTSIZE=10000 # Increases size of history
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"
shopt -s histappend # Append history instead of overwriting
shopt -s cdspell # Correct minor spelling errors in cd command
shopt -s dotglob # includes dotfiles in pathname expansion
shopt -s checkwinsize # If window size changes, redraw contents
shopt -s cmdhist # Multiline commands are a single command in history.
shopt -s extglob # Allows basic regexps in bash.
set ignoreeof on # Typing EOF (CTRL+D) will not exit interactive sessions

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# External config
[[ -r ~/.dircolors && -x /usr/bin/dircolors ]] && eval $(dircolors -b ~/.dircolors)
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -z $BASH_COMPLETION && -r /etc/bash_completion ]] && . /etc/bash_completion

# Some history hacking
[[ "${PROMPT_COMMAND}" ]] && PROMPT_COMMAND="$PROMPT_COMMAND;history -a" || PROMPT_COMMAND="history -a"

# Alias definitions
# -----------------

alias acka='ag -a'
alias cdpr='cd ~/Projects'

# Shortcuts for some OpenSource projects
alias cdustaging='cd ~/Projects/inyoka/inyoka-staging'
alias cdiny='cd ~/Projects/inyoka/inyoka-sandbox'

# Shortcuts for my daily work
alias cdnu='cd ~/Projects/native/native.uranos'
alias cdnt='cd ~/Projects/native/native.triton'
alias cdsdbs='cd ~/Projects/native/sdbs2'

# Git related shortcuts
alias gitl='git log --pretty=format:"%h %s" --graph'

# convert permissions to octal - http://www.shell-fu.org/lister.php?id=205
alias lo='ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g''

# get an ordered list of subdirectory sizes
alias dux='du -skh ./* | sort -h | grep -v total && du -cskh ./* | grep --color=never total'

alias ..='cd ..' # Go up one directory
alias ...='cd ../..' # Go up two directories
alias l='ls -lah' # Long view, show hidden
alias la='ls -AF' # Compact view, show hidden
alias ll='ls -lFh' # Long view, no hidden
alias fwrab='ssh -L 55672:localhost:55672 apollo13@eshu'

# Helpers
alias grep='grep --color=auto' # Always highlight grep search term
alias ping='ping -c 5' # Pings with 5 packets, not unlimited
alias df='df -h' # Disk free, in gigabytes, not bytes
alias du='du -h -c' # Calculate total disk usage for a folder

# Nifty extras
alias servethis="python2 -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias clr='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."'
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'
alias xo='xdg-open'
alias wtc="curl --silent 'http://whatthecommit.com/index.txt'"

# "last as root"
alias lr='su -c "$(history | tail -n 2 | head -n 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")"'

# enable color support of ls and also add handy aliases
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -halG'
alias fl='foreman start --procfile=Procfile.local'
alias ssu='./Projects/sshuttle/sshuttle --dns -vvr webshox 0/0'
alias ipy='python -c "import IPython; IPython.embed()"'
alias t='task'
alias tw='task list +work'
alias toli='task list +oli'
alias jpp='python -mjson.tool'
alias git='hub'
alias pcire='sudo sh -c "echo  1 > /sys/bus/pci/rescan"'
alias cdpap='cd ~/Projects/paperc'

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
    curl -s -m 5 http://myip.dk | grep "ha4" | sed -e 's/<b>IP Address:<\/b> <span class="ha4">//g' -e 's/<\/span><br \/><br \/>//g'
}


lsmod() {
  {
    echo "Module Size Ref UsedBy Stat Address"
    cat /proc/modules
  } | column -t
}


# Virtual Python Environment, VCS and Fancy Promt
# -----------------------------------------------

# Advanced VCS information in bash
__vcs_dir() {
  local vcs base_dir sub_dir ref
  sub_dir() {
    local sub_dir
    sub_dir=$(readlink -f "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }

  git_dir() {
    base_dir="."
    while [ ! -d "$base_dir/.git" ]; do base_dir="$base_dir/.."; [ $(readlink -f "${base_dir}") = "/" ] && return 1; done
    base_dir=$(readlink -f "$base_dir")
    sub_dir=$(sub_dir "${base_dir}")
    ref=$(git describe --all 2>/dev/null)
    vcs="git"
  }

  svn_dir() {
    [ -d ".svn" ] || return 1
    base_dir="."
    while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
    base_dir=$(readlink -f "$base_dir")
    sub_dir=$(sub_dir "${base_dir}")
    ref=$(svn info "$base_dir" | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print r":"$0 }')
    vcs="svn"
  }

  hg_dir() {
    base_dir="."
    while [ ! -d "$base_dir/.hg" ]; do base_dir="$base_dir/.."; [ $(readlink -f "${base_dir}") = "/" ] && return 1; done
    base_dir=$(readlink -f "$base_dir")
    sub_dir=$(sub_dir "${base_dir}")
    ref=$(hg branch)
    vcs="hg"
  }

  svn_dir ||
  git_dir ||
  hg_dir ||
  base_dir="$PWD"

  echo "${vcs:+($vcs $ref)}"
}

# Export the promt with advanced vcs information
export PS1='\[\e[33;1m\]$(__vcs_dir)\[\e[0m\] \[\e[32;1m\]\w> \[\e[0m\]'

# Automatic virtualenv activation based on .venv config file with
# hook integration.
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper_lazy.sh

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


export PATH=/home/ente/bin/Sencha/Cmd/3.0.0.250:$PATH

export SENCHA_CMD_3_0_0="/tmp/packerbuild-1000/sencha-cmd/sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/3.1.2.342"

export PATH=/tmp/packerbuild-1000/sencha-cmd/sencha-cmd/pkg/opt/Sencha/Cmd/3.0.0.250:$PATH


export PATH=/home/ente/Downloads/dart-sdk/bin:$PATH

export PATH=/tmp/packerbuild-1000/sencha-cmd/sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/3.1.2.342:$PATH

export PATH=/opt/android-sdk/tools:$PATH

export PATH=/opt/android-sdk/platform-tools/:$PATH

export ANDROID_NDK_ROOT=/opt/android-ndk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_NDK_ROOT:$ANDROID_SDK_ROOT:$PATH
export ANDROID_HOME=$ANDROID_SDK_ROOT
