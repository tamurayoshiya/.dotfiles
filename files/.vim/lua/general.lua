vim.opt.autoread = true -- ファイルが外部で変更された場合、自動的に読み直す
vim.opt.autoindent = true -- 新しい行を挿入するときに、前の行のインデントを自動的に継承する
vim.opt.expandtab = true -- タブをスペースに変換する
vim.opt.hidden = true -- 編集中のバッファを保存せずに隠すことを許可する
vim.opt.incsearch = true -- 検索中に一致する部分をリアルタイムでハイライトする
vim.opt.number = true -- 行番号を表示する
vim.opt.ignorecase = true -- 検索時に大文字小文字を無視する
vim.opt.smartcase = true -- 検索時に小文字のみの場合は大文字小文字を区別しないが、大文字を含む場合は区別する
vim.opt.smartindent = true -- 新しい行のインデントを文脈に応じて調整する
vim.opt.smarttab = true -- タブキーの動作を現在のコンテキストに応じて調整する
vim.opt.backspace = "start,eol,indent" -- バックスペースキーが行の開始、行末、インデントを削除できるようにする
vim.opt.wildmenu = true -- コマンドライン補完時に、補完候補をメニュー形式で表示する
vim.opt.wildmode = "longest,list,full" -- コマンドライン補完の挙動を指定する
vim.opt.ruler = true -- ステータスラインにカーソルの行番号と列番号を表示する
vim.opt.hlsearch = true -- 検索結果をハイライトする
vim.opt.showmatch = true -- カッコの対応を表示する（例: `()`や`[]`など）
vim.opt.matchtime = 2 --  -- 入力された文字列がマッチするまでにかかる時間
vim.opt.listchars = { eol = "$", tab = "> ", extends = "<" } -- 不可視文字（改行、タブ、行の延長など）を視覚的に表示する文字を指定
vim.opt.whichwrap = "b,s,h,l,<,>,[,]" -- 行末などでカーソル移動可能に
vim.opt.compatible = false -- Vi互換モードをオフ
vim.opt.swapfile = false -- swapfileを作成しないように設定

-- バックアップ・Undo・スワップ用ディレクトリ
vim.opt.backupdir = vim.fn.expand("$HOME/.vimbackup")
vim.opt.directory = vim.fn.expand("$HOME/.vimbackup")
vim.opt.undodir = vim.fn.expand("$HOME/.vimundo")
vim.opt.undofile = true

-- タブ・インデント関連
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- :W で sudo して保存 (permission-deniedの時など)
vim.api.nvim_create_user_command("W", "w !sudo tee % > /dev/null", {})

-----------------------------------
-- キーマッピング

local opts = { noremap = true, silent = true }

-- yank に登録せずに削除・置換
vim.keymap.set("n", "x", '"0x', opts)
vim.keymap.set("v", "x", '"0x', opts)
vim.keymap.set("n", "d", '"0d', opts)
vim.keymap.set("v", "d", '"0d', opts)
vim.keymap.set("n", "p", '"0p', opts)
vim.keymap.set("v", "p", '"0p', opts)
vim.keymap.set("n", "P", '"0P', opts)
vim.keymap.set("v", "P", '"0P', opts)

-- 画面分割時の移動：Ctrl + {h,j,k,l}
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-W>h", opts)
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-W>j", opts)
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-W>k", opts)
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-W>l", opts)

-- Esc を2回押してハイライト消去
vim.keymap.set("n", "<ESC><ESC>", ":nohlsearch<CR><ESC>", opts)

-- インサートモードで jj を押下すると ESC 相当 + l 相当
vim.api.nvim_set_keymap("i", "jj", "<ESC>l", { silent = true })

-- インサートモードで Control + j を押下すると ESC
vim.api.nvim_set_keymap("i", "<C-j>", "<ESC>", { silent = true })

-- 勝手に改行させない
vim.opt.formatoptions:append("or")

-- ファイル形式の検出、プラグインとインデントを有効化
vim.cmd("filetype plugin indent on")

-- JSONファイルの conceal を無効化
vim.g.vim_json_syntax_conceal = 0

-- オムニ補完
vim.api.nvim_set_keymap("i", "<S-TAB>", [[pumvisible() and "\<C-p>" or "\<S-TAB>"]], { expr = true, noremap = true })

-- Insert mode with :set paste mode
vim.api.nvim_set_keymap("n", ",i", ":<C-u>set paste<CR>i", { noremap = true })

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = "*",
	command = "set nopaste",
})

-- synmaxcolの設定
vim.o.synmaxcol = 1000

-- 空白行でエスケープした時にインデントを消さない
vim.api.nvim_set_keymap("i", "<CR>", "<CR>x<BS>", { noremap = true })
vim.api.nvim_set_keymap("n", "o", "ox<BS>", { noremap = true })
vim.api.nvim_set_keymap("n", "O", "Ox<BS>", { noremap = true })

-- クリップボードの設定
vim.opt.clipboard:append("unnamed")

-- VimShowHlItem: カーソル下のハイライト名を表示
vim.api.nvim_create_user_command("VimShowHlItem", function()
	local synID = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
	local name = vim.fn.synIDattr(synID, "name")
	print(name)
end, {})

-- SID_PREFIX関数の代替
local function sid_prefix()
	return debug.getinfo(1, "S").short_src -- `<sfile>` の代替
end

-- タブライン設定
vim.o.showtabline = 2 -- 常にタブラインを表示

-- プレフィックスキーの設定
vim.api.nvim_set_keymap("n", "[Tag]", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "t", "[Tag]", {})

-- タブジャンプの設定
for n = 1, 9 do
	vim.api.nvim_set_keymap("n", "[Tag]" .. n, ":<C-u>tabnext " .. n .. "<CR>", { noremap = true, silent = true })
end

-- タブ操作のマッピング
vim.api.nvim_set_keymap("n", "[Tag]c", ":tablast | tabnew<CR>", { noremap = true, silent = true }) -- 新しいタブ
vim.api.nvim_set_keymap("n", "[Tag]x", ":tabclose<CR>", { noremap = true, silent = true }) -- タブを閉じる
vim.api.nvim_set_keymap("n", "[Tag]n", ":tabnext<CR>", { noremap = true, silent = true }) -- 次のタブ
vim.api.nvim_set_keymap("n", "[Tag]p", ":tabprevious<CR>", { noremap = true, silent = true }) -- 前のタブ

-- TypeScriptのindent
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact" }, -- TypeScriptとTSXに適用
	callback = function()
		vim.bo.tabstop = 2 -- タブ幅を2に設定
		vim.bo.shiftwidth = 2 -- 自動インデントの幅を2に設定
		vim.bo.softtabstop = 2 -- 挿入モードでタブを2に設定
		vim.bo.expandtab = true -- タブをスペースに変換
	end,
})

-- Markdownのindent
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown", -- Markdownに適用
	callback = function()
		vim.bo.tabstop = 2 -- タブ幅を2に設定
		vim.bo.shiftwidth = 2 -- 自動インデントの幅を2に設定
		vim.bo.softtabstop = 2 -- 挿入モードでタブを2に設定
		vim.bo.expandtab = true -- タブをスペースに変換
	end,
})
