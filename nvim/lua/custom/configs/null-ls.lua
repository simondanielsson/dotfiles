local augorup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local null_ls = require('null-ls')

local opts = {
  sources = {
    -- Python tools
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.mypy.with({
        extra_args = function()
          local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
          return { "--python-executable", virtual .. "/bin/python3" }
        end,
    }),

    -- Go tools
    null_ls.builtins.formatting.gofmt,       -- Go formatter
    null_ls.builtins.formatting.goimports,   -- Formatter that also handles imports
    null_ls.builtins.diagnostics.golangci_lint, -- Go linter

    -- JavaScript tools
    null_ls.builtins.formatting.prettier.with({
        filetypes = { "javascript", "typescript", "svelte", "html", "css", "js", "ts" },
    }),

    -- ESLint for linting JavaScript/TypeScript
    null_ls.builtins.diagnostics.eslint.with({
        filetypes = { "javascript", "typescript", "svelte", "html", "css", "js", "ts" },
    }),
    -- OCaml tools
    null_ls.builtins.formatting.ocamlformat,
  },
  on_attach = function (client, bufnr)
    if client.supports_method("textDocument/formatting") or client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({
        group = augorup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augorup,
        buffer = bufnr,
        callback = function ()
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      })
    end
  end,
}

return opts
