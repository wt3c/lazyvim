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

  check("which-key carregado", pcall(require, "which-key"))

  -- Resolução de keymaps (sem colisão entre teste e terminal).
  check("<leader>tf = Test: Run File", desc(" tf") == "Test: Run File")
  check("<leader>Tf = Terminal: Float", desc(" Tf") == "Terminal: Float")
  check("- = Oil", (desc("-") or ""):match("Oil") ~= nil)
  check("<leader>ha = Harpoon", (desc(" ha") or ""):match("Harpoon") ~= nil)

  if #failures == 0 then
    print("\nSMOKE: TODOS OS TESTES PASSARAM")
    vim.cmd("qa!")
  else
    print("\nSMOKE: FALHAS -> " .. table.concat(failures, ", "))
    vim.cmd("cq") -- encerra com código de erro
  end
end, 3000)
