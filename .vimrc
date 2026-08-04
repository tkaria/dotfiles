" ============================================================
" .vimrc — modern Vim 9+ configuration
" Last updated: 2025/2026
" ============================================================

" Must be first — disables Vi compatibility
set nocompatible

" filetype off so vim-plug can update runtimepath cleanly;
" re-enabled via filetype plugin indent on after plug#end()
filetype off

" ============================================================
" PLUGIN MANAGER — vim-plug
" Auto-installs vim-plug if not found
" ============================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_autoinstall
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" ALE: disable its built-in LSP *before* the plugin loads (ALE docs requirement)
let g:ale_disable_lsp = 1

" ============================================================
" PLUGINS
" ============================================================
call plug#begin('~/.vim/plugged')

" --- Sensible defaults baseline ---
Plug 'tpope/vim-sensible'           " Universally-agreed sensible defaults

" --- File exploration ---
Plug 'preservim/nerdtree'           " Classic file tree explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'             " Fuzzy finder (files, buffers, rg, history)

" --- Git integration ---
Plug 'tpope/vim-fugitive'           " Git commands inside Vim (:Git, :Gblame, …)
Plug 'airblade/vim-gitgutter'       " Git diff signs in the gutter

" --- Status line ---
Plug 'vim-airline/vim-airline'      " Feature-rich statusline
Plug 'vim-airline/vim-airline-themes'

" --- LSP client (pure VimScript — works in Vim 8+/9+) ---
Plug 'prabirshrestha/vim-lsp'               " LSP client
Plug 'mattn/vim-lsp-settings'              " Auto-install + configure language servers
Plug 'prabirshrestha/asyncomplete.vim'     " Async completion framework
Plug 'prabirshrestha/asyncomplete-lsp.vim' " Wire vim-lsp into asyncomplete

" --- Linting & fixing (ALE; runs independently of LSP) ---
Plug 'dense-analysis/ale'           " Asynchronous linting + auto-fix

" --- Editing utilities ---
Plug 'tpope/vim-surround'           " Change/add/delete surrounding pairs
Plug 'tpope/vim-commentary'         " Toggle comments (gcc / gc<motion>)
Plug 'tpope/vim-repeat'             " Make plugin actions repeatable with '.'
Plug 'jiangmiao/auto-pairs'         " Auto-close brackets, quotes, etc.

" --- Color schemes ---
Plug 'sainnhe/gruvbox-material'     " Gruvbox variant with softer contrast (top pick 2025)
Plug 'sainnhe/everforest'           " Warm green palette; easy on the eyes
Plug 'arcticicestudio/nord-vim'     " Cool blue-grey polar palette
Plug 'joshdick/onedark.vim'         " Atom One Dark port — widely used
Plug 'catppuccin/vim', { 'as': 'catppuccin' } " Soothing pastel themes (4 flavours)
Plug 'lifepillar/vim-solarized8'    " Solarized for truecolor terminals
Plug 'morhetz/gruvbox'              " Original Gruvbox (kept for compat)

call plug#end()

" Re-enable filetype detection, plugin loading, and indentation
filetype plugin indent on
syntax on   " Must follow filetype detection for syntax overrides to work correctly

" ============================================================
" GENERAL SETTINGS
" ============================================================

" Leader key — comma is ergonomic and widely used
let mapleader = ","
let maplocalleader = "\\"

" Security — prevent modeline exploits
set modelines=0

" Encoding
set encoding=utf-8
setglobal fileencoding=utf-8   " Default for new files; does not override detected encoding

" Show line numbers (absolute + relative for easy motion counting)
set number
set relativenumber

" Always show file path, cursor position
set ruler

" Allow switching buffers without saving
set hidden

" Faster terminal rendering
set ttyfast

" Always show status line
set laststatus=2

" Show current mode and partial commands
set noshowmode   " vim-airline renders the mode in the statusline — suppress the duplicate
set showcmd

" Reduce command timeout for key sequences
set timeoutlen=500

" ============================================================
" TRUECOLOR & COLOR SCHEME
" ============================================================

" Enable 256-colour fallback for older terminals
set t_Co=256

" Enable 24-bit truecolor when the terminal supports it
if has('termguicolors')
  " Fix termguicolors inside tmux
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Dark background
set background=dark

" gruvbox-material — warm, low-contrast, excellent truecolor support
" Switch by uncommenting the desired colorscheme line.
let g:gruvbox_material_background = 'medium'   " 'hard' / 'medium' / 'soft'
let g:gruvbox_material_better_performance = 1
" silent! avoids E185 on first install before PlugInstall has run
silent! colorscheme gruvbox-material

" Other great options (uncomment to switch):
" let g:everforest_background = 'medium'
" silent! colorscheme everforest
" silent! colorscheme nord
" silent! colorscheme onedark
" silent! colorscheme catppuccin_mocha       " mocha / macchiato / frappe / latte
" silent! colorscheme gruvbox
" let g:solarized_use16 = 0
" silent! colorscheme solarized8

