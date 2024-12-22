return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
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

      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
        -- Telescope FTFW
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope git_files<cr>") -- files tracked in git (good for ignoring node_modules)
        vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files<cr>") -- finds everythign regardless of git status
        vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>") -- search for diagnostics in current buffer
        vim.keymap.set("n", "<leader>f*", "<cmd>Telescope grep_string<cr>") -- search for string in project
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- search for string in project
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- search for buffer
        vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>") -- search for marks
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>") -- search for registers
        vim.keymap.set("n", "<leader>f.", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- search in current buffer

      vim.keymap.set("n", "<leader><leader>c", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

      require "config.telescope.multigrep".setup()
    end
  }
}
