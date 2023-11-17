-- [[ Configure LSP Saga ]]

require('lspsaga').setup({
  move_in_saga = {
    prev = "<C-k>",
    next = "<C-j>",
  },
  finder_action_keys = {
    open = "<CR>",
  },
  definition_action_keys = {
    edit = "<CR>",
  },
  ui = {
    border = "rounded",
  },
})

-- Floating terminal
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>Lspsaga term_toggle<CR>")
