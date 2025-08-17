return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim", "nvim-lspconfig" },
        opts = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            
            -- Server configurations
            local servers = {
                gopls = {
                    filetypes = { "go", "gomod" },
                },
                intelephense = {
                    init_options = {
                        licenceKey = os.getenv("INTELEPHENSELICENCE"),
                    },
                    filetypes = { "php", "phtml" },
                    settings = {
                        intelephense = {
                            format = {
                                braces = "k&r",
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
                                    "~/.composer/vendor/php-stubs",
                                    "~/code/wordpress",
                                },
                            },
                            files = {
                                maxSize = 5000000,
                            },
                        },
                    },
                },
                lua_ls = {
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                                return
                            end
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                            runtime = {
                                version = "LuaJIT",
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                },
                            },
                        })
                    end,
                    settings = {
                        Lua = {},
                    },
                },
                -- Web development servers
                ts_ls = {},
                html = {},
                cssls = {},
                somesass_ls = {},
                tailwindcss = {},
                eslint = {},
                jsonls = {},
            }

            return {
                ensure_installed = {
                    "gopls",           -- Go
                    "intelephense",    -- PHP
                    "lua_ls",          -- Lua
                    "ts_ls",           -- TypeScript/JavaScript
                    "html",            -- HTML
                    "cssls",           -- CSS
                    "somesass_ls",     -- Sass/SCSS
                    "tailwindcss",     -- Tailwind CSS
                    "eslint",          -- ESLint
                    "jsonls",          -- JSON
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server_config = servers[server_name] or {}
                        server_config.capabilities = capabilities
                        require("lspconfig")[server_name].setup(server_config)
                    end,
                }
            }
        end
    }
}