vim.cmd [[
set ts=4 sw=4 sts=4 noet
]]

require('nvim-treesitter.configs').setup({
  textobjects = {
    move = {
      goto_next_start = {
        ["]t"] = { query = "@x.realtarget", desc = "Next target", query_group = "locals" },
      },
      goto_previous_start = {
        ["[t"] = { query = "@x.realtarget", desc = "Next target", query_group = "locals" },
      },
    },
  },
})
