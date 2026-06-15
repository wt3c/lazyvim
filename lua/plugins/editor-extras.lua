-- ~/.config/nvim/lua/plugins/editor-extras.lua
-- Plugins de navegacao/edicao adicionais.
return {
  -- Spectre: search & replace no projeto inteiro (com preview e regex).
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").toggle()
        end,
        desc = "Replace in Files (Spectre)",
      },
      {
        "<leader>sr",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        mode = "v",
        desc = "Replace Word (Spectre)",
      },
    },
  },

  -- Harpoon 2: marcar arquivos e saltar entre eles instantaneamente.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon: Add File",
      },
      {
        "<leader>hh",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "Harpoon: Quick Menu",
      },
      {
        "<leader>hp",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon: Prev File",
      },
      {
        "<leader>hn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon: Next File",
      },
      {
        "<leader>h1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon: File 1",
      },
      {
        "<leader>h2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon: File 2",
      },
      {
        "<leader>h3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon: File 3",
      },
      {
        "<leader>h4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon: File 4",
      },
    },
  },

  -- Oil: editar diretorios como um buffer normal (criar/renomear/mover arquivos).
  -- Nao assume o explorer padrao (neo-tree do LazyVim continua em <leader>e).
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory (Oil)" },
    },
    opts = {
      default_file_explorer = false,
      view_options = { show_hidden = true },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
  },
}
