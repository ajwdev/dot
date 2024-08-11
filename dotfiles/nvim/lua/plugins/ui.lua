-- Plugins related to controlling the main editor appearance
return {
  {
    'RRethy/nvim-base16',
    lazy = false, -- Make its loaded during startup
    priority = 1000, -- Make sure its loaded before everything else
    -- config = function ()
    --   -- TODO Probably a better way to do this
    --   vim.cmd "colorscheme base16-decaf"
    --   -- Make the line number standout so its easier to find
    --   vim.cmd "hi CursorLineNR guifg=yellow"
    -- end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function ()
      -- XXX HACK HALP
      -- If I load base16-decaf first, my entire editor goes to gray scale.
      -- Presumably because of some weird treesitter changes. However, if I
      -- first load tokyonight, then immediately switch, it works fine.
      -- :shrug:
      vim.cmd "colorscheme tokyonight"
      vim.cmd "colorscheme base16-decaf"
      -- Make the line number standout so its easier to find
      vim.cmd "hi CursorLineNR guifg=yellow"
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      -- TODO I'd like the filename in the winbar to show a path instead of basename
      require('lualine').setup {
        sections = {
          lualine_c = {
            {
              'filename',
              -- Absolute path with tilde for home directory
              path = 3,
            }
          }
        }

      }
    end
  },
  {
    'MunifTanjim/nui.nvim',
    lazy = true
  },
  {
    'folke/twilight.nvim',
    keys = {
      { "<F5>", "<cmd>Twilight<cr>", desc = "Toggle Twightlight" },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
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
}
