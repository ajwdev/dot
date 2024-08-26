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
      local open_with_trouble = require("trouble.sources.telescope").open
      -- Use this to add more results without clearing the trouble list
      -- local add_to_trouble = require("trouble.sources.telescope").add

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
              ['<c-d>'] = require('telescope.actions').delete_buffer,
              ["<c-t>"] = open_with_trouble,
            },
            i = {
              -- Close telescope window
              ["<esc>"] = actions.close,
              -- Delete buffer
              ['<C-d>'] = actions.delete_buffer,
              -- Clear prompt
              ["<C-u>"] = false,
              ["<c-t>"] = open_with_trouble,
            },
          },
        }
      }


      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>T', '<cmd>Telescope<cr>', { silent = true, desc = "Telescope" })
      vim.keymap.set('n', '<C-P>', builtin.find_files, { desc = "Telescope: Find files" })
      vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = "Telescope: Help tags" })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Telescope: Show buffers" })
      vim.keymap.set('n', '<leader>rg', builtin.live_grep, { desc = "Telescope: Live grep" })
      vim.keymap.set('n', '<leader>ts', builtin.treesitter, { desc = "Telescope: Tressitter" })
      vim.keymap.set('n', '<leader>ls', function()
        builtin.lsp_document_symbols({symbol_width=0.4, symbol_type_width = 0.1})
      end, { desc = "Telescope: LSP document symbols" })
      vim.keymap.set('n', '<leader>lws', function()
        builtin.lsp_dynamic_workspace_symbols({fname_width = 0.5,symbol_width=0.4, symbol_type_width = 0.1})
      end, { desc = "Telescope: LSP document symbols" })
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

