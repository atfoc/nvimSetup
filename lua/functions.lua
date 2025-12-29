local M = {}

function M.resizeWindowHeight()
    local size = vim.v.count1
    vim.cmd("resize " .. size)
end

function M.resizeWindowWidth()
    local size = vim.v.count1
    vim.cmd("vertical resize " .. size)
end

function M.tweekJdtlsConfig()
    local cwd = vim.fn.getcwd()
    local rootDir = vim.fs.root(cwd, {
        'pom.xml',
        '.git',
        'build.gradle',
        'build.gradle.kts',
        'build.xml',
        'settings.gradle',
        'settings.gradle.kts',
    })

    if (rootDir ~= nil)
    then
        local projectName = vim.fn.fnamemodify(rootDir, ":t")
        local homwDir = vim.uv.os_homedir()
        vim.lsp.config("jdtls", {
            cmd = {
                'jdtls',
                '-configuration',
                homwDir .. "/.cache/jdtls/config/" .. projectName
                ,
                '-data',
                homwDir .. "/.cache/jdtls/data/" .. projectName,
                "--jvm-arg=-javaagent:" .. homwDir .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
                "--jvm-arg=-Xms4g"

            },
            root_dir = rootDir,
        })
    end
end

function M.deleteJumpList()
    vim.cmd("clearjumps")
end

function M.applyCodeAction(title, kind)
    vim.lsp.buf.code_action({
        filter = function(a) return a.kind == kind and a.title == title end,
        apply = true
    })
end

function M.lua_snip_jump_expand_or_tab()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
        -- Condition is true: expand or jump
        ls.expand_or_jump()
    else
        -- Condition is false: insert a real Tab character
        -- we use nvim_replace_termcodes to turn "<Tab>" into the actual keycode
        local tab = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
        vim.api.nvim_feedkeys(tab, "n", false)
    end
end

return M
