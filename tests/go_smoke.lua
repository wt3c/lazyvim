-- Integração real do perfil Go: módulo temporário, LSP, formatação, Neotest e DAP.
-- Executar com nvim --headless +"luafile tests/go_smoke.lua".
vim.defer_fn(function()
  local ok, err = xpcall(function()
    local root = vim.fn.tempname()
    vim.fn.mkdir(root, "p")
    vim.fn.writefile({ "module example.com/nvimcheck", "", "go 1.21" }, root .. "/go.mod")
    vim.fn.writefile({ "package check", "func Add(a,b int) int{return a+b}" }, root .. "/add.go")
    vim.fn.writefile({
      "package check",
      'import "testing"',
      'func TestAdd(t *testing.T) { if Add(2, 3) != 5 { t.Fatal("sum") } }',
    }, root .. "/add_test.go")
    vim.cmd.cd(root)
    vim.cmd.edit(root .. "/add.go")
    assert(
      vim.wait(60000, function()
        return #vim.lsp.get_clients({ bufnr = 0, name = "gopls" }) > 0
      end, 100),
      "gopls não anexou ao módulo"
    )
    local client = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })[1]
    local params = { textDocument = { uri = vim.uri_from_bufnr(0) }, position = { line = 1, character = 6 } }
    local hover = client:request_sync("textDocument/hover", params, 30000, 0)
    assert(hover and hover.result and hover.result.contents, "gopls não respondeu ao hover")
    print("[PASS] gopls anexado e hover real")
    local formatted, format_err
    require("conform").format({ async = false, timeout_ms = 30000 }, function(e)
      formatted, format_err = true, e
    end)
    assert(formatted and not format_err, tostring(format_err))
    assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[2] == "", "gofumpt não formatou")
    vim.cmd.write()
    print("[PASS] goimports e gofumpt reais")
    vim.cmd.edit(root .. "/add_test.go")
    assert(
      vim.wait(60000, function()
        return pcall(vim.treesitter.language.add, "go")
      end, 200),
      "parser Go não instalado"
    )
    local neotest = require("neotest")
    neotest.run.run(root .. "/add_test.go")
    assert(
      vim.wait(90000, function()
        for _, adapter in ipairs(neotest.state.adapter_ids()) do
          if adapter:find("neotest-golang", 1, true) then
            local counts = neotest.state.status_counts(adapter)
            if counts and counts.passed > 0 then
              return true
            end
          end
        end
        return false
      end, 200),
      "Neotest não executou TestAdd com sucesso"
    )
    print("[PASS] Neotest descobriu e executou TestAdd")
    local dap = require("dap")
    assert(dap.adapters.go and #dap.configurations.go > 0, "DAP Go não configurado")
    local result = vim.system({ "go", "test", "-race", "./..." }, { text = true }):wait(90000)
    assert(result.code == 0, result.stderr or result.stdout)
    local debug = vim.system({ "dlv", "version" }, { text = true }):wait(10000)
    assert(debug.code == 0, debug.stderr)
    local initialized, terminated = false, false
    dap.listeners.after.event_initialized.go_smoke = function()
      initialized = true
    end
    dap.listeners.after.event_terminated.go_smoke = function()
      terminated = true
    end
    dap.run({ type = "go", request = "launch", name = "Go smoke", mode = "test", program = root, cwd = root })
    assert(
      vim.wait(60000, function()
        return initialized and terminated
      end, 200),
      "sessão real do Delve não concluiu"
    )
    dap.listeners.after.event_initialized.go_smoke = nil
    dap.listeners.after.event_terminated.go_smoke = nil
    print("[PASS] go test -race e sessão real do Delve via DAP")
  end, debug.traceback)
  if not ok then
    print(err)
  end
  vim.cmd(ok and "qa!" or "cq")
end, 3000)
