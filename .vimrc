set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" core plugins
Bundle 'gmarik/vundle'
Bundle 'flazz/vim-colorschemes'
Bundle 'kien/ctrlp.vim'

" main plugins
Bundle 'sjl/gundo.vim'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-commentary'

Bundle 'airblade/vim-gitgutter'

filetype plugin indent on

set expandtab
set tabstop=2
set shiftwidth=2
set hlsearch
set textwidth=78
set backspace=indent,eol,start
set ruler
set relativenumber
set number
set incsearch
set encoding=utf8
set laststatus=2

" treat all numerals as decimal for <C-a> and <C-x>
set nrformats=

if has('gui_running')
  set guifont=Inconsolata\ for\ Powerline:h11
endif

syntax on
colorscheme candyman

" backup/persistence
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set backup

" persist undo tree between sessions
set undofile
set history=100
set undolevels=100

" Open file to previous location
augroup line_return
  au!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"zvzz" |
    \ endif

augroup END

" open vimrc
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>V :tabnew ~/.vimrc<CR>

" airline settings
if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif

let g:airline_theme="powerlineish"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1

" Toggle relativenumber and number
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

" toggleables
nnoremap <F3> :GitGutterToggle<CR>
nnoremap <F4> :GundoToggle<CR>
nnoremap <C-n> :call NumberToggle()<cr>

" Linenumber swapping
augroup LineNumber
  au!
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber

  autocmd FocusLost * :set norelativenumber
  autocmd FocusGained * :set relativenumber
augroup END

