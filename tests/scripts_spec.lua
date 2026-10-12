-- Integração real dos scripts Bash em diretórios temporários.
describe("scripts de manutenção", function()
  it("preserva backups e detecta falhas em todas as suítes", function()
    local result = vim.system({ "bash", "tests/scripts.sh" }, { text = true }):wait(30000)
    assert.equals(0, result.code, (result.stdout or "") .. (result.stderr or ""))
  end)
end)
