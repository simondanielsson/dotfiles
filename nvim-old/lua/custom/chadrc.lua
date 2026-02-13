---@type ChadrcConfig
local M = {}

M.ui = { theme = 'nightowl' }
-- update line number color to a stronger gray
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'gray' } )
vim.g.transparency = 1


M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
return M
