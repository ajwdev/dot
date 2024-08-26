return {
  {
    'preservim/nerdtree',
    dependencies = {
      -- Adjust color/syntax of open files
      'tiagofumo/vim-nerdtree-syntax-highlight',
      -- Delete buffers from NERDTree
      'PhilRunninger/nerdtree-buffer-ops',
    },
    event = { 'BufReadPost', 'BufNew' },
    config = function()
      vim.keymap.set('n', "<F2>", "::NERDTreeToggleVCS<cr>", { silent = true })
    end,
    init = function()
      vim.cmd [[
      let g:NERDTreeQuitOnOpen = 1

      " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
        autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
            \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
      ]]
    end
  },
}
