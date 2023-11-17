-- [[ Configure Neotree]]

require('neo-tree').setup({
  window = {
    position = 'right'
  }
})

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd <CR>", { silent = true })
vim.keymap.set("n", "<leader>\\b", ":Neotree source=buffers toggle<CR>", { desc = "Neotree Buffer" })
vim.keymap.set("n", "<leader>\\g", ":Neotree source=git_status toggle<CR>", { desc = "Neotree Git Status" })
