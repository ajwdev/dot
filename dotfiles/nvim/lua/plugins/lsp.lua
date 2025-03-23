return {
  --
  -- LSP config
  --
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPost',
    dependencies = {
      -- Adds a lightblub in the line number column when an LSP code action is available
      {
        'kosayoda/nvim-lightbulb',
        config =function ()
          require('nvim-lightbulb').setup {
            code_lenses = true,
            autocmd = { enabled = true },
            sign = { enabled = false },
            virtual_text = { enabled = true }
          }
        end
      },
      {
        'vxpm/ferris.nvim',
        opts = {},
      },
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require 'config.lsp'
    end,
  },

  --
  -- Completion
  --
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Highlight/bold the current argument of the completion
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- Add completion sources from text in the same document
      'hrsh7th/cmp-buffer',
      -- Completions from LSP servers
      'hrsh7th/cmp-nvim-lsp',
      -- Completions from filesystem paths
      'hrsh7th/cmp-path',
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
  },
}
