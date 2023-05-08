-- [[ Configure LSP ]]

-- Setup neovim lua configuration
-- require('neodev').setup({})

-- setup LSP-ZERO
local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = false,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})

-- make sure this servers installed
lsp.ensure_installed({
    -- 'rust_analyzer', NOTE: Installed natively with cargo
    'lua_ls',
})

-- configue Lua Server
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
})

-- setup solidity server from VSCode
lsp.use('solidity', {
    cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = require("lspconfig.util").root_pattern('foundry.toml'),
    single_file_support = true,
})

-- setup remappings for solidity ls
lsp.configure('solidity', {
    settings = {
        solidity = {
            includePath = "",
            remapping = {
                ['forge-std/'] = 'lib/forge-std/src/',
                ['solady/'] = 'lib/solady/src/',
                ['solmate/'] = 'lib/solmate/src/',
                ['zodiac/'] = 'lib/zodiac/contract/',
                ['safe-tools/'] = 'lib/safe-tools/src/',
                ['@openzeppelin/'] = 'lib/openzeppelin-contracts/',
                ['openzeppelin-contracts/'] = 'lib/openzeppelin-contracts',
            }
        }
    }
})

-- don't initialize this language server
-- we will use rust-tools to setup rust_analyzer
lsp.skip_server_setup({ 'rust_analyzer' })

-- helper for binds
local nmap = function(bufnr, keys, func, desc)
    if desc then
        desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

-- LSP settings.
lsp.on_attach(function(_, bufnr)
    -- LSP keymap
    nmap(bufnr, 'gr', '<cmd>Lspsaga lsp_finder<CR>', '[G]oto [R]eferences')
    nmap(bufnr, 'gd', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap(bufnr, 'gD', '<cmd>Lspsaga peek_definition<CR>', '[G]oto [D]efinition')
    nmap(bufnr, 'gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap(bufnr, '<leader>ca', '<cmd>Lspsaga code_action<CR>', '[C]ode [A]ction')
    nmap(bufnr, '<leader>rn', '<cmd>Lspsaga rename<CR>', '[R]e[n]ame')
    nmap(bufnr, '<leader>d', '<cmd>Lspsaga peek_type_definition<CR>', 'Type [D]efinition')
    nmap(bufnr, '<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch document [S]ymbols')
    nmap(bufnr, 'K', '<cmd>Lspsaga hover_doc<CR>', 'Hover Documentation')

    -- in INSERT mode only
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

    -- Diagnostic keymaps
    nmap(bufnr, '<leader>D', '<cmd>Lspsaga show_cursor_diagnostics<CR>', '[D]iagnostics')
    nmap(bufnr, '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Go to prev diagnostic msg')
    nmap(bufnr, ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Go to next diagnostic msg')
    nmap(bufnr, '<leader>q', '<cmd>Lspsaga show_buf_diagnostics<CR>', 'Open diagnostic list')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end)

-- configure lua language server for neovim
lsp.nvim_workspace()

-- call setup
lsp.setup()

-- initialize rust_analyzer with rust_tools
local rust_lsp = lsp.build_options('rust_analyzer', {
    single_file_support = false,

    settings = {
        ['rust-analyzer'] = {
            lens = {
                enable = true,
            },
            checkOnSave = {
                enable = true,
            }
        }
    },

    on_attach = function(_, bufnr)
        print('Lets get Rusty!')

        -- Rust Specific keymaps
        nmap(bufnr, '<leader>a', require('rust-tools').hover_actions.hover_actions, '[A]ctions Hover')
        nmap(bufnr, '<leader>ca', require('rust-tools').code_action_group.code_action_group, '[C]ode [A]ction')
        nmap(bufnr, '<leader>cr', '<cmd>RustRunnables<CR>', '[C]argo [R]unnables')
    end
})

require('rust-tools').setup({ server = rust_lsp })

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-x>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'crates' },
    },
}
