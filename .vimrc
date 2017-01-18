if has('win32')
  set rtp+=~/.vim
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'pangloss/vim-javascript'
Plug 'sjl/badwolf'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

call plug#end()

syntax enable
filetype plugin indent on

colorscheme badwolf

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set hlsearch
set textwidth=78
set ruler
set relativenumber
set number
set incsearch
set showcmd
set cursorline
set wildmenu
set lazyredraw
set incsearch
set hlsearch
set ignorecase
set smartcase

let mapleader="\<Space>"

nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>V :tabnew $MYVIMRC<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>s :Obsess ~/.vim/session.vim<CR>
nnoremap <leader>S :source ~/.vim/session.vim<CR>
nnoremap <leader>a :Ack 
nnoremap <leader>t :TagbarToggle<CR>

nnoremap <c-n> :call NumberToggle()<CR>
nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz

" not sure if I need these
nnoremap : :set norelativenumber<CR>:
nnoremap / :set norelativenumber<CR>/
nnoremap ? :set norelativenumber<CR>?

nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]
inoremap jk <esc>

let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0

let g:easytags_async = 1

if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g "" | dos2unix'
  let g:ackprg = 'ag --vimgrep'
endif

if has('win32unix')
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
else
  " allows cursor change in tmux mode
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" toggle relativenumber and number
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

" reload .vimrc when changed
augroup vim_source
  au!
  autocmd BufWritePost .vimrc so $MYVIMRC
augroup end

" linenumber swapping
augroup line_number
  au!
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber

  if !has('win32unix')
    autocmd FocusLost * :set norelativenumber
    autocmd FocusGained * :set relativenumber
  endif
augroup end

" turn off backup and history for encrypted files
augroup encrypted
  au!
  autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 secure | endif
augroup end

" open file to previous location
augroup line_return
  au!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"zvzz" |
    \ endif
augroup end

augroup language_config
  au!
  autocmd FileType cs setlocal ts=4 sts=4 sw=4 noexpandtab
augroup END

