#!/usr/bin/env bash
# Testes reais de arquivos/archives; subprocessos falsos apenas para falhas do runner.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime_dir="$(mktemp -d "${TMPDIR:-/tmp}/nvim-scripts.XXXXXX")"
trap 'rm -rf -- "$runtime_dir"' EXIT
mkdir -p "$runtime_dir/bin"

cat > "$runtime_dir/bin/nvim" <<'NVIM'
#!/usr/bin/env bash
if [[ " $* " == *" -l "* ]]; then exit 0; fi
case "${SCRIPT_TEST_CASE:-multi}" in
  multi)
    printf 'Success: \t1\nFailed : \t1\nErrors : \t0\n'
    printf 'Success: \t2\nFailed : \t0\nErrors : \t0\n' ;;
  exit)
    printf 'Success: \t2\nFailed : \t0\nErrors : \t0\n'
    exit 7 ;;
  empty)
    printf 'Success: \t0\nFailed : \t0\nErrors : \t0\n' ;;
esac
NVIM
chmod +x "$runtime_dir/bin/nvim"
for scenario in multi exit empty; do
  if PATH="$runtime_dir/bin:$PATH" SCRIPT_TEST_CASE="$scenario" \
    bash "$ROOT/tests/run.sh" unit > "$runtime_dir/runner.log" 2>&1; then
    echo "FAIL: runner aceitou o cenário $scenario"
    cat "$runtime_dir/runner.log"
    exit 1
  fi
done
echo "PASS: runner rejeita falha anterior, saída não zero e zero testes"

# Impede que uma versão antiga sem suporte XDG toque a configuração real.
for script in backup-config.sh restore-config.sh; do
  if ! grep -q XDG_CONFIG_HOME "$ROOT/$script"; then
    echo "FAIL: $script não permite isolar a configuração com XDG_CONFIG_HOME"
    exit 1
  fi
done
config_dir="$runtime_dir/config com espaços"
mkdir -p "$config_dir/nvim/tests/.deps"
printf 'dependência temporária\n' > "$config_dir/nvim/tests/.deps/fixture"
printf 'original\n' > "$config_dir/nvim/init.lua"
printf '{"plugin":"commit-fixo"}\n' > "$config_dir/nvim/lazy-lock.json"
XDG_CONFIG_HOME="$config_dir" bash "$ROOT/backup-config.sh" > "$runtime_dir/backup.log"
backups=("$config_dir"/nvim-backup/nvim-backup-*.tar.gz)
[[ -f "${backups[0]}" ]]
tar -tzf "${backups[0]}" | grep -q '^nvim/lazy-lock.json$'
if tar -tzf "${backups[0]}" | grep -q '/tests/.deps/'; then
  echo "FAIL: backup incluiu dependências temporárias de testes"
  exit 1
fi
echo "PASS: backup sem Ruff preserva o lockfile"

printf 'alterado\n' > "$config_dir/nvim/init.lua"
printf 's\n' | XDG_CONFIG_HOME="$config_dir" bash "$ROOT/restore-config.sh" "${backups[0]}" \
  > "$runtime_dir/restore.log"
[[ "$(cat "$config_dir/nvim/init.lua")" == original ]]
previous=("$config_dir"/nvim-backup/nvim-before-restore-*.tar.gz)
[[ "$(tar -xOzf "${previous[0]}" nvim/init.lua)" == alterado ]]
echo "PASS: restauração com espaços salva a configuração anterior"

printf 'alterado novamente\n' > "$config_dir/nvim/init.lua"
printf '1\ns\n' | XDG_CONFIG_HOME="$config_dir" bash "$ROOT/restore-config.sh" > "$runtime_dir/menu.log"
[[ "$(cat "$config_dir/nvim/init.lua")" == original ]]
echo "PASS: seleção de backup pelo menu com espaços"

mkdir -p "$runtime_dir/source/ruff" "$config_dir/ruff"
printf 'line-length = 120\n' > "$runtime_dir/source/ruff/ruff.toml"
printf 'line-length = 80\n' > "$config_dir/ruff/ruff.toml"
tar -czf "$runtime_dir/somente-ruff.tar.gz" -C "$runtime_dir/source" ruff
printf 's\n' | XDG_CONFIG_HOME="$config_dir" bash "$ROOT/restore-config.sh" "$runtime_dir/somente-ruff.tar.gz" \
  > "$runtime_dir/ruff-restore.log"
