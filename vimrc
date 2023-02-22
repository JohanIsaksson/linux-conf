" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Load plugins here
call plug#begin()

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ajh17/vimcompletesme'

call plug#end()

" clangd
if executable('clangd')
  augroup lsp_clangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
      \ })
    autocmd FileType c setlocal omnifunc=lsp#complete
    autocmd FileType cpp setlocal omnifunc=lsp#complete
    autocmd FileType objc setlocal omnifunc=lsp#complete
    autocmd FileType objcpp setlocal omnifunc=lsp#complete
  augroup end
endif

" hdl checker
if executable('hdl_checker')
  augroup lsp_hdl
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'hdl_checker',
      \ 'cmd': {server_info->['hdl_checker', '--lsp', '--log-level', 'DEBUG']},
      \ 'allowlist': ['vhdl'],
      \ })
    autocmd FileType vhdl setlocal omnifunc=lsp#complete
  augroup end
endif


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> lgd <plug>(lsp-definition)
    nmap <buffer> lgs <plug>(lsp-document-symbol-search)
    nmap <buffer> lgS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> lgr <plug>(lsp-references)
    nmap <buffer> lgi <plug>(lsp-implementation)
    nmap <buffer> lgt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> l[g <plug>(lsp-previous-diagnostic)
    nmap <buffer> l]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" Tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Turn on syntax highlighting
syntax enable

" For plugins to load correctly
filetype plugin indent on

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
au FileType gitcommit setlocal tw=72
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
"set softtabstop=-1
set expandtab
set noshiftround
set autoindent
set smarttab
function TabToggle()
  if &expandtab
    set softtabstop=0
    set noexpandtab
  else
    set softtabstop=-1
    set expandtab
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

set formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*
set formatoptions+=n

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Visualize tabs and newlines
set listchars=tab:▸\ ,trail:.
",eol:¬,space:.
" Uncomment this to enable by default:
set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
"set t_Co=256
set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" backup  settings {{{
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup
" }}}

" swap settings {{{
" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.
" }}}

" viminfo settings {{{
" viminfo stores the state of your previous editing session
set viminfo+=n~/.vim/viminfo
" }}}

" undo settings {{{
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif
" }}}

syntax on
colorscheme sublimemonokai

set number
set tags=tags;/

"command gd <C-]>
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
"nmap <C-9> <C-w><C-]><C-w>T
"

" Change cursor in insert mode
"let &t_SI = \<Esc>]50;CursorShape=1\x7"
let &t_SI = "\e[5 q"
"let &t_SR = \<Esc>]50;CursorShape=2\x7"
let &t_SR = "\e[1 q"
"let &t_EI = \<Esc>]50;CursorShape=0\x7"
let &t_EI = "\e[2 q"

:autocmd InsertEnter,InsertLeave * set cul!
set ttimeout
set ttimeoutlen=1
set ttyfast

set runtimepath^=~/.vim/bundle/ctrlp.vim
