# ~/.config/zsh/.zshrc
# Loaded automatically because ~/.zshenv sets ZDOTDIR=$HOME/.config/zsh

# ===== Zinit bootstrap =====
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ===== Options =====
setopt EXTENDED_HISTORY          # Write history in ':start:elapsed;command' format
setopt SHARE_HISTORY             # Share history across sessions
setopt HIST_IGNORE_DUPS          # Don't record duplicate of last entry
setopt HIST_IGNORE_ALL_DUPS      # Delete old entry if new one is a duplicate
setopt HIST_FIND_NO_DUPS         # Don't display previously found entries
setopt HIST_IGNORE_SPACE         # Don't record entries starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
HISTSIZE=10000
SAVEHIST=10000

# ===== Aliases =====

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# List files
alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lAh"

# Git shortcuts
alias gst="git status"
alias gco="git checkout"
alias gcm="git checkout main"
alias gp="git push"
alias gpl="git pull"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Directory shortcuts
alias dt="cd ~/Desktop"
alias dl="cd ~/Downloads"
alias dev="cd ~/dev"

# System
alias reload="source ~/.config/zsh/.zshrc"
alias zshconfig="${EDITOR:-vim} ~/.config/zsh/.zshrc"
alias vimconfig="${EDITOR:-vim} ~/.vimrc"

# Utilities
alias grep="grep --color=auto"
alias h="history"
alias c="clear"

# ===== Functions =====

# Create a new directory and enter it
mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Extract any archive
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ===== Environment =====
export EDITOR='nvim'
export VISUAL='nvim'

# ===== OS-specific =====
if [[ "$OSTYPE" == darwin* ]]; then
  # Homebrew
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
elif [[ "$OSTYPE" == linux-gnu* ]]; then
  if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
  fi
fi

# ===== Plugins (turbo — load after first prompt) =====
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# Bind history substring search to Up/Down arrows (after plugin loads)
zinit wait lucid atload"
  bindkey '\e[A' history-substring-search-up
  bindkey '\e[B' history-substring-search-down
" for zsh-users/zsh-history-substring-search

# ===== Tool integrations =====

# fzf (prefer modern --zsh flag for fzf >= 0.48; fall back to legacy file)
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
elif [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

# zoxide (modern cd replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# kubectl completions (cached)
if command -v kubectl &>/dev/null; then
  zinit wait lucid as"completion" for \
    <(kubectl completion zsh)
fi

# docker completions
if command -v docker &>/dev/null; then
  zinit wait lucid as"completion" for \
    <(docker completion zsh 2>/dev/null || true)
fi

# ===== Prompt =====
eval "$(starship init zsh)"

# ===== Machine-specific settings =====
# Add the following to ~/.zshrc.local (gitignored):
#   export PATH="$HOME/.npm-global/bin:$PATH"
#   export PATH="$PATH:$HOME/.lmstudio/bin"
#   eval "$(wsp completion zsh)"
#   alias pb="pbcopy <"

# Load local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
