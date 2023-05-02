--[[

=====================================================================
  ______             _______                   __                __
 /      \           /       \                 /  |              /  |
/₿₿₿₿₿₿  | __    __ ₿₿₿₿₿₿₿  | _____  ____   _₿₿ |_     ______  ₿₿/
₿₿₿  \₿₿ |/  \  /  |₿₿ |  ₿₿ |/     \/    \ / ₿₿   |   /      \ /  |
₿₿₿₿  ₿₿ |₿₿  \/₿₿/ ₿₿ |  ₿₿ |₿₿₿₿₿₿ ₿₿₿₿  |₿₿₿₿₿₿/   /₿₿₿₿₿₿  |₿₿ |
₿₿ ₿₿ ₿₿ | ₿₿  ₿₿<  ₿₿ |  ₿₿ |₿₿ | ₿₿ | ₿₿ |  ₿₿ | __ ₿₿ |  ₿₿/ ₿₿ |
₿₿ \₿₿₿₿ | /₿₿₿₿  \ ₿₿ |__₿₿ |₿₿ | ₿₿ | ₿₿ |  ₿₿ |/  |₿₿ |      ₿₿ |
₿₿   ₿₿₿/ /₿₿/ ₿₿  |₿₿    ₿₿/ ₿₿ | ₿₿ | ₿₿ |  ₿₿  ₿₿/ ₿₿ |      ₿₿ |
 ₿₿₿₿₿₿/  ₿₿/   ₿₿/ ₿₿₿₿₿₿₿/  ₿₿/  ₿₿/  ₿₿/    ₿₿₿₿/  ₿₿/       ₿₿/
=====================================================================

--]]
--
-- [[ Configure Core Settings]]

-- Load default Keymaps, Settings and Colorscheme
require('0xDmtri.core.set')
require('0xDmtri.core.remap')

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy plugin manager
require('lazy').setup({

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    -- Theme
    'maxmx03/dracula.nvim',
    name = 'dracula',
    priority = 1000,
    opts = function()
      return require('0xDmtri.plugins.others').dracula
    end,
    config = function(_, opts)
      require('dracula').setup(opts)
      vim.cmd.colorscheme 'dracula'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = function()
      return require('0xDmtri.plugins.others').lualine
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },

  {
    -- Rust dev env
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    ft = { 'rust' },
    config = function()
      require "0xDmtri.plugins.ftplugin.rust"
    end,
  },

  {
    -- Auto matching brackers
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  {
    -- Better file tree
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup {}
    end,
  },

  {
    -- Integrated terminal
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup {}
    end,
  },

  {
    -- File bookmarks
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
  },

  -- Autoformat (smart)
  require '0xDmtri.plugins.autoformat',

  -- Debuggin suit
  require '0xDmtri.plugins.debug',

}, {})

-- ================= Load Configs =================

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Harpoon ]]
require('0xDmtri.plugins.harpoon')

-- [[ Configure Telescope ]]
require('0xDmtri.plugins.telescope')

-- [[ Configure Treesitter ]]
require('0xDmtri.plugins.treesitter')

-- [[ Configure LSP ]]
require('0xDmtri.plugins.lsp')
