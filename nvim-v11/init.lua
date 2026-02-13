-- VSCode-embedded Neovim: bail out early
if vim.g.vscode then
  return
end

-- Set leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core options
require("options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins via lazy.nvim
-- lazy auto-imports all files under lua/plugins/
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "night-owl" } },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin", "tohtml", "getscript", "getscriptPlugin",
        "gzip", "logipat", "netrw", "netrwPlugin", "netrwSettings",
        "netrwFileHandlers", "matchit", "tar", "tarPlugin",
        "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin",
        "zip", "zipPlugin", "rplugin", "synmenu",
        "optwin", "compiler", "bugreport",
      },
    },
  },
})

require("keymaps")
require("autocmds")
require("lsp")
