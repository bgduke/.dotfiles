vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local treesitter = require("nvim-treesitter")
local languages = {
	"bash",
	"c",
	"css",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"toml",
	"typescript",
	"vim",
	"vimdoc",
}

if vim.fn.executable("tree-sitter") == 1 then
	treesitter.install(languages)
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
	pattern = {
		"bash",
		"c",
		"css",
		"help",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"lua",
		"markdown",
		"sh",
		"toml",
		"typescript",
		"typescriptreact",
		"vim",
	},
	callback = function()
		pcall(vim.treesitter.start)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("treesitter-context").setup({
	enable = true,
	max_lines = 4,
	multiline_threshold = 1,
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
})

vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>", { desc = "Toggle sticky code context" })
