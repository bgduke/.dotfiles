local bufferline = require("bufferline")

local git_status_cache = {}

local function refresh_bufferline()
	local ok, ui = pcall(require, "bufferline.ui")
	if ok then
		ui.refresh()
	end
end

local function git_root(path)
	local dir = vim.fs.dirname(path)
	local git_dir = vim.fs.find(".git", { path = dir, upward = true })[1]
	return git_dir and vim.fs.dirname(git_dir) or nil
end

local function git_status_symbol(buf)
	if not buf.path or buf.path == "" then
		return ""
	end

	local cached = git_status_cache[buf.path]
	local now = vim.uv.hrtime() / 1000000
	if cached and now - cached.updated_at < 1500 then
		return cached.symbol
	end

	local root = git_root(buf.path)
	if not root then
		git_status_cache[buf.path] = { symbol = "", updated_at = now }
		return ""
	end

	local result = vim.system({ "git", "-C", root, "status", "--porcelain", "--", buf.path }, { text = true }):wait()
	local line = result.code == 0 and vim.split(result.stdout or "", "\n", { plain = true, trimempty = true })[1] or nil
	local status = line and line:sub(1, 2) or ""
	local index_status = status:sub(1, 1)
	local worktree_status = status:sub(2, 2)
	local symbol = ""

	if status == "??" or index_status == "A" then
		symbol = " +"
	elseif index_status == "D" or worktree_status == "D" then
		symbol = " -"
	elseif status ~= "" and (index_status ~= " " or worktree_status ~= " ") then
		symbol = " ~"
	end

	git_status_cache[buf.path] = { symbol = symbol, updated_at = now }
	return symbol
end

local function diagnostics_indicator(count, level, diagnostics_dict)
	if not diagnostics_dict then
		return ""
	end

	local parts = {}
	local severities = {
		{ name = "error", icon = "" },
		{ name = "warning", icon = "" },
		{ name = "info", icon = "" },
		{ name = "hint", icon = "󰌵" },
	}

	for _, severity in ipairs(severities) do
		local severity_count = diagnostics_dict[severity.name]
		if severity_count and severity_count > 0 then
			table.insert(parts, severity.icon .. severity_count)
		end
	end

	return #parts > 0 and " " .. table.concat(parts, " ") or ""
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufFilePost", "FocusGained" }, {
	group = vim.api.nvim_create_augroup("bufferline_git_status", { clear = true }),
	callback = function()
		git_status_cache = {}
		refresh_bufferline()
	end,
})

bufferline.setup({
	options = {
		mode = "buffers",
		style_preset = bufferline.style_preset.default,
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		left_mouse_command = "buffer %d",
		indicator = {
			icon = "▎",
			style = "icon",
		},
		modified_icon = "●",
		name_formatter = function(buf)
			return buf.name .. git_status_symbol(buf)
		end,
		diagnostics = "nvim_lsp",
		diagnostics_update_on_event = true,
		diagnostics_indicator = diagnostics_indicator,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
		color_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		separator_style = { "|", "" },
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "insert_after_current",
	},
})