mapfile -d '' previous < <(find "$config_dir/nvim-backup" -name 'nvim-before-restore-*.tar.gz' \
  -printf '%T@ %p\0' | sort -znr | cut -z -d ' ' -f 2-)
last="${previous[0]}"
[[ "$(tar -xOzf "$last" ruff/ruff.toml)" == 'line-length = 80' ]]
echo "PASS: restauração também salva o Ruff anterior"

# Falha no snapshot de segurança deve impedir a extração do backup solicitado.
real_tar="$(command -v tar)"
cat > "$runtime_dir/bin/tar" <<'TAR'
#!/usr/bin/env bash
if [[ "$1" == -czf ]]; then exit 7; fi
exec "$SCRIPT_TEST_TAR" "$@"
TAR
chmod +x "$runtime_dir/bin/tar"
printf 'preservado\n' > "$config_dir/nvim/init.lua"
if printf 's\n' | PATH="$runtime_dir/bin:$PATH" XDG_CONFIG_HOME="$config_dir" SCRIPT_TEST_TAR="$real_tar" \
  bash "$ROOT/restore-config.sh" "${backups[0]}" > "$runtime_dir/failed-restore.log"; then
  echo "FAIL: restauração ignorou falha do snapshot"
  exit 1
fi
[[ "$(cat "$config_dir/nvim/init.lua")" == preservado ]]
echo "PASS: falha no snapshot aborta a restauração"

git -C "$config_dir/nvim" init -q
printf '\n' | XDG_CONFIG_HOME="$config_dir" bash "$ROOT/backup-config.sh" > "$runtime_dir/no-commit.log"
git -C "$config_dir/nvim" diff --cached --quiet
if git -C "$config_dir/nvim" rev-parse --verify HEAD > /dev/null 2>&1; then
  echo "FAIL: backup criou um commit sem confirmação"
  exit 1
fi
echo "PASS: recusar commit não altera o index nem impede o snapshot"
for _ in 1 2 3 4 5 6; do
  printf '\n' | XDG_CONFIG_HOME="$config_dir" bash "$ROOT/backup-config.sh" > "$runtime_dir/retention.log"
done
backups=("$config_dir"/nvim-backup/nvim-backup-*.tar.gz)
[[ "${#backups[@]}" -eq 5 ]]
[[ -f "$last" ]]
echo "PASS: retenção mantém cinco backups e preserva snapshots de segurança"

# O diagnóstico deve propagar uma falha do Ruff, sem anunciar sucesso.
cat > "$runtime_dir/bin/ruff" <<'RUFF'
#!/usr/bin/env bash
if [[ "$1" == --version ]]; then echo 'ruff (teste de falha)'; exit 0; fi
exit 7
RUFF
chmod +x "$runtime_dir/bin/ruff"
if PATH="$runtime_dir/bin:$PATH" XDG_CONFIG_HOME="$config_dir" \
  bash "$ROOT/check-ruff.sh" > "$runtime_dir/failed-ruff.log" 2>&1; then
  echo "FAIL: diagnóstico anunciou sucesso após falha do Ruff"
  exit 1
fi
echo "PASS: diagnóstico propaga falha do Ruff"

real_ruff="$(command -v ruff || true)"
if [[ -n "$real_ruff" ]]; then
  mkdir -p "$runtime_dir/project/.venv/bin"
  ln -s "$real_ruff" "$runtime_dir/project/.venv/bin/ruff"
  printf '[tool.ruff]\nline-length = 99\n' > "$runtime_dir/project/pyproject.toml"
  (
    cd "$runtime_dir/project"
    VIRTUAL_ENV="" XDG_CONFIG_HOME="$config_dir" bash "$ROOT/check-ruff.sh" > "$runtime_dir/real-ruff.log"
  )
  grep -q 'formatter.line_width = 99' "$runtime_dir/real-ruff.log"
  [[ -z "$(find "$runtime_dir/project" -maxdepth 1 -name '.nvim-ruff-check.*.py' -print)" ]]
  echo "PASS: Ruff real usa o venv e a configuração do projeto, sem deixar amostras"
else
  echo "SKIP: Ruff real ausente (o smoke usa o Ruff instalado pelo Mason)"
fi
