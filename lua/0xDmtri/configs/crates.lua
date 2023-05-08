-- [[ Configure Crate ]]

local crates = require('crates')

-- Add keymaps specific for `Cargo.toml`
vim.keymap.set('n', '<leader>ci', crates.show_crate_popup, { desc = '[C]rate [I]nfo' })
vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = '[C]rate [V]ersion popup' })
vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = '[C]rate [F]eatures popup' })
vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = '[C]rate [U]pdate ' })
vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = '[C]rates update [A]ll' })
vim.keymap.set('n', '<leader>cd', crates.open_documentation, { desc = '[C]rate [D]ocs' })

require('crates').setup {
  popup = {
    autofocus = true,
    hide_on_select = false,
  }
}
