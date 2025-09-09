return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
			})
			vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
			vim.cmd([[colorscheme catppuccin]])
		end,
		priority = 1000,
	},
}
