-- ~/.config/nvim/lua/plugins/python-tools.lua

-- Ruff code actions (fix all / organize imports) como keymaps buffer-local.
-- O conform ja roda ruff_format + ruff_organize_imports no save; estes atalhos
-- permitem aplicar sob demanda sem salvar.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ruff_code_actions", { clear = true }),
  pattern = "python",
  callback = function(args)
    local function ruff_action(kind, desc)
      return function()
        vim.lsp.buf.code_action({
          context = { only = { kind }, diagnostics = {} },
          apply = true,
        })
      end
    end
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set(
      "n",
      "<leader>cR",
      ruff_action("source.fixAll.ruff"),
      vim.tbl_extend("force", opts, { desc = "Ruff: Fix All" })
    )
    vim.keymap.set(
      "n",
      "<leader>co",
      ruff_action("source.organizeImports.ruff"),
      vim.tbl_extend("force", opts, { desc = "Ruff: Organize Imports" })
    )
  end,
})

return {
  -- Mason: Python tools
  {
    "mason-org/mason.nvim",
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
              -- Formatacao e organizada pelo conform (ruff_format + ruff_organize_imports).
              -- Manter o LSP fora disso evita duas fontes de formatacao em conflito.
              format = { enable = false },
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

      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local debugpy = vim.fn.executable(mason_debugpy) == 1 and mason_debugpy
        or vim.fn.exepath("python3")
        or vim.fn.exepath("python")
        or "python"
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

      -- Registrar config Django no init (não sobrescreve outras configs ao pressionar tecla)
      dap.configurations.python = dap.configurations.python or {}
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Django: runserver",
        program = "${workspaceFolder}/manage.py",
        args = { "runserver" },
        django = true,
        justMyCode = true,
      })

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap-python").test_method()
      end, { desc = "Debug Test Method" })
      vim.keymap.set("n", "<leader>dj", function()
        for _, config in ipairs(dap.configurations.python or {}) do
          if config.name == "Django: runserver" then
            dap.run(config)
            return
          end
        end
      end, { desc = "Launch Django Server" })
    end,
  },

  -- NOTE: venv-selector.nvim ja e configurado pelo extra lang.python do LazyVim
  -- (keymap <leader>cv, API nova com opts.options.*). O override anterior usava a
  -- API antiga (name/search_workspace) e era ignorado -- por isso foi removido.
}
