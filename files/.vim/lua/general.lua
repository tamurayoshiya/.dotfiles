vim.opt.autoread = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.backspace = "start,eol,indent"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"
vim.opt.ruler = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.listchars = { eol = "$", tab = "> ", extends = "<" }
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.swapfile = false
vim.opt.synmaxcol = 1000

vim.opt.backupdir = vim.fn.expand("$HOME/.vimbackup")
vim.opt.directory = vim.fn.expand("$HOME/.vimbackup")
vim.opt.undodir = vim.fn.expand("$HOME/.vimundo")
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard:append("unnamed")
vim.opt.formatoptions:append("or")
vim.opt.showtabline = 2

-- :W to save with sudo
vim.api.nvim_create_user_command("W", "w !sudo tee % > /dev/null", {})

-----------------------------------
-- Keymaps

local opts = { noremap = true, silent = true }

-- Delete/paste without yanking
vim.keymap.set("n", "x", '"0x', opts)
vim.keymap.set("v", "x", '"0x', opts)
vim.keymap.set("n", "d", '"0d', opts)
vim.keymap.set("v", "d", '"0d', opts)
vim.keymap.set("n", "p", '"0p', opts)
vim.keymap.set("v", "p", '"0p', opts)
vim.keymap.set("n", "P", '"0P', opts)
vim.keymap.set("v", "P", '"0P', opts)

-- Split navigation
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-W>h", opts)
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-W>j", opts)
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-W>k", opts)
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-W>l", opts)

-- Double ESC to clear search highlight
vim.keymap.set("n", "<ESC><ESC>", ":nohlsearch<CR><ESC>", opts)

-- jj to escape
vim.api.nvim_set_keymap("i", "jj", "<ESC>l", { silent = true })
vim.api.nvim_set_keymap("i", "<C-j>", "<ESC>", { silent = true })

-- paste mode
vim.api.nvim_set_keymap("n", ",i", ":<C-u>set paste<CR>i", { noremap = true })
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = "*",
	command = "set nopaste",
})

-- Preserve indent on empty lines
vim.api.nvim_set_keymap("i", "<CR>", "<CR>x<BS>", { noremap = true })
vim.api.nvim_set_keymap("n", "o", "ox<BS>", { noremap = true })
vim.api.nvim_set_keymap("n", "O", "Ox<BS>", { noremap = true })

-- Tab navigation
vim.api.nvim_set_keymap("n", "[Tag]", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "t", "[Tag]", {})
for n = 1, 9 do
	vim.api.nvim_set_keymap("n", "[Tag]" .. n, ":<C-u>tabnext " .. n .. "<CR>", { noremap = true, silent = true })
end
vim.api.nvim_set_keymap("n", "[Tag]c", ":tablast | tabnew<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[Tag]x", ":tabclose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[Tag]n", ":tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[Tag]p", ":tabprevious<CR>", { noremap = true, silent = true })

-- Filetype-specific indent
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "vue", "css", "scss", "yaml", "markdown", "json", "jsonc" },
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

-- Auto-reload files changed externally
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})

-- LSP diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
