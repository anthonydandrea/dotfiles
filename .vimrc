call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.com/sharkdp/fd.git'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-repeat'

" Tabs
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Cursor search highlight
Plug 'https://github.com/PeterRincker/vim-searchlight.git'

" Copilot
" Plug 'https://github.com/github/copilot.vim'

" autoformatting
Plug 'vim-autoformat/vim-autoformat'

" autoread plug to refresh buffers when changed on fs in background
" Plug 'https://github.com/TheZoq2/neovim-auto-autoread.git'

" surround.vim
Plug 'https://tpope.io/vim/surround.git'

" Git support
Plug 'https://github.com/airblade/vim-gitgutter.git'

" Comments
Plug 'https://tpope.io/vim/commentary.git'

" NERDTree
Plug 'preservim/nerdtree'

" Smooth scroll
Plug 'psliwka/vim-smoothie'

" Theme
Plug 'franbach/miramare'

" Syntax highlighting
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'ThePrimeagen/harpoon'

Plug '/apollo/env/envImprovement/vim/amazon/brazil-config'

" Plug '~/workplace/codewhisperer-nvim/src/AmazonCodeWhispererVimPlugin'

call plug#end()

""" Let
let mapleader = " "
" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|build/*|dist/*|node_modules'

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

let g:brazil_config_plugin_path = '/apollo/env/envImprovement/vim/amazon/brazil-config'

let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let g:NERDTreeWinSize=80

" the configuration options should be placed before `colorscheme miramare`
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

" search history memory https://gist.github.com/junegunn/f8a0b2712656867888e79397cc5cbffc
let g:fzf_history_dir = '~/.fzf-history'

" let g:current_directory = getcwd()

""" Map
map <leader>[ :cnext<CR>
map <leader>] :cprev<CR>
map <leader>3 :b#<CR>
map <leader>n :bn<CR>
map <leader>b :bp<CR>
map <C-n> <C-b>
map <C-p> :Files<CR>

command! -bang -nargs=* PRg
            \ call fzf#vim#grep("rg --files --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': g:current_directory }, <bang>0)

let g:fzf_history_dir = '~/.fzf-history'
" map <C-[> :Rg<CR>
map <C-h> :BufferPrevious<CR>
map <C-l> :BufferNext<CR>

" Ripgrep
map <leader>r :Rg<CR>

" CodeWhisperer generate
map <leader>g :CWGenerateNvim<CR>

" copy to system clipboard
map <leader>C "+y

" leader p to paste from yank buffer
nnoremap <leader>p "0p

" leader-w to :w
nnoremap <leader>w :w<CR>

" leader o to insert new line and stay in normal mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

inoremap jj <ESC>
" inoremap <leader>y "+y
""inoremap { {}<Left><Esc>ha
""inoremap ( ()<Left><Esc>ha
""inoremap [ []<Left><Esc>ha
""inoremap " ""<Left><Esc>ha
""inoremap ' ''<Left><Esc>ha
""inoremap ` ``<Left><Esc>ha

map <leader>s :call SynStack()<CR>

nnoremap <leader>t :NERDTreeToggle<CR>

" cp to overwrite current word with yanked buffer
nmap <silent> cp "_cw<C-R>"<Esc>

" Vavigate CoC menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

" Tabs for buffers
" map T <Cmd>BufferPrevious<CR>
" map t <Cmd>BufferNext<CR>
map <leader>q <Cmd>BufferClose<CR>

map <leader>m <Cmd>lua require("harpoon.mark").add_file()<CR>
map <leader>f <Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>


" autocmd VimEnter * Copilot enable


function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction



cnoreabbrev nf saveas %:h/


""" set
" Ignore files when searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip   " MacOSX/Linux

"Autoreload files when changed externally
" https://stackoverflow.com/questions/2157914/can-vim-monitor-realtime-changes-to-a-file
set autoread | au CursorHold * checktime | call feedkeys("lh")

" if has('nvim') "Prevent errors when using standard vim
"     autocmd VimEnter * AutoreadLoop
" endif

" auto-change vim dir to current file dir
" set autochdir

" Quicker update for reloading from disk changes
set updatetime=1000

" Formatting
set ts=4 sw=4 expandtab
set mouse=a
set so=999
set number relativenumber
set cursorline
set termguicolors

nmap <leader>n :call ChangeLineNumbering()<CR>

""" Functions
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Toggle between line numbers and no line numbers
" https://www.reddit.com/r/neovim/comments/k2bk0o/toggle_linenumbering/
function! ChangeLineNumbering()
    if &number == 0 && &relativenumber == 0
        setlocal number! relativenumber!
    else
        setlocal number! relativenumber!
    endif
endfunction


""" Autocmd

" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
" autoformat on save
" autocmd BufWrite * if @% != 'Config' && @% != 'makefile' | :Autoformat
map <leader>F :Autoformat<CR>

" Run Autoformat on Leader-F
nnoremap <leader>F :Autoformat<CR>

if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

""" Misc
command -nargs=1 Sr vimgrep /<args>/gj `git ls-files`

""" Themeing
syntax on
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
hi typescriptCase guibg=none guifg=orange
hi typescriptBranch guibg=none guifg=violet
hi typescriptStatementKeyword guibg=none guifg=#ff8080
hi typescriptClassKeyword guibg=none guifg=lightblue
hi typescriptClassExtends guibg=none guifg=lightgreen
hi typescriptArrowFuncArg guibg=none guifg=lightred
hi typescriptAliasKeyword guibg=none guifg=orange
hi typescriptInterfaceKeyword guibg=none guifg=silver
hi typescriptInterfaceExtends guibg=none guifg=yellow

hi jsonQuote guifg=lightgrey
hi javaClassDecl guibg=none guifg=pink
hi javaExternal guibg=none guifg=cyan
hi javaExceptions guibg=none guifg=orange
hi javaStatement guibg=none guifg=pink
hi javaMethodDecl guibg=none guifg=brown
hi javaBranch guibg=none guifg=cyan
hi javaRepeat guibg=none guifg=violet
hi jsDot guifg=white

hi shComment guifg=#dddddd
hi javaTypedef guifg=cyan
hi javaType guifg=#91d0e3

hi vimCommand guibg=bg guifg=pink
hi vimMap guibg=bg guifg=violet
hi vimFgBgAttrib guibg=bg
hi vimEnvvar guibg=bgk guifg=gold
