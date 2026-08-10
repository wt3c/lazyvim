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
    -- auto_register so cobre `keys` de specs lazy.nvim; vim.keymap.set() cru em
    -- config/keymaps.lua nao aparece sozinho na paleta. Entradas "anonimas" (sem
    -- handler) so registram para exibicao -- a implementacao real continua em
    -- keymaps.lua, nao duplicar aqui.
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
