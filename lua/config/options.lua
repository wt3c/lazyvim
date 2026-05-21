-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Clipboard: usa clipboard do sistema (wl-clipboard no Wayland, xclip no X11)
opt.clipboard = "unnamedplus"

-- Exibicao de linha
opt.colorcolumn = "120"
opt.number = true
opt.relativenumber = false

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false

-- Indentacao (Python/Lua)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Busca
opt.ignorecase = true
opt.smartcase = true

-- Comportamento
opt.mouse = "a"
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Diagnosticos
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
