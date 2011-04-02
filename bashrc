# .bashrc

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


# Alias definitions
# -----------------

alias banshee='XLIB_SKIP_ARGB_VISUALS=1 banshee-1'
alias acka='ack -a'
alias cdpr='cd ~/Projects'
alias siny='sudo /etc/rc.d/mysqld start && sudo /etc/rc.d/memcached start && sudo /etc/rc.d/nginx start'
alias sps='sudo service postgresql start'
alias sapache='sudo service httpd start start'

alias cduuprod='cd ~/Projects/inyoka/inyoka-staging && workon uuprod && source init.sh'
alias cdiny='cd ~/Projects/inyoka/inyoka-sandbox && source ../bin/activate'

alias gitl='git log --pretty=format:"%h %s" --graph'

# convert permissions to octal - http://www.shell-fu.org/lister.php?id=205
alias lo='ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g''

# get an ordered list of subdirectory sizes - http://www.shell-fu.org/lister.php?id=275
alias dux='du -sk ./* | sort -n | awk '\''BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1000 ) { x = (x + 1023)/1000; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1000 ) { total = (total + 1000)/1000; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'\'''

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
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'

# "last as root"
alias lr='su -c "$(history | tail -n 2 | head -n 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")"'

# enable color support of ls and also add handy aliases
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -halG'

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
    [[ -n $URL ]] && firefox $URL || echo "No BitBucket path found!"
}

exip () {
    # gather external ip address
    echo -n "Current External IP: "
    curl -s -m 5 http://myip.dk | grep "ha4" | sed -e 's/<b>IP Address:<\/b> <span class="ha4">//g' -e 's/<\/span><br \/><br \/>//g'
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

  # BROKEN!
  git_dir() {
    [ -d ".git" ] || return 1
    ref=$(git describe --tags 2>/dev/null || git describe --all 2>/dev/null)
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
    ref=$(< "${base_dir}/.hg/branch")
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

export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

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
