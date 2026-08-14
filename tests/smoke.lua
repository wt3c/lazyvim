-- Smoke test de integração: boota a config REAL e valida o estado em runtime.
-- Rodar com: nvim --headless +"luafile tests/smoke.lua"
-- Sai com código != 0 (via :cq) se alguma verificação falhar.

local failures = {}

local function check(name, ok)
  print(("[%s] %s"):format(ok and "PASS" or "FAIL", name))
  if not ok then
    failures[#failures + 1] = name
  end
end

local function desc(lhs)
  local m = vim.fn.maparg(lhs, "n", false, true)
  return m and m.desc or nil
end

-- Espera o lazy carregar os plugins antes de inspecionar o estado.
vim.defer_fn(function()
  check("vim.g.lazyvim_picker == telescope", vim.g.lazyvim_picker == "telescope")

  local pick_ok, pick = pcall(require, "lazyvim.util.pick")
  check("picker ativo = telescope", pick_ok and pick.picker ~= nil and pick.picker.name == "telescope")

  local conform_ok, conform = pcall(require, "conform")
  check("conform carregado", conform_ok)
  if conform_ok then
    check(
      "conform: Python = ruff_format + ruff_organize_imports",
      vim.deep_equal(conform.formatters_by_ft.python, { "ruff_format", "ruff_organize_imports" })
    )
  end

  local which_key_ok = pcall(require, "which-key")
  check("which-key carregado pelo LazyVim", which_key_ok)
  check("<leader>? = atalhos locais do buffer (which-key)", desc(" ?") == "Buffer Keymaps (which-key)")

  local lazy_plugins = require("lazy.core.config").plugins
  check("legendary não faz parte do spec", lazy_plugins["legendary.nvim"] == nil)
  check("checkhealth nvim_config disponível", pcall(require, "nvim_config.health"))
  check("provider Python configurado", vim.fn.executable(vim.g.python3_host_prog or "") == 1)
  check("Molten registrado como plugin remoto", vim.fn.exists(":MoltenInit") == 2)
  check("dap.core: nvim-nio disponível", pcall(require, "nio"))
  check("dap.core: dap-ui disponível", pcall(require, "dapui"))

  -- Resolução de keymaps (sem colisão entre teste e terminal).
  check("<leader>tf = Test: Run File", desc(" tf") == "Test: Run File")
  check("<leader>Tf = Terminal: Float", desc(" Tf") == "Terminal: Float")
  check("- = Oil", (desc("-") or ""):match("Oil") ~= nil)
  check("<leader>ha = Harpoon", (desc(" ha") or ""):match("Harpoon") ~= nil)
  check("<leader>dj preservado pelo DAP oficial", desc(" dj") == "Down")
  check("<leader>dl preservado pelo DAP oficial", desc(" dl") == "Run Last")

  local notebook = vim.fn.getcwd() .. "/tests/fixtures/minimal.ipynb"
  local opened = pcall(vim.cmd.edit, vim.fn.fnameescape(notebook))
  local converted = opened
    and vim.bo.filetype == "markdown"
    and table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("nvim%-jupytext%-ok") ~= nil
  check("Jupytext converte notebook real para Markdown", converted)
  check("Gitsigns não anexa ao buffer .ipynb", vim.b.gitsigns_status_dict == nil)

  if #failures == 0 then
    print("\nSMOKE: TODOS OS TESTES PASSARAM")
    vim.cmd("qa!")
  else
    print("\nSMOKE: FALHAS -> " .. table.concat(failures, ", "))
    vim.cmd("cq") -- encerra com código de erro
  end
end, 3000)
