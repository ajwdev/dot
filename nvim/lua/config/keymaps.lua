-- TODO Make this native lua and/or tie them into lazy loading keymaps

vim.cmd [[
cmap Qall qall
cmap Wall wall
cmap Vsp vsp
cmap w!! w !sudo tee % >/dev/null

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

" Disable search highlights
nmap <leader>h <ESC>:noh<CR>

vmap <Tab> >gv
vmap <S-Tab> <gv

nnoremap <F3> :UndotreeToggle<CR>
nnoremap <F4> :NERDTreeToggle<CR>
nnoremap <F5> :Twilight<CR>
nnoremap <F9> :lua require("dapui").toggle()<CR>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
noremap <leader>b <ESC>:Buffers<CR>
noremap <leader>f <ESC>:Files<CR>
nmap <C-P> :Files<CR>
]]
