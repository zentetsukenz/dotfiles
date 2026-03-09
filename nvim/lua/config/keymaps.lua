-- Spacemacs-inspired LSP keymaps under <leader>l
-- Note: <leader>c is LazyVim's built-in code group — we ADD <leader>l alongside it
vim.keymap.set("n", "<leader>l", "", { desc = "+Code" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostic" })
