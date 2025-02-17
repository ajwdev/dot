return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },

      -- TODO Look into these
      scope = { enabled = false },    -- REVIEW
      notifier = { enabled = false }, -- Maybe?
      input = { enabled = false },    -- TODO Might want this
      -- scratch = { enabled = true },
      dim = { enabled = true }, -- TODO Repalce twight
      -- layout = { enabled = false },
    },
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          -- vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          -- Snacks.toggle.diagnostics():map("<leader>ud")
          -- Snacks.toggle.line_number():map("<leader>ul")
          -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          -- "<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          -- Snacks.toggle.inlay_hints():map("<leader>uh")
          -- Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<F4>")
        end,
      })
    end,
  },

  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "folke/trouble.nvim",
    opts = {
      open_no_results = true,
    },
    cmd = "Trouble",
    keys = {
      {
        "]d",
        function() require("trouble").next() end,
        desc = "Next Item (Trouble)",
      },
      {
        "[d",
        function() require("trouble").prev() end,
        desc = "Previous Item (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      -- LSP things
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=true win.position=bottom<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xr",
        "<cmd>Trouble lsp_references toggle focus=true win.position=bottom<cr>",
        desc = "LSP References (Trouble)",
      },
      {
        "<leader>xd",
        "<cmd>Trouble lsp_definitions toggle focus=true win.position=bottom<cr>",
        desc = "LSP Definitions (Trouble)",
      },
      {
        "<leader>xD",
        "<cmd>Trouble lsp_type_definitions toggle focus=true win.position=bottom<cr>",
        desc = "LSP Type definitions (Trouble)",
      },
      {
        "<leader>xi",
        "<cmd>Trouble lsp_implementations toggle focus=true win.position=bottom<cr>",
        desc = "LSP Implementations (Trouble)",
      },
      {
        "<leader>xci",
        "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=bottom<cr>",
        desc = "LSP Incoming Calls (Trouble)",
      },
      {
        "<leader>xco",
        "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=bottom<cr>",
        desc = "LSP Outgoing Calls (Trouble)",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = 'BufReadPost',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        SAFETY = { icon = " ", color = "warning" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]], -- pattern or table of patterns, used for highlighting (vim regex)
        keyword = "bg",                   -- "fg" or "bg" or empty
      },
    }
  },
}
