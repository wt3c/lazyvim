#!/bin/bash
# Script para fazer backup da configuração do Neovim

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_DIR="$CONFIG_DIR/nvim"
BACKUP_DIR="$CONFIG_DIR/nvim-backup"
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
        git status --short
        read -r -p "💬 Criar um commit com todas as mudanças antes do snapshot? (s/N): " do_commit
        if [[ "$do_commit" =~ ^[Ss]$ ]]; then
            echo "✅ Mudanças detectadas. Fazendo commit..."

            git add -A
            git status --short

            echo ""
            read -r -p "💬 Mensagem do commit (Enter para padrão): " commit_msg

            if [ -z "$commit_msg" ]; then
                commit_msg="Update config - $(date '+%Y-%m-%d %H:%M:%S')"
            fi

            git commit -m "$commit_msg"

            echo ""
            echo "✅ Commit realizado!"
            echo ""
            read -r -p "📤 Fazer push para o remote? (s/N): " do_push

            if [[ "$do_push" =~ ^[Ss]$ ]]; then
                git push
                echo "✅ Push realizado!"
            else
                echo "ℹ️  Push não realizado. Execute 'git push' manualmente."
            fi
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

BACKUP_FILE="$(mktemp "$BACKUP_DIR/nvim-backup-$TIMESTAMP-XXXXXX.tar.gz")"
complete=0
trap 'if [ "$complete" -eq 0 ]; then rm -f -- "$BACKUP_FILE"; fi' EXIT
entries=(nvim)
if [ -d "$CONFIG_DIR/ruff" ]; then
    entries+=(ruff)
fi

# Criar backup
tar -czf "$BACKUP_FILE" \
    -C "$CONFIG_DIR" \
    --exclude='.git' \
    --exclude='.cache' \
    --exclude='tests/.deps' \
    "${entries[@]}"
complete=1

echo "✅ Backup criado: $BACKUP_FILE"

# Listar backups existentes
echo ""
echo "📂 Backups existentes:"
find "$BACKUP_DIR" -maxdepth 1 -name 'nvim-backup-*.tar.gz' -type f -printf '%f\n'

# Manter apenas os 5 backups mais recentes
echo ""
echo "🧹 Limpando backups antigos (mantendo 5 mais recentes)..."
mapfile -d '' backups < <(find "$BACKUP_DIR" -maxdepth 1 -name 'nvim-backup-*.tar.gz' -type f \
    -printf '%T@ %p\0' | sort -znr | cut -z -d ' ' -f 2-)
for ((i=5; i<${#backups[@]}; i++)); do
    rm -f -- "${backups[$i]}"
done
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
