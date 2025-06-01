-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- ~/.config/nvim/lua/config/options.lua

-- Garanta que 'opt' está disponível
local opt = vim.opt

-- Configurações já existentes do LazyVim ou suas outras configurações podem estar aqui...
-- Exemplo:
-- opt.autowrite = true -- Salva automaticamente ao sair de um buffer modificado
-- opt.clipboard = "unnamedplus" -- Usa o clipboard do sistema
-- opt.completeopt = "menu,menuone,noselect"
-- ... e assim por diante.

-- [[ Configurações Adicionais Solicitadas ]]

-- 1. Linha Vertical (Colorcolumn) em 120 colunas
opt.colorcolumn = "120"
-- Se quisesse múltiplas colunas, seria algo como "80,120"

-- 2. Números de Linha Sequenciais
opt.number = true -- Mostrar números de linha
opt.relativenumber = false -- DESABILITAR números de linha relativos
-- LazyVim pode habilitar relativenumber por padrão,
-- então é importante definir explicitamente como false.

-- [[ Outras Opções Úteis (Muitas já são padrão no LazyVim, mas para referência) ]]

-- UI
opt.termguicolors = true -- Habilita cores verdadeiras no terminal
opt.signcolumn = "yes" -- Sempre mostrar a signcolumn, para não deslocar o texto (LSP, GitSigns)
opt.cursorline = true -- Destaca a linha atual
opt.wrap = false -- Desabilitar quebra de linha (preferência pessoal)

-- Indentação (LazyVim já configura bem para Python via treesitter, mas para garantir)
opt.expandtab = true -- Usar espaços em vez de TABs
opt.shiftwidth = 4 -- Número de espaços para indentação automática
opt.tabstop = 4 -- Número de espaços que um TAB conta como
opt.softtabstop = 4 -- Número de espaços que um TAB insere no modo de inserção

-- Busca
opt.ignorecase = true -- Ignorar caixa na busca
opt.smartcase = true -- Não ignorar caixa se a busca contiver letras maiúsculas

-- Comportamento
opt.mouse = "a" -- Habilitar mouse em todos os modos
opt.undofile = true -- Persistir histórico de undo entre sessões
opt.backup = false -- Não criar arquivos de backup
opt.writebackup = false -- Não criar arquivos de backup ao salvar
opt.swapfile = false -- Não criar arquivos de swap
opt.scrolloff = 8 -- Manter 8 linhas de contexto acima/abaixo do cursor
opt.sidescrolloff = 8 -- Manter 8 colunas de contexto à esquerda/direita do cursor

-- Opcional: Retornar uma tabela para o framework do LazyVim, se necessário
-- para sobrescrever opções específicas do LazyVim.
-- Para vim.opt, geralmente não é necessário retornar nada aqui,
-- a menos que você esteja sobrescrevendo algo que LazyVim define
-- através do seu sistema de `opts` interno para `vim.g` ou `vim.opt`.
-- As atribuições diretas a `vim.opt` acima devem funcionar.
-- return {
--   -- Por exemplo, se LazyVim tivesse uma opção `ui.relativenumber = true`
--   -- você poderia sobrescrevê-la aqui:
--   -- ui = {
--   --   relativenumber = false,
--   -- },
-- }
