-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Format-on-save: gerenciado pelo conform.nvim (configurado em plugins/formatting.lua)
-- Linting: gerenciado pelo nvim-lint (configurado em plugins/markdown-tools.lua e python-tools.lua)
-- Ambos sao inicializados automaticamente pelo LazyVim -- nao e necessario duplicar aqui.

-- Auto-reload: recarregar buffers quando arquivos sao modificados externamente
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload_files", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Hot-reload: re-executa options/keymaps/autocmds ao salvar, sem precisar
-- reiniciar o nvim. lua/plugins/*.lua ja e recarregado automaticamente pelo
-- lazy.nvim (change_detection.enabled = default do LazyVim) -- nao duplicar aqui.
-- lazy.lua/init.lua ficam de fora: fazem bootstrap do lazy.nvim e nao sao
-- seguros de re-executar em quente (duplicariam o setup).
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("config_hot_reload", { clear = true }),
  pattern = vim.fn.stdpath("config") .. "/lua/config/*.lua",
  callback = function(ev)
    local reloadable = { ["options.lua"] = true, ["keymaps.lua"] = true, ["autocmds.lua"] = true }
    local basename = vim.fn.fnamemodify(ev.file, ":t")
    if not reloadable[basename] then
      return
    end
    local ok, err = pcall(dofile, ev.file)
    if ok then
      vim.notify("Config recarregada: " .. basename, vim.log.levels.INFO)
    else
      vim.notify("Erro ao recarregar " .. basename .. ": " .. err, vim.log.levels.ERROR)
    end
  end,
})

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
      local temporary = ("%s.%d.tmp"):format(pt_spl, vim.uv.os_getpid())
      local ok, err = pcall(vim.system, {
        "curl",
        "-fLso",
        temporary,
        "https://ftp.nluug.nl/pub/vim/runtime/spell/pt.utf-8.spl",
      }, { text = true }, function(result)
        vim.schedule(function()
          if result.code == 0 then
            local renamed = vim.uv.fs_rename(temporary, pt_spl)
            if renamed then
              vim.notify("Dicionário pt instalado com sucesso!", vim.log.levels.INFO)
              return
            end
          end
          vim.uv.fs_unlink(temporary)
          vim.notify("Falha ao baixar dicionário. Rode :spell pt manualmente.", vim.log.levels.WARN)
        end)
      end)
      if not ok then
        vim.schedule(function()
          vim.notify("Não foi possível iniciar o download do dicionário: " .. tostring(err), vim.log.levels.WARN)
        end)
      end
    end
  end,
})
