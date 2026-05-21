# 🚀 Changelog - Reconfiguração Completa do LazyVim

## Data: 20/05/2026

---

## 📦 NOVOS PLUGINS INSTALADOS

### 🐳 Docker & Docker Compose
- **dockerfile-language-server** - LSP para Dockerfiles
- **docker-compose-language-service** - LSP para docker-compose.yml
- **hadolint** - Linter para Dockerfiles
- Atalhos dedicados sob `<leader>D`

### 🌿 Git Moderno
- **Neogit** - Interface Git moderna (tipo Magit)
- **Diffview** - Visualizador de diffs avançado
- **GitSigns** (melhorado) - Integração Git inline
- Telescope Git pickers

### 🧪 Testes e Execução
- **Neotest** - Framework de testes moderno com UI
  - Adapter Python/pytest integrado
  - Debug de testes
  - Watch mode
- **Overseer** - Task runner para scripts
- **ToggleTerm** - Gerenciador de terminais
  - Python REPL
  - Docker logs
  - Lazygit integrado

### 🎨 UI/UX Moderna
- **Noice** - UI moderna para mensagens, cmdline, popupmenu
- **Notify** - Notificações bonitas
- **Dressing** - Melhora interfaces vim.ui
- **Which-key** (melhorado) - Ajuda de keybindings
- **Illuminate** - Destaca referências sob cursor
- **Mini.indentscope** - Guias de indentação animadas
- **Colorizer** - Mostra cores no código
- **Telescope** (melhorado) - Busca fuzzy otimizada
- **Trouble** - Lista de diagnósticos moderna

---

## 🗂️ ARQUIVOS CRIADOS/MODIFICADOS

### ✨ Novos Arquivos
1. `/lua/plugins/docker-tools.lua` - Suporte Docker completo
2. `/lua/plugins/git-modern.lua` - Git moderno (Neogit, Diffview)
3. `/lua/plugins/test-runner.lua` - Testes e task runner (Neotest, Overseer, ToggleTerm, Trouble)
4. `/lua/plugins/modern-ui.lua` - Melhorias UI/UX (Noice, Notify, Dressing, Telescope, etc)
5. `/KEYBINDINGS.md` - Guia completo de keybindings
6. `/CHANGELOG.md` - Este arquivo

### 🔧 Arquivos Modificados
1. `/lazyvim.json` - Adicionado SQL extra
2. `/lua/config/keymaps.lua` - **COMPLETAMENTE REFEITO**
   - Ctrl+/ para comentar (antes: Ctrl+Space)
   - Atalhos Docker (`<leader>D`)
   - Atalhos Git melhorados
   - Window management
   - Buffer management
   - Edição moderna (Alt+j/k, jk/kj para ESC, etc)
3. `/lua/config/options.lua` - Diagnósticos melhorados
4. `/lua/config/autocmds.lua` - Auto-format on save
5. `/lua/plugins/python-tools.lua` - Atualizado (Ruff + Mypy)
6. `/lua/plugins/mason-tools.lua` - Atualizado com todas ferramentas
7. `/lua/plugins/sql-tools.lua` - Mantido

---

## ⌨️ MUDANÇAS DE KEYBINDINGS

### 🔄 Alterações Principais
- **Comentar:** `Ctrl+Space` ➜ `Ctrl+/` (mais padrão)
  - Alternativa: `Ctrl+_` (compatibilidade terminal)
- **Salvar:** Adicionado `Ctrl+s` (todos os modos)
- **Escape Insert:** `jk` ou `kj` (além do ESC)

### ➕ Novos Atalhos

#### 🐳 Docker (`<leader>D`)
- `Du` - docker-compose up -d
- `Dd` - docker-compose down
- `Dr` - docker-compose restart
- `Dl` - docker-compose logs -f
- `Db` - docker-compose build
- `DB` - docker-compose build --no-cache
- `Dp` - docker ps
- `Di` - docker images
- `Ds` - docker system prune
- `De` - docker exec -it (interativo)

#### 🌿 Git (`<leader>g`)
- `gg` - Neogit open
- `gc` - Neogit commit
- `gp` - Neogit push
- `gP` - Neogit pull
- `gd` - Diffview open
- `gD` - Diffview close
- `gh` - File history
- `gH` - Project history
- `gs` - Stage hunk
- `gr` - Reset hunk
- `gS` - Stage buffer
- `gR` - Reset buffer
- `gu` - Undo stage
- `gv` - Preview hunk
- `gb` - Blame line
- `gB` - Toggle blame
- `]h`/`[h` - Next/prev hunk

#### 🧪 Testes (`<leader>t`)
- `tt` - Test nearest
- `tf` - Test file
- `tT` - Test all
- `ts` - Toggle summary
- `to` - Show output
- `tO` - Toggle output panel
- `tS` - Stop test
- `tw` - Toggle watch
- `td` - Debug test
- `tf` - Terminal float
- `th` - Terminal horizontal
- `tv` - Terminal vertical
- `tp` - Python REPL terminal
- `tl` - Docker logs terminal
- `tg` - Lazygit terminal

