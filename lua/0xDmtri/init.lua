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

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {
        -- plugin to config lsp
        'neovim/nvim-lspconfig',
        dependencies = {
          -- Additional lua configuration, makes nvim stuff amazing!
          'folke/neodev.nvim',

          -- plugins to download remote lsp servers
          { 'williamboman/mason.nvim',          config = true },
          { 'williamboman/mason-lspconfig.nvim' },

          -- LSP extention for formatting and linting
          {
            "jose-elias-alvarez/null-ls.nvim",
            requires = { "nvim-lua/plenary.nvim" },
          },

          -- Useful status updates for LSP
          {
            'j-hui/fidget.nvim',
            branch = 'legacy',
            dependencies = {
              "xiyaowong/transparent.nvim",
            },
            -- lil hack to set blend to 0 if transparent and vice versa
            opts = function()
              if vim.g.transparent_enabled then
                return { window = { blend = 0 } }
              else
                return { window = { blend = 100 } }
              end
            end,
            config = function(_, opts)
              require('fidget').setup(opts)
            end
          },
        }
      },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },

    },
    config = function()
      -- [[ Configure LSP ]]
      require('0xDmtri.configs.lsp')
    end
  },

  {
    -- LSP Enhance Plugin
    "nvimdev/lspsaga.nvim",
    name = 'lspsaga',
    event = "LspAttach",
    opts = function()
      return require('0xDmtri.configs.saga')
    end,
    config = function(opts)
      require("lspsaga").setup(opts)
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      'VonHeikemen/lsp-zero.nvim',
    }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

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
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    opts = function()
      return require('0xDmtri.configs.others').rose_pine
    end,
    config = function(_, opts)
      require('rose-pine').setup(opts)
      vim.cmd.colorscheme 'rose-pine'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'ColorScheme',
    opts = function()
      return require('0xDmtri.configs.others').lualine
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- [[ Configure Telescope ]]
      require('0xDmtri.configs.telescope')
    end
  },

  {
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    config = function()
      -- [[ Configure Treesitter ]]
      require('0xDmtri.configs.treesitter')
    end
  },

  {
    -- Rust dev env
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvimdev/lspsaga.nvim',
    },
    ft = { 'rust' },
    -- NOTE: configured inside LSP config
  },

  {
    -- Crates helper
    'saecki/crates.nvim',
    name = 'crates',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- [[ Configure Crates ]]
      require('0xDmtri.configs.crates')
    end
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
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- [[ Configure Neo Tree]]
      require('0xDmtri.configs.neotree')
    end,
  },

  {
    -- File bookmarks
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      -- [[ Configure Harpoon ]]
      require('0xDmtri.configs.harpoon')
    end,
  },

  {
    -- Transparent windows on demand!
    "xiyaowong/transparent.nvim",
    config = function()
      require('transparent').setup(
        {
          extra_groups = { 'NormalFloat' },
        }
      )
    end,
  },

  {
    -- Context functions while scrolling
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function()
      require('treesitter-context').setup {}
    end,
  },

  -- Huff syntax highlighting
  { "wuwe1/vim-huff", lazy = false },
}, {})
