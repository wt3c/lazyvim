-- ~/.config/nvim/lua/plugins/python-tools.lua
return {
  -- Mason: Python tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "mypy",
        "debugpy",
      })
    end,
  },

  -- LSP: Pyright + Ruff
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ruff = {
          filetypes = { "python" },
          init_options = {
            settings = {
              lineLength = 120,
              configurationPreference = "filesystemFirst",
              lint = { enable = true },
              format = { enable = true, args = { "--line-length=120" } },
            },
          },
        },
      },
    },
  },

  -- Linting: Mypy via nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy" },
      },
      linters = {
        mypy = {
          args = {
            "--ignore-missing-imports",
            "--show-column-numbers",
            "--show-error-end",
            "--hide-error-codes",
            "--hide-error-context",
            "--no-color-output",
            "--no-error-summary",
            "--no-pretty",
          },
        },
      },
    },
  },

  -- Treesitter: Python + Django templates + filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "html",
        "htmldjango",
        "css",
        "javascript",
        "toml",
        "rst",
        "sql",
      })
    end,
    init = function()
      vim.filetype.add({
        extension = {
          html = function(path, _)
            if path:match("templates/.*%.html$") then
              return "htmldjango"
            end
            return "html"
          end,
        },
      })
    end,
  },

  -- DAP: Python debugging via Mason-installed debugpy
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()

      local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy)

      local dap, dapui = require("dap"), require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap-python").test_method()
      end, { desc = "Debug Test Method" })
      vim.keymap.set("n", "<leader>dj", function()
        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Django: runserver",
            program = "${workspaceFolder}/manage.py",
            args = { "runserver" },
            django = true,
            justMyCode = true,
          },
        }
        dap.continue()
      end, { desc = "Launch Django Server" })
    end,
  },

  -- Virtual Environment Selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    cmd = { "VenvSelect", "VenvSelectCached" },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select VirtualEnv (Cached)" },
    },
    opts = {
      name = { ".venv", "venv", "env" },
      search_workspace = true,
      notify_user_on_activate = true,
    },
  },
}
