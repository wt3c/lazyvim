-- Rastro do cursor: destaca a célula deixada a cada movimento, esmaece e remove.
-- Adaptado de FractalCodeRicardo/dev-config (nvim/lua/my/cursor-animation.lua).
local M = {}

local ns = vim.api.nvim_create_namespace("CursorAnimation")
local STAGE_MS = 200
local active = true

local function set_highlights()
  vim.api.nvim_set_hl(0, "CursorAnimationStart", { link = "IncSearch" })
  vim.api.nvim_set_hl(0, "CursorAnimationFade", { link = "Visual" })
end

-- Sem end_col a célula não tem texto (linha vazia): pinta um espaço sobreposto.
local function decoration(hl, end_row, end_col)
  if end_col then
    return { end_row = end_row, end_col = end_col, hl_group = hl, strict = false }
  end
  return { virt_text = { { " ", hl } }, virt_text_pos = "overlay", strict = false }
end

-- Relê a posição da marca: o texto pode ter mudado desde que ela foi criada.
local function fade(buf, id)
  if not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  local mark = vim.api.nvim_buf_get_extmark_by_id(buf, ns, id, { details = true })
  if #mark == 0 then
    return
  end
  local opts = decoration("CursorAnimationFade", mark[3].end_row, mark[3].end_col)
  opts.id = id
  vim.api.nvim_buf_set_extmark(buf, ns, mark[1], mark[2], opts)
end

local function remove(buf, id)
  if vim.api.nvim_buf_is_loaded(buf) then
    vim.api.nvim_buf_del_extmark(buf, ns, id)
  end
end

-- A marca pertence ao buffer: com dois splits, o rastro apareceria nos dois.
local function should_animate(buf)
  return active
    and vim.api.nvim_get_mode().mode == "n"
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].filetype ~= "bigfile"
    and vim.fn.reg_executing() == ""
    and #vim.fn.win_findbuf(buf) == 1
end

local function on_cursor_moved()
  local buf = vim.api.nvim_get_current_buf()
  if not should_animate(buf) then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
  if #line > 0 and col >= #line then
    return
  end

  -- Os timers da marca antiga viram no-op, pois ela já não existe.
  for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(buf, ns, { row, col }, { row, col }, {})) do
    vim.api.nvim_buf_del_extmark(buf, ns, mark[1])
  end

  local end_col = #line > 0 and col + 1 + vim.str_utf_end(line, col + 1) or nil
  local id = vim.api.nvim_buf_set_extmark(buf, ns, row, col, decoration("CursorAnimationStart", row, end_col))
  vim.defer_fn(function()
    fade(buf, id)
    vim.defer_fn(function()
      remove(buf, id)
    end, STAGE_MS)
  end, STAGE_MS)
end

function M.enabled()
  return active
end

function M.set_enabled(value)
  active = value
  if active then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
  end
end

function M.setup()
  set_highlights()
  local group = vim.api.nvim_create_augroup("cursor_animation", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
  vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = on_cursor_moved })
end

return M
