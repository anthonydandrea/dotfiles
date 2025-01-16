-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {capabilities = capabilities}
lspconfig.pyright.setup {capabilities = capabilities}
lspconfig.ts_ls.setup {capabilities = capabilities}
lspconfig.clangd.setup {capabilities = capabilities}

