# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin/flutter/bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="awesomepanda"
DISABLE_UPDATE_PROMPT="true"

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR='nvim'
#command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

plugins=(git)

source $ZSH/oh-my-zsh.sh

NEWLINE=$'\n'
 
function prompt_my_midway() {
    if [[ ! -f ~/.midway/cookie ]] || (( $(grep "^#HttpOnly_midway-auth.amazon.com" ~/.midway/cookie | awk '{print $5}') < $(date +%s) ))
      then
          echo "%{$fg[red]%}Missing mwinit authentication"
      else
          echo "%{$fg[green]%}mwinit authenticated"
      fi
  }

 
 PROMPT='
 $(prompt_my_midway)
 ${ret_status}%{$fg_bold[green]%} %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}$(svn_prompt_info)%{$reset_color%}$ '

# Tmux aliases
alias tmuxk='tmux kill-session -t'
alias tmuxka='tmux kill-server'
alias tmuxn='tmux new -s'

# Git aliases
alias gs='git status'
alias gb='git branch | fzf | xargs git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gca='git commit --amend'

alias ft="find . -name '*' -exec cat {} \; | grep"
alias python='python3'
alias restart-audio="sudo pkill coreaudiod"
alias sd='pushd ~/Repos/dotfiles/ && git pull && git add . && git commit -m "updates" && git push && popd'
alias save-dots='sd'
alias vim="nvim"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/anthonydandrea/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON=/usr/bin/python 

clear
source ~/.bashrc
source ~/.zshrc.aws
