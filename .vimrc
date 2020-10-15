" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1

" install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-python/python-syntax'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'lervag/vimtex'
Plug 'terryma/vim-multiple-cursors'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

set nu
let g:tex_flavor = 'latex'
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'
let g:session_autosave_to = 'default'
let g:session_verbose_messages = 0
let g:vimtex_view_method = 'skim'

map <C-t> :NERDTreeToggle<CR>

let maplocalleader="\<space>"
autocmd VimLeave * NERDTreeClose
:set ignorecase
:set smartcase
syntax on
colorscheme onedark
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }
let g:python_highlight_all = 1
let g:ale_lint_on_text_change = 'always'
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\}

" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

if &compatible
  finish
else
  let g:loaded_sensible = 1
endif

if has('autocmd')
  filetype plugin indent on
endif

" Use :help 'option' to see the documentation for the given option.

" set tab width to 4
set ts=4 sw=4
" stay in visual mode after indenting
vnoremap < <gv
vnoremap > >gv
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set expandtab
set nrformats-=octal

set ttimeout
set ttimeoutlen=100

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

set laststatus=2
set ruler
set showcmd
set wildmenu
set splitbelow

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags^=./tags;
endif

if &shell =~# 'fish$'
  set shell=/bin/bash
endif

set autoread
set fileformats+=mac

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$
autocmd bufreadpre *.tex setlocal textwidth=89
" https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()