#### ⚙️ Task Runner (`<leader>r`)
- `rr` - Run task
- `rt` - Toggle task list
- `ri` - Task info
- `ra` - Task action

#### 💻 Terminal
- `Ctrl+\` - Toggle terminal

#### 🪟 Window Management (`<leader>w`)
- `wv` - Split vertical
- `wh` - Split horizontal
- `we` - Equal size
- `wx` - Close
- `Ctrl+h/j/k/l` - Navigate windows
- `Ctrl+arrows` - Resize

#### 📄 Buffers (`<leader>b`)
- `bd` - Delete buffer
- `bD` - Delete all except current
- `Shift+h/l` - Prev/next buffer
- `[b`/`]b` - Prev/next buffer

#### 🔍 Telescope (`<leader>f`)
- `ff` - Find files
- `fr` - Recent files
- `fg` - Live grep
- `fw` - Grep word
- `fh` - Help tags
- `fk` - Keymaps
- `fc` - Commands
- `fs` - Document symbols
- `fS` - Workspace symbols
- `fd` - Diagnostics
- `fgc` - Git commits
- `fgb` - Git branches
- `fgs` - Git status
- `fgh` - Git stash

#### 🚨 Trouble (`<leader>x`)
- `xx` - Diagnostics
- `xX` - Buffer diagnostics
- `xL` - Location list
- `xQ` - Quickfix
- `xs` - Symbols
- `xl` - LSP defs/refs

#### ⚡ Toggles (`<leader>u`)
- `uw` - Toggle wrap
- `us` - Toggle spell
- `ul` - Toggle list chars
- `ur` - Toggle relative numbers
- `un` - Dismiss notifications

#### 📝 Edição Moderna
- `Alt+j/k` - Move line down/up
- `v` then `p` - Paste without yank
- `Ctrl+a` - Select all
- `<`/`>` (visual) - Indent (keeps selection)

---

## 🛠️ FERRAMENTAS INSTALADAS (MASON)

### Python
- pyright ✓
- ruff ✓
- mypy ✓
- debugpy ✓

### Docker
- dockerfile-language-server ✓
- docker-compose-language-service ✓
- hadolint ✓

### SQL
- sqlfluff ✓

### Markdown
- marksman ✓
- markdownlint-cli2 ✓
- markdown-toc ✓

### JSON/YAML
- json-lsp ✓
- yaml-language-server ✓

### Shell
- bash-language-server ✓
- shfmt ✓
- shellcheck ✓

### Geral
- stylua ✓

---

## 🎯 FUNCIONALIDADES PRINCIPAIS

### 1. 🐍 Python/Django Completo
- Ruff (lint + format, line-length 120)
- Mypy (type checking estrito)
- Pyright (LSP features)
- Debug com DAP
- Neotest para testes
- Django management commands

### 2. 🐳 Docker Workflow Completo
- LSP para Dockerfile e docker-compose
- Linting com hadolint
- Atalhos para todas operações comuns
- Terminal integrado para logs
- Exec interativo em containers

### 3. 🌿 Git Moderno e Fácil
- Neogit (interface tipo Magit)
- Diffview (diffs lindos)
- GitSigns (hunks inline)
- Telescope Git pickers
- Lazygit integrado

### 4. 🧪 Testes Profissionais
- Neotest com UI
- Run/Debug testes
- Watch mode
- Output em tempo real
- Integração com DAP

### 5. ⚙️ Task Runner
- Overseer para scripts
- Templates customizáveis
- Execução assíncrona
- Output tracking

### 6. 💻 Terminais Modernos
- ToggleTerm com float/split
- Python REPL dedicado
- Docker logs dedicado
- Lazygit dedicado
- Toggle com Ctrl+\

### 7. 🎨 UI/UX de Última Geração
- Noice (mensagens lindas)
- Notify (notificações)
- Dressing (inputs bonitos)
- Illuminate (destaque de referências)
- Colorizer (cores inline)
- Trouble (diagnósticos organizados)

### 8. 🔍 Busca Poderosa
- Telescope otimizado
- FZF nativo
- Pickers Git
- Symbols/Diagnostics
- Keymaps/Commands

---

## 📋 COMO TESTAR

### 1. Reiniciar Neovim
```bash
# Feche qualquer instância do Neovim e abra novamente
nvim
```

### 2. Sincronizar Plugins
```vim
:Lazy sync
```
Aguarde todos os plugins serem instalados/atualizados.

### 3. Instalar Ferramentas
```vim
:Mason
```
Verifique se todas as ferramentas listadas acima estão instaladas (✓).
Se não, selecione e pressione `i` para instalar.

### 4. Verificar LSPs
Abra um arquivo Python:
```vim
:e test.py
:LspInfo
```
Deve mostrar: `pyright` e `ruff` ativos.

### 5. Testar Comentários
- Modo Normal: `Ctrl+/` em uma linha
- Modo Visual: Selecione linhas, `Ctrl+/`

### 6. Testar Git
```vim
:Neogit
```
Ou use `<Space>gg`

### 7. Testar Docker
Em um projeto com docker-compose.yml:
```vim
<Space>Du     " docker-compose up -d
<Space>Dl     " docker-compose logs -f
```

### 8. Testar Testes
Em um arquivo de teste Python:
```vim
<Space>tt     " Rodar teste sob cursor
<Space>ts     " Abrir summary
```

### 9. Testar Terminal
```vim
Ctrl+\        " Toggle terminal
<Space>tp     " Python REPL
<Space>tg     " Lazygit
```

### 10. Testar Telescope
```vim
<Space>ff     " Buscar arquivos
<Space>fg     " Live grep
<Space>fk     " Ver todos keybindings
```

### 11. Ver Ajuda de Keybindings
```vim
<Space>       " Aguarde 1 segundo - Which-key aparece
<Space>fk     " Telescope keymaps
:e ~/.config/nvim/KEYBINDINGS.md
```

---

## ⚠️ POSSÍVEIS PROBLEMAS

### Ctrl+/ não funciona
**Causa:** Alguns terminais não capturam Ctrl+/

**Solução:**
- Use `Ctrl+_` (alternativa configurada)
- Ou use `gcc` (padrão LazyVim)

### Plugins não carregam
**Solução:**
```vim
:Lazy restore
:Lazy clean
:Lazy sync
```

### LSP não ativa
**Solução:**
```vim
:LspInfo
:LspRestart
:Mason
```
Reinstale as ferramentas.

### Neotest não encontra testes
**Solução:**
- Certifique-se que pytest está instalado no venv
- Ative o venv correto: `<Space>cv`

### Lazygit não abre
**Solução:**
Instale lazygit no sistema:
```bash
# Arch/Garuda
yay -S lazygit

