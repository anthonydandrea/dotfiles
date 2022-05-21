# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin/flutter/bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="awesomepanda"
DISABLE_UPDATE_PROMPT="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias restart-audio="sudo pkill coreaudiod"
alias vim="nvim"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON=/usr/bin/python 

clear
