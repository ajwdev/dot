return {
  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   config = true,
  --   keys = {
  --     { "<leader>;", nil, desc = "AI/Claude Code" },
  --     { "<leader>;c", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>;f", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>;r", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>;C", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>;m", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  --     { "<leader>;b", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>;s", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {
  --       "<leader>;s",
  --       "<cmd>ClaudeCodeTreeAdd<cr>",
  --       desc = "Add file",
  --       ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  --     },
  --     -- Diff management
  --     { "<leader>;a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>;d", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },
  -- TODO(ajw) Do I still want this?
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      {
        "<leader>;p",
        function()
          local client = require("copilot.client")
          if client.is_disabled() then
            require("copilot.command").enable()
            vim.notify("Copilot enabled", vim.log.levels.INFO)
          else
            require("copilot.command").disable()
            vim.notify("Copilot disabled", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Copilot",
      },
    },
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
    end,
  },
  {
    "pablopunk/pi.nvim",
    config = function()
      require("pi").setup({
        -- model = "openrouter/free",
        -- system_prompt = "You are a helpful assistant.",
        -- append_system_prompt = "Always respond concisely.",
        -- context = {
        --   max_bytes = 24000,
        --   ask = {
        --     surrounding_lines = 80,
        --   },
        --   selection = {
        --     surrounding_lines = 40,
        --   },
        --   diagnostics = {
        --     enabled = false,
        --   },
        -- },
        -- skills = true,
        -- extensions = true,
      })
    end,
    keys = {
      { "<leader>;", ":PiAsk<CR>", desc = "Ask pi" },
      { "<leader>;", ":PiAskSelection<CR>", mode = "v", desc = "Ask pi (selection)" },
    },
  },
}
