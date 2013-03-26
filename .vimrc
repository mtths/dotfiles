call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
syntax on
colorscheme badwolf
"colorscheme ez
set background=dark

if exists('+colorcolumn')
    set colorcolumn=78
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>78v.\+', -1)
endif

let g:SuperTabDefaultCompletionType = "context"

" jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    au BufNewFile,BufRead *.tt2,*.tt setf tt2 

    " Use perl compiler for all *.pl and *.pm files.
    autocmd BufNewFile,BufRead *.p[lm] compiler perl
    " :make :clist :cnext :cprevious
    autocmd BufNewFile,BufRead *.p6 setfiletype perl6
    autocmd! BufWritePost *.pl :silent! !chmod +x %
    "autocmd! BufWrite *.p[lm] !perl -c %
    autocmd FileType perl source ~/.vim/vimperl
    autocmd FileType tt2 source ~/.vim/vimtt2
endif

if has("autocmd")
    filetype plugin indent on
endif

set titlestring=%f title        " set the file name as terminal title

set showcmd                     " Show (partial) command in status line.
set showmatch                   " Show matching brackets.
set ignorecase                  " Do case insensitive matching
set smartcase                   " Do smart case matching
set hlsearch                    " highlight the last used search pattern
set incsearch                   " Incremental search
set nobackup                    " Don't create backup files
set noswapfile
set backspace=indent,eol,start  " backspacing over everything in insert mode
set smartindent                 " smart autoindenting when starting a new line
set hidden                      " manage multiple buffers effectively
set smarttab

set modelines=3
let mapleader = ","

set list listchars=tab:>-,trail:‧
nmap <silent> <leader>tt :set nolist!<CR>

map Y y$

" reset search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

" keep some context around cursor
set scrolloff=3

" folding settings
set foldmethod=syntax   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"some selfdefined mappings
"    ;; regex search & replace w/ global modifier
"map ;; :%s:::g<Left><Left><Left>

"indent the whole file
function! MyIndent()
    let oldLine=line('.')
    normal(gg=G)
    execute ':' . oldLine
endfun

map <leader>in :call MyIndent()<cr>

set pastetoggle=<F11>

"Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

"set tags=tags\ /usr/local/www/.tags
"let Tlist_Ctags_Cmd="/usr/bin/ctags-exuberant"

set encoding=UTF-8
"someone set up us the BOM
"set bomb

set statusline=%f%m%r%h%w\ [%{&ff}]%y\%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k(%l/%L,%v)\ %p%%
set laststatus=2

set winminheight=0
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

vmap <leader>bl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" automatically source the .vimrc file if I change it
" the bang (!) forces it to overwrite this command rather than stack it
autocmd! BufWritePost .vimrc source %

noremap <leader>v  :source ~/.vimrc<cr>
noremap <leader>V  :split ~/.vimrc<cr>

inoremap <f5> :make<cr>
noremap <f5> :make<cr>

" highlight current line (toggle)
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
"hi CursorLine   cterm=NONE ctermbg=lightgrey ctermfg=darkgrey guibg=lightgrey guifg=darkgrey
"hi CursorColumn cterm=NONE ctermbg=lightgrey ctermfg=darkgrey guibg=lightgrey guifg=darkgrey
nnoremap <leader>cl :set cursorline!<CR>

set expandtab
set sw=4
set ts=4
