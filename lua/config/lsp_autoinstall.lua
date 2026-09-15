-- Auto-instalacao de LSP: ao abrir um arquivo cujo filetype tem servidor(es)
-- disponiveis no mason-lspconfig mas nenhum deles instalado ainda, instala
-- automaticamente em vez de exigir declaracao previa em lua/plugins/*.lua ou
-- rodar :LspInstall manualmente.
--
-- Escopo deliberadamente restrito: só age quando NENHUM candidato do filetype
-- esta instalado. Se ja existe um instalado (ex.: pyright declarado em
-- python-tools.lua), nao mexe -- evita reinstalar/duplicar servidor escolhido
-- explicitamente. Em filetypes com varios candidatos e nenhum instalado, nao
-- escolhe por adivinhacao: notifica e sugere :LspInstall para o usuario decidir.

local notified_filetypes = {}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lsp_autoinstall", { clear = true }),
  callback = function(ev)
    local ft = ev.match
    if ft == "" then
      return
    end

    local ok_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
    local ok_registry, registry = pcall(require, "mason-registry")
    if not (ok_lspconfig and ok_registry) then
      return
    end

    local candidates = mason_lspconfig.get_available_servers({ filetype = ft })
    if #candidates == 0 then
      return
    end

    local lspconfig_to_package = mason_lspconfig.get_mappings().lspconfig_to_package
    local not_installed = {}
    for _, server in ipairs(candidates) do
      local pkg = lspconfig_to_package[server]
      if pkg and not registry.is_installed(pkg) then
        table.insert(not_installed, { server = server, package = pkg })
      end
    end

    -- Ja tem pelo menos um candidato instalado (ex.: declarado manualmente) -> nada a fazer.
    if #not_installed == #candidates and #not_installed == 1 then
      local target = not_installed[1]
      local pkg = registry.get_package(target.package)
      -- Outro buffer do mesmo filetype já disparou a instalação.
      if pkg:is_installing() then
        return
      end
      vim.notify(
        ("LSP: instalando %s (%s) automaticamente..."):format(target.server, target.package),
        vim.log.levels.INFO
      )
      pkg:install({}, function(success, err)
        if not success then
          vim.schedule(function()
            vim.notify(
              ("LSP: falha ao instalar %s: %s"):format(target.package, tostring(err)),
              vim.log.levels.ERROR
            )
          end)
        end
      end)
    elseif #not_installed == #candidates and #not_installed > 1 and not notified_filetypes[ft] then
      notified_filetypes[ft] = true
      local names = vim.tbl_map(function(c)
        return c.server
      end, not_installed)
      vim.notify(
        ("LSP: %d servidores disponiveis para %q (%s), nenhum instalado. Rode :LspInstall para escolher."):format(
          #names,
          ft,
          table.concat(names, ", ")
        ),
        vim.log.levels.WARN
      )
    end
  end,
})
