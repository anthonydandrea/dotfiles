set ts=4 sw=4
set mouse=a

" 
inoremap jj <ESC>

" cp to overwrite current word with yanked buffer
nmap <silent> cp "_cw<C-R>"<Esc>

" Vavigate CoC menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Any valid git URL is allowed

" Theme
Plug 'franbach/miramare'

" Syntax highlighting
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()

set relativenumber
syntax on

" important!!
set termguicolors

" the configuration options should be placed before `colorscheme miramare`
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

colorscheme miramare




inoremap jj <ESC>

" Vavigate CoC menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Any valid git URL is allowed

" Theme
Plug 'franbach/miramare'

" Syntax highlighting
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Initialize plugin system
call plug#end()

set relativenumber
syntax on

" important!!
set termguicolors

" the configuration options should be placed before `colorscheme miramare`
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

colorscheme miramare

" Highlighting off
hi rustKeyword guibg=bg guifg=#ff8080
hi rustConditional guibg=bg guifg=#ff8080
hi rustRepeat guibg=bg guifg=#ff8080
hi rustTypedef guibg=bg guifg=#ff8080

hi rustModPathSep guibg=bg guifg=white
hi rustDerive guibg=bg guifg=#e0abdb
hi rustAttribute guibg=bg guifg=#e0abdb
hi rustDeriveTrait guibg=bg guifg=#e0abdb
hi rustPubScopeCrate guibg=bg guifg=#e0abdb


