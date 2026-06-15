-- ~/.config/nvim/lua/plugins/docker-tools.lua
return {
  -- Mason: Ensure Docker tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint", -- Dockerfile linter
      })
    end,
  },

  -- Docker Compose syntax and commands
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
        "yaml", -- For docker-compose.yml
      })
    end,
  },

  -- Enhanced Docker support with custom keybindings
  -- These will be defined in keymaps.lua but documented here
  -- <leader>D prefix for Docker commands:
  --   <leader>Du - docker-compose up -d
  --   <leader>Dd - docker-compose down
  --   <leader>Dr - docker-compose restart
  --   <leader>Dl - docker-compose logs -f
  --   <leader>Dp - docker ps
  --   <leader>Di - docker images
  --   <leader>Db - docker-compose build
  --   <leader>De - docker exec -it (select container)
}
