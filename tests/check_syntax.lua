-- Validação de sintaxe de todos os arquivos Lua da config.
-- Rodar com: nvim -l tests/check_syntax.lua

local files = vim.fn.globpath("lua", "**/*.lua", false, true)
table.insert(files, "init.lua")
vim.list_extend(files, vim.fn.globpath("tests", "*.lua", false, true))

local ok = true
for _, file in ipairs(files) do
  local chunk, err = loadfile(file)
  if not chunk then
    io.stderr:write("ERRO DE SINTAXE em " .. file .. ":\n  " .. err .. "\n")
    ok = false
  end
end

if not ok then
  os.exit(1)
end

print(("sintaxe OK (%d arquivos)"):format(#files))