" ============================================================
" PERSISTENT UNDO
" (survives restarts — keep undo history across sessions)
" ============================================================
if has('persistent_undo')
  let s:undo_dir = expand('~/.vim/undodir')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
  endif
  set undodir=~/.vim/undodir
  set undofile
endif

" ============================================================
" BACKUP & SWAP (consolidated into ~/.vim/{backup,swap})
" ============================================================
let s:backup_dir = expand('~/.vim/backup')
let s:swap_dir   = expand('~/.vim/swap')
if !isdirectory(s:backup_dir) | call mkdir(s:backup_dir, 'p', 0700) | endif
if !isdirectory(s:swap_dir)   | call mkdir(s:swap_dir,   'p', 0700) | endif
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set backup

" ============================================================
" CLIPBOARD
" ============================================================
" Use the system clipboard for all yank/paste operations.
" Requires +clipboard build (check with: vim --version | grep clipboard).
if has('clipboard')
  " unnamed     = macOS (* register)
  " unnamedplus = Linux/X11/Wayland (+ register)
  " Both values together work across platforms.
  set clipboard=unnamed,unnamedplus
endif

" ============================================================
" MOUSE SUPPORT
" ============================================================
if has('mouse')
  set mouse=a   " Enable mouse in all modes (click, scroll, resize splits)
endif

" ============================================================
" BELLS — silence everything
" ============================================================
" visualbell must be ON so that t_vb= (empty) suppresses the visual flash;
" noerrorbells additionally silences error-specific audio bells.
set noerrorbells visualbell
set t_vb=   " Clear the terminal visual-bell sequence
augroup no_bells
  autocmd!
  autocmd GUIEnter * set t_vb=   " Re-apply for GVim (GUI resets t_vb)
augroup END

" ============================================================
" WHITESPACE & INDENTATION
" ============================================================
set wrap                    " Soft-wrap long lines
set textwidth=79            " Hard-wrap at 79 cols (only when formatting)
set formatoptions=tcqrn1    " See :help fo-table
set tabstop=4               " Visual width of a tab character
set shiftwidth=4            " Indent/de-indent amount
set softtabstop=4           " Tab in insert mode feels like 4 spaces
set expandtab               " Turn tabs into spaces
set noshiftround

" Per-filetype overrides (add more as needed)
augroup filetype_indent
  autocmd!
  autocmd FileType html,css,javascript,typescript,yaml,json,vim
    \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" ============================================================
" SEARCH
" ============================================================
set hlsearch          " Highlight all matches
set incsearch         " Show matches while typing
set ignorecase        " Case-insensitive search …
set smartcase         " … unless pattern has uppercase chars
set showmatch         " Briefly jump to matching bracket

" Very-magic mode by default (consistent regex behaviour)
nnoremap / /\v
vnoremap / /\v

" ============================================================
" GREP — use ripgrep when available
" ============================================================
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  " :Rg in fzf.vim already uses rg; this wires :grep too
endif

" ============================================================
" SPLITS
" ============================================================
set splitright    " Vertical splits open to the right
set splitbelow    " Horizontal splits open below

