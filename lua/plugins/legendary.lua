-- ~/.config/nvim/lua/plugins/legendary.lua
-- Paleta de comandos estilo VS Code (busca fuzzy de keymaps/comandos), em cima do
-- which-key padrão do LazyVim (que continua sendo o popup do <leader>) — não o substitui.
return {
  "mrjones2014/legendary.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  cmd = "Legendary",
  keys = {
    -- <leader>? já é "Buffer Keymaps (which-key)" no LazyVim; usar outro atalho.
    { "<leader>sL", "<cmd>Legendary<cr>", desc = "Legendary: All keymaps/commands" },
  },
  opts = {
    extensions = {
      lazy_nvim = { auto_register = true },
      -- importa grupos/itens registrados no which-key (wk.add) automaticamente,
      -- em vez de duplicar manualmente quando esse tipo de registro existir.
      which_key = { auto_register = true },
    },
    -- auto_register cobre `keys` de specs lazy.nvim; vim.keymap.set() cru em
    -- config/keymaps.lua não aparece sozinho na paleta. Entradas "anônimas" (sem
    -- handler) só registram para exibição -- a implementação real continua em
    -- keymaps.lua, não duplicar aqui.
    keymaps = {
      {
        itemgroup = "Docker",
        description = "Comandos Docker/Docker Compose",
        keymaps = {
          { "<leader>Du", description = "Docker: Compose Up" },
          { "<leader>Dd", description = "Docker: Compose Down" },
          { "<leader>Dr", description = "Docker: Compose Restart" },
          { "<leader>Dl", description = "Docker: Logs Follow" },
          { "<leader>Db", description = "Docker: Compose Build" },
          { "<leader>DB", description = "Docker: Build No Cache" },
          { "<leader>Dp", description = "Docker: List Containers" },
          { "<leader>Di", description = "Docker: List Images" },
          { "<leader>Ds", description = "Docker: System Prune" },
          { "<leader>De", description = "Docker: Exec Into Container" },
        },
      },
      {
        itemgroup = "Django/Python",
        description = "Comandos Python/Django",
        keymaps = {
          { "<leader>pr", description = "Python: REPL" },
          { "<leader>pf", description = "Python: Run File" },
          { "<leader>pR", description = "Django: Run Server" },
          { "<leader>pM", description = "Django: Make Migrations" },
          { "<leader>pm", description = "Django: Migrate" },
          { "<leader>ps", description = "Django: Shell" },
          { "<leader>pt", description = "Django: Test" },
          { "<leader>pc", description = "Django: Collect Static" },
          { "<leader>pC", description = "Django: Create Superuser" },
        },
      },
    },
  },
}
