# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin/flutter/bin:$HOME/.cargo/bin:/lib

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh


ZSH_THEME="awesomepanda"
DISABLE_UPDATE_PROMPT="true"

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR='nvim'
# export TERM=tmux-256color
#command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

plugins=(git)


# Disable auto update of oh-my-zsh
DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

# Tmux aliases
alias tmuxk='tmux kill-session -t'
alias tmuxka='tmux kill-server'
alias tmuxn='tmux new -s'

# Docker
alias dockerrun='docker run -i -t'

function latest_docker_image_id() {
    echo $(docker images | awk '{print $3}' | awk 'NR==2')
}
alias dockerrunlatest='dockerrun $(latest_docker_image_id)'

# Git aliases
alias gs='git status'
alias gb='git branch | fzf | xargs git checkout'
alias gd='git diff'
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
alias h="history"
alias s="source ~/.zshrc && source ~/.zshrc.aws &> /dev/null || true"

#alias here="echo $(whoami)@$(hostname):$(pwd)"
alias here="pwd | xargs -I {} echo $(whoami)@$(hostname):{}"

alias metpro-db="mongosh "mongodb+srv://metpro34-db-instance.vignm.mongodb.net/myFirstDatabase" --apiVersion 1 --username metpro34-db-user"
alias mp="pushd ~/Repos/MetPro34"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON=/usr/local/bin/python3

if [ -f '/Users/anthdand/.zshrc.aws' ] || [ -f '/home/anthdand/.zshrc.aws' ]; then
    source ~/.zshrc.aws
fi
clear


export AWS_EC2_METADATA_DISABLED=true

