-- ~/.config/nvim/lua/plugins/python-tools.lua

-- Ruff code actions (fix all / organize imports) como keymaps buffer-local.
-- O conform ja roda ruff_format + ruff_organize_imports no save; estes atalhos
-- permitem aplicar sob demanda sem salvar.
local function system_python()
  for _, executable in ipairs({ "python3", "python" }) do
    local path = vim.fn.exepath(executable)
    if path ~= "" then
      return path
    end
  end
  return "python"
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ruff_code_actions", { clear = true }),
  pattern = "python",
  callback = function(args)
    local function ruff_action(kind)
      return function()
        vim.lsp.buf.code_action({
          context = { only = { kind }, diagnostics = {} },
          apply = true,
        })
      end
    end
    local opts = { buf = args.buf, silent = true }
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

  -- DAP Python: o ciclo de vida/UI/atalhos gerais ficam com o extra dap.core.
  -- Aqui mantemos apenas a resolução do debugpy e o perfil específico do Django.
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      {
        "<leader>dPr",
        function()
          local dap = require("dap")
          for _, config in ipairs(dap.configurations.python or {}) do
            if config.name == "Django: runserver" then
              dap.run(config)
              return
            end
          end
          vim.notify("Perfil DAP do Django não encontrado", vim.log.levels.ERROR)
        end,
        desc = "Python: Debug Django runserver",
        ft = "python",
      },
    },
    config = function()
      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local debugpy_adapter = vim.fn.exepath("debugpy-adapter")
      local debugpy = debugpy_adapter ~= "" and debugpy_adapter
        or (vim.fn.executable(mason_debugpy) == 1 and mason_debugpy or system_python())
      require("dap-python").setup(debugpy)

      local dap = require("dap")

      -- Não duplica o perfil ao recarregar a spec durante ajustes da configuração.
      dap.configurations.python = dap.configurations.python or {}
      local has_django = vim.iter(dap.configurations.python):any(function(config)
        return config.name == "Django: runserver"
      end)
      if not has_django then
        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Django: runserver",
          program = "${workspaceFolder}/manage.py",
          args = { "runserver" },
          django = true,
          justMyCode = true,
        })
      end
    end,
  },

  -- NOTE: venv-selector.nvim ja e configurado pelo extra lang.python do LazyVim
  -- (keymap <leader>cv, API nova com opts.options.*). O override anterior usava a
  -- API antiga (name/search_workspace) e era ignorado -- por isso foi removido.
}
