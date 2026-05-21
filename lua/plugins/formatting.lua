-- ~/.config/nvim/lua/plugins/formatting.lua
-- Global formatting configuration with line-length = 120 for all languages

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
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
          prepend_args = { "--print-width", "120" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-bn", "-ci", "-sr" },
        },
      },
    },
  },
}
