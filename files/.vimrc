set encoding=utf-8

" =======================================================
" -------------------> dein.vim
" =======================================================

let s:dein_dir = $HOME . '/.vim/bundle'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " Load and cached toml
  " all plugins listed in toml
  call dein#load_toml(s:dein_dir . '/rc/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_dir . '/rc/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" =======================================================
" -------------------> color
" =======================================================

syntax on

" vim-go additional highlight
" ※この位置に書かないとオリジナルのmolokaiのカラーにならない..
hi def link   goVarDefs           Identifier
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_function_arguments = 1
" https://github.com/hnakamur/vim-go-tutorial-ja#vimrc-%E3%81%AE%E6%94%B9%E5%96%84-4
let g:rehash256 = 1
let g:molokai_original = 1

"===== light theme
"set background=light
"colorscheme one

"===== dark theme
set background=dark
"colorscheme molokai
"colorscheme hybrid_material
"colorscheme gruvbox
"colorscheme afterglow
colorscheme hybrid_material

" tab color
highlight TabLineFill ctermfg=238 ctermbg=236
" status line color
highlight StatusLine ctermfg=243 ctermbg=236
highlight StatusLineNC ctermfg=240 ctermbg=234
" color of pane splitter
set foldcolumn=0
highlight foldcolumn ctermbg=236 guibg=NONE
highlight VertSplit ctermbg=236 guibg=NONE guifg=NONE
" vim-indent-guides
" 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=NONE ctermbg=236
" 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=NONE ctermbg=235
" alacrittyで背景半透明に
highlight Normal ctermbg=none guibg=NONE
" markdownのハイライトを有効にする
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown

highlight Pmenu ctermbg=237 guibg=237

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" =======================================================
" -------------------> fundamentals
" =======================================================

" Set to auto read when a file is changed from the outside
set autoread
"新しい行のインデントを現在行と同じにする
set autoindent
"バックアップファイルを作るディレクトリ
set backupdir=$HOME/.vimbackup
"Vim の undo 履歴を ~/.vimundo ディレクトリに保存して、次回起動時に復元する (Vim 7.3 以降)
set undodir=~/.vimundo undofile
"スワップファイル用のディレクトリ
set directory=$HOME/.vimbackup
"ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer
"Vi互換をオフ
set nocompatible
"タブの代わりに空白文字を挿入する
set expandtab
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
"インクリメンタルサーチを行う
set incsearch
"タブ文字、行末など不可視文字を表示する
"set list
"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>\ ,extends:<
"行番号を表示する
set number
"検索時に大文字を含んでいたら大/小を区別
set smartcase
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"ファイル内の <Tab> が対応する空白の数
set tabstop=4
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
"タブを4スペースに
set ts=4
"検索時に大文字、小文字を区別しない
set ignorecase
set smartcase
"インサートモードでバックスペースで削除出来るように
set backspace=start,eol,indent
" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null
" Turn on the WiLd menu
set wildmenu
set wildmode=longest,list,full
"Always show current position
set ruler
" Highlight search results
set hlsearch
" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2"

" Do not yank when paste
nnoremap x "0x
vnoremap x "0x
nnoremap d "0d
vnoremap d "0d
nnoremap p "0p
vnoremap p "0p
nnoremap P "0P
vnoremap P "0P

"画面分割時にcontrol + l, h, j, kで移動
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" control + / 2回でコメントアウト・イン
nmap <C-/><C-/> :TComment

"自動インデント時にタブが2つ付くのを防ぐ
set softtabstop=4
set shiftwidth=4

"インサートモードでjjを押下するとESC相当 + l相当
inoremap <silent> jj <ESC>l
"インサートモードでcountrol + jを押下するとESC
inoremap <silent> <C-j> <ESC>
"勝手に改行させない
"set formatoptions=q
set formatoptions+=or
" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on
" JSONファイルのconcealを無効に
let g:vim_json_syntax_conceal = 0

" オムニ補完
"imap <C-f> <C-x><C-o>
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Into insert mode with :set paste mode
nnoremap ,i :<C-u>set paste<Return>i

" Turn off paste mode when leaving insert.
" Usually used 'InsertLeave', but anyhow it doesn't work
" as it supporsed to be on Vim8 nor NeoVim, so workaround with
" 'CursorMoved' -> https://github.com/neovim/neovim/issues/4609
autocmd CursorMoved * set nopaste

