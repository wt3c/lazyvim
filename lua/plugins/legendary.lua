-- ~/.config/nvim/lua/plugins/legendary.lua
-- Paleta de comandos estilo VS Code: busca fuzzy de keymaps/comandos/autocmds
-- (renderiza via vim.ui.select -> dressing.nvim -> Telescope, ja configurado em modern-ui.lua)
return {
  "mrjones2014/legendary.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  cmd = "Legendary",
  keys = {
    { "<leader>?", "<cmd>Legendary<cr>", desc = "Legendary: All keymaps/commands" },
  },
  opts = {
    extensions = {
      lazy_nvim = { auto_register = true },
    },
  },
}
