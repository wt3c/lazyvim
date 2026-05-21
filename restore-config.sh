#!/bin/bash
# Script para restaurar configuração do Neovim

set -e

BACKUP_DIR="$HOME/.config/nvim-backup"

echo "════════════════════════════════════════════════════════"
echo "🔄 Restaurar Configuração do Neovim"
echo "════════════════════════════════════════════════════════"
echo ""

# Se passou arquivo como argumento
if [ -n "$1" ]; then
    BACKUP_FILE="$1"
else
    # Lista backups disponíveis
    echo "📂 Backups disponíveis:"
    echo "────────────────────────────────────────────────────────"

    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR/*.tar.gz 2>/dev/null)" ]; then
        echo "❌ Nenhum backup encontrado em $BACKUP_DIR"
        exit 1
    fi

    backups=($(ls -t "$BACKUP_DIR"/nvim-backup-*.tar.gz))

    for i in "${!backups[@]}"; do
        backup_file="${backups[$i]}"
        backup_name=$(basename "$backup_file")
        backup_date=$(echo "$backup_name" | sed 's/nvim-backup-\(.*\)\.tar\.gz/\1/')
        backup_size=$(du -h "$backup_file" | cut -f1)

        echo "$((i+1))) $backup_date ($backup_size)"
    done

    echo ""
    read -p "🔢 Escolha o número do backup (1-${#backups[@]}): " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#backups[@]}" ]; then
        echo "❌ Escolha inválida!"
        exit 1
    fi

    BACKUP_FILE="${backups[$((choice-1))]}"
fi

# Verificar se arquivo existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Arquivo de backup não encontrado: $BACKUP_FILE"
    exit 1
fi

echo ""
echo "📦 Backup selecionado: $(basename $BACKUP_FILE)"
echo ""
echo "⚠️  ATENÇÃO: Isso irá SOBRESCREVER a configuração atual!"
echo ""
read -p "🔄 Continuar? (s/N): " confirm

if ! [[ "$confirm" =~ ^[Ss]$ ]]; then
    echo "❌ Restauração cancelada."
    exit 0
fi

echo ""
echo "🔄 Restaurando configuração..."
echo "────────────────────────────────────────────────────────"

# Backup da configuração atual (se existir)
if [ -d "$HOME/.config/nvim" ]; then
    echo "📦 Fazendo backup da configuração atual..."
    CURRENT_BACKUP="$BACKUP_DIR/nvim-before-restore-$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$CURRENT_BACKUP" \
        -C "$HOME/.config" \
        --exclude='.git' \
        --exclude='.cache' \
        nvim 2>/dev/null || true
    echo "✅ Backup atual salvo: $CURRENT_BACKUP"
fi

# Extrair backup
echo "📂 Extraindo backup..."
tar -xzf "$BACKUP_FILE" -C "$HOME/.config"

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Restauração Completa!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📁 Arquivos restaurados:"
echo "   • ~/.config/nvim/"
echo "   • ~/.config/ruff/"
echo ""
echo "🚀 Próximos passos:"
echo "   1. Abra o Neovim: nvim"
echo "   2. Sincronize plugins: :Lazy sync"
echo "   3. Instale ferramentas: :Mason"
echo ""
