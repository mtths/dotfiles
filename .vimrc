execute pathogen#infect()
syntax on
set t_Co=256
colorscheme badwolf
"colorscheme ez
"set background=dark

if exists('+colorcolumn')
    set colorcolumn=78
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>78v.\+', -1)
endif

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

set modelines=3
let mapleader = ","

set list listchars=tab:▸\ ,trail:‧,nbsp:˔
nmap <silent> <leader>tt :set nolist!<CR>

" reset search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

" keep some context around cursor
set scrolloff=3

" ignore whitespace in diff mode
set diffopt+=iwhite

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

set encoding=UTF-8
"someone set up us the BOM
"set bomb

set statusline=%f%m%r%h%w\ [%{&ff}]%y\%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k(%l/%L,%v)\ %p%%
set laststatus=2

set winminheight=0
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" svn diff mode
map <leader>df :new<cr>:r!svn diff<cr>:set ft=diff<cr>:resize<cr>gg
vmap <leader>bl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

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

set expandtab
set sw=4
set ts=4

set undodir=~/.vim/undodir

set switchbuf=split

" plugins ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
nmap ,a :Ack 

" syntastic.vim
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_perl_checker=1
let g:syntastic_perl_perlcritic_thres=4
let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_interpreter='perl'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" gundo.vim
nnoremap <F5> :GundoToggle<CR>

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1

" trailing-whitespace
map <leader>fw :FixWhitespace<CR>

let g:gofmt_command="goimports"

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType perl setlocal omnifunc=PerlComplete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\|\h\w*->\h\w*\|\h\w*::\|\h\w*::\h\w*'
