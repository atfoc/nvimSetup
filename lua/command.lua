vim.api.nvim_create_user_command("ListCodeActions", function()
    -- 1. Get parameters for the current cursor position
    --- @type any
    local params = vim.lsp.util.make_range_params(0, "utf-8")


    params.context = {diagnostics= {}}
    -- 2. Request code actions from all attached LSP clients
    --    Method: textDocument/codeAction
    vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(err, result, ctx)
        if err then
            vim.print(err)
            return
        end

        if not result or vim.tbl_isempty(result) then
            vim.notify("No code actions available.", vim.log.levels.INFO)
            return
        end

        -- 3. Header
        print(string.format("%-40s | %s", "CODE ACTION TITLE", "KIND"))
        print(string.rep("-", 60))

        -- 4. Iterate and print Name (title) and Kind
        for _, action in pairs(result) do
            local title = action.title or "Unknown Title"
            -- 'kind' is optional in the LSP spec, so we handle nil
            local kind = action.kind or "[No Kind specified]"

            print(string.format("%-40s | %s", title, kind))
        end
    end)
end, { desc = "List LSP code actions and their kinds without executing" })