" ============================================================
" WILDMENU — better command-line completion
" ============================================================
set wildmenu
set wildmode=list:longest,full   " First list matches, then cycle through them
set wildignorecase
set wildignore+=*.o,*.obj,*.pyc,*.class,*.swp,*~
set wildignore+=.git,.hg,.svn
set wildignore+=node_modules/**,*.min.js

" ============================================================
" CURSOR & SCROLLING
" ============================================================
set scrolloff=5       " Keep 5 lines visible above/below cursor
set sidescrolloff=8
set backspace=indent,eol,start
set matchpairs+=<:>   " % jumps between <> pairs too
runtime! macros/matchit.vim

" Navigate visual (wrapped) lines, not physical lines
nnoremap j gj
nnoremap k gk

" ============================================================
" DISPLAY / UI
" ============================================================
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
" set list   " Uncomment to enable by default

" Highlight the current line
set cursorline

" Keep sign column always visible (avoids layout shift from gitgutter/ale)
set signcolumn=yes

" Reduce update time (faster gitgutter sign refresh)
set updatetime=100

" ============================================================
" KEY MAPPINGS
" ============================================================

" --- Leader shortcuts ---
nnoremap <leader><space> :nohlsearch<CR>      " Clear search highlight
nnoremap <leader>l       :set list!<CR>       " Toggle whitespace chars
nnoremap <leader>q       gqip                 " Reformat paragraph
nnoremap <leader>w       :w<CR>               " Quick save
nnoremap <leader>x       :x<CR>               " Save + quit

" --- Buffer navigation ---
nnoremap <leader>]   :bnext<CR>
nnoremap <leader>[   :bprevious<CR>
nnoremap <leader>bD  :bdelete<CR>   " capital D avoids 500 ms wait on <leader>b (Buffers)

" --- Split navigation (Ctrl+hjkl) ---
" Note: <C-l> replaces the built-in 'redraw screen'. Use <leader>r instead.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>R :redraw!<CR>   " capital R avoids 500 ms wait from <leader>rn (LSP rename) in LSP buffers

" --- Quickfix / location list ---
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprevious<CR>

" ============================================================
" PLUGIN CONFIGURATION
" ============================================================

" --- NERDTree ---
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden  = 1        " Show dotfiles
let NERDTreeMinimalUI   = 1        " Remove help text at top
let NERDTreeQuitOnOpen  = 0        " Keep tree open after opening a file
" Auto-close Vim when NERDTree is the only remaining window.
" Wrapped in an augroup so re-sourcing .vimrc does not duplicate the autocmd.
augroup nerdtree_autoquit
  autocmd!
  autocmd BufEnter * if winnr('$') == 1
        \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END

" --- FZF ---
nnoremap <C-p>       :Files<CR>
nnoremap <leader>b   :Buffers<CR>
nnoremap <leader>g   :Rg<CR>
nnoremap <leader>fh  :History<CR>    " <leader>f prefix avoids conflict with <leader>hs/hu/hp
nnoremap <leader>t   :Tags<CR>
nnoremap <leader>m   :Marks<CR>

" Open FZF results in splits / tabs
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',   " ctrl-s is intercepted by terminal XOFF; use ctrl-x instead
  \ 'ctrl-v': 'vsplit' }

" Match FZF colours to the active colorscheme
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" --- vim-airline ---
let g:airline_powerline_fonts                 = 1
let g:airline#extensions#tabline#enabled     = 1
let g:airline#extensions#tabline#formatter   = 'unique_tail'
let g:airline#extensions#ale#enabled         = 1   " Show ALE errors in statusline
let g:airline#extensions#fugitiveline#enabled = 1

" --- vim-gitgutter ---
" updatetime is already set to 100 above (used globally for gutter refresh)
let g:gitgutter_map_keys = 0   " Disable default keymaps (define your own below)
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>
nnoremap <leader>hp :GitGutterPreviewHunk<CR>

" --- LSP (vim-lsp + asyncomplete) ---
" Language servers are installed automatically via vim-lsp-settings:
"   Open a file, run :LspInstallServer, follow the prompts.

let g:lsp_diagnostics_enabled         = 1
let g:lsp_diagnostics_echo_cursor     = 1   " Show diagnostic under cursor in cmdline
let g:lsp_document_highlight_enabled  = 1

" Completion options (no auto-insert, no auto-select)
set completeopt=menuone,noinsert,noselect

" Wire vim-lsp into asyncomplete.
" Using the User asyncomplete_setup event ensures registration happens exactly
" once per Vim session and is safe to re-source.
augroup asyncomplete_lsp_setup
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(
    \ asyncomplete#sources#lsp#get_source_options({
    \ 'name': 'lsp',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#lsp#completor'),
    \ 'config': {},
    \ }))
augroup END

" Tab / S-Tab cycle through the completion popup; Enter confirms.
" The <CR> mapping guards asyncomplete availability to avoid E117 when
" native omnicompletion (or no asyncomplete) is active.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() && exists('*asyncomplete#close_popup')
      \ ? asyncomplete#close_popup() : "\<CR>"

" LSP keymaps (active only when an LSP server is attached)
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> gd          <Plug>(lsp-definition)
  nmap <buffer> gs          <Plug>(lsp-document-symbol-search)
  nmap <buffer> gS          <Plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr          <Plug>(lsp-references)
  nmap <buffer> gi          <Plug>(lsp-implementation)  " shadows built-in 'gi' (go to last insert); accepted LSP convention
  nmap <buffer> <leader>rn  <Plug>(lsp-rename)
  nmap <buffer> <leader>ca  <Plug>(lsp-code-action)
  nmap <buffer> K           <Plug>(lsp-hover)
  nmap <buffer> [d          <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d          <Plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>lf  <Plug>(lsp-document-format)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" --- ALE (linting + auto-fix) ---
" g:ale_disable_lsp is set before plug#begin() above (ALE docs requirement).
let g:ale_sign_error         = '✖'
let g:ale_sign_warning       = '⚠'
let g:ale_echo_msg_format    = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save        = 1    " Auto-fix on save (remove if unwanted)
let g:ale_fixers = {
  \ '*':          ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'python':     ['black', 'isort'],
  \ 'go':         ['gofmt', 'goimports'],
  \ 'rust':       ['rustfmt'],
  \ }

nnoremap <leader>af :ALEFix<CR>
nnoremap ]e         :ALENext<CR>
nnoremap [e         :ALEPrevious<CR>

" ============================================================
" END OF .vimrc
" ============================================================
