-- LSP mappings
local rt = require("rust-tools")

local opts = {
  tools = {
    -- rust-tools options

    -- how to execute terminal commands
    -- options right now: termopen / quickfix
    executor = require("rust-tools.executors").termopen,

    -- runnables
    runnables = {
      use_telescope = true,
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    -- standalone file support
    -- setting it to false may improve startup time
    standalone = false,

    on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      -- LSP general keymaps
      nmap('gr', '<cmd>Lspsaga lsp_finder<CR>', '[G]oto [R]eferences')
      nmap('gd', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('gD', '<cmd>Lspsaga peek_definition<CR>', '[G]oto [D]efinition')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>rn', '<cmd>Lspsaga rename<CR>', '[R]e[n]ame')
      nmap('<leader>d', '<cmd>Lspsaga show_cursor_diagnostics<CR>', '[D]iagnostics')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch document [S]ymbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Rust Specific keymaps
      nmap('<leader>a', rt.hover_actions.hover_actions, 'Hover Actions')
      nmap('<leader>ca', rt.code_action_group.code_action_group, '[C]ode [A]ction')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end,

    settings = {
      ['rust-analyzer'] = {
        lens = {
          enable = true,
        },
        checkOnSave = {
          enable = true,
        }
      }
    }
  }, -- rust-analyzer options

  -- debugging stuff
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
}

return opts
