-- ~/.config/nvim/lua/plugins/herdr-nvim.lua
-- herdr-nvim: anotações de código enviadas ao agente no pane vizinho do herdr.
-- A barra lateral e o seletor de arquivos vêm do plugin do herdr (`herdr plugin install ChmaraX/herdr-nvim`).
-- Prefixo <leader>H: o padrão <leader>a já é do claudecode.nvim (claude-code.lua), e <leader>h é do Harpoon.
return {
  "ChmaraX/herdr-nvim",
  opts = {
    prefix = "<leader>H",
  },
}
