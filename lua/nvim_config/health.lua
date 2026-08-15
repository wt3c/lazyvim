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

local function can_import(python, modules)
  if not python or python == "" or vim.fn.executable(python) ~= 1 then
    return false
  end
  local result = vim.system({ python, "-c", "import " .. table.concat(modules, ", ") }, { text = true }):wait(5000)
  return result.code == 0
end

local function command_succeeds(command)
  if not executable(command[1]) then
    return false
  end
  return vim.system(command, { text = true }):wait(5000).code == 0
end

function M.check()
  vim.health.start("Configuração pessoal do Neovim")

  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim 0.12+ (APIs esperadas pela configuração)")
  else
    vim.health.error("Neovim 0.12+ é obrigatório", { "Atualize o Neovim antes de carregar esta configuração." })
  end
  if jit then
    vim.health.ok("LuaJIT disponível")
  else
    vim.health.error("Esta configuração exige Neovim compilado com LuaJIT")
  end

  vim.health.start("Ferramentas essenciais")
  for _, tool in ipairs({
    { "git", "bootstrap e atualização dos plugins" },
    { "curl", "blink.cmp e download do dicionário" },
    { "rg", "Telescope e busca de texto" },
    { "fd", "descoberta de ambientes virtuais pelo venv-selector" },
    { "make", "compilação de plugins" },
    { "cc", "parsers do Treesitter e extensões nativas" },
    { "tree-sitter", "geração de parsers" },
    { "node", "servidores de linguagem instalados pelo Mason" },
    { "npm", "ferramentas JavaScript instaladas pelo Mason" },
    { "python3", "desenvolvimento Python e plugins remotos" },
    { "uv", "provider Python/Jupyter isolado e projetos Python" },
    { "unzip", "extração de ferramentas instaladas pelo Mason" },
    { "tar", "extração de ferramentas instaladas pelo Mason" },
    { "gzip", "extração de ferramentas instaladas pelo Mason" },
  }) do
    check_executable(tool[1], tool[2], true)
  end

  vim.health.start("Integrações opcionais")
  for _, tool in ipairs({
    { "fzf", "busca fuzzy no terminal" },
    { "lazygit", "atalho <leader>Tg" },
    { "docker", "atalhos <leader>D*" },
    { "magick", "renderização opcional de imagens e plots do Jupyter" },
    { "kitty", "terminal recomendado para imagens e plots inline" },
    { "claude", "integração claudecode.nvim" },
    { "sqlite3", "conexões SQLite pelo vim-dadbod" },
    { "psql", "conexões PostgreSQL pelo vim-dadbod" },
    { "mysql", "conexões MySQL/MariaDB pelo vim-dadbod" },
  }) do
    check_executable(tool[1], tool[2], false)
  end

  if command_succeeds({ "docker", "compose", "version" }) then
    vim.health.ok("Docker Compose disponível (docker compose)")
  elseif executable("docker-compose") then
    vim.health.ok("Docker Compose legado disponível (docker-compose)")
  else
    vim.health.warn("Docker Compose não encontrado: atalhos de Compose ficarão indisponíveis")
  end

  if executable("wl-copy") then
    vim.health.ok("Clipboard Wayland disponível (wl-copy)")
  elseif executable("xclip") then
    vim.health.ok("Clipboard X11 disponível (xclip)")
  else
    vim.health.warn("Clipboard externo indisponível", {
      "Instale wl-clipboard no Wayland ou xclip no X11.",
    })
  end

  vim.health.start("Provider Python e Jupyter")
  local configured = vim.g.python3_host_prog
  local pynvim_python = vim.fn.exepath("pynvim-python")
  local candidate = configured or (pynvim_python ~= "" and pynvim_python or vim.fn.exepath("python3"))
  if can_import(candidate, { "pynvim" }) then
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
    if can_import(dedicated, { "pynvim", "jupyter_client", "jupytext", "ipykernel" }) then
      vim.health.ok("Dependências Python do Jupyter disponíveis")
    else
      vim.health.error("Dependências Python do Jupyter incompletas", {
        "Execute `./install.sh` para instalar pynvim, jupyter-client, jupytext e ipykernel.",
      })
    end
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
