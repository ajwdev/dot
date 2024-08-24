-- Page up and down, re-centering the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Indent with tab/shift-tab and reselect
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

 -- Yank to end of line
vim.keymap.set("n", "Y", "yg_")

vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null")

-- Typing is hard
vim.keymap.set("c", "Qall", "qall")
vim.keymap.set("c", "Wall", "wall")
