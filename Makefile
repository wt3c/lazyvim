.PHONY: test test-unit test-smoke test-ci syntax

# Suíte completa: sintaxe + specs + smoke de boot.
test:
	@bash tests/run.sh all

# Apenas specs unitárias (não instala todos os plugins) -- usado no CI.
test-ci: test-unit

test-unit:
	@bash tests/run.sh unit

# Apenas o smoke de boot da config completa.
test-smoke:
	@bash tests/run.sh smoke

# Validação de sintaxe Lua isolada.
syntax:
	@nvim -l tests/check_syntax.lua
