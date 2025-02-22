return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    event = "InsertEnter",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      -- debug = true, -- Enable debugging
    },
    keys = {
      {
        "<leader>C",
        "<cmd>CopilotChatToggle<cr>",
        desc = "Toggle Copilot Chat",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end
  },
}
