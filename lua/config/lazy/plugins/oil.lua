return {
      {
          'stevearc/oil.nvim',
          ---@module 'oil'
          opts = {},
          -- Optional dependencies
          dependencies = { { "echasnovski/mini.icons", opts = {} } },
          -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
          config = function()
              require("oil").setup()
                -- oil, open current file parent directory
                vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
          end
      },
}
