#!/usr/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/anthdand/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install nvim
brew install node
brew install git
brew install python3
brew install tldr

sudo curl -L https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-macos.tar.gz -o /usr/local/nvim-macos.tar.gz
sudo xattr -c /usr/local/nvim-macos.tar.gz
sudo tar xzvf /usr/local/nvim-macos.tar.gz -C /usr/local/
sudo ln -s /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim

mkdir -p ~/.config/nvim
ln -s ~/Repos/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/Repos/dotfiles/.vimrc ~/.vimrc
ln -s ~/Repos/dotfiles/.gitignore ~/.gitignore
ln -s ~/Repos/dotfiles/.tmux.confg ~/.tmux.conf
ln -s ~/Repos/dotfiles/.tmux ~/.tmux
ln -s ~/Repos/dotfiles/.p10k.zsh ~/.p10k.zsh

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH_CUSTOM/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting




git config --global core.excludesFile '~/.gitignore'

# install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Dep for nvim-telescope
brew install ripgrep

# install tmux
brew install tmux

# install oh-my-zsh
       sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

       mkdir -p ~/.oh-my-zsh/custom/plugins/
       git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# install Github cli
       :exe 'edit '.stdpath('config').'/init.vim'

brew install gh
brew install fzf

# install neovim python module for python plugins
pip3 install neovim

# install rustup
curl https://sh.rustup.rs -sSf | sh

# zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zoxide
brew install zoxide


# Font installation
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font

curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Manual installs
       echo 'Download iTerm2 here: https://iterm2.com/downloads.html'
#echo 'Execute these for nvim: \
#1. To start the transition, create your init.vim (user config) file:\
#\
#:call mkdir(stdpath('config'), 'p')\
#:exe 'edit '.stdpath('config').'/init.vim'\
#\
#2. Add these contents to the file:\
#\
#set runtimepath^=~/.vim runtimepath+=~/.vim/after\
#let &packpath = &runtimepath\
#source ~/.vimrc'
       echo 'Login with gh cli: gh auth login'
       echo 'Install coc.nvim servers:  :CocInstall coc-json coc-tsserver coc-rust-analyzer coc-pyright coc-java'


# Run :Copilot setup in nvim to link account
