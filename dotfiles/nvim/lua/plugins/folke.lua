return {
  {
    'folke/twilight.nvim',
    keys = {
      { "<F4>", "<cmd>Twilight<cr>", desc = "Toggle Twightlight" },
    },
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
