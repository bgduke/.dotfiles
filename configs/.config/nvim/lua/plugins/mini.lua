vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
})

-- ============================================================================
-- Mini.nvim — startup modules
-- ============================================================================

require("mini.icons").setup()
vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = vim.g.terminal_color_12 })
vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = vim.g.terminal_color_4 })
vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = vim.g.terminal_color_6 })
vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = vim.g.terminal_color_2 })
vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = vim.g.terminal_color_8 })
vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = vim.g.terminal_color_3 })
vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = vim.g.terminal_color_5 })
vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = vim.g.terminal_color_1 })
vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = vim.g.terminal_color_11 })

require("mini.diff").setup({
	view = {
		style = vim.go.number and "sign" or "number",
		signs = {
			add = "+",
			change = "~",
			delete = "-",
			topdelete = "",
			changedelete = "▎",
			untracked = "+",
		},
		priority = 199,
	},
})

local win_config = function()
	local height = math.floor(0.618 * vim.o.lines)
	local width = math.floor(0.618 * vim.o.columns)
	return {
		anchor = "NW",
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(0.5 * (vim.o.columns - width)),
	}
end

require("mini.pick").setup({
	mappings = {
		move_down = "<C-j>",
		move_up = "<C-k>",
	},
	window = { config = win_config },
})

require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.extra").setup()

require("mini.files").setup({
	mappings = {
		go_in_plus = "<CR>",
	},
})

-- ============================================================================
-- Deferred — loads right after startup via vim.schedule()
-- ============================================================================
vim.schedule(function()
	require("mini.surround").setup({
		mappings = {
			replace = "cs", -- Replace surrounding
		},
	})

	require("mini.comment").setup()
	require("mini.bracketed").setup()
	require("mini.git").setup()
	-- require("mini.notify").setup()
end)

-- ============================================================================
-- Lazy — loads on InsertEnter
-- ============================================================================
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("mini.completion").setup({
			mappings = {
				scroll_down = "",
				scroll_up = "",
			},
		})
		vim.bo.completefunc = "v:lua.MiniCompletion.completefunc_lsp"
		require("mini.pairs").setup()

		local gen_loader = require("mini.snippets").gen_loader
		local csharp_patterns = { "csharp/**/*.json", "csharp/**/*.lua", "**/csharp.json", "**/csharp.lua" }
		require("mini.snippets").setup({
			snippets = {
				gen_loader.from_lang({
					lang_patterns = {
						cs = csharp_patterns,
						csharp = csharp_patterns,
					},
				}),
			},
			mappings = {
				expand = "",
			},
		})
		MiniSnippets.start_lsp_server({ match = false })
	end,
})
