# Dotfiles

Personal dotfiles for zsh, neovim, tmux, git, and ghostty — managed with [GNU stow](https://www.gnu.org/software/stow/) and organized around the [XDG Base Directory spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

## Features

- **Zsh** — oh-my-zsh today, migrating to Zinit + Starship (phase 4)
- **Neovim** — lazy.nvim config (phase 5)
- **Tmux** — TPM + catppuccin + resurrect/continuum
- **Git** — delta pager, rerere, modern defaults, identity kept out of the repo
- **Ghostty** — Catppuccin Frappé theme, BlexMono Nerd Font

## Installation

```bash
git clone https://github.com/tkaria/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

The bootstrap script will:
1. Detect your OS (macOS / Linux)
2. Install Homebrew (macOS) or update apt (Linux)
3. Install all packages via `Brewfile` (macOS) or `packages/apt.txt` (Linux)
4. Install [GNU stow](https://www.gnu.org/software/stow/) if not present
5. Stow all packages — creates symlinks under `$HOME` / `$XDG_CONFIG_HOME`
6. Install [Zinit](https://github.com/zdharma-continuum/zinit) (zsh plugin manager)
7. Install [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
8. Optionally set zsh as your default shell

Use `--dry-run` to preview without making changes:
```bash
./bootstrap.sh --dry-run
```

## Post-Install Setup

### 1. Configure Git identity

```bash
cp git/.config/git/config.local.example ~/.config/git/config.local
$EDITOR ~/.config/git/config.local
```

Fill in your name, email, and SSH signing key. This file is gitignored and never committed.

### 2. Add machine-specific shell settings

```bash
cp zsh/.config/zsh/zshrc.local.example ~/.zshrc.local
$EDITOR ~/.zshrc.local
```

Put any machine-specific `PATH` additions, aliases, or tool integrations here.

### 3. Install tmux plugins

Start tmux, then press `prefix + I` (capital i) to install all plugins via TPM.

### 4. Install Neovim plugins

Open Neovim — lazy.nvim will auto-install all plugins on first launch.

### 5. Set terminal font

Set your terminal to use **BlexMono Nerd Font** for powerline glyphs:
- **Ghostty**: already configured in `ghostty/.config/ghostty/config`
- **iTerm2**: Preferences → Profiles → Text → Font
- **VSCode**: `"terminal.integrated.fontFamily": "BlexMono Nerd Font Mono"`

## Directory Structure

```
dotfiles/
├── bootstrap.sh              # Idempotent installer (replaces setup.sh)
├── Brewfile                  # macOS packages (declarative)
├── packages/
│   └── apt.txt               # Linux packages
├── .stow-local-ignore        # Files stow should not symlink
│
├── zsh/
│   ├── .zshenv               # Sets ZDOTDIR → ~/.config/zsh (stowed to ~/.zshenv)
│   └── .config/zsh/
│       ├── .zshrc            # Main zsh config
│       ├── zshrc.local.example  # Template for ~/.zshrc.local
│       └── aliases.zsh       # (placeholder)
│
├── starship/
│   └── .config/
│       └── starship.toml     # Starship prompt config (placeholder, full config in phase 4)
│
├── nvim/
│   └── .config/nvim/         # Neovim config (full config added in phase 5)
│
├── tmux/
│   └── .config/tmux/
│       └── tmux.conf         # Tmux config with TPM + catppuccin
│
├── git/
│   └── .config/git/
│       ├── config            # Main git config (no personal info)
│       ├── ignore            # Global gitignore
│       └── config.local.example  # Template for ~/.config/git/config.local
│
├── ghostty/
│   └── .config/ghostty/
│       └── config            # Ghostty terminal config
│
└── vim/
    └── .vimrc                # Minimal fallback vim config (for SSH servers)
```

## Stow Usage

Install a single package:
```bash
stow -t ~ zsh
```

Remove a package (unlink):
```bash
stow -D -t ~ zsh
```

Reinstall all packages:
```bash
stow --restow -t ~ zsh starship nvim tmux git ghostty vim
```

## Updating

```bash
cd ~/dotfiles
git pull origin main
stow --restow -t ~ zsh starship nvim tmux git ghostty vim
```

## Customization

- **Machine-specific shell**: `~/.zshrc.local` (gitignored)
- **Machine-specific git**: `~/.config/git/config.local` (gitignored)
- **Work vs personal git**: Use `[includeIf]` in `config.local` (see `config.local.example`)

## Key Bindings

### Tmux
- `prefix` = `C-a`
- `prefix + |` — split horizontal
- `prefix + -` — split vertical
- `prefix + h/j/k/l` — navigate panes
- `prefix + H/J/K/L` — resize panes
- `prefix + r` — reload config

### Vim / Neovim
- `<leader>` = `,`
- `<C-n>` — toggle file tree
- `<C-p>` — fuzzy file finder
- `<leader>g` — live grep
- `<leader>b` — buffer list

## License

Feel free to use and adapt.
