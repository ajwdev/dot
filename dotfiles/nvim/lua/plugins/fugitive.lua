return {
  'tpope/vim-fugitive',
  event = 'BufReadPost',
  config = function()
    -- TODO Use real Lua APIs here

    -- Keymaps
    vim.cmd [[
    nmap <leader>gb :Gbrowse<cr>
    nmap <leader>gl :Glog -- %<cr>
    nmap <leader>gs :Gstatus<cr>
    nmap <leader>ge :Gedit<cr>
    nmap <leader>gd :Gdiff<cr>
    nmap <leader>gc :Gcommit<cr>
    cnoremap gw Gwrite
    ]]

    -- Autocmds
    vim.cmd [[
    augroup fugitiveBuffers
    autocmd!
    " Autoclose Fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete

    " Add '..' mapping for moving back to parent directory in Fugitive Git browser
    autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif
    augroup END
    ]]
  end
}
