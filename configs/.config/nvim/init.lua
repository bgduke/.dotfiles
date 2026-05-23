-- ==================================================================================================================================================
-- CORE VIM CONFIG
-- ==================================================================================================================================================
-- UI
vim.o.background = "dark"
vim.o.number = true -- absolute line numbers
vim.o.relativenumber = true -- relative numbers
vim.o.cursorline = true -- highlight current line
vim.o.showmode = false -- don"t show -- INSERT --
vim.o.signcolumn = "yes" -- always show sign column
vim.o.wrap = false -- no line wrapping
vim.o.scrolloff = 8 -- keep lines above/below cursor
vim.o.sidescrolloff = 8
vim.o.confirm = true
vim.o.ttimeoutlen = 1 -- Snappy escape

--Transparent background
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.smartindent = true
vim.o.autoindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- Files & Backup
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true -- persistent undo
-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Clipboard
vim.o.clipboard = "unnamedplus"

-- Diagnostics
vim.diagnostic.config({
	severity_sort = true, -- show most severe error first
	update_in_insert = false, -- don"t update while typing
	float = { source = "if_many" }, -- nicer look for floats and show source if multiple sources (ex. ruff and ty)
	jump = { float = true }, -- automatically open the diagnostic float if you jump with [d ]d
})

-- ==================================================================================================================================================
-- AUTO CMDS
-- ==================================================================================================================================================
-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- Found a supporting client, no need to check others
				end
			end

			-- 3. Proceed only if an LSP is active AND supports the feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

-- Transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local highlights = {
			"Normal",
			"NormalNC",
			"LineNr",
			"Folded",
			"NonText",
			"SpecialKey",
			"VertSplit",
			"SignColumn",
			"EndOfBuffer",
		}
		for _, name in ipairs(highlights) do
			vim.cmd("hi " .. name .. " guibg=NONE ctermbg=NONE")
		end
	end,
})

-- ==================================================================================================================================================
-- CORE KEYMAPS
-- ==================================================================================================================================================
-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Ctrl+C behave like escape
vim.keymap.set({ "i", "n", "v" }, "<C-C>", "<esc>")

-- Exit Terminal Mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Clear search highlight
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear Highlighting" })

-- Quick save
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save Buffer" })

-- Navigate buffers
vim.keymap.set("n", "H", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "L", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":w | bdelete<CR>", { silent = true })

-- Close the current buffer (like Ctrl+W in VS Code)
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close Buffer", silent = true })

-- Show diagnostics
vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- ==================================================================================================================================================
-- PLUGINS
-- ==================================================================================================================================================
local gh = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	-- UI
	{ src = gh("ellisonleao/gruvbox.nvim") },
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = gh("nvim-tree/nvim-web-devicons") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("folke/which-key.nvim") },
	{ src = gh("akinsho/bufferline.nvim") },
	{ src = gh("stevearc/dressing.nvim") },
	-- General Purpose
	{ src = gh("nvim-tree/nvim-tree.lua") },
	{ src = gh("nvim-telescope/telescope.nvim") },
	{ src = gh("windwp/nvim-autopairs") },
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("GustavEikaas/easy-dotnet.nvim") },
	{ src = gh("nvim-lua/plenary.nvim") },
	-- Utils
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("romus204/tree-sitter-manager.nvim") },
	-- DAP
	{ src = gh("mfussenegger/nvim-dap") },
	{ src = gh("rcarriga/nvim-dap-ui") },
	{ src = gh("jay-babu/mason-nvim-dap.nvim") },
	{ src = gh("nvim-neotest/nvim-nio") },
	-- Completion
	{ src = gh("saghen/blink.cmp"), version = "v1" },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("L3MON4D3/LuaSnip") },
})

-- ==================================================================================================================================================
-- PLUGINS CONFIG
-- ==================================================================================================================================================
-- Colorscheme
require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")
-- vim.cmd.colorscheme("catppuccin-mocha")

