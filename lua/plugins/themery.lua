-- ~/.config/nvim/lua/plugins/themery.lua
-- Gerenciador de temas: seletor com live preview + persistencia entre sessoes.
-- lazy=false (spec recomendado pelo proprio plugin) para que loadState() rode
-- cedo e restaure o colorscheme salvo antes do LazyVim aplicar o default.
return {
  "zaldih/themery.nvim",
  lazy = false,
  keys = {
    { "<leader>uc", "<cmd>Themery<cr>", desc = "Themery: Switch colorscheme" },
  },
  opts = {
    themes = {
      { name = "Tokyo Night (Night)", colorscheme = "tokyonight-night" },
      { name = "Tokyo Night (Storm)", colorscheme = "tokyonight-storm" },
      { name = "Tokyo Night (Moon)", colorscheme = "tokyonight-moon" },
      { name = "Tokyo Night (Day)", colorscheme = "tokyonight-day" },
      { name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
      { name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
      { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
      { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
    },
    livePreview = true,
  },
}
