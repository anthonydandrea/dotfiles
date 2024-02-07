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
    {'neoclide/coc.nvim', branch='release'},
    { 'tpope/vim-repeat' },
    -- " Docstrings
    -- " https://github.com/danymat/neogen#features"
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        lazy = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    -- " Cursor search highlight
    { 'https://github.com/PeterRincker/vim-searchlight.git' },
    -- Multi file search replace
    { 'https://github.com/wincent/ferret.git' },
    -- " autoformatting
    { 'vim-autoformat/vim-autoformat' },
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
    { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
    { 'junegunn/fzf' },
    { 'junegunn/fzf.vim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
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

vim.cmd('source ~/.config/nvim/another_init.vim')
