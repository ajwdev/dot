return {
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = { 'hrsh7th/nvim-cmp' }
      },
    },
    build = "make install_jsregexp",
    config = function()
      require 'config.luasnip'
    end,
  },
}
