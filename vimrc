set nocompatible
set ttyfast

runtime macros/matchit.vim

filetype off
"call pathogen#infect()
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'Lokaltog/vim-easymotion'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'godlygeek/tabular'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'jpalardy/vim-slime'
Plugin 'kana/vim-textobj-user'
Plugin 'kien/ctrlp.vim'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'pangloss/vim-javascript'
Plugin 'rizzatti/dash.vim'
Plugin 'rizzatti/funcoo.vim'
Plugin 'rking/vim-detailed'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'

" This throws the following error:
" Vundle error: Name collision for Plugin rking/vim-detailed. Plugin " rking/vim-detailed previously used the name "vim-detailed". Skipping Plugin " rking/vim-detailed.
"Plugin 'rking/vim-detailed'
Plugin 'wombat'
Plugin 'molokai'
Plugin 'mayansmoke'

call vundle#end()

let g:airline_powerline_fonts = 1
let mapleader = "\<space>"

set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class
set history=1000        " remember more commands and search history
set undolevels=100      " use many muchos levels of undo
"set title               " change the terminal's title
set visualbell          " don't beep
set noerrorbells        " don't beep
set encoding=utf-8

" Syntax highlighting stuff
syntax on
"filetype on
filetype plugin indent on
set pastetoggle=<F2>

" Default tab spacing should be 2 spaces
set autoindent
set tabstop=2       " 2 spaces for tabs
set shiftwidth=2    " ^^
set softtabstop=2
set expandtab

set timeoutlen=250

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
set shell=/bin/bash " Set to bash instead of zsh for compatiblity

" Common typos
iabbrev teh the
iabbrev tihs this
iabbrev jsut just

set t_Co=256
if has('gui_running') 
"  set background=dark
"  colorscheme solarized
  colorscheme molokai 
  set cursorline
  set guioptions-=T " Remove toolbar
  "set guioptions-=r " Remove scrollbars
  "set guioptions-=l 
  "set guifont=Monaco:h11.0
  "set columns=150
  "set lines=55
endif

"function SetWrap()
"  setlocal wrap linebreak nolist
"  set virtualedit=
"  setlocal display+=lastline
"  noremap <buffer> <silent> <Up>   gk
"  noremap <buffer> <silent> <Down> gj
"  noremap <buffer> <silent> <Home> g<Home>
"  noremap <buffer> <silent> <End>  g<End>
"  inoremap <buffer> <silent> <Up>   <C-o>gk
"  inoremap <buffer> <silent> <Down> <C-o>gj
"  inoremap <buffer> <silent> <Home> <C-o>g<Home>
"  inoremap <buffer> <silent> <End>  <C-o>g<End>
"endfunction

"augroup default
  "autocmd!
  " Autindent, shift two characters, expand tabs to spaces
  autocmd FileType shell,ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai ts=2 sw=2 sts=2 et
  autocmd Filetype c set ai ts=4 sw=4 sts=4 et
  " Autindent, shift 8 characters, use real tabs
  "autocmd Filetype go set ai ts=8 sw=8 sts=8 noet
  autocmd Filetype go set ai ts=4 sw=4 sts=4 noet
  
  " Remove whitespace on save
  autocmd BufWritePre *.py,*.sh,*.rb,*.go :%s/\s\+$//e
  autocmd BufRead .git/COMMIT_EDITMSG set spell
  
  autocmd! BufWritePost .vimrc source ~/.vimrc
"augroup END

nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>
" Enable word processor style word wrapping
"nnoremap <F4> :call SetWrap()<CR>

" Command mode with the ;
cmap w!! w !sudo tee % >/dev/null

" Ack
map <leader>a :Ack 

" Fugitive mappings
nmap <leader>gb :Gbrowse<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>ge :Gedit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gc :Gcommit<cr>

" Set alternate complete key
imap <C-Space> <C-N>

" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
noremap <leader><tab> <ESC>:Tabularize /
noremap <leader><tab><tab> <ESC>:Tabularize /:\zs<CR>

" Vimgeeks shizzle
set updatecount=20

" Disable arrow keys
"inoremap  <Up>     <NOP>
"inoremap  <Down>   <NOP>
"inoremap  <Left>   <NOP>
"inoremap  <Right>  <NOP>
"noremap   <Up>     <NOP>
"noremap   <Down>   <NOP>
"noremap   <Left>   <NOP>
"noremap   <Right>  <NOP>

