local home = os.getenv("HOME")
package.path = package.path
	.. ";"
	.. home
	.. "/.config/nvim/lua/?.lua"
	.. ";"
	.. home
	.. "/.config/nvim/lua/config/?.lua"

require("utils")
require("plugins")
require("settings")
require("keymaps")
require("config/cmp")
require("config/lspconfig")
require("config/marks")
require("config/harpoon2")
require("config/nvim-tree")

require("kanagawa").load("dragon")
