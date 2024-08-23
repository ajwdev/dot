return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        }
      }

      local actions = require("telescope.actions")
      require("telescope").setup{
        defaults = {
          mappings = {
            n = {
              ['<c-d>'] = require('telescope.actions').delete_buffer
            },
            i = {
              -- Close telescope window
              ["<esc>"] = actions.close,
              -- Delete buffer
              ['<C-d>'] = actions.delete_buffer,
              -- Clear prompt
              ["<C-u>"] = false,
            },
          },
        }
      }


      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<C-P>', builtin.find_files, {})
      vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader><leader>h', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>Td', builtin.lsp_dynamic_workspace_symbols, {})
      vim.keymap.set('c', 'Rg<cr>', builtin.live_grep, {})
    end,
  },
}

