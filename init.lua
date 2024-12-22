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

vim.keymap.set("n","<leader><leader>x", "<cmd>source %<CR>") -- source the current file, used for editing this file
vim.keymap.set("n","<leader>x", ":.lua<CR>") -- run current line
vim.keymap.set("v","<leader>x", ":.lua<CR>") -- run selection

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- stop space from moving the cursor in normal/visual mode
vim.keymap.set('n', '<leader><leader>l', '<cmd>nohlsearch<CR>')
vim.keymap.set('', 'gf', '<cmd>edit <cfile><CR>') -- go to non-existant file

-- reselect visual selection after indent change
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>gx', '<cmd>!xdg-open %<cr><cr>') -- open links in firefox or whatever


vim.keymap.set("n", "<esc>", function()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

-- quick wins
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>') -- save
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>') -- quit
vim.keymap.set('n', '<leader>cb', '<cmd>clo<CR>') -- close buffer
vim.keymap.set('n', '<leader>cab', '<cmd>%bd|e#<CR>') -- close all other buffers except current
vim.keymap.set('v', "<leader>y", "\"+y") -- copy to system clipboard
vim.keymap.set('n', "<leader>Y", "\"+Y") -- copy to system clipboard
vim.keymap.set('n', "Y", "yg$") -- copy to end of line
vim.keymap.set('n', "n", "nzzzv") -- center screen on search next
vim.keymap.set('n', "N", "Nzzzv") -- center screen on search prev
vim.keymap.set('n', "J", "mzJ`z") -- join lines without moving cursor
vim.keymap.set('n', "<C-d>", "<C-d>zz") -- scroll down but keep cursor in same place
vim.keymap.set('n', "<C-u>", "<C-u>zz") -- scroll up but keep cursor in same place

-- window navigation
vim.keymap.set('n', "<C-h>", "<C-w>h") -- move to left window
vim.keymap.set('n', "<C-j>", "<C-w>j") -- move to bottom window
vim.keymap.set('n', "<C-k>", "<C-w>k") -- move to top window
vim.keymap.set('n', "<C-l>", "<C-w>l") -- move to right window

-- buffer navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>') -- next buffer
vim.keymap.set('n', '<leader>[', '<cmd>bnext<CR>') -- next buffer

vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>') -- previous buffer
vim.keymap.set('n', '<leader>]', '<cmd>bprevious<CR>') -- previous buffer

vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv") -- move line down in visual mode
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv") -- move line up in visual mode

-- vim.keymap.set('n', '<leader>=', '<cmd>Neoformat<CR>') -- format code







-- copilot
vim.keymap.set('i', '<C-.>', '<Plug>copilot-next', {noremap = false})
vim.keymap.set('i', '<C-,>', '<Plug>copilot-previous', {noremap = false})




require("config.lazy")
