set encoding=utf-8
syntax on
hi def link   goVarDefs           Identifier
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_function_arguments = 1
let g:rehash256 = 1
let g:molokai_original = 1
set background=dark
colorscheme slate
highlight TabLineFill ctermfg=238 ctermbg=236
highlight StatusLine ctermfg=243 ctermbg=236
highlight StatusLineNC ctermfg=240 ctermbg=234
set foldcolumn=0
highlight foldcolumn ctermbg=236 guibg=NONE
highlight VertSplit ctermbg=236 guibg=NONE guifg=NONE
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=NONE ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=NONE ctermbg=235
highlight Normal ctermbg=none guibg=NONE
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.prisma set filetype=prisma
highlight Pmenu ctermbg=237 guibg=#555555
set autoread
set autoindent
set backupdir=$HOME/.vimbackup
set undodir=~/.vimundo undofile
set directory=$HOME/.vimbackup
set browsedir=buffer
set nocompatible
set expandtab
set hidden
set incsearch
set listchars=eol:$,tab:>\ ,extends:<
set number
set smartcase
set smartindent
set smarttab
set tabstop=4
set whichwrap=b,s,h,l,<,>,[,]
set ts=4
set ignorecase
set smartcase
set backspace=start,eol,indent
command W w !sudo tee % > /dev/null
set wildmenu
set wildmode=longest,list,full
set ruler
set hlsearch
set showmatch
set mat=2"
nnoremap x "0x
vnoremap x "0x
nnoremap d "0d
vnoremap d "0d
nnoremap p "0p
vnoremap p "0p
nnoremap P "0P
vnoremap P "0P
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nmap <ESC><ESC> :nohlsearch<CR><ESC>
nmap <C-/><C-/> :TComment
set softtabstop=4
set shiftwidth=4
inoremap <silent> jj <ESC>l
inoremap <silent> <C-j> <ESC>
set formatoptions+=or
filetype plugin indent on
let g:vim_json_syntax_conceal = 0
nnoremap ,i :<C-u>set paste<Return>i
autocmd CursorMoved * set nopaste
let mapleader = "."
set synmaxcol=1000
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>
set clipboard+=unnamed
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.pug setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.scss setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.re setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.qtpl setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.pu setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ------------
" tab
" ------------

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
  let bufnrs = tabpagebuflist(i)
  let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
  let no = i  " display 0-origin tabpagenr.
  let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
  let title = fnamemodify(bufname(bufnr), ':t')
  let title = '[' . title . ']'
  let s .= '%'.i.'T'
  let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
  let s .= no . ':' . title
  let s .= mod
  let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

