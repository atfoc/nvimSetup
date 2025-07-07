return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-latte")
        end
    },
    {
        "preservim/nerdtree",
        name = "nerdtree",
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        opts = {
            defaults = {
                layout_config = {
                    width = 0.99,
                    height = 0.99,
                },
                layout_strategy = "horizontal"
            }
        }
    },
    {
        "echasnovski/mini.pairs",
        opts = {},
    },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
    },
}
