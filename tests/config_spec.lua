-- Specs de invariantes da config (rodam com plenary/busted, sem instalar plugins).
-- Carregam os módulos de spec dos plugins e/ou leem o fonte para validar contratos.

local function read(path)
  return table.concat(vim.fn.readfile(path), "\n")
end

-- Encontra a spec de um plugin pelo nome ("autor/repo") numa lista de specs.
local function find_plugin(specs, name)
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and spec[1] == name then
      return spec
    end
  end
  return nil
end

-- Conjunto de lhs (lado esquerdo) dos keymaps declarados numa spec.
local function lhs_set(spec)
  local set = {}
  for _, key in ipairs((spec and spec.keys) or {}) do
    local lhs = type(key) == "table" and key[1] or key
    set[lhs] = true
  end
  return set
end

describe("config/options", function()
  local src = read("lua/config/options.lua")

  it("padroniza o Telescope como picker", function()
    assert.truthy(src:find('lazyvim_picker%s*=%s*"telescope"'))
  end)

  it("não usa a forma deprecada do diagnostic float source", function()
    assert.is_nil(src:find('source%s*=%s*"always"'))
    assert.truthy(src:find("source%s*=%s*true"))
  end)

  it("mantém mecanismos de recuperação de escrita e crash", function()
    assert.is_nil(src:find("opt%.writebackup%s*=%s*false"))
    assert.is_nil(src:find("opt%.swapfile%s*=%s*false"))
  end)

  it("não força indentação de 4 espaços em todos os filetypes", function()
    assert.is_nil(src:find("opt%.shiftwidth%s*=%s*4"))
    assert.is_nil(src:find("opt%.tabstop%s*=%s*4"))
    local autocmds = read("lua/config/autocmds.lua")
    assert.truthy(autocmds:find('pattern = { "python", "htmldjango" }', 1, true))
    assert.truthy(autocmds:find("vim.opt_local.shiftwidth = 4", 1, true))
  end)
end)

describe("config/autocmds", function()
  it("recarregar autocmds.lua não acumula timers de checktime", function()
    dofile("lua/config/autocmds.lua")
    local first = _G.__nvim_config_checktime_timer
    dofile("lua/config/autocmds.lua")
    local second = _G.__nvim_config_checktime_timer

    assert.is_not_nil(first)
    assert.are_not.equal(first, second)
    assert.is_true(first:is_closing())
    assert.is_false(second:is_closing())
    second:stop()
    second:close()
    _G.__nvim_config_checktime_timer = nil
  end)
end)

describe("config/python (resolvedor por buffer)", function()
  local python = require("config.python")

  local function project()
    local root = vim.fn.tempname()
    local bin = root .. "/.venv/bin"
    vim.fn.mkdir(bin, "p")
    vim.fn.mkdir(root .. "/app/views", "p")
    vim.fn.writefile({}, root .. "/pyproject.toml")
    for _, name in ipairs({ "python", "ruff" }) do
      vim.fn.writefile({ "#!/bin/sh" }, bin .. "/" .. name)
      vim.fn.setfperm(bin .. "/" .. name, "rwxr-xr-x")
    end
    return root
  end

  it("resolve raiz e venv a partir do arquivo do buffer, não do cwd", function()
    local root = project()
    local previous_venv = vim.env.VIRTUAL_ENV
    vim.env.VIRTUAL_ENV = nil
    vim.cmd.edit(vim.fn.fnameescape(root .. "/app/views/home.py"))
    local buf = vim.api.nvim_get_current_buf()

    assert.equal(root, python.root(buf))
    assert.equal(root .. "/.venv/bin/python", python.python(buf))
    assert.equal(root .. "/.venv/bin/ruff", python.executable("ruff", buf))

    vim.cmd("bwipeout!")
    vim.env.VIRTUAL_ENV = previous_venv
    vim.fn.delete(root, "rf")
  end)

  it("VIRTUAL_ENV ativo tem prioridade sobre o venv do projeto", function()
    local root = project()
    local active = project()
    local previous_venv = vim.env.VIRTUAL_ENV
    vim.env.VIRTUAL_ENV = active .. "/.venv"
    vim.cmd.edit(vim.fn.fnameescape(root .. "/app/views/home.py"))

    assert.equal(active .. "/.venv/bin/python", python.python(vim.api.nvim_get_current_buf()))

    vim.cmd("bwipeout!")
    vim.env.VIRTUAL_ENV = previous_venv
    vim.fn.delete(root, "rf")
    vim.fn.delete(active, "rf")
  end)
end)

