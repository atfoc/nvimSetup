vim.api.nvim_create_user_command("CopyClassFullName", function()
    local parser = vim.treesitter.get_parser(0, "java")
    if parser == nil then
        vim.notify("failed to get treesitter parser", vim.log.levels.ERROR)
        return
    end

    local root = parser:parse(nil)[1]:root()
    local query = vim.treesitter.query.parse("java", [[
        (package_declaration
            (scoped_identifier) @package)

        (class_declaration
            name: (identifier) @class)
    ]])

    local packageName = ""
    local className = ""
    for index, node in query:iter_captures(root, 0) do
        if query.captures[index] == "package" then
            local start_row, start_col, end_row, end_col = node:range(false)
            packageName = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]:match(
            "^%s*(.-)%s*$")
        end

        if query.captures[index] == "class" then
            local start_row, start_col, end_row, end_col = node:range(false)
            className = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]:match("^%s*(.-)%s*$")
        end
    end

    if packageName == "" or className == "" then
        vim.notify("failed to find package name or class name", vim.log.levels.ERROR)
        return
    end

    local full_name = packageName .. "." .. className
    vim.fn.setreg("+", full_name)
    vim.fn.setreg("0", full_name)

end, { desc = "Copy class full name" })
