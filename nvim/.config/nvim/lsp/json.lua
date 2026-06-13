local has_schemastore, schemastore = pcall(require, "schemastore")

return {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = {
		"json",
		"jsonc",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	settings = {
		json = {
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = has_schemastore and schemastore.json.schemas() or {},
			validate = {
				enable = true,
			},
		},
	},
}
