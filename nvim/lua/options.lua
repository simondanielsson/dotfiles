-- ╭──────────────────────────────────────────────────────────╮
-- │  Vim Options                                             │
-- ╰──────────────────────────────────────────────────────────╯

local opt = vim.opt
local g = vim.g

-- General
opt.laststatus = 3          -- global statusline
opt.showmode = false        -- mode shown in statusline plugin
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.mouse = "a"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Appearance
opt.fillchars = { eob = " " }
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false
opt.shortmess:append("s")
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.wrap = false

-- Behavior
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250
opt.virtualedit = "block"
opt.scrolloff = 25
opt.whichwrap:append("<>[]hl")

-- Spell checking (use zg to add word to dictionary)
opt.spell = true

-- Terminal
g.terminal_emulator = "Alacritty.app"

-- Disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  g["loaded_" .. provider .. "_provider"] = 0
end

-- Add mason binaries to PATH
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

vim.cmd.colorscheme("nightowl-nvchad")
