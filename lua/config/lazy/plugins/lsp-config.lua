vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)


        -- format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
            end,
        })
        -- LSP && Telescope mappings
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gb", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gtr", "<cmd>Telescope lsp_references<cr>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gl", "<cmd>Telescope diagnostics<cr>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end
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
