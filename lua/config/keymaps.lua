-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

vim.keymap.set("n", "<leader>pr", "<cmd>terminal python<cr>", { desc = "Python: REPL" })
vim.keymap.set("n", "<leader>pf", "<cmd>!python %<cr>", { desc = "Python: Run File" })

-- Django management commands
vim.keymap.set("n", "<leader>pR", "<cmd>!python manage.py runserver<cr>", { desc = "Django: Run Server" })
vim.keymap.set("n", "<leader>pM", "<cmd>!python manage.py makemigrations<cr>", { desc = "Django: Make Migrations" })
vim.keymap.set("n", "<leader>pm", "<cmd>!python manage.py migrate<cr>", { desc = "Django: Migrate" })
vim.keymap.set("n", "<leader>ps", "<cmd>!python manage.py shell<cr>", { desc = "Django: Shell" })
vim.keymap.set("n", "<leader>pt", "<cmd>!python manage.py test<cr>", { desc = "Django: Test" })
vim.keymap.set("n", "<leader>pc", "<cmd>!python manage.py collectstatic<cr>", { desc = "Django: Collect Static" })
vim.keymap.set("n", "<leader>pC", "<cmd>!python manage.py createsuperuser<cr>", { desc = "Django: Create Superuser" })

-- ============================================================================
-- DOCKER / DOCKER COMPOSE
-- ============================================================================

-- Docker Compose common operations
vim.keymap.set("n", "<leader>Du", "<cmd>!docker-compose up -d<cr>", { desc = "Docker: Compose Up" })
vim.keymap.set("n", "<leader>Dd", "<cmd>!docker-compose down<cr>", { desc = "Docker: Compose Down" })
vim.keymap.set("n", "<leader>Dr", "<cmd>!docker-compose restart<cr>", { desc = "Docker: Compose Restart" })
vim.keymap.set("n", "<leader>Dl", "<cmd>terminal docker-compose logs -f<cr>", { desc = "Docker: Logs Follow" })
vim.keymap.set("n", "<leader>Db", "<cmd>!docker-compose build<cr>", { desc = "Docker: Compose Build" })
vim.keymap.set("n", "<leader>DB", "<cmd>!docker-compose build --no-cache<cr>", { desc = "Docker: Build No Cache" })

-- Docker commands
vim.keymap.set("n", "<leader>Dp", "<cmd>terminal docker ps<cr>", { desc = "Docker: List Containers" })
vim.keymap.set("n", "<leader>Di", "<cmd>terminal docker images<cr>", { desc = "Docker: List Images" })
vim.keymap.set("n", "<leader>Ds", "<cmd>!docker system prune -f<cr>", { desc = "Docker: System Prune" })

-- Docker exec into container
vim.keymap.set("n", "<leader>De", function()
  vim.ui.input({ prompt = "Container name/ID: " }, function(container)
    if container then
      vim.cmd("terminal docker exec -it " .. container .. " /bin/bash")
    end
  end)
end, { desc = "Docker: Exec Into Container" })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

-- Quick file operations
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<leader>fR", function()
  local old = vim.fn.expand("%")
  vim.ui.input({ prompt = "Rename to: ", default = old }, function(new)
    if new and new ~= "" and new ~= old then
      vim.cmd("saveas " .. vim.fn.fnameescape(new))
      vim.fn.delete(old)
      vim.cmd("redraw!")
    end
  end)
end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>fD", function()
  local file = vim.fn.expand("%")
  vim.ui.input({ prompt = 'Delete "' .. file .. '"? (yes/no): ' }, function(answer)
    if answer == "yes" then
      vim.fn.delete(file)
      vim.cmd("bdelete!")
    end
  end)
end, { desc = "Delete File" })

-- Format file (via conform.nvim, com fallback para LSP)
vim.keymap.set("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format File" })

-- ============================================================================
-- LSP KEYMAPS (Enhanced)
-- ============================================================================

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- ============================================================================
-- DIAGNOSTIC NAVIGATION
-- ============================================================================

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev Error" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- ============================================================================
-- QUICK COMMANDS
-- ============================================================================

-- Quick quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All Force" })

-- Source config
vim.keymap.set("n", "<leader>so", "<cmd>source %<cr>", { desc = "Source Current File" })

-- Toggle options
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle Line Wrap" })
vim.keymap.set("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle Spell Check" })
vim.keymap.set("n", "<leader>ul", "<cmd>set list!<cr>", { desc = "Toggle List Chars" })
vim.keymap.set("n", "<leader>ur", "<cmd>set relativenumber!<cr>", { desc = "Toggle Relative Numbers" })

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
--   <leader>gs - GitSigns: Stage Hunk
--   <leader>gr - GitSigns: Reset Hunk
--   <leader>gS - GitSigns: Stage Buffer
--   <leader>gR - GitSigns: Reset Buffer
--   <leader>gu - GitSigns: Undo Stage
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
-- TERMINAL (test-runner.lua):
--   <C-\> - Terminal: Toggle
--   <leader>tf - Terminal: Float
--   <leader>th - Terminal: Horizontal
--   <leader>tv - Terminal: Vertical
--   <leader>tp - Terminal: Python REPL
--   <leader>tl - Terminal: Docker Logs
--   <leader>tg - Terminal: Lazygit
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
