" Minimal .vimrc — SSH fallback (full config lives in ~/.config/nvim/)
" vim: set ft=vim:

set nocompatible
filetype plugin indent on
syntax on

let mapleader = ","

set number
set encoding=utf-8
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set ignorecase smartcase hlsearch incsearch
set scrolloff=3
set hidden
set laststatus=2
set ruler
set showmode showcmd
set backspace=indent,eol,start

" Visual-line navigation
nnoremap j gj
nnoremap k gk

" Clear search highlight
map <leader><space> :let @/=''<cr>

" Toggle whitespace visualization
map <leader>l :set list!<CR>
set listchars=tab:▸\ ,trail:·

" Format paragraph
map <leader>q gqip
