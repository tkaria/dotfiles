#!/bin/bash

# Dotfiles Setup Script
# This script will:
# 1. Detect your operating system
# 2. Backup existing dotfiles
# 3. Create symlinks to dotfiles in this repository
# 4. Install necessary tools and dependencies

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Print colored output
print_info() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Detect OS
detect_os() {
    print_info "Detecting operating system..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_success "Detected macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_success "Detected Linux"
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Backup existing dotfiles
backup_dotfiles() {
    print_info "Backing up existing dotfiles to $BACKUP_DIR..."

    mkdir -p "$BACKUP_DIR"

    local files=(".vimrc" ".zshrc" ".gitconfig")
    local backed_up=0

    for file in "${files[@]}"; do
        if [ -f "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
            mv "$HOME/$file" "$BACKUP_DIR/"
            print_success "Backed up $file"
            backed_up=$((backed_up + 1))
        fi
    done

    # Backup Ghostty config if it exists
    if [ -f "$HOME/.config/ghostty/config" ] || [ -L "$HOME/.config/ghostty/config" ]; then
        mkdir -p "$BACKUP_DIR/.config/ghostty"
        mv "$HOME/.config/ghostty/config" "$BACKUP_DIR/.config/ghostty/"
        print_success "Backed up .config/ghostty/config"
        backed_up=$((backed_up + 1))
    fi

    if [ $backed_up -eq 0 ]; then
        print_warning "No existing dotfiles found to backup"
        rmdir "$BACKUP_DIR"
    else
        print_success "Backed up $backed_up file(s)"
    fi
}

# Create symlinks
create_symlinks() {
    print_info "Creating symlinks..."

    local files=(".vimrc" ".zshrc" ".gitconfig")

    for file in "${files[@]}"; do
        if [ -f "$DOTFILES_DIR/$file" ]; then
            ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
            print_success "Linked $file"
        else
            print_warning "$file not found in $DOTFILES_DIR"
        fi
    done

    # Create Ghostty config symlink
    if [ -f "$DOTFILES_DIR/ghostty" ]; then
        mkdir -p "$HOME/.config/ghostty"
        ln -sf "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty/config"
        print_success "Linked .config/ghostty/config"
    fi
}

# Install dependencies for macOS
install_macos_deps() {
    print_info "Installing macOS dependencies..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == 'arm64' ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        print_success "Homebrew installed"
    else
        print_success "Homebrew already installed"
    fi

    # Install essential tools
    print_info "Installing essential tools via Homebrew..."
    brew install git vim zsh fzf ripgrep

    # Install NerdFonts
    print_info "Installing BlexMono Nerd Font..."
    if brew list --cask font-blex-mono-nerd-font &> /dev/null || \
       [ -f "$HOME/Library/Fonts/BlexMonoNerdFont-Regular.ttf" ] || \
       [ -f "/Library/Fonts/BlexMonoNerdFont-Regular.ttf" ]; then
        print_success "BlexMono Nerd Font already installed"
    else
        brew install --cask font-blex-mono-nerd-font
        print_success "BlexMono Nerd Font installed"
    fi

    # Install Ghostty terminal
    print_info "Installing Ghostty terminal..."
    if brew list --cask ghostty &> /dev/null || [ -d "/Applications/Ghostty.app" ]; then
        print_success "Ghostty already installed"
    else
        brew install --cask ghostty
        print_success "Ghostty installed"
    fi

    # Configure macOS settings
    print_info "Configuring macOS settings..."

    # Set faster key repeat
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    print_success "Set faster key repeat rates"
}

# Install dependencies for Linux
install_linux_deps() {
    print_info "Installing Linux dependencies..."

    # Detect package manager
    if command -v apt-get &> /dev/null; then
        print_info "Using apt package manager..."
        sudo apt-get update
        sudo apt-get install -y git vim zsh curl wget

        # Install fzf
        if [ ! -d "$HOME/.fzf" ]; then
            git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
            "$HOME/.fzf/install" --all
        fi

    elif command -v yum &> /dev/null; then
        print_info "Using yum package manager..."
        sudo yum install -y git vim zsh curl wget

    elif command -v pacman &> /dev/null; then
        print_info "Using pacman package manager..."
        sudo pacman -Sy --noconfirm git vim zsh curl wget fzf

    else
        print_warning "Unknown package manager. Please install git, vim, zsh, curl, wget manually."
    fi

    print_success "Essential tools installed"
}

# Install NerdFonts for Linux
install_nerdfonts_linux() {
    print_info "Installing BlexMono Nerd Font..."

    local fonts_dir="$HOME/.local/share/fonts"
    local font_name="BlexMono"

    # Create fonts directory if it doesn't exist
    mkdir -p "$fonts_dir"

    # Check if font is already installed
    if fc-list | grep -qi "blex"; then
        print_success "BlexMono Nerd Font already installed"
        return
    fi

    # Download and install BlexMono Nerd Font
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    print_info "Downloading BlexMono Nerd Font..."
    curl -fLo "${font_name}.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IBMPlexMono.zip

    print_info "Extracting fonts..."
    unzip -q "${font_name}.zip" -d "$fonts_dir"

    # Clean up
    cd - > /dev/null
    rm -rf "$temp_dir"

    # Refresh font cache
    print_info "Refreshing font cache..."
    fc-cache -fv > /dev/null 2>&1

    print_success "BlexMono Nerd Font installed"
    print_info "You may need to select the font in your terminal settings"
}

# Install oh-my-zsh
install_oh_my_zsh() {
    if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
        print_success "oh-my-zsh already installed"
        return
    fi

    print_info "Installing oh-my-zsh..."

    # Install oh-my-zsh non-interactively
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    print_success "oh-my-zsh installed"
}

# Install zsh plugins
install_zsh_plugins() {
    print_info "Installing zsh plugins..."

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "Installed zsh-autosuggestions"
    else
        print_success "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        print_success "Installed zsh-syntax-highlighting"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi

    # fast-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
        print_success "Installed fast-syntax-highlighting"
    else
        print_success "fast-syntax-highlighting already installed"
    fi

    # zsh-autocomplete
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
        git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"
        print_success "Installed zsh-autocomplete"
    else
        print_success "zsh-autocomplete already installed"
    fi
}

# Install vim-plug
install_vim_plug() {
    if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
        print_success "vim-plug already installed"
        return
    fi

    print_info "Installing vim-plug..."

    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    print_success "vim-plug installed"
    print_info "Run ':PlugInstall' in vim to install plugins"
}

# Set zsh as default shell
set_zsh_default() {
    if [ "$SHELL" = "$(which zsh)" ]; then
        print_success "zsh is already the default shell"
        return
    fi

    print_info "Setting zsh as default shell..."

    # Add zsh to allowed shells if not already there
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi

    # Change default shell
    chsh -s "$(which zsh)"

    print_success "zsh set as default shell (restart terminal to apply)"
}

# Main installation flow
main() {
    echo ""
    print_info "Starting dotfiles setup..."
    echo ""

    # Detect OS
    detect_os
    echo ""

    # Backup existing dotfiles
    backup_dotfiles
    echo ""

    # Create symlinks
    create_symlinks
    echo ""

    # Install OS-specific dependencies
    if [ "$OS" = "macos" ]; then
        install_macos_deps
    elif [ "$OS" = "linux" ]; then
        install_linux_deps
        echo ""
        install_nerdfonts_linux
    fi
    echo ""

    # Install oh-my-zsh
    install_oh_my_zsh
    echo ""

    # Install zsh plugins
    install_zsh_plugins
    echo ""

    # Install vim-plug
    install_vim_plug
    echo ""

    # Set zsh as default shell
    set_zsh_default
    echo ""

    print_success "Dotfiles setup complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Update .gitconfig with your name and email"
    echo "  2. Set your terminal font to 'BlexMono Nerd Font' for best experience"
    echo "  3. Restart your terminal or run: source ~/.zshrc"
    echo "  4. Open vim and run :PlugInstall to install vim plugins"
    echo "  5. (Optional) Customize settings in ~/.zshrc.local"
    echo ""
}

# Run main function
main
