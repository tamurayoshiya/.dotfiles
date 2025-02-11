local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	'neovim/nvim-lspconfig',

    -- theme
    {
        'cocopon/iceberg.vim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd[[colorscheme iceberg]]
        end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function ()
          require("lualine").setup({
            options = { theme = 'nord' },
            sections = {
              lualine_b = { 'branch', 'diff', 'diagnostics' },
              lualine_c = {
                {
                  'filename',
                  file_status = true, -- displays file status (readonly status, modified status)
                  path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
                }
              },
              lualine_x = {'encoding', 'filetype'},
            }
          })
        end,
    },

    -- file explorer
    {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    config = function()
       vim.g.nvim_tree_show_icons = {
           git = 0,
           folders = 0,
           files = 0,
           folder_arrows = 0,
       }
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        renderer = {
            icons = {
                show = {
                    git = false,
                    file = false,
                    folder = false,
                    folder_arrow = false,
                }
            }
        },
        view = {
            side = "right"
        },
        filters = {
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', 'C', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', '<Tab>', api.tree.toggle, opts('Toggle'))
        end
      })
      vim.keymap.set('n', '<Tab>', function()
          require('nvim-tree.api').tree.toggle()
      end, { noremap = true, silent = true, desc = "Toggle nvim-tree" })
    end,
  },
})
