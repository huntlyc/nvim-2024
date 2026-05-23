return {
    "rouge8/neotest-rust",
    dependencies = {
        "nvim-neotest/neotest",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local ok, rust = pcall(require, "neotest-rust")
        if ok then
            local config = require("neotest.config")
            table.insert(config.adapters, rust)
        end
    end,
}
