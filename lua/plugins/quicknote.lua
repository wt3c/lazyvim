-- ~/.config/nvim/lua/plugins/quicknote.lua
-- Quicknote: anotacoes rapidas acumuladas no mesmo documento (escopo global).
return {
  "RutaTang/quicknote.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Telescope" },
  opts = {
    mode = "resident",
    sign = "N",
    filetype = "md",
    git_branch_recognizable = true,
  },
  config = function(_, opts)
    require("quicknote").setup(opts)
  end,
  keys = {
    -- <leader>n sozinho já é "Notification History" (LazyVim/Snacks), por isso
    -- o grupo de notas usa <leader>N para não disputar o bind exato.
    {
      "<leader>Na",
      function()
        require("quicknote").NewNoteAtGlobal()
      end,
      desc = "Nota: adicionar (global)",
    },
    {
      "<leader>No",
      function()
        require("quicknote").OpenNoteAtGlobal()
      end,
      desc = "Nota: abrir (global)",
    },
    {
      "<leader>Nl",
      function()
        require("quicknote").ListNotesForGlobal()
      end,
      desc = "Nota: listar (global)",
    },
    {
      "<leader>Nd",
      function()
        require("quicknote").DeleteNoteAtGlobal()
      end,
      desc = "Nota: deletar (global)",
    },
  },
}
