# 🚀 LazyVim - Configuração Moderna e Completa

**IDE completo para Python, Django, Docker, Git e muito mais!**

---

## 📚 Documentação

- **[INSTALL.md](./INSTALL.md)** - 🚀 Instalação completa (pré-requisitos + troubleshooting)
- **[KEYBINDINGS.md](./KEYBINDINGS.md)** - 📖 Guia completo de atalhos (LEIA PRIMEIRO!)
- **[CHANGELOG.md](./CHANGELOG.md)** - 📋 Todas mudanças e funcionalidades

---

## ⚡ Quick Start

### 0. Pré-requisito: Clipboard do sistema

```bash
# Wayland (Hyprland, Sway, GNOME Wayland)
yay -S wl-clipboard

# X11
yay -S xclip
```

### 1. Primeira Vez

```bash
# Abrir Neovim
nvim

# Sincronizar plugins (dentro do Neovim)
:Lazy sync

# Instalar ferramentas
:Mason
```

### 2. Atalhos Mais Usados

| Atalho               | Ação                         |
| -------------------- | ---------------------------- |
| `<Space>` (aguardar) | Ver todas opções (Which-key) |
| `<Space>ff`          | Buscar arquivo               |
| `<Space>fg`          | Buscar texto (grep)          |
| `<Space>fk`          | Ver todos keybindings        |
| `Ctrl+/`             | Comentar linha               |
| `Ctrl+s`             | Salvar                       |
| `Ctrl+\`             | Terminal                     |
| `<Space>gg`          | Git (Neogit)                 |

### 3. Verificar Tudo Funciona

```vim
:checkhealth
:LspInfo
```

---

## 🎯 Funcionalidades Principais

### 🐍 Python/Django

- **Ruff como ferramenta central** — lint + format + organize imports (line-length 120)
  - Formatação/imports no save via conform (`ruff_format` + `ruff_organize_imports`)
  - Code actions sob demanda: `<Space>cR` (Fix All) e `<Space>co` (Organize Imports)
- Pyright (type checking + hover/completion) + Mypy (checagem profunda via nvim-lint)
- Debug (DAP) com config Django pronta (`<Space>dj` sobe o runserver)
- Neotest (testes com UI, runner pytest)
- Django management commands (`<Space>p`)
- Virtual environment selector (`<Space>cv`, fornecido pelo extra do LazyVim)

### ⌨️ Autocomplete

- blink.cmp (motor padrão do LazyVim) com ajuste fino:
  - Ghost text inline, documentação automática, signature help e realce treesitter no menu

### 🐳 Docker

- LSP para Dockerfile e docker-compose
- Atalhos para todas operações (`<Space>D`)
- Terminal para logs

### 🌿 Git

- Neogit (interface moderna)
- Diffview (visualizador de diffs)
- GitSigns (hunks inline)
- Lazygit integrado

### 🧪 Testes

- Neotest (UI linda)
- Run/Debug testes
- Watch mode
- Atalhos: `<Space>t`

### 💻 Terminais

> Prefixo dedicado **`<Space>T`** (maiúsculo) para não colidir com testes (`<Space>t`).

- ToggleTerm (`Ctrl+\`)
- Float / Horizontal / Vertical (`<Space>Tf` / `<Space>Th` / `<Space>Tv`)
- Python REPL (`<Space>Tp`)
- Docker logs (`<Space>Tl`)
- Lazygit (`<Space>Tg`)

### 🎨 UI Moderna

- Noice (mensagens)
- Notify (notificações)
- Telescope (busca fuzzy)
- Trouble (diagnósticos)
- Which-key (ajuda)
- Treesitter Context (cabeçalho fixo da classe/função — `<Space>ut` alterna)

---

## 🗂️ Estrutura

```
~/.config/nvim/
├── init.lua                  # Entry point
├── lazy-lock.json            # Plugin versions lock
├── lazyvim.json              # LazyVim extras config
├── README.md                 # Este arquivo
├── KEYBINDINGS.md            # Guia completo de atalhos ⭐
├── CHANGELOG.md              # Log de mudanças
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # Plugin manager setup
│   │   ├── options.lua       # Vim options
│   │   ├── keymaps.lua       # Keybindings ⭐
│   │   └── autocmds.lua      # Autocommands
│   └── plugins/
│       ├── python-tools.lua  # Python/Django (Ruff, Pyright, Mypy, DAP)
│       ├── completion.lua    # Autocomplete (blink.cmp tuning)
│       ├── formatting.lua    # Conform (formatação, line-length 120)
│       ├── comments.lua      # Comentários (mini.comment + atalhos)
│       ├── docker-tools.lua  # Docker support
│       ├── git-modern.lua    # Git (Neogit, Diffview, GitSigns)
│       ├── test-runner.lua   # Neotest, Overseer, ToggleTerm, Trouble
│       ├── modern-ui.lua     # UI (Noice, Telescope, Treesitter Context)
│       ├── markdown-tools.lua# Markdown (Marksman, markdownlint)
│       ├── sql-tools.lua     # SQL support
│       └── mason-tools.lua   # Tool installation
```

---

## 🎓 Aprendendo Neovim

### Modos Vim

- `i` - Insert (editar)
- `v` - Visual (selecionar)
- `<Esc>` ou `jk` - Voltar para Normal
- `:` - Comandos

### Navegação Básica

- `h j k l` - Esquerda, Baixo, Cima, Direita
- `gg` - Topo do arquivo
- `G` - Final do arquivo
- `w` - Próxima palavra
- `b` - Palavra anterior

### Edição Básica

- `i` - Insert antes do cursor
- `a` - Insert depois do cursor
- `o` - Nova linha abaixo
- `dd` - Deletar linha
- `yy` - Copiar linha
- `p` - Colar

### Busca

- `/texto` - Buscar
- `n` - Próximo resultado
- `*` - Buscar palavra sob cursor

### Comandos Úteis

- `:w` - Salvar
- `:q` - Sair
- `:wq` - Salvar e sair
- `:q!` - Sair sem salvar
- `:help <termo>` - Ajuda

---

## 📦 Plugins Principais

| Plugin             | Função                           |
| ------------------ | -------------------------------- |
| LazyVim            | Base do setup                    |
| blink.cmp          | Autocomplete                     |
| Ruff (LSP)         | Lint + format + organize imports |
| Telescope          | Busca fuzzy                      |
| Treesitter         | Syntax highlighting              |
| Treesitter Context | Cabeçalho fixo de classe/função  |
| LSP                | Language servers (Pyright, etc.) |
| Mason              | Gerenciador de ferramentas       |
| Neotest            | Framework de testes              |
| Neogit             | Interface Git                    |
| Diffview           | Visualizador de diffs            |
| ToggleTerm         | Terminais                        |
| Noice              | UI moderna                       |
| Trouble            | Lista de diagnósticos            |
| Which-key          | Ajuda de keybindings             |

---

## 🛠️ Comandos Úteis

```vim
" Gerenciamento
:Lazy                  " Gerenciar plugins
:Mason                 " Gerenciar ferramentas LSP
:LspInfo               " Info sobre LSPs ativos
:checkhealth           " Verificar saúde do Neovim

