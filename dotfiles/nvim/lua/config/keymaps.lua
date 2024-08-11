-- TODO Make this native lua and/or tie them into lazy loading keymaps
--
-- Page up and down, re-centering the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- In visual, allow us to move the highlighted block of tax
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Indent with tab/shift-tab and reselect
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

 -- Yank to end of line
vim.keymap.set("n", "Y", "yg_")

vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null")

-- Typing is hard
vim.keymap.set("c", "Qall", "qall")
vim.keymap.set("c", "Wall", "wall")
