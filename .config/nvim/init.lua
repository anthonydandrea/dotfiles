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
    -- {
    --     'ribru17/bamboo.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require('bamboo').setup {
    --             style = 'vulgaris',
    --             highlights = {
    --             }
    --         }
    --         require('bamboo').load()
    --     end,
    -- },
    {
        'rmehri01/onenord.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('onenord').setup()
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
    },
    { 'https://github.com/sharkdp/fd.git' },
    -- {'neoclide/coc.nvim', branch='release'},

    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'hrsh7th/nvim-cmp'},
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },

    -- { 'L3MON4D3/LuaSnip'},
    -- {'saadparwaiz1/cmp_luasnip'},
    { 'tpope/vim-repeat' },
    -- " Docstrings
    -- " https://github.com/danymat/neogen#features"
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        lazy = true,
        -- Uncomment next line if you want to follow only stable versions
        version = "*"
    },
    -- " Cursor search highlight
    { 'https://github.com/PeterRincker/vim-searchlight.git' },
    -- Multi file search replace
    { 'https://github.com/wincent/ferret.git' },
    -- " autoformatting
    -- { 'vim-autoformat/vim-autoformat' },
    { 'sbdchd/neoformat' },
    -- Kotlin syntax highlighting
    { 'udalov/kotlin-vim' },
    -- " surround.vim
    { 'https://tpope.io/vim/surround.git' },
    -- " Comments
    { 'https://tpope.io/vim/commentary.git' },
    -- " NERDTree
    { 'preservim/nerdtree' },
    -- " Smooth scroll
    { 'psliwka/vim-smoothie' },
    -- " Theme
    { 'franbach/miramare' },
    -- " Syntax highlighting"
    { 'yuezk/vim-js' },
    { 'maxmellon/vim-jsx-pretty', lazy = true },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-pack/nvim-spectre' },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
    { 'junegunn/fzf' },
    { 'junegunn/fzf.vim' },
    -- {
    --     "neovim/nvim-lspconfig",
        -- cmd = function ()
        --     local lspconfig = require 'lspconfig'
        --     local configs = require 'lspconfig.configs'
        --     if not configs.codewhisperer then
        --         configs.codewhisperer = {
        --             default_config = {
        --                 -- Add the codewhisperer to our PATH or BIN folder
        --                 cmd = { "cwls" },
        --                 root_dir = lspconfig.util.root_pattern("packageInfo", "package.json", "tsconfig.json", "jsconfig.json", ".git"),
        --                 filetypes = { 'java', 'python', 'typescript', 'javascript', 'csharp', 'ruby', 'kotlin', 'shell', 'sql', 'c', 'cpp', 'go', 'rust', 'lua' },
        --             },
        --         }
        --     end
        --     lspconfig.codewhisperer.setup {}
        -- end,
    -- },
    { 'ThePrimeagen/harpoon' },
    { dir = '/apollo/env/envImprovement/vim/amazon/brazil-config' },
    -- { dir = '~/workplace/codewhisperer-nvim/src/AmazonCodeWhispererVimin' }

    -- " Tabs
    -- "  'nvim-tree/nvim-web-devicons'
    -- "  'romgrk/barbar.nvim'

    -- " Copilot
    -- "  'https://github.com/github/copilot.vim'

    -- " autoread plug to refresh buffers when changed on fs in background
    -- "  'https://github.com/TheZoq2/neovim-auto-autoread.git'

    -- " Git support"
    -- { 'https://github.com/airblade/vim-gitgutter.git' },
})

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  ["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			-- elseif luasnip.expand_or_jumpable() then
			-- 	luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {"i", "s"}),
   ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            -- elseif luasnip.jumpable(-1) then
            --     luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"}),
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

vim.cmd('source ~/.config/nvim/another_init.vim')

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })


-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.rust_analyzer.setup {
-- }
