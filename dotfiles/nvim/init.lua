--[[
-- Neovim configuration using Lazy package manager.
--
-- Most plugin configuration will live in the lua/plugin.lua module. For
-- components that are simple, the "config" closure in the plugin spec
-- should suffice. For larger things like completion, LSP, etc, there
-- are modules for each under lua/config/<component>. Basic options,
-- keymaps, and autocmds live in modules underneath lua/config/*.
--
-- Finally, remaining configuration will live in after/* and are
-- automatically sourced by Neovim.
--]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick keymap, set early in the process, to open a development environment
-- for the Lua configs. Useful when there is an error that is going to need
-- to be debugged.
vim.keymap.set("n", "<leader>D", "<cmd>tabnew | tcd ~/.config/nvim | e init.lua<CR>", {silent=true})

require("lazy").setup("plugins", {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        -- The only plugin out the defaults I still like
        -- This can probably be done with Treesitter now. Look into it
        -- 'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

require("config.options")
-- TODO Should these go in after/plugin instead?
require("config.keymaps")
require("config.autocmds")
