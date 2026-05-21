#!/bin/bash
# Desinstalação completa do LazyVim
# ATENÇÃO: Este script remove TODOS os dados do Neovim!

set -e

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║   ⚠️  DESINSTALAÇÃO COMPLETA - LazyVim Config                    ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  ATENÇÃO: Este script irá remover:"
echo ""
echo "   1. ~/.config/nvim          (configuração)"
echo "   2. ~/.local/share/nvim     (plugins e dados)"
echo "   3. ~/.local/state/nvim     (estado)"
echo "   4. ~/.cache/nvim           (cache)"
echo "   5. ~/.config/ruff          (configuração global Ruff)"
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo ""

# Confirmação obrigatória
read -p "⚠️  Tem CERTEZA que deseja continuar? (digite 'SIM' para confirmar): " confirm

if [ "$confirm" != "SIM" ]; then
    echo ""
    echo "❌ Desinstalação cancelada."
    echo ""
    exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo ""

# Oferecer backup
read -p "📦 Deseja fazer backup antes de deletar? (s/N): " backup_choice

if [[ "$backup_choice" =~ ^[Ss]$ ]]; then
    BACKUP_DIR="$HOME/nvim-backup-$(date +%Y%m%d-%H%M%S)"
    echo ""
    echo "📦 Criando backup em: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    [ -d "$HOME/.config/nvim" ] && cp -r "$HOME/.config/nvim" "$BACKUP_DIR/config-nvim" && echo "   ✅ ~/.config/nvim"
    [ -d "$HOME/.local/share/nvim" ] && cp -r "$HOME/.local/share/nvim" "$BACKUP_DIR/share-nvim" && echo "   ✅ ~/.local/share/nvim"
    [ -d "$HOME/.local/state/nvim" ] && cp -r "$HOME/.local/state/nvim" "$BACKUP_DIR/state-nvim" && echo "   ✅ ~/.local/state/nvim"
    [ -d "$HOME/.cache/nvim" ] && cp -r "$HOME/.cache/nvim" "$BACKUP_DIR/cache-nvim" && echo "   ✅ ~/.cache/nvim"
    [ -d "$HOME/.config/ruff" ] && cp -r "$HOME/.config/ruff" "$BACKUP_DIR/config-ruff" && echo "   ✅ ~/.config/ruff"

    echo ""
    echo "✅ Backup completo: $BACKUP_DIR"
    echo ""
fi

echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "🗑️  Removendo arquivos..."
echo ""

# Remover diretórios do Neovim
if [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
    echo "   ✅ Removido: ~/.config/nvim"
else
    echo "   ⚠️  Não encontrado: ~/.config/nvim"
fi

if [ -d "$HOME/.local/share/nvim" ]; then
    rm -rf "$HOME/.local/share/nvim"
    echo "   ✅ Removido: ~/.local/share/nvim"
else
    echo "   ⚠️  Não encontrado: ~/.local/share/nvim"
fi

if [ -d "$HOME/.local/state/nvim" ]; then
    rm -rf "$HOME/.local/state/nvim"
    echo "   ✅ Removido: ~/.local/state/nvim"
else
    echo "   ⚠️  Não encontrado: ~/.local/state/nvim"
fi

if [ -d "$HOME/.cache/nvim" ]; then
    rm -rf "$HOME/.cache/nvim"
    echo "   ✅ Removido: ~/.cache/nvim"
else
    echo "   ⚠️  Não encontrado: ~/.cache/nvim"
fi

# Remover configuração do Ruff
if [ -d "$HOME/.config/ruff" ]; then
    rm -rf "$HOME/.config/ruff"
    echo "   ✅ Removido: ~/.config/ruff"
else
    echo "   ⚠️  Não encontrado: ~/.config/ruff"
fi

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo ""

# Perguntar sobre Django type stubs
read -p "🐍 Deseja remover Django type stubs instalados globalmente? (s/N): " remove_stubs

if [[ "$remove_stubs" =~ ^[Ss]$ ]]; then
    echo ""
    echo "🗑️  Removendo Django type stubs..."

    if command -v pip3 &> /dev/null; then
        pip3 uninstall -y django-stubs djangorestframework-stubs django-types django-stubs-ext 2>/dev/null || true
        echo "   ✅ Type stubs removidos"
    else
        echo "   ⚠️  pip3 não encontrado - pule esta etapa"
    fi
else
    echo ""
    echo "   ℹ️  Django type stubs mantidos (podem ser úteis para outros projetos)"
fi

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "✅ Desinstalação Completa!"
echo "════════════════════════════════════════════════════════════════════"
echo ""

if [[ "$backup_choice" =~ ^[Ss]$ ]]; then
    echo "📦 Backup salvo em: $BACKUP_DIR"
    echo ""
    echo "   Para restaurar:"
    echo "   cp -r $BACKUP_DIR/config-nvim ~/.config/nvim"
    echo "   cp -r $BACKUP_DIR/share-nvim ~/.local/share/nvim"
    echo "   cp -r $BACKUP_DIR/state-nvim ~/.local/state/nvim"
    echo "   cp -r $BACKUP_DIR/cache-nvim ~/.cache/nvim"
    echo "   cp -r $BACKUP_DIR/config-ruff ~/.config/ruff"
    echo ""
fi

echo "ℹ️  Para reinstalar:"
echo "   git clone https://github.com/SEU-USUARIO/nvim-config ~/.config/nvim"
echo "   cd ~/.config/nvim"
echo "   ./install.sh"
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo ""
