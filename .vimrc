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
colorscheme xoria256

syntax enable

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
