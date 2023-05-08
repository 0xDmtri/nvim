-- [[ Configure Neotree]]
vim.keymap.set("n", "<C-\\>", ":Neotree toggle reveal_force_cwd <CR>")
vim.keymap.set("n", "<leader>\\b", ":Neotree source=buffers toggle<CR>", { desc = "Neotree Buffer" })
vim.keymap.set("n", "<leader>\\g", ":Neotree source=git_status toggle<CR>", { desc = "Neotree Git Status" })
