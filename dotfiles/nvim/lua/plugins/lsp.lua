return {
  --
  -- LSP config
  --
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Adds a lightblub in the line number column when an LSP code action is available
      'kosayoda/nvim-lightbulb',
      -- Inlay hints. Review this in the future as Neovim is getting it natively
      'simrat39/inlay-hints.nvim',
      {
        'vxpm/ferris.nvim',
        opts = {},
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
      'hrsh7th/cmp-nvim-lua',
      'windwp/nvim-autopairs',
      'onsails/lspkind.nvim',
      'ray-x/lsp_signature.nvim',
      'lukas-reineke/cmp-under-comparator',
      --'hrsh7th/cmp-cmdline',
      --'hrsh7th/cmp-nvim-lsp-document-symbol',
    },
    config = function()
      require 'config.cmp'
    end,
    event = 'InsertEnter',
  },
}
