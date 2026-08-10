# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository

This is a personal LazyVim-based Neovim configuration (Lua), tuned for Python/Django development, plus Docker,
SQL, Git and Jupyter tooling. It is a config repo, not an application — "the build" is booting Neovim itself,
and "the tests" verify the config's invariants and boot health rather than business logic.

## Commands

```bash
make test         # full suite: syntax + specs + smoke (boots the real config)
make test-unit    # syntax + specs only (does not install all plugins) — same as CI
make test-smoke   # boot smoke test only
make syntax       # Lua syntax validation only (tests/check_syntax.lua)

# Run a single spec file directly:
nvim --headless -u tests/minimal_init.lua \
  -c "PlenaryBustedFile tests/config_spec.lua {minimal_init='tests/minimal_init.lua'}" +qa
```

`tests/run.sh` is the actual orchestrator behind the Makefile targets (`unit`/`smoke`/`all`). CI
(`.github/workflows/test.yml`) runs `make test-ci` (= `test-unit`) on every push/PR to `main`.

Formatting/linting of the Lua config itself uses StyLua (`.stylua.toml`: 120 col, 2-space indent, double quotes).
`check-ruff.sh` checks the Ruff install used *inside* Neovim for Python projects, not this repo's own code.

## Architecture

- `init.lua` — one-line entry point, delegates to `lua/config/lazy.lua`.
- `lua/config/lazy.lua` — bootstraps `lazy.nvim`, then loads `{ import = "lazyvim.plugins" }` (LazyVim core) followed
  by `{ import = "plugins" }` (everything in `lua/plugins/*.lua`). Later specs in `lua/plugins/` override/extend
  LazyVim defaults — this is the main mechanism for customization, not editing LazyVim's own files.
- `lazyvim.json` — declares which upstream LazyVim "extras" are enabled (`lang.python`, `lang.docker`, `lang.sql`,
  `lang.markdown`, `lang.json`, `lang.toml`, `lang.typescript`+`vtsls`, `coding.yanky`). Check this before adding a
  plugin that an extra might already provide.
- `lua/config/` — `options.lua` (vim options), `keymaps.lua` (all custom keybindings — see KEYBINDINGS.md for the
  human-readable map), `autocmds.lua`, `lazy.lua` (bootstrap, above).
- `lua/plugins/*.lua` — one file per concern (not per plugin necessarily): `python-tools.lua` (Ruff/Pyright/Mypy/DAP),
  `jupyter-tools.lua` (jupytext + molten for `.ipynb`), `uv-tools.lua`, `formatting.lua` (conform.nvim,
  line-length 120), `docker-tools.lua`, `sql-tools.lua`, `git-modern.lua` (Neogit/Diffview/GitSigns),
  `test-runner.lua` (Neotest/Overseer/ToggleTerm/Trouble), `modern-ui.lua` (Noice/Telescope/Treesitter Context),
  `legendary.lua` (command/keymap palette — replaces which-key), `claude-code.lua` (claudecode.nvim bridge to the
  `claude` CLI), `themery.lua` (colorscheme switching), `mason-tools.lua` (LSP/tool installation list).
- `tests/` — `config_spec.lua` is a plenary/busted spec asserting invariants (Ruff wired into conform, Telescope as
  picker, no keymap collisions, expected plugins present, no deprecated APIs used); `smoke.lua` boots the real
  config headless and checks runtime state; `check_syntax.lua` just parses every Lua file.

## Key conventions

- Python/Django is the primary target: Ruff is the single source of truth for lint + format + import
  organization (format-on-save via conform), Pyright for types/completion, Mypy via nvim-lint for deeper checks.
- Terminal keymaps use a dedicated `<Space>T` (uppercase) prefix specifically to avoid colliding with the test
  prefix `<Space>t` (lowercase) — preserve this split when adding new terminal or test keymaps.
- Jupyter `.ipynb` support (`jupytext.nvim` + `molten-nvim`) round-trips notebooks through markdown; image/plot
  rendering (`image.nvim`) only works inside the Kitty terminal — cell execution itself works everywhere.
- KEYBINDINGS.md is the canonical human-facing keymap reference; keep it in sync with `lua/config/keymaps.lua`
  when adding/changing keymaps. CHANGELOG.md tracks version history and should be updated for user-facing changes.
