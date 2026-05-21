-- ~/.config/nvim/lua/plugins/python-tools.lua
return {
  -- Mason: Ensure Python tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",      -- Type checker (LSP)
        "ruff",         -- Linter + Formatter (unified LSP)
        "mypy",         -- Strict type checker
        "debugpy",      -- Python debugger
      })
    end,
  },

  -- LSP Configuration: Pyright + Ruff
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright for IDE features (hover, completion, go-to-def)
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- or "strict" for more strictness
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        -- Ruff LSP for linting + formatting (unified)
        ruff = {
          -- Only enable for Python files (not markdown, etc)
          filetypes = { "python" },
          init_options = {
            settings = {
              -- Force line length to 120
              lineLength = 120,
              -- Configuration file path (fallback to global)
              configurationPreference = "filesystemFirst",
              -- Enable all Ruff's LSP features
              lint = {
                enable = true,
                args = {},
              },
              format = {
                enable = true,
                args = { "--line-length=120" },
              },
            },
          },
        },
      },
    },
  },

  -- Formatting: Use Ruff via conform.nvim (Python only)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        -- Explicitly disable for markdown
        markdown = {},
      },
      formatters = {
        ruff_format = {
          prepend_args = { "--line-length=120" },
        },
        ruff_organize_imports = {
          prepend_args = { "--line-length=120" },
        },
      },
    },
  },

  -- Linting: Add Mypy via nvim-lint
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

  -- Treesitter: Ensure Django-related parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "html",          -- Django templates
        "htmldjango",    -- Django-specific HTML
        "css",
        "javascript",
        "toml",          -- pyproject.toml
        "rst",           -- ReStructuredText (docs)
        "sql",           -- SQL (for Django queries)
      })
    end,
  },

  -- Django template filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        extension = {
          html = function(path, bufnr)
            -- If file is in a Django templates directory, treat as htmldjango
            if path:match("templates/.*%.html$") then
              return "htmldjango"
            end
            return "html"
          end,
        },
      })
    end,
  },

  -- DAP: Django debugging setup
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

      local dap, dapui = require("dap"), require("dapui")

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- DAP Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap-python").test_method()
      end, { desc = "Debug Test Method" })

      -- Django runserver debug configuration
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

  -- Virtual Environment Selector (with uv support)
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      -- Search paths for virtual environments
      search_venv_managers = true, -- Search for Poetry, Pipenv, etc
      search_workspace = true,     -- Search for .venv in project root
      search = true,               -- Enable auto-search on startup

      -- Priority order: uv > Poetry > .venv > venv > virtualenvwrapper
      pipenv_path = vim.fn.expand("~/.local/share/virtualenvs"),
      poetry_path = vim.fn.expand("~/.cache/pypoetry/virtualenvs"),
      venvwrapper_path = vim.fn.expand("~/workspace"), -- MPRJ legacy projects

      -- uv-specific: detect .venv in project root
      name = {
        ".venv",
        "venv",
        "env",
      },

      -- Auto-select if only one venv found
      auto_refresh = true,

      -- Show Python version in selection
      show_python_version = true,

      -- Notify on venv change
      notify_user_on_activate = true,
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select VirtualEnv (Cached)" },
    },
    cmd = { "VenvSelect", "VenvSelectCached" },
  },
}
