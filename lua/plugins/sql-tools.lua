-- ~/.config/nvim/lua/plugins/sql-tools.lua
return {
  -- Override SQL formatting to use PostgreSQL dialect (common in Django)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff" },
      },
      formatters = {
        sqlfluff = {
          args = { "format", "--dialect=postgres", "-" }, -- Change to postgres or mysql as needed
        },
      },
    },
  },

  -- vim-dadbod-ui: salva queries executadas em pasta fixa (em vez do default
  -- espalhado por buffers sem nome) e evita popular a UI com todo .sql do cwd.
  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui_queries"
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Configure database connections
  -- Add this to your project's .lazy.lua (gitignored file) or here for global config
  -- Example:
  -- vim.g.dbs = {
  --   dev = "postgresql://user:password@localhost:5432/dbname",
  --   local = "sqlite:///path/to/db.sqlite3",
  -- }
}
