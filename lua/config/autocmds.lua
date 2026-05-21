-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Format-on-save: gerenciado pelo conform.nvim (configurado em plugins/formatting.lua)
-- Linting: gerenciado pelo nvim-lint (configurado em plugins/markdown-tools.lua e python-tools.lua)
-- Ambos sao inicializados automaticamente pelo LazyVim -- nao e necessario duplicar aqui.

-- Spell: habilitar apenas em filetypes de texto (nao em codigo)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("spell_text", { clear = true }),
  pattern = { "markdown", "text", "gitcommit", "rst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Spell: download automatico do dicionario portugues na primeira sessao
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("spell_download", { clear = true }),
  once = true,
  callback = function()
    local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
    vim.fn.mkdir(spell_dir, "p")
    local pt_spl = spell_dir .. "/pt.utf-8.spl"
    if vim.fn.filereadable(pt_spl) == 0 then
      vim.notify("Baixando dicionário pt (português)...", vim.log.levels.INFO)
      vim.fn.jobstart({
        "curl", "-fLso", pt_spl,
        "https://ftp.nluug.nl/pub/vim/runtime/spell/pt.utf-8.spl",
      }, {
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.notify("Dicionário pt instalado com sucesso!", vim.log.levels.INFO)
            else
              vim.notify("Falha ao baixar dicionário. Rode :spell pt manualmente.", vim.log.levels.WARN)
            end
          end)
        end,
      })
    end
  end,
})
