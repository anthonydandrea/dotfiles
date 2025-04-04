vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.ctrlp_map = '<c-p>'
vim.g.ctrlp_cmd = 'CtrlP'
vim.g.ctrlp_working_path_mode = 'ra'

vim.g.miramare_enable_italic = 1
vim.g.miramare_disable_italic_comment = 1

vim.g.fzf_history_dir = '~/.fzf-history'

-- Quicker update for reloading from disk changes
vim.opt.updatetime = 1000

-- Formatting
vim.opt.ts = 4
vim.opt.sw = 4
vim.opt.expandtab = true
vim.opt.mouse = a
vim.opt.so = 999
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"
