-- ~/.config/nvim/lua/plugins/modern-ui.lua
-- Modern UI/UX improvements
return {
  -- Noice: Modern UI for messages, cmdline, and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      { "<leader>sn", "<cmd>Noice telescope<cr>", desc = "Noice: Messages" },
      { "<leader>sN", "<cmd>Noice last<cr>", desc = "Noice: Last Message" },
      { "<leader>sh", "<cmd>Noice history<cr>", desc = "Noice: History" },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },

  -- Notify: Beautiful notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  -- Dressing: Better default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        win_options = {
          winblend = 0,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        get_config = function()
          return { backend = "telescope", telescope = require("telescope.themes").get_dropdown() }
        end,
      },
    },
  },

  -- Which-key: Show keybindings (LazyVim includes this, but we enhance it)
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code/lsp" },
        { "<leader>d", group = "debug" },
        { "<leader>D", group = "docker" },
        { "<leader>f", group = "find/file" },
        { "<leader>fg", group = "git" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "harpoon" },
        { "<leader>p", group = "python/django" },
        { "<leader>q", group = "quit" },
        { "<leader>r", group = "run" },
        { "<leader>s", group = "search/noice" },
        { "<leader>t", group = "test" },
        { "<leader>T", group = "terminal" },
        { "<leader>u", group = "toggle" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics/trouble" },
      },
    },
  },

  -- Illuminate: Highlight same words under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      vim.keymap.set("n", "]]", function()
        require("illuminate").goto_next_reference(false)
      end, { desc = "Next Reference" })
      vim.keymap.set("n", "[[", function()
        require("illuminate").goto_prev_reference(false)
      end, { desc = "Prev Reference" })
    end,
  },

  -- NOTE: indent guides + scope sao fornecidos pelo snacks.indent (default do
  -- LazyVim). Nao adicionar mini.indentscope para evitar scope duplicado.

  -- Colorizer: Show colors in code
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
      },
    },
  },

  -- Treesitter Context: cabecalho fixo da classe/funcao atual no topo da janela.
  -- Muito util para navegar metodos longos em models/views Django.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>ut",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
    },
  },

  -- Telescope enhancements
  -- O extra editor.telescope (auto-importado via vim.g.lazyvim_picker="telescope")
  -- ja traz fzf-native, setup e defaults robustos. Aqui apenas ESTENDEMOS:
  -- keymaps no esquema <leader>f* (preferencia do usuario) + mappings/pickers extras.
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Better file navigation
      { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep Word" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      -- Diagnostics
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      })
      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
      })
    end,
  },
}
