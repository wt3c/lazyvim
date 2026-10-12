#!/usr/bin/env bash
# Diagnóstico do Ruff do projeto ou do Mason, sem instalar pacotes globais.
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
RUFF=""
if [[ -n "${VIRTUAL_ENV:-}" && -x "$VIRTUAL_ENV/bin/ruff" ]]; then
  RUFF="$VIRTUAL_ENV/bin/ruff"
else
  for venv in .venv venv env; do
    if [[ -x "$PWD/$venv/bin/ruff" ]]; then
      RUFF="$PWD/$venv/bin/ruff"
      break
    fi
  done
fi
if [[ -z "$RUFF" ]]; then
  RUFF="$(command -v ruff || true)"
fi
if [[ -z "$RUFF" && -x "$DATA_DIR/nvim/mason/bin/ruff" ]]; then
  RUFF="$DATA_DIR/nvim/mason/bin/ruff"
fi
if [[ -z "$RUFF" ]]; then
  echo "❌ Ruff não encontrado no venv, PATH ou Mason. Abra :Mason e instale ruff."
  exit 1
fi

echo "🔍 Ruff: $RUFF"
"$RUFF" --version
echo "📁 Configurações globais disponíveis:"
for name in .ruff.toml ruff.toml pyproject.toml; do
  if [[ -f "$CONFIG_DIR/ruff/$name" ]]; then
    echo "   $CONFIG_DIR/ruff/$name"
  fi
done

runtime_dir="$(mktemp -d "${TMPDIR:-/tmp}/nvim-ruff-check.XXXXXX")"
filename=""
trap 'rm -rf -- "$runtime_dir"; if [[ -n "$filename" ]]; then rm -f -- "$filename"; fi' EXIT
# Um arquivo real no cwd permite ao Ruff descobrir a configuração do projeto.
# mktemp evita colidir com arquivos existentes, e o trap remove a amostra.
filename="$(mktemp "$PWD/.nvim-ruff-check.XXXXXX.py")"
cat > "$filename" <<'PYTHON'
def very_long_function_name_that_exceeds_eighty_characters_but_should_be_ok_with_one_hundred_twenty(param1, param2, param3):
    pass
PYTHON
echo "📋 Configuração efetiva para o diretório atual:"
"$RUFF" check --show-settings "$filename" > "$runtime_dir/settings"
awk '/^Settings path:|^linter.line_length =|^formatter.line_width =/' "$runtime_dir/settings"

echo "🧪 Formatação com a configuração efetiva (sem forçar line-length):"
# --stdin-filename só informa a descoberta da configuração; não grava no arquivo.
# shellcheck disable=SC2094
"$RUFF" format --stdin-filename "$filename" - < "$filename"
echo "✅ Ruff respondeu ao diagnóstico e à formatação."
