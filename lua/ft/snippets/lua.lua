local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", { s("fl", fmt([[
for {}, {} in {}({}) do
    {}
end
]], {

    i(1, "index"),
    i(2, "value"),
    c(3, { t("paris"), t("ipairs") }),
    i(4, "over"),
    i(0, "")
}
)) })

ls.add_snippets("all", {
    s("if", fmt([[
        if {} then
            {}
        end 
    ]], {i(1, "condition"), i(0, "body")}))
})