" set <Space> for Leader
" http://postd.cc/how-to-boost-your-vim-productivity/
let mapleader = "."

" http://qiita.com/szk3/items/e33df9acea5050f29a07
set synmaxcol=1000

" 空白行でエスケープした時にインデントを消さない
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>

" clip board
set clipboard+=unnamed

" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

" =======================================================
" -------------------> indent
" =======================================================

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.pug setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.scss setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.re setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

"-------------------------------------
" vim-indent-guides
"-------------------------------------
" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量
let g:indent_guides_start_level=1
" 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" ハイライト色の変化の幅
let g:indent_guides_color_change_percent = 100
" ガイドの幅
let g:indent_guides_guide_size = 1

" =======================================================
" -------------------> status line
" =======================================================

" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" file encoding
set statusline+=[%{&fileencoding}]
" 現在行数/全行数
set statusline+=[row=%l/%L]
" ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2

" =======================================================
" -------------------> tab
" =======================================================

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
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>

" " =======================================================
" " -------------------> denite.vim
" " =======================================================

call denite#custom#option('default', 'prompt', '>')
call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>')
call denite#custom#source('file_mru', 'matchers', ['matcher_regexp'])
call denite#custom#source('file', 'matchers', ['matcher_regexp'])
call denite#custom#source('buffer', 'matchers', ['matcher_regexp'])
call denite#custom#source('line', 'matchers', ['matcher_regexp'])
call denite#custom#source('file_mru', 'matchers', ['matcher_regexp'])
call denite#custom#source('neoyank', 'matchers', ['matcher_regexp'])
call denite#custom#source('outline', 'matchers', ['matcher_regexp'])
call denite#custom#source('grep', 'matchers', ['matcher_regexp'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', 'build/', '__pycache__/', 'node_modules/',
      \ 'images/', '*.o', '*.make',
      \ '*.min.*',
      \ 'img/', 'fonts/'])
call denite#custom#option('_', 'auto_resize', 'true')

" Define mappings
nnoremap [denite] <Nop>
nmap <Space>f [denite]
nnoremap <silent> [denite]f :<C-u> Denite file/rec<CR>
nnoremap <silent> [denite]g :<C-u> Denite grep<CR>
nnoremap <silent> [denite]b :<C-u> Denite buffer<CR>
nnoremap <silent> [denite]m :<C-u> Denite file_mru<CR>
nnoremap <silent> [denite]d :<C-u> Denite file<CR>
nnoremap <silent> [denite]l :<C-u> Denite line<CR>
nnoremap <silent> [denite]y :<C-u> Denite neoyank<CR>
nnoremap <silent> [denite]o :<C-u> Denite outline<CR>
nnoremap <silent> [denite]p :<C-u> Denite file_rec<CR>
nnoremap <silent> [denite]h :<C-u> Denite command_history<CR>
nnoremap <silent> [denite]c :<C-u> Denite colorscheme<CR>
" denite-git
nnoremap <silent> [denite]s :<C-u> Denite gitstatus<CR>
nnoremap <silent> [denite]j :<C-u>DeniteCursorWord grep:.<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
	  nnoremap <silent><buffer><expr> <CR>      denite#do_map('do_action')
	  nnoremap <silent><buffer><expr> d         denite#do_map('do_action', 'delete')
	  nnoremap <silent><buffer><expr> p         denite#do_map('do_action', 'preview')
	  nnoremap <silent><buffer><expr> q         denite#do_map('quit')
	  nnoremap <silent><buffer><expr> <C-c>     denite#do_map('quit')
	  nnoremap <silent><buffer><expr> i         denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> <Space>   denite#do_map('toggle_select').'j'
endfunction
autocmd FileType denite-filter call s:denite_filter_my_settings()
	function! s:denite_filter_my_settings() abort
	  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

if executable('rg')
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
endif

"-------------------
" neomru
"-------------------

let g:neomru#file_mru_limit = 200
let g:neomru#directory_mru_limit = 200

" =======================================================
" -------------------> neosnippet
" =======================================================

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

" 自分用 snippet ファイルの場所
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.dotfiles/files/.vim/snippets/'
let g:neosnippet#disable_runtime_snippets = {'_' : 1}


" =======================================================
" -------------------> vim-gitgutter
" =======================================================

