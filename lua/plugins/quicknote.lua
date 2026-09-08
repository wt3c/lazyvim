-- ~/.config/nvim/lua/plugins/quicknote.lua
-- Quicknote: anotacoes rapidas versionadas no repositorio (.quicknote/ no CWD).
return {
  "RutaTang/quicknote.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    mode = "portable",
    sign = "📝",
    filetype = "md",
  },
  config = function(_, opts)
    require("quicknote").setup(opts)
    require("telescope").load_extension("quicknote")
  end,
  keys = {
    -- <leader>n sozinho já é "Notification History" (LazyVim/Snacks), por isso
    -- o grupo de notas usa <leader>N para não disputar o bind exato.
    -- Escopo CWD (projeto): grava em .quicknote/ na raiz do repositório.
    {
      "<leader>Na",
      function()
        require("quicknote").NewNoteAtCWD()
      end,
      desc = "Nota: adicionar (projeto)",
    },
    {
      "<leader>No",
      function()
        require("quicknote").OpenNoteAtCWD()
      end,
      desc = "Nota: abrir (projeto)",
    },
    {
      "<leader>Nl",
      function()
        require("quicknote").ListNotesForCWD()
      end,
      desc = "Nota: listar (projeto)",
    },
    {
      "<leader>Np",
      "<cmd>Telescope quicknote<cr>",
      desc = "Nota: listar com preview (projeto)",
    },
    {
      "<leader>Nd",
      function()
        require("quicknote").DeleteNoteAtCWD()
      end,
      desc = "Nota: deletar (projeto)",
    },
    -- Escopo arquivo/linha atual.
    {
      "<leader>Nfa",
      function()
        require("quicknote").NewNoteAtCurrentLine()
      end,
      desc = "Nota: adicionar (arquivo/linha)",
    },
    {
      "<leader>Nfo",
      function()
        require("quicknote").OpenNoteAtCurrentLine()
      end,
      desc = "Nota: abrir (arquivo/linha)",
    },
    {
      "<leader>Nfl",
      function()
        require("quicknote").ListNotesForCurrentBuffer()
      end,
      desc = "Nota: listar (arquivo)",
    },
    {
      "<leader>Nfd",
      function()
        require("quicknote").DeleteNoteAtCurrentLine()
      end,
      desc = "Nota: deletar (arquivo/linha)",
    },
  },
  init = function()
    -- Ao entrar em qualquer buffer, mostra na gutter o sinal (ver opts.sign)
    -- nas linhas que têm nota — sem notificação/lista, só o indicador inline.
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("quicknote_show_signs", { clear = true }),
      callback = function()
        require("quicknote").ShowNoteSigns()
      end,
    })
  end,
}
