vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.map.on_attach.default(bufnr)

	local lefty = function()
		local node_at_cursor = api.tree.get_node_under_cursor()
		if (node_at_cursor.name == ".." or node_at_cursor.nodes) and node_at_cursor.open then
			api.node.open.edit()
		else
			api.node.navigate.parent()
		end
	end

	local righty = function()
		local node_at_cursor = api.tree.get_node_under_cursor()
		if (node_at_cursor.name == ".." or node_at_cursor.nodes) and not node_at_cursor.open then
			api.node.open.edit()
		elseif node_at_cursor.open then
			api.node.open.edit()
		else
			api.node.open.edit()
		end
	end

	vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "h", lefty, opts("C-tollapse"))
	vim.keymap.set("n", "l", righty, opts("Expand"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "A", function()
		local node = api.tree.get_node_under_cursor()
		local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
		require("easy-dotnet").create_new_item(path)
	end, opts("Create file from dotnet template"))
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	renderer = {
		group_empty = true,
		icons = {
			diagnostics_placement = "after",
			glyphs = {
				git = {
					unstaged = " ●",
					staged = " ✓",
					untracked = " ＋",
					deleted = " −",
					renamed = " →",
					unmerged = " ",
					ignored = " ◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		icons = {
			error = "",
			warning = "",
			info = "",
			hint = "󰌵",
		},
	},
	filters = {
		dotfiles = true,
		git_ignored = true,
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
