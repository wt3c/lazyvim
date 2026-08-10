-- ~/.config/nvim/lua/plugins/uv-tools.lua
-- uv.nvim: roda/gerencia projeto uv (run/add/remove/sync) sem sair do editor.
-- venv-selector.nvim (extra lang.python) ja ativa venvs criados pelo uv; este
-- plugin cobre o que falta (rodar arquivo/selecao/funcao, gerenciar deps).
return {
  "benomahony/uv.nvim",
  ft = "python",
  opts = {
    picker_integration = true,
    -- prefixo default e <leader>x, que ja e usado por Trouble (xx/xX/xL/xQ/xs/xl)
    -- e pelo LazyVim core (xl/xq) -- move para <leader>U pra nao colidir.
    keymaps = {
      prefix = "<leader>U",
    },
  },
}
