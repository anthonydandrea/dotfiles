local map = vim.api.nvim_set_keymap
vim.g.mapleader = " "
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>',
    {desc = "Toggle Spectre"})
map('n', '<leader>sw',
    '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    {desc = "Search current word"})
map('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
    {desc = "Search current word"})
map('n', '<leader>sp',
    '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    {desc = "Search on current file"})
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
    {noremap = true, silent = true})
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>',
    {noremap = true, silent = true})

map('n', '<leader>[', ':cnext<CR>', {})
map('n', '<leader>]', ':cprev<CR>', {})
map('n', '<leader>3', ':b#<CR>', {})
map('n', '<leader>n', ':bn<CR>', {})
map('n', '<leader>b', ':bp<CR>', {})
map('n', '<C-n>', '<C-b>', {})
map('n', '<C-p>', ':Files<CR>', {})

map('n', '<leader>r', ':Rg<CR>', {})

-- CodeWhisperer generate
map('n', '<leader>g', ':CWGenerateNvim<CR>', {})

-- copy to system clipboard
map('i', '<leader>C', '"+y', {})

-- leader p to paste from yank buffer
map('n', '<leader>p', '"_dP', {})

-- leader-w to :w
map('n', '<leader>w', ':w<CR>', {})
map('n', '<leader>q', ':q<CR>', {})
map('n', '<leader>F', ':Neoformat<CR>', {})

-- leader o to insert new line and stay in normal mode
map('n', '<Leader>o', 'o<Esc>', {})
map('n', '<leader>t', ':NvimTreeToggle<CR>', {})

map('i', 'jj', '<Esc>', {})

map("n", "<leader>n", ":lua ChangeLineNumbering()<CR>", { noremap = true, silent = true })

-- cp to overwrite current word with yanked buffer
-- nmap <silent> cp "_cw<C-R>"<Esc>

-- Vavigate CoC menu with Tab
-- map <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
-- map <expr> <S-Tab> pumvisible() ? \<C-p>"  "\<S-Tab>"

-- GoTo code navigation
-- map('gd', <Plug>(coc-definition), { silent = true })
-- map('gy', <Plug>(coc-type-definition), { silent = true })
-- map('gi', <Plug>(coc-implementation), { silent = true })
-- map('gr', <Plug>(coc-references), { silent = true })

