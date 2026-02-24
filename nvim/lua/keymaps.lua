-- ╭──────────────────────────────────────────────────────────╮
-- │  Keymaps                                                 │
-- ╰──────────────────────────────────────────────────────────╯
-- LSP keymaps are in lua/lsp.lua (set buffer-locally on LspAttach)
-- Gitsigns keymaps are in the gitsigns on_attach (in plugins/init.lua)
-- DAP / Harpoon / Gopher keymaps are in their plugin configs

local map = vim.keymap.set

-- ── Insert mode ──────────────────────────────────────────────
map("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- ── Normal mode ──────────────────────────────────────────────
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- Save / Copy
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })

-- Smart j/k on wrapped lines
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, desc = "Move down" })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, desc = "Move up" })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Buffer
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })

-- Format
map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP formatting" })

-- Scroll + center
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- End of line remap (§ → $, Swedish keyboard)
map("n", "§", "$", { desc = "Move to end of line" })
map("v", "§", "$", { desc = "Visual to end of line" })
map("n", "y§", "y$", { desc = "Yank to end of line" })

-- Quickfix navigation
map("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Previous quickfix" })

-- Merge conflicts (only in diff mode)
if vim.wo.diff then
  map("n", "ga", "<cmd>diffget LOCAL<CR>", { desc = "Choose mine" })
  map("n", "gä", "<cmd>diffget REMOTE<CR>", { desc = "Choose theirs" })
end

-- Jump to first merge conflict marker
map("n", "<leader>mc", function()
  vim.fn.setreg("/", [[\V<<<<<<<]])
  vim.cmd("normal! n")
end, { desc = "Find merge conflict marker" })

-- ── Terminal mode ────────────────────────────────────────────
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal" })

-- ── Visual mode ──────────────────────────────────────────────
map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Visual block: don't copy replaced text on paste
map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Paste without yanking", silent = true })

-- ── Buffer navigation (replaces NvChad tabufline) ────────────
map("n", "<S-tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- ── Comment toggle ───────────────────────────────────────────
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- ── NvimTree ─────────────────────────────────────────────────
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvimtree" })

-- ── Telescope ────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find all" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help page" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Bookmarks" })

-- ── NvTerm ───────────────────────────────────────────────────
-- Terminal mode
map("t", "<A-i>", function() require("nvterm.terminal").toggle("float") end, { desc = "Toggle floating term" })
map("t", "<A-h>", function() require("nvterm.terminal").toggle("horizontal") end, { desc = "Toggle horizontal term" })
map("t", "<A-v>", function() require("nvterm.terminal").toggle("vertical") end, { desc = "Toggle vertical term" })
-- Normal mode
map("n", "<leader>ö", function() require("nvterm.terminal").toggle("float") end, { desc = "Toggle floating term" })
map("n", "<A-h>", function() require("nvterm.terminal").toggle("horizontal") end, { desc = "Toggle horizontal term" })
map("n", "<A-v>", function() require("nvterm.terminal").toggle("vertical") end, { desc = "Toggle vertical term" })
map("n", "<leader>h", function() require("nvterm.terminal").new("horizontal") end, { desc = "New horizontal term" })
map("n", "<leader>v", function() require("nvterm.terminal").new("vertical") end, { desc = "New vertical term" })

-- ── Which-key ────────────────────────────────────────────────
map("n", "<leader>wK", function() vim.cmd("WhichKey") end, { desc = "Which-key all keymaps" })
map("n", "<leader>wk", function()
  local input = vim.fn.input("WhichKey: ")
  vim.cmd("WhichKey " .. input)
end, { desc = "Which-key query lookup" })
