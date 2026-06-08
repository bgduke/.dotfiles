vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("plugins.mason")
require("plugins.lsp")
require("plugins.mini")
require("plugins.which-key")
require("plugins.conform")
require("plugins.gruvbox")
require("plugins.dap")
require("plugins.easydotnet")

require("config.options")
require("config.keymaps")
require("config.autocmds")
