return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = "BufReadPost",
    build = ":TSUpdate",
    config = function()
      -- Register custom mangle parser (path-based, pre-generated grammar)
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").mangle = {
            install_info = {
              path = "~/src/github.com/ajwdev/tree-sitter-mangle",
              generate = false,
            },
            filetype = "mangle",
          }
        end,
      })
      vim.filetype.add({ extension = { mangle = "mangle", mg = "mangle" } })

      require("nvim-treesitter").install({
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
        "markdown",
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
      })

      -- Enable highlighting and indentation per filetype
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local buf = event.buf
          pcall(vim.treesitter.start, buf)
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Select textobjects
      for _, mode in ipairs({ "x", "o" }) do
        vim.keymap.set(mode, "af", function() select.select_textobject("@function.outer", "textobjects") end)
        vim.keymap.set(mode, "if", function() select.select_textobject("@function.inner", "textobjects") end)
        vim.keymap.set(mode, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
        vim.keymap.set(mode, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
        vim.keymap.set(mode, "as", function() select.select_textobject("@scope.outer", "textobjects") end)
        vim.keymap.set(mode, "is", function() select.select_textobject("@scope.inner", "textobjects") end)
      end

      -- Swap
      vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
      vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end)

      -- Move: goto next start
      vim.keymap.set({ "n", "x", "o" }, "]r", function() move.goto_next_start("@x.return", "locals") end, { desc = "Next return statement" })
      vim.keymap.set({ "n", "x", "o" }, "]R", function() move.goto_next_start("@x.returnargs", "locals") end, { desc = "Next return value(s)" })
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "]o", function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end, { desc = "Next scope" })

      -- Move: goto next end
      vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_end("@class.outer", "textobjects") end)

      -- Move: goto previous start
      vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous_start("@x.import.last", "locals") end, { desc = "Last import statement" })
      vim.keymap.set({ "n", "x", "o" }, "[r", function() move.goto_previous_start("@x.return", "locals") end, { desc = "Previous return statement" })
      vim.keymap.set({ "n", "x", "o" }, "[R", function() move.goto_previous_start("@x.returnargs", "locals") end, { desc = "Previous return value(s)" })
      vim.keymap.set({ "n", "x", "o" }, "[s", function() move.goto_previous_start("@local.scope", "locals") end, { desc = "Previous scope" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class start" })
      vim.keymap.set({ "n", "x", "o" }, "[o", function() move.goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[I", function() move.goto_previous_start("@import", "textobjects") end)

      -- Move: goto previous end
      vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)

      -- Move: goto next/previous (whichever is closer)
      vim.keymap.set({ "n", "x", "o" }, "]b", function() move.goto_next("@conditional.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[b", function() move.goto_previous("@conditional.outer", "textobjects") end)

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter-endwise").setup()
    end,
  },

  -- TODO: nvim-treesitter-textsubjects is broken with the new nvim-treesitter main branch
  -- (it requires the removed `nvim-treesitter.query` module and appears unmaintained).
  -- Previously provided: . (smart select), ; (container outer), i; (container inner).
  -- Potential replacement: daliusd/incr.nvim for node-by-node expand selection.
  -- {
  --   "RRethy/nvim-treesitter-textsubjects",
  --   event = "BufReadPost",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = function()
  --     require("nvim-treesitter-textsubjects").configure({
  --       prev_selection = ",",
  --       keymaps = {
  --         ["."] = "textsubjects-smart",
  --         [";"] = "textsubjects-container-outer",
  --         ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
  --       },
  --     })
  --   end,
  -- },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          -- lua = 'rainbow-blocks',
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
}
