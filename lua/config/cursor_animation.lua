-- Rastro do cursor: destaca a célula deixada a cada movimento, esmaece e remove.
-- Adaptado de FractalCodeRicardo/dev-config (nvim/lua/my/cursor-animation.lua).
local M = {}

local ns = vim.api.nvim_create_namespace("CursorAnimation")
local STAGE_MS = 200

local function set_highlights()
  vim.api.nvim_set_hl(0, "CursorAnimationStart", { link = "IncSearch" })
  vim.api.nvim_set_hl(0, "CursorAnimationFade", { link = "Visual" })
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
  vim.api.nvim_buf_set_extmark(buf, ns, mark[1], mark[2], {
    id = id,
    end_row = mark[3].end_row,
    end_col = mark[3].end_col,
    hl_group = "CursorAnimationFade",
    strict = false,
  })
end

local function remove(buf, id)
  if vim.api.nvim_buf_is_loaded(buf) then
    vim.api.nvim_buf_del_extmark(buf, ns, id)
  end
end

local function on_cursor_moved()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" or vim.fn.reg_executing() ~= "" then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
  if col >= #line then
    return
  end

  local id = vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
    end_row = row,
    end_col = col + 1 + vim.str_utf_end(line, col + 1),
    hl_group = "CursorAnimationStart",
  })
  vim.defer_fn(function()
    fade(buf, id)
    vim.defer_fn(function()
      remove(buf, id)
    end, STAGE_MS)
  end, STAGE_MS)
end

function M.setup()
  set_highlights()
  local group = vim.api.nvim_create_augroup("cursor_animation", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
  vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = on_cursor_moved })
end

return M
