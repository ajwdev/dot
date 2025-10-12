return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>;",  nil,                              desc = "AI/Claude Code" },
      { "<leader>;c", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>;f", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>;r", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>;C", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>;m", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>;b", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>;s", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>;s",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>;a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>;d", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    }
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
