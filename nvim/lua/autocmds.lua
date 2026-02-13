-- ╭──────────────────────────────────────────────────────────╮
-- │  Autocmds                                                │
-- ╰──────────────────────────────────────────────────────────╯

local autocmd = vim.api.nvim_create_autocmd

-- Don't list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Go: format with goimports on save
autocmd("BufWritePre", {
  pattern = "*.go",
  group = vim.api.nvim_create_augroup("GoImports", { clear = true }),
  callback = function()
    local ok, go_format = pcall(require, "go.format")
    if ok then
      go_format.goimports()
    end
  end,
})
