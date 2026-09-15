# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository

This is a personal LazyVim-based Neovim configuration (Lua), tuned for Python/Django development, plus Docker,
SQL, Git and Jupyter tooling. It is a config repo, not an application — "the build" is booting Neovim itself,
and "the tests" verify the config's invariants and boot health rather than business logic.

## Commands

```bash
make test         # full suite: syntax + specs + smoke (boots the real config)
make test-unit    # syntax + specs only (does not install all plugins) — CI job `test`
make test-smoke   # boot smoke test only
make syntax       # Lua syntax validation only (tests/check_syntax.lua)

# Run a single spec file directly:
nvim --headless -u tests/minimal_init.lua \
  -c "PlenaryBustedFile tests/config_spec.lua {minimal_init='tests/minimal_init.lua'}" +qa
```

`tests/run.sh` is the actual orchestrator behind the Makefile targets (`unit`/`smoke`/`all`). CI
(`.github/workflows/test.yml`) runs on pushes to `main` and on every pull request, with two jobs: `test` runs
`make test-ci` (= `test-unit`); `smoke` installs the required tools, runs `install.sh`, `:Lazy! restore` from
`lazy-lock.json` and then `make test-smoke`. In CI the Omarchy `theme.lua` symlink is broken, so the job removes it
and `~/.config/nvim` is symlinked to the checkout.

Formatting/linting of the Lua config itself uses StyLua (`.stylua.toml`: 120 col, 2-space indent, double quotes).
`check-ruff.sh` checks the Ruff install used *inside* Neovim for Python projects, not this repo's own code.
Markdown docs are linted with `npx --yes markdownlint-cli2` (config in `.markdownlint-cli2.jsonc`: MD013 at 120
columns) — keep it at 0 issues when editing any `.md`.

## Architecture

- `init.lua` — one-line entry point, delegates to `lua/config/lazy.lua`.
- `lua/config/lazy.lua` — bootstraps `lazy.nvim`, then loads `{ import = "lazyvim.plugins" }` (LazyVim core) followed
  by `{ import = "plugins" }` (everything in `lua/plugins/*.lua`). Later specs in `lua/plugins/` override/extend
  LazyVim defaults — this is the main mechanism for customization, not editing LazyVim's own files.
- `lazyvim.json` — declares which upstream LazyVim "extras" are enabled (`lang.python`, `lang.docker`, `lang.sql`,
  `lang.markdown`, `lang.json`, `lang.toml`, `lang.typescript` (vtsls by default), `coding.yanky`, `dap.core`).
  Check this before adding a plugin that an extra might already provide.
- `lua/config/` — `options.lua` (vim options, Python/Jupyter provider path), `keymaps.lua` (global custom
  keybindings; plugin-specific ones live in each spec's `keys` table — see KEYBINDINGS.md for the human-readable
  map), `python.lua` (per-buffer project root and venv executables — used by keymaps, conform, Neotest, Overseer
  and terminals), `docker.lua` (Compose command, v2 first, and the compose file's cwd), `autocmds.lua` (also
  loads `lsp_autoinstall.lua`, which auto-installs an LSP server via Mason when a filetype has exactly one
  candidate and none installed), `lazy.lua` (bootstrap, above).
- `lua/nvim_config/health.lua` — backs `:checkhealth nvim_config` (external dependency checks).
- `lua/plugins/*.lua` — one file per concern (not per plugin necessarily): `python-tools.lua` (Ruff/Pyright/Mypy/DAP),
  `jupyter-tools.lua` (jupytext + molten for `.ipynb`), `uv-tools.lua`, `formatting.lua` (conform.nvim,
  line-length 120), `sql-tools.lua`, `git-modern.lua` (Neogit/Diffview/GitSigns),
  `test-runner.lua` (Neotest/Overseer/Snacks.terminal/Trouble), `modern-ui.lua` (Noice/Telescope/Treesitter Context),
  `legendary.lua` (command/keymap palette at `<leader>sL` — complements which-key, does not replace it),
  `claude-code.lua` (claudecode.nvim bridge to the `claude` CLI), `mason-tools.lua` (only tools the extras don't bring;
  Python ones live in `python-tools.lua`), `editor-extras.lua` (Harpoon/Oil; search & replace is LazyVim's grug-far), `quicknote.lua`
  (notes under `<leader>N`), `completion.lua` (blink.cmp), `surround.lua` (mini.surround),
  `lua-tools.lua` (lua_ls for editing this config), `markdown-tools.lua`.
- Theming: `theme.lua` is a **symlink** to `~/.local/state/omarchy/current/theme/neovim.lua` managed by Omarchy —
  do not edit or replace it in the repo. `omarchy-theme-hotreload.lua` reloads it on `LazyReload`,
  `omarchy-themes.lua` declares the theme plugins (lazy) and
  `themery.lua` provides manual switching (`<leader>uC`) and a light/dark toggle (`<leader>uB`).
- `tests/` — `config_spec.lua` is a plenary/busted spec asserting invariants (Ruff wired into conform, Telescope as
  picker, no terminal × test keymap collision, expected plugins present, no deprecated Neovim 0.12 APIs, no shell
  interpolation of user input); `smoke.lua` boots the real config headless and checks runtime state, and runs
  `tests/smoke/terminals.lua` (presses the `<leader>T*` keys in a temp venv/compose project) and
  `tests/smoke/theme.lua` (fires `User LazyReload` with a stubbed `plugins.theme`) — checks needing a missing tool
  print `[SKIP]`; `check_syntax.lua` just parses every Lua file.

## Key conventions

- Python/Django is the primary target: Ruff is the single source of truth for lint + format + import
  organization (format-on-save via conform), Pyright for types/completion, Mypy via nvim-lint for deeper checks.
- Terminal keymaps use a dedicated `<Space>T` (uppercase) prefix specifically to avoid colliding with the test
  prefix `<Space>t` (lowercase) — preserve this split when adding new terminal or test keymaps.
- Jupyter `.ipynb` support (`jupytext.nvim` + `molten-nvim`) round-trips notebooks through markdown; image/plot
  rendering (`image.nvim`) only works inside the Kitty terminal — cell execution itself works everywhere.
- which-key is LazyVim's default (no local override — a spec asserts this). Before adding a `<leader>` keymap, check
  LazyVim core bindings to avoid shadowing them (e.g. `<leader>uc` conceal → Themery uses `<leader>uC`; `<leader>n`
  notification history → quicknote uses `<leader>N`; uv.nvim moved from `<leader>x` to `<leader>U` because of
  Trouble).
- Prefer what LazyVim/Snacks already ship (notifier, words, terminal, rename, grug-far, native `gc`) over adding a
  plugin for the same job; specs assert that notify/illuminate/dressing/toggleterm/spectre/mini.comment stay out.
- `lazy-lock.json` is versioned (no longer in `.gitignore`): commit it after `:Lazy sync`/`:Lazy update`.
- Docs are in pt-BR (with correct accents). KEYBINDINGS.md is the canonical human-facing keymap reference; keep it in
  sync with `lua/config/keymaps.lua` **and** plugin `keys` specs when adding/changing keymaps. README.md,
  INSTALL.md (dependencies and `install.sh` steps) and BACKUP-GUIDE.md (backup/restore scripts) must follow changes
  to the corresponding scripts. CHANGELOG.md tracks version history and should be updated for user-facing
  changes.
