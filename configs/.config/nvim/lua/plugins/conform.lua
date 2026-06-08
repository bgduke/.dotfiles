vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

local format_on_save = true

conform.setup({
	format_on_save = format_on_save and { timeout_ms = 500, lsp_format = "fallback" } or nil,

	formatters = {
		prettier_json = {
			inherit = "prettier",
			append_args = { "--trailing-comma", "none" },
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettier_json" },
		jsonc = { "prettier_json" },
		toml = { "taplo" },
	},
})

vim.keymap.set("n", "<leader>F", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })
