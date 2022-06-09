if !has('nvim')

  set ttymouse=xterm2
  " set termguicolors
endif

let encoding_loaded=0
if !exists("encoding_loaded")
  " This can only be set once so wrap it to avoid errors
  " when sourcing this file
  set encoding=utf-8
  let encoding_loaded=1
endif


filetype off

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Lokaltog/vim-easymotion'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-jdaddy' " JSON text objects and pretty printing
Plug 'mbbill/undotree'
Plug 'yssl/QFEnter'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Neovim 0.5
" https://crispgm.com/page/neovim-is-overpowering.html
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'

" New stuff
Plug 'folke/which-key.nvim'
Plug 'gfanto/fzf-lsp.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-path'

" Productivity
Plug 'folke/twilight.nvim'
" Plug 'nvim-orgmode/orgmode'

Plug 'windwp/nvim-autopairs'
Plug 'p00f/nvim-ts-rainbow'
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'stevearc/dressing.nvim'

Plug 'simrat39/rust-tools.nvim'

" Syntax
Plug 'lifepillar/pgsql.vim', { 'for': 'sql' }
Plug 'uber/prototool', { 'rtp':'vim/prototool' }
Plug 'vim-ruby/vim-ruby', { 'for': 'rust' }
Plug 'tpope/vim-rbenv', { 'for': 'ruby' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" Plug 'treycordova/rustpeg.vim', { 'for': 'rust' }
Plug 'qnighy/lalrpop.vim'
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'wlangstroth/vim-racket'
Plug 'cappyzawa/starlark.vim'
" Plug 'maverickg/stan.vim'
" Plug 'hashivim/vim-terraform'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'

" Colorschemes / Appearance
Plug 'bling/vim-airline'
Plug 'RRethy/nvim-base16'
call plug#end()

set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class
set history=1000        " remember more commands and search history
set undolevels=100      " use many muchos levels of undo
"set title               " change the terminal's title
set visualbell          " don't beep
set noerrorbells        " don't beep

" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Syntax highlighting stuff
syntax on
filetype plugin indent on
set pastetoggle=<F2>

" Default tab spacing should be 2 spaces
set autoindent
set tabstop=2       " 2 spaces for tabs
set shiftwidth=2    " ^^
set softtabstop=2
set expandtab

" With line wrapping on, keep the previous indent level
if has('breakindent')
  set breakindent
endif

set timeoutlen=350  " In milliseconds

" Dont increment numbers as octal
set nrformats-=octal

set signcolumn=yes
set laststatus=2
set scrolloff=5
set sidescrolloff=1
set backspace=indent,eol,start
set showmatch       " highlight search
set incsearch       " show search matches as you type
set showcmd
set nowrap          " Dont wrap lines
set number          " Show line numbers
set ruler
set hidden
set autoread
set autowrite
set splitright      " Make new split-windows open to the right

" Enable mouse in all modes
set mouse=a

" Update swap file after 20 characters
set updatecount=20

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Common typos
iabbrev tihs this
iabbrev jsut just

colorscheme base16-decaf

let g:airline_powerline_fonts = 1

"let mapleader = "\<space>"
" https://www.reddit.com/r/vim/comments/1vdrxg/space_is_a_big_key_what_do_you_map_it_to/cerq68d
map <space> <leader>


" LUA
lua require('config')

" Treesitter based folding
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()


" FZF mappings
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
noremap <leader>b <ESC>:Buffers<CR>
noremap <leader>f <ESC>:Files<CR>
nmap <C-P> :Files<CR>

" Allow escape to close the buffer
if has("nvim")
augroup Fzf
  autocmd!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
augroup END
endif
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Consider running this to clear all autocmds on reload
" autocmd!

" Autindent, shift two characters, expand tabs to spaces
autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber set ai ts=2 sw=2 sts=2 et
autocmd FileType sh,shell,rust,javascript set ai ts=4 sw=4 sts=4 et
autocmd Filetype c,python set ai ts=4 sw=4 sts=4 noet
autocmd Filetype go set ai ts=4 sw=4 sts=4 noet

" Remove whitespace on save
autocmd BufWritePre *.sql,*.py,*.sh,*.rb,*.go,*.rs,*.cpp,*.hpp,*.c,*.h,*.proto :%s/\s\+$//e

" For Windows Wix package files
autocmd BufRead *.wx[sil].erb set ft=xml

" Autoclose Fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" Add '..' mapping for moving back to parent directory in Fugitive Git browser
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Only for Neovim. Automatically switch to insert mode when
" entering a terminal buffer
" autocmd BufEnter term://* :startinsert

" Enable spell checking when making Git commit messages
autocmd FileType gitcommit setlocal spell

" Open help vertically
autocmd FileType help wincmd L

autocmd! BufWritePost .vimrc source ~/.vimrc

nnoremap <F3> :UndotreeToggle<CR>
nnoremap <F4> :NERDTreeToggle<CR>
nnoremap <F5> :Twilight<CR>


" " vim-go
" let g:go_def_mapping_enabled = 0
" let g:go_fmt_autosave = 1
" let g:go_metalinter_autosave = 0
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
" let g:go_list_type = "quickfix"
" let g:go_doc_keywordprg_enabled = 0
" let g:go_gopls_options = ['-remote=auto']

let g:go_def_mapping_enabled = 0
let g:go_fmt_autosave = 0
let g:go_textobj_enabled = 0
let g:go_metalinter_autosave = 0
let g:go_list_type = "quickfix"
let g:go_gopls_enabled = 0

" Go declarations in vim-go
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
" autocmd FileType go nmap <Leader>i <Plug>(go-info)
autocmd FileType go nmap <Leader>r :GoRun<CR>
" autocmd FileType go map <leader>Gd :GoDecls<CR>
" autocmd FileType go map <leader>GD :GoDeclsDir<CR>
autocmd FileType go map <leader>Gb :GoBuild<CR>
autocmd FileType go map <leader>Ga :GoAlternate<CR>
" autocmd FileType go map <leader>Gi :GoImpl<CR>
autocmd FileType go map <leader>Gp :GoPlay<CR>
autocmd FileType go map <leader>Gt :GoAddTags<CR>

" Command mode
cmap Set set
cmap Qall qall
cmap Wall wall
cmap Vsp vsp
cmap w!! w !sudo tee % >/dev/null
" Vim's crypto is broken so dont let me use it (even accidentally). Its
" already disabled in Neovim.
" https://github.com/vim/vim/issues/638#issuecomment-186163441
cnoremap X x

" Yank to end of line
map Y yg_

" Fugitive mappings
nmap <leader>gb :Gbrowse<cr>
nmap <leader>gl :Glog -- %<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>ge :Gedit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gc :Gcommit<cr>
cnoremap gw Gwrite

" Set alternate complete key
"imap <C-Space> <C-N>

" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
noremap <leader><tab><tab> <ESC> :Tabularize /
noremap <leader><tab>:     <ESC> :Tabularize /:\zs<CR>
noremap <leader><tab>=     <ESC> :Tabularize /=<CR>


" Disable search highlights
nmap <leader>h <ESC>:noh<CR>

" Easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f2)
"omap t <Plug>(easymotion-bd-tl)
map  <leader>j <Plug>(easymotion-j)
map  <leader>k <Plug>(easymotion-k)
map  <leader>/ <Plug>(easymotion-sn)
omap <leader>/ <Plug>(easymotion-tn)

map  <Leader>t <Plug>(easymotion-t)
map  <Leader>T <Plug>(easymotion-T)
map  <Leader>f <Plug>(easymotion-f)
map  <Leader>F <Plug>(easymotion-F)


vmap <Tab> >gv
vmap <S-Tab> <gv

" if has('nvim')
"   tnoremap <Esc> <C-\><C-n>
"   nmap <leader>] <ESC>:tabnew<CR>:terminal<CR>
" endif

" TODO http://vimcasts.org/episodes/using-external-filter-commands-to-reformat-html/
" TODO https://youtu.be/aHm36-na4-4?t=720

augroup Binary
  au!
  au BufReadPre  *.exe let &bin=1
  au BufReadPost *.exe if &bin | %!xxd
  au BufReadPost *.exe set ft=xxd | endif
  au BufWritePre *.exe if &bin | %!xxd -r
  au BufWritePre *.exe endif
  au BufWritePost *.exe if &bin | %!xxd
  au BufWritePost *.exe set nomod | endif
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end

" Show diagnostic popup on cursor hold
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
" nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>

" " Code navigation shortcuts
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> <c-w>gd    <cmd>vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>

" Search visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Copy current filename to unnamed register
nmap <leader>cp :let @" = expand("%")<cr>

" :TSHighlightCapturesUnderCursor
" use with :call SynGroup() and then :hi <first word>
" function! SynGroup()                                                            
"     let l:s = synID(line('.'), col('.'), 1)                                       
"     echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
" endfun

let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']
