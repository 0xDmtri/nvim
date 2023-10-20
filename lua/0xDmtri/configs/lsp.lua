-- [[ Configure LSP ]]

-- Setup neovim dev tools for lua
require('neodev').setup({})

-- setup LSP-ZERO
local lsp_zero = require('lsp-zero')

-- setup Mason and Mason-LspConfig
require('mason').setup({})
require('mason-lspconfig').setup({
    -- make sure this servers installed via Mason
    -- NOTE: I installed rust-analyzer, ruff and forge-fmt locally!
    ensure_installed = {
        -- LSPs:
        'lua_ls',
        'tsserver',
        'solidity_ls_nomicfoundation',
        'pyright',

    },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

-- helper for binds
local nmap = function(bufnr, keys, func, desc)
    if desc then
        desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

-- LSP settings on attach
lsp_zero.on_attach(function(_, bufnr)
    -- LSP keymap
    nmap(bufnr, 'gr', '<cmd>Lspsaga finder ref<CR>', '[G]oto [R]eferences')
    nmap(bufnr, 'gd', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap(bufnr, 'gD', '<cmd>Lspsaga finder def<CR>', '[G]oto [D]efinition')
    nmap(bufnr, 'gI', '<cmd>Lspsaga finder imp<CR>', '[G]oto [I]mplementation')
    nmap(bufnr, '<leader>ca', '<cmd>Lspsaga code_action<CR>', '[C]ode [A]ction')
    nmap(bufnr, '<leader>rn', '<cmd>Lspsaga rename<CR>', '[R]e[n]ame')
    nmap(bufnr, '<leader>d', '<cmd>Lspsaga finder tyd<CR>', 'Type [D]efinition')
    nmap(bufnr, '<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch document [S]ymbols')
    nmap(bufnr, 'K', '<cmd>Lspsaga hover_doc<CR>', 'Hover Documentation')
    nmap(bufnr, '<leader>o', '<cmd>Lspsaga outline<CR>', '[O]utline')

    -- in INSERT mode only
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

    -- Diagnostic keymaps
    nmap(bufnr, '<leader>D', '<cmd>Lspsaga show_cursor_diagnostics<CR>', '[D]iagnostics')
    nmap(bufnr, '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Go to prev diagnostic msg')
    nmap(bufnr, ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Go to next diagnostic msg')
    nmap(bufnr, '<leader>q', '<cmd>Lspsaga show_buf_diagnostics<CR>', 'Open diagnostic list')
end)

-- enable format on save
lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 500,
    },
    servers = {
        -- Langs that will use null-ls for formatting
        ['null-ls'] = { 'javascript', 'typescript', 'python', 'solidity', },

        -- Langs that will use other formatters
        ['lua_ls'] = { 'lua' },
        ['rust_analyzer'] = { 'rust' }
    }
})

-- setup null-ls
local null_ls = require('null-ls')
null_ls.setup({
    sources = {
        -- Formattings
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.formatting.forge_fmt,
        null_ls.builtins.formatting.prettier,

        -- Diagnostics
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.solhint,
        null_ls.builtins.diagnostics.eslint_d,
    }
})

-- initialize rust_analyzer with rust_tools
require('rust-tools').setup({
    server = {
        on_attach = function(_, bufnr)
            print('🦀')

            -- Rust Specific keymaps
            nmap(bufnr, '<leader>a', require('rust-tools').hover_actions.hover_actions, '[A]ctions Hover')
            nmap(bufnr, '<leader>ca', require('rust-tools').code_action_group.code_action_group, '[C]ode [A]ction')
            nmap(bufnr, '<leader>cr', require('rust-tools').runnables.runnables, '[C]argo [R]unnables')
        end,

        standalone = false,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    command = 'clippy',
                    extraArgs = { '--all', '--', '-W', 'clippy::all' },
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                },
                procMacro = {
                    enable = true,
                },
            }
        }

    },
    hover_actions = { auto_focus = true },
    runnables = { use_telescope = true }
})

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
    formatting = lsp_zero.cmp_format(),
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
        { name = 'cmdline' },
    },
}
