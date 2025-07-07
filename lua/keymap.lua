vim.keymap.set("n", "<leader>sf", ":wall<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>qv", ":qall<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>qV", ":qall!<CR>", { desc = "Quit force" })
vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format file" })
vim.keymap.set("n", "<leader>nt", ":NERDTreeToggle<CR>", { desc = "Nerd tree toggle" })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fs", telescope.find_files, { desc = "Git files" })

vim.keymap.set("n", "<leader>ss", telescope.lsp_document_symbols, { desc = "File symbols" })
vim.keymap.set("n", "<leader>sS", telescope.lsp_dynamic_workspace_symbols, { desc = "Dynamic workspace symbols" })
vim.keymap.set("n", "<leader>gr", telescope.lsp_references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>gi", telescope.lsp_implementations, { desc = "Go to implementsion" })
vim.keymap.set("n", "<leader>gd", telescope.lsp_definitions, { desc = "Go to definitions" })
vim.keymap.set("n", "<leader>gt", telescope.lsp_type_definitions, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>km", telescope.keymaps, { desc = "List keymaps" })
vim.keymap.set("n", "<leader>bf", telescope.buffers, { desc = "List buffers" })


vim.keymap.set("n", "<leader>dg", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Open diagnostics" })

vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highligh" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", {desc = "Split vertical"})
vim.keymap.set("n", "<leader>sh", ":split<CR>", {desc = "Split horizontal"})
vim.keymap.set("n", "<leader>wh", "<C-W>h", {desc = "Go left split"})
vim.keymap.set("n", "<leader>wj", "<C-W>j", {desc = "Go down split"})
vim.keymap.set("n", "<leader>wk", "<C-W>k", {desc = "Go up split"})
vim.keymap.set("n", "<leader>wl", "<C-W>l", {desc = "Go right split"})
vim.keymap.set("n", "<leader>wq", ":q<CR>", {desc = "Quit split"})
vim.keymap.set("n", "<leader>wQ", ":q!<CR>", {desc = "Quit split without save"})

--vim.keymap.set("n", "<leader>", "", { desc = "" })