describe("config/docker (Compose)", function()
  local docker = require("config.docker")

  it("prefere docker compose v2 e roda no diretório do compose file", function()
    local root = vim.fn.tempname()
    vim.fn.mkdir(root .. "/services/api", "p")
    vim.fn.writefile({ "services: {}" }, root .. "/compose.yaml")
    vim.cmd.edit(vim.fn.fnameescape(root .. "/services/api/main.py"))

    local exepath, system = vim.fn.exepath, vim.system
    vim.fn.exepath = function(name)
      return ({ docker = "/usr/bin/docker", ["docker-compose"] = "/usr/bin/docker-compose" })[name] or ""
    end
    vim.system = function()
      return {
        wait = function()
          return { code = 0 }
        end,
      }
    end
    docker.reset()
    local command, cwd = docker.compose({ "up", "-d" }, vim.api.nvim_get_current_buf())
    vim.fn.exepath, vim.system = exepath, system
    docker.reset()

    assert.same({ "/usr/bin/docker", "compose", "up", "-d" }, command)
    assert.equal(root, cwd)
    vim.cmd("bwipeout!")
    vim.fn.delete(root, "rf")
  end)
end)

describe("config/keymaps", function()
  local src = read("lua/config/keymaps.lua")

  it("usa vim.diagnostic.jump (não goto_prev/goto_next)", function()
    assert.is_nil(src:find("diagnostic%.goto_prev"))
    assert.is_nil(src:find("diagnostic%.goto_next"))
    assert.truthy(src:find("diagnostic%.jump"))
    assert.is_nil(src:find("float%s*=%s*true"))
    assert.truthy(src:find("on_jump%s*="))
  end)

  it("mantém os atalhos de comentário sem depender do mini.comment", function()
    for _, lhs in ipairs({ "<C-_>", "<C-/>", "<A-/>", "<leader>/" }) do
      assert.truthy(src:find('"' .. lhs .. '", "gcc", { remap = true', 1, true))
      assert.truthy(src:find('"' .. lhs .. '", "gc", { remap = true', 1, true))
    end
    assert.truthy(src:find('"<C-_>", "<Esc>gcca", { remap = true', 1, true))
  end)

  it("renomeia via Snacks.rename e envia exclusões para a lixeira quando possível", function()
    assert.truthy(src:find("Snacks.rename.rename_file()", 1, true))
    assert.is_nil(src:find('cmd = "saveas"', 1, true))
    assert.truthy(src:find('{ "gio", "trash"', 1, true))
  end)

  it("não regride os keymaps de LSP do LazyVim", function()
    assert.is_nil(src:find("lsp%.buf%.definition"))
    assert.is_nil(src:find("lsp%.buf%.references"))
  end)

  it("oferece dicionários de português e inglês", function()
    assert.truthy(src:find('host = language == "pt" and "pt.wiktionary.org" or "en.wiktionary.org"', 1, true))
    assert.truthy(src:find('"<leader>zp"', 1, true))
    assert.truthy(src:find('"<leader>ze"', 1, true))
    assert.truthy(src:find('"<leader>zd"', 1, true))
  end)
end)

