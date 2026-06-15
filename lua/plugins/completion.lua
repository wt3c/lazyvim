-- ~/.config/nvim/lua/plugins/completion.lua
-- Ajuste fino do autocomplete (blink.cmp e o motor padrao do LazyVim).
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- Texto fantasma inline com a sugestao atual.
        ghost_text = { enabled = true },
        -- Mostra a documentacao do item automaticamente apos breve delay.
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        -- Realce do trecho que casa com o que foi digitado.
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      -- Assinatura de funcao (parametros) enquanto digita chamadas.
      signature = { enabled = true },
    },
  },
}
