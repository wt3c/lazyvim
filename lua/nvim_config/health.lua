local M = {}

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function check_executable(name, description, required)
  if executable(name) then
    vim.health.ok(("%s encontrado (%s)"):format(name, vim.fn.exepath(name)))
  elseif required then
    vim.health.error(("%s não encontrado: %s"):format(name, description))
  else
    vim.health.warn(("%s não encontrado: %s"):format(name, description))
  end
end

local function can_import_pynvim(python)
  if not python or python == "" or vim.fn.executable(python) ~= 1 then
    return false
  end
  local result = vim.system({ python, "-c", "import pynvim" }, { text = true }):wait(5000)
  return result.code == 0
end

function M.check()
  vim.health.start("Configuração pessoal do Neovim")

  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim 0.12+ (APIs esperadas pela configuração)")
  else
    vim.health.error("Neovim 0.12+ é obrigatório", { "Atualize o Neovim antes de carregar esta configuração." })
  end

  vim.health.start("Ferramentas essenciais")
  for _, tool in ipairs({
    { "git", "bootstrap e atualização dos plugins" },
    { "curl", "blink.cmp e download do dicionário" },
    { "rg", "Telescope e busca de texto" },
    { "make", "compilação de plugins" },
    { "cc", "parsers do Treesitter e extensões nativas" },
    { "tree-sitter", "geração de parsers" },
    { "node", "servidores de linguagem instalados pelo Mason" },
    { "npm", "ferramentas JavaScript instaladas pelo Mason" },
    { "python3", "desenvolvimento Python e plugins remotos" },
    { "uv", "provider Python/Jupyter isolado e projetos Python" },
  }) do
    check_executable(tool[1], tool[2], true)
  end

  vim.health.start("Integrações opcionais")
  for _, tool in ipairs({
    { "fd", "acelera alguns pickers de arquivos" },
    { "fzf", "busca fuzzy no terminal" },
    { "lazygit", "atalho <leader>Tg" },
    { "docker", "atalhos <leader>D*" },
    { "docker-compose", "fallback legado para Docker Compose" },
    { "magick", "renderização opcional de imagens e plots do Jupyter" },
  }) do
    check_executable(tool[1], tool[2], false)
  end

  vim.health.start("Provider Python e Jupyter")
  local configured = vim.g.python3_host_prog
  local pynvim_python = vim.fn.exepath("pynvim-python")
  local candidate = configured or (pynvim_python ~= "" and pynvim_python or vim.fn.exepath("python3"))
  if can_import_pynvim(candidate) then
    vim.health.ok("Provider Python consegue importar pynvim: " .. candidate)
  else
    vim.health.warn("Provider Python sem pynvim funcional", {
      "Instale com `uv tool install --upgrade pynvim` ou `pipx install pynvim`.",
      "Depois execute `:checkhealth vim.provider nvim_config`.",
    })
  end

  local dedicated = vim.fn.stdpath("data") .. "/venvs/jupyter/bin/python"
  if vim.fn.executable(dedicated) == 1 then
    vim.health.ok("Venv dedicado do Jupyter encontrado: " .. dedicated)
  else
    vim.health.warn("Venv dedicado do Jupyter não encontrado: " .. dedicated, {
      "Molten exige um provider Python com pynvim e dependências Jupyter funcionais.",
    })
  end

  local jupytext = vim.fn.stdpath("data") .. "/venvs/jupyter/bin/jupytext"
  if vim.fn.executable(jupytext) == 1 then
    vim.health.ok("Jupytext isolado encontrado: " .. jupytext)
  else
    vim.health.error("Jupytext não encontrado: " .. jupytext, {
      "Execute `./install.sh` para instalar o conversor usado ao abrir e salvar notebooks.",
    })
  end

  check_executable("debugpy-adapter", "debug Python via DAP", false)
end

return M
