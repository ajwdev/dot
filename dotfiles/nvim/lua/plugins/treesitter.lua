return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "c",
          "cpp",
          "go",
          "lua",
          "rust",
          "javascript",
          "typescript",
          "python",
          "ruby",
          "html",
          "css",
          -- TODO Check in on this one, it may have an upstream bug
          --"markdown",
          "racket",
          "sql",
          "bash",
          "make",
          "comment",
          "yaml",
          "json",
          "toml",
          "vim",
          "vimdoc",
        },

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        incremental_selection = {
          enable = true,

          keymaps = {
            init_selection = "gnn",
            -- Unlikely to use this bindings with the textsubjects plugin, but
            -- why not?
            node_incremental = "grn",
            scope_incremental = "grs",
            node_decremental = "grN",
          },
        },

        indent = {
          enable = true
        },
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          enable = true,

          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["as"] = "@scope.outer",
              ["is"] = "@scope.inner",
            },

            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = 'V',     -- blockwise
              -- ['@class.outer'] = '<c-v>', -- blockwise
            },
          },

          -- mappings to swap the node under the cursor with the next or previous one, like function parameters or arguments.
          swap = {
            enable = true,

            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },

          -- mappings to jump to the next or previous text object. This is similar to ]m, [m, ]M, [M Neovim's mappings to jump to the next or previous function.
          move = {
            enable = true,

            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]r"] = { query = "@x.return", desc = "Next return statement", query_group = "locals" },
              ["]R"] = { query = "@x.returnargs", desc = "Next return value(s)", query_group = "locals" },
              ["]f"] = "@function.outer",
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

              ["]s"] = { query = "@scope", desc = "Next scope" },

              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[r"] = { query = "@x.return", desc = "Previous return statement", query_group = "locals" },
              ["[R"] = { query = "@x.returnargs", desc = "Previous return value(s)", query_group = "locals" },
              ["[s"] = { query = "@scope", desc = "Previous scope" },
              ["[f"] = "@function.outer",
              ["[C"] = { query = "@class.outer", desc = "Previous class start" },
              ["[o"] = "@loop.*",
              ["[I"] = "@import",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            },
          },
        },
      })

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-refactor',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        refactor = {
          smart_rename = {
            enable = true,
            keymaps = { smart_rename = '<leader>Rn' },
          },
          highlight_definitions = { enable = false },
        },
      })
    end,
  },

  {
    'RRethy/nvim-treesitter-endwise',
    event = 'InsertEnter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        endwise = {
          enable = true,
        },
      })
    end,
  },

  {
    'RRethy/nvim-treesitter-textsubjects',
    event = 'BufReadPost',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
          },
        },
      })
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPost',
    url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      require('rainbow-delimiters.setup').setup({
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          -- lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      })
    end
  },
}
