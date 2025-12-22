return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    event = "BufReadPost",
    config = function()
      require("mini.icons").setup({})

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- Add animated scope lines. Useful for python, yaml, etc that are
      -- whitespace sensitive
      require("mini.indentscope").setup()
      -- ... however, I find it distracting in languages where I don't care.
      -- So disable for all filetypes except python and yaml.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local allowed_filetypes = { "python", "yaml" }
          if not vim.tbl_contains(allowed_filetypes, ft) then
            vim.b[args.buf].miniindentscope_disable = true
          end
        end,
      })

      -- Keymaps to align text
      require("mini.align").setup()
    end,
  },
}
