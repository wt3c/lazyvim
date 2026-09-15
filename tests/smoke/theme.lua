-- Smoke do hot reload do tema Omarchy: simula a troca do symlink theme.lua e o
-- User LazyReload que o lazy dispara, sem mexer no tema do sistema.
return function(check, skip)
  local events = 0
  local group = vim.api.nvim_create_augroup("smoke_theme", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      events = events + 1
      -- Plugins reaplicam seus highlights no ColorScheme; o reload faz `highlight clear` antes.
      vim.api.nvim_set_hl(0, "SmokeThemeSentinel", { fg = "#123456" })
    end,
  })

  local function reload(spec)
    package.preload["plugins.theme"] = spec and function()
      return spec
    end or nil
    events = 0
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyReload" })
    vim.wait(500)
  end

  local function tokyonight(style)
    return {
      { "folke/tokyonight.nvim", priority = 1000, opts = { style = style } },
      { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-" .. style } },
    }
  end

  local initial = vim.g.colors_name

  reload(tokyonight("night"))
  local night_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  check(
    "hot reload aplica tokyonight-night com background dark",
    vim.g.colors_name == "tokyonight-night" and vim.o.background == "dark"
  )
  check("hot reload dispara um único ColorScheme", events == 1)
  check(
    "highlights de plugins voltam após o highlight clear",
    next(vim.api.nvim_get_hl(0, { name = "SmokeThemeSentinel" })) ~= nil
  )

  reload(tokyonight("day"))
  check(
    "hot reload recarrega plugin já carregado (tokyonight-day, background light)",
    vim.g.colors_name == "tokyonight-day"
      and vim.o.background == "light"
      and vim.api.nvim_get_hl(0, { name = "Normal" }).bg ~= night_bg
  )

  -- No CI o symlink do Omarchy não existe: sem plugins.theme o reload não faz nada.
  reload(nil)
  if pcall(require, "plugins.theme") then
    check("hot reload volta ao tema do Omarchy", vim.g.colors_name == initial and vim.fn.exists("syntax_on") == 1)
  else
    skip("volta ao tema do Omarchy (symlink theme.lua ausente)")
  end

  vim.api.nvim_del_augroup_by_id(group)
end
