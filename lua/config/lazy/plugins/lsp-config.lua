return {
        {
            "neovim/nvim-lspconfig",
            dependancies = {
{
                    "folke/lazydev.nvim",
                    ft = "lua", -- only load on lua files
                    opts = {
                        library = {
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
                }
            end
        }
}