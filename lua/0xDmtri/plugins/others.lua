local M = {}

M.lualine = {
    options = {
        theme = 'rose-pine',
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
    },
}

M.rose_pine = {
    variant = 'auto',
    dark_variant = 'main',
    disable_background = vim.g.transparent_enabled,
    disable_float_background = vim.g.transparent_enabled,
}

return M