let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_removed = '-'
highlight GitGutterAddLine gui=bold ctermbg=233
highlight GitGutterChangeLine gui=bold ctermbg=233
highlight GitGutterDeleteLine gui=bold ctermbg=52
highlight GitGutterChangeDeleteLine gui=bold ctermbg=233
highlight GitGutterAdd ctermbg=none ctermfg=34
highlight GitGutterChange ctermbg=none ctermfg=3
highlight GitGutterDelete ctermbg=none ctermfg=124
highlight GitGutterChangeDelete ctermbg=none ctermfg=13


" =======================================================
" -------------------> NERD TREE
" =======================================================

let g:NERDTreeWinPos = "right"
nmap <C-i> :<C-u>NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeShowBookmarks = 1
let NERDTreeWinSize=36
highlight Directory guifg=#AAAAAA ctermfg=245 ctermbg=233

" =======================================================
" -------------------> Language Support
" =======================================================

"-------------------
" ALE
"-------------------

" ale fixのみ使用する
let g:ale_enabled = 0
let g:ale_fix_on_save = 0
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'reason': ['refmt'],
\}
nmap <silent> <C-a> <Plug>(ale_fix)

"-------------------
" coc.nvim
"-------------------

" プラグイン（自動アップデート）
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#update-extensions
let g:coc_global_extensions = [
            \ 'coc-pairs',
            \ 'coc-go',
            \ 'coc-prettier',
            "\ 'coc-snippets',
            "\ 'coc-emmet',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-yaml',
            \ 'coc-json',
            \ 'coc-tsserver',
            \ 'coc-phpls',
            \ 'coc-rls',
            \ 'coc-rust-analyzer',
            \ 'coc-solargraph',
\ ]

" coc-pairs
" https://qiita.com/maguro_tuna/items/70814d99aef8f1ddc8e9
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> go  :<C-u>CocList diagnostics<cr>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"-------------------
"emmet-vim (zencoding)
"-------------------
let g:user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_expandword_key = '<c-e>'
let g:user_emmet_install_global = 0
autocmd FileType html,css,php,reason,rescript,vue,typescriptreact,javascript.jsx EmmetInstall
autocmd BufWritePost *.res RescriptFormat

"-------------------
"vim-go
"-------------------
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)

"-------------------
"slimv (lisp)
"-------------------
let g:slimv_repl_split = 4
let g:slimv_repl_name = 'REPL'
let g:slimv_repl_simple_eval = 0
"let g:slimv_lisp = '/usr/bin/clisp'
let g:slimv_impl = 'clisp'
let g:slimv_preferred = 'clisp'
let g:lisp_rainbow=1
let g:paredit_electric_return = 0
au FileType lisp IndentGuidesDisable
au FileType lisp inoremap ' '

"-------------------
"ghcmod.vim (haskell)
"-------------------
autocmd BufWritePost *.hs GhcModCheckAndLintAsync
let g:necoghc_enable_detailed_browse = 1
hi ghcmodType ctermbg=lightcyan
let g:ghcmod_type_highlight = 'ghcmodType'

au BufNewFile,BufRead *.hs map <Leader>t :GhcModType<cr>
au BufNewFile,BufRead *.hs map <Leader>tt :GhcModTypeClear<cr>
let g:hoogle_search_count=15
let g:hoogle_search_buf_name='Hoogle'
au BufNewFile,BufRead *.hs map <silent> <leader>h :Hoogle<CR>
au BufNewFile,BufRead *.hs map <buffer> <Leader>hh :HoogleClose<CR>

au BufRead,BufNewFile *.qmu set filetype=qmu
au BufRead,BufNewFile *.re set filetype=reason
au BufRead,BufNewFile *.res set filetype=rescript
au BufRead,BufNewFile *.hbs set filetype=html

"php
let g:php_baselib       = 1
let g:php_htmlInStrings = 1

" tsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
" Jenkinsfile
au BufNewFile,BufRead Jenkinsfile setf groovy
" antlr4
autocmd BufNewFile,BufRead *.g4  set filetype=antlr
" elm
autocmd BufNewFile,BufRead *.elm  set filetype=elm
" vue
let g:vue_disable_pre_processors=1
autocmd FileType vue syntax sync fromstart
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.typescript.css
" coffee
autocmd FileType coffee    setlocal sw=2 sts=2 ts=2 et
