return {
  {
    'tpope/vim-fugitive',
    event = 'BufReadPost',
    config = function()
      -- TODO Use real Lua APIs here

      -- Keymaps
      vim.cmd [[
    nmap <leader>gl :G log -- %<cr>
    nmap <leader>gs :G<cr>
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
    autocmd User FugitiveTree,FugitiveCommit,FugitiveTag nnoremap <buffer> q :bd<CR>

    " Add '..' mapping for moving back to parent directory in Fugitive Git browser
    " autocmd User fugitive
    "   \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    "   \   nnoremap <buffer> ^ :edit %:h<CR> |
    "   \ endif
    augroup END
    ]]
    end
  },
  'tpope/vim-sleuth',
  'tpope/vim-sensible',
  -- 'tpope/vim-jdaddy', -- JSON text objects and pretty printing
  'tpope/vim-repeat',
  'tpope/vim-surround',

  'tpope/vim-unimpaired',
  'tpope/vim-abolish',
}
