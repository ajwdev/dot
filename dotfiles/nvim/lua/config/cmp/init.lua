-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local myutil = require("config.util")
local WindowStyle = myutil.WindowStyle

local has_words_before = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s')
end

cmp.setup({
  enabled = function()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")
    if buftype == "prompt" then
      return false
    end

    -- disable completion in comments
    -- local context = require 'cmp.config.context'
    -- -- keep command mode completion enabled when cursor is in a comment
    -- if vim.api.nvim_get_mode().mode == 'c' then
    --   return true
    -- else
    --   return not context.in_treesitter_capture("comment")
    --     and not context.in_syntax_group("Comment")
    -- end
    return true
  end,

  -- Don't give the LSP preference on what completion source should be
  -- selected. This frequently causes the wrong thing to be selected even
  -- though theres an obvious first choice. See the following issue:
  -- https://github.com/hrsh7th/nvim-cmp/issues/1762
  preselect = cmp.PreselectMode.None,

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require "cmp-under-comparator".under,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  mapping = {
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    -- Switch to only showing snippet sources
    ['<C-s>'] = cmp.mapping.complete({
      config = {
        sources = {
          { name = "luasnip"}
        }
      }
    }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-Space>'] = cmp.mapping.confirm({
      -- TODO I think i'd prefer replace
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      -- elseif has_words_before() then
      --   cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
      with_text = true,
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
      })
    })
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  window = {
    completion = WindowStyle,
    documentation = WindowStyle,
  },

  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- },

  -- Order of sources matters (highest priority -> lowest)
  sources = {
    { name = "copilot", group_index = 2 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'path' },
	-- Don't show buffer sources until I hit five characters
    { name = 'buffer', keyword_length = 5 },
  },
})

require "config.cmp.autopairs"
