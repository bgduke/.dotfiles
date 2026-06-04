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
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("GustavEikaas/easy-dotnet.nvim") },
	{ src = gh("nvim-lua/plenary.nvim") },
	-- Utils
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("romus204/tree-sitter-manager.nvim") },
	-- DAP
	{ src = gh("mfussenegger/nvim-dap") },
	{ src = gh("nvim-neotest/nvim-nio") },
	{ src = gh("rcarriga/nvim-dap-ui") },
	{ src = gh("jay-babu/mason-nvim-dap.nvim") },
	-- Completion
	{ src = gh("saghen/blink.cmp"), version = "v1" },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("L3MON4D3/LuaSnip") },
})
