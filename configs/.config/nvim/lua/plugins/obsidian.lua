vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/epwalsh/obsidian.nvim",
})

local obsidian = require("obsidian")

obsidian.setup({
	workspaces = {
		{
			name = "notes",
			path = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname ~= "" then
					local root = vim.fs.root(bufname, { ".obsidian", ".git" })
					if root ~= nil then
						return root
					end

					local parent = vim.fs.dirname(bufname)
					if parent ~= nil then
						return parent
					end
				end

				return assert(vim.fn.getcwd())
			end,
			overrides = {
				notes_subdir = vim.NIL,
				new_notes_location = "current_dir",
				templates = {
					folder = vim.NIL,
				},
				disable_frontmatter = true,
			},
		},
	},
	preferred_link_style = "markdown",
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	mappings = {
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},
	picker = {
		name = "mini.pick",
	},
	ui = {
		enable = false,
	},
})

local cmp = require("cmp")

cmp.setup.filetype("markdown", {
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "obsidian" },
		{ name = "obsidian_new" },
		{ name = "obsidian_tags" },
	}),
})

vim.keymap.set("n", "<leader>mb", "<cmd>ObsidianBacklinks<cr>", { desc = "Markdown backlinks" })
vim.keymap.set("n", "<leader>ml", "<cmd>ObsidianLinks<cr>", { desc = "Markdown links" })
vim.keymap.set("n", "<leader>mq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Markdown quick switch" })
vim.keymap.set("n", "<leader>ms", "<cmd>ObsidianSearch<cr>", { desc = "Markdown search" })
vim.keymap.set("n", "<leader>mt", "<cmd>ObsidianTags<cr>", { desc = "Markdown tags" })
vim.keymap.set("n", "<leader>mn", "<cmd>ObsidianNew<cr>", { desc = "Markdown new note" })
