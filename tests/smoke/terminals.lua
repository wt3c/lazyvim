-- Smoke dos terminais Snacks: pressiona os atalhos de verdade num projeto Python
-- temporário (venv + compose.yaml) e confere posição, comando e cwd de cada terminal.
return function(check, skip)
  local function press(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "mx", false)
    vim.wait(300)
  end

  local function terminals()
    local list = {}
    for _, term in ipairs(Snacks.terminal.list()) do
      if term:win_valid() then
        local info = vim.b[term.buf].snacks_terminal or {}
        list[#list + 1] = { term = term, position = term.opts.position, cmd = info.cmd, cwd = info.cwd }
      end
    end
    return list
  end

  local function destroy_all()
    for _, term in ipairs(Snacks.terminal.list()) do
      term:close()
    end
    vim.cmd("stopinsert")
    vim.wait(100)
  end

  -- Fechar o terminal mata o job, e o TermClose do Snacks acusa "exited with code" em
  -- toda saída não zero; aqui isso é esperado, então o aviso fica mudo nesta seção.
  local notify_error = Snacks.notify.error
  Snacks.notify.error = function() end

  local project = vim.fn.tempname()
  vim.fn.mkdir(project .. "/.venv/bin", "p")
  vim.fn.mkdir(project .. "/app", "p")
  vim.fn.writefile({}, project .. "/pyproject.toml")
  vim.fn.writefile({ "services: {}" }, project .. "/compose.yaml")
  vim.uv.fs_symlink(vim.fn.exepath("python3"), project .. "/.venv/bin/python")
  vim.cmd.edit(vim.fn.fnameescape(project .. "/app/main.py"))
  local source = vim.api.nvim_get_current_win()

  local function reset()
    destroy_all()
    vim.api.nvim_set_current_win(source)
  end

  press("<Space>Tf")
  local open = terminals()
  check("<leader>Tf abre um terminal float", #open == 1 and open[1].position == "float")

  vim.api.nvim_set_current_win(open[1].term.win)
  vim.cmd("startinsert")
  vim.wait(100)
  press("<C-\\>")
  check("<C-\\> no modo terminal esconde o float", #terminals() == 0)
  vim.api.nvim_set_current_win(source)
  press("<C-\\>")
  open = terminals()
  check("<C-\\> no modo normal reabre o mesmo float", #open == 1 and open[1].position == "float")
  reset()

  press("<Space>Th")
  vim.api.nvim_set_current_win(source)
  press("<Space>Tv")
  local positions = vim.tbl_map(function(term)
    return term.position
  end, terminals())
  table.sort(positions)
  check("<leader>Th e <leader>Tv abrem terminais separados", vim.deep_equal(positions, { "bottom", "right" }))
  reset()

  press("<Space>Tp")
  open = terminals()
  check("<leader>Tp usa o python do .venv", open[1] and vim.deep_equal(open[1].cmd, { project .. "/.venv/bin/python" }))
  check("<leader>Tp roda na raiz do projeto", open[1] and open[1].cwd == project)
  reset()

  local compose = require("config.docker").compose({ "logs", "-f" })
  if compose then
    press("<Space>Tl")
    open = terminals()
    check("<leader>Tl roda docker compose logs -f", open[1] and vim.deep_equal(open[1].cmd, compose))
    check("<leader>Tl roda no diretório do compose file", open[1] and open[1].cwd == project)
    reset()
  else
    skip("<leader>Tl (Docker Compose ausente)")
  end

  if vim.fn.executable("lazygit") == 1 then
    press("<Space>Tg")
    open = terminals()
    check("<leader>Tg abre o lazygit", open[1] and vim.deep_equal(open[1].cmd, { "lazygit" }))
    reset()
  else
    skip("<leader>Tg (lazygit ausente)")
  end

  vim.cmd("bwipeout!")
  vim.fn.delete(project, "rf")
  vim.wait(200)
  Snacks.notify.error = notify_error
end
