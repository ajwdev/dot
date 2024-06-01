return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    priority = 20,
    init = function()
      vim.o.timeout = true
    end,
    opts = {},
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    -- config = function()
    --   vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
    --   vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
    --   vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
    --   vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
    --   vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
    --   -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    -- end
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
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
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        SAFETY = { icon = " ", color = "warning" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]], -- pattern or table of patterns, used for highlighting (vim regex)
        keyword = "bg", -- "fg" or "bg" or empty
      },
    }
  },
  --  {
  --    "folke/flash.nvim",
  --    event = "VeryLazy",
  --    opts = {},
  --    -- stylua: ignore
  --    keys = {
  --      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --    },
  -- },
  --  TODO Super annoying at the moment. Review more later
  --  {
  --    "folke/flash.nvim",
  --    event = "VeryLazy",
  --    opts = {},
  --    -- stylua: ignore
  --    keys = {
  --      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --    },
  -- },
  -- Make this lazy as it will get required by the LSP configuration
  { 'folke/neodev.nvim', lazy = true },
}
