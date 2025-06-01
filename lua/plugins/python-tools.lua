-- ~/.config/nvim/lua/plugins/python-tools.lua
return {
  -- Gerenciador de LSPs, Formatters e Linters (Mason)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Adiciona pyright e ruff-lsp à lista de `ensure_installed` do Mason
      -- Assim, eles serão instalados automaticamente pelo Mason
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff-lsp", -- LSP do Ruff (para linting e quick fixes)
        -- "black", -- Formatter (alternativa ou complemento ao ruff format)
        "isort", -- Organizador de imports (alternativa ou complemento ao ruff)
        "debugpy", -- Debugger para Python
      })
    end,
  },

  -- Configuração do LSP (nvim-lspconfig)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright para análise de tipo e funcionalidades de linguagem
        pyright = {
          -- Configurações específicas do Pyright, se necessário.
          -- Geralmente, as configurações padrão são boas.
          -- Exemplo: se você quiser que o Pyright use um Python específico:
          -- settings = {
          --   python = {
          --     pythonPath = "/path/to/your/venv/bin/python",
          --   },
          -- },
          -- É importante que o Pyright encontre seu virtualenv.
          -- Ativar o venv ANTES de abrir o Neovim geralmente resolve.
        },
        -- Ruff LSP para linting e formatação (mais rápido que muitos outros)
        ruff_lsp = {
          -- Configurações do ruff-lsp.
          -- Por padrão, ele respeitará seu `pyproject.toml` ou `ruff.toml`.
          -- Para habilitar formatação via ruff-lsp:
          init_options = {
            settings = {
              -- Habilitar formatação através do LSP do Ruff
              format = { args = {} }, -- Usa as configurações padrão do ruff format
            },
          },
        },
      },
      -- Configuração global para todos os LSPs, se necessário
      setup = {
        ruff_lsp = function(_, opts)
          -- Permite que o ruff-lsp também seja um formatador
          -- Isso é importante para o LazyVim/conform.nvim detectar
          require("lspconfig").ruff_lsp.setup(vim.tbl_deep_extend("force", opts, {
            capabilities = vim.lsp.protocol.make_client_capabilities(), -- Pega as capabilities padrão
            on_attach = function(client, bufnr)
              -- Habilitar formatação ao salvar APENAS para buffers com ruff-lsp
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = vim.api.nvim_create_augroup("LspFormatOnSaveRuff", { clear = true }),
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({
                      bufnr = bufnr,
                      async = false,
                      filter = function(c)
                        return c.name == "ruff_lsp"
                      end,
                    })
                  end,
                })
              end
              -- Keymaps específicos do LSP (LazyVim já define os básicos)
              local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
              end
              map("n", "<leader>co", vim.lsp.buf.code_action, "LSP Code Action")
              map("n", "<leader>cf", function()
                vim.lsp.buf.format({
                  filter = function(c)
                    return c.name == "ruff_lsp"
                  end,
                  async = true,
                })
              end, "LSP Format (Ruff)")
            end,
          }))
          return true -- Indica que lidamos com a configuração
        end,
      },
    },
  },

  -- Formatação (Conform.nvim - geralmente já vem com LazyVim, mas vamos garantir Ruff)
  {
    "stevearc/conform.nvim",
    optional = true, -- É opcional porque o ruff-lsp já pode formatar
    opts = {
      -- Define formatters para tipos de arquivo específicos
      formatters_by_ft = {
        python = { "ruff_format" }, -- Preferir `ruff format`
        -- ["*"] = { "prettier" }, -- Exemplo para outros arquivos
      },
      -- Configuração de format-on-save (se não estiver usando o do LSP acima)
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true, -- Tenta o LSP se o formatter falhar
      -- },
    },
  },

  -- Treesitter para melhor highlighting e análise sintática
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Adiciona parsers para Python, Django (HTML), etc.
      vim.list_extend(opts.ensure_installed, {
        "python",
        "html", -- Para templates Django
        "css", -- Para CSS em projetos Django
        "javascript", -- Para JS em projetos Django
        "toml", -- Para pyproject.toml
        "rst", -- Para ReStructuredText (comum em docs Python)
      })
    end,
  },

  -- Depurador (nvim-dap e nvim-dap-python)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui", -- UI para o DAP
      "nvim-neotest/nvim-nio", -- Dependência do nvim-dap
    },
    config = function()
      require("dapui").setup()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python") -- Caminho para o python com debugpy
      -- Você pode instalar debugpy em um venv dedicado ou no seu projeto:
      -- pip install debugpy

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

      -- Keymaps para DAP
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP Step Into" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP Open REPL" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap-python").test_method()
      end, { desc = "DAP Debug Test Method (cursor)" })
      vim.keymap.set("n", "<leader>dj", function() -- 'j' para Django
        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Django: runserver",
            program = "${workspaceFolder}/manage.py",
            args = { "runserver" },
            django = true, -- Importante para Django
            justMyCode = true, -- Para não pular para dentro de bibliotecas por padrão
            -- pythonPath = function() -- Opcional: se precisar especificar o python do venv
            --  return vim.fn.trim(vim.fn.system("poetry env info -p")) -- Exemplo com poetry
            -- end,
          },
        }
        dap.continue()
      end, { desc = "DAP Launch Django Server" })
    end,
  },

  -- Comentários fáceis
  {
    "numToStr/Comment.nvim",
    opts = {}, -- Configurações padrão são boas
    lazy = false, -- Carregar imediatamente
  },

  -- Auto pares de delimitadores
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- Configurações padrão são boas
  },

  -- UI para Telescope (Fuzzy Finder)
  -- LazyVim já o inclui, mas você pode querer customizar os pickers.
  {
    "nvim-telescope/telescope.nvim",
    -- opts = { defaults = { ... } } -- para customizar
  },

  -- Plugins úteis adicionais (muitos já vêm com LazyVim)
  -- { "tpope/vim-fugitive" }, -- Integração Git (LazyVim usa gitsigns.nvim por padrão)
  -- { "tpope/vim-rhubarb" }, -- Necessário para fugitive se usar GitHub
  -- { "lewis6991/gitsigns.nvim", opts = {} }, -- Sinais do Git na gutter (já no LazyVim)
}
