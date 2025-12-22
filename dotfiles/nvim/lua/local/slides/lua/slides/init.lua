-- Google Slides Control from Neovim
-- Control Google Slides presentations from within Neovim using AppleScript

local M = {}

-- Get the directory where this script is located
local function get_script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  local lua_dir = str:match("(.*/)")
  -- Scripts are in ../../scripts/ relative to lua/slides/init.lua
  return lua_dir .. "../../scripts/"
end

local script_dir = get_script_dir()

function M.next_slide(count)
  count = count or 1
  vim.fn.system(script_dir .. "next-slide.scpt " .. count)
end

function M.prev_slide(count)
  count = count or 1
  vim.fn.system(script_dir .. "prev-slide.scpt " .. count)
end

function M.setup(opts)
  opts = opts or {}

  -- Default keybindings (can be overridden)
  local next_key = opts.next_key or "<leader><Right>"
  local prev_key = opts.prev_key or "<leader><Left>"

  -- Set up keybindings
  vim.keymap.set("n", next_key, function()
    M.next_slide(vim.v.count1)
  end, {
    desc = "Next slide",
    silent = true,
  })

  vim.keymap.set("n", prev_key, function()
    M.prev_slide(vim.v.count1)
  end, {
    desc = "Previous slide",
    silent = true,
  })

  -- Slide tag navigation keymaps for Git
  vim.keymap.set("n", "<leader>st", function()
    vim.cmd("!git next-tag")
    vim.cmd("bufdo e!")
  end, { desc = "Next slide tag" })

  vim.keymap.set("n", "<leader>sT", function()
    vim.cmd("!git prev-tag")
    vim.cmd("bufdo e!")
  end, { desc = "Previous slide tag" })

  print("Google Slides control loaded. Use " .. next_key .. " (next) and " .. prev_key .. " (previous)")
end

return M
