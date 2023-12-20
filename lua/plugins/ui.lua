return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skp = true },
      })
      opts.presets.lsp_doc_border = true
    end,
  },
}
