return {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = {
		"json",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
