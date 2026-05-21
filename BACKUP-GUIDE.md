# 📦 Guia de Backup e Restauração

## 🎯 Problema

Quando você reinstala o LazyVim (remove `~/.config/nvim`), **TODA** a configuração customizada é perdida!

## ✅ Solução

Este diretório tem **3 sistemas de backup**:

1. **Git** (Recomendado) - Versionamento completo
2. **Backup em arquivo** - Snapshot compactado
3. **Instalação rápida** - Script para recriar do zero

---

## 📁 O Que Precisa de Backup?

### 🟢 Arquivos FORA do diretório LazyVim (sobrevivem):
```
~/.config/ruff/
└── pyproject.toml      ✅ Config global Ruff (line-length 120)
```

### 🔴 Arquivos DENTRO do diretório LazyVim (perdidos se reinstalar):
```
~/.config/nvim/
├── README.md
├── KEYBINDINGS.md
├── CHANGELOG.md
├── LINE-LENGTH-FIX.md
├── BACKUP-GUIDE.md
├── backup-config.sh    ⭐ Scripts de backup
├── restore-config.sh   ⭐ Scripts de restauração
├── quick-install.sh    ⭐ Instalação rápida
├── check-ruff.sh
├── lazyvim.json        ⭐ Extras habilitados
└── lua/
    ├── config/
    │   ├── keymaps.lua    ⭐ Seus keybindings
    │   ├── options.lua    ⭐ Suas opções
    │   └── autocmds.lua   ⭐ Seus autocmds
    └── plugins/
        ├── python-tools.lua      ⭐ Config Python/Django
        ├── docker-tools.lua      ⭐ Config Docker
        ├── git-modern.lua        ⭐ Config Git
        ├── test-runner.lua       ⭐ Testes/Tasks
        ├── modern-ui.lua         ⭐ UI/UX
        ├── sql-tools.lua         ⭐ SQL
        └── mason-tools.lua       ⭐ Ferramentas
```

---

## 🔄 Método 1: Git (RECOMENDADO)

### Fazer Backup
```bash
cd ~/.config/nvim
./backup-config.sh
```

O script irá:
1. ✅ Fazer commit no Git (se houver mudanças)
2. ✅ Perguntar se quer fazer push
3. ✅ Criar backup em arquivo `.tar.gz` (redundância)

### Restaurar do Git
```bash
cd ~/.config/nvim
git pull
# ou
git reset --hard origin/main
```

---

## 📦 Método 2: Backup em Arquivo

### Fazer Backup
```bash
cd ~/.config/nvim
./backup-config.sh
```

Backup será salvo em: `~/.config/nvim-backup/nvim-backup-TIMESTAMP.tar.gz`

### Restaurar
```bash
cd ~/.config/nvim
./restore-config.sh
# Escolha o backup da lista
```

Ou especificar arquivo:
```bash
./restore-config.sh ~/.config/nvim-backup/nvim-backup-20260520_220000.tar.gz
```

---

## 🚀 Método 3: Reinstalação do Zero

### Cenário: Você deletou tudo e quer recomeçar

#### Opção A: Restaurar de Backup
```bash
# 1. Instalar LazyVim do zero
mv ~/.config/nvim ~/.config/nvim.old  # Se existir
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 2. Restaurar configuração
cd ~/.config/nvim
./restore-config.sh  # Se tiver o script no backup

# OU extrair backup manual
tar -xzf ~/path/to/nvim-backup-TIMESTAMP.tar.gz -C ~/.config

# 3. Abrir Neovim e sincronizar
nvim
:Lazy sync
:Mason
```

#### Opção B: Clonar do Git
```bash
# Se você versionou no Git (GitHub/GitLab)
git clone https://github.com/seu-usuario/nvim-config ~/.config/nvim

# Abrir e sincronizar
nvim
:Lazy sync
:Mason
```

#### Opção C: Instalação Rápida (Sem Backup)
```bash
# 1. Instalar LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 2. Executar instalação rápida
cd ~/.config/nvim
./quick-install.sh
# Siga as instruções
```

---

## 📋 Checklist Pós-Restauração

Após restaurar, verifique:

