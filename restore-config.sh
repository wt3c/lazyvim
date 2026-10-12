#!/bin/bash
# Script para restaurar configuração do Neovim

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$CONFIG_DIR/nvim-backup"

echo "════════════════════════════════════════════════════════"
echo "🔄 Restaurar Configuração do Neovim"
echo "════════════════════════════════════════════════════════"
echo ""

# Se passou arquivo como argumento
if [ -n "${1:-}" ]; then
    BACKUP_FILE="$1"
else
    # Lista backups disponíveis
    echo "📂 Backups disponíveis:"
    echo "────────────────────────────────────────────────────────"

    if [ ! -d "$BACKUP_DIR" ]; then
        echo "❌ Nenhum backup encontrado em $BACKUP_DIR"
        exit 1
    fi

    mapfile -d '' backups < <(find "$BACKUP_DIR" -maxdepth 1 -name 'nvim-backup-*.tar.gz' -type f \
        -printf '%T@ %p\0' | sort -znr | cut -z -d ' ' -f 2-)
    if [ "${#backups[@]}" -eq 0 ]; then
        echo "❌ Nenhum backup encontrado em $BACKUP_DIR"
        exit 1
    fi

    for i in "${!backups[@]}"; do
        backup_file="${backups[$i]}"
        backup_name=$(basename "$backup_file")
        backup_date="${backup_name#nvim-backup-}"
        backup_date="${backup_date%.tar.gz}"
        backup_size=$(du -h "$backup_file" | cut -f1)

        echo "$((i+1))) $backup_date ($backup_size)"
    done

    echo ""
    read -r -p "🔢 Escolha o número do backup (1-${#backups[@]}): " choice

    if ! [[ "$choice" =~ ^[1-9][0-9]{0,5}$ ]] || [ "$choice" -gt "${#backups[@]}" ]; then
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
echo "📦 Backup selecionado: $(basename "$BACKUP_FILE")"
tar -tzf "$BACKUP_FILE" > /dev/null
echo ""
echo "⚠️  ATENÇÃO: Isso irá SOBRESCREVER a configuração atual!"
echo ""
read -r -p "🔄 Continuar? (s/N): " confirm

if ! [[ "$confirm" =~ ^[Ss]$ ]]; then
    echo "❌ Restauração cancelada."
    exit 0
fi

echo ""
echo "🔄 Restaurando configuração..."
echo "────────────────────────────────────────────────────────"

# Backup da configuração atual (se existir)
mkdir -p "$CONFIG_DIR" "$BACKUP_DIR"
entries=()
for entry in nvim ruff; do
    if [ -d "$CONFIG_DIR/$entry" ]; then entries+=("$entry"); fi
done
if [ "${#entries[@]}" -gt 0 ]; then
    echo "📦 Fazendo backup da configuração atual..."
    CURRENT_BACKUP="$(mktemp "$BACKUP_DIR/nvim-before-restore-$(date +%Y%m%d_%H%M%S)-XXXXXX.tar.gz")"
    if ! tar -czf "$CURRENT_BACKUP" \
        -C "$CONFIG_DIR" \
        --exclude='.git' \
        --exclude='.cache' \
        --exclude='tests/.deps' \
        "${entries[@]}"; then
        rm -f -- "$CURRENT_BACKUP"
        echo "❌ Falha ao salvar a configuração atual; restauração cancelada."
        exit 1
    fi
    echo "✅ Backup atual salvo: $CURRENT_BACKUP"
fi

# Extrair backup
echo "📂 Extraindo backup..."
tar -xzf "$BACKUP_FILE" -C "$CONFIG_DIR"

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
echo "   2. Restaurar versões dos plugins: :Lazy restore (snapshots novos incluem o lockfile)"
echo "   3. Instale ferramentas: :Mason"
echo ""
