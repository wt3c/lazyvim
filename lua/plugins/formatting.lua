-- ~/.config/nvim/lua/plugins/formatting.lua
-- Global formatting configuration with line-length = 120 for all languages

-- Prefere o ruff do venv ativo ou de .venv/ local; cai no Mason/PATH como fallback.
-- Garante que a versão do ruff usada seja a mesma do projeto (pyproject.toml).
local function find_ruff()
  local venv = vim.env.VIRTUAL_ENV
  if venv then
    local bin = venv .. "/bin/ruff"
    if vim.fn.executable(bin) == 1 then
      return bin
    end
  end
  local bin = vim.fn.getcwd() .. "/.venv/bin/ruff"
  if vim.fn.executable(bin) == 1 then
    return bin
  end
  return "ruff"
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        lua = { "stylua" },
        toml = { "taplo" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        fish = { "fish_indent" },
        json = { "prettier" },
        yaml = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier", "md_table_sep" },
      },
      formatters = {
        ruff_format = { command = find_ruff },
        ruff_organize_imports = { command = find_ruff },
        stylua = {
          prepend_args = { "--column-width", "120" },
        },
        prettier = {
          prepend_args = function(_, ctx)
            local args = { "--print-width", "120" }
            if ctx.filename:match("%.md$") then
              vim.list_extend(args, { "--prose-wrap", "always" })
            end
            return args
          end,
        },
        shfmt = {
          prepend_args = { "-i", "2", "-bn", "-ci", "-sr" },
        },
        -- Convert table separator rows to match PyCharm style:
        -- | --- | --- |  →  |---|---|  (spaces become dashes, same column width)
        -- Skips lines inside ``` / ~~~ fenced code blocks and lines with : (alignment markers).
        md_table_sep = {
          command = "awk",
          args = {
            [[/^```/ || /^~~~/ { in_code = !in_code } !in_code && /^\|( *-+ *\|)+$/ { gsub(/ /, "-") } { print }]],
          },
          stdin = true,
        },
      },
    },
  },
}
