-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-format on save for specific filetypes
-- Note: LazyVim already handles format-on-save via conform.nvim
-- This is a backup/explicit configuration
local format_group = vim.api.nvim_create_augroup("AutoFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  pattern = { "*.py", "*.lua", "*.sql", "*.md" },
  callback = function()
    -- Use LazyVim's format function if available
    local ok, lazyvim_util = pcall(require, "lazyvim.util")
    if ok and lazyvim_util.format then
      lazyvim_util.format({ force = true })
    else
      -- Fallback to vim.lsp.buf.format if LazyVim util not available
      vim.lsp.buf.format({ async = false })
    end
  end,
})
