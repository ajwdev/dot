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
        config = function()
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
      'saghen/blink.cmp',
    },
    config = function()
      require 'config.lsp'
    end,
  },

  ----
  ---- Completion
  ----
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'giuxtaposition/blink-cmp-copilot',
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',

        ['<C-space>'] = { 'select_and_accept', 'show', 'show_documentation' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = {
          auto_show = true, auto_show_delay_ms = 500
        },
        accept = {
          auto_brackets = { enabled = true },
        },
        ghost_text = { enabled = true },
        menu = {
          auto_show = true,

          draw = {
            treesitter = { 'lsp' },
            -- nvim-cmp style menu
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          }
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = ''
                item.kind_name = 'Copilot'
              end
              return items
            end,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },

      -- Use a preset for snippets, check the snippets documentation for more information
      snippets = { preset = 'luasnip' },

      -- Experimental signature help support
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  }
}
