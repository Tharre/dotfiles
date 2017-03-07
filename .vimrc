" Plugins for review:
"   'msanders/snipmate.vim'
"   'godlygeek/tabular'
"   'plasticboy/vim-markdown'
" Consider using sections like this:
"     Section Name {{{
"     set number "This will be folded
"     }}}

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()
set nocompatible " Be iMproved
let mapleader="," " set leader early as otherwise it wouldn't work
filetype plugin indent on

" ========== general settings ==========
set encoding=utf-8
set ff=unix
set number
set clipboard=unnamedplus
set showmatch " show matching brackets

set incsearch " Find as you type search
set hlsearch " Highlight search terms
set ignorecase " Case-insensitive searching.
set smartcase " But case-sensitive if expression contains a capital letter.

set history=1000 " remember more commands and search history
set undolevels=1000 " use many levels of undo

set nobackup
set noswapfile

set tabstop=4
set shiftwidth=4
set textwidth=80
set cc=81
"set expandtab

syntax enable
set background=dark
colorscheme distinguished

set list
set listchars=tab:>-,trail:~

set lazyredraw
set wildmenu

set relativenumber

set wildignore+=*.a,*.o,*.class
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

" jk is escape
inoremap jk <esc>

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" switch buffers with space!
nnoremap <space> :call SwitchBuffer()<CR>

function! SwitchBuffer()
    exe "ls"
    let c = nr2char(getchar())
    exe "b " . c
    redraw
endfunction

map <silent> <leader>1 :diffget LO<CR> :diffupdate<CR>
map <silent> <leader>2 :diffget BA<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget RE<CR> :diffupdate<CR>

map Q @
map <S-m> :tabprevious<CR>
map m :tabnext<CR>

" remove trailing whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

" save file with root permissions
cmap w!! w !sudo tee % >/dev/null

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" ========== file specific settings ==========
" Markdown
autocmd BufRead,BufNew *.md set filetype=markdown

" java
au BufNewFile,BufRead *.java set tabstop=4 softtabstop=4 shiftwidth=4 smarttab autoindent cc=121

" ========== plugin settings ==========
" airline
set laststatus=2
let g:airline_theme = 'powerlineish'
"let g:airline#extensions#tabline#enabled = 1 " make tabs look crazy
" only enable trailing whitespace checking
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#syntastic#enabled = 0

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" ctrlp
let g:ctrlp_max_files = 1000000
let g:ctrlp_cmd = 'CtrlPMixed'

" supertab
let g:SuperTabDefaultCompletionType = "context"

" javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

" Automatically import
nmap <leader>ai <Plug>(JavaComplete-Imports-AddMissing)

