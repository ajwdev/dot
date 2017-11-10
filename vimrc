if !has('nvim')
  set nocompatible
  set ttyfast
  set ttymouse=xterm2
endif

let encoding_loaded=0
if !exists("encoding_loaded")
  " This can only be set once so wrap it to avoid errors
  " when sourcing this file
  set encoding=utf-8
  let encoding_loaded=1
endif

" Dont totally remember why I do this but I think its related
" to previously using patheogen
runtime macros/matchit.vim

filetype off

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Lokaltog/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'
Plug 'rizzatti/dash.vim'
Plug 'rizzatti/funcoo.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-jdaddy' " JSON text objects and pretty printing
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'w0rp/ale'
Plug 'mbbill/undotree'
Plug 'yssl/QFEnter'

Plug 'kana/vim-textobj-indent'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'

" Syntax
Plug 'vim-ruby/vim-ruby', { 'for': 'rust' }
Plug 'tpope/vim-rbenv', { 'for': 'ruby' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'treycordova/rustpeg.vim', { 'for': 'rust' }
Plug 'hashivim/vim-terraform'
Plug 'derekwyatt/vim-scala'
Plug 'ensime/ensime-vim'

" Colorschemes / Appearance
Plug 'bling/vim-airline'
Plug 'kien/rainbow_parentheses.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/zenburn'
call plug#end()

set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class
set history=1000        " remember more commands and search history
set undolevels=100      " use many muchos levels of undo
"set title               " change the terminal's title
set visualbell          " don't beep
set noerrorbells        " don't beep

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

set laststatus=2
set scrolloff=5
set sidescrolloff=1
set backspace=indent,eol,start
set showmatch       " highlight search
set incsearch       " show search matches as you type
set wildmenu
set showcmd
set nowrap          " Dont wrap lines
set number          " Show line numbers
set ruler           
set hidden
set autoread
set noautowrite
set splitright      " Make new split-windows open to the right

" Enable mouse in all modes
set mouse=a

" Update swap file after 20 characters
set updatecount=20

" Common typos
iabbrev tihs this
iabbrev jsut just

set t_Co=256  " 256 terminal colors

if has('gui_running') 
  "set background=dark
  colorscheme solarized 
  set cursorline
  set guioptions-=T " Remove toolbar
  set guifont=Meslo\ LG\ M\ for\ Powerline:h14
  set belloff=all
endif

let g:airline_powerline_fonts = 1

"let mapleader = "\<space>"
" https://www.reddit.com/r/vim/comments/1vdrxg/space_is_a_big_key_what_do_you_map_it_to/cerq68d
map <space> <leader>


" Consider running this to clear all autocmds on reload
" autocmd!

" Autindent, shift two characters, expand tabs to spaces
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai ts=2 sw=2 sts=2 et
autocmd FileType shell,rust set ai ts=4 sw=4 sts=4 et
autocmd Filetype c,python set ai ts=4 sw=4 sts=4 noet
" Autindent, shift 8 characters, use real tabs
"autocmd Filetype go set ai ts=8 sw=8 sts=8 noet
autocmd Filetype go set ai ts=4 sw=4 sts=4 noet

" Remove whitespace on save
autocmd BufWritePre *.py,*.sh,*.rb,*.go :%s/\s\+$//e
autocmd BufRead .git/COMMIT_EDITMSG set spell

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
autocmd BufEnter term://* :startinsert

" Enable spell checking when making Git commit messages
autocmd FileType gitcommit setlocal spell

" Open help vertically
autocmd FileType help wincmd L

autocmd! BufWritePost .vimrc source ~/.vimrc

let g:linter_toggle = 1
function! ToggleLinting()
  let g:linter_toggle = !g:linter_toggle 
  " Close and clear the quickfix
  cclose
  cexpr []

  let g:go_metalinter_autosave = g:linter_toggle
  " TODO Add Ruby, Rust, and Javascript linters
endfunction

nnoremap <F3> :call ToggleLinting()<CR>
nnoremap <F4> :NERDTreeToggle<CR>

" Syntastic
" Check files when I open them
let g:syntastic_check_on_open = 1
" Dont automatically open the localwindow but do automatically close it
" when the errors are gone
let g:syntastic_auto_loc_list = 2
" Drop Syntastic errors in the localwindow. This can conflict
" with other plugins but I do not believe it does in my setup.
let g:syntastic_always_populate_loc_list = 1

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_ruby_exec='/Users/andrew/.rbenv/shims/ruby'

" vim-go
let g:go_fmt_autosave = 1
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

" Go declarations in vim-go
map <leader>Gd :GoDecls<CR>
map <leader>GD :GoDeclsDir<CR>
map <leader>Gb :GoBuild<CR>
map <leader>Ga :GoAlternate<CR>
map <leader>Gi :GoImpl<CR>
map <leader>Gp :GoPlay<CR>


" Command mode
cmap Set set
cmap w!! w !sudo tee % >/dev/null
" Vim's crypto is broken so dont let me use it (even accidentally). Its
" already disabled in Neovim.
" https://github.com/vim/vim/issues/638#issuecomment-186163441
cnoremap X x

" Yank to end of line
map Y yg_

" Ack
map <leader>a :Ack 

" Dash
" TODO Do something different on non-osx
map <leader>d :Dash!<CR>

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

" CtrlP stuff
noremap <leader>b <ESC>:CtrlPBuffer<CR>
noremap <leader>m <ESC>:CtrlPMRU<CR>

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


" Disable arrow keys
"inoremap  <Up>     <NOP>
"inoremap  <Down>   <NOP>
"inoremap  <Left>   <NOP>
"inoremap  <Right>  <NOP>
"noremap   <Up>     <NOP>
"noremap   <Down>   <NOP>
"noremap   <Left>   <NOP>
"noremap   <Right>  <NOP>

vmap <Tab> >gv
vmap <S-Tab> <gv

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  nmap <leader>] <ESC>:tabnew<CR>:terminal<CR>
endif

" TODO http://vimcasts.org/episodes/using-external-filter-commands-to-reformat-html/
" TODO https://youtu.be/aHm36-na4-4?t=720
