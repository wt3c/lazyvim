-- ~/.config/nvim/lua/plugins/mason-tools.lua
-- Global Mason tool installation
return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- Ferramentas globais não gerenciadas por arquivos de feature específicos.
      -- Python → python-tools.lua | Docker → docker-tools.lua
      ensure_installed = {
        -- SQL
        "sqlfluff",

        -- Markdown
        "marksman",
        "markdownlint-cli2",
        "markdown-toc",

        -- JSON/YAML
        "json-lsp",
        "yaml-language-server",

        -- Shell
        "bash-language-server",
        "shfmt",
        "shellcheck",

        -- TOML
        "taplo",

        -- General
        "stylua",
        "prettier",
      },
    },
  },
}
