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
      vim.keymap.set('n', '<C-P>', builtin.find_files, { desc = "Telescope: Find files" })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Telescope: Show buffers" })
      vim.keymap.set('n', '<leader>rg', builtin.live_grep, { desc = "Telescope: Live grep" })
      vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = "Telescope: Help tags" })
      vim.keymap.set('n', '<leader>ts', builtin.treesitter, { desc = "Telescope: Tressitter" })
      vim.keymap.set('n', '<leader>lws', builtin.lsp_dynamic_workspace_symbols, { desc = "Telescope: LSP dynamic workspace symbols" })
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = "Telescope: LSP document symbols" })
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = "Telescope: LSP references" })
      vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, { desc = "Telescope: LSP implementations" })
      vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = "Telescope: LSP definitions" })
      vim.keymap.set('n', '<leader>lD', builtin.lsp_type_definitions, { desc = "Telescope: LSP type definitions" })
      vim.keymap.set('n', '<leader>lci', builtin.lsp_incoming_calls, { desc = "Telescope: LSP calls incoming" })
      vim.keymap.set('n', '<leader>lco', builtin.lsp_outgoing_calls, { desc = "Telescope: LSP calls outgoing" })
      vim.keymap.set('c', 'Rg<cr>', builtin.live_grep, {})
    end,
  },
}

