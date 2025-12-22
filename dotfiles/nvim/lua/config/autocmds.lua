-- TODO Make these all native lua (or at least where it makes sense)
--
-- Probably a hack :shrug:
local nvim_create_augroup, nvim_create_autocmd = vim.api.nvim_create_augroup, vim.api.nvim_create_autocmd

--
-- NOTE Make sure that we're only clearing autocmds in groups or else Lazy stops functioning.
--

-- Toggle between relative line numbers and regular line numbering when going to/from insert mode.
vim.cmd([[
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
]])

vim.cmd([[
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 400 }
augroup end
]])

-- show cursor line only in active window
local cursorGrp = nvim_create_augroup("CursorLine", { clear = true })
nvim_create_autocmd({ "InsertLeave", "WinEnter" }, { pattern = "*", command = "set cursorline", group = cursorGrp })
nvim_create_autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })

--
-- Windowing related stuff
--
local windowGrp = nvim_create_augroup("WindowMagic", { clear = true })
-- windows to close with "q"
nvim_create_autocmd("FileType", {
  pattern = { "help", "startuptime", "qf", "lspinfo", "fugitiveblame" },
  command = [[nnoremap <buffer><silent> q :close<CR>]],
  group = windowGrp,
})
nvim_create_autocmd("FileType", {
  pattern = "man",
  command = "nnoremap <buffer><silent> q :quit<CR>",
  group = windowGrp,
})
nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
  desc = "Moves the window for provided file types to the far right (i.e ctrl+w L)",
})
nvim_create_autocmd("FileType", {
  pattern = "gitcommit,markdown,text",
  command = "setlocal spell",
  desc = "Spell check in certain types of files",
})

-- Close FZF term window with "ESC"
vim.cmd([[
augroup Fzf
  autocmd!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
augroup END
]])

-- This is needed to load the tilt_lsp
vim.cmd([[
autocmd BufRead Tiltfile setf=tiltfile
]])

vim.cmd([[
autocmd BufRead *kubeconfig set ft=yaml
]])
