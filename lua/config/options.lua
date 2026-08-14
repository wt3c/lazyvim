-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Picker unificado: Telescope em tudo (inclusive nos internos do LazyVim como
-- gr/gd/references). Isso faz o LazyVim auto-importar o extra editor.telescope e
-- NAO carregar o snacks.picker -- eliminando a redundancia de dois fuzzy finders.
-- Deve ser definido antes do startup do lazy.nvim (este arquivo carrega antes).
vim.g.lazyvim_picker = "telescope"

-- Clipboard: usa clipboard do sistema (wl-clipboard no Wayland, xclip no X11)
opt.clipboard = "unnamedplus"

-- Python provider: fixa o host somente quando o venv dedicado realmente existe.
-- Sem isso, o Neovim pode procurar um provider válido (por exemplo, pynvim via uv/pipx)
-- em vez de falhar por causa de um caminho inexistente.
local python_host = vim.fn.stdpath("data") .. "/venvs/jupyter/bin/python"
if vim.fn.executable(python_host) == 1 then
  vim.g.python3_host_prog = python_host
end

-- O jupytext.nvim recebe o caminho absoluto, mas seu healthcheck procura o
-- comando no PATH. Anexar (em vez de prefixar) evita trocar o Python padrão
-- usado por terminais e ferramentas de projeto.
local jupyter_bin = vim.fn.stdpath("data") .. "/venvs/jupyter/bin"
local jupytext = jupyter_bin .. "/jupytext"
if vim.fn.executable(jupytext) == 1 and not (vim.env.PATH or ""):find(jupyter_bin, 1, true) then
  local separator = vim.fn.has("win32") == 1 and ";" or ":"
  vim.env.PATH = (vim.env.PATH or "") .. separator .. jupyter_bin
end

-- Esta configuração não usa plugins remotos Node, Perl ou Ruby. Mason/LSPs
-- executados em Node não dependem do provider Node do Neovim.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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
opt.autoread = true
opt.mouse = "a"
opt.undofile = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Spell
opt.spelllang = { "pt", "en" }
opt.spellfile = vim.fn.stdpath("config") .. "/spell/pt.utf-8.add," .. vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Diagnosticos
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  float = {
    source = true,
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
