-- Neovim 0.10+ has built-in OSC52 support via vim.ui.clipboard.osc52.
-- For local desktop (Wayland/X11), system clipboard via vim.opt.clipboard is preferred.
-- OSC52 is only needed for SSH sessions — enable it per-project if necessary.
return {
  { "ojroques/nvim-osc52", enabled = false },
}