```bash
# 1. Verificar arquivos
ls ~/.config/nvim/lua/plugins/
# Deve mostrar todos os .lua customizados

# 2. Verificar Ruff global
cat ~/.config/ruff/pyproject.toml | grep line-length
# Deve mostrar: line-length = 120

# 3. Abrir Neovim
nvim

# 4. Sincronizar plugins
:Lazy sync

# 5. Instalar ferramentas
:Mason

# 6. Verificar LSPs
:LspInfo

# 7. Verificar line-length
cd ~/.config/nvim && ./check-ruff.sh
```

---

## 🔐 Estratégia de Backup Recomendada

### 1. Git (Diário/Semanal)
```bash
# Commit após mudanças importantes
cd ~/.config/nvim
git add -A
git commit -m "Update: descrição da mudança"
git push
```

### 2. Backup em Arquivo (Antes de Mudanças Grandes)
```bash
# Antes de testar algo novo ou atualizar LazyVim
./backup-config.sh
```

### 3. Remote Git (GitHub/GitLab)
```bash
# Se ainda não configurou remote:
cd ~/.config/nvim
git remote add origin https://github.com/seu-usuario/nvim-config.git
git push -u origin main
```

---

## 📤 Versionando no GitHub/GitLab

### Criar Repositório
```bash
# No GitHub/GitLab, crie um repositório privado: nvim-config

# No seu terminal:
cd ~/.config/nvim

# Se já é repositório (verifica)
git remote -v

# Se NÃO tem remote, adicione:
git remote add origin git@github.com:seu-usuario/nvim-config.git

# Commit tudo
git add -A
git commit -m "Initial commit - LazyVim complete config"

# Push
git push -u origin main
```

### Clonar em Outra Máquina
```bash
# Backup do nvim existente (se houver)
mv ~/.config/nvim ~/.config/nvim.bak

# Clonar seu config
git clone git@github.com:seu-usuario/nvim-config.git ~/.config/nvim

# Sincronizar
nvim
:Lazy sync
:Mason
```

---

## 🆘 Recuperação de Emergência

### Perdeu tudo e não tem backup?

1. **Recriar configuração básica:**
   ```bash
   # Instalar LazyVim
   git clone https://github.com/LazyVim/starter ~/.config/nvim
   rm -rf ~/.config/nvim/.git
   
   # Config global Ruff (isso você lembra!)
   mkdir -p ~/.config/ruff
   cat > ~/.config/ruff/pyproject.toml << 'EOF'
   [tool.ruff]
   line-length = 120
   target-version = "py310"
   EOF
   ```

2. **Consultar documentação:**
   - Este README.md (se tiver backup)
   - KEYBINDINGS.md
   - CHANGELOG.md

3. **Recriar plugins manualmente:**
   - Copie deste guia ou da documentação oficial
   - LazyVim docs: https://www.lazyvim.org/

---

## 📊 Resumo dos Scripts

| Script | Função | Quando Usar |
|--------|--------|-------------|
| `backup-config.sh` | Commit Git + backup .tar.gz | Antes de mudanças grandes |
| `restore-config.sh` | Restaura de .tar.gz | Após reinstalar |
| `quick-install.sh` | Recria config do zero | Sem backup disponível |
| `check-ruff.sh` | Verifica line-length 120 | Após restauração |

---

## 💡 Dicas

1. **Faça backup ANTES de:**
   - Atualizar LazyVim
   - Testar plugins novos
   - Mudanças grandes na configuração
   - Formatar o PC

2. **Mantenha backups em:**
   - Git (local)
   - GitHub/GitLab (remote)
   - Arquivo .tar.gz (local)
   - Drive/Dropbox (cloud) ← backup do backup!

3. **Automatize:**
   - Crie um cron job para backup diário
   - Use git hooks para auto-commit

4. **Documente:**
   - Anote mudanças importantes
   - Mantenha README atualizado

---

## 🎯 Quick Reference

```bash
# Fazer backup
./backup-config.sh

# Restaurar
./restore-config.sh

# Reinstalar do zero (com backup)
./restore-config.sh path/to/backup.tar.gz

# Reinstalar do zero (sem backup)
./quick-install.sh

# Verificar config
./check-ruff.sh

# Commit manual
git add -A && git commit -m "Update config" && git push

# Ver backups
ls -lh ~/.config/nvim-backup/
```

---

**✅ Com estes 3 métodos, você NUNCA perderá sua configuração!**

🔐 Git + 📦 Arquivo + 🚀 Quick Install = Segurança Total!
