local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

ls.add_snippets("all", {
    s("hl", {
        t("hello "), i(1, "first name"), t(" "), i(2, "last name"), i(0, "")
    })
})
