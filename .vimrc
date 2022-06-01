
call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.com/sharkdp/fd.git'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Theme
Plug 'franbach/miramare'

" Syntax highlighting
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

let mapleader = " "
map <leader>[ :cnext<CR>
map <leader>] :cprev<CR>
map <leader>3 :b#<CR>

map <C-n> <C-b>

set ts=4 sw=4
set mouse=a

" 
inoremap jj <ESC>
""inoremap { {}<Left><Esc>ha
""inoremap ( ()<Left><Esc>ha
""inoremap [ []<Left><Esc>ha
""inoremap " ""<Left><Esc>ha
""inoremap ' ''<Left><Esc>ha
""inoremap ` ``<Left><Esc>ha

" cp to overwrite current word with yanked buffer
nmap <silent> cp "_cw<C-R>"<Esc>

" Vavigate CoC menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip   " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|build/*|dist/*|node_modules'
set number relativenumber
set cursorline

syntax on

" important!!
set termguicolors

" the configuration options should be placed before `colorscheme miramare`
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

colorscheme miramare


command -nargs=1 Sr vimgrep /<args>/gj `git ls-files`

highlight LineNr guifg=orange

syntax on

" important!!
set termguicolors

" the configuration options should be placed before `colorscheme miramare`
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

colorscheme miramare

hi LineNr guifg=orange

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


hi typescriptOperator guibg=bg guifg=#ff8080
hi typescriptAmbientDeclaration guibg=bg guifg=#ff8080
hi typescriptExceptions guibg=bg guifg=#ff8080
hi typescriptCastKeyword guibg=bg guifg=#ff8080
hi typescriptMappedIn guibg=bg guifg=#ff8080
hi typescriptDOMStyle guibg=bg guifg=#ff8080
hi typescriptForOperator guibg=bg guifg=#ff8080
hi typescriptConditional guibg=bg guifg=#ff8080
hi typescriptConditionalElse guibg=bg guifg=#ff8080
hi typescriptRepeat guibg=bg guifg=#ff8080

hi typescriptDotNotation guibg=bg guifg=white
hi typescriptGlobalNumberDot guibg=bg guifg=white
hi typescriptGlobalStringDot guibg=bg guifg=white
hi typescriptGlobalArrayDot guibg=bg guifg=white
hi typescriptGlobalObjectDot guibg=bg guifg=white
hi typescriptGlobalSymbolDot guibg=bg guifg=white
hi typescriptGlobalMathDot guibg=bg guifg=white
hi typescriptGlobalDateDot guibg=bg guifg=white
hi typescriptGlobalJSONDot guibg=bg guifg=white
hi typescriptGlobalPromiseDot guibg=bg guifg=white
hi typescriptGlobalRegExpDot guibg=bg guifg=white
hi typescriptGlobalURLDot guibg=bg guifg=white
hi typescriptObjectColon guibg=bg guifg=white
hi typescriptTypeAnnotation guibg=bg guifg=white

hi typescriptNodeGlobal guibg=bg guifg=#e0abdb
hi typescriptExport guibg=bg guifg=#e0abdb
hi typescriptImport guibg=bg guifg=#e0abdb

hi jsonQuote guifg=lightgrey
