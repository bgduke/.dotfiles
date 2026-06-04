local dotnet = require("easy-dotnet")

require("lualine").setup({
	options = {
		theme = "gruvbox",
	},
	sections = {
		lualine_a = { "mode", dotnet.lualine.jobs },
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = { dotnet.lualine.active_project },
	},
})
