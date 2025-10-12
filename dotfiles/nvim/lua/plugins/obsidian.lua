return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Documents/obsidian*/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Documents/obsidian*/*.md",
    },
    cmd = "Obsidian",
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian/personal",
        },
        {
          name = "work",
          path = "~/Documents/obsidian_work",
        }
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Daily",
        -- Optional, if you want to change the date format for daily notes.
        -- date_format = "%Y-%m-%d"
      },
    },
  },
}
