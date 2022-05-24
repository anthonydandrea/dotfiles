set ts=4 sw=4
set mouse=a

" 
inoremap jj <ESC>

" cp to overwrite current word with yanked buffer
nmap <silent> cp "_cw<C-R>"<Esc>

" Vavigate CoC menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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

" Fuzzy finding
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

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

hi typescriptNodeGlobal guibg=bg guifg=#e0abdb
hi typescriptExport guibg=bg guifg=#e0abdb
hi typescriptImport guibg=bg guifg=#e0abdb

hi jsonQuote guifg=lightgrey
