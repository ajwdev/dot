-- Plugins related to controlling the main editor appearance
return {
  {
    'RRethy/nvim-base16',
    lazy = false,    -- Make its loaded during startup
    priority = 1000, -- Make sure its loaded before everything else
    config = function()
      -- TODO Probably a better way to do this
      vim.cmd "colorscheme base16-eighties"
      -- Make the line number standout so its easier to find
      vim.cmd "hi CursorLineNR guifg=yellow"
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = {
      'kyazdani42/nvim-web-devicons',
      'AndreM222/copilot-lualine',
    },
    config = function()
      -- TODO I'd like the filename in the winbar to show a path instead of basename
      require('lualine').setup {
        sections = {
          lualine_b = { 'copilot', 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              -- Absolute path with tilde for home directory
              path = 3,
            }
          },
        }

      }
    end
  },

  {
    'j-hui/fidget.nvim',
    event = 'BufReadPost',
    tag = 'legacy',
    config = function()
      require('fidget').setup {
        sources = {
          ['null-ls'] = { ignore = true },
        },
      }
    end,
  },

  -- Floating statusline in the top right
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require('incline').setup()
    end
  },
}
