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
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: Run All" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle() end, desc = "Test: Toggle Watch" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          }),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd("Trouble quickfix")
          end,
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

      -- Custom terminal shortcuts
      local Terminal = require("toggleterm.terminal").Terminal

      -- Python REPL
      local python_repl = Terminal:new({ cmd = "python", hidden = true })
      function _PYTHON_TOGGLE()
        python_repl:toggle()
      end

      -- Docker
      local docker_logs = Terminal:new({ cmd = "docker-compose logs -f", hidden = true })
      function _DOCKER_LOGS()
        docker_logs:toggle()
      end

      -- Git lazygit
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { desc = "Terminal: Python REPL" })
      vim.keymap.set("n", "<leader>tl", "<cmd>lua _DOCKER_LOGS()<cr>", { desc = "Terminal: Docker Logs" })
      vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", { desc = "Terminal: Lazygit" })
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
