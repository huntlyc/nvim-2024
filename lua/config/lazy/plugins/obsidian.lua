return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>of", "<cmd>Obsidian quick_switch<CR>", desc = "Find vault note" },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search vault content" },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New vault note" },
      { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Note backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Note links" },
      { "<leader>ot", "<cmd>Obsidian tags<CR>", desc = "Vault tags" },
    },
    init = function()
      -- Keep existing normal-mode keys, including Ctrl-a / Ctrl-x.
      vim.g.obsidian_default_keymap = false
    end,
    opts = function()
      return {
        legacy_commands = false,
        workspaces = { { name = "pkm", path = "~/pkm" } },
        picker = { name = "telescope.nvim" },
        new_notes_location = "notes_subdir",
        note_id_func = require("obsidian.builtin").title_id,
        link = { style = "markdown" },
        -- Do not inject or rewrite YAML metadata when saving existing notes.
        frontmatter = { enabled = false },
        -- Conceal is set per vault buffer below, after the UI initializes.
        ui = { ignore_conceal_warn = true },
        callbacks = {
          enter_note = function()
            vim.opt_local.conceallevel = 2
            -- Override the global file-only gf mapping only inside vault notes.
            vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<CR>", {
              buffer = true,
              desc = "Follow note link",
            })
          end,
        },
      }
    end,
  },
}
