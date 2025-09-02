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
        '.git',
        'build.gradle',
        'build.gradle.kts',
        'build.xml',
        'pom.xml',
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
                "--jvm-arg=-javaagent:".. homwDir .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
                "--jvm-arg=-Xms4g"

            }
        })
    end
end

return M
