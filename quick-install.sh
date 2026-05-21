#!/bin/bash
# Script de instalação rápida da configuração completa
# Use este script APÓS reinstalar o LazyVim do zero

set -e

echo "════════════════════════════════════════════════════════"
echo "🚀 Instalação Rápida - Configuração Completa"
echo "════════════════════════════════════════════════════════"
echo ""
echo "⚠️  Este script deve ser executado APÓS instalar o LazyVim!"
echo ""
read -p "✅ LazyVim já está instalado? (s/N): " ready

if ! [[ "$ready" =~ ^[Ss]$ ]]; then
    echo ""
    echo "📝 Instale o LazyVim primeiro:"
    echo ""
    echo "   # Backup (se necessário)"
    echo "   mv ~/.config/nvim ~/.config/nvim.bak"
    echo ""
    echo "   # Clone LazyVim"
    echo "   git clone https://github.com/LazyVim/starter ~/.config/nvim"
    echo "   rm -rf ~/.config/nvim/.git"
    echo ""
    echo "   # Execute este script novamente"
    echo "   ./quick-install.sh"
    echo ""
    exit 0
fi

echo ""
echo "🔄 Configurando..."
echo "────────────────────────────────────────────────────────"

NVIM_DIR="$HOME/.config/nvim"
RUFF_DIR="$HOME/.config/ruff"

# 1. Criar configuração global do Ruff
echo "1️⃣  Criando configuração global do Ruff..."
mkdir -p "$RUFF_DIR"

cat > "$RUFF_DIR/pyproject.toml" << 'RUFF_EOF'
# Ruff global configuration
[tool.ruff]
line-length = 120
target-version = "py310"

exclude = [
    ".git", ".venv", "venv", "__pycache__",
    ".pytest_cache", ".mypy_cache", ".ruff_cache",
    "build", "dist", "migrations", "*.egg-info",
]

[tool.ruff.lint]
select = ["E", "W", "F", "I", "N", "UP", "B", "C4", "DJ", "PTH", "SIM", "TID", "Q"]
ignore = ["E501", "B008", "B904"]

[tool.ruff.lint.isort]
known-first-party = []
section-order = ["future", "standard-library", "third-party", "first-party", "local-folder"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"

[tool.ruff.lint.pydocstyle]
convention = "google"
RUFF_EOF

echo "   ✅ ~/.config/ruff/pyproject.toml criado"

# 2. Adicionar SQL extra ao lazyvim.json
echo "2️⃣  Atualizando lazyvim.json..."

if [ -f "$NVIM_DIR/lazyvim.json" ]; then
    # Verificar se SQL já está adicionado
    if ! grep -q '"lazyvim.plugins.extras.lang.sql"' "$NVIM_DIR/lazyvim.json"; then
        # Adicionar SQL após python
        sed -i 's/"lazyvim.plugins.extras.lang.python",/"lazyvim.plugins.extras.lang.python",\n    "lazyvim.plugins.extras.lang.sql",/' "$NVIM_DIR/lazyvim.json"
        echo "   ✅ SQL extra adicionado"
    else
        echo "   ℹ️  SQL extra já estava presente"
    fi
fi

# 3. Informar sobre plugins que precisam ser criados
echo "3️⃣  Plugins que precisam ser criados:"
echo ""
echo "   ⚠️  Os arquivos lua/plugins/*.lua precisam ser restaurados!"
echo ""
echo "   Opções:"
echo "   a) Restaurar de backup: ./restore-config.sh"
echo "   b) Clonar do repositório Git"
echo "   c) Recriar manualmente"
echo ""
read -p "   Você tem um backup? (s/N): " has_backup

if [[ "$has_backup" =~ ^[Ss]$ ]]; then
    echo ""
    read -p "   📁 Caminho do backup .tar.gz: " backup_path

    if [ -f "$backup_path" ]; then
        echo "   🔄 Restaurando..."
        tar -xzf "$backup_path" -C "$HOME/.config" --strip-components=1 nvim/lua/plugins/
        echo "   ✅ Plugins restaurados!"
    else
        echo "   ❌ Arquivo não encontrado: $backup_path"
    fi
else
    echo ""
    echo "   📋 Você precisará criar manualmente os seguintes arquivos:"
    echo "      • lua/plugins/python-tools.lua"
    echo "      • lua/plugins/docker-tools.lua"
    echo "      • lua/plugins/git-modern.lua"
    echo "      • lua/plugins/test-runner.lua"
    echo "      • lua/plugins/modern-ui.lua"
    echo "      • lua/plugins/sql-tools.lua"
    echo "      • lua/plugins/mason-tools.lua"
    echo ""
    echo "   💡 Consulte a documentação em:"
    echo "      https://github.com/seu-usuario/seu-repo (se versionou no Git)"
    echo ""
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Configuração Básica Completa!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "🚀 Próximos passos:"
echo ""
echo "1. Restaure os plugins (se não fez ainda):"
echo "   ./restore-config.sh"
echo ""
echo "2. Abra o Neovim:"
echo "   nvim"
echo ""
echo "3. Sincronize plugins:"
echo "   :Lazy sync"
echo ""
echo "4. Instale ferramentas:"
echo "   :Mason"
echo ""
echo "5. Verifique line-length:"
echo "   ./check-ruff.sh"
echo ""
