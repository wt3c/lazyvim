-- Init mínimo para rodar os specs busted (plenary) isolados da config completa.
-- Coloca o repo e o plenary no runtimepath, sem bootstrapar todos os plugins.

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(root)

-- Localiza o plenary: usa o já instalado pelo lazy, ou o clone local em tests/.deps.
local function find_plenary()
  local candidates = {
    vim.fn.stdpath("data") .. "/lazy/plenary.nvim",
    root .. "/tests/.deps/plenary.nvim",
  }
  for _, path in ipairs(candidates) do
    if vim.fn.isdirectory(path) == 1 then
      return path
    end
  end
  return nil
end

local plenary = find_plenary()
if not plenary then
  error("plenary.nvim não encontrado. Rode tests/run.sh (clona em tests/.deps) ou abra o nvim uma vez.")
end

vim.opt.rtp:prepend(plenary)
vim.cmd("runtime plugin/plenary.vim")