" Telescope (busca)
:Telescope find_files  " Buscar arquivos
:Telescope live_grep   " Buscar texto
:Telescope keymaps     " Ver keybindings
:Telescope commands    " Ver comandos

" Git
:Neogit                " Abrir Neogit
:DiffviewOpen          " Abrir diff viewer

" Testes
:Neotest summary       " Resumo de testes

" Terminal
:ToggleTerm            " Toggle terminal

" Diagnósticos
:Trouble               " Lista de problemas
```

---

## ⚙️ Customização

### Mudar Keybindings

Edite: `~/.config/nvim/lua/config/keymaps.lua`

### Mudar Opções

Edite: `~/.config/nvim/lua/config/options.lua`

### Adicionar Plugins

Crie: `~/.config/nvim/lua/plugins/meu-plugin.lua`

### Configurar Databases (SQL)

Edite: `~/.config/nvim/lua/plugins/sql-tools.lua`

---

## 🐛 Troubleshooting

### Plugins não carregam

```vim
:Lazy restore
:Lazy clean
:Lazy sync
```

### LSP não funciona

```vim
:LspInfo
:LspRestart
:Mason
```

Reinstale as ferramentas necessárias.

### Ctrl+/ não funciona

Use `Ctrl+_` ou `gcc` (padrão LazyVim).

### Clipboard não sincroniza com o sistema (yy/p)

Instale `wl-clipboard` (Wayland) ou `xclip` (X11). Veja [INSTALL.md](./INSTALL.md).

### Performance lenta

```vim
:Lazy profile
```

Identifique plugins lentos e desabilite se necessário.

### Desinstalar Completamente

```bash
cd ~/.config/nvim
./uninstall.sh
```

Remove tudo (com opção de backup). Veja [INSTALL.md](./INSTALL.md) para detalhes.

---

## 📖 Recursos Externos

### Documentação Oficial

- [Neovim](https://neovim.io/doc/)
- [LazyVim](https://www.lazyvim.org/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)

### Aprender Vim

- `:Tutor` (dentro do Neovim)
- [OpenVim Tutorial](https://www.openvim.com/)
- [Vim Adventures](https://vim-adventures.com/)

### Plugins

- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Neogit](https://github.com/NeogitOrg/neogit)
- [Neotest](https://github.com/nvim-neotest/neotest)
- [Mason](https://github.com/mason-org/mason.nvim)

---

## 💡 Dicas

1. **Use Which-key:** Aperte `<Space>` e espere para ver opções
2. **Explore Telescope:** `<Space>fk` mostra todos keybindings
3. **Aprenda aos poucos:** Não precisa decorar tudo de uma vez
4. **Use :help:** `:help <termo>` é seu melhor amigo
5. **Pratique:** Use Neovim para tudo, a memória muscular vem com o tempo

---

## 🎯 Fluxo de Trabalho Recomendado

### 1. Abrir Projeto

```bash
cd ~/workspace/meu-projeto
nvim .
```

### 2. Buscar Arquivos

- `<Space>ff` - Buscar por nome
- `<Space>fg` - Buscar por conteúdo
- `<Space>fr` - Arquivos recentes

### 3. Editar

- Navegar: `h j k l` ou `Ctrl+h/j/k/l` (entre splits)
- Comentar: `Ctrl+/`
- Mover linhas: `Alt+j/k`
- Salvar: `Ctrl+s`

### 4. Git

- Status: `<Space>gg`
- Diff: `<Space>gd`
- Stage: `<Space>gs`
- Commit: `<Space>gc`

### 5. Testar

- Teste atual: `<Space>tt`
- Todos testes: `<Space>tT`
- Watch: `<Space>tw`

### 6. Docker

- Up: `<Space>Du`
- Logs: `<Space>Dl`
- Down: `<Space>Dd`

### 7. Terminal

- Toggle: `Ctrl+\`
- Python REPL: `<Space>Tp`
- Lazygit: `<Space>Tg`

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique `:checkhealth`
2. Leia [KEYBINDINGS.md](./KEYBINDINGS.md)
3. Leia [CHANGELOG.md](./CHANGELOG.md)
4. Consulte `:help <termo>`
5. [LazyVim Issues](https://github.com/LazyVim/LazyVim/issues)

---

## 📊 Estatísticas

- **Plugins:** ~65
- **Keybindings:** 160+
- **LSPs:** Python, Docker, SQL, JSON, YAML, Bash, Markdown, Lua
- **Linguagens:** Python, Lua, Docker, SQL, Markdown, Shell
- **Frameworks:** Django (suporte nativo)

---

## 🎉 Versão

**2.2 - Ruff-First & Autocomplete Edition**  
Data: 15/06/2026

> Destaques 2.2: Ruff centralizado (lint+format+imports) com code actions, autocomplete blink.cmp afinado, Treesitter
> Context, picker unificado no Telescope, novos plugins (Harpoon, Spectre, Oil), terminal movido p/ `<Space>T` (sem
> colisão com testes), e APIs deprecadas (diagnostic/gitsigns) atualizadas para o Neovim 0.12.

---

**Feito com ❤️ usando LazyVim**

🚀 **Happy Coding!**
