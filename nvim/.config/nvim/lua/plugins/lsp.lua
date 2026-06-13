vim.pack.add({ "https://github.com/b0o/SchemaStore.nvim" })

vim.lsp.enable({
	"lua_ls",
	"html",
	"json",
	"toml",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("gd", vim.lsp.buf.definition, "Goto Definition")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gr", function()
			require("mini.extra").pickers.lsp({ scope = "references" })
		end, "Find References")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("<leader>rr", vim.lsp.buf.rename, "Rename all references")
		map("<leader>kp", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, "Format")
		map("<leader>gv", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end

		if client and client:supports_method("textDocument/foldingRange", event.buf) then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldmethod = "expr"
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
			vim.wo[win][0].foldtext = "v:lua.vim.lsp.foldtext()"
		end
	end,
})

vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = {
		source = "if_many",
		prefix = "●",
	},
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
