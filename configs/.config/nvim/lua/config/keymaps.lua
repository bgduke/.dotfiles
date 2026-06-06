local function opts(desc)
	return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end
local map = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<C-h>", "<C-w>h", opts("Move pane left"))
map("n", "<C-j>", "<C-w>j", opts("Move pane down"))
map("n", "<C-k>", "<C-w>k", opts("Move pane up"))
map("n", "<C-l>", "<C-w>l", opts("Move pane right"))

map("n", "<leader>h", ":nohlsearch<CR>", opts("Clear Highlighting"))
map("n", "<leader>w", ":w<CR>", opts("Save Buffer"))

-- Buffers
map("n", "<S-h>", ":bprevious<CR>", opts("Prev buffer"))
map("n", "<S-l>", ":bnext<CR>", opts("Next buffer"))
map("n", "<leader>o", "<cmd>Pick buffers<CR>", opts("Pick buffer"))
map("n", "<leader>q", ":bd<CR>", opts("Close buffer"))

-- Mini.Files
map("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", opts("Opens Mini File Picker"))

-- Mini.Git
map("n", "<leader>gg", "<cmd>lua MiniDiff.toggle_overlay()<CR>", opts("Opens Mini Git"))

-- Mini.Pick
map("n", "<leader>ff", "<cmd>Pick files<CR>", opts("Pick Files"))
map("n", "<leader>/", "<cmd>Pick grep_live<CR>", opts("Grep Live"))
map("n", "<leader>hh", "<cmd>Pick help<CR>", opts("Pick Help"))

-- Mini.Completion
local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

map_multistep({ "i", "s" }, "<Tab>", { "vimsnippet_next", "pmenu_next" })
map_multistep({ "i", "s" }, "<S-Tab>", { "vimsnippet_prev", "pmenu_prev" })

local tab_steps = {
	"minisnippets_next",
	"minisnippets_expand",
	"pmenu_next",
	"jump_after_tsnode",
	"jump_after_close",
}
map_multistep("i", "<Tab>", tab_steps)

local shifttab_steps = {
	"minisnippets_prev",
	"pmenu_prev",
	"jump_before_tsnode",
	"jump_before_open",
}
map_multistep("i", "<S-Tab>", shifttab_steps)
