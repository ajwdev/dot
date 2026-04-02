vim.cmd [[
set ts=4 sw=4 sts=4 noet
]]

local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]t", function()
  move.goto_next_start("@x.realtarget", "locals")
end, { buffer = true, desc = "Next target" })
vim.keymap.set({ "n", "x", "o" }, "[t", function()
  move.goto_previous_start("@x.realtarget", "locals")
end, { buffer = true, desc = "Previous target" })
