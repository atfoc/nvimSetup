local functions = require('functions')
vim.keymap.set("n", "<leader>ev", function()
        functions.applyCodeAction("Extract to local variable", "refactor.extract.variable")
end, { desc = "Java: Extract Variable" })

