if g:dein#_cache_version != 100 | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/home/ytamura/.vimrc', '/home/ytamura/.vim/bundle/rc/dein.toml', '/home/ytamura/.vim/bundle/rc/dein_lazy.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/home/ytamura/.vim/bundle'
let g:dein#_runtime_path = '/home/ytamura/.vim/bundle/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/home/ytamura/.vim/bundle/.cache/.vimrc'
let &runtimepath = '/home/ytamura/.vim/bundle/repos/github.com/Shougo/dein.vim/,/home/ytamura/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/home/ytamura/.vim/bundle/repos/github.com/Shougo/dein.vim,/home/ytamura/.vim/bundle/.cache/.vimrc/.dein,/usr/share/vim/vim80,/home/ytamura/.vim/bundle/.cache/.vimrc/.dein/after,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,/home/ytamura/.vim/after'
filetype off
    let g:gen_tags#gtags_auto_gen = 1
    let g:gen_tags#use_cache_dir = 0
    noremap [denite-gtags]  <Nop>
    nmap ,t [denite-gtags]
    nnoremap [denite-gtags]d :<C-u>DeniteCursorWord -buffer-name=gtags_def -mode=normal gtags_def<CR>
    nnoremap [denite-gtags]r :<C-u>DeniteCursorWord -buffer-name=gtags_ref -mode=normal gtags_ref<CR>
    nnoremap [denite-gtags]c :<C-u>DeniteCursorWord -buffer-name=gtags_context -mode=normal gtags_context<CR>
    nnoremap [denite] <Nop>
    nmap <Space>f [denite]
    nmap <silent> [denite]f :<C-u>Denite file_rec -highlight-mode-insert=Search -sorters=sorter_word<CR>
    nmap <silent> [denite]d :<C-u>Denite file -highlight-mode-insert=Search -sorters=sorter_word<CR>
    nmap <silent> [denite]b :<C-u>Denite buffer -highlight-mode-insert=Search -sorters=sorter_word<CR>
    nmap <silent> [denite]l :<C-u>Denite line -highlight-mode-insert=Search<CR>
    nmap <silent> [denite]m :<C-u>Denite file_mru -highlight-mode-insert=Search<CR>
    nmap <silent> [denite]y :<C-u>Denite neoyank -highlight-mode-insert=Search<CR>
    nmap <silent> [denite]o :<C-u>Denite outline -highlight-mode-insert=Search<CR>
    nmap <silent> [denite]g :<C-u>Denite grep -highlight-mode-insert=Search<CR>
    nmap <silent> [denite]p :<C-u>DeniteBufferDir file_rec -highlight-mode-insert=Search<CR>
    if executable('rg')
      call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git', '!node_modules'])
      call denite#custom#var('grep', 'command', ['rg'])
    endi
    let g:Gtags_Auto_Map = 0
    let g:Gtags_OpenQuickfixWindow = 1
    nmap <silent> K :<C-u>exe("Gtags ".expand('<cword>'))<CR>
    nmap <silent> R :<C-u>exe("Gtags -r ".expand('<cword>'))<CR>''
