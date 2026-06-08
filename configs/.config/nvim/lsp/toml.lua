return {
	cmd = {
		"taplo",
		"lsp",
		"stdio",
	},
	filetypes = {
		"toml",
	},
	root_markers = {
		".taplo.toml",
		"taplo.toml",
		"Cargo.toml",
		"pyproject.toml",
		".git",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
