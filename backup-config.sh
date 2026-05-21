#!/bin/bash
# Script para fazer backup da configuração do Neovim

set -e

NVIM_DIR="$HOME/.config/nvim"
RUFF_DIR="$HOME/.config/ruff"
BACKUP_DIR="$HOME/.config/nvim-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "════════════════════════════════════════════════════════"
echo "🔄 Backup da Configuração do Neovim"
echo "════════════════════════════════════════════════════════"
echo ""

# Opção 1: Commit no Git (se for repositório)
if [ -d "$NVIM_DIR/.git" ]; then
    echo "📦 Opção 1: Commit no Git"
    echo "────────────────────────────────────────────────────────"

    cd "$NVIM_DIR"

    # Verificar mudanças
    if [[ -n $(git status -s) ]]; then
        echo "✅ Mudanças detectadas. Fazendo commit..."

        git add -A
        git status --short

        echo ""
        read -p "💬 Mensagem do commit (Enter para padrão): " commit_msg

        if [ -z "$commit_msg" ]; then
            commit_msg="Update config - $(date '+%Y-%m-%d %H:%M:%S')"
        fi

        git commit -m "$commit_msg"

        echo ""
        echo "✅ Commit realizado!"
        echo ""
        read -p "📤 Fazer push para o remote? (s/N): " do_push

        if [[ "$do_push" =~ ^[Ss]$ ]]; then
            git push
            echo "✅ Push realizado!"
        else
            echo "ℹ️  Push não realizado. Execute 'git push' manualmente."
        fi
    else
        echo "ℹ️  Nenhuma mudança detectada."
    fi

    echo ""
fi

# Opção 2: Backup em arquivo
echo "📦 Opção 2: Backup em Arquivo"
echo "────────────────────────────────────────────────────────"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/nvim-backup-$TIMESTAMP.tar.gz"

# Criar backup
tar -czf "$BACKUP_FILE" \
    -C "$HOME/.config" \
    --exclude='.git' \
    --exclude='lazy-lock.json' \
    --exclude='.cache' \
    nvim \
    ruff

echo "✅ Backup criado: $BACKUP_FILE"

# Listar backups existentes
echo ""
echo "📂 Backups existentes:"
ls -lh "$BACKUP_DIR" | tail -5

# Manter apenas os 5 backups mais recentes
echo ""
echo "🧹 Limpando backups antigos (mantendo 5 mais recentes)..."
cd "$BACKUP_DIR"
ls -t nvim-backup-*.tar.gz | tail -n +6 | xargs -r rm -f
echo "✅ Limpeza concluída!"

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Backup Completo!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📁 Backup salvo em: $BACKUP_FILE"
echo ""
echo "💡 Para restaurar:"
echo "   ./restore-config.sh $BACKUP_FILE"
echo ""
