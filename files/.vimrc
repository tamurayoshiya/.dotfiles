set encoding=utf-8
syntax on
set background=dark
colorscheme slate
highlight Normal ctermbg=none guibg=NONE
highlight Pmenu ctermbg=237 guibg=#555555
highlight TabLineFill ctermfg=238 ctermbg=236
highlight StatusLine ctermfg=243 ctermbg=236
highlight StatusLineNC ctermfg=240 ctermbg=234
highlight VertSplit ctermbg=236 guibg=NONE guifg=NONE
set foldcolumn=0
highlight foldcolumn ctermbg=236 guibg=NONE

set nocompatible
set autoread
set autoindent
set expandtab
set hidden
set incsearch
set number
set ignorecase
set smartcase
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=start,eol,indent
set wildmenu
set wildmode=longest,list,full
set ruler
set hlsearch
set showmatch
set mat=2
set whichwrap=b,s,h,l,<,>,[,]
set listchars=eol:$,tab:>\ ,extends:<
set synmaxcol=1000
set clipboard+=unnamed
set noswapfile
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimbackup
set undodir=~/.vimundo
set undofile
set formatoptions+=or
set showtabline=2

filetype plugin indent on

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
inoremap <silent> jj <ESC>l
inoremap <silent> <C-j> <ESC>
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>
nnoremap ,i :<C-u>set paste<Return>i
autocmd CursorMoved * set nopaste
command W w !sudo tee % > /dev/null

nnoremap [Tag] <Nop>
nmap t [Tag]
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.js,*.ts,*.tsx,*.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.css,*.scss,*.yaml,*.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.md setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
