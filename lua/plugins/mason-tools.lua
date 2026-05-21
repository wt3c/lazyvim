-- ~/.config/nvim/lua/plugins/mason-tools.lua
-- Global Mason tool installation
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "pyright",
        "ruff",
        "mypy",
        "debugpy",

        -- SQL
        "sqlfluff",

        -- Docker
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint", -- Dockerfile linter

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

        -- General
        "stylua", -- Lua formatter
      },
    },
  },
}
