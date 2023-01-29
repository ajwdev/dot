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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick keymap, set early in the process, to open a development environment
-- for the Lua configs. Useful when there is an error that is going to need
-- to be debugged.
vim.keymap.set("n", "<leader>D", "<cmd>tabnew | tcd ~/.config/nvim | e init.lua<CR>", {silent=true})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup("config.plugins", {
  -- TODO Doesnt work yet, but OK with that for now
  --defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
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
