local cmd = vim.fn.executable("golps") == 1 and "golps" or "gopls"

return {
	cmd = {
		cmd,
	},
	filetypes = {
		"go",
		"gomod",
		"gowork",
		"gotmpl",
	},
	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
}
