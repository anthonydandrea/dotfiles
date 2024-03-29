# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:/Users/anthonydandrea/Library/Android/sdk/platform-tools/

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export HISTCONTROL=ignoreboth:erasedups

export ZSH_THEME="awesomepanda"
# DISABLE_UPDATE_PROMPT="true"
zstyle ':omz:update' mode reminder
# check for updates every 2 weeks
zstyle ':omz:update' frequency 14


export FZF_DEFAULT_COMMAND="rg --files -i"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR='nvim'
# export TERM=tmux-256color
#command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

plugins=(git gitfast zsh-autosuggestions)

# Load all of the plugins that were defined in ~/.zshrc
# for plugin ($plugins); do
#   start=$SECONDS
#   if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
#     source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
#   elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
#     source $ZSH/plugins/$plugin/$plugin.plugin.zsh
#   fi
#   duration=$(( SECONDS - start ))
#   echo $duration":" $plugin
# done


# Disable auto update of oh-my-zsh
DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

# Tmux aliases
alias tmuxk='tmux kill-session -t'
alias tmuxka='tmux kill-server'
alias tmuxn='tmux new -s'
alias tmuxa='tmux attach-session -t'
alias tmuxd='tmux detach'

# Docker
alias dockerrun='docker run -i -t'

function latest_docker_image_id() {
    echo $(docker images | awk '{print $3}' | awk 'NR==2')
}
alias dockerrunlatest='dockerrun $(latest_docker_image_id)'

# Git aliases
alias gs='git status'
alias gb='git branch | fzf | xargs git checkout'
alias gd="git diff -- . ':(exclude)package-lock.json'"
alias gds='git diff --staged'
alias gca='git commit --amend'
alias gp='git pull'

alias ft="find . -name '*' -exec cat {} \; | grep"
alias python='python3'
alias restart-audio="sudo pkill coreaudiod"
alias sd='pushd ~/Repos/dotfiles/ && git stash && git pull && git stash pop && git add . || true && git commit -m "updates" || true && git push || true && popd'
alias pd='pushd ~/Repos/dotfiles/ && git pull && source ~/.zshrc && popd'
alias save-dots='sd'
alias vim="nvim"
# "vim open"
alias vo="nvim ."
alias vc="vim ~/.vimrc"
alias h="history"
alias s="source ~/.zshrc && source ~/.zshrc.aws &> /dev/null || true"
alias server="python3 -m http.server"

#alias here="echo $(whoami)@$(hostname):$(pwd)"
alias here="pwd | xargs -I {} echo $(whoami)@$(hostname):{}"

alias metpro-db="mongosh "mongodb+srv://metpro34-db-instance.vignm.mongodb.net/myFirstDatabase" --apiVersion 1 --username metpro34-db-user"
alias mp="pushd ~/Repos/MetPro34"

export CLOUDSDK_PYTHON=/usr/local/bin/python3

# export SPARK_HOME=/opt/spark
# export PATH=$$SPARK_HOME/bin

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

if [ -f '/Users/anthdand/.zshrc.aws' ] || [ -f '/home/anthdand/.zshrc.aws' ]; then
    source ~/.zshrc.aws
fi
if [ -f '/Users/anthonydandrea/.zshrc_secret' ]; then
    source ~/.zshrc_secret
fi
clear


export AWS_EC2_METADATA_DISABLED=true

# Don't share shell history in different tmux panes
setopt noincappendhistory
setopt nosharehistory


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/anthonydandrea/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/anthonydandrea/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/anthonydandrea/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/anthonydandrea/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/anthonydandrea/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/anthonydandrea/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/anthonydandrea/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/anthonydandrea/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Added by Amplify CLI binary installer
export PATH="/usr/local/bin/:$PATH:$HOME/.amplify/bin:/Users/anthonydandrea/Library/Python/3.11/lib/python/site-packages"
# source /Users/anthdand/.brazil_completion/zsh_completion
