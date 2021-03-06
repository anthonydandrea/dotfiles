# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#if [ -f ~/.scripts/get_aliases.sh ]; then
    #. ~/.scripts/get_aliases.sh
#fi

export TERM=rxvt
export DOTFILES=~/.dotfiles
export EDITOR=vim

export SCRIPTS=~/.scripts
export CONFIGS=~/.config
export EC2_HOST=ubuntu@ec2-3-15-69-235.us-east-2.compute.amazonaws.com
export ITE_SERVER=aed14008@137.99.3.177
export HPC_SERVER=aed14008@login.storrs.hpc.uconn.edu
export GOOGLE_APPLICATION_CREDENTIALS="/home/anthonyd/MetPro34/MetPro34-35b3fe3237f2.json"


alias la="ls -a"
alias edit-i3="vim $CONFIGS/i3/config"
alias edit-polybar="vim $CONFIGS/polybar/config"
alias set-resolution="$SCRIPTS/resolution/set_resolution.sh"
alias clear="echo -ne '\033c'"
alias goodnight="poweroff"
alias edit-login="vim /etc/alternatives/gdm3.css"
alias find-networks="nmcli d wifi list"
alias connect-to-network="$SCRIPTS/network/connect_to_network.sh"
alias audio-settings="blueman-manager & pavucontrol"
alias all-alias="alias | awk -F'[ =]' '{print ${2}}'"
alias lock="sudo pm-suspend && i3lock"
alias matlab="~/Matlab/bin/matlab &"
alias vscode="code"
alias rubymine="/bin/RubyMine*/bin/rubymine.sh"
alias android-studio="~/android-studio/bin/studio.sh"

alias ec2="ssh -i ~/CadetsPercussion.com/ec2.pem ubuntu@ec2-3-15-69-235.us-east-2.compute.amazonaws.com"
alias gcloud-ssh-db="gcloud compute ssh --project absolute-bot-264323 --zone us-east4-c  metpro34-db-vm"
alias hpc="ssh aed14008@login.storrs.hpc.uconn.edu"
alias ite-server="ssh aed14008@137.99.3.177"
alias pi="ssh pi@192.168.1.104"
alias mon2="/home/anthonyd/.scripts/polybar/launch_polybar.sh DP-1"
alias uconn-vpn="/usr/local/pulse/pulsesvc -h vpn.uconn.edu -u aed14008 -r UConn"
alias runelite="flatpak run net.runelite.RuneLite/x86_64/stable"
alias gcloud="/usr/bin/gcloud"
alias fix-dummy-output-audio="pulseaudio -k && sudo alsa force-reload"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/anthonyd/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/anthonyd/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/anthonyd/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/anthonyd/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source /usr/share/rvm/scripts/rvm

#export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-11"
#export PATH=$JAVA_HOME/bin:$PATH

source /etc/profile.d/gradle.sh
export PATH=/home/anthonyd/Android/Sdk/tools:/home/anthonyd/Android/Sdk/platform-tools:$PATH

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PERSONAL_ACCESS_TOKEN=d3540d63cdb87d783b74fc1de3ef957c16539824fbc36ee58a58130c08096f63


