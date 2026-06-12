# Dotfiles

Personal dotfiles for zsh, neovim, tmux, git, and ghostty — managed with [GNU stow](https://www.gnu.org/software/stow/) and organized around the [XDG Base Directory spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

## Stack

| Tool | Choice | Notes |
|------|--------|-------|
| Shell | zsh + [Zinit](https://github.com/zdharma-continuum/zinit) | Turbo async plugin loading |
| Prompt | [Starship](https://starship.rs) | Agnoster-style, Catppuccin Frappé |
| Editor | [Neovim](https://neovim.io) + [lazy.nvim](https://github.com/folke/lazy.nvim) | LSP, treesitter, telescope |
| Multiplexer | [tmux](https://github.com/tmux/tmux) + [TPM](https://github.com/tmux-plugins/tpm) | Resurrect + continuum |
| Git pager | [delta](https://github.com/dandavison/delta) | Catppuccin Frappé syntax theme |
| Terminal | [Ghostty](https://ghostty.org) | Catppuccin Frappé theme |
| Font | BlexMono Nerd Font | Powerline glyphs |
| Dotfile mgmt | [GNU stow](https://www.gnu.org/software/stow/) | Symlink farm, XDG-aligned |

All tools share the **Catppuccin Frappé** colour theme for a consistent look across terminal, prompt, editor, tmux, and git diffs.

## Quick Start

```bash
git clone https://github.com/tkaria/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

Then complete the [post-install steps](#post-install-setup).

Use `--dry-run` to preview without changes:
```bash
./bootstrap.sh --dry-run
```

## What `bootstrap.sh` does

1. Detects OS (macOS / Linux)
2. Installs Homebrew (macOS) or updates apt (Linux)
3. Installs all packages via `Brewfile` / `packages/apt.txt`
4. Installs GNU stow if absent
5. Stows all packages — creates symlinks under `$HOME`
6. Installs [Zinit](https://github.com/zdharma-continuum/zinit) (zsh plugin manager)
7. Installs [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
8. Optionally sets zsh as your default shell

## Post-Install Setup

### 1. Git identity

```bash
cp git/.config/git/config.local.example ~/.config/git/config.local
$EDITOR ~/.config/git/config.local
```

Set your name, email, and SSH signing key. This file is gitignored — never committed.

### 2. Machine-specific shell settings

```bash
cp zsh/.config/zsh/zshrc.local.example ~/.zshrc.local
$EDITOR ~/.zshrc.local
```

Put machine-specific `PATH` additions, aliases, and tool integrations here.

### 3. Tmux plugins

Start tmux, then press `prefix + I` (capital i) to install plugins via TPM.

### 4. Neovim plugins

Open Neovim — lazy.nvim auto-installs all plugins on first launch. Run `:MasonUpdate` to install LSP servers.

### 5. Terminal font

Set your terminal to **BlexMono Nerd Font** for powerline glyphs:
- **Ghostty**: already configured
- **iTerm2**: Preferences → Profiles → Text → Font
- **VSCode**: `"terminal.integrated.fontFamily": "BlexMono Nerd Font Mono"`

## Directory Structure

```
dotfiles/
├── bootstrap.sh              # Idempotent installer
├── Brewfile                  # macOS packages
├── packages/apt.txt          # Linux packages
├── .stow-local-ignore
│
├── zsh/
│   ├── .zshenv                  # Sets ZDOTDIR (stowed to ~/.zshenv)
│   └── .config/zsh/
│       ├── .zshrc               # Zinit + plugins + aliases
│       └── zshrc.local.example  # Template for ~/.zshrc.local
│
├── starship/
│   └── .config/starship.toml    # Agnoster-style Catppuccin prompt
│
├── nvim/
│   └── .config/nvim/
│       ├── init.lua
│       ├── stylua.toml
│       └── lua/
│           ├── config/          # options, keymaps, autocmds, lazy bootstrap
│           └── plugins/         # ui, editor, git, lsp, completion, treesitter
│
├── tmux/
│   └── .config/tmux/tmux.conf   # TPM + catppuccin + resurrect
│
├── git/
│   └── .config/git/
│       ├── config               # delta, rerere, aliases (no PII)
│       ├── ignore               # global gitignore
│       └── config.local.example # template for identity + credentials
│
├── ghostty/
│   └── .config/ghostty/config   # Catppuccin Frappé, BlexMono
│
└── vim/
    └── .vimrc                   # Minimal SSH fallback (no plugins)
```

## Stow Usage

```bash
# Install a package
stow -t ~ zsh

# Remove a package
stow -D -t ~ zsh

# Reinstall everything
stow --restow -t ~ zsh starship nvim tmux git ghostty vim
```

## Updating

```bash
cd ~/dotfiles
git pull
stow --restow -t ~ zsh starship nvim tmux git ghostty vim
```

## Key Bindings

### Tmux (prefix = `C-a`)

| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontal |
| `prefix + -` | Split vertical |
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + r` | Reload config |
| `prefix + I` | Install plugins (TPM) |
| `prefix + s` | Session picker |

### Neovim (leader = `,`)

| Key | Action |
|-----|--------|
| `<C-n>` | Toggle file tree (neo-tree) |
| `<C-p>` | Find files (Telescope) |
| `<leader>g` | Live grep |
| `<leader>b` | Buffer list |
| `<leader>gs` | Git status (fugitive) |
| `<leader>rn` | LSP rename |
| `<leader>ca` | LSP code action |
| `<leader>f` | Format buffer |
| `gd` | Go to definition |
| `K` | Hover docs |
| `]h` / `[h` | Next/prev git hunk |
| `<leader><space>` | Clear search highlight |

## Customization

- **Machine-specific shell**: `~/.zshrc.local` (gitignored)
- **Git identity**: `~/.config/git/config.local` (gitignored)
- **Work vs personal git**: `[includeIf]` in `config.local` (see example)

## License

Feel free to use and adapt.
