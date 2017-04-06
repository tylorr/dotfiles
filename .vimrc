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
Plug 'edkolev/tmuxline.vim'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'mtth/scratch.vim'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'sjl/badwolf'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
" Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
" Plug 'xolox/vim-easytags'
Plug 'tylorr/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'chaoren/vim-wordmotion'

call plug#end()

syntax enable
filetype plugin indent on

colorscheme badwolf

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
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
set splitright
set splitbelow
set autoread
set hidden

let mapleader="\<Space>"

cabbr <expr> %% expand('%:p:h')

nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>V :tabnew $MYVIMRC<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>s :Obsess ~/.vim/session.vim<CR>
nnoremap <leader>S :source ~/.vim/session.vim<CR>
nnoremap <leader>l :SyntasticCheck<CR>
nnoremap <leader>L :SyntasticToggleMode<CR>
nnoremap <leader>a :Ack! 
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>r :CtrlPBufTag<CR>
nnoremap <leader>R :CtrlPBufTagAll<CR>
nnoremap <leader>ne :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

nnoremap <c-n> :call NumberToggle()<CR>
nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz

" not sure if I need these
" nnoremap : :set norelativenumber<CR>:
" nnoremap / :set norelativenumber<CR>/
" nnoremap ? :set norelativenumber<CR>?

nnoremap j gj
nnoremap k gk

xnoremap io iw
xnoremap ao aw
onoremap io iw
onoremap ao aw

" highlight last inserted text
nnoremap gV `[v`]
inoremap jk <esc>

vnoremap // y/<C-R>"<CR>

if !has('win32unix')
  inoremap <esc> <nop>
  inoremap <esc>^[ <esc>^[
endif

" custom text-object for numerical values
function! Numbers()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call Numbers()<CR>
onoremap in :normal vin<CR>

let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_buftag_types = { 'javascript': '--language-force=javascript --javascript-types=fcmvg' }

let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["php"] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

let g:easytags_async = 1

let g:tmuxline_powerline_separators = 0
let g:tmuxline_separators = {
      \ 'left' : '>',
      \ 'left_alt': '>',
      \ 'right' : '<',
      \ 'right_alt' : '<',
      \ 'space' : ' '}

let g:scratch_persistence_file = '~/.vim/scratch.vim'

" let g:easytags_languages = {
" \   'javascript': {
" \     'cmd': 'es-ctags',
" \     'stdout_opt': '-f - ',
" \   }
" \}

if executable('ag')
  if has('win32unix')
    let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g "" | dos2unix'
  else
    let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  endif

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
    " autocmd FocusLost * :set norelativenumber
    " autocmd FocusGained * :set relativenumber
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
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType php setlocal ts=4 sts=4 sw=4 noexpandtab
augroup END

