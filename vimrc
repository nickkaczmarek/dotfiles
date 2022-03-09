set nocompatible              " be iMproved, required
filetype off                  " required
set path+=**
set wildmenu

set tabstop=8     " tabs are at proper location
set expandtab     " don't use actual tab character (ctrl-v)
set shiftwidth=4  " indenting is 4 spaces
set autoindent    " turns it on
set smartindent   " does the right thing (mostly) in programs
set cindent       " stricter rules for C programs

set incsearch     " incremental searching
set hlsearch      " highlighting for search

" Theme
 syntax enable
 set background=dark    " Setting dark mode
" for vim 7
 set t_Co=256

" for vim 8
 if (has("termguicolors"))
  set termguicolors
 endif

"colorscheme gruvbox

set laststatus=2
set number numberwidth=1
set softtabstop=2
set shiftwidth=2

" show | and * in help text
:set conceallevel=0
:hi link HelpBar Normal
:hi link HelpStar Normal

command! WQ wq
command! Wq wq
command! W w
command! Q q


""""Insert mode mappings
inoremap <c-d> <esc>ddi
"THIS
"lowercase word
"uppercase word
inoremap <c-u> <esc>viwUi
inoremap <M-l> <esc>viwui
"select word
inoremap <c-i> <esc>viw

""""Normal mode mappings
"line down
noremap <M-Down> ddp

"line up
noremap <M-Up> ddkP

"Lowercase word
nnoremap <c-l> viwu

"Uppercase word
nnoremap <c-u> viwU

nnoremap <leader>d dd
nnoremap <leader>c ddO

"Quick edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"Shortcut for sourcing vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

"Surround word with double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
"Single quotes
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

":noremap <Up> 5k
":noremap <Down> 5j
