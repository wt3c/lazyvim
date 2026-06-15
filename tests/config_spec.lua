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
end)

describe("config/keymaps", function()
  local src = read("lua/config/keymaps.lua")

  it("usa vim.diagnostic.jump (não goto_prev/goto_next)", function()
    assert.is_nil(src:find("diagnostic%.goto_prev"))
    assert.is_nil(src:find("diagnostic%.goto_next"))
    assert.truthy(src:find("diagnostic%.jump"))
  end)

  it("não regride os keymaps de LSP do LazyVim", function()
    assert.is_nil(src:find("lsp%.buf%.definition"))
    assert.is_nil(src:find("lsp%.buf%.references"))
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
  local lsp = find_plugin(require("plugins.python-tools"), "neovim/nvim-lspconfig")

  it("Ruff LSP não formata (conform é o dono da formatação)", function()
    assert.is_false(lsp.opts.servers.ruff.init_options.settings.format.enable)
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

  it("which-key define o grupo <leader>h (harpoon)", function()
    local wk = find_plugin(specs, "folke/which-key.nvim")
    local has_group = false
    for _, group in ipairs(wk.opts.spec) do
      if group[1] == "<leader>h" then
        has_group = true
      end
    end
    assert.is_true(has_group)
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
