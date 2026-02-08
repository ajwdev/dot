return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      picker = {
        enabled = true,
        layout = {
          preset = "telescope",
          reverse = true,
        },
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },

      -- TODO Look into these
      scope = { enabled = false }, -- REVIEW
      notifier = { enabled = false }, -- Maybe?
      -- input = { enabled = true },    -- TODO Might want this
      dim = { enabled = true }, -- TODO Repalce twight
      -- layout = { enabled = false },
      --
      styles = {
        input = {
          relative = "cursor",
          row = -3,
        },
      },
    },
    keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },

      -- Picker keybindings (replacing Telescope)
      {
        "<leader>T",
        function()
          Snacks.picker.pick()
        end,
        desc = "Snacks Picker",
      },

      -- File pickers
      {
        "<C-P>",
        function()
          Snacks.picker.files()
        end,
        desc = "Picker: Find files",
      },
      {
        "<leader>b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Picker: Show buffers",
      },

      -- Search
      {
        "<leader>rg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Picker: Live grep",
      },
      {
        "<leader>H",
        function()
          Snacks.picker.help()
        end,
        desc = "Picker: Help tags",
      },

      -- Treesitter symbols (document level)
      {
        "<leader>ts",
        function()
          Snacks.picker.treesitter()
        end,
        desc = "Picker: Treesitter symbols",
      },

      -- LSP pickers
      {
        "<leader>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Picker: LSP document symbols",
      },
      {
        "<leader>lws",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Picker: LSP workspace symbols",
      },
      {
        "<leader>lr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "Picker: LSP references",
      },
      {
        "<leader>li",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Picker: LSP implementations",
      },
      {
        "<leader>ld",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Picker: LSP definitions",
      },
      {
        "<leader>lD",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Picker: LSP type definitions",
      },
      {
        "<leader>lci",
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = "Picker: LSP calls incoming",
      },
      {
        "<leader>lco",
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = "Picker: LSP calls outgoing",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Replace the standard input dialog. Makes LSP rename nicer
          vim.ui.input = Snacks.input.input

          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          -- vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          -- Snacks.toggle.diagnostics():map("<leader>ud")
          -- Snacks.toggle.line_number():map("<leader>ul")
          -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          -- "<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          -- Snacks.toggle.inlay_hints():map("<leader>uh")
          -- Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<F4>")
        end,
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "folke/trouble.nvim",
    opts = {
      open_no_results = true,
    },
    cmd = "Trouble",
    -- Integrate with snacks.nvim picker (from docs)
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      {
        "]d",
        function()
          require("trouble").next()
        end,
        desc = "Next Item (Trouble)",
      },
      {
        "[d",
        function()
          require("trouble").prev()
        end,
        desc = "Previous Item (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      -- LSP things
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=true win.position=bottom<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xr",
        "<cmd>Trouble lsp_references toggle focus=true win.position=bottom<cr>",
        desc = "LSP References (Trouble)",
      },
      {
        "<leader>xd",
        "<cmd>Trouble lsp_definitions toggle focus=true win.position=bottom<cr>",
        desc = "LSP Definitions (Trouble)",
      },
      {
        "<leader>xD",
        "<cmd>Trouble lsp_type_definitions toggle focus=true win.position=bottom<cr>",
        desc = "LSP Type definitions (Trouble)",
      },
      {
        "<leader>xi",
        "<cmd>Trouble lsp_implementations toggle focus=true win.position=bottom<cr>",
        desc = "LSP Implementations (Trouble)",
      },
      {
        "<leader>xci",
        "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=bottom<cr>",
        desc = "LSP Incoming Calls (Trouble)",
      },
      {
        "<leader>xco",
        "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=bottom<cr>",
        desc = "LSP Outgoing Calls (Trouble)",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        SAFETY = { icon = " ", color = "warning" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]], -- pattern or table of patterns, used for highlighting (vim regex)
        keyword = "bg", -- "fg" or "bg" or empty
      },
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
}
