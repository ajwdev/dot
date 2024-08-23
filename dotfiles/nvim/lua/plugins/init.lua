-- local myutil = require("config.util")
-- local WindowStyle = myutil.WindowStyle

return {
  'nvim-lua/plenary.nvim',

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    config = function()
      require('Comment').setup {}

      local ft = require('Comment.ft')
      -- I want an extra space after the comment delimiter in Lua
      ft.set("lua", { "-- %s", "--[[ %s ]]--" })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end,
  },

  {
    "Wansmer/treesj",
    keys = {
      { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },

  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sr",
        function() require("ssr").open() end,
        mode = { "n", "x" },
        desc = "Structural Search and Replace",
      },
    },
  },

  --
  -- Productivity
  --
  {
    'yorickpeterse/nvim-window',
    url = 'https://gitlab.com/yorickpeterse/nvim-window.git',
    config = function()
      vim.keymap.set('n', "<leader>w", require('nvim-window').pick, { silent = true })
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        columns = { "icon" },
        keymaps = {
          ["<C-v>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
      }
    end,
    keys = {
      {
        "<F4>",
        mode = "n",
        function()
          require("oil").toggle_float()
        end,
        { desc = "Open parent directory" }
      }
    },
  },

  {
    'rgroli/other.nvim',
    config = function()
      require("other-nvim").setup({
        showMissingFiles = false,
        mappings         = {
          -- builtin mappings
          "rails",
          "golang",
          -- custom mapping
          -- {
          --   pattern = "/path/to/file/src/app/(.*)/.*.ext$",
          --   target = "/path/to/file/src/view/%1/",
          --   transformer = "lowercase"
          -- }
        },
        -- transformers = {
        --   -- defining a custom transformer
        --   lowercase = function (inputString)
        --     return inputString:lower()
        --   end
        -- },
        style            = {
          -- How the plugin paints its window borders
          -- Allowed values are none, single, double, rounded, solid and shadow
          -- border = WindowStyle.boder,
          border = 'rounded',

          -- -- Column seperator for the window
          -- seperator = "|",
          --
          -- -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
          -- width = 0.7,
          --
          -- -- min height in rows.
          -- -- when more columns are needed this value is extended automatically
          -- minHeight = 2
        },
      })
      vim.keymap.set("c", "AV<CR>", "<cmd>OtherVSplit<CR>", { silent = true })
    end
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = "markdown",
    build = 'cd app && yarn install',
  },

  {
    'mbbill/undotree',
    cmd = "UndotreeToggle",
    init = function()
      vim.keymap.set('n', "<F3>", "<cmd>UndotreeToggle<cr>", { silent = true })
    end
  },

  {
    'yssl/QFEnter',
    event = "BufEnter quickfix"
  },

  {
    'jbyuki/venn.nvim',
    cmd = "VBox",
  },

  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require('incline').setup()
    end
  },

  {
    'glacambre/firenvim',

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end
  },
}
