-- Regressões com plugins reais e arquivos temporários; somente a UI é simulada.
return function(check)
  local initial_theme = vim.g.colors_name
  local themery = require("plugins.themery")
  require("lazy").load({ plugins = { "themery.nvim" } })
  local state = require("themery.config").getStatePaths().state_file_path
  local function saved_theme()
    return vim.fn.filereadable(state) == 1 and table.concat(vim.fn.readfile(state), "\n") or ""
  end
  local before = saved_theme()
  local toggle = themery.keys[2][2]
  vim.cmd.colorscheme("tokyonight-moon")
  local ok = pcall(toggle)
  check("toggle de tema aplica Catppuccin Latte", ok and vim.g.colors_name == "catppuccin-latte")
  ok = pcall(toggle)
  check("toggle de tema volta ao Tokyo Night Moon", ok and vim.g.colors_name == "tokyonight-moon")
  check("toggle de tema não altera a seleção persistida", saved_theme() == before)
  vim.cmd.colorscheme(initial_theme)
  -- LazyReload do teste anterior pode limpar os handlers locais; recarrega os atalhos.
  dofile("lua/config/keymaps.lua")

  local first = vim.api.nvim_create_buf(true, false)
  local second = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(first)
  vim.cmd.vsplit()
  local windows = #vim.api.nvim_list_wins()
  local delete = vim.fn.maparg(" bd", "n", false, true)
  if delete.callback then
    delete.callback()
  else
    vim.cmd(delete.rhs:gsub("<cmd>", ""):gsub("<cr>", ""))
  end
  check("fechar buffer preserva os splits", #vim.api.nvim_list_wins() == windows)
  vim.cmd.only()

  local current = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(current)
  local others = vim.fn.maparg(" bD", "n", false, true)
  ok = pcall(function()
    if others.callback then
      others.callback()
    else
      vim.cmd(others.rhs:gsub("<cmd>", ""):gsub("<cr>", ""))
    end
  end)
  check("fechar outros buffers preserva o atual", ok and vim.api.nvim_get_current_buf() == current)

  local root = vim.fn.tempname()
  vim.fn.mkdir(root, "p")
  local file = root .. "/arquivo com espaços.txt"
  vim.fn.writefile({ "conteúdo" }, file)
  vim.cmd.edit(vim.fn.fnameescape(file))
  local target = vim.api.nvim_get_current_buf()
  local input, executable = vim.ui.input, vim.fn.executable
  local confirm
  vim.ui.input = function(_, callback)
    confirm = callback
  end
  -- Exercita a exclusão real de um arquivo temporário quando não há lixeira.
  vim.fn.executable = function(name)
    if name == "gio" or name == "trash" then
      return 0
    end
    return executable(name)
  end
  local key = vim.fn.maparg(" fD", "n", false, true)
  key.callback()
  local other = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(other)
  ok = pcall(confirm, "yes")
  vim.ui.input, vim.fn.executable = input, executable
  check("exclusão confirmada remove o arquivo correto", ok and vim.fn.filereadable(file) == 0)
  check("exclusão fecha o buffer original", not vim.api.nvim_buf_is_valid(target) or not vim.bo[target].buflisted)
  check(
    "exclusão preserva o buffer aberto durante a confirmação",
    vim.api.nvim_buf_is_valid(other) and vim.bo[other].buflisted
  )
  vim.fn.delete(root, "rf")
  for _, buf in ipairs({ first, second, current, target, other }) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end
