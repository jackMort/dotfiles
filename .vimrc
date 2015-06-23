" pathogen
execute pathogen#infect()

" Shortcut to rapidly toggle `set list` with: /l
nmap <leader>l :set list!<CR>

" Invisible chars
set listchars=tab:▸\ ,eol:¬

set list
set tabstop=4 
set shiftwidth=4 
set expandtab
set number
set hidden
set nobackup

"colorscheme sherkhan
"colorscheme delek
colorscheme distinguished

syntax enable
filetype plugin indent on

" autocommands
if has( "autocmd" )
    autocmd BufEnter * :lcd %:p:h  " set current dir
endif

" Bubble single line
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" NERD tree
nmap <silent> <c-n> :NERDTreeToggle<CR>
let g:miniBufExplorerMoreThanOne = 0
let NERDTreeIgnore = ['\.pyc$']

" max line length
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" TODO
source ~/.vim/bundle/vim-flake8/ftplugin/python_flake8.vim

autocmd BufWritePost *.py call Flake8()

" PHP documenter script bound to Control-P
autocmd FileType php inoremap <C-c> <ESC>:call PhpDocSingle()<CR>i
autocmd FileType php nnoremap <C-c> :call PhpDocSingle()<CR>
autocmd FileType php vnoremap <C-c> :call PhpDocRange()<CR> 
