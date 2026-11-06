return {
  {
    'nvim-telescope/telescope.nvim',
     version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = function()
      require('telescope').setup {
          defaults = {
            preview = { treesitter = false } -- Disables treesitter in previeq
          },
        pickers = {
          help_tags = {
            theme = "ivy"
          },
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>f*", "<cmd>Telescope grep_string<cr>", { desc = "Grep string" })
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
        vim.keymap.set("n", "<leader>fi", "<cmd>Telescope symbols<cr>", { desc = "Insert symbol" })
        vim.keymap.set("n", "<leader>f.", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy find in buffer" })

      vim.keymap.set("n", "<leader><leader>c", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end, { desc = "Neovim config files" })
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end, { desc = "Plugin files" })

      require "config.telescope.multigrep".setup()
      require "config.telescope.find_files".setup()
    end
  }
}
