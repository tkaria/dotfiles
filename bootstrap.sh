#!/usr/bin/env bash
# bootstrap.sh — idempotent dotfiles installer
# Usage: ./bootstrap.sh [--dry-run]
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh starship nvim tmux git ghostty vim)
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ── helpers ────────────────────────────────────────────────────────────────────
blue()    { echo -e "\033[0;34m==>\033[0m $*"; }
green()   { echo -e "\033[0;32m✓\033[0m $*"; }
yellow()  { echo -e "\033[1;33m!\033[0m $*"; }
red()     { echo -e "\033[0;31m✗\033[0m $*"; }

run() {
  if $DRY_RUN; then
    yellow "[dry-run] $*"
  else
    "$@"
  fi
}

# ── OS detection ───────────────────────────────────────────────────────────────
detect_os() {
  blue "Detecting OS..."
  if [[ "$OSTYPE" == darwin* ]]; then
    OS=macos; green "macOS"
  elif [[ "$OSTYPE" == linux-gnu* ]]; then
    OS=linux; green "Linux"
  else
    red "Unsupported OS: $OSTYPE"; exit 1
  fi
}

# ── package manager ────────────────────────────────────────────────────────────
install_pkg_manager() {
  if [[ "$OS" == macos ]]; then
    if ! command -v brew &>/dev/null; then
      blue "Installing Homebrew..."
      run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Apple Silicon
      [[ $(uname -m) == arm64 ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      green "Homebrew already installed"
    fi
  fi
}

# ── packages ───────────────────────────────────────────────────────────────────
install_packages() {
  blue "Installing packages..."
  case "$OS" in
    macos)
      run brew bundle --no-lock --file="$DOTFILES_DIR/Brewfile"
      ;;
    linux)
      run sudo apt-get update -qq
      run xargs -a "$DOTFILES_DIR/packages/apt.txt" sudo apt-get install -y
      # delta + starship + eza need manual install on older Ubuntu
      if ! command -v delta &>/dev/null; then
        DELTA_VER="0.17.0"
        run bash -c "curl -fsSL https://github.com/dandavison/delta/releases/download/${DELTA_VER}/git-delta_${DELTA_VER}_amd64.deb -o /tmp/delta.deb && sudo dpkg -i /tmp/delta.deb"
      fi
      if ! command -v starship &>/dev/null; then
        run bash -c "curl -sS https://starship.rs/install.sh | sh -s -- --yes"
      fi
      ;;
  esac
}

# ── stow ───────────────────────────────────────────────────────────────────────
install_stow() {
  if ! command -v stow &>/dev/null; then
    blue "Installing stow..."
    case "$OS" in
      macos) run brew install stow ;;
      linux) run sudo apt-get install -y stow ;;
    esac
  else
    green "stow already installed"
  fi
}

stow_packages() {
  blue "Stowing packages: ${PACKAGES[*]}"

  # Ensure nvim config dir exists (placeholder until Phase 5)
  run mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

  for pkg in "${PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      run stow --restow --target="$HOME" --dir="$DOTFILES_DIR" "$pkg"
      green "Stowed $pkg"
    else
      yellow "Package dir not found, skipping: $pkg"
    fi
  done
}

# ── zinit ──────────────────────────────────────────────────────────────────────
install_zinit() {
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ ! -d "$zinit_home" ]]; then
    blue "Installing Zinit..."
    run mkdir -p "$(dirname "$zinit_home")"
    run git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
    green "Zinit installed (plugins will load on first shell start)"
  else
    green "Zinit already installed"
  fi
}

# ── tmux plugin manager ────────────────────────────────────────────────────────
install_tpm() {
  local tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
  if [[ ! -d "$tpm_dir" ]]; then
    blue "Installing TPM (Tmux Plugin Manager)..."
    run git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    green "TPM installed — press prefix+I inside tmux to install plugins"
  else
    green "TPM already installed"
  fi
}

# ── default shell ──────────────────────────────────────────────────────────────
set_zsh_default() {
  local zsh_path
  zsh_path=$(command -v zsh 2>/dev/null || echo "")
  if [[ -z "$zsh_path" ]]; then
    yellow "zsh not found — skipping default shell change"
    return
  fi
  if [[ "$SHELL" != "$zsh_path" ]]; then
    blue "Set $zsh_path as default shell? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      grep -qF "$zsh_path" /etc/shells || run sudo bash -c "echo '$zsh_path' >> /etc/shells"
      run chsh -s "$zsh_path"
      green "Default shell changed to zsh — restart your terminal"
    fi
  else
    green "zsh is already the default shell"
  fi
}

# ── post-install notes ─────────────────────────────────────────────────────────
post_install_notes() {
  echo ""
  blue "Post-install checklist:"
  echo "  1. Copy git/config.local.example  →  ~/.config/git/config.local  and fill in your details"
  echo "  2. Copy zsh/.config/zsh/zshrc.local.example  →  ~/.zshrc.local   for machine-specific settings"
  echo "  3. Start tmux and press prefix+I to install tmux plugins"
  echo "  4. Open Neovim — lazy.nvim will auto-install plugins on first launch"
  echo "  5. Set your terminal font to: BlexMono Nerd Font"
}

# ── main ───────────────────────────────────────────────────────────────────────
main() {
  detect_os
  install_pkg_manager
  install_stow
  install_packages
  stow_packages
  install_zinit
  install_tpm
  set_zsh_default
  post_install_notes
}

main "$@"
