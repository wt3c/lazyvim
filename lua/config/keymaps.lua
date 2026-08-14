-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function executable(names)
  for _, name in ipairs(names) do
    local path = vim.fn.exepath(name)
    if path ~= "" then
      return path
    end
  end
end

local function python_executable()
  local candidates = {}
  if vim.env.VIRTUAL_ENV then
    candidates[#candidates + 1] = vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  candidates[#candidates + 1] = vim.uv.cwd() .. "/.venv/bin/python"
  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return executable({ "python3", "python" })
end

local function terminal_job(command, opts)
  if not command or not command[1] or vim.fn.executable(command[1]) ~= 1 then
    vim.notify("Executável não encontrado: " .. tostring(command and command[1]), vim.log.levels.ERROR)
    return
  end

  vim.cmd.new()
  local bufnr = vim.api.nvim_get_current_buf()
  local job = vim.fn.jobstart(command, { term = true, cwd = opts and opts.cwd or nil })
  if job <= 0 then
    vim.api.nvim_buf_delete(bufnr, { force = true })
    vim.notify("Não foi possível iniciar: " .. table.concat(command, " "), vim.log.levels.ERROR)
    return
  end
  vim.cmd.startinsert()
end

local function django_command(arguments)
  local current = vim.api.nvim_buf_get_name(0)
  local start = current ~= "" and vim.fs.dirname(current) or vim.uv.cwd()
  local manage = vim.fs.find("manage.py", { path = start, upward = true, type = "file" })[1]
  if not manage then
    vim.notify("manage.py não encontrado nos diretórios-pai", vim.log.levels.ERROR)
    return
  end

  local python = python_executable()
  if not python then
    vim.notify("Python não encontrado", vim.log.levels.ERROR)
    return
  end
  local command = { python, manage }
  vim.list_extend(command, arguments)
  terminal_job(command, { cwd = vim.fs.dirname(manage) })
end

local function compose_command(arguments)
  local command
  local legacy = executable({ "docker-compose" })
  if legacy then
    command = { legacy }
  else
    local docker = executable({ "docker" })
    if not docker then
      vim.notify("Docker Compose não encontrado", vim.log.levels.ERROR)
      return
    end
    command = { docker, "compose" }
  end
  vim.list_extend(command, arguments)
  terminal_job(command)
end

-- ============================================================================
-- EDITOR BASICS
-- ============================================================================

-- Better commenting with Ctrl+/ (using LazyVim's default "gc")
-- Configured in lua/plugins/comments.lua for all modes (Normal, Visual, Insert)
-- Multiple options: Ctrl+/, Ctrl+_, Alt+/, Space+/, gcc
-- Note: Ctrl+/ in most terminals is sent as Ctrl+_

-- Save with Ctrl+S (very modern)
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better escape
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better paste (don't overwrite register)
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yank" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- System clipboard (Ctrl+C / Ctrl+V)
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<C-c>", '"+yy', { desc = "Copy line to clipboard" })
vim.keymap.set({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

-- Split windows
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close current split" })

-- Navigate windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Navigate buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Close buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers except current" })

-- ============================================================================
-- PYTHON / DJANGO
-- ============================================================================

vim.keymap.set("n", "<leader>pr", function()
  local python = python_executable()
  terminal_job(python and { python } or nil)
end, { desc = "Python: REPL" })
vim.keymap.set("n", "<leader>pf", function()
  local python = python_executable()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("O buffer atual ainda não tem arquivo", vim.log.levels.ERROR)
    return
  end
  terminal_job(python and { python, file } or nil)
end, { desc = "Python: Run File" })

-- Django management commands
vim.keymap.set("n", "<leader>pR", function()
  django_command({ "runserver" })
end, { desc = "Django: Run Server" })
vim.keymap.set("n", "<leader>pM", function()
  django_command({ "makemigrations" })
end, { desc = "Django: Make Migrations" })
vim.keymap.set("n", "<leader>pm", function()
  django_command({ "migrate" })
end, { desc = "Django: Migrate" })
vim.keymap.set("n", "<leader>ps", function()
  django_command({ "shell" })
end, { desc = "Django: Shell" })
vim.keymap.set("n", "<leader>pt", function()
  django_command({ "test" })
end, { desc = "Django: Test" })
vim.keymap.set("n", "<leader>pc", function()
  django_command({ "collectstatic" })
end, { desc = "Django: Collect Static" })
vim.keymap.set("n", "<leader>pC", function()
  django_command({ "createsuperuser" })
end, { desc = "Django: Create Superuser" })

-- ============================================================================
-- DOCKER / DOCKER COMPOSE
-- ============================================================================

-- Docker Compose common operations
vim.keymap.set("n", "<leader>Du", function()
  compose_command({ "up", "-d" })
end, { desc = "Docker: Compose Up" })
vim.keymap.set("n", "<leader>Dd", function()
  compose_command({ "down" })
end, { desc = "Docker: Compose Down" })
vim.keymap.set("n", "<leader>Dr", function()
  compose_command({ "restart" })
end, { desc = "Docker: Compose Restart" })
vim.keymap.set("n", "<leader>Dl", function()
  compose_command({ "logs", "-f" })
end, { desc = "Docker: Logs Follow" })
vim.keymap.set("n", "<leader>Db", function()
  compose_command({ "build" })
end, { desc = "Docker: Compose Build" })
vim.keymap.set("n", "<leader>DB", function()
  compose_command({ "build", "--no-cache" })
end, { desc = "Docker: Build No Cache" })

-- Docker commands
vim.keymap.set("n", "<leader>Dp", function()
  local docker = executable({ "docker" })
  terminal_job(docker and { docker, "ps" } or nil)
end, { desc = "Docker: List Containers" })
vim.keymap.set("n", "<leader>Di", function()
  local docker = executable({ "docker" })
  terminal_job(docker and { docker, "images" } or nil)
end, { desc = "Docker: List Images" })
vim.keymap.set("n", "<leader>Ds", function()
  vim.ui.select({ "Cancelar", "Executar docker system prune" }, {
    prompt = "Remover recursos Docker não utilizados?",
  }, function(choice)
    if choice == "Executar docker system prune" then
      local docker = executable({ "docker" })
      terminal_job(docker and { docker, "system", "prune", "-f" } or nil)
    end
  end)
end, { desc = "Docker: System Prune" })

-- Docker exec into container
vim.keymap.set("n", "<leader>De", function()
  vim.ui.input({ prompt = "Container name/ID: " }, function(container)
    if not container or container == "" then
      return
    end

    local docker = executable({ "docker" })
    terminal_job(docker and { docker, "exec", "-it", container, "/bin/bash" } or nil)
  end)
end, { desc = "Docker: Exec Into Container" })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

-- Quick file operations
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<leader>fR", function()
  local old = vim.api.nvim_buf_get_name(0)
  vim.ui.input({ prompt = "Rename to: ", default = old }, function(new)
    if new and new ~= "" and new ~= old then
      vim.api.nvim_cmd({ cmd = "saveas", args = { new }, magic = { file = false, bar = false } }, {})
      if old ~= "" and vim.fn.delete(old) ~= 0 then
        vim.notify("Novo arquivo salvo, mas não foi possível remover: " .. old, vim.log.levels.WARN)
      end
      vim.cmd.redraw({ bang = true })
    end
  end)
end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>fD", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("O buffer atual ainda não tem arquivo", vim.log.levels.ERROR)
    return
  end
  vim.ui.input({ prompt = 'Delete "' .. file .. '"? (yes/no): ' }, function(answer)
    if answer == "yes" then
      if vim.fn.delete(file) ~= 0 then
        vim.notify("Não foi possível excluir: " .. file, vim.log.levels.ERROR)
        return
      end
      vim.api.nvim_buf_delete(0, { force = true })
    end
  end)
end, { desc = "Delete File" })

-- Format file (via conform.nvim, com fallback para LSP)
vim.keymap.set("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format File" })

-- ============================================================================
-- LSP KEYMAPS
-- ============================================================================
--
-- NOTE: gd/gD/gi/gr/K/<leader>ca/<leader>cr/<leader>cs sao fornecidos pelo
-- LazyVim no evento LspAttach, com UI superior (picker fzf/Snacks) e ativos
-- apenas em buffers com LSP. Nao redefinir aqui para evitar regressao.

-- ============================================================================
-- DIAGNOSTIC NAVIGATION
-- ============================================================================
-- Usa vim.diagnostic.jump com o contrato atual do Neovim 0.12.

local function jump_to_error(count)
  vim.diagnostic.jump({
    count = count,
    severity = vim.diagnostic.severity.ERROR,
    -- `float` em JumpOpts foi depreciado no Neovim 0.12. O callback é
    -- executado depois do salto, então o float usa a nova posição do cursor.
    on_jump = function(diagnostic, bufnr)
      if diagnostic then
        vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor" })
      end
    end,
  })
end

-- Navegar apenas por ERROS (complementa os []d do LazyVim que cobrem tudo)
vim.keymap.set("n", "[e", function()
  jump_to_error(-1)
end, { desc = "Prev Error" })
vim.keymap.set("n", "]e", function()
  jump_to_error(1)
end, { desc = "Next Error" })

-- ============================================================================
-- QUICK COMMANDS
-- ============================================================================

-- Quick quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All Force" })

-- Source config
vim.keymap.set("n", "<leader>so", "<cmd>source %<cr>", { desc = "Source Current File" })

-- Toggle options
-- NOTE: wrap/spell/relativenumber/line-number ja sao cobertos pelo LazyVim core
-- (Snacks.toggle em <leader>uw/us/uL/ul) -- nao duplicar aqui, so o que falta:
vim.keymap.set("n", "<leader>uv", "<cmd>set list!<cr>", { desc = "Toggle List Chars (view whitespace)" })

-- ============================================================================
-- DICTIONARY (DEFINITIONS)
-- ============================================================================

local function dictionary_word()
  if vim.fn.mode():match("[vV\22]") then
    local previous = vim.fn.getreg('"')
    local previous_type = vim.fn.getregtype('"')
    vim.cmd("normal! y")
    local selected = vim.trim(vim.fn.getreg('"'):gsub("[\r\n]+", " "))
    vim.fn.setreg('"', previous, previous_type)
    return selected
  end
  return vim.fn.expand("<cword>")
end

local function lookup_dictionary(language)
  local word = dictionary_word()
  if word == "" then
    vim.notify("Nenhuma palavra selecionada", vim.log.levels.WARN)
    return
  end

  local host = language == "pt" and "pt.wiktionary.org" or "en.wiktionary.org"
  local url = ("https://%s/wiki/Special:Search?search=%s"):format(host, vim.uri_encode(word))
  local ok, err = vim.ui.open(url)
  if not ok then
    vim.notify("Não foi possível abrir o dicionário: " .. tostring(err), vim.log.levels.ERROR)
  end
end

vim.keymap.set({ "n", "x" }, "<leader>zp", function()
  lookup_dictionary("pt")
end, { desc = "Dicionário: português" })

vim.keymap.set({ "n", "x" }, "<leader>ze", function()
  lookup_dictionary("en")
end, { desc = "Dictionary: English" })

vim.keymap.set({ "n", "x" }, "<leader>zd", function()
  vim.ui.select({ "Português brasileiro", "English" }, { prompt = "Consultar em qual dicionário?" }, function(choice)
    if choice then
      lookup_dictionary(choice == "Português brasileiro" and "pt" or "en")
    end
  end)
end, { desc = "Dicionário: escolher idioma" })

-- ============================================================================
-- NOTES
-- ============================================================================

-- The following keybindings are defined by plugins:
--
-- GIT (git-modern.lua):
--   <leader>gg - Neogit: Open
--   <leader>gc - Neogit: Commit
--   <leader>gp - Neogit: Push
--   <leader>gP - Neogit: Pull
--   <leader>gd - Diffview: Open
--   <leader>gD - Diffview: Close
--   <leader>gh - Diffview: File History
--   <leader>gH - Diffview: Project History
--   <leader>gs - GitSigns: Stage/Unstage Hunk
--   <leader>gr - GitSigns: Reset Hunk
--   <leader>gS - GitSigns: Stage Buffer
--   <leader>gR - GitSigns: Reset Buffer
--   <leader>gv - GitSigns: Preview Hunk
--   <leader>gb - GitSigns: Blame Line
--   <leader>gB - GitSigns: Toggle Blame
--   ]h - Next Hunk
--   [h - Prev Hunk
--
-- TEST RUNNER (test-runner.lua):
--   <leader>tt - Test: Run Nearest
--   <leader>tf - Test: Run File
--   <leader>tT - Test: Run All
--   <leader>ts - Test: Toggle Summary
--   <leader>to - Test: Show Output
--   <leader>tO - Test: Toggle Output Panel
--   <leader>tS - Test: Stop
--   <leader>tw - Test: Toggle Watch
--   <leader>td - Test: Debug Nearest
--
-- TASK RUNNER (test-runner.lua):
--   <leader>rr - Run: Task
--   <leader>rt - Run: Toggle
--   <leader>ri - Run: Info
--   <leader>ra - Run: Task Action
--
-- TERMINAL (test-runner.lua) -- prefixo <leader>T para nao colidir com testes:
--   <C-\> - Terminal: Toggle
--   <leader>Tf - Terminal: Float
--   <leader>Th - Terminal: Horizontal
--   <leader>Tv - Terminal: Vertical
--   <leader>Tp - Terminal: Python REPL
--   <leader>Tl - Terminal: Docker Logs
--   <leader>Tg - Terminal: Lazygit
--
-- TROUBLE (test-runner.lua):
--   <leader>xx - Trouble: Diagnostics
--   <leader>xX - Trouble: Buffer Diagnostics
--   <leader>xL - Trouble: Location List
--   <leader>xQ - Trouble: Quickfix List
--   <leader>xs - Trouble: Symbols
--   <leader>xl - Trouble: LSP Definitions/References
--
-- TELESCOPE (modern-ui.lua):
--   <leader><space> - Buffers
--   <leader>ff - Find Files
--   <leader>fr - Recent Files
--   <leader>fg - Live Grep
--   <leader>fw - Grep Word
--   <leader>fh - Help Tags
--   <leader>fk - Keymaps
--   <leader>fc - Commands
--   <leader>fs - Document Symbols
--   <leader>fS - Workspace Symbols
--   <leader>fd - Diagnostics
--   <leader>fgc - Git: Commits
--   <leader>fgb - Git: Branches
--   <leader>fgs - Git: Status
--   <leader>fgh - Git: Stash
