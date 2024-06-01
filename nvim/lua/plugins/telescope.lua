-- Much of this is borrowed from tjdevries' config
-- https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope.lua

local data = assert(vim.fn.stdpath "data") --[[@as string]]

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      -- "kkharji/sqlite.lua",
    },
    config = function()
      require('telescope').setup {
        extensions = {
          wrap_results = true,
          fzf = {
            -- fuzzy = true,                   -- false will only do exact matching
            -- override_generic_sorter = true, -- override the generic sorter
            -- override_file_sorter = true,    -- override the file sorter
            -- case_mode = "smart_case",       -- or "ignore_case" or "respect_case". The default case_mode is "smart_case"
          },

          -- history = {
          --   path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
          --   limit = 100,
          -- },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        }
      }

      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              -- Close telescope window
              ["<esc>"] = actions.close,
              -- Clear prompt
              ["<C-u>"] = false,
            },
          },
        }
      }


      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<C-P>', builtin.find_files, {})
      vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader><leader>h', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>Td', builtin.lsp_dynamic_workspace_symbols, {})
      vim.keymap.set('c', 'Rg<cr>', builtin.live_grep, {})
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
    end,
  },
}
