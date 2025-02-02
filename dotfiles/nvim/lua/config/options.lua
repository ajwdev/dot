-- Many of these options are lifted/inspired by the configs I've read below:
--
-- https://github.com/tjdevries/config_manager/blob/66d5262e1d142bfde5ebc19ba120ae86cb16d1d9/xdg_config/nvim/plugin/options.lua. 
-- https://github.com/wbthomason/dotfiles/blob/a6379cb7a1e50654247ecce5344f76ad90970418/dot_config/nvim/lua/config/options.lua


local opt = vim.opt

-- Force 24bit color
opt.termguicolors = true

-- Enable mouse in almost all modes
opt.mouse = "a"

-- bells (both audidle and visual) are annoying
opt.belloff = "all"

opt.timeout = true
-- Timeout for mapper sequeneces
opt.timeoutlen = 350
-- Smaller updatetime for CursorHold & CursorHoldI
opt.updatetime = 300

-- Use a global status line
opt.laststatus = 3

-- Always show sign column
opt.signcolumn = "yes"

-- Always keep 5 lines below the cursor
opt.scrolloff = 5
-- Always keep at least column to left and right of cursor
opt.sidescrolloff = 1

-- highlight search
opt.showmatch = true
-- show search matches as you type
opt.incsearch = true

-- Dont word wrap
opt.wrap = false
-- Every wrapped line will continue visually indented (same amount of
-- space as the beginning of that line), thus preserving horizontal blocks
-- of text.
opt.breakindent = true

-- Show last command in the last line of the screen
opt.showcmd = true
-- Better display for messages
-- TODO Can we go back to 1 if we use popups for diagnostics and stuff?
-- opt.cmdheight = 1

-- Show line numbers. When relative numbering is enabled, this will show the current line number instead of 0
opt.number = true
-- Show incrementing/decrementing line from the cursor position
opt.relativenumber = true

-- Prefer vertical splits open to the right
opt.splitright = true
-- Prefer splits open to the bottom
opt.splitbelow = true
-- Make splits equal sized
opt.equalalways = true

-- Display a background line where the cursor is
opt.cursorline = true

-- Don't add two spaces when joining lines. I've never written text this way.
opt.joinspaces = false

-- Copy ident from the current line when starting a new one
-- TODO Review all indent options and how they play with Treesitter
opt.autoindent = true
-- Uses spaces for tabs instead of actual tab characters
opt.expandtab = true
-- Default to two spaces for tabs. Note that these may get overwritten by
-- autocmds on a per file basis
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

opt.textwidth = 78

-- TODO Review these
opt.wildmode = "list:longest,full"
opt.wildignore = { "*.swp", "*.bak", "*.pyc", "*.class" }
opt.wildoptions = "pum"

-- Toggle paste mode with f2.
-- TODO Not needed as much in Neovim. Maybe we can remove this?
-- opt.pastetoggle="<F2>"

-- Options for completion mode in-order:
-- * Display popup menu even for a single completion item
-- * Do not insert text for match until its selected
-- * Do not select a match in the menu, force the user to
opt.completeopt = "menuone,noinsert,noselect"
-- don't give |ins-completion-menu| messages.
opt.shortmess = opt.shortmess + "c"

-- See :h fo-table for options. Default is "tcqj". Some options are
-- unnessecarily removed for commentary purposes.
opt.formatoptions = opt.formatoptions
  - "t" -- Don't auto format text by text width (only comments)
  + "c" -- ^^
  - "o" -- O and o should not continue comments
  + "r" -- But newlines should
  + "j" -- Auto-remove comments when joining lines
  -- + "n" -- When formatting text, recognize numbered lists and wrap accordingly
  -- + "1" -- Dont break lines after a one character word
  -- + "p" -- Dont break lines at single spaces that follow periods

-- Enable spelling
opt.spell = true
-- Only spellcheck designated areas such as comments. These are typically defined by Treesitter queries
opt.spelloptions = "noplainbuffer"

