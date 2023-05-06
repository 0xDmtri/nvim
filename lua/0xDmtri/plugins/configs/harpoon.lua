-- [[ Configure Harpoon ]]
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")


wk.register({
    ["<leader>h"] = { name = "+harpoon" },
    ["<leader>ha"] = { mark.add_file, '[H]arpoon [A]dd buffer' },
    ["<leader>hm"] = { ui.toggle_quick_menu, '[H]arpoon [M]enu' },

    ["<leader>h1"] = { function() ui.nav_file(1) end, '[H]arpoon file [1]' },
    ["<leader>h2"] = { function() ui.nav_file(2) end, '[H]arpoon file [2]' },
    ["<leader>h3"] = { function() ui.nav_file(3) end, '[H]arpoon file [3]' },
    ["<leader>h4"] = { function() ui.nav_file(4) end, '[H]arpoon file [4]' },

    ["<M-tab>"] = { function() ui.nav_next() end, 'which_key_ignore' }
})