-- Autopairs
require("nvim-autopairs").setup()

-- Buffer Line
local bufferline = require("bufferline")
bufferline.setup({
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
		numbers = "none",
		close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
		indicator = {
			icon = "▎", -- this should be omitted if indicator style is not 'icon'
			style = "icon",
		},
		buffer_close_icon = "󰅖",
		modified_icon = "● ",
		close_icon = " ",
		left_trunc_marker = " ",
		right_trunc_marker = " ",
		--- name_formatter can be used to change the buffer's label in the bufferline.
		--- Please note some names can/will break the
		--- bufferline so use this at your discretion knowing that it has
		--- some limitations that will *NOT* be fixed.
		name_formatter = function(buf) -- buf contains:
			-- name                | str        | the basename of the active file
			-- path                | str        | the full path of the active file
			-- bufnr               | int        | the number of the active buffer
			-- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
			-- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
		end,
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false, -- only applies to coc
		diagnostics_update_on_event = true, -- use nvim's diagnostic handler
		-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "(" .. count .. ")"
		end,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		custom_filter = function(buf_number, buf_numbers)
			-- filter out filetypes you don't want to see
			if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
				return true
			end
			-- filter out by buffer name
			if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
				return true
			end
			-- filter out based on arbitrary rules
			-- e.g. filter out vim wiki buffer from tabline in your work repo
			if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
				return true
			end
			-- filter out by it's index number in list (don't show first buffer)
			if buf_numbers[1] ~= buf_number then
				return true
			end
		end,
		offsets = {
			{
				filetype = "snacks_layout_box",
				text = "󰙅  File Explorer",
				separator = true,
			},
			{

				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		get_element_icon = function(element)
			-- element consists of {filetype: string, path: string, extension: string, directory: string}
			-- This can be used to change how bufferline fetches the icon
			-- for an element e.g. a buffer or a tab.
			-- e.g.
			local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
			return icon, hl
		end,
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
		duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = { "|", "" },
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		auto_toggle_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "insert_after_current",
		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
		},
	},
})

-- Blink Completion
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<RIGHT>"] = { "accept", "fallback" },
		["<TAB>"] = { "accept", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { documentation = { auto_show = false } },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Mason
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Conform
require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable autoformat on certain filetypes
		local ignore_filetypes = { "sql", "java" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- Disable autoformat for files in a certain path
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end
		-- ...additional logic...
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	formatters = {
		prettier_json = {
			inherit = "prettier",
			append_args = { "--trailing-comma", "none" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettier_json" },
		jsonc = { "prettier_json" },
	},
})
vim.keymap.set("n", "<leader>F", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })

-- LSP Config
vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "Snacks", "hl" },
			},
		},
	},
}
vim.lsp.enable("lua_ls")

vim.lsp.config["jsonls"] = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },
	init_options = {
		provideFormatter = false,
	},
	settings = {
		json = {
			validate = { enable = true },
		},
	},
}
vim.lsp.enable("jsonls")

-- Lua Line
local dotnet = require("easy-dotnet")
require("lualine").setup({
	options = {
		theme = "gruvbox",
	},
	sections = {
		lualine_a = { "mode", dotnet.lualine.jobs },
		lualine_x = { dotnet.lualine.active_project },
	},
})

-- DAP
require("mason-nvim-dap").setup({
	ensure_installed = { "cppdbg" },
	handlers = {},
})
local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.keymap.set("n", "<F5>", function()
	dap.continue()
end)
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end)
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end)
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end)
vim.keymap.set("n", "<F9>", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint()
end)

-- Which Key
require("which-key").setup()

-- Tree-sitter-manager
require("tree-sitter-manager").setup()

-- NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.map.on_attach.default(bufnr)

	-- custom mappings
	vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

