return {
  "ojroques/nvim-osc52",
  event = "VeryLazy",
  config = function()
    require("osc52").setup({})
    local function copy(lines, _)
      require("osc52").copy(table.concat(lines, "\n"))
    end
    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = function() return { "" }, {} end, ["*"] = function() return { "" }, {} end },
    }
    -- opcional: mapear y para copiar automaticamente via osc52
    vim.keymap.set({ "n", "x" }, "y", function()
      require("osc52").copy_visual()
    end, { expr = true })
  end,
}
