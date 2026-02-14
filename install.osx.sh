#!/bin/bash
set -e

DOTFILES="$HOME/Repos/dotfiles"

echo "==> Setting up macOS from $DOTFILES"

# ─── Homebrew ────────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
export PATH="/opt/homebrew/bin:$PATH"

echo "==> Installing brew packages..."
brew install neovim node git python3 tldr tmux ripgrep gh fzf zoxide just luarocks
brew install --cask font-jetbrains-mono-nerd-font
brew install font-awesome

# ─── Rust ────────────────────────────────────────────────────────────────────

if ! command -v rustup &>/dev/null; then
    echo "==> Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
. "$HOME/.cargo/env"
cargo install tokei

# ─── Oh My Zsh ───────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ─── Symlinks ────────────────────────────────────────────────────────────────

echo "==> Creating symlinks..."

link() {
    local src="$1" dest="$2"
    if [ -L "$dest" ]; then
        echo "  Already linked: $dest"
    elif [ -e "$dest" ]; then
        echo "  Backing up:     $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
        ln -s "$src" "$dest"
    else
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        echo "  Linked:         $dest -> $src"
    fi
}

link "$DOTFILES/.zshrc"          "$HOME/.zshrc"
link "$DOTFILES/.vimrc"          "$HOME/.vimrc"
link "$DOTFILES/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES/.tmux"           "$HOME/.tmux"
link "$DOTFILES/.gitignore"      "$HOME/.gitignore"
link "$DOTFILES/.config/nvim"    "$HOME/.config/nvim"
link "$DOTFILES/bin"             "$HOME/bin"

# ─── Git config ──────────────────────────────────────────────────────────────

git config --global core.excludesFile "$HOME/.gitignore"

# ─── Tmux Plugin Manager ────────────────────────────────────────────────────

if [ ! -d "$DOTFILES/.tmux/plugins/tpm" ]; then
    echo "==> Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$DOTFILES/.tmux/plugins/tpm"
fi

# ─── Secrets template ───────────────────────────────────────────────────────

if [ ! -f "$HOME/.zshrc_secret" ]; then
    cp "$DOTFILES/.zshrc_secret_template" "$HOME/.zshrc_secret"
    echo "==> Created ~/.zshrc_secret from template — edit it with your secrets"
fi

# ─── Crontab ─────────────────────────────────────────────────────────────────

crontab "$DOTFILES/cron-jobs.txt"

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo "==> Done! Remaining manual steps:"
echo "  1. Restart your terminal (or: source ~/.zshrc)"
echo "  2. In tmux, press prefix + I to install tmux plugins"
echo "  3. Open nvim — plugins will auto-install on first launch"
echo "  4. Run: gh auth login"
