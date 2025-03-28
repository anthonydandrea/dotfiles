# Don't share shell history in different tmux panes
setopt noincappendhistory
setopt nosharehistory


# OhMyZsh setup
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="af-magic"
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 28 # check for updates every 4 weeks
DISABLE_AUTO_UPDATE=true # Disable auto update of oh-my-zsh
plugins=(gitfast zsh-autosuggestions zsh-syntax-highlighting)
export ZVM_VI_ESCAPE_BINDKEY=jj
source $ZSH/oh-my-zsh.sh # Must source after plugins declaration


# Environment
export EDITOR='nvim'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND="rg --files -i"
export HISTCONTROL=ignoreboth:erasedups
export PATH=$HOME/.toolbox/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=/Users/anthonydandrea/Library/Android/sdk/platform-tools/:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin:$PATH


function latest_docker_image_id() {
    echo $(docker images | awk '{print $3}' | awk 'NR==2')
}

alias big="ls -lSh 2>/dev/null | grep ^- | head -${1:-10}"
alias cd="z"
alias cdi="zi"
alias dockerrun='docker run -i -t'
alias dockerrunlatest='dockerrun $(latest_docker_image_id)'
alias ft="find . -name '*' -exec cat {} \; | grep"
alias gacp='git add . && git commit -m "Updates" && git push'
alias gb='git branch | fzf | xargs git checkout'
alias gca='git commit --amend'
alias gd="git diff -- . ':(exclude)package-lock.json'"
alias gds='git diff --staged'
alias gp='git pull'
alias gs='git status'
alias h="history"
alias here="pwd | xargs -I {} echo $(whoami)@$(hostname):{}"
alias pd='pushd ~/Repos/dotfiles/ && git pull && source ~/.zshrc && popd'
alias python='python3'
alias restart-audio="sudo pkill coreaudiod"
alias rust="evcxr"
alias s="source ~/.zshrc && source ~/.zshrc.aws &> /dev/null || true"
alias save-dots='sd'
alias sd='pushd ~/Repos/dotfiles/ && git stash && git pull && git stash pop && git add . || true && git commit -m "updates" || true && git push || true && popd'
alias server="python3 -m http.server"
alias tmuxa='tmux a'
alias tmuxd='tmux detach'
alias tmuxk='tmux kill-session -t'
alias tmuxka='tmux kill-server'
alias tmuxn='tmux new -s'
alias vc="vim ~/.vimrc"
alias vim="nvim"
alias vo="nvim ."

if [ -f '/Users/anthonydandrea/.zshrc.meta' ]; then
    source ~/.zshrc.meta
fi
if [ -f '/Users/anthonydandrea/.zshrc_secret' ]; then
    source ~/.zshrc_secret
fi

eval "$(zoxide init zsh)"

clear

# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false

export AWS_EC2_METADATA_DISABLED=true


# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/emulator:${ANDROID_SDK}/tools:${ANDROID_SDK}/tools/bin:${ANDROID_SDK}/platform-tools
