local luasnip = require('luasnip')

-- NOTE I dont love these variable names, but those are the defaults used
-- by the snip_env defaults. Might as well be consistent :shrug:
-- https://github.com/L3MON4D3/LuaSnip/blob/0de6d9c6f88565ad9163d61823b1c1e91be33a52/lua/luasnip/default_config.lua#L20
local s = luasnip.snippet
local f = luasnip.function_node

local date = function() return {os.date('%Y-%m-%d')} end

luasnip.add_snippets(nil, {
    all = {
        s({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
        }, {
            f(date, {}),
        }),
    },
})

local curdir = debug.getinfo(1).source:match("@?(.*/)")
require("luasnip.loaders.from_lua").load({ paths = curdir .. "snippets" })
