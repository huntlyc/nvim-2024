return {
  {
    'nvim-telescope/telescope.nvim',
     version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          help_tags = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {}
        }
      }
        -- stop copilot on telescope
        vim.g.copilot_filetypes = { TelescopePrompt = false }

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
        vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files<cr>", { desc = "Find all files" })
        vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>f*", "<cmd>Telescope grep_string<cr>", { desc = "Grep string" })
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
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
    end
  }
}
