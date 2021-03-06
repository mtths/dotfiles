call pathogen#infect()
call pathogen#helptags()

syntax on
set t_Co=256
colorscheme rupza
set background=dark

au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>78v.\+', -1)

"let g:SuperTabDefaultCompletionType = "context"

" jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    au BufNewFile,BufRead *.tt2,*.tt setf tt2

    " Use perl compiler for all *.pl and *.pm files.
    autocmd BufNewFile,BufRead *.p[lm] compiler perl
    autocmd BufNewFile,BufRead *.psgi setfiletype perl
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
set wrap

set modelines=3
let mapleader = ","

set encoding=UTF-8
"someone set up us the BOM
"set bomb

set list listchars=tab:▸\ ,trail:‧,nbsp:˔
nmap <silent> <leader>nl :set nolist!<CR>

" reset search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

nmap <F5> :cnext<CR>

" keep some context around cursor
set scrolloff=3

" ignore whitespace in diff mode
set diffopt+=iwhite


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

" make <C-Left/Right> work again
if &term =~ "^screen"
    map <esc>[1;5D <C-Left>
    map <esc>[1;5C <C-Right>
endif

set pastetoggle=<F11>

"Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

"set tags=tags\ /usr/local/www/.tags
"let Tlist_Ctags_Cmd="/usr/bin/ctags-exuberant"

set statusline=%f%m%r%h%w\ [%{&ff}]%y\%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k(%l/%L,%v)\ %p%%
set laststatus=2

set winminheight=0
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" automatically source the .vimrc file if I change it
" the bang (!) forces it to overwrite this command rather than stack it
autocmd! BufWritePost .vimrc source %

noremap <leader>v  :source ~/.vimrc<cr>
noremap <leader>V  :split ~/.vimrc<cr>

" highlight current line (toggle)
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
"hi CursorLine   cterm=NONE ctermbg=lightgrey ctermfg=darkgrey guibg=lightgrey guifg=darkgrey
"hi CursorColumn cterm=NONE ctermbg=lightgrey ctermfg=darkgrey guibg=lightgrey guifg=darkgrey
nnoremap <leader>cl :set cursorline!<CR>

" write buffer with elevated permissions
cmap w!! w !sudo tee % >/dev/null

set expandtab
set sw=4
set ts=4

if has("persistent_undo")
    set undodir=~/.undodir
    set undofile
endif

set switchbuf=split

function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

nnoremap <leader>fw :call StripTrailingWhitespace()<cr>

if executable("ag")
    set grepprg=ag\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

nnoremap <leader>b :sb <C-d>
nnoremap <c-p> :tabe **/
nnoremap <leader>e :sp **/
nnoremap <leader>a :grep<space>

runtime macros/matchit.vim

" open quickfix window automatically on make/grep
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" plugins ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" vim-gitgutter recommended
set updatetime=250

" pear-tree
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_pairs = {
\   '(': {'closer': ')'},
\   '[': {'closer': ']'},
\   '{': {'closer': '}'},
\   "'": {'closer': "'"},
\   '"': {'closer': '"'},
\   '<*>': {'closer': '</*>', 'not_if': ['br', 'meta', 'img'], 'until': '\W'}
\ }

" ale.vim
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_open_list = 'on_save'
let g:ale_linters = {
\   'perl': ['perl','perlcritic'],
\}

" lightline.vim
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⚿":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '>', 'right': '<' },
      \ 'subseparator': { 'left': '>', 'right': '<' }
      \ }

let g:gofmt_command="goimports"

" replace neocomplete with vimcompletesme
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:vcm_omni_pattern = '\h\w*->\|\h\w*->\h\w*\|\h\w*::\|\h\w*::\h\w*'

" fugitive.vim
map <leader>gs :Gstatus<cr>

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
