-- Rastro do cursor: exercita extmarks, timers e highlights reais do Neovim.

local animation = require("config.cursor_animation")
local ns = vim.api.nvim_create_namespace("CursorAnimation")

local function file_buffer(lines, cursor)
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, cursor or { 1, 0 })
  return buf
end

local function move()
  vim.api.nvim_exec_autocmds("CursorMoved", {})
end

local function marks(buf)
  return vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true })
end

local function wait_until_clear(buf)
  return vim.wait(1000, function()
    return #marks(buf) == 0
  end, 10)
end

describe("config/cursor_animation", function()
  before_each(function()
    vim.cmd.only()
    animation.setup()
    animation.set_enabled(true)
    vim.v.errmsg = ""
  end)

  it("destaca a célula do cursor em um buffer de arquivo", function()
    local buf = file_buffer({ "abc" }, { 1, 1 })
    move()
    local mark = marks(buf)[1]
    assert.are.equal(0, mark[2])
    assert.are.equal(1, mark[3])
    assert.are.equal(2, mark[4].end_col)
    assert.are.equal("CursorAnimationStart", mark[4].hl_group)
  end)

  it("cobre o caractere acentuado inteiro", function()
    local buf = file_buffer({ "ação" }, { 1, 1 })
    move()
    assert.are.equal(3, marks(buf)[1][4].end_col)
  end)

  it("esmaece e depois remove a marca", function()
    local buf = file_buffer({ "abc" })
    move()
    local faded = vim.wait(1000, function()
      local mark = marks(buf)[1]
      return mark and mark[4].hl_group == "CursorAnimationFade"
    end, 5)
    assert.is_true(faded)
    assert.is_true(wait_until_clear(buf))
  end)

  it("limpa o buffer de origem mesmo após trocar de buffer", function()
    local origin = file_buffer({ "abc" })
    move()
    file_buffer({ "outro" })
    assert.is_true(wait_until_clear(origin))
  end)

  it("ignora buffers especiais", function()
    local buf = file_buffer({ "abc" })
    vim.bo[buf].buftype = "nofile"
    move()
    assert.are.equal(0, #marks(buf))
  end)

  it("desenha o rastro em linha vazia, esmaece e remove", function()
    local buf = file_buffer({ "" })
    move()
    assert.are.equal("CursorAnimationStart", marks(buf)[1][4].virt_text[1][2])
    local faded = vim.wait(1000, function()
      local mark = marks(buf)[1]
      return mark and mark[4].virt_text[1][2] == "CursorAnimationFade"
    end, 5)
    assert.is_true(faded)
    assert.is_true(wait_until_clear(buf))
    assert.are.equal("", vim.v.errmsg)
  end)

  it("não anima buffer aberto em mais de uma janela", function()
    local buf = file_buffer({ "abc" })
    vim.cmd.vsplit()
    move()
    assert.are.equal(0, #marks(buf))
  end)

  it("não anima no modo visual", function()
    local buf = file_buffer({ "abc" })
    vim.cmd("normal! v")
    move()
    vim.cmd("normal! \27")
    assert.are.equal(0, #marks(buf))
  end)

  it("mantém uma marca por célula", function()
    local buf = file_buffer({ "abc" })
    for _ = 1, 5 do
      move()
    end
    assert.are.equal(1, #marks(buf))
  end)

  it("reinicia a animação ao voltar para a mesma célula", function()
    local buf = file_buffer({ "abc" })
    move()
    vim.wait(1000, function()
      local mark = marks(buf)[1]
      return mark and mark[4].hl_group == "CursorAnimationFade"
    end, 5)
    move()
    assert.are.equal("CursorAnimationStart", marks(buf)[1][4].hl_group)
  end)

  it("ignora arquivos grandes marcados pelo Snacks", function()
    local buf = file_buffer({ "abc" })
    vim.bo[buf].filetype = "bigfile"
    move()
    assert.are.equal(0, #marks(buf))
  end)

  it("pode ser desligado e religado", function()
    local buf = file_buffer({ "abc" })
    move()
    animation.set_enabled(false)
    assert.is_false(animation.enabled())
    assert.are.equal(0, #marks(buf))
    move()
    assert.are.equal(0, #marks(buf))
    animation.set_enabled(true)
    assert.is_true(animation.enabled())
    move()
    assert.are.equal(1, #marks(buf))
  end)

  it("não anima durante a execução de macro", function()
    local buf = file_buffer({ "abc" })
    local original = vim.fn.reg_executing
    vim.fn.reg_executing = function()
      return "q"
    end
    move()
    vim.fn.reg_executing = original
    assert.are.equal(0, #marks(buf))
  end)

  it("sobrevive à remoção do buffer durante a animação", function()
    local buf = file_buffer({ "abc" })
    move()
    file_buffer({ "outro" })
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.wait(500)
    assert.are.equal("", vim.v.errmsg)
  end)

  it("sobrevive à remoção da linha durante a animação", function()
    local buf = file_buffer({ "abc", "def" }, { 2, 1 })
    move()
    vim.api.nvim_buf_set_lines(buf, 1, 2, false, {})
    assert.is_true(wait_until_clear(buf))
    assert.are.equal("", vim.v.errmsg)
  end)

  it("mantém as cores vinculadas ao tema após trocar o colorscheme", function()
    vim.cmd.colorscheme("default")
    assert.are.equal("IncSearch", vim.api.nvim_get_hl(0, { name = "CursorAnimationStart" }).link)
    assert.are.equal("Visual", vim.api.nvim_get_hl(0, { name = "CursorAnimationFade" }).link)
  end)

  it("é carregado pelos autocmds da config", function()
    local source = table.concat(vim.fn.readfile("lua/config/autocmds.lua"), "\n")
    assert.truthy(source:find('require("config.cursor_animation").setup()', 1, true))
  end)
end)
