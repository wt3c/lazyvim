-- Resolvedor único de raiz de projeto e executáveis Python a partir do buffer.
-- Usado por keymaps, conform (Ruff), Neotest, Overseer e terminais: todos
-- olham o projeto do arquivo aberto, não o cwd do Neovim.
local M = {}

local root_markers = { "pyproject.toml", "manage.py", "setup.py", "setup.cfg", ".git" }
local venv_names = { ".venv", "venv", "env" }
local windows = vim.fn.has("win32") == 1

--- Raiz do projeto do buffer (marcador mais próximo acima do arquivo) ou o cwd.
---@param bufnr? integer
---@return string
function M.root(bufnr)
  return vim.fs.root(bufnr or 0, root_markers) or vim.uv.cwd()
end

-- Caminho de um executável dentro de um venv (bin/ no Unix, Scripts/ no Windows).
local function venv_executable(venv, name)
  local path = windows and ("%s/Scripts/%s.exe"):format(venv, name) or ("%s/bin/%s"):format(venv, name)
  if vim.fn.executable(path) == 1 then
    return path
  end
end

--- Executável do venv ativo ou do projeto do buffer; nil quando não houver.
---@param name string
---@param bufnr? integer
---@return string?
function M.executable(name, bufnr)
  if vim.env.VIRTUAL_ENV then
    local path = venv_executable(vim.env.VIRTUAL_ENV, name)
    if path then
      return path
    end
  end
  local root = M.root(bufnr)
  for _, venv in ipairs(venv_names) do
    local path = venv_executable(root .. "/" .. venv, name)
    if path then
      return path
    end
  end
end

--- Python do venv ativo/do projeto; cai no python3/python do PATH.
---@param bufnr? integer
---@return string?
function M.python(bufnr)
  local venv_python = M.executable("python", bufnr)
  if venv_python then
    return venv_python
  end
  for _, executable in ipairs({ "python3", "python" }) do
    local path = vim.fn.exepath(executable)
    if path ~= "" then
      return path
    end
  end
end

return M
