local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local r = require("luasnip.extras").rep

ls.add_snippets("all", { s("fe", fmt([[
for({} {} : {}) {{
    {}
    {}
}}
]], {

    i(3, "Type"),
    i(2, "value"),
    i(1, "over"),
    i(1, "body"),
    i(0)
})) })


ls.add_snippets("all", { s("fl", fmt([[
for({} {} = {}; {} {}; {}++) {{
    {}
    {}
}}
]], {

    i(4, "int"),
    i(3, "i"),
    i(1, "0"),
    r(3),
    i(2, "< 10"),
    r(3),
    i(5, "body"),
    i(0)
})) })

ls.add_snippets("all", {
    s("if", fmt([[
        if {} {{ 
            {}
            {}
    }}
    ]], {i(1, "condition"), i(2, "body"), i(0, "")}))
})


---@return string 
local function get_class_name_from_file()
    local file_name = vim.fn.expand("%:t")

    local file_name_without_java = string.match(file_name, "(.+)%.java")
    return file_name_without_java
end


---@return string 
local function get_package_name_based_on_file()
    local full_path_for_file = vim.fn.expand("%:p")
    local file_name = vim.fn.expand("%:t")

    local _, src_end = string.find(full_path_for_file, "src/")
    local file_name_start = string.find(full_path_for_file, file_name)

    local result = {}
    local part_to_convert = string.sub(full_path_for_file, src_end+1, file_name_start - 1)

    for part_of_package in string.gmatch(part_to_convert, "(%w+)/?")do
        table.insert(result, part_of_package)
    end

    return table.concat(result, ".")
end


ls.add_snippets("all", { s("jf", fmt([[
package {};

public {} {} {{
    
}}
]], {

    f(get_package_name_based_on_file),
    c(1, {t("class"), t("interface"), t("enum")}),
    f(get_class_name_from_file),
})) })


ls.add_snippets("all", {
    s("fn", fmt([[
        {} {} {}({}) {{
            {}
            {}
        }}
    }}
    ]], {
            c(1, {t("public"), t("private")}),
            i(3, "void"),
            i(2, "name"),
            i(4, "args..."),
            i(5, "body"),
            i(0),
        }))
})

ls.add_snippets("all", {
    s("sf", fmt([[
        {} static {} {}({}) {{
            {}
            {}
        }}
    }}
    ]], {
            c(1, {t("public"), t("private")}),
            i(3, "void"),
            i(2, "name"),
            i(4, "args..."),
            i(5, "body"),
            i(0),
        }))
})

ls.add_snippets("all", {
    s("cf", fmt([[
        {} {} {}{};
    ]], {
            c(1, {t("public"), t("private")}),
            i(3, "Object"),
            i(2, "name"),
            i(0),
        }))
})

ls.add_snippets("all", {
    s("sf", fmt([[
        {} static final {} {}{};
    ]], {
            c(1, {t("public"), t("private")}),
            i(3, "Object"),
            i(2, "name"),
            i(0),
        }))
})

ls.add_snippets("all", {
    s("ff", fmt([[
        {} final {} {}{};
    ]], {
            c(1, {t("public"), t("private")}),
            i(3, "Object"),
            i(2, "name"),
            i(0),
        }))
})

ls.add_snippets("all", {
    s("te", fmt([[
        throw new {}({} {}){};
    ]], {
            i(1, "RuntimeException"),
            i(3, '"Failed to "'),
            i(2, ', e'),
            i(0),
        }))
})


