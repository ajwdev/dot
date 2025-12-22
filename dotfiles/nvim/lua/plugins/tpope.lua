-- Load Tim Pope's plugins earlier as many of them represent default "base"
-- keymaps. Plugins after the fact may override certain settings (ex:
-- unimpaired). Lazy.nvim default priority is 50.
local priority = 500

return {
  {
    "tpope/vim-fugitive",
    event = "BufReadPost",
    config = function()
      -- TODO Use real Lua APIs here

      -- Keymaps
      vim.cmd([[
    nmap <leader>gl :G log -- %<cr>
    nmap <leader>gs :G<cr>
    nmap <leader>ge :Gedit<cr>
    nmap <leader>gd :Gdiff<cr>
    nmap <leader>gc :Gcommit<cr>
    cnoremap gw Gwrite
    ]])

      -- Autocmds
      vim.cmd([[
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
    ]])
    end,
  },

  {
    -- Automatically detects sets things like tabstop, spaces, etc
    "tpope/vim-sleuth",
    priority = priority,
  },

  {
    -- Sensible Vim settings everyone can agree. Most of these are probably
    -- set by default in Neovim.
    -- TODO Examine this plugin and see if it's still useful
    "tpope/vim-sensible",
    priority = priority,
    lazy = false,
  },

  {
    -- Bunch of useful mappings for navigation
    "tpope/vim-unimpaired",
    dependencies = "tpope/vim-repeat",
    priority = priority,
  },

  {
    -- The OG surround plugin
    "tpope/vim-surround",
    priority = priority,
  },

  {
    -- Spell check handling and fancy search/replace. Consider removing
    "tpope/vim-abolish",
    cmd = { "Subvert", "Abolish" },
  },
}
