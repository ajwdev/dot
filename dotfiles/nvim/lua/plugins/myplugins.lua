-- Local custom plugins
return {
  -- Google Slides controller
  {
    dir = vim.fn.expand("~/dot/dotfiles/nvim/lua/local/slides"),
    name = "slides",
    config = function()
      require("slides").setup({
        next_key = "<leader>s<Right>",
        prev_key = "<leader>s<Left>",
      })
    end,
  },

  -- Add more local plugins here as needed
  -- {
  --   dir = vim.fn.expand("~/dot/dotfiles/nvim/lua/local/another-plugin"),
  --   name = "another-plugin",
  --   config = function()
  --     require('another-plugin').setup()
  --   end,
  -- },
}
