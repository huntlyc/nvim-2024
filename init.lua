vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = 'yes:2'
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.listchars = 'tab:▸ ,trail:·'
vim.opt.mouse = 'a'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 3
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- death to trailing whitespace...
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current line" })
vim.keymap.set("v", "<leader>x", ":.lua<CR>", { desc = "Run selection" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true, desc = "Disable space cursor movement" })
vim.keymap.set('n', '<leader><leader>l', '<cmd>nohlsearch<CR>', { desc = "Clear search highlight" })
vim.keymap.set('', 'gf', '<cmd>edit <cfile><CR>', { desc = "Open file under cursor" })

vim.keymap.set('v', '<', '<gv', { desc = "Indent left and reselect" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right and reselect" })

vim.keymap.set('n', '<leader>gx', '<cmd>!xdg-open %<cr><cr>', { desc = "Open file in system app" })


vim.keymap.set("n", "<esc>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "win" then
            vim.api.nvim_win_close(win, false)
        end
    end
    vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = "Quit" })
vim.keymap.set('n', '<leader>cb', '<cmd>clo<CR>', { desc = "Close buffer" })
vim.keymap.set('n', '<leader>cab', '<cmd>%bd|e#<CR>', { desc = "Close all other buffers" })
vim.keymap.set('v', "<leader>y", "\"+y", { desc = "Copy to system clipboard" })
vim.keymap.set('n', "<leader>Y", "\"+Y", { desc = "Copy line to system clipboard" })
vim.keymap.set('n', "Y", "yg$", { desc = "Yank to end of line" })
vim.keymap.set('n', "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set('n', "N", "Nzzzv", { desc = "Prev search result (centered)" })
vim.keymap.set('n', "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
vim.keymap.set('n', "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set('n', "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

vim.keymap.set('n', "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set('n', "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set('n', "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set('n', "<C-l>", "<C-w>l", { desc = "Window right" })

vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = "Next buffer" })
vim.keymap.set('n', '<leader>[', '<cmd>bnext<CR>', { desc = "Next buffer" })

vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = "Previous buffer" })
vim.keymap.set('n', '<leader>]', '<cmd>bprevious<CR>', { desc = "Previous buffer" })

vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- vim.keymap.set('n', '<leader>=', '<cmd>Neoformat<CR>') -- format code







vim.keymap.set('i', '<C-.>', '<Plug>copilot-next', { noremap = false, desc = "Copilot next suggestion" })
vim.keymap.set('i', '<C-,>', '<Plug>copilot-previous', { noremap = false, desc = "Copilot previous suggestion" })




require("config.lazy")
