-- ~/.config/nvim/lua/plugins/modern-ui.lua
-- Modern UI/UX improvements
return {
  -- Noice: Modern UI for messages, cmdline, and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>sn", "<cmd>Noice telescope<cr>", desc = "Noice: Messages" },
      { "<leader>sN", "<cmd>Noice last<cr>", desc = "Noice: Last Message" },
      { "<leader>sh", "<cmd>Noice history<cr>", desc = "Noice: History" },
    },
    opts = {
      -- Os overrides de LSP são fornecidos pelo LazyVim. Não os repetimos
      -- aqui porque stylize_markdown foi depreciado no Neovim 0.12.
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

  -- NOTE: notificações (Snacks.notifier), vim.ui.select/input (dressing via extra
  -- telescope) e destaque de referências com ]] / [[ (Snacks.words) vêm do LazyVim.

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
