local plugins = {
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    lazy = true,
    opts = {
        -- Refer to the configuration section below
        -- or leave empty for defaults
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    "m4xshen/smartcolumn.nvim",
    lazy = false,
    opts = {
      custom_colorcolumn = {
        python = "88",
        ocaml = "90",
      },
    }
  },
  {
      "kawre/leetcode.nvim",
      build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
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
            toggle = { "q" }, ---@type string|string[]
            confirm = { "<CR>" }, ---@type string|string[]

            reset_testcases = "r", ---@type string
            use_testcase = "U", ---@type string
            focus_testcases = "H", ---@type string
            focus_result = "L", ---@type string
        },
      },
  },
  {
    'milanglacier/minuet-ai.nvim',
    lazy = false,
    version = false,
    config = function()
        require('minuet').setup {
          provider = 'openai',
          model = "openai/gpt-4.1-mini",
          virtualtext = {
              auto_trigger_ft = {'*'},
              auto_trigger_ignore_ft = {'.env', '.env*'},
              keymap = {
                  accept = '<C-y>',
                  dismiss = '<A-e>',
              },
          },
        }
    end,
  },
  {
    "yetone/avante.nvim",
    -- event = "VeryLazy",
    lazy = true,
    keys = {
      {
        "<leader>as",
        function()
          require("avante.api").ask()
        end,
        desc = "Start and ask Avante",
      },
    },
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      -- for example
      provider = "openai",
      providers = {
        openai = {
          model = "gpt-4.1-mini",
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
          }
        },
      },
      -- provider = "openai",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- timeout in milliseconds
      --   temperature = 0, -- adjust if needed
      --   max_tokens = 4096,
      --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require('nvim-dap-virtual-text').setup({
        virt_text_pos = "eol",
      })
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      document_color = {
        kind = "background"
      }
    }
  },
  {
    "othree/html5.vim",
    ft = "html",
  },
  {
    "pangloss/vim-javascript",
    ft = "javascript",
  },
  {
    "evanleck/vim-svelte",
    ft = {"svelte", "js", "ts", "javascript", "typescript" },
    dependencies = {
      "pangloss/vim-javascript",
      "othree/html5.vim",
    },
    config = function(_, opts)
      require("vim-svelte").setup(opts)
    end
  },
  {
    "olexsmir/gopher.nvim",
    ft= "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()'
  },
  {
    name = "nvim-pandas",
    dir = "~/projects/nvim-pandas.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = false,
    config = function(_, opts)
      require('nvim-pandas').setup(opts)
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      -- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      --
      -- vim.keymap.set("n", "<H>", function() harpoon:list():select(1) end)
      -- vim.keymap.set("n", "<J>", function() harpoon:list():select(2) end)
      -- vim.keymap.set("n", "<K>", function() harpoon:list():select(3) end)
      -- vim.keymap.set("n", "<L>", function() harpoon:list():select(4) end)

      -- for some reason, C-e cannot be set in the mapping module
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      require("core.utils").load_mappings("harpoon")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "folke/neodev.nvim",
    opts = {},
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function ()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  {
    -- used by nvim-dap-ui
    "nvim-neotest/nvim-nio",
  },
  {
    -- TODO: toggle nvim-tree when attaching debugger
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        -- set debug terminal in vertical split
        layouts = { {
          elements = { {
            id = "scopes",
            size = 0.25
            }, {
              id = "breakpoints",
              size = 0.25
            }, {
              id = "stacks",
              size = 0.25
            }, {
              id = "watches",
              size = 0.25
            } },
          position = "left",
          size = 20
        }, {
            elements = {
            -- disable if using external console
            -- {
            --   id = "console",
            --   size = 0.5
            -- }, 
              {
                id = "repl",
                size = 1.0
            }, },
            position = "bottom",
            size = 20
          }, 
        },
      })
      require("core.utils").load_mappings("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function (_, opts)
      require("core.utils").load_mappings("dap")
      vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      local dap = require('dap')
      dap.defaults.fallback.focus_terminal = true
      dap.defaults.fallback.terminal_win_cmd = 'vsplit new'
      dap.defaults.fallback.external_terminal = {
        command = "tmux",
        args = { "split-pane", "-h" },
      }
      -- Add virtual text
      local virtual_text_initialized = false
      dap.listeners.after.event_initialized["dap-virtual-text"] = function()
        if not virtual_text_initialized then
          require('nvim-dap-virtual-text').setup()
          virtual_text_initialized = true
        end
      end
      -- Ocaml adapters
      dap.adapters.ocamlearlybird = {
        type = 'executable',
        command = 'ocamlearlybird',
        args = { 'debug' }
      }
      dap.configurations.ocaml = {
        {
          name = 'OCaml Debug test.bc',
          type = 'ocamlearlybird',
          request = 'launch',
          program = '${workspaceFolder}/_build/default/test/test.bc',
        },
        {
          name = 'OCaml Debug main.bc',
          type = 'ocamlearlybird',
          request = 'launch',
          program = '${workspaceFolder}/_build/default/bin/main.bc',
          console = "externalTerminal",
          onlyDebugGlob = "<${workspaceFolder}/**/*>",
        },
        {
            type = "ocamlearlybird",
            request = "launch",
            name = "Run ocaml earlybird",
            program = function()
              return coroutine.create(function(coro)
                local opts = {}
                local finders = require("telescope.finders")
                local pickers = require("telescope.pickers")
                local conf = require("telescope.config").values
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                pickers.new(opts, {
                    prompt_title = "Path to executable",
                    finder = finders.new_oneshot_job( { "fd", "--no-ignore", "--type", "x", "--full-path", "_build/.*" }, {}),
                    sorter = conf.generic_sorter(opts),
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
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      -- local path = require('venv-selector').get_active_path()
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")

      --
      -- set visuals
      vim.api.nvim_set_hl(0, 'DapStopped', { bg='#31353f' } )
      vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    -- TODO: DISABLED FOR NOW
    enabled = false,
    event = "InsertEnter",
    config = function()
      require('copilot').setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
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
          -- python = false,
          ["."] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python", "go", "javascript", "typescript", "svelte", "html", "css", "js", "ts", "ocaml"},
    opts = function ()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "black",
        "pyright",
        "mypy",
        "ruff",
        "gopls",
        "html-lsp",
        "css-lsp",
        "cssmodules-language-server",
        "svelte-language-server",
        "tailwindcss-language-server",
        "ts_ls",
        "emmet-language-server",
        "eslint-lsp",
        -- ocaml
        -- "ocaml-lsp",
        -- "ocamlformat",
      },
      auto_update = true,
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}
return plugins
