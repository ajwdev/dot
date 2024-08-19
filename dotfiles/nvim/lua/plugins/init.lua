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
      ft.set("lua", {"-- %s", "--[[ %s ]]--"})
    end,
  },

  -- Tpope's
  -- TODO I think most of these defaults are also defaults in Neovim. Review and remove
  'tpope/vim-sensible',
  -- 'tpope/vim-jdaddy', -- JSON text objects and pretty printing
  'tpope/vim-repeat',
  'tpope/vim-surround',

  'tpope/vim-unimpaired',
  'tpope/vim-abolish',

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

  --  TODO Super annoying at the moment. Review more later
 --  {
 --    "folke/flash.nvim",
 --    event = "VeryLazy",
 --    opts = {},
 --    -- stylua: ignore
 --    keys = {
 --      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
 --      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
 --      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
 --      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
 --      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
 --    },
 -- },

  --
  -- Productivity
  --
  {
    'yorickpeterse/nvim-window',
    url = 'https://gitlab.com/yorickpeterse/nvim-window.git',
    config = function()
      vim.keymap.set('n', "<leader>w", require('nvim-window').pick, {silent=true})
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<F4>", mode = "n", function ()
        require("oil").toggle_float()
      end, { desc = "Open parent directory" } }
    },
  },

  {
    'rgroli/other.nvim',
    config = function ()
      require("other-nvim").setup({
        showMissingFiles  = false,
        mappings = {
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
        style = {
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
      vim.keymap.set("c", "AV<CR>", "<cmd>OtherVSplit<CR>", {silent = true})
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function ()
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
      -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "bg",
        pattern = [[<(KEYWORDS).*:?\s]], -- TODO Still doesnt quite work like I want
      },
    }
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = "markdown",
    build = 'cd app && yarn install',
  },

  {
    'mbbill/undotree',
    cmd = "UndotreeToggle",
    init = function ()
      vim.keymap.set('n', "<F3>", "<cmd>UndotreeToggle<cr>", {silent=true})
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
  -- Make this lazy as it will get required by the LSP configuration
  { 'folke/neodev.nvim', lazy = true },

  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require('incline').setup()
    end
  },

  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    priority = 20,
    init = function ()
      vim.o.timeout = true
    end,
    opts = {},
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
