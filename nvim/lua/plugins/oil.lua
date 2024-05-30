return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        columns = { "icon" },
        keymaps = {
          ["<C-v>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
      }
      -- -- Open parent directory in current window
      -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      --
      -- -- Open parent directory in floating window
      -- vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
    keys = {
      { "<F4>", mode = "n", function ()
        require("oil").toggle_float()
      end, { desc = "Open parent directory" } }
    },
  },
}
