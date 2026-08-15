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

  it("fallbacks de Python não tratam string vazia como executável", function()
    for _, file in ipairs({ "lua/plugins/python-tools.lua", "lua/plugins/test-runner.lua" }) do
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

  it("inclui Spectre, Harpoon e Oil", function()
    assert.is_not_nil(find_plugin(specs, "nvim-pack/nvim-spectre"))
    assert.is_not_nil(find_plugin(specs, "ThePrimeagen/harpoon"))
    assert.is_not_nil(find_plugin(specs, "stevearc/oil.nvim"))
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

  it("telescope é aditivo (sem config/dependências redundantes)", function()
    local telescope = find_plugin(specs, "nvim-telescope/telescope.nvim")
    assert.is_nil(telescope.config)
    assert.is_nil(telescope.dependencies)
  end)
end)

describe("plugins/test-runner (sem colisão terminal × teste)", function()
  local specs = require("plugins.test-runner")

  it("terminal usa <leader>T*, não <leader>tf", function()
    local keys = lhs_set(find_plugin(specs, "akinsho/toggleterm.nvim"))
    assert.is_nil(keys["<leader>tf"])
    assert.is_true(keys["<leader>Tf"])
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
