set ts=4 sw=4 sts=4 noet

let g:go_def_mapping_enabled = 0
let g:go_fmt_autosave = 0
let g:go_textobj_enabled = 0
let g:go_metalinter_autosave = 0
let g:go_list_type = "quickfix"
let g:go_gopls_enabled = 0

" Go declarations in vim-go
" XXX Autocommands are probably unnessecary here, but I think I'm going to
" nuke this plugin anyhow
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
