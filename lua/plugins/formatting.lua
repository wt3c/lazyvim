-- ~/.config/nvim/lua/plugins/formatting.lua
-- Global formatting configuration with line-length = 120 for all languages

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        lua = { "stylua" },
        toml = { "taplo" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        fish = { "fish_indent" },
        json = { "prettier" },
        yaml = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        stylua = {
          prepend_args = { "--column-width", "120" },
        },
        prettier = {
          prepend_args = function(_, ctx)
            local args = { "--print-width", "120" }
            if ctx.filename:match("%.md$") then
              vim.list_extend(args, { "--prose-wrap", "always" })
            end
            return args
          end,
        },
        shfmt = {
          prepend_args = { "-i", "2", "-bn", "-ci", "-sr" },
        },
      },
    },
  },
}
