-- ~/.config/nvim/lua/plugins/mason-tools.lua
-- Global Mason tool installation
return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- Só o que o LazyVim e os extras de lazyvim.json não instalam.
      -- Python → python-tools.lua | Docker/SQL/Markdown/JSON/TOML → extras.
      ensure_installed = {
        "yaml-language-server",
        "bash-language-server",
        "shellcheck",
        "prettier",
      },
    },
  },
}
