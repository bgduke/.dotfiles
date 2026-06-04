vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-->", "<C-o>", { desc = "Jump back" })
vim.keymap.set("n", "<C-=>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set({ "i", "n", "v" }, "<C-C>", "<esc>")
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear Highlighting" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save Buffer" })
vim.keymap.set("n", "H", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "L", ":bnext<CR>", { silent = true })
local function smart_quit()
	local current = vim.api.nvim_get_current_buf()

	if vim.bo[current].buftype ~= "" then
		vim.cmd("quit")
		return
	end

	vim.cmd("write")

	local buffers = vim.tbl_filter(function(bufnr)
		return bufnr ~= current
			and vim.api.nvim_buf_is_valid(bufnr)
			and vim.bo[bufnr].buflisted
			and vim.bo[bufnr].buftype == ""
	end, vim.api.nvim_list_bufs())

	if #buffers == 0 then
		vim.cmd("quit")
		return
	end

	local alternate = vim.fn.bufnr("#")
	local target = buffers[1]

	if alternate > 0 and vim.tbl_contains(buffers, alternate) then
		target = alternate
	end

	vim.api.nvim_set_current_buf(target)

	local ok, err = pcall(vim.cmd, "bdelete " .. current)
	if not ok then
		vim.api.nvim_set_current_buf(current)
		vim.notify(err, vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_user_command("SmartQuit", smart_quit, {})

vim.keymap.set("n", "<leader>q", ":SmartQuit<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close Buffer", silent = true })
vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "<C-b>", ":Dotnet build<CR>", { desc = "Build Project" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
	callback = function(event)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
		end

		local function telescope(method)
			return function()
				require("telescope.builtin")[method]()
			end
		end

		map("gd", telescope("lsp_definitions"), "LSP go to definition")
		map("gD", vim.lsp.buf.declaration, "LSP go to declaration")
		map("gi", telescope("lsp_implementations"), "LSP go to implementation")
		map("gr", telescope("lsp_references"), "LSP show references")
		map("gy", telescope("lsp_type_definitions"), "LSP go to type definition")
		map("K", vim.lsp.buf.hover, "LSP hover")
		map("<leader>rn", vim.lsp.buf.rename, "LSP rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
		map("<leader>ds", telescope("lsp_document_symbols"), "LSP document symbols")
		map("<leader>ws", telescope("lsp_dynamic_workspace_symbols"), "LSP workspace symbols")
	end,
})
