vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install lazy.nvim ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ -- Fuzzy Finder
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		config = function()
			require("telescope").setup({})
			pcall(require("telescope").load_extension, "fzf")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fm", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
			vim.keymap.set("n", "go", builtin.diagnostics, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Fuzzy search in buffer" })
		end,
	},

	{ -- LSP
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
					map("gr", require("telescope.builtin").lsp_references, "Goto References")
					map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
					map("gn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				ts_ls = {},
				jsonls = {},
				typos_lsp = {},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				json = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
				},
			})
		end,
	},

	{ -- Treesitter
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"diff",
				"html",
				"typescript",
				"tsx",
				"rust",
				"lua",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},

	-- Theme
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({ transparent = true })
			vim.cmd([[colorscheme cyberdream]])
		end,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
			vim.api.nvim_create_user_command("Git", function(cmd)
				if cmd.args == "blame" then
					require("gitsigns").blame()
				end
			end, { nargs = 1 })
		end,
	},

	-- Copilot
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			vim.api.nvim_set_keymap(
				"i",
				"<C-K>",
				'copilot#Accept("<CR>")',
				{ silent = true, expr = true, script = true }
			)
			vim.api.nvim_set_keymap("i", "<C-a><C-s>", "<Plug>(copilot-suggest)", {})
			vim.api.nvim_set_keymap("i", "<C-a><C-p>", "<Plug>(copilot-previous)", {})
			vim.api.nvim_set_keymap("i", "<C-l>", "<Plug>(copilot-next)", {})
			vim.api.nvim_set_keymap("i", "<C-a><C-j>", "<Plug>(copilot-dismiss)", {})
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_filetypes = { markdown = true }
			vim.api.nvim_create_autocmd("VimEnter", {
				pattern = "*",
				command = "Copilot enable",
			})
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		config = function()
			vim.keymap.set(
				"n",
				"<Tab>",
				require("nvim-tree.api").tree.toggle,
				{ noremap = true, silent = true, desc = "Toggle nvim-tree" }
			)
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				renderer = {
					icons = {
						show = {
							git = true,
							file = false,
							folder = true,
							folder_arrow = true,
						},
						glyphs = {
							folder = {
								arrow_closed = "📁",
								arrow_open = "📂",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "⨯",
								staged = "✓",
								unmerged = "✗",
								renamed = "➜",
								untracked = "+",
								deleted = "-",
								ignored = "◌",
							},
						},
					},
				},
				view = { side = "right" },
				filters = {
					dotfiles = false,
					git_ignored = false,
				},
				actions = {
					open_file = {
						quit_on_open = true,
						resize_window = false,
						window_picker = { enable = false },
					},
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
					vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
					vim.keymap.set("n", "<Tab>", api.tree.toggle, opts("Toggle"))
				end,
			})
		end,
	},
})

-- Hover with double space
vim.api.nvim_set_keymap(
	"n",
	"<Space><Space>",
	"<cmd>lua vim.lsp.buf.hover()<CR>",
	{ noremap = true, silent = true }
)
