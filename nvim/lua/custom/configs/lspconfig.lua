local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"}, 
  root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
    },
  },
})

-- HTML
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach
})

-- CSS
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach
})

-- EMMET
lspconfig.emmet_language_server.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    "css",
    "eelixir",
    "elixir",
    "eruby",
    "heex",
    "html",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "svelte",
    "typescriptreact" }
})

-- CSS MODULES
lspconfig.cssmodules_ls.setup({
  capabilities = capabilities,
  filetypes = { "javascriptreact", "typescriptreact" }
})

-- Typescript
lspconfig.ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}

-- TAILWINDCSS
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  autostart = false,
  settings = {
    tailwindCSS = {
      includeLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
  },
})

-- ESLINT
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = on_attach
})

--SVELTE
lspconfig.svelte.setup({
  on_attach = on_attach,
  flags = {debounce_text_changes = 50},
})
vim.g.vim_svelte_plugin_use_typescript = 1

-- OCAML
lspconfig.ocamllsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
  root_dir = lspconfig.util.root_pattern("dune-project", ".git"),
})
