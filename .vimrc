" ~/.vimrc

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

" options {{{
" ===========

set nocompatible " Be iMproved
let mapleader="," " set leader early to avoid problems

filetype plugin indent on
syntax enable

set encoding=utf-8
set ff=unix
set number
set relativenumber
set clipboard=unnamedplus
set showmatch " show matching brackets
set hidden
set autoread
" CVE-2002-1377, CVE-2016-1248,
" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set nomodeline

set incsearch " Find as you type search
set hlsearch " Highlight search terms
set ignorecase " Case-insensitive searching.
set smartcase " But case-sensitive if expression contains a capital letter.

set complete-=i
set nrformats-=octal
set ttimeout
set ttimeoutlen=100

set history=10000 " remember more commands and search history
set undolevels=10000 " use many levels of undo

set nobackup
set noswapfile
set viminfo^=! " always save upper case variables to viminfo file

set autoindent
set tabstop=8
set smarttab
set backspace=indent,eol,start
set shiftwidth=8
set textwidth=80
set cc=81

set list
set listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:+

set lazyredraw
set wildmenu
set wildignore+=*.a,*.o,*.class
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

set scrolloff=1 " always show at least one line above/below the cursor.
set sidescrolloff=5
set display+=lastline

set formatoptions+=j " delete comment character when joining commented lines

if &sessionoptions =~# '\<options\>'
  set sessionoptions-=options
  set sessionoptions+=localoptions
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

if !has('gui_running') && &t_Co != 256
  colorscheme  delek
else
  colorscheme distinguished
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" }}}
" general mappings {{{
" ====================
" Plugin-specific mappings can be found under plugin settings->mappings

inoremap <C-U> <C-G>u<C-U>

" jk is escape
inoremap jk <esc>

" switch buffers with space!
nnoremap <space> :call SwitchBuffer()<CR>

map <silent> <leader>1 :diffget LO<CR>:diffupdate<CR>
map <silent> <leader>2 :diffget BA<CR>:diffupdate<CR>
map <silent> <leader>3 :diffget RE<CR>:diffupdate<CR>

map Q @
map <S-m> :bprevious<CR>
map m :bnext<CR>

" map F5 to removing trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" save file with root permissions
cmap w!! w !sudo tee % >/dev/null

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" }}}
" autocommands {{{
" ================

" filetype specific {{{

" Markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

" java
au BufNewFile,BufRead *.java set tabstop=4 softtabstop=4 shiftwidth=4 cc=121

" PKGBUILD
autocmd BufRead,BufNew PKGBUILD set filetype=sh

" }}}

augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" }}}
" functions {{{
" =============

function! SwitchBuffer()
    exe "ls"
    let c = nr2char(getchar())
    exe "b " . c
    redraw
endfunction

" }}}
" plugin settings {{{
" ===================

" mappings {{{

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" Automatically import
nmap <leader>ai <Plug>(JavaComplete-Imports-AddMissing)

nnoremap <C-p> :Files<cr>

" }}}

" airline {{{
set laststatus=2
let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" only enable trailing whitespace checking
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#wordcount#enabled = 0 " extremely slow on bigger files
" }}}

" ALE {{{
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" html
let g:ale_linters = {
\   'html': ['htmlhint', 'tidy'],
\   'text': ['proselint', 'vale'],
\}
" }}}

" fzf
let $FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

" supertab
let g:SuperTabDefaultCompletionType = "context"

" markdown
let g:vim_markdown_math = 1

" hexmode
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.rom'

" }}}

" vim:fdm=marker
