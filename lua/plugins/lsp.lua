return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",

        opts = {
            ensure_installed = { "c", "json", "html", "lua", "tsx", "typescript", "yaml", "go", "java" },
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },
    {
        "neovim/nvim-lspconfig",
        name = "nvim-lspconfig",

        dependencies = { "mason-lspconfig", "mason" },
    },
    {
        "williamboman/mason.nvim",
        name = "mason",
        opts = {}
    },
    {
        "williamboman/mason-lspconfig.nvim",
        name = "mason-lspconfig",
        opts = {
            ensure_installed = { "lua_ls", "ts_ls", "gopls", "jdtls" },
            automatic_installation = true,
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "LazyVim",            words = { "LazyVim" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
                { path = "lazy.nvim",          words = { "LazyVim" } },
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        name="luaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { "luaSnip", "dadbod-completion" },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'enter' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                documentation = { auto_show = false },
                menu = {
                    auto_show = false,
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                per_filetype = {
                    sql = { 'snippets', 'dadbod', 'buffer' },
                },
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" }
    },
    {
        'tpope/vim-dadbod',
        name = "dadbod"
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        name = "dadbod-ui",
        dependencies = { "dadbod" }
    },
    {
        'kristijanhusak/vim-dadbod-completion',
        name = "dadbod-completion",
        ft = { 'sql', 'mysql', 'plsql' },
        dependencies = { "dadbod" },
    },
    {
        'mfussenegger/nvim-jdtls',
        name = "nvim-jdtls",
        ft = { "java" }
    }
}
