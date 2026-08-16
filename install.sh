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

# 1. Verificar dependências antes de modificar o ambiente do usuário
echo "1️⃣  Verificando dependências..."

# Neovim 0.12+ com LuaJIT
if command -v nvim &>/dev/null; then
  nvim_version=$(nvim --version | head -1)
  if nvim --clean --headless -u NONE \
    '+lua if vim.fn.has("nvim-0.12") == 0 or not jit then vim.cmd("cquit") end' +qa &>/dev/null; then
    echo "   ✅ Neovim: $nvim_version"
  else
    echo "   ❌ Neovim 0.12+ com LuaJIT é obrigatório; encontrado: $nvim_version"
    exit 1
  fi
else
  echo "   ❌ Neovim não instalado!"
  echo "      Instale: https://neovim.io"
  exit 1
fi

required_tools=(git curl rg fd make cc tree-sitter node npm python3 uv unzip tar gzip)
missing_required=()
for tool in "${required_tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    echo "   ✅ $tool instalado"
  else
    echo "   ❌ $tool não encontrado"
    missing_required+=("$tool")
  fi
done

if [ "${#missing_required[@]}" -gt 0 ]; then
  echo ""
  echo "   Dependências obrigatórias ausentes: ${missing_required[*]}"
  echo "   Consulte INSTALL.md para os pacotes de cada sistema."
  echo "   openSUSE Tumbleweed:"
  echo "   sudo zypper install neovim git curl ripgrep fd make gcc tree-sitter"
  echo "     nodejs24 npm24 python313 python313-uv unzip tar gzip"
  echo "   Arch Linux / Garuda Linux:"
  echo "   sudo pacman -S --needed neovim git curl ripgrep fd make gcc tree-sitter tree-sitter-cli"
  echo "     nodejs npm python python-pip uv unzip tar gzip"
  exit 1
fi

echo ""
echo "   Integrações opcionais:"
optional_tools=(fzf lazygit docker magick kitty claude sqlite3 psql mysql)
for tool in "${optional_tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    echo "   ✅ $tool instalado"
  else
    echo "   ⚠️  $tool não encontrado (funcionalidade opcional; veja INSTALL.md)"
  fi
done

if command -v wl-copy &>/dev/null; then
  echo "   ✅ clipboard Wayland disponível (wl-copy)"
elif command -v xclip &>/dev/null; then
  echo "   ✅ clipboard X11 disponível (xclip)"
else
  echo "   ⚠️  Clipboard externo indisponível (instale wl-clipboard ou xclip)"
fi

if command -v docker &>/dev/null && docker compose version &>/dev/null; then
  echo "   ✅ Docker Compose disponível (docker compose)"
elif command -v docker-compose &>/dev/null; then
  echo "   ✅ Docker Compose legado disponível (docker-compose)"
else
  echo "   ⚠️  Docker Compose não encontrado (atalhos Docker Compose ficarão indisponíveis)"
fi

echo ""

# 2. Criar configuração global do Ruff
echo "2️⃣  Configurando Ruff global (line-length 120)..."

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

# 3. Provider Python isolado para Neovim/Jupyter
echo "3️⃣  Configurando provider Python e Jupyter..."
uv venv --allow-existing "$JUPYTER_VENV"
uv pip install --python "$JUPYTER_VENV/bin/python" --upgrade pynvim jupyter-client jupytext ipykernel \
  django-stubs djangorestframework-stubs
echo "   ✅ Provider criado em $JUPYTER_VENV"
echo "   ✅ Type stubs Django/DRF instalados globalmente (django-stubs, djangorestframework-stubs)"

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
echo "3. Verifique as ferramentas LSP instaladas automaticamente:"
echo "   :Mason"
echo "   (A configuração declara Pyright, Ruff, Mypy, debugpy, sqlfluff e as demais.)"
echo ""
echo "4. Reinicie o Neovim:"
echo "   :qa"
echo "   nvim"
echo ""
echo "5. Verifique line-length:"
echo "   cd ~/.config/nvim && ./check-ruff.sh"
echo ""
echo "6. Verifique a saúde da configuração e do gerenciador de ferramentas:"
echo "   :checkhealth nvim_config vim.provider mason"
echo ""
echo "7. Leia a documentação:"
echo "   :e ~/.config/nvim/README.md"
echo "   :e ~/.config/nvim/KEYBINDINGS.md"
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "💡 Dica: Use <Space> + aguarde para ver todos os atalhos (Which-key)"
echo "════════════════════════════════════════════════════════════════════"
echo ""
