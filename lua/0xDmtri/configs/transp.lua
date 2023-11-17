-- [[ Configure Transparent ]]

require('transparent').setup({
  extra_groups = { 'NormalFloat' },
})

-- [[ Hack Transparent Plugin ]]
-- Define the function that wrapps TransparentEnable with
-- transparent fidget borders
local function toggleLucid()
  -- check if fidget installed
  local success, fidget = pcall(require, 'fidget')

  -- if success, make fidget transparent
  if success then
    fidget.setup({
      notification = {
        window = {
          winblend = 0
        }
      }
    })
  end

  -- Then, execute the :TransparentEnable command
  vim.cmd("TransparentEnable")
end

-- Define the function that wrapps TransparentDisable with
-- transparent fidget borders
local function toggleSolid()
  -- check if fidget installed
  local success, fidget = pcall(require, 'fidget')

  -- if success, make fidget solid
  if success then
    fidget.setup({
      notification = {
        window = {
          winblend = 100
        }
      }
    })
  end

  -- Then, execute the :TransparentDisable command
  vim.cmd("TransparentDisable")
end

-- Create a new command that makes everything lucid
vim.api.nvim_create_user_command('Lucid', toggleLucid, {})

-- Create a new command that makes everything solid
vim.api.nvim_create_user_command('Solid', toggleSolid, {})
