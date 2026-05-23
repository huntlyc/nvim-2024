local function load_theme(flavour)
	pcall(function()
		require("catppuccin").setup({
			flavour = flavour,
			background = {
				light = "latte",
				dark = flavour,
			},
		})
		vim.g.catppuccin_flavour = flavour
		vim.cmd([[colorscheme catppuccin]])
	end)
end

local function read_theme()
	local state_file = vim.fn.stdpath("config") .. "/../catppuccin-theme/current"
	local f = io.open(state_file, "r")
	if f then
		local flavour = f:read("*all"):gsub("%s+", "")
		f:close()
		if flavour == "latte" or flavour == "mocha" then
			return flavour
		end
	end
	return "mocha"
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			load_theme(read_theme())
			vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
				callback = function()
					load_theme(read_theme())
				end,
			})
		end,
		priority = 1000,
	},
}