describe("compatibilidade com Neovim 0.12", function()
  it("não usa aliases Lua e opções de keymap depreciados", function()
    for _, file in ipairs({ "lua/config/lazy.lua", "lua/plugins/git-modern.lua", "lua/plugins/python-tools.lua" }) do
      local content = read(file)
      assert.is_nil(content:find("vim%.loop"))
      assert.is_nil(content:find("buffer%s*="))
    end
  end)

  it("não repete o override depreciado de stylize_markdown", function()
    assert.is_nil(read("lua/plugins/modern-ui.lua"):find('["vim.lsp.util.stylize_markdown"]', 1, true))
  end)

  it("usa vim.system no bootstrap de processo comum", function()
    local content = read("lua/config/lazy.lua")
    assert.is_truthy(content:find('%.system%({ "git", "clone"'))
    assert.is_nil(content:find("vim.fn.system", 1, true))
  end)

  it("oferece checkhealth próprio", function()
    assert.is_function(require("nvim_config.health").check)
  end)

  it("verifica dependências essenciais do venv-selector e do Mason", function()
    local health = read("lua/nvim_config/health.lua")
    local install = read("install.sh")
    for _, tool in ipairs({ "fd", "unzip", "tar", "gzip" }) do
      assert.is_truthy(health:find('{ "' .. tool .. '"', 1, true))
    end
    assert.is_truthy(
      install:find("required_tools=(git curl rg fd make cc tree-sitter node npm python3 uv unzip tar gzip)", 1, true)
    )
    assert.is_truthy(install:find("pynvim jupyter-client jupytext ipykernel", 1, true))
    assert.is_truthy(health:find('{ "pynvim", "jupyter_client", "jupytext", "ipykernel" }', 1, true))
    assert.is_truthy(read("quick-install.sh"):find('exec "$NVIM_DIR/install.sh" "$@"', 1, true))
  end)

  it("usa a implementação atual do jupytext com executável isolado", function()
    local content = read("lua/plugins/jupyter-tools.lua")
    assert.is_truthy(content:find('"goerz/jupytext.nvim"', 1, true))
    assert.is_truthy(content:find('jupyter_venv .. "/jupytext"', 1, true))
    assert.is_nil(content:find('"GCBallesteros/jupytext.nvim"', 1, true))
  end)

  it("renderiza imagens via ImageMagick sem gerenciador LuaRocks", function()
    local content = read("lua/plugins/jupyter-tools.lua")
    assert.is_truthy(content:find('processor = "magick_cli"', 1, true))
    assert.is_nil(content:find("vhyrro/luarocks.nvim", 1, true))
    assert.is_truthy(read("lua/config/lazy.lua"):find("rocks = { enabled = false }", 1, true))
  end)

  it("image.nvim só carrega como dependência do Molten", function()
    local image = find_plugin(require("plugins.jupyter-tools"), "3rd/image.nvim")
    assert.is_true(image.lazy)
  end)

  it("lazy.nvim não verifica atualizações em segundo plano", function()
    assert.truthy(read("lua/config/lazy.lua"):find("checker = { enabled = false }", 1, true))
  end)
end)

describe("correcoes de robustez", function()
  it("markdownlint não exige configuração global inexistente", function()
    local content = read("lua/plugins/markdown-tools.lua")
    assert.is_nil(content:find("~/.markdownlint.json", 1, true))
  end)

  it("docker exec usa argv e não concatena entrada do usuário", function()
    local content = read("lua/config/keymaps.lua")
    assert.is_truthy(content:find('{ docker, "exec", "-it", container, "/bin/bash" }', 1, true))
    assert.is_nil(content:find('"terminal docker exec -it " .. container', 1, true))
  end)

  it("Python, Django e Docker não são interpolados em comandos de shell", function()
    local content = read("lua/config/keymaps.lua")
    assert.is_nil(content:find("<cmd>!", 1, true))
    assert.is_nil(content:find("<cmd>terminal", 1, true))
    assert.is_truthy(content:find("vim.fn.jobstart(command, { term = true", 1, true))
  end)

  it("download assíncrono comum usa vim.system, não jobstart", function()
    local content = read("lua/config/autocmds.lua")
    assert.is_truthy(content:find("pcall(vim.system", 1, true))
    assert.is_nil(content:find("vim.fn.jobstart", 1, true))
  end)

  it("docker system prune pede confirmação", function()
    local content = read("lua/config/keymaps.lua")
    assert.is_truthy(content:find('vim.ui.select({ "Cancelar", "Executar docker system prune" }', 1, true))
  end)

  it("não anexa Gitsigns a notebooks interceptados pelo Jupytext", function()
    local content = read("lua/plugins/git-modern.lua")
    assert.is_truthy(content:find('match("%.ipynb$")', 1, true))
    assert.is_truthy(content:find("return false", 1, true))
  end)

  it("hot reload de tema compara syntax_on com 1 e não dispara eventos artificiais", function()
    local content = read("lua/plugins/omarchy-theme-hotreload.lua")
    assert.truthy(content:find('vim.fn.exists("syntax_on") == 1', 1, true))
    assert.is_nil(content:find('nvim_exec_autocmds("VimEnter"', 1, true))
    assert.is_nil(content:find('nvim_exec_autocmds("ColorScheme"', 1, true))
  end)

  it("auto-instalação de LSP usa a API pública e não reinstala pacote em andamento", function()
    local content = read("lua/config/lsp_autoinstall.lua")
    assert.is_nil(content:find("mason-lspconfig.mappings", 1, true))
    assert.truthy(content:find("get_available_servers", 1, true))
    assert.truthy(content:find("is_installing()", 1, true))
  end)

  it("exemplo de conexão SQL não traz credencial", function()
    local content = read("lua/plugins/sql-tools.lua")
    assert.is_nil(content:find("user:password", 1, true))
    assert.truthy(content:find("vim.env.DATABASE_URL", 1, true))
  end)

  it("fallbacks de Python não tratam string vazia como executável", function()
    for _, file in ipairs({ "lua/plugins/python-tools.lua", "lua/config/python.lua" }) do
      local content = read(file)
      assert.is_truthy(content:find('if path ~= "" then', 1, true))
      assert.is_nil(content:find('exepath("python3") or vim.fn.exepath', 1, true))
    end
  end)
end)

