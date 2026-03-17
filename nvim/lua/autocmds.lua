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

-- ── Markdown / notetaking ─────────────────────────────────
-- Auto-continue list items on <Enter>
autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    local function list_prefix(line)
      local indent = line:match("^(%s*)")
      if line:match("^%s*[-*+] %[.%] ") then
        return indent .. "- [ ] "
      end
      return line:match("^%s*[-*+] ") or line:match("^%s*%d+%. ")
    end

    local function is_empty_bullet(line)
      return line:match("^%s*[-*+] %[.%] $")
          or line:match("^%s*[-*+] $")
          or line:match("^%s*%d+%. $")
    end

    vim.keymap.set("i", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      local prefix = list_prefix(line)
      if prefix then
        if is_empty_bullet(line) then return "<C-u><CR>" end
        return "<CR>" .. prefix
      end
      return "<CR>"
    end, { expr = true, buffer = true })

    vim.keymap.set("n", "o", function()
      local line = vim.api.nvim_get_current_line()
      local prefix = list_prefix(line)
      if prefix then return "o" .. prefix end
      return "o"
    end, { expr = true, buffer = true })
  end,
})

-- Markdown buffer settings
autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
    vim.opt_local.textwidth = 80
    -- Green for completed checkboxes (treesitter + render-markdown)
    vim.api.nvim_set_hl(0, "@markup.list.checked", { fg = "#29E68E" })
    vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#29E68E" })
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
