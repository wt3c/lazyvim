-- Integração real Rust em projeto temporário sem dependências externas.
-- Executar da raiz da configuração com nvim --headless +"luafile tests/rust_smoke.lua".
vim.defer_fn(function()
  local root = vim.fn.tempname()
  local dap = require("dap")
  local ok, err = xpcall(function()
    vim.fn.mkdir(root .. "/src", "p")
    vim.fn.writefile({
      "[package]",
      'name = "nvim_rust_check"',
      'version = "0.1.0"',
      'edition = "2021"',
    }, root .. "/Cargo.toml")
    vim.fn.writefile({
      "pub fn add(a:i32,b:i32)->i32{a+b}",
      "#[cfg(test)]",
      "mod tests {",
      "    #[test]",
      "    fn adds_numbers() { assert_eq!(super::add(2, 3), 5); }",
      "}",
    }, root .. "/src/lib.rs")
    vim.fn.writefile({ 'fn main() { println!("{}", nvim_rust_check::add(2, 3)); }' }, root .. "/src/main.rs")
    vim.cmd.cd(root)
    vim.cmd.edit(root .. "/src/lib.rs")
    assert(
      vim.wait(60000, function()
        return #vim.lsp.get_clients({ bufnr = 0, name = "rust-analyzer" }) == 1
      end, 100),
      "rust-analyzer não anexou ao projeto"
    )
    local client = vim.lsp.get_clients({ bufnr = 0, name = "rust-analyzer" })[1]
    assert(
      vim.wait(60000, function()
        local response = client:request_sync("textDocument/hover", {
          textDocument = { uri = vim.uri_from_bufnr(0) },
          position = { line = 0, character = 7 },
        }, 5000, 0)
        return response and response.result and response.result.contents ~= nil
      end, 200),
      "rust-analyzer não respondeu ao hover"
    )
    print("[PASS] rust-analyzer único e hover real")

    local formatting_error
    require("conform").format({ async = false, timeout_ms = 30000 }, function(e)
      formatting_error = e
    end)
    assert(not formatting_error, tostring(formatting_error))
    assert(
      vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "pub fn add(a: i32, b: i32) -> i32 {",
      "rustfmt não formatou"
    )
    vim.cmd.write()
    local function cargo(args)
      local command = { "cargo" }
      vim.list_extend(command, args)
      local result = vim.system(command, { cwd = root, text = true }):wait(60000)
      assert(result.code == 0, result.stderr or result.stdout)
      return result
    end
    cargo({ "fmt", "--all" })
    cargo({ "fmt", "--all", "--", "--check" })
    cargo({ "clippy", "--offline", "--all-targets", "--", "-D", "warnings" })
    cargo({ "test", "--offline" })
    print("[PASS] rustfmt, cargo clippy e cargo test reais")

    assert(
      vim.wait(60000, function()
        return pcall(vim.treesitter.language.add, "rust")
      end, 200),
      "parser Rust indisponível"
    )
    assert(
      vim.wait(60000, function()
        local response = client:request_sync("experimental/runnables", {
          textDocument = { uri = vim.uri_from_bufnr(0) },
        }, 5000, 0)
        if response and response.result then
          for _, runnable in ipairs(response.result) do
            if runnable.label:find("adds_numbers", 1, true) then
              return true
            end
          end
        end
        return false
      end, 200),
      "rust-analyzer não descobriu o teste Rust"
    )
    local neotest = require("neotest")
    neotest.run.run(root .. "/src/lib.rs")
    assert(
      vim.wait(60000, function()
        for _, adapter in ipairs(neotest.state.adapter_ids()) do
          if adapter:find("rust", 1, true) then
            local counts = neotest.state.status_counts(adapter)
            if counts and counts.passed > 0 then
              return true
            end
          end
        end
        return false
      end, 200),
      "Neotest não executou adds_numbers"
    )
    print("[PASS] Neotest descobriu e executou o teste Rust")

    cargo({ "build", "--offline" })
    local initialized, terminated = false, false
    dap.listeners.after.event_initialized.rust_smoke = function()
      initialized = true
    end
    dap.listeners.after.event_terminated.rust_smoke = function()
      terminated = true
    end
    local rust_config = require("rustaceanvim.config.internal")
    assert(rust_config.dap.adapter, "CodeLLDB não configurado")
    dap.adapters.rust_smoke = rust_config.dap.adapter
    dap.run({
      type = "rust_smoke",
      request = "launch",
      name = "Rust smoke",
      program = root .. "/target/debug/nvim_rust_check",
      cwd = root,
      stopOnEntry = false,
    })
    assert(
      vim.wait(60000, function()
        return initialized and terminated
      end, 200),
      "sessão real do CodeLLDB não concluiu"
    )
    print("[PASS] sessão real do CodeLLDB via DAP")
  end, debug.traceback)
  dap.listeners.after.event_initialized.rust_smoke = nil
  dap.listeners.after.event_terminated.rust_smoke = nil
  if dap.session() then
    dap.close()
  end
  vim.cmd("silent! %bwipeout!")
  vim.cmd.cd(vim.fn.stdpath("config"))
  vim.fn.delete(root, "rf")
  if not ok then
    print(err)
  end
  vim.cmd(ok and "qa!" or "cq")
end, 3000)
