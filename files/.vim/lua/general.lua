-- 自動読み込み・インデントなど
vim.opt.autoread = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.ignorecase = true
vim.opt.backspace = "start,eol,indent"

-- バックアップ・Undo・スワップ用ディレクトリ
vim.opt.backupdir = vim.fn.expand("$HOME/.vimbackup")
vim.opt.directory = vim.fn.expand("$HOME/.vimbackup")
vim.opt.undodir = vim.fn.expand("~/.vimundo")
vim.opt.undofile = true

-- ファイルダイアログ、ウィルド補完
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"

-- その他の表示オプション
vim.opt.ruler = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.matchtime = 2 -- ブレリンク時間 (単位: 1/10秒)
vim.opt.listchars = { eol = "$", tab = "> ", extends = "<" }
-- vim.opt.list   = true  -- 不可視文字を表示する場合はコメントアウトを解除

-- タブ・インデント関連
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- 行末などでカーソル移動可能に
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"

-- Vi互換モードをオフ
vim.opt.compatible = false

-- :W で sudo して保存 (permission-denied 対策)
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

-- Ctrl+/ を2回押してコメントアウト・解除
vim.keymap.set("n", "<C-/><C-/>", ":TComment<CR>", opts)

-- 自動インデント時にタブが2つ付くのを防ぐ
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- インサートモードで jj を押下すると ESC 相当 + l 相当
vim.api.nvim_set_keymap("i", "jj", "<ESC>l", { silent = true })

-- インサートモードで Control + j を押下すると ESC
vim.api.nvim_set_keymap("i", "<C-j>", "<ESC>", { silent = true })

-- 勝手に改行させない
-- vim.o.formatoptions = vim.o.formatoptions:gsub("q", "")
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

-- Leaderキーの設定
vim.g.mapleader = "."

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

-- swapfileを作成しないように設定
vim.opt.swapfile = false

-- indent
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact" }, -- TypeScriptとTSXに適用
	callback = function()
		vim.bo.tabstop = 2 -- タブ幅を2に設定
		vim.bo.shiftwidth = 2 -- 自動インデントの幅を2に設定
		vim.bo.softtabstop = 2 -- 挿入モードでタブを2に設定
		vim.bo.expandtab = true -- タブをスペースに変換
	end,
})