local config = {
	on_attach = my_on_attach,
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
}
require("nvim-tree").setup(config)
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Telescop
require("telescope").setup()

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- ==================================================================================================================================================
-- PLUGINS CONFIG: EASY DOT NET
-- ==================================================================================================================================================
require("easy-dotnet").setup({
	managed_terminal = {
		auto_hide = true, -- auto hides terminal if exit code is 0
		auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
		mappings = {
			next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
			prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
			new_terminal = { lhs = "+", desc = "New user terminal" },
			close_terminal = { lhs = "X", desc = "Close current terminal tab" },
			hide_panel = { lhs = "q", desc = "Hide terminal panel" },
		},
	},
	-- Optional configuration for external terminals (matches nvim-dap structure)
	external_terminal = nil,
	lsp = {
		enabled = true, -- Enable builtin roslyn lsp
		set_fold_expr = false,
		preload_roslyn = true, -- Start loading roslyn before any buffer is opened
		roslynator_enabled = true, -- Automatically enable roslynator analyzer
		easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
		auto_refresh_codelens = true,
		analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
		config = {},
	},
	debugger = {
		-- Path to custom coreclr DAP adapter
		-- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
		bin_path = nil,
		console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
		apply_value_converters = true,
		auto_register_dap = true,
		mappings = {
			open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
		},
	},
	---@type TestRunnerOptions
	test_runner = {
		auto_start_testrunner = true,
		hide_legend = false,
		---@type "split" | "vsplit" | "float" | "buf"
		viewmode = "float",
		---@type number|nil
		vsplit_width = nil,
		---@type string|nil "topleft" | "topright"
		vsplit_pos = nil,
		icons = {
			passed = "",
			skipped = "",
			failed = "",
			success = "",
			reload = "",
			test = "",
			sln = "󰘐",
			project = "󰘐",
			dir = "",
			package = "",
			class = "",
			build_failed = "󰒡",
		},
		mappings = {
			run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
			run_all_tests_from_buffer = { lhs = "<leader>t", desc = "Run all tests in file" },
			get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
			peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
			debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
			debug_test = { lhs = "<leader>d", desc = "debug test" },
			go_to_file = { lhs = "g", desc = "go to file" },
			run_all = { lhs = "<leader>R", desc = "run all tests" },
			run = { lhs = "<leader>r", desc = "run test" },
			peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
			expand = { lhs = "o", desc = "expand" },
			expand_node = { lhs = "E", desc = "expand node" },
			collapse_all = { lhs = "W", desc = "collapse all" },
			close = { lhs = "q", desc = "close testrunner" },
			refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
			cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
		},
	},
	new = {
		project = {
			prefix = "sln", -- "sln" | "none"
		},
	},
	csproj_mappings = true,
	fsproj_mappings = true,
	auto_bootstrap_namespace = {
		--block_scoped, file_scoped
		type = "block_scoped",
		enabled = true,
		use_clipboard_json = {
			behavior = "prompt", --"auto" | "prompt" | "never",
			register = "+", -- which register to check
		},
	},
	server = {
		---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
		log_level = nil,
	},
	-- choose which picker to use with the plugin
	-- possible values are "telescope" | "fzf" | "snacks" | "basic"
	-- if no picker is specified, the plugin will determine
	-- the available one automatically with this priority:
	--  snacks -> fzf -> telescope ->  basic
	picker = "snacks",
	background_scanning = true,
	notifications = {
		--Set this to false if you have configured lualine to avoid double logging
		handler = function(start_event)
			local spinner = require("easy-dotnet.ui-modules.spinner").new()
			spinner:start_spinner(start_event.job.name)
			---@param finished_event JobEvent
			return function(finished_event)
				spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
			end
		end,
	},
	diagnostics = {
		default_severity = "error",
		setqflist = false,
	},
	outdated = {
		mappings = {
			upgrade = { lhs = "<leader>pu", desc = "upgrade package under cursor" },
			upgrade_all = { lhs = "<leader>pa", desc = "upgrade all outdated packages" },
		},
	},
})
