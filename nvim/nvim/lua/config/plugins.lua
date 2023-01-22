-- Pattern borrowed from https://github.com/wbthomason/dotfiles/blob/main/dot_config/nvim/lua/plugins.lua
--
-- Lazy plugin manager is being used: https://github.com/folke/lazy.nvim

return {
  --
  -- colorschemes / appearance
  --
  {
    'RRethy/nvim-base16',
    lazy = false, -- Make its loaded during startup
    priority = 1000, -- Make sure its loaded before everything else
    config = function ()
      -- TODO Probably a better way to do this
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
      require('lualine').setup {}
    end
  },

  --
  -- LSP config
  --
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Adds a lightblub in the line number column when an LSP code action is available
      'kosayoda/nvim-lightbulb',
      'simrat39/inlay-hints.nvim',
      {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
      },
    },
    config = function()
      require 'config.lsp'
    end,
    event = 'BufReadPost',
  },

  --
  -- Completion
  --
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Highlight/bold the current argument of the completion
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- Add completion sources from text in the same document
      'hrsh7th/cmp-buffer',
      -- Completions from LSP servers
      'hrsh7th/cmp-nvim-lsp',
      -- Completions from filesystem paths
      'hrsh7th/cmp-path',
      -- Completions for the Neovim Lua API (also see neodev)
      -- 'hrsh7th/cmp-nvim-lua',
      'folke/neodev.nvim',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'windwp/nvim-autopairs',
      'onsails/lspkind.nvim',
      'ray-x/lsp_signature.nvim',
      --'lukas-reineke/cmp-under-comparator',
      --'hrsh7th/cmp-cmdline',
      --'hrsh7th/cmp-nvim-lsp-document-symbol',
    },
    config = function()
      require 'config.cmp'
      require 'config.snippets'
    end,
    event = 'InsertEnter',
  },

  --
  -- Treesitter
  --
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
      'RRethy/nvim-treesitter-endwise',
      'p00f/nvim-ts-rainbow',
    },
    build = ':TSUpdate',
    event = 'BufReadPost',
    config = function()
      require 'config.treesitter'
    end,
  },

  {
    'numToStr/Comment.nvim',
    --event = 'User ActuallyEditing', too
    event = 'BufReadPost',
    config = function()
      require('Comment').setup {}

      local ft = require('Comment.ft')
      -- I want an extra space after the comment delimiter in Lua
      ft.set("lua", {"-- %s", "--[[ %s ]]--"})
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'BufReadPost',
    config = function()
      require('fidget').setup {
        sources = {
          ['null-ls'] = { ignore = true },
        },
      }
    end,
  },

  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end,
    event = 'BufReadPost',
  },


  -- Tpope's
  {
    'tpope/vim-fugitive',
    event = 'BufReadPost',
  },
  -- TODO I think most of these defaults are also defaults in Neovim. Review and remove
  {
    'tpope/vim-sensible',
    lazy = false,
  },
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-abolish',
  'tpope/vim-speeddating',
  'tpope/vim-jdaddy', -- JSON text objects and pretty printing

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
    'folke/twilight.nvim',
    event = "VeryLazy"
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  {
    'anuvyklack/hydra.nvim',
    config = function()
      require 'config.hydra'
    end,
  },

  {
    'scrooloose/nerdtree',
    cmd = "NERDTreeToggle",
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = "markdown",
    build = 'cd app && yarn install',
  },

  'mbbill/undotree',
  'yssl/QFEnter',
  'jbyuki/venn.nvim',

  -- FZF (TODO Replace with telescope?)
  {
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = ':fzf#install()'
      },
    },
  },

  -- Finally, syntax things
  { 'lifepillar/pgsql.vim', ft = 'sql' },
  { 'fatih/vim-go', ft = 'go' },
  { 'rust-lang/rust.vim',ft = 'rust' },
  { 'qnighy/lalrpop.vim', ft = "lalrpop" },
  { 'wlangstroth/vim-racket', ft = "racket" },
  -- TODO What should the type be here?
  { 'cappyzawa/starlark.vim', ft = "starlark" },
  { 'ziglang/zig.vim', ft = "zig" },
  -- { 'uber/prototool', { 'rtp':'vim/prototool' }
  -- { 'vim-ruby/vim-ruby', ft = 'ruby' }
  -- { 'tpope/vim-rbenv', ft = 'ruby' }
  -- { 'pangloss/vim-javascript' }
  -- { 'leafgarland/typescript-vim' }
  -- { 'maxmellon/vim-jsx-pretty' }
  -- { 'peitalin/vim-jsx-typescript' }
}
