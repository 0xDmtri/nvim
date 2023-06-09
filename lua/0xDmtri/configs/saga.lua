-- [[ Configure LSP Saga ]]

-- Floating terminal
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>Lspsaga term_toggle<CR>")

local opts = {
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
}

return opts
