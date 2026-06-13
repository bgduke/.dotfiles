vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
	enabled = true,
	preset = "obsidian",
	file_types = { "markdown" },
	render_modes = { "n", "c", "t" },
	anti_conceal = {
		enabled = true,
		above = 1,
		below = 1,
	},
	code = {
		width = "block",
		min_width = 45,
		border = "thin",
	},
	heading = {
		width = "block",
		border = false,
	},
	pipe_table = {
		style = "normal",
	},
	completions = {
		lsp = {
			enabled = false,
		},
	},
})

vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown render toggle" })
vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown preview<cr>", { desc = "Markdown preview split" })
