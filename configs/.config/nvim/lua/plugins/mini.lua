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
	local height = math.floor(0.418 * vim.o.lines)
	local width = math.floor(0.418 * vim.o.columns)
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

local statusline = require("mini.statusline")

local set_statusline_hl = function()
	local colors = {
		bg = vim.g.terminal_color_0 or "#282828",
		fg = vim.g.terminal_color_7 or "#ebdbb2",
		muted = vim.g.terminal_color_8 or "#928374",
		red = vim.g.terminal_color_1 or "#cc241d",
		green = vim.g.terminal_color_2 or "#98971a",
		yellow = vim.g.terminal_color_3 or "#d79921",
		blue = vim.g.terminal_color_4 or "#458588",
		purple = vim.g.terminal_color_5 or "#b16286",
		cyan = vim.g.terminal_color_6 or "#689d6a",
	}

	vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = colors.bg, bg = colors.fg, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = colors.bg, bg = colors.blue, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = colors.bg, bg = colors.green, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = colors.bg, bg = colors.red, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = colors.bg, bg = colors.yellow, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = colors.bg, bg = colors.purple, bold = true })

	vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = colors.fg, bg = colors.bg, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.muted, bg = colors.bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = colors.muted, bg = colors.bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = colors.muted, bg = colors.bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineGit", { fg = colors.green, bg = colors.bg, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineDiff", { fg = colors.yellow, bg = colors.bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineDiagnostics", { fg = colors.red, bg = colors.bg, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineLsp", { fg = colors.cyan, bg = colors.bg })
end

local section_lsp_names = function(trunc_width)
	if statusline.is_truncated(trunc_width) then
		return ""
	end

	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	if vim.tbl_isempty(clients) then
		return ""
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	table.sort(names)
	return "LSP " .. table.concat(names, ",")
end

local section_git_branch = function(trunc_width)
	if statusline.is_truncated(trunc_width) then
		return ""
	end

	local summary = vim.b.minigit_summary
	if summary == nil then
		return ""
	end

	local head = summary.head_name or ""
	if head == "HEAD" and summary.head ~= nil then
		head = summary.head:sub(1, 7)
	end
	if head == "" then
		return ""
	end

	if summary.in_progress ~= nil and summary.in_progress ~= "" then
		head = head .. "|" .. summary.in_progress
	end

	return "git " .. head
end

local section_location = function(trunc_width)
	if statusline.is_truncated(trunc_width) then
		return "%l:%v"
	end

	return "Ln %l/%L  Col %v"
end

local section_filename = function(trunc_width)
	if vim.bo.buftype == "terminal" then
		return "%t"
	end

	local filename = statusline.is_truncated(trunc_width) and "%f" or "%F"
	local flags = {}

	if vim.bo.modified then
		table.insert(flags, "[+]")
	end
	if vim.bo.readonly then
		table.insert(flags, "[RO]")
	end
	if not vim.bo.modifiable then
		table.insert(flags, "[-]")
	end

	return filename .. (#flags > 0 and " " .. table.concat(flags, " ") or "")
end

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git = section_git_branch(55)
			local diff = statusline.section_diff({ trunc_width = 90, icon = "diff" })
			local diagnostics = statusline.section_diagnostics({
				trunc_width = 90,
				icon = "diag",
				signs = { ERROR = "E", WARN = "W", INFO = "I", HINT = "H" },
			})
			local lsp = section_lsp_names(110)
			local filename = section_filename(140)
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local search = statusline.section_searchcount({ trunc_width = 80 })
			local location = section_location(75)

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode:upper() } },
				{ hl = "MiniStatuslineGit", strings = { git } },
				{ hl = "MiniStatuslineDiff", strings = { diff } },
				{ hl = "MiniStatuslineDiagnostics", strings = { diagnostics } },
				{ hl = "MiniStatuslineLsp", strings = { lsp } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
		inactive = function()
			return "%#MiniStatuslineInactive# %f %="
		end,
	},
})
set_statusline_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("CustomMiniStatusline", { clear = true }),
	callback = set_statusline_hl,
})

require("mini.extra").setup()

local starter = require("mini.starter")
local starter_item = function(key, name, action)
	return { name = key .. "  " .. name, action = action, section = "Dashboard" }
end

starter.setup({
	evaluate_single = true,
	header = "nvim",
	items = {
		starter_item("f", "Find files", function()
			MiniPick.builtin.files()
		end),
		starter_item("r", "Recent files", function()
			MiniExtra.pickers.oldfiles()
		end),
		starter_item("g", "Grep text", function()
			MiniPick.builtin.grep_live()
		end),
		starter_item("b", "Open buffers", function()
			MiniPick.builtin.buffers()
		end),
		starter_item("d", "Diagnostics", function()
			MiniExtra.pickers.diagnostic({ scope = "all" })
		end),
		starter_item("h", "Help", function()
			MiniPick.builtin.help()
		end),
		starter_item("n", "New file", "enew"),
		starter_item("c", "Config", function()
			vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
		end),
		starter_item("q", "Quit", "qall"),
	},
	content_hooks = {
		starter.gen_hook.aligning("center", "center"),
	},
	footer = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
	end,
})

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
		local completion_fallback = function()
			local cursor = vim.api.nvim_win_get_cursor(0)
			local line_before_cursor = vim.api.nvim_get_current_line():sub(1, cursor[2])
			local is_path = line_before_cursor:match("[~%./%w_%-%s]*[/\\][%w_%.%-/\\]*$") ~= nil
			local keys = is_path and "<C-g><C-g><C-x><C-f>" or "<C-n>"

			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
		end

		require("mini.completion").setup({
			fallback_action = completion_fallback,
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
