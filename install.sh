#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "==> Setting up $OS from $DOTFILES"

# ─── Packages ────────────────────────────────────────────────────────────────

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        echo "==> Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    export PATH="/opt/homebrew/bin:$PATH"

    echo "==> Installing brew packages..."
    brew install neovim node git python3 tldr tmux ripgrep gh fzf zoxide just luarocks jq
    brew install --cask font-jetbrains-mono-nerd-font
    brew install font-awesome
    # clangd ships with the Xcode command line tools.
    xcode-select -p &>/dev/null || xcode-select --install
else
    echo "==> Installing apt packages..."
    sudo apt-get update
    sudo apt-get install -y curl git python3 tldr tmux ripgrep gh fzf zoxide just luarocks jq clangd
    # Skip if node came from elsewhere (e.g. NodeSource), whose nodejs conflicts with apt's npm.
    command -v npm &>/dev/null || sudo apt-get install -y nodejs npm

    # apt's neovim lags too far behind for the plugins, so use the release build.
    echo "==> Installing Neovim..."
    case "$(uname -m)" in
        x86_64)        NVIM_ARCH=x86_64 ;;
        aarch64|arm64) NVIM_ARCH=arm64 ;;
    esac
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$NVIM_ARCH.tar.gz" \
        | sudo tar -xz -C /opt
    sudo ln -sf "/opt/nvim-linux-$NVIM_ARCH/bin/nvim" /usr/local/bin/nvim
fi

# ─── Rust ────────────────────────────────────────────────────────────────────

if ! command -v rustup &>/dev/null; then
    echo "==> Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
. "$HOME/.cargo/env"
rustup component add rust-analyzer
command -v tokei &>/dev/null || cargo install tokei

# ─── Language servers ────────────────────────────────────────────────────────

echo "==> Installing language servers..."
NPM_SUDO=""
[ -w "$(npm config get prefix)/lib" ] || NPM_SUDO="sudo"
$NPM_SUDO npm install -g pyright typescript typescript-language-server

# ─── Oh My Zsh ───────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

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
link "$DOTFILES/.claude/statusline.sh" "$HOME/.claude/statusline.sh"
if [ "$(uname)" = "Darwin" ]; then
    link "$DOTFILES/iterm/tmux-profile.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/tmux-profile.json"
    # iTerm2 loads all its settings from iterm/com.googlecode.iterm2.plist on next launch.
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

# ─── Claude Code status line ────────────────────────────────────────────────

# Only the script is symlinked above. settings.json stays a real file because
# Claude Code rewrites it itself (/config, plugin toggles), so the statusLine
# block is merged in instead — preserving whatever else is already there.
echo "==> Registering Claude Code status line..."
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
jq '.statusLine = {
      "type": "command",
      "command": "~/.claude/statusline.sh",
      "refreshInterval": 30
    }' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp" \
  && mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"

# ─── Git config ──────────────────────────────────────────────────────────────

git config --global core.excludesFile "$HOME/.gitignore"

# ─── Tmux Plugin Manager ────────────────────────────────────────────────────

if [ ! -d "$DOTFILES/.tmux/plugins/tpm" ]; then
    echo "==> Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$DOTFILES/.tmux/plugins/tpm"
fi

# ─── Neovim plugins ─────────────────────────────────────────────────────────

echo "==> Installing Neovim plugins..."
nvim --headless "+Lazy! restore" +qa

# ─── Secrets template ───────────────────────────────────────────────────────

if [ ! -f "$HOME/.zshrc_secret" ]; then
    cp "$DOTFILES/.zshrc_secret_template" "$HOME/.zshrc_secret"
    echo "==> Created ~/.zshrc_secret from template — edit it with your secrets"
fi

# ─── Crontab ─────────────────────────────────────────────────────────────────

# The only job runs repo-sync.sh from hark-dotfiles. macOS runs it from a
# LaunchAgent instead, since cron there cannot reach the keychain.
if [ "$OS" = "Linux" ] && [ -e "$HOME/.local/bin/repo-sync.sh" ]; then
    crontab "$DOTFILES/cron-jobs.txt"
else
    echo "==> Skipping crontab: macOS, or ~/.local/bin/repo-sync.sh not linked"
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo "==> Done! Remaining manual steps:"
echo "  1. Restart your terminal (or: source ~/.zshrc)"
echo "  2. In tmux, press prefix + I to install tmux plugins"
echo "  3. Run: gh auth login"
