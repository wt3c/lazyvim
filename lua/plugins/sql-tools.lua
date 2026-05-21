-- ~/.config/nvim/lua/plugins/sql-tools.lua
return {
  -- Override SQL formatting to use PostgreSQL dialect (common in Django)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        sqlfluff = {
          args = { "format", "--dialect=postgres", "-" }, -- Change to postgres or mysql as needed
        },
      },
    },
  },

  -- Configure database connections
  -- Add this to your project's .lazy.lua (gitignored file) or here for global config
  -- Example:
  -- vim.g.dbs = {
  --   dev = "postgresql://user:password@localhost:5432/dbname",
  --   local = "sqlite:///path/to/db.sqlite3",
  -- }
}
