vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("markdown_options", { clear = true }),
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 120
		vim.opt_local.colorcolumn = "120"
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.conceallevel = 1
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.foldtext = "v:lua.vim.treesitter.foldtext()"
		vim.opt_local.foldlevel = 99
		vim.opt_local.foldlevelstart = 99
		vim.opt_local.formatoptions:append({ "t" })
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id
		local map_split = function(keys, direction, desc)
			vim.keymap.set("n", keys, function()
				local MiniFiles = require("mini.files")
				local entry = MiniFiles.get_fs_entry()
				if entry == nil then
					vim.notify("No fd entry in mini files", vim.log.levels.WARN)
					return
				end

				if entry.fs_type == "directory" then
					MiniFiles.go_in()
					return
				end

				local cur_target = MiniFiles.get_explorer_state().target_window
				local new_target = vim.api.nvim_win_call(cur_target, function()
					vim.cmd(direction .. " split")
					return vim.api.nvim_get_current_win()
				end)

				MiniFiles.set_target_window(new_target)
				MiniFiles.go_in({ close_on_file = true })
			end, { buffer = buf_id, desc = desc })
		end

		map_split("<C-v>", "vertical", "Open in vertical split")
		map_split("<C-s>", "", "Open in horizontal split")

		vim.keymap.set("n", "<leader>a", function()
			local entry = require("mini.files").get_fs_entry()
			if entry == nil then
				vim.notify("No fd entry in mini files", vim.log.levels.WARN)
				return
			end
			local target_dir = entry.path
			if target_dir == nil then
				vim.notify("No fd entry in mini files", vim.log.levels.WARN)
				return
			end

			if entry.fs_type == "file" then
				target_dir = vim.fn.fnamemodify(entry.path, ":h")
			end
			require("easy-dotnet").create_new_item(target_dir)
		end, { buffer = buf_id, desc = "Create item" })
	end,
})
