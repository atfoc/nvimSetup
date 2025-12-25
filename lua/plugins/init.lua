return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-macchiato")
        end
    },
    {
        "preservim/nerdtree",
        name = "nerdtree",
    },
    {
        'nvim-telescope/telescope.nvim',
        name="telescope",
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
    {
        'nvim-telescope/telescope-ui-select.nvim',
        name="telescope-ui-select",
        dependencies = {"telescope"},
        config = function()
            require("telescope").load_extension("ui-select")
        end
    }
}
