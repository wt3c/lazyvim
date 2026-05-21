-- ~/.config/nvim/lua/plugins/comments.lua
-- Enhanced comment configuration

return {
  -- LazyVim uses mini.comment by default
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = nil,
        ignore_blank_line = false,
        start_of_line = false,
        pad_comment_parts = true,
      },
      mappings = {
        -- Toggle comment on current line (Normal mode)
        comment = "gcc",
        -- Toggle comment on visual selection
        comment_visual = "gc",
        -- Define 'comment' textobject
        textobject = "gc",
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)

      -- Additional keymaps for convenience
      local keymap = vim.keymap.set

      -- Ctrl+/ (most terminals send this as Ctrl+_)
      keymap("n", "<C-_>", "gcc", { remap = true, desc = "Comment line", silent = true })
      keymap("v", "<C-_>", "gc", { remap = true, desc = "Comment selection", silent = true })

      -- Ctrl+/ (try this too, works in some terminals)
      keymap("n", "<C-/>", "gcc", { remap = true, desc = "Comment line", silent = true })
      keymap("v", "<C-/>", "gc", { remap = true, desc = "Comment selection", silent = true })

      -- Alt+/ (fallback - always works)
      keymap("n", "<A-/>", "gcc", { remap = true, desc = "Comment line", silent = true })
      keymap("v", "<A-/>", "gc", { remap = true, desc = "Comment selection", silent = true })

      -- Leader+/ (another fallback)
      keymap("n", "<leader>/", "gcc", { remap = true, desc = "Comment line", silent = true })
      keymap("v", "<leader>/", "gc", { remap = true, desc = "Comment selection", silent = true })

      -- Ctrl+c (if you prefer)
      -- keymap("n", "<C-c>", "gcc", { remap = true, desc = "Comment line", silent = true })
      -- keymap("v", "<C-c>", "gc", { remap = true, desc = "Comment selection", silent = true })
    end,
  },
}
