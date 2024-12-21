-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
  spec = {
      -- import your plugins
      --{ import = "plugins" },
      {
          'stevearc/oil.nvim',
          ---@module 'oil'
          ---@type oil.SetupOpts
          opts = {},
          -- Optional dependencies
          dependencies = { { "echasnovski/mini.icons", opts = {} } },
          -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
          config = function()
              require("oil").setup()
          end
      },
      {
          "catppuccin/nvim",
          name = "catppuccin",
          config = function()
              require("catppuccin").setup({
                  flavour = "mocha", -- latte, frappe, macchiato, mocha
                  background = { -- :h background
                      light = "latte",
                      dark = "mocha",
                  },
              })
              vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
              vim.cmd[[colorscheme catppuccin]]
          end,
          priority = 1000
      },
      { 
          'echasnovski/mini.nvim',
          version = '*',
          config = function()
              local statusline = require('mini.statusline')
              statusline.setup({
                  use_icons = true
              })
          end
      },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function ()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "css", "typescript", "javascript", "html", "php", "phpdoc", "sql", "scss" },
                    sync_install = false,
                    highlight = {
                        enable = true,
                        disable = function(lang, buf)
                            local max_filesize = 100 * 1024 -- 100 KB
                            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                            if ok and stats and stats.size > max_filesize then
                                return true
                            end
                        end,
                        additional_vim_regex_highlighting = false,
                    },
                    indent = { enable = true },
                })
            end
        },
        {
            "neovim/nvim-lspconfig",
            dependancies = {
{
                    "folke/lazydev.nvim",
                    ft = "lua", -- only load on lua files
                    opts = {
                        library = {
                            -- See the configuration section for more details
                            -- Load luvit types when the `vim.uv` word is found
                            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                        },
                    },
                },
            },
            config = function()

                require'lspconfig'.lua_ls.setup {
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                                return
                            end
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT'
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME
                                    -- Depending on the usage, you might want to add additional paths here.
                                    -- "${3rd}/luv/library"
                                    -- "${3rd}/busted/library",
                                }
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                                -- library = vim.api.nvim_get_runtime_file("", true)
                            }
                        })
                    end,
                    settings = {
                        Lua = {}
                    }
                }



            end
        }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
