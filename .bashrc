# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [[ "$TERM" != screen* ]]
then
    export TERM=xterm-256color
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export HISTFILESIZE=40000
export HISTSIZE=40000
export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] "
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_colored_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
#fi
unset color_prompt force_color_prompt

parse_git_branch() {
    git branch 2> /dev/null | perl -lanE 'if (/^\* (.*)/) { $b=$1; $b=~s/^(.{20}).+/$1.../; say "[$b]"; }'
}

export PS1='\[\e[32;1m\]\u@${debian_chroot:+($debian_chroot)}\h\[\e[0m\]:\[\e[36;1m\]\W\[\e[0m\]\[\e[1;35m\]$( [ $? == 0 ] && echo "☺"  || echo "☹" )\[\e[31;1m\] $(parse_git_branch)\$\[\e[0m\] '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias now='date +%s --date "now"'
alias ..='cd ..'
alias -- -='cd -'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# host-specific stuff here
if [ -f $HOME/.rc.local ]; then
    . $HOME/.rc.local
fi

# custom functions
md() {
    mkdir -p "$*" && cd "$*"
}
hx() {
    hexdump -e '20/1 "%02X ""\n"" "' -e '20/1 "%c  ""\n"'
}
pgw() {
    ping $( ip route list 0/0 | awk '{ print $3 }' )
}
grefresh() {
    local cur_branch=$(git branch | awk '/^\*/ {print$2}')
    (git checkout master && git pull && git checkout $cur_branch) > /dev/null
}

keychain id_rsa id_dsa
[ -f $HOME/.keychain/$HOSTNAME-sh ] && \
    source $HOME/.keychain/$HOSTNAME-sh

vnstat -d | head -5; vnstat -d | tail -9
export PATH=~/.rakudobrew/bin:$PATH
