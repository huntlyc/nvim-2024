return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local setup_servers = {} -- Track which servers we've already set up

            -- Server configurations
            local servers = {
                gopls = {
                    filetypes = { "go", "gomod" },
                },
                intelephense = {
                    filetypes = { "php", "phtml" },
                    settings = {
                        intelephense = {
                            format = {
                                braces = "k&r",
                            },
                            maxMemory = 4096,
                            stubs = {
                                "Core",
                                "standard",
                                "wordpress",
                                "woocommerce",
                                "acf-pro",
                                "wordpress-globals",
                            },
                            environment = {
                                includePaths = {
                                    "/home/huntlyc/code/docker-wp/wp/themes/AtomIc/vendor/php-stubs",
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
                            if
                                vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
                            then
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
                ts_ls = {
                    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
                    init_options = {
                        preferences = {
                            disableSuggestions = false,
                        },
                    },
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },
                html = {},
                cssls = {},
                somesass_ls = {},
                tailwindcss = {},
                eslint = {},
                jsonls = {},
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            check = { command = "clippy" },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                chainingHints = { enable = true },
                                closingBraceHints = { enable = true, minLines = 25 },
                                lifetimeElisionHints = { enable = "always" },
                                parameterHints = { enable = true },
                                typeHints = { enable = true },
                            },
                        },
                    },
                },
            }

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls", -- Go
                    "intelephense", -- PHP
                    "lua_ls", -- Lua
                    "ts_ls", -- TypeScript/JavaScript
                    "html", -- HTML
                    "cssls", -- CSS
                    "somesass_ls", -- Sass/SCSS
                    "tailwindcss", -- Tailwind CSS
                    "eslint", -- ESLint
                    "jsonls", -- JSON
                    "rust_analyzer", -- Rust
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        if not setup_servers[server_name] then
                            setup_servers[server_name] = true
                            local server_config = servers[server_name] or {}
                            server_config.capabilities = capabilities
                            vim.lsp.config(server_name, server_config)
                        end
                    end,
                },
            })

            -- Setup ts_ls with better root detection (merge with existing config)
            local util = require("lspconfig.util")
            local ts_ls_config = servers["ts_ls"] or {}
            ts_ls_config.root_dir = util.root_pattern("package.json", "tsconfig.json", ".git")
            ts_ls_config.single_file_support = true
            vim.lsp.config("ts_ls", ts_ls_config)
        end,
    },
}