describe("plugins/formatting (conform)", function()
  local conform = find_plugin(require("plugins.formatting"), "stevearc/conform.nvim")

  it("Python usa Ruff: format + organize imports", function()
    assert.is_not_nil(conform)
    assert.same({ "ruff_format", "ruff_organize_imports" }, conform.opts.formatters_by_ft.python)
  end)
end)

describe("plugins/python-tools", function()
  local specs = require("plugins.python-tools")
  local lsp = find_plugin(specs, "neovim/nvim-lspconfig")

  it("Ruff LSP não formata (conform é o dono da formatação)", function()
    assert.is_false(lsp.opts.servers.ruff.init_options.settings.format.enable)
  end)

  it("Mason e Treesitter só declaram o que o extra lang.python não traz", function()
    local mason = { ensure_installed = {} }
    find_plugin(specs, "mason-org/mason.nvim").opts(nil, mason)
    assert.same({ "mypy", "debugpy" }, mason.ensure_installed)

    local treesitter = { ensure_installed = {} }
    find_plugin(specs, "nvim-treesitter/nvim-treesitter").opts(nil, treesitter)
    assert.same({ "htmldjango", "css" }, treesitter.ensure_installed)
  end)

  it("delega o DAP base ao extra oficial e mantém apenas a extensão Python", function()
    local lazyvim = read("lazyvim.json")
    local dap_python = find_plugin(specs, "mfussenegger/nvim-dap-python")
    local keys = lhs_set(dap_python)

    assert.truthy(lazyvim:find('"lazyvim.plugins.extras.dap.core"', 1, true))
    assert.is_not_nil(dap_python)
    assert.is_nil(find_plugin(specs, "mfussenegger/nvim-dap"))
    assert.is_true(keys["<leader>dPr"])
    assert.is_nil(keys["<leader>dj"])
    assert.is_nil(keys["<leader>dl"])
  end)
end)

describe("plugins/completion (blink.cmp)", function()
  local blink = find_plugin(require("plugins.completion"), "saghen/blink.cmp")

  it("habilita ghost text e signature help", function()
    assert.is_not_nil(blink)
    assert.is_true(blink.opts.completion.ghost_text.enabled)
    assert.is_true(blink.opts.signature.enabled)
  end)
end)

describe("plugins/editor-extras", function()
  local specs = require("plugins.editor-extras")

  it("inclui Harpoon e Oil; substituição no projeto fica com o grug-far do LazyVim", function()
    assert.is_nil(find_plugin(specs, "nvim-pack/nvim-spectre"))
    assert.is_not_nil(find_plugin(specs, "ThePrimeagen/harpoon"))
    assert.is_not_nil(find_plugin(specs, "stevearc/oil.nvim"))
  end)
end)

describe("plugins redundantes com o LazyVim/Snacks", function()
  it("não declara ferramentas já trazidas pelos extras", function()
    assert.same(
      { "yaml-language-server", "bash-language-server", "shellcheck", "prettier" },
      find_plugin(require("plugins.mason-tools"), "mason-org/mason.nvim").opts.ensure_installed
    )
    assert.equal(0, vim.fn.filereadable("lua/plugins/docker-tools.lua"))
    assert.equal(0, vim.fn.filereadable("lua/plugins/colorschemes.lua"))
    assert.equal(0, vim.fn.filereadable("lua/plugins/comments.lua"))
    assert.is_nil(read("lazyvim.json"):find("typescript.vtsls", 1, true))
  end)
end)

describe("plugins/modern-ui", function()
  local specs = require("plugins.modern-ui")

  it("inclui o treesitter-context", function()
    assert.is_not_nil(find_plugin(specs, "nvim-treesitter/nvim-treesitter-context"))
  end)

  it("não inclui mini.indentscope (duplicava o snacks.indent)", function()
    assert.is_nil(find_plugin(specs, "nvim-mini/mini.indentscope"))
  end)

  it("which-key usa o spec padrão do LazyVim, sem override local", function()
    assert.is_nil(find_plugin(specs, "folke/which-key.nvim"))
  end)

  it("usa Snacks para notificações e referências, sem notify/illuminate/dressing locais", function()
    for _, name in ipairs({ "rcarriga/nvim-notify", "RRethy/vim-illuminate", "stevearc/dressing.nvim" }) do
      assert.is_nil(find_plugin(specs, name))
    end
    assert.is_false(vim.tbl_contains(find_plugin(specs, "folke/noice.nvim").dependencies, "rcarriga/nvim-notify"))
  end)

  it("telescope é aditivo (sem config/dependências redundantes)", function()
    local telescope = find_plugin(specs, "nvim-telescope/telescope.nvim")
    assert.is_nil(telescope.config)
    assert.is_nil(telescope.dependencies)
  end)
end)

