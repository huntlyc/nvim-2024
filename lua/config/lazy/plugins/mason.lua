return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "intelephense",
                "gopls",
                "ts_ls",
                "lua_ls",
                "cssls",
                "emmet_ls",
            },
            automatic_enable = true,
        },
    },
}
