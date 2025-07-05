-- lua/config/lsp.lua (for example)

local lsp_format_on_save = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(c)
            return c.id == client.id
          end,
        })
      end,
    })
  end
end

local lsp_keymaps = function(bufnr)
  local keymap = vim.keymap.set
  local opts = { buffer = bufnr, silent = true, noremap = true }

  keymap("n", "K", vim.lsp.buf.hover, opts)
  keymap("n", "<leader>gg", vim.diagnostic.open_float, opts)
  keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)
  keymap("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
  keymap("n", "<leader>gi", vim.lsp.buf.implementation, opts)
  keymap("n", "<leader>gr", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>gb", vim.diagnostic.goto_next, opts)
  keymap("n", "<leader>gp", vim.diagnostic.goto_prev, opts)
  keymap("n", "<leader>gtr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap("n", "<leader>gl", "<cmd>Telescope diagnostics<CR>", opts)
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    lsp_keymaps(bufnr)
    lsp_format_on_save(client, bufnr)
  end,
})


return {
    {
        "neovim/nvim-lspconfig",
        dependancies = {
            'saghen/blink.cmp',
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require 'lspconfig'.intelephense.setup {
                capabilities = capabilities,
                init_options = {
                    licenceKey = os.getenv('INTELEPHENSELICENCE'),
                },
                filetypes = { "php", "phtml" },
                settings = {
                    intelephense = {
                        format = {
                            braces = "k&r"
                        },
                        maxMemory = 4096,
                        stubs = {
                            "bcmath",
                            "bz2",
                            "calendar",
                            "Core",
                            "curl",
                            "date",
                            "dba",
                            "dom",
                            "enchant",
                            "fileinfo",
                            "filter",
                            "ftp",
                            "gd",
                            "gettext",
                            "hash",
                            "iconv",
                            "imap",
                            "intl",
                            "json",
                            "ldap",
                            "libxml",
                            "mbstring",
                            "mcrypt",
                            "mysql",
                            "mysqli",
                            "password",
                            "pcntl",
                            "pcre",
                            "PDO",
                            "pdo_mysql",
                            "Phar",
                            "readline",
                            "recode",
                            "Reflection",
                            "regex",
                            "session",
                            "SimpleXML",
                            "soap",
                            "sockets",
                            "sodium",
                            "SPL",
                            "standard",
                            "superglobals",
                            "sysvsem",
                            "sysvshm",
                            "tokenizer",
                            "xml",
                            "xdebug",
                            "xmlreader",
                            "xmlwriter",
                            "yaml",
                            "zip",
                            "zlib",
                            "wordpress",
                            "woocommerce",
                            "acf-pro",
                            "wordpress-globals",
                        },
                        environment = {
                            includePaths = {
                                '~/.composer/vendor/php-stubs',
                                '~/code/wordpress'
                            }
                        },
                        files = {
                            maxSize = 5000000,
                        },
                    }
                }
            }

            require 'lspconfig'.lua_ls.setup({
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            })
        end
    }
}