describe("plugins/test-runner (sem colisão terminal × teste)", function()
  local specs = require("plugins.test-runner")

  it("terminal usa Snacks.terminal com <leader>T*, não <leader>tf", function()
    assert.is_nil(find_plugin(specs, "akinsho/toggleterm.nvim"))
    local keys = lhs_set(find_plugin(specs, "folke/snacks.nvim"))
    assert.is_nil(keys["<leader>tf"])
    local terminal_keys =
      { "<C-\\>", "<leader>Tf", "<leader>Th", "<leader>Tv", "<leader>Tp", "<leader>Tl", "<leader>Tg" }
    for _, lhs in ipairs(terminal_keys) do
      assert.is_true(keys[lhs], lhs)
    end
  end)

  it("pytest não força xdist nem log DEBUG por padrão", function()
    local previous = package.loaded["neotest-python"]
    package.loaded["neotest-python"] = function(opts)
      return opts
    end
    local opts = find_plugin(specs, "nvim-neotest/neotest").opts()
    package.loaded["neotest-python"] = previous

    local args = table.concat(opts.adapters[1].args, " ")
    assert.is_nil(args:find("-n auto", 1, true))
    assert.is_nil(args:find("DEBUG", 1, true))
  end)

  it("neotest mantém <leader>tf (Test: Run File)", function()
    local keys = lhs_set(find_plugin(specs, "nvim-neotest/neotest"))
    assert.is_true(keys["<leader>tf"])
  end)

  it("neotest ignora ambientes e caches durante a descoberta", function()
    local previous = package.loaded["neotest-python"]
    package.loaded["neotest-python"] = function(opts)
      return opts
    end

    local opts = find_plugin(specs, "nvim-neotest/neotest").opts()
    package.loaded["neotest-python"] = previous

    for _, name in ipairs({ ".git", ".pytest_cache", ".venv", "__pycache__" }) do
      assert.is_false(opts.discovery.filter_dir(name))
    end
    assert.is_true(opts.discovery.filter_dir("tests"))
  end)
end)

describe("plugins/git-modern (gitsigns com API atual)", function()
  local src = read("lua/plugins/git-modern.lua")

  it("usa nav_hunk e não chama APIs removidas/deprecadas", function()
    assert.truthy(src:find("nav_hunk"))
    assert.is_nil(src:find("gs%.undo_stage_hunk"))
    assert.is_nil(src:find("gs%.next_hunk"))
    assert.is_nil(src:find("gs%.prev_hunk"))
  end)
end)

describe("plugins/quicknote", function()
  local quicknote = require("plugins.quicknote")

  -- `cmd` registra o comando no handler do lazy; ao carregar o plugin por
  -- qualquer outra via o handler roda nvim_del_user_command sobre o comando --
  -- e :Telescope pertence ao telescope.nvim, nao ao quicknote (que so registra
  -- uma extensao). Declarar `cmd = { "Telescope" }` aqui apagava o :Telescope
  -- real e matava todo <leader>f* sempre que o quicknote carregava antes.
  it("não sequestra o :Telescope como gatilho de lazy-load", function()
    for _, cmd in ipairs(quicknote.cmd or {}) do
      assert.are_not.equal("Telescope", cmd)
    end
  end)

  it("só carrega o plugin para exibir sinais em arquivos de projetos com .quicknote/", function()
    local content = read("lua/plugins/quicknote.lua")
    assert.truthy(content:find('vim.bo[ev.buf].buftype ~= ""', 1, true))
    assert.truthy(content:find('"/.quicknote"', 1, true))
  end)
end)

describe("plugins/themery", function()
  local themery = require("plugins.themery")

  it("carrega sob demanda sem reaplicar o tema no VimEnter", function()
    assert.is_not_false(themery.lazy)
    assert.is_nil(themery.init)
    assert.truthy(vim.tbl_contains(themery.cmd, "Themery"))
  end)
end)
