set guioptions-=m guioptions-=T
" カラー設定:
if !exists("colors_name")
    colorscheme molokai
endif
colorscheme molokai
" ウインドウの幅
set columns=150
" ウインドウの高さ
set lines=50
" コマンドラインの高さ(GUI使用時)
set cmdheight=1
"半透明
set transparency=6
"起動時にフルスクリーン
set fuoptions=maxvert,maxhorz

set clipboard=unnamed,autoselect
