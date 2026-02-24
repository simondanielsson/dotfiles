-- ╭──────────────────────────────────────────────────────────╮
-- │  Native Neovim 0.11 LSP Setup                           │
-- │                                                          │
-- │  Server configs live in the top-level lsp/ directory     │
-- │  (e.g. lsp/pyrefly.lua, lsp/gopls.lua, …).              │
-- │  Neovim auto-discovers them.                             │
-- ╰──────────────────────────────────────────────────────────╯

-- ── Disable inlay hints globally ─────────────────────────────
-- Pyrefly aggressively re-enables inlay hints on various events
-- (save, LSP restart, debugger launch, etc.). This timer-based
-- approach catches all of them by polling every 500ms.
vim.lsp.inlay_hint.enable(false)
local inlay_timer = vim.uv.new_timer()
inlay_timer:start(0, 500, vim.schedule_wrap(function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  end
end))

-- ── Diagnostic appearance ────────────────────────────────────
local signs = { Error = "󰅙", Warn = "", Info = "󰋼", Hint = "󰌵" }

vim.diagnostic.config({
  virtual_text = { prefix = "", virtual_text = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN]  = signs.Warn,
      [vim.diagnostic.severity.INFO]  = signs.Info,
      [vim.diagnostic.severity.HINT]  = signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  float = { border = "single" },
})

-- ── Shared capabilities (advertise nvim-cmp support to servers) ──
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  },
}

-- Tell all LSP servers the client does NOT support inlay hints
capabilities.textDocument.inlayHint = nil

-- Apply to every server via the wildcard
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- ── LspAttach: buffer-local keymaps ──────────────────────────
-- Fires whenever any LSP client attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    bmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
    bmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
    bmap("n", "<C-k>", function() vim.lsp.buf.hover({ border = "single" }) end, "LSP hover")
    bmap("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
    bmap("n", "<leader>ls", function() vim.lsp.buf.signature_help({ border = "single" }) end, "LSP signature help")
    bmap("n", "<leader>D", vim.lsp.buf.type_definition, "LSP type definition")
    bmap("n", "<leader>ra", vim.lsp.buf.rename, "LSP rename")
    bmap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    bmap("v", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    bmap("n", "gr", vim.lsp.buf.references, "LSP references")
    bmap("n", "<leader>lf", function() vim.diagnostic.open_float({ border = "rounded" }) end, "Floating diagnostic")
    bmap("n", "[d", function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end, "Goto prev diagnostic")
    bmap("n", "]d", function() vim.diagnostic.goto_next({ float = { border = "rounded" } }) end, "Goto next diagnostic")
    bmap("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic setloclist")
    bmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    bmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    bmap("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders")

    -- LSP semantic tokens are enabled — they layer on top of treesitter
    -- highlights and provide more accurate coloring (e.g. distinguishing
    -- parameters from local variables). The @lsp.type.* groups link to
    -- treesitter groups by default, so the colorscheme only needs to
    -- define the treesitter groups to cover both.
  end,
})

-- ── Enable LSP servers ───────────────────────────────────────
-- Each name matches a file in lsp/<name>.lua
vim.lsp.enable({
  "pyrefly",              -- Python
  "gopls",                -- Go
  "html",                 -- HTML
  "cssls",                -- CSS
  "emmet_language_server", -- Emmet
  "cssmodules_ls",        -- CSS Modules
  "ts_ls",                -- TypeScript / JavaScript
  "tailwindcss",          -- Tailwind CSS
  "eslint",               -- ESLint
  "svelte",               -- Svelte
  "ocamllsp",             -- OCaml
  "lua_ls",               -- Lua
  "marksman",             -- Markdown
})

-- Re-trigger FileType for the initial buffer (FileType fires before this runs)
vim.cmd("silent! do FileType")
