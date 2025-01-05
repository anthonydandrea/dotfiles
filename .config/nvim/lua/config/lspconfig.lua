-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {['rust-analyzer'] = {cargo = {allFeatures = true}}}
}
vim.api.nvim_create_user_command('RAE', function()
    vim.cmd('edit ~/.config/nvim/init.lua') -- Replace 'filename' with your actual file name
    vim.cmd('/lspconfig.rust_analyzer.setup') -- Replace 'search_string' with the text to find
end, {})

lspconfig.pyright.setup {capabilities = capabilities}
lspconfig.tsserver.setup {
    -- capabilities = capabilities,
}
lspconfig.clangd.setup {capabilities = capabilities}

