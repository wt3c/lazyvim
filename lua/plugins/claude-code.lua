-- ~/.config/nvim/lua/plugins/claude-code.lua
-- Claude Code IDE extension: bridge nativo com o CLI `claude` já autenticado
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude: Toggle" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude: Focus" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude: Select model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: Add buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: Send selection" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: Deny diff" },
  },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.30,
      provider = "auto",
      auto_insert = true,
    },
    diff_opts = {
      layout = "vertical",
    },
  },
}
