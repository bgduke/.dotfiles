local function opts(desc)
	return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end
local map = vim.api.nvim_set_keymap

map("n", "<C-h>", "<C-w>h", opts("Move pane left"))
map("n", "<C-j>", "<C-w>j", opts("Move pane down"))
map("n", "<C-k>", "<C-w>k", opts("Move pane up"))
map("n", "<C-l>", "<C-w>l", opts("Move pane right"))

map("n", "<leader>h", ":nohlsearch<CR>", opts("Clear Highlighting"))
map("n", "<leader>w", ":w<CR>", opts("Save Buffer"))

-- Folds
map("n", "<leader>zc", "zc", opts("Close fold"))
map("n", "<leader>zo", "zo", opts("Open fold"))
map("n", "<leader>zC", "zM", opts("Close all folds"))
map("n", "<leader>zO", "zR", opts("Open all folds"))

-- Buffers
map("n", "<S-h>", ":bprevious<CR>", opts("Prev buffer"))
map("n", "<S-l>", ":bnext<CR>", opts("Next buffer"))
map("n", "<leader>o", "<cmd>Pick buffers<CR>", opts("Pick buffer"))
map("n", "<leader>q", ":bd<CR>", opts("Close buffer"))
map("n", "<leader>sv", ":vsplit<CR>", opts("Vertical Split"))
map("n", "<leader>sh", ":split<CR>", opts("Horizontal Split"))

-- Mini.Files
map("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", opts("Opens Mini File Picker"))

-- Mini.Git
map("n", "<leader>gg", "<cmd>lua MiniDiff.toggle_overlay()<CR>", opts("Opens Mini Git"))

-- Mini.Pick
map("n", "<leader>ff", "<cmd>Pick files<CR>", opts("Pick Files"))
map("n", "<leader>/", "<cmd>Pick grep_live<CR>", opts("Grep Live"))
vim.api.nvim_create_user_command("ProjectReplace", function()
	require("config.project_replace").run()
end, {})
map("n", "<leader>sr", "<cmd>ProjectReplace<CR>", opts("Project Replace"))
map("n", "<leader>hh", "<cmd>Pick help<CR>", opts("Pick Help"))

-- Mini.Completion
local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

local tab_steps = { "minisnippets_next", "pmenu_next" }
map_multistep("i", "<Tab>", tab_steps)

local shifttab_steps = { "minisnippets_prev", "pmenu_prev" }
map_multistep("i", "<S-Tab>", shifttab_steps)
