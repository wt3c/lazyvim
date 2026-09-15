-- Docker Compose: resolve o comando (v2 `docker compose` primeiro, `docker-compose`
-- legado como fallback) e o diretório do compose file mais próximo do buffer.
local M = {}

local compose_files = { "compose.yaml", "compose.yml", "docker-compose.yaml", "docker-compose.yml" }
local base -- comando base em cache; false quando nenhum Compose foi encontrado

local function detect()
  local docker = vim.fn.exepath("docker")
  if docker ~= "" and vim.system({ docker, "compose", "version" }):wait().code == 0 then
    return { docker, "compose" }
  end
  local legacy = vim.fn.exepath("docker-compose")
  if legacy ~= "" then
    return { legacy }
  end
  return false
end

--- Limpa o cache da detecção (útil após instalar o plugin compose).
function M.reset()
  base = nil
end

--- Comando Compose completo e o cwd onde executá-lo.
---@param arguments string[]
---@param bufnr? integer
---@return string[]? command, string? cwd
function M.compose(arguments, bufnr)
  if base == nil then
    base = detect()
  end
  if not base then
    return nil
  end

  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
  local file = vim.fs.find(compose_files, { path = start, upward = true, type = "file" })[1]

  local command = vim.list_extend(vim.deepcopy(base), arguments)
  return command, file and vim.fs.dirname(file) or nil
end

return M
