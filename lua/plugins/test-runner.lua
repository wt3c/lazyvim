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
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: Run All" },

      -- View results
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle Output Panel" },

      -- Output with auto-open
      { "<leader>tr", function()
        require("neotest").output_panel.open()
        require("neotest").run.run()
      end, desc = "Test: Run + Show Output" },

      { "<leader>tF", function()
        require("neotest").output_panel.open()
        require("neotest").run.run(vim.fn.expand("%"))
      end, desc = "Test: Run File + Show Output" },

      -- Control
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle() end, desc = "Test: Toggle Watch" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },

      -- Navigation
      { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous Failed Test" },
      { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG", "-vv", "--tb=short" }, -- Verbose output
            runner = "pytest",
            python = function()
              local cwd = vim.fn.getcwd()
              for _, venv in ipairs({ ".venv", "venv", "env" }) do
                local path = cwd .. "/" .. venv .. "/bin/python"
                if vim.fn.filereadable(path) == 1 then
                  return path
                end
              end
              return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end,
          }),
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
      templates = { "builtin", "user.python_script", "user.docker_compose" },
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
            cmd = { "python" },
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
          return {
            cmd = { "docker-compose" },
            args = { "up", "-d" },
            components = { "default" },
          }
        end,
      })
    end,
  },

  -- ToggleTerm: Easy terminal management
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Terminal: Toggle", mode = { "n", "t" } },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal: Float" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal: Horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal: Vertical" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      local python_repl = Terminal:new({ cmd = "python", hidden = true })
      local docker_logs = Terminal:new({ cmd = "docker-compose logs -f", hidden = true })
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

      vim.keymap.set("n", "<leader>tp", function() python_repl:toggle() end, { desc = "Terminal: Python REPL" })
      vim.keymap.set("n", "<leader>tl", function() docker_logs:toggle() end, { desc = "Terminal: Docker Logs" })
      vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end, { desc = "Terminal: Lazygit" })
    end,
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
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble: LSP Definitions / References" },
    },
    opts = {}, -- default configuration
  },
}
