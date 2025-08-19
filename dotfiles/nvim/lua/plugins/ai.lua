return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()

      local claudeGrp = vim.api.nvim_create_augroup("Claude", { clear = true })
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          if string.find(buf_name, "claude-") then
            -- Auto-unlist claude-code buffer
            vim.bo.buflisted = false
            vim.keymap.set("n", "q", "<cmd>ClaudeCode<cr>", {
              buffer = 0,
              desc = "Toggle Claude Code Buffer",
            })
            vim.keymap.set("n", "<ESC>", "i<A-ESC><ESC>", {
              buffer = 0,
            })
            vim.keymap.set("n", "O", "a", {
              buffer = 0,
            })
            vim.keymap.set("n", "o", "a", {
              buffer = 0,
            })
          end
        end,
        group = claudeGrp,
      })
    end
  },
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
        mode = { "n", "v" },
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
