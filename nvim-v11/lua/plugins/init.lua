return {
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Core / UI
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  { "nvim-lua/plenary.nvim", lazy = false },

  -- Theme
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("night-owl").setup({ transparent_background = true })
      vim.cmd.colorscheme("night-owl")
      vim.api.nvim_set_hl(0, "LineNr", { fg = "gray" })
    end,
  },

  -- Statusline 
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            {
              -- Show attached LSP clients
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, c in ipairs(clients) do
                  if c.name ~= "null-ls" then
                    table.insert(names, c.name)
                  end
                end
                if #names == 0 then return "" end
                return "  " .. table.concat(names, ", ")
              end,
            },
            "encoding",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
          },
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          separator_style = "thin",
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Editor enhancements
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup()
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = { char = "▏" },
        scope = { enabled = true },
        exclude = {
          filetypes = {
            "help", "terminal", "lazy", "lspinfo",
            "TelescopePrompt", "TelescopeResults", "mason", "",
          },
          buftypes = { "terminal" },
        },
      })
    end,
  },

  -- Smart color column
  {
    "m4xshen/smartcolumn.nvim",
    lazy = false,
    opts = {
      custom_colorcolumn = {
        python = "88",
        ocaml = "90",
      },
    },
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Treesitter
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "python", "go",
          "css", "html", "javascript", "typescript", "tsx", "svelte", "json",
          "markdown", "markdown_inline", "toml",
          "ocaml",
        },
        auto_install = true,
      })
      -- Neovim 0.11: start treesitter highlighting for every buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
      -- Also start for the current buffer immediately
      pcall(vim.treesitter.start)
    end,
  },

  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost", "BufNewFile" } },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Git
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local function bmap(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          bmap("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to next hunk" })
          bmap("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to prev hunk" })
          -- Actions
          bmap("n", "<leader>rh", gs.reset_hunk, { desc = "Reset hunk" })
          bmap("n", "<leader>ph", gs.preview_hunk, { desc = "Preview hunk" })
          bmap("n", "<leader>gb", function() gs.blame_line() end, { desc = "Blame line" })
          bmap("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
        end,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    config = function()
      require("diffview").setup()
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  LSP / Mason / Formatting
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌",
          },
        },
        max_concurrent_installers = 10,
      })
      -- Custom command to install all listed binaries
      local ensure_installed = {
        "debugpy", "black", "mypy", "ruff",
        "gopls",
        "html-lsp", "css-lsp", "cssmodules-language-server",
        "svelte-language-server", "tailwindcss-language-server",
        "typescript-language-server", "emmet-language-server", "eslint-lsp",
        "lua-language-server",
      }
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
      end, {})
    end,
  },

  -- nvim-lspconfig provides base server configs used by lsp/ files
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },

  -- none-ls (formatting + linting via null-ls API)
  {
    "nvimtools/none-ls.nvim",
    ft = { "python", "go", "javascript", "typescript", "svelte", "html", "css", "ocaml" },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
      null_ls.setup({
        sources = {
          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.mypy.with({
            extra_args = function()
              local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
              return { "--python-executable", virtual .. "/bin/python3" }
            end,
          }),
          -- Go
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.diagnostics.golangci_lint,
          -- JavaScript / Web
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "svelte", "html", "css" },
          }),
          -- OCaml
          null_ls.builtins.formatting.ocamlformat,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting")
            or client.server_capabilities.documentFormattingProvider
          then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Completion
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet engine
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          -- vscode format snippets
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })
          -- snipmate format
          require("luasnip.loaders.from_snipmate").load()
          require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })
          -- lua format
          require("luasnip.loaders.from_lua").load()
          require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

          vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
              if
                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                and not require("luasnip").session.jump_active
              then
                require("luasnip").unlink_current()
              end
            end,
          })
        end,
      },
      -- Auto-pairs
      {
        "windwp/nvim-autopairs",
        opts = { fast_wrap = {}, disable_filetype = { "TelescopePrompt", "vim" } },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
      },
      -- Sources
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      -- Icons
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      local function border(hl_name)
        return {
          { "╭", hl_name }, { "─", hl_name }, { "╮", hl_name },
          { "│", hl_name }, { "╯", hl_name }, { "─", hl_name },
          { "╰", hl_name }, { "│", hl_name },
        }
      end

      cmp.setup({
        completion = { completeopt = "menu,menuone" },
        window = {
          completion = {
            border = border("CmpBorder"),
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            scrollbar = false,
          },
          documentation = {
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
      })
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Navigation / File management
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Comment
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = { enable = true, update_root = false },
        view = {
          adaptive_size = false,
          side = "left",
          width = 30,
          preserve_window_proportions = true,
        },
        git = { enable = false, ignore = true },
        filesystem_watchers = { enable = true },
        actions = { open_file = { resize_window = true } },
        renderer = {
          root_folder_label = false,
          highlight_git = false,
          highlight_opened_files = "none",
          indent_markers = { enable = false },
          icons = {
            show = { file = true, folder = true, folder_arrow = true, git = false },
          },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope-fzf-native.nvim" },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg", "-L", "--color=never", "--no-heading",
            "--with-filename", "--line-number", "--column", "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules" },
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          mappings = { n = { ["q"] = require("telescope.actions").close } },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Which-key
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local map = vim.keymap.set
      map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
      map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      map("n", "H", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      map("n", "J", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      map("n", "K", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      map("n", "L", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  DAP (Debugging)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local map = vim.keymap.set

      -- Keymaps
      map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
      map("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
      map("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
      map("n", "<leader>ds", function() dap.step_over() end, { desc = "Step over" })
      map("n", "<leader>di", function() dap.step_into() end, { desc = "Step into" })
      map("n", "<leader>dq", function()
        dap.close()
        require("dapui").close()
      end, { desc = "Close DAP" })
      map("n", "<leader>djs", function()
        require("dap.ext.vscode").load_launchjs()
        print("Loaded launch.json configurations")
      end, { desc = "Load launch.json" })

      -- Visuals
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
      dap.defaults.fallback.focus_terminal = true
      dap.defaults.fallback.terminal_win_cmd = "vsplit new"
      dap.defaults.fallback.external_terminal = {
        command = "tmux",
        args = { "split-pane", "-h" },
      }

      -- Virtual text
      local virtual_text_initialized = false
      dap.listeners.after.event_initialized["dap-virtual-text"] = function()
        if not virtual_text_initialized then
          require("nvim-dap-virtual-text").setup()
          virtual_text_initialized = true
        end
      end

      -- OCaml adapters
      dap.adapters.ocamlearlybird = {
        type = "executable",
        command = "ocamlearlybird",
        args = { "debug" },
      }
      dap.configurations.ocaml = {
        {
          name = "OCaml Debug test.bc",
          type = "ocamlearlybird",
          request = "launch",
          program = "${workspaceFolder}/_build/default/test/test.bc",
        },
        {
          name = "OCaml Debug main.bc",
          type = "ocamlearlybird",
          request = "launch",
          program = "${workspaceFolder}/_build/default/bin/main.bc",
          console = "externalTerminal",
          onlyDebugGlob = "<${workspaceFolder}/**/*>",
        },
        {
          type = "ocamlearlybird",
          request = "launch",
          name = "Run ocaml earlybird",
          program = function()
            return coroutine.create(function(coro)
              local finders = require("telescope.finders")
              local pickers = require("telescope.pickers")
              local conf = require("telescope.config").values
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              pickers
                .new({}, {
                  prompt_title = "Path to executable",
                  finder = finders.new_oneshot_job({ "fd", "--no-ignore", "--type", "x", "--full-path", "_build/.*" }, {}),
                  sorter = conf.generic_sorter({}),
                  attach_mappings = function(buffer_number)
                    actions.select_default:replace(function()
                      actions.close(buffer_number)
                      coroutine.resume(coro, action_state.get_selected_entry()[1])
                    end)
                    return true
                  end,
                })
                :find()
            end)
          end,
        },
      }
    end,
  },

  { "nvim-neotest/nvim-nio" },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })
    end,
  },

  {
    "folke/neodev.nvim",
    opts = {},
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 20,
          },
          {
            elements = {
              { id = "repl", size = 1.0 },
            },
            position = "bottom",
            size = 20,
          },
        },
      })

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>do", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
      map("n", "<leader>dh", function() dapui.eval(nil, { enter = true }) end, { desc = "DAP eval under cursor" })
      map("v", "<leader>dh", function() dapui.eval(nil, { enter = true }) end, { desc = "DAP eval selection" })

      -- Auto open/close
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)

      vim.keymap.set("n", "<leader>dt", function()
        local dap = require("dap")
        dap.defaults.fallback.focus_terminal = true
        dap.defaults.fallback.terminal_win_cmd = "vsplit new"
        dap.defaults.fallback.external_terminal = {
          command = "tmux",
          args = { "split-pane", "-h" },
        }
        require("dap-python").test_method()
      end, { desc = "Debug test method" })

      -- Visuals
      vim.api.nvim_set_hl(0, "DapStopped", { bg = "#31353f" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
    end,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  AI / Copilot
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = true,
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = { position = "bottom", ratio = 0.4 },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 200,
          keymap = {
            accept = "<C-y>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          go = false,
          ocaml = false,
          ml = false,
          ["."] = false,
        },
        copilot_node_command = "node",
        server_opts_overrides = {},
      })
    end,
  },

  {
    "johnseth97/codex.nvim",
    lazy = true,
    cmd = { "Codex", "CodexToggle" },
    keys = {
      {
        "<leader>cc",
        function() require("codex").toggle() end,
        desc = "Toggle Codex popup",
      },
    },
    opts = {
      keymaps = { toggle = nil, quit = "<C-q>" },
      border = "rounded",
      width = 0.8,
      height = 0.8,
      model = nil,
      autoinstall = true,
    },
  },

  {
    "milanglacier/minuet-ai.nvim",
    lazy = false,
    version = false,
    enabled = false, -- disabled (enable if copilot not used)
    config = function()
      require("minuet").setup({
        provider = "openai",
        model = "openai/gpt-4.1-mini",
        virtualtext = {
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = { ".env", ".env*" },
          keymap = { accept = "<C-y>", dismiss = "<A-e>" },
        },
      })
    end,
  },

  {
    "yetone/avante.nvim",
    lazy = true,
    keys = {
      {
        "<leader>as",
        function() require("avante.api").ask() end,
        desc = "Start and ask Avante",
      },
    },
    version = false,
    opts = {
      provider = "openai",
      providers = {
        openai = {
          model = "gpt-4.1-mini",
          extra_request_body = { temperature = 0, max_tokens = 8192 },
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --  Language-specific
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Go
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function()
      require("gopher").setup()
      vim.keymap.set("n", "<leader>gsj", "<cmd>GoAddTag json<CR>", { desc = "Add json struct tags" })
      vim.keymap.set("n", "<leader>gsy", "<cmd>GoAddTag yaml<CR>", { desc = "Add yaml struct tags" })
    end,
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Tailwind
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { document_color = { kind = "background" } },
  },

  -- Svelte / HTML / JS
  { "othree/html5.vim", ft = "html" },
  { "pangloss/vim-javascript", ft = "javascript" },
  {
    "evanleck/vim-svelte",
    ft = { "svelte", "js", "ts", "javascript", "typescript" },
    dependencies = { "pangloss/vim-javascript", "othree/html5.vim" },
  },

  -- Custom local plugin
  {
    name = "nvim-pandas",
    dir = "~/projects/nvim-pandas.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = false,
    config = function(_, opts)
      require("nvim-pandas").setup(opts)
    end,
  },

  -- Leetcode
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    cmd = "Leet",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "python3",
      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
    },
  },

  -- Remote SSH
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    lazy = true,
    opts = {},
  },
}
