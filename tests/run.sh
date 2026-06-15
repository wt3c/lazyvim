#!/usr/bin/env bash
# Orquestrador de testes da config.
#   tests/run.sh            -> sintaxe + specs + smoke (tudo)
#   tests/run.sh unit       -> sintaxe + specs (não precisa instalar todos os plugins)
#   tests/run.sh smoke      -> apenas o smoke de boot da config completa
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MODE="${1:-all}"
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
fail=0

step() { echo -e "\n${BLUE}==> $1${NC}"; }
pass() { echo -e "${GREEN}✓ $1${NC}"; }
err() {
  echo -e "${RED}✗ $1${NC}"
  fail=1
}

run_syntax() {
  step "Sintaxe Lua"
  if nvim -l tests/check_syntax.lua; then pass "sintaxe"; else err "sintaxe"; fi
}

ensure_plenary() {
  if [ ! -d "$HOME/.local/share/nvim/lazy/plenary.nvim" ] && [ ! -d "$ROOT/tests/.deps/plenary.nvim" ]; then
    step "Clonando plenary.nvim (tests/.deps)"
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim "$ROOT/tests/.deps/plenary.nvim"
  fi
}

run_unit() {
  ensure_plenary
  step "Specs (plenary/busted)"
  local out
  out="$(nvim --headless -u tests/minimal_init.lua \
    -c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua', sequential=true}" \
    +qa 2>&1)"
  echo "$out"
  # A saída do plenary separa rótulo e número por TAB e usa cores ANSI;
  # normaliza antes de extrair os contadores.
  local clean failed errors success
  clean="$(echo "$out" | sed -E 's/\x1b\[[0-9;]*m//g' | tr '\t' ' ' | tr -s ' ')"
  failed="$(echo "$clean" | grep -oE 'Failed : [0-9]+' | grep -oE '[0-9]+$' | tail -1)"
  errors="$(echo "$clean" | grep -oE 'Errors : [0-9]+' | grep -oE '[0-9]+$' | tail -1)"
  success="$(echo "$clean" | grep -oE 'Success: [0-9]+' | grep -oE '[0-9]+$' | tail -1)"

  if [ -z "${success:-}" ]; then
    err "specs (nenhum teste executado)"
  elif [ "${failed:-0}" -ne 0 ] || [ "${errors:-0}" -ne 0 ]; then
    err "specs (${failed:-0} falhas, ${errors:-0} erros)"
  else
    pass "specs ($success ok)"
  fi
}

run_smoke() {
  step "Smoke (boot da config completa)"
  if nvim --headless +"luafile tests/smoke.lua"; then pass "smoke"; else err "smoke"; fi
}

case "$MODE" in
  unit)
    run_syntax
    run_unit
    ;;
  smoke)
    run_smoke
    ;;
  all)
    run_syntax
    run_unit
    run_smoke
    ;;
  *)
    echo "uso: tests/run.sh [unit|smoke|all]" >&2
    exit 2
    ;;
esac

echo ""
if [ "$fail" -eq 0 ]; then
  echo -e "${GREEN}━━━ TODOS OS TESTES PASSARAM ━━━${NC}"
else
  echo -e "${RED}━━━ HOUVE FALHAS ━━━${NC}"
fi
exit "$fail"
