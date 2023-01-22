local ok, luasnip = pcall(require, 'luasnip')
if not ok then
    return
end

-- some shorthands...
local snip = luasnip.snippet
-- local node = ls.snippet_node
-- local text = ls.text_node
-- local insert = ls.insert_node
local func = luasnip.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node

local date = function() return {os.date('%Y-%m-%d')} end

luasnip.add_snippets(nil, {
    all = {
        snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
        }, {
            func(date, {}),
        }),
    },
})
