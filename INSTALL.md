# 🚀 Instalação Rápida - LazyVim Config Completo

## 📋 Pré-requisitos

- **Neovim** >= 0.9.0
- **Git**
- **Python** 3.10+ (para Python/Django features)

---

## 🎯 Instalação em Máquina Limpa

### Método 1: Clone Simples (RECOMENDADO)

```bash
# 1. Backup da config existente (se houver)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim.backup 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim.backup 2>/dev/null || true

# 2. Clonar este repositório
git clone https://github.com/SEU-USUARIO/nvim-config ~/.config/nvim
# OU se for seu repo:
git clone git@github.com:SEU-USUARIO/nvim-config.git ~/.config/nvim

# 3. Executar instalação
cd ~/.config/nvim
./install.sh

# 4. Abrir Neovim (plugins vão sincronizar automaticamente)
nvim

# 5. Instalar ferramentas LSP
# Dentro do Neovim:
:Mason
# Instale: pyright, ruff, mypy, debugpy, sqlfluff, etc

# 6. Reiniciar
:qa
nvim

# 7. Verificar tudo (opcional)
./check-ruff.sh
```

**Pronto! ✅**

---

## 🔄 Atualizar Config (em máquina já configurada)

```bash
cd ~/.config/nvim
git pull
./install.sh  # Atualiza configs globais se necessário
nvim
:Lazy sync
```

---

## 📦 O Que o `install.sh` Faz?

1. ✅ Copia config do Ruff para `~/.config/ruff/pyproject.toml`
2. ✅ Verifica dependências (Neovim, Git, Python, pip)
3. ✅ Instala Django type stubs (django-stubs, djangorestframework-stubs, django-types, django-stubs-ext)
4. ✅ Torna scripts executáveis
5. ✅ Mostra próximos passos

---

## 🌐 Método 2: Sem Git Clone (Download Manual)

```bash
# 1. Baixe o repositório como ZIP do GitHub
# 2. Extraia para ~/.config/nvim
# 3. Execute:
cd ~/.config/nvim
./install.sh
nvim
```

---

## 📱 Instalar em Múltiplas Máquinas

### Máquina 1 (original):
```bash
cd ~/.config/nvim
git add -A
git commit -m "Update config"
git push
```

### Máquina 2, 3, 4... (novas):
```bash
git clone SEU-REPO ~/.config/nvim
cd ~/.config/nvim
./install.sh
nvim
:Mason  # Instalar ferramentas
```

---

## 🆘 Troubleshooting

### Problema: Plugins não carregam
```vim
:Lazy restore
:Lazy clean
:Lazy sync
```

### Problema: LSP não funciona
```vim
:Mason
# Reinstale: pyright, ruff, mypy
:LspRestart
```

### Problema: Line-length não é 120
```bash
cd ~/.config/nvim
./check-ruff.sh
# Verifique se ~/.config/ruff/pyproject.toml existe
```

### Problema: Scripts não executam
```bash
cd ~/.config/nvim
chmod +x *.sh
```

---

## 📚 Após Instalação

### Leia a Documentação:
```vim
:e ~/.config/nvim/README.md          # Overview
:e ~/.config/nvim/KEYBINDINGS.md     # 150+ atalhos
:e ~/.config/nvim/BACKUP-GUIDE.md    # Como fazer backup
```

### Teste Funcionalidades:
```bash
# Abra arquivo Python
nvim test.py

# Testes:
# 1. Ctrl+/ para comentar
# 2. <Space>ff para buscar arquivos
# 3. <Space>gg para Git (Neogit)
# 4. Salvar (Ctrl+s) - deve formatar com 120 chars
```

---

## 🎓 Recursos

- **Which-key**: Pressione `<Space>` e aguarde para ver todos atalhos
- **Telescope**: `<Space>fk` mostra keybindings
- **Ajuda**: `:help <termo>` para documentação

---

## 🔧 Customização

### Adicionar Plugins:
Crie: `~/.config/nvim/lua/plugins/meu-plugin.lua`

### Mudar Keybindings:
Edite: `~/.config/nvim/lua/config/keymaps.lua`

### Mudar Opções:
Edite: `~/.config/nvim/lua/config/options.lua`

---

## ✅ Checklist Pós-Instalação

- [ ] Neovim abre sem erros
- [ ] `:Lazy` mostra todos plugins
- [ ] `:Mason` tem ferramentas instaladas (pyright, ruff, mypy)
- [ ] `:LspInfo` mostra LSPs ativos em arquivo Python
- [ ] `<Space>` mostra Which-key
- [ ] `Ctrl+/` comenta linha
- [ ] `./check-ruff.sh` mostra line-length = 120
- [ ] Ler KEYBINDINGS.md

---

## 🎉 Pronto!

Seu Neovim está configurado com:
- ✅ Python/Django (Ruff + Mypy, 120 chars)
- ✅ Docker (LSP + atalhos)
- ✅ Git (Neogit + Diffview)
- ✅ Testes (Neotest)
- ✅ UI moderna (Noice + Telescope)
- ✅ 150+ keybindings

**Divirta-se! 🚀**
