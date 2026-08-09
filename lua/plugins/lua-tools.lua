-- ~/.config/nvim/lua/plugins/lua-tools.lua
-- lua_ls apontando pro runtime do Neovim: melhora muito autocomplete/diagnostics
-- ao editar esta propria config (vim.*, vim.uv, etc.).
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    },
  },
}
