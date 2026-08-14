#!/bin/bash
# Instalação automática - Execute após clonar o repositório

set -euo pipefail

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║   🚀 Instalação Automática - LazyVim Config Completo              ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

NVIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUFF_DIR="$HOME/.config/ruff"
JUPYTER_VENV="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/venvs/jupyter"

# Verificar se está no diretório correto
if [ ! -f "$NVIM_DIR/init.lua" ]; then
  echo "❌ O diretório do script não parece uma configuração do Neovim: $NVIM_DIR"
  exit 1
fi

echo "📋 Checklist de Instalação:"
echo "────────────────────────────────────────────────────────────────────"
echo ""

# 1. Criar configuração global do Ruff
echo "1️⃣  Configurando Ruff global (line-length 120)..."

if [ -f "$NVIM_DIR/ruff-config/pyproject.toml" ]; then
  mkdir -p "$RUFF_DIR"
  cp "$NVIM_DIR/ruff-config/pyproject.toml" "$RUFF_DIR/pyproject.toml"
  echo "   ✅ ~/.config/ruff/pyproject.toml criado"
else
  echo "   ⚠️  Arquivo ruff-config/pyproject.toml não encontrado"
  echo "   Criando configuração padrão..."
  mkdir -p "$RUFF_DIR"
  cat > "$RUFF_DIR/pyproject.toml" << 'RUFF_EOF'
[tool.ruff]
line-length = 120
target-version = "py310"

[tool.ruff.lint]
select = ["E", "W", "F", "I"]
ignore = ["E501"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
RUFF_EOF
  echo "   ✅ Config padrão criada"
fi

echo ""

# 2. Verificar dependências
echo "2️⃣  Verificando dependências..."

# Neovim 0.12+
if command -v nvim &>/dev/null; then
  nvim_version=$(nvim --version | head -1)
  if nvim --clean --headless -u NONE \
    '+lua if vim.fn.has("nvim-0.12") == 0 then vim.cmd("cquit") end' +qa &>/dev/null; then
    echo "   ✅ Neovim: $nvim_version"
  else
    echo "   ❌ Neovim 0.12+ é obrigatório; encontrado: $nvim_version"
    exit 1
  fi
else
  echo "   ❌ Neovim não instalado!"
  echo "      Instale: https://neovim.io"
  exit 1
fi

required_tools=(git curl rg make cc tree-sitter node npm python3 uv)
for tool in "${required_tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    echo "   ✅ $tool instalado"
  else
    echo "   ❌ $tool não encontrado"
    exit 1
  fi
done

# Ruff (opcional)
if command -v ruff &>/dev/null; then
  echo "   ✅ Ruff: $(ruff --version)"
else
  echo "   ⚠️  Ruff não instalado (será instalado via Mason)"
fi

echo ""

# 3. Provider Python isolado para Neovim/Jupyter
echo "3️⃣  Configurando provider Python e Jupyter..."
uv venv --allow-existing "$JUPYTER_VENV"
uv pip install --python "$JUPYTER_VENV/bin/python" --upgrade pynvim jupyter-client jupytext
echo "   ✅ Provider criado em $JUPYTER_VENV"
echo "   ℹ️  Stubs Django devem ser dependências de desenvolvimento de cada projeto"
echo "      Exemplo: uv add --dev django-stubs djangorestframework-stubs"

echo ""

# 4. Tornar scripts executáveis
echo "4️⃣  Tornando scripts executáveis..."
chmod +x "$NVIM_DIR"/*.sh 2> /dev/null || true
echo "   ✅ Scripts prontos"

echo ""

# 5. Instruções finais
echo "════════════════════════════════════════════════════════════════════"
echo "✅ Instalação Completa!"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "🚀 Próximos Passos:"
echo ""
echo "1. Abra o Neovim:"
echo "   nvim"
echo ""
echo "2. Aguarde plugins sincronizarem (Lazy.nvim faz automaticamente)"
echo "   Ou force: :Lazy sync"
echo ""
echo "3. Instale ferramentas LSP:"
echo "   :Mason"
echo "   (Instale: pyright, ruff, mypy, debugpy, sqlfluff, etc)"
echo ""
echo "4. Reinicie o Neovim:"
echo "   :qa"
echo "   nvim"
echo ""
echo "5. Verifique line-length:"
echo "   cd ~/.config/nvim && ./check-ruff.sh"
echo ""
echo "6. Verifique a saúde da configuração:"
echo "   :checkhealth nvim_config vim.provider"
echo ""
echo "7. Leia a documentação:"
echo "   :e ~/.config/nvim/README.md"
echo "   :e ~/.config/nvim/KEYBINDINGS.md"
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "💡 Dica: Use <Space> + aguarde para ver todos os atalhos (Which-key)"
echo "════════════════════════════════════════════════════════════════════"
echo ""
