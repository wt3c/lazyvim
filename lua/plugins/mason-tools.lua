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
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      -- Os adaptadores já estão no ensure_installed do Mason. Instalar por aqui também
      -- gera, no primeiro boot, o erro "Package is already installing".
      automatic_installation = false,
    },
  },
}
