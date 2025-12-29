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


local function generate_parameter_doc(args)
    local function_params = args[1][1]
    local result = {}
    for value in string.gmatch(function_params, "[^,]+") do
        table.insert(result, string.format("---@param %s type", value))
    end
    table.insert(result, "---@return type")
    return result
end

ls.add_snippets("all", {
    s("lf", fmt([[
        {}
        local function {}({})
            {}
        end 
    ]], {f(generate_parameter_doc, {2}), i(1, "name"), i(2, "param..."), i(0, "body")}))
})

ls.add_snippets("all", {
    s("af", fmt([[
        function ({})
            {}
        end 
    ]], {i(1, "param..."), i(0, "body")}))
})

ls.add_snippets("all", {
    s("sf", fmt([[
        {}
        function {}.{}({})
            {}
        end 
    ]], {f(generate_parameter_doc, {3}), i(1, "M"), i(2, "name"), i(3, "param..."), i(0, "body")}))
})

ls.add_snippets("all", {
    s("ie", fmt([[
        if err ~= nil then
            return {}, err
        end 
    ]], {i(0, "value")}))
})


