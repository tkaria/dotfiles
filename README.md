# Dotfiles

My personal dotfiles for vim, git, and zsh. Works on both macOS and Linux.

## Features

### Vim Configuration (.vimrc)
- **vim-plug** plugin manager with auto-installation
- Curated plugin set:
  - NERDTree for file exploration
  - FZF for fuzzy finding
  - vim-fugitive and gitgutter for Git integration
  - vim-airline for status line
  - Solarized and Gruvbox color schemes
  - Useful utilities (surround, commentary, auto-pairs)
- Sensible defaults for editing
- Smart search and navigation
- Line numbers and visual feedback

### Zsh Configuration (.zshrc)
- **oh-my-zsh** framework
- Enhanced plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - fast-syntax-highlighting
  - zsh-autocomplete
- Custom aliases for common tasks
- Useful functions (mkcd, extract)
- OS-specific configurations
- Extended history settings
- Support for local customizations via `~/.zshrc.local`

### Git Configuration (.gitconfig)
- Comprehensive aliases (st, co, br, visual, etc.)
- Better diff and merge settings
- Color-coded output
- Default branch and push behavior
- URL shortcuts (gh:, gist:)
- Auto-correct for mistyped commands

### Fonts
- **BlexMono Nerd Font** (IBM Plex Mono patched with icons)
- Installed automatically on both macOS and Linux
- Enables powerline symbols in vim-airline
- Provides icon glyphs for enhanced terminal experience

### Setup Script (setup.sh)
- Automatic OS detection (macOS/Linux)
- Backs up existing dotfiles with timestamp
- Creates symlinks to dotfiles
- Installs required tools and dependencies
- Installs BlexMono Nerd Font
- Sets up oh-my-zsh and plugins
- Installs vim-plug
- Sets zsh as default shell

## Installation

### Quick Start

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the setup script
cd ~/dotfiles
./setup.sh
```

The setup script will:
1. Detect your OS (macOS or Linux)
2. Backup existing dotfiles to `~/dotfiles_backup_TIMESTAMP`
3. Create symlinks from your home directory to this repository
4. Install necessary tools (Homebrew on macOS, apt/yum/pacman on Linux)
5. Install BlexMono Nerd Font
6. Install oh-my-zsh and plugins
7. Install vim-plug
8. Set zsh as your default shell

### Manual Installation

If you prefer to set up manually:

```bash
# Backup existing dotfiles
mkdir -p ~/dotfiles_backup
mv ~/.vimrc ~/.zshrc ~/.gitconfig ~/dotfiles_backup/

# Create symlinks
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Post-Installation

### 1. Configure Terminal Font

Set your terminal to use **BlexMono Nerd Font** for the best experience:

- **iTerm2** (macOS): Preferences → Profiles → Text → Font → Select "BlexMono Nerd Font"
- **Terminal.app** (macOS): Preferences → Profiles → Font → Change → Select "BlexMono Nerd Font"
- **GNOME Terminal** (Linux): Preferences → Profile → Custom font → Select "BlexMono Nerd Font"
- **Alacritty**: Edit `~/.config/alacritty/alacritty.yml` and set `font.normal.family: "BlexMono Nerd Font"`
- **VSCode**: Set `"terminal.integrated.fontFamily": "BlexMono Nerd Font Mono"`

### 2. Configure Git User Information

Edit `.gitconfig` and add your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Or uncomment and edit the user section in `~/.gitconfig`.

### 3. Install Vim Plugins

Open vim and run:

```vim
:PlugInstall
```

This will install all the plugins defined in `.vimrc`.

### 4. Restart Your Terminal

Restart your terminal or run:

```bash
source ~/.zshrc
```

### 5. Optional Customizations

Create a `~/.zshrc.local` file for machine-specific settings that won't be tracked in git:

```bash
# Example ~/.zshrc.local
export PATH="$HOME/custom/bin:$PATH"
alias customalias="some command"
```

## Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull origin main
```

If you've added new vim plugins to `.vimrc`, run `:PlugInstall` in vim.

If you've added new zsh plugins, restart your terminal or run `source ~/.zshrc`.

## Customization

### Adding Vim Plugins

Edit `.vimrc` and add plugins in the vim-plug section:

```vim
call plug#begin('~/.vim/plugged')
Plug 'author/plugin-name'
call plug#end()
```

Then run `:PlugInstall` in vim.

### Adding Zsh Plugins

For oh-my-zsh plugins, add them to the `plugins` array in `.zshrc`:

```bash
plugins=(
  git
  # add your plugin here
)
```

### Adding Git Aliases

Add aliases to the `[alias]` section in `.gitconfig`:

```gitconfig
[alias]
  myalias = command here
```

## Key Bindings

### Vim
- `<C-n>` - Toggle NERDTree
- `<C-p>` - Open FZF file finder
- `<leader>b` - Browse open buffers
- `<leader>g` - Search with ripgrep
- `<leader><space>` - Clear search highlighting
- `<leader>l` - Toggle whitespace visualization
- `j/k` - Move by visual lines

### Zsh
- `Ctrl+R` - Search command history
- `Tab` - Autocomplete with menu
- Arrow keys navigate suggestions from zsh-autosuggestions

## Directory Structure

```
dotfiles/
├── .gitconfig       # Git configuration
├── .vimrc          # Vim configuration
├── .zshrc          # Zsh configuration
├── setup.sh        # Setup script
└── README.md       # This file
```

## Troubleshooting

### Zsh plugins not loading

Make sure the plugins are installed:

```bash
ls ~/.oh-my-zsh/custom/plugins/
```

If missing, run the relevant installation commands from `setup.sh`.

### Vim plugins not working

Run `:PlugInstall` in vim and restart vim.

### Permission issues with setup.sh

Make sure the script is executable:

```bash
chmod +x ~/dotfiles/setup.sh
```

### Colors not working in vim

Make sure your terminal supports 256 colors. For iTerm2, this should work by default. For other terminals, you may need to set:

```bash
export TERM=xterm-256color
```

## License

Feel free to use and modify these dotfiles for your own setup.

## Acknowledgments

- Inspired by various dotfiles repositories in the community
- vim-plug by junegunn
- oh-my-zsh by the oh-my-zsh community
