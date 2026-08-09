-- ~/.config/nvim/lua/plugins/jupyter-tools.lua
-- Jupyter (.ipynb) no Neovim:
--   jupytext.nvim -> converte .ipynb <-> texto (markdown/python) ao abrir/salvar
--   molten-nvim   -> executa celulas contra um kernel Jupyter real, output inline
--   image.nvim    -> renderiza imagens/plots inline (SO funciona no terminal Kitty;
--                     Alacritty, o $terminal default do Hyprland, nao suporta o
--                     protocolo de graficos Kitty -- fora do Kitty, molten ainda
--                     roda celulas normalmente, so sem os plots).
return {
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },

  {
    "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    opts = {
      backend = "kitty",
      processor = "magick_rock",
      max_width_window_percentage = 100,
      max_height_window_percentage = 50,
    },
  },

  {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim" },
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    ft = { "python", "markdown", "quarto" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 12
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten: Init Kernel" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten: Evaluate Operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten: Evaluate Line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten: Re-evaluate Cell" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Molten: Evaluate Visual" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten: Show Output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Molten: Hide Output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten: Delete Cell" },
      { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "Molten: Interrupt" },
      { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten: Restart Kernel" },
    },
  },
}
