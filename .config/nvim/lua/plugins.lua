local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
{
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = {
                function()
                    require('lualine').setup {
                        sections = {
                            lualine_x = {'fileformat', 'filetype'},
                        },
                        options = {
                            theme = 'gruvbox', -- Or set a specific theme
                        },
                        winbar = {
                            lualine_a = { require"doing.api".status },
                        }
                    }
                end
            }
        },	{
		"rebelot/kanagawa.nvim",
	},

	{
		"rmehri01/onenord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onenord").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{ "nvim-tree/nvim-tree.lua" }, -- {
	{ "https://github.com/sharkdp/fd.git" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/nvim-cmp" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-vsnip" },
	{ "hrsh7th/vim-vsnip" },
	{ "tpope/vim-repeat" }, -- " Docstrings
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
		lazy = true,
		-- Uncomment next line if you want to follow only stable versions
		version = "*",
	}, -- " Cursor search highlight
	{ "https://github.com/PeterRincker/vim-searchlight.git" },
	-- Multi file search replace
	{ "https://github.com/wincent/ferret.git" }, -- " autoformatting
	{ "sbdchd/neoformat" }, -- Kotlin syntax highlighting
	{ "udalov/kotlin-vim" }, -- " surround.vim
	{ "https://tpope.io/vim/surround.git" }, -- " Comments
	{ "https://tpope.io/vim/commentary.git" }, -- " NERDTree
	-- " Smooth scroll
	{ "psliwka/vim-smoothie" }, -- " Theme
	{ "franbach/miramare" }, -- " Syntax highlighting"
	{ "yuezk/vim-js" },
	{ "maxmellon/vim-jsx-pretty", lazy = true },
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-pack/nvim-spectre" },
	{ "junegunn/fzf" },
	{ "junegunn/fzf.vim" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "chentoast/marks.nvim" },
	{ dir = "/apollo/env/envImprovement/vim/amazon/brazil-config" },
	{ "nvim-tree/nvim-web-devicons" },
})
