-- ~/.config/nvim/lua/plugins/test-runner.lua
-- Modern test and script execution

return {
  -- Neotest: Modern test runner with UI
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Python adapter
      "nvim-neotest/neotest-python",
    },
    keys = {
      -- Run tests
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run Nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test: Run All",
      },

      -- View results
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test: Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: Toggle Output Panel",
      },

      -- Output with auto-open
      {
        "<leader>tr",
        function()
          require("neotest").output_panel.open()
          require("neotest").run.run()
        end,
        desc = "Test: Run + Show Output",
      },

      {
        "<leader>tF",
        function()
          require("neotest").output_panel.open()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: Run File + Show Output",
      },

      -- Control
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: Stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "Test: Toggle Watch",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Test: Debug Nearest",
      },

      -- Navigation
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous Failed Test",
      },
      {
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next Failed Test",
      },
    },
    opts = function()
      local ignored_discovery_dirs = {
        [".git"] = true,
        [".pytest_cache"] = true,
        [".venv"] = true,
        ["__pycache__"] = true,
      }

      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            -- Sem `-n auto` (exige pytest-xdist) nem log DEBUG: flags extras ficam no pyproject.
            args = { "--tb=short" },
            runner = "pytest",
            python = function()
              return require("config.python").python(0) or "python"
            end,
          }),
        },
        discovery = {
          filter_dir = function(name)
            return not ignored_discovery_dirs[name]
          end,
        },
        -- Show test status in the sign column
        status = {
          virtual_text = true,
          signs = true,
        },
        -- Icons for test status
        icons = {
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          passed = "✓",
          running = "⟳",
          failed = "✗",
          skipped = "⊘",
          unknown = "?",
        },
        -- Automatically open output
        output = {
          enabled = true,
          open_on_run = "short", -- "short" opens only for failed/errors
        },
        -- Output panel config
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        -- Show floating window on run
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.9,
        },
        -- Use Trouble for quickfix
        quickfix = {
          enabled = true,
          open = function()
            if pcall(require, "trouble") then
              vim.cmd("Trouble quickfix")
            else
              vim.cmd("copen")
            end
          end,
        },
        -- Summary window config
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, neotest_ns)

      require("neotest").setup(opts)
    end,
  },

  -- Overseer: Task runner for scripts
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run: Task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Run: Toggle" },
      { "<leader>ri", "<cmd>OverseerInfo<cr>", desc = "Run: Info" },
      { "<leader>ra", "<cmd>OverseerTaskAction<cr>", desc = "Run: Task Action" },
      { "<leader>rl", "<cmd>OverseerLoadBundle<cr>", desc = "Run: Load Bundle" },
      { "<leader>rs", "<cmd>OverseerSaveBundle<cr>", desc = "Run: Save Bundle" },
    },
    opts = {
      templates = {
        "builtin",
        "user.python_script",
        "user.docker_compose",
        "user.django_runserver",
        "user.django_migrate",
        "user.django_makemigrations",
        "user.django_shell",
      },
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 15,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
        },
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)

      -- Custom task templates
      require("overseer").register_template({
        name = "user.python_script",
        builder = function()
          local file = vim.fn.expand("%:p")
          return {
            cmd = { require("config.python").python(0) or "python" },
            args = { file },
            components = { { "on_output_quickfix", open = true }, "default" },
          }
        end,
        condition = {
          filetype = { "python" },
        },
      })

      require("overseer").register_template({
        name = "user.docker_compose",
        builder = function()
          local command, cwd = require("config.docker").compose({ "up", "-d" })
          command = command or { "docker", "compose", "up", "-d" }
          return {
            cmd = { command[1] },
            args = vim.list_slice(command, 2),
            cwd = cwd,
            components = { "default" },
          }
        end,
      })

      -- Django (uv-managed projects) -- so aparecem quando ha manage.py no cwd
      local function has_manage_py()
        return vim.fn.filereadable(vim.fn.getcwd() .. "/manage.py") == 1
      end

      local function django_template(name, args)
        require("overseer").register_template({
          name = name,
          builder = function()
            return {
              cmd = { "uv" },
              args = args,
              components = { "default" },
            }
          end,
          condition = {
            callback = has_manage_py,
          },
        })
      end

      django_template("user.django_runserver", { "run", "python", "manage.py", "runserver" })
      django_template("user.django_migrate", { "run", "python", "manage.py", "migrate" })
      django_template("user.django_makemigrations", { "run", "python", "manage.py", "makemigrations" })
      django_template("user.django_shell", { "run", "python", "manage.py", "shell" })
    end,
  },

  -- Terminais via Snacks.terminal (já vem no LazyVim; substitui o ToggleTerm).
  -- Cada posição usa um `count` próprio para ser um terminal independente.
  {
    "folke/snacks.nvim",
    -- NOTE: terminal usa o prefixo <leader>T (maiusculo) para nao colidir com
    -- os mapeamentos de teste em <leader>t (ex: <leader>tf = Test: Run File).
    keys = {
      {
        "<C-\\>",
        function()
          Snacks.terminal.toggle(nil, { count = 1, win = { position = "float" } })
        end,
        desc = "Terminal: Toggle",
        mode = { "n", "t" },
      },
      {
        "<leader>Tf",
        function()
          Snacks.terminal.toggle(nil, { count = 1, win = { position = "float" } })
        end,
        desc = "Terminal: Float",
      },
      {
        "<leader>Th",
        function()
          Snacks.terminal.toggle(nil, { count = 2, win = { position = "bottom" } })
        end,
        desc = "Terminal: Horizontal",
      },
      {
        "<leader>Tv",
        function()
          Snacks.terminal.toggle(nil, { count = 3, win = { position = "right" } })
        end,
        desc = "Terminal: Vertical",
      },
      {
        "<leader>Tp",
        function()
          local python = require("config.python")
          Snacks.terminal.toggle({ python.python(0) or "python" }, { cwd = python.root(0) })
        end,
        desc = "Terminal: Python REPL",
      },
      {
        "<leader>Tl",
        function()
          local command, cwd = require("config.docker").compose({ "logs", "-f" })
          if not command then
            vim.notify("Docker Compose não encontrado", vim.log.levels.ERROR)
            return
          end
          Snacks.terminal.toggle(command, { cwd = cwd })
        end,
        desc = "Terminal: Docker Logs",
      },
      {
        "<leader>Tg",
        function()
          Snacks.terminal.toggle({ "lazygit" })
        end,
        desc = "Terminal: Lazygit",
      },
    },
  },

  -- Trouble: Better diagnostics and quickfix list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer Diagnostics" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix List" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble: Symbols" },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "Trouble: LSP Definitions / References",
      },
    },
    opts = {}, -- default configuration
  },
}