# Ubuntu/Debian
sudo apt install lazygit
```

---

## 🎓 PRÓXIMOS PASSOS

### 1. Personalize
- Edite cores em `:Lazy` → busque por "colorscheme"
- Ajuste keybindings em `~/.config/nvim/lua/config/keymaps.lua`
- Configure databases em `~/.config/nvim/lua/plugins/sql-tools.lua`

### 2. Aprenda
- Leia `KEYBINDINGS.md` completo
- Use `<Space>fk` para explorar keybindings
- Use `<Space>` e aguarde para ver opções

### 3. Explore Plugins
- `:Lazy` - Ver todos plugins instalados
- `:Mason` - Ver ferramentas disponíveis
- `:Telescope` - Ver todos pickers

### 4. Documentação
- `:h nvim` - Ajuda Neovim
- `:h lazy.nvim` - Ajuda Lazy
- `:h telescope` - Ajuda Telescope
- [LazyVim Docs](https://www.lazyvim.org/)

---

## 📊 COMPARAÇÃO ANTES vs DEPOIS

| Funcionalidade | Antes | Depois |
|----------------|-------|--------|
| Comentar | Ctrl+Space | Ctrl+/ ✨ |
| Git | Básico (gitsigns) | Neogit + Diffview + Lazygit ✨ |
| Testes | Manual | Neotest com UI ✨ |
| Docker | Nenhum | Completo (LSP + atalhos) ✨ |
| Terminal | :terminal | ToggleTerm + especializados ✨ |
| Task Runner | Nenhum | Overseer ✨ |
| UI | Padrão | Noice + Notify + Dressing ✨ |
| Diagnósticos | Lista | Trouble ✨ |
| Busca | Básica | Telescope otimizado ✨ |
| Keybindings | ~30 | 150+ ✨ |
| Plugins | ~40 | ~60 ✨ |

---

## 🎉 CONCLUSÃO

Seu Neovim agora é um **IDE moderno completo** com:

✅ Suporte profissional a Python/Django  
✅ Workflow Docker integrado  
✅ Git moderno e visual  
✅ Testes com UI  
✅ Task runner  
✅ Terminais especializados  
✅ Interface linda  
✅ 150+ keybindings produtivos  

**Aproveite! 🚀**

---

## 📝 MANUTENÇÃO

### Atualizar Plugins
```vim
:Lazy sync
```

### Atualizar Ferramentas
```vim
:Mason
u (para atualizar tudo)
```

### Verificar Saúde
```vim
:checkhealth
```

### Backup
Seu config está em: `~/.config/nvim/`
Faça backup regular ou use Git para versionar.

---

**Criado em:** 20/05/2026  
**Versão:** 2.0 - Modern Complete Edition
