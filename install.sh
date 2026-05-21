#!/bin/bash
# Instalação automática - Execute após clonar o repositório

set -e

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║   🚀 Instalação Automática - LazyVim Config Completo             ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

NVIM_DIR="$HOME/.config/nvim"
RUFF_DIR="$HOME/.config/ruff"

# Verificar se está no diretório correto
if [ ! -f "$NVIM_DIR/install.sh" ]; then
    echo "❌ Execute este script de dentro do diretório ~/.config/nvim"
    echo "   cd ~/.config/nvim && ./install.sh"
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

# Neovim
if command -v nvim &> /dev/null; then
    nvim_version=$(nvim --version | head -1)
    echo "   ✅ Neovim: $nvim_version"
else
    echo "   ❌ Neovim não instalado!"
    echo "      Instale: https://neovim.io"
    exit 1
fi

# Git
if command -v git &> /dev/null; then
    echo "   ✅ Git instalado"
else
    echo "   ❌ Git não instalado!"
    exit 1
fi

# Ruff (opcional)
if command -v ruff &> /dev/null; then
    echo "   ✅ Ruff: $(ruff --version)"
else
    echo "   ⚠️  Ruff não instalado (será instalado via Mason)"
fi

# Python e pip
if command -v python3 &> /dev/null; then
    echo "   ✅ Python: $(python3 --version)"
else
    echo "   ❌ Python3 não instalado!"
    exit 1
fi

if command -v pip3 &> /dev/null; then
    echo "   ✅ pip instalado"
else
    echo "   ❌ pip3 não instalado!"
    exit 1
fi

echo ""

# 3. Instalar Django type stubs (para LSP)
echo "3️⃣  Instalando Django type stubs para pyright/pylance..."

# Verificar se já estão instalados
if python3 -c "import django_stubs" 2>/dev/null; then
    echo "   ✅ django-stubs já instalado"
else
    echo "   📦 Instalando stubs..."
    pip3 install --user django-stubs djangorestframework-stubs django-types django-stubs-ext
    echo "   ✅ Type stubs instalados"
fi

echo ""

# 4. Tornar scripts executáveis
echo "4️⃣  Tornando scripts executáveis..."
chmod +x "$NVIM_DIR"/*.sh 2>/dev/null || true
echo "   ✅ Scripts prontos"

echo ""

# 4. Instruções finais
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
echo "   💡 Django type stubs já instalados para melhor LSP!"
echo ""
echo "4. Reinicie o Neovim:"
echo "   :qa"
echo "   nvim"
echo ""
echo "5. Verifique line-length:"
echo "   cd ~/.config/nvim && ./check-ruff.sh"
echo ""
echo "6. Leia a documentação:"
echo "   :e ~/.config/nvim/README.md"
echo "   :e ~/.config/nvim/KEYBINDINGS.md"
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "💡 Dica: Use <Space> + aguarde para ver todos os atalhos (Which-key)"
echo "════════════════════════════════════════════════════════════════════"
echo ""
