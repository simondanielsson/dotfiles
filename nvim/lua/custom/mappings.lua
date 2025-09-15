local M = {}
--
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"},
    ["<leader>dr"] = {
      function ()
        require('dap').repl.open()
      end
    },
    ["<leader>dc"] = {
      function ()
        require('dap').continue()
      end
    },
    ["<leader>ds"] = {
      function ()
        require('dap').step_over()
      end
    },
    ["<leader>di"] = {
      function ()
        require('dap').step_into()
      end
    },
    ["<leader>dq"] = {
      function ()
        require('dap').close()
        require('dapui').close()
      end
    },
    ["<leader>djs"] = {
      function ()
        -- load debugging config from .vscode/launch.json
        -- IMPORTANT: `type` must be `python`, and must be a proper json (no incorrect trailing commas)
        require('dap.ext.vscode').load_launchjs()
        print("Loaded launch.json configurations")
      end
    },
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dt"] = {
      function()
        local dap = require('dap')
        dap.defaults.fallback.focus_terminal = true
        dap.defaults.fallback.terminal_win_cmd = 'vsplit new'
        dap.defaults.fallback.external_terminal = {
          command = "tmux",
          args = { "split-pane", "-h" },
        }
        require('dap-python').test_method()
      end
    },
  }
}

M.dapui = {
  plugin = true,
  n = {
    ["<leader>do"] = {
      function ()
        require('dapui').toggle()
      end
    },
    ["<leader>dh"] = {
      -- hover and enter automatically
      function ()
        -- nil as first argumnet to eval will evaluate the expression under the cursor
        require('dapui').eval(nil, { enter = true })
      end
    }
  },
  v = {
    ["<leader>dh"] = {
      -- hover with enter set to true for visual mode
      function()
        local dapui = require('dapui')
        dapui.eval(nil, { enter = true })
      end
    }
  }
}

M.harpoon = {
  plugin = true,
  n = {
    ["<leader>a"] = {
      function()
        require('harpoon'):list():add()
      end
    },
    ["H"] = {
      function ()
        require('harpoon'):list():select(1)
      end
    },

    ["J"] = {
      function ()
        require('harpoon'):list():select(2)
      end
    },
    ["K"] = {
      function ()
        require('harpoon'):list():select(3)
      end
    },
    ["L"] = {
      function ()
        require('harpoon'):list():select(4)
      end
    },
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoAddTag json <CR>",
      "Add json struct tags",
    },
    ["<leader>gsy"] = {
      "<cmd> GoAddTag yaml <CR>",
      "Add yaml struct tags",
    },
  }
}

return M
