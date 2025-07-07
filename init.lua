vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4           -- Tab width
vim.opt.shiftwidth = 4        -- Indent width
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Smart indenting
vim.opt.wrap = false          -- Disable line wrap
vim.opt.swapfile = false      -- No swap files
vim.opt.backup = false        -- No backups
vim.opt.undofile = true       -- Persistent undo
vim.opt.hlsearch = true       -- Highlight search
vim.opt.incsearch = true      -- Incremental search
vim.opt.termguicolors = true  -- True color support
vim.opt.scrolloff = 8         -- Keep cursor centered
vim.opt.signcolumn = "yes"    -- Always show sign column

-- Leader key
vim.g.mapleader = " "

require("lazyConfig")
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("keymap")
    end
})
