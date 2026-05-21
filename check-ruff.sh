#!/bin/bash
# Script para verificar configuração do Ruff

echo "════════════════════════════════════════════════════════"
echo "🔍 Verificando Configuração do Ruff"
echo "════════════════════════════════════════════════════════"
echo ""

# Verificar se Ruff está instalado
if command -v ruff &> /dev/null; then
    echo "✅ Ruff instalado: $(ruff --version)"
else
    echo "❌ Ruff não encontrado"
    echo "   Instale com: pip install ruff"
    exit 1
fi

echo ""
echo "📁 Arquivos de configuração encontrados:"
echo "────────────────────────────────────────────────────────"

# Verificar configuração global
if [ -f ~/.config/ruff/pyproject.toml ]; then
    echo "✅ ~/.config/ruff/pyproject.toml"
    echo "   line-length: $(grep -A1 '\[tool.ruff\]' ~/.config/ruff/pyproject.toml | grep line-length | cut -d'=' -f2 | tr -d ' ')"
else
    echo "❌ ~/.config/ruff/pyproject.toml não encontrado"
fi

# Verificar configuração do projeto atual
if [ -f pyproject.toml ]; then
    echo "✅ ./pyproject.toml (projeto)"
    if grep -q '\[tool.ruff\]' pyproject.toml; then
        line_length=$(grep -A5 '\[tool.ruff\]' pyproject.toml | grep line-length | cut -d'=' -f2 | tr -d ' ')
        if [ -n "$line_length" ]; then
            echo "   line-length: $line_length"
        else
            echo "   ⚠️  line-length não especificado (usando padrão)"
        fi
    else
        echo "   ⚠️  [tool.ruff] não configurado"
    fi
elif [ -f ruff.toml ]; then
    echo "✅ ./ruff.toml (projeto)"
    line_length=$(grep line-length ruff.toml | cut -d'=' -f2 | tr -d ' ')
    echo "   line-length: $line_length"
else
    echo "ℹ️  Nenhuma configuração no projeto atual"
    echo "   (usando configuração global)"
fi

echo ""
echo "🧪 Teste rápido:"
echo "────────────────────────────────────────────────────────"

# Criar arquivo de teste
cat > /tmp/test_ruff.py << 'PYTHON'
def very_long_function_name_that_exceeds_eighty_characters_but_should_be_ok_with_one_hundred_twenty(param1, param2, param3):
    pass
PYTHON

# Testar formatação
echo "Testando linha com ~130 caracteres..."
ruff format /tmp/test_ruff.py --line-length=120 --diff 2>&1 | head -10

rm -f /tmp/test_ruff.py

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Verificação Completa!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "💡 Dica: Se ainda houver problemas:"
echo "   1. Reinicie o Neovim: :qa + nvim"
echo "   2. Restart LSP: :LspRestart"
echo "   3. Verifique LSP: :LspInfo"
echo "   4. Format manual: <leader>fm"
echo ""
