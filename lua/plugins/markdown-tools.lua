-- ~/.config/nvim/lua/plugins/markdown-tools.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          -- Força o config global (line_length: 120, tables: false) mesmo em
          -- repos sem .markdownlint-cli2.jsonc próprio, já que a busca padrão
          -- não sobe até ~/.config/nvim a partir de projetos fora de $HOME.
          -- --no-globs evita que a chave "globs" do config global vire uma
          -- busca de arquivos no repo inteiro em vez de lint do stdin (-).
          prepend_args = {
            "--config",
            vim.fn.expand("~/.config/nvim/.markdownlint-cli2.jsonc"),
            "--no-globs",
          },
        },
      },
    },
  },
}
