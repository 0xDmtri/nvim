local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      python = {
        command = { "python" },
      },
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').right(120),
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>im",       -- send motion
    visual_send = "<space>is",       -- send selection
    send_file = "<space>if",         -- send file
    send_line = "<space>il",         -- send line
    send_until_cursor = "<space>iu", -- send until-coursor
    -- send_mark = "<space>sm",
    -- mark_motion = "<space>mm",
    -- mark_visual = "<space>mv",
    -- remove_mark = "<space>md",
    cr = "<space>i<cr>",
    interrupt = "<space>i<space>", -- interrupt
    exit = "<space>iq",            -- quit
    clear = "<space>ic",           -- clear
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>', { desc = '[R]epl [S]tart' })
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>', { desc = '[R]epl [R]estart' })
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>', { desc = '[R]epl [F]ocus' })
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>', { desc = '[R]epl [H]ide' })
