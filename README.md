# 🚀 LazyVim - Configuração Moderna e Completa

**IDE completo para Python, Django, Docker, Git e muito mais!**

---

## 📚 Documentação

- **[INSTALL.md](./INSTALL.md)** - 🚀 Instalação completa (pré-requisitos + troubleshooting)
- **[KEYBINDINGS.md](./KEYBINDINGS.md)** - 📖 Guia completo de atalhos (LEIA PRIMEIRO!)
- **[CHANGELOG.md](./CHANGELOG.md)** - 📋 Todas mudanças e funcionalidades
- **[BACKUP-GUIDE.md](./BACKUP-GUIDE.md)** - 📦 Backup e restauração (`backup-config.sh` / `restore-config.sh`)

---

## ⚡ Quick Start

```bash
git clone https://github.com/wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
nvim
```

Na primeira abertura, aguarde o Lazy e o Mason instalarem plugins e ferramentas. Depois execute
`:checkhealth nvim_config vim.provider mason`.

### Dependências obrigatórias do sistema

| Executável | Uso |
| --- | --- |
| `nvim` 0.12+ | Runtime da configuração e APIs utilizadas |
| `git`, `curl` | Bootstrap de plugins e downloads |
| `rg`, `fd` | Telescope e descoberta de ambientes pelo `venv-selector.nvim` |
| `make`, `cc`, `tree-sitter` | Extensões nativas e parsers do Treesitter |
| `node`, `npm` | Servidores e ferramentas JavaScript instalados pelo Mason |
| `python3`, `uv` | Projetos Python e provider isolado do Neovim/Jupyter |
| `unzip`, `tar`, `gzip` | Extração de pacotes pelo Mason |

O `install.sh` valida esses executáveis e cria o ambiente Jupyter com `pynvim`, `jupyter-client`, `jupytext` e
`ipykernel`. Os comandos de instalação para openSUSE e a matriz completa estão em [INSTALL.md](INSTALL.md).

### Dependências por funcionalidade

| Recurso | Dependência externa |
| --- | --- |
| Clipboard do sistema | `wl-copy` (`wl-clipboard`) no Wayland ou `xclip` no X11 |
| Busca fuzzy no terminal | `fzf` |
| Interface Git em terminal | `lazygit` |
| Atalhos Docker | Docker com `docker compose` ou o legado `docker-compose` |
| Plots e imagens inline | ImageMagick (`magick`) e Kitty ou terminal compatível com o protocolo gráfico Kitty |
| Claude Code | CLI `claude` instalado e autenticado |
| Bancos via Dadbod | Cliente do banco usado: `psql`, `sqlite3` ou `mysql` |
| Ícones completos | Nerd Font v3 configurada no terminal |

Pyright, Ruff, Mypy, debugpy, sqlfluff, Marksman, markdownlint, formatadores e servidores de linguagem são
declarados pela configuração e gerenciados pelo Mason; não devem ser instalados globalmente só para o Neovim.

### Atalhos Mais Usados

| Atalho               | Ação                         |
|----------------------|------------------------------|
| `<Space>?`           | Atalhos locais (which-key)   |
| `<Space>ff`          | Buscar arquivo               |
| `<Space>fg`          | Buscar texto (grep)          |
| `<Space>fk`          | Ver todos keybindings        |
| `Ctrl+/`             | Comentar linha               |
| `Ctrl+s`             | Salvar                       |
| `Ctrl+\`             | Terminal                     |
| `<Space>gg`          | Git (Neogit)                 |

### Verificar tudo

```vim
:checkhealth
:checkhealth nvim_config vim.provider mason
:LspInfo
```

---

## 🎯 Funcionalidades Principais

### 🐍 Python/Django

- **Ruff como ferramenta central** — lint + format + organize imports (line-length 120)
  - Formatação/imports no save via conform (`ruff_format` + `ruff_organize_imports`)
  - Code actions sob demanda: `<Space>cR` (Fix All) e `<Space>co` (Organize Imports)
- Pyright (type checking + hover/completion) + Mypy (checagem profunda via nvim-lint)
- Debug (DAP) pelo extra oficial do LazyVim, com config Django pronta (`<Space>dPr` sobe o runserver)
- Neotest (testes com UI, runner pytest)
- Django management commands (`<Space>p`)
- Virtual environment selector (`<Space>cv`, fornecido pelo extra do LazyVim)
- **uv.nvim** — roda/gerencia projeto uv sem sair do editor (`<Space>U`, ver [KEYBINDINGS.md](KEYBINDINGS.md))
- **Overseer** — task runner (`<Space>r*`) com templates Django prontos: `runserver`, `migrate`,
  `makemigrations` e `shell` (via `uv run python manage.py ...`, visíveis só quando há `manage.py` no CWD)

### 🧩 LSP

- Servidores declarados nos extras do LazyVim e em `mason-tools.lua`
- **Auto-instalação por filetype** (`lua/config/lsp_autoinstall.lua`): ao abrir um arquivo cujo filetype tem
  servidor disponível no Mason e nenhum instalado, instala sozinho; com vários candidatos, apenas notifica e
  sugere `:LspInstall`
- `lua_ls` apontado para o runtime do Neovim, para editar esta própria config com autocomplete de `vim.*`

### 📓 Jupyter (.ipynb)

- `jupytext.nvim` converte `.ipynb` ↔ markdown automaticamente ao abrir/salvar
- `molten-nvim` executa células contra um kernel Jupyter real, output inline (`<Space>m*`)
- `install.sh` cria um ambiente isolado com `pynvim`, `jupyter-client` e o conversor `jupytext`
- Renderização de imagens/plots usa `image.nvim`, ImageMagick e o protocolo gráfico Kitty; fora de um terminal
  compatível, a execução de células continua normal, apenas sem os plots

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

### 🤖 Claude Code

- `claudecode.nvim` — bridge nativo com o CLI `claude` já autenticado (`<Space>a*`,
  ver [KEYBINDINGS.md](KEYBINDINGS.md))
- Toggle/focus do painel, seleção de modelo, envio de seleção/buffer, aceitar/recusar diffs

### 🎨 UI Moderna

- Noice (mensagens)
- Notify (notificações)
- Telescope (busca fuzzy)
- Trouble (diagnósticos)
- Which-key (descoberta contextual de atalhos; `<Space>?` mostra os atalhos locais do buffer)
- Legendary (paleta de comandos/keymaps pesquisável — `<Space>sL`, complementa o which-key)
- Treesitter Context (cabeçalho fixo da classe/função — `<Space>ut` alterna)

### 🖌️ Temas (Omarchy + Themery)

- `lua/plugins/theme.lua` é um **symlink** para `~/.local/state/omarchy/current/theme/neovim.lua`: o tema do
  Omarchy prevalece no boot
- `omarchy-theme-hotreload.lua` reaplica o tema quando o Omarchy troca de tema (evento `LazyReload`), sem
  reiniciar o Neovim; `omarchy-themes.lua` deixa os colorschemes do Omarchy disponíveis (lazy)
- Themery (`<Space>uC`) continua disponível para troca manual durante a sessão, com Kanagawa, Gruvbox e
  Nightfox além de Tokyo Night/Catppuccin

> Fora do Omarchy o symlink fica quebrado — recrie `lua/plugins/theme.lua` como arquivo normal com o
> colorscheme desejado.

### 🧭 Navegação e Edição

- **Harpoon 2** — marcar arquivos e saltar entre eles (`<Space>h*`)
- **nvim-spectre** — search & replace no projeto com preview (`<Space>sr`)
- **oil.nvim** — editar diretórios como buffer (`-`)
- **mini.surround** — adicionar/trocar/remover aspas, parênteses e tags

### 📝 Notas (Quicknote)

- Notas por **projeto** gravadas em `.quicknote/` na raiz do repositório (versionáveis): `<Space>Na` / `No` /
  `Nl` / `Nd`, e `<Space>Np` lista com preview no Telescope
- Notas por **arquivo/linha**: `<Space>Nfa` / `Nfo` / `Nfl` / `Nfd`
- Linhas com nota ganham o sinal 📝 na gutter automaticamente

---

## 🗂️ Estrutura

```text
~/.config/nvim/
├── init.lua                         # Entry point (delega para lua/config/lazy.lua)
├── lazy-lock.json                   # Plugin versions lock
├── lazyvim.json                     # LazyVim extras habilitados
├── Makefile                         # Alvos de teste (test, test-unit, test-smoke, syntax)
├── install.sh / quick-install.sh    # Instalação (valida dependências, provider Python/Jupyter)
├── uninstall.sh                     # Remoção completa (com opção de backup)
├── backup-config.sh / restore-config.sh  # Backup e restauração da config
├── check-ruff.sh                    # Diagnóstico do Ruff usado pelo Neovim
├── README.md / INSTALL.md / KEYBINDINGS.md ⭐ / CHANGELOG.md / BACKUP-GUIDE.md
├── .github/workflows/test.yml       # CI: sintaxe + specs
├── lua/
│   ├── config/
│   │   ├── lazy.lua                 # Bootstrap do lazy.nvim + LazyVim
│   │   ├── options.lua              # Vim options
│   │   ├── keymaps.lua              # Keybindings ⭐
│   │   ├── autocmds.lua             # Autocommands (hot-reload, auto-reload de buffers)
│   │   └── lsp_autoinstall.lua      # Instala LSP ausente por filetype
│   ├── nvim_config/
│   │   └── health.lua               # :checkhealth nvim_config
│   └── plugins/
│       ├── python-tools.lua         # Python/Django (Ruff, Pyright, Mypy, DAP)
│       ├── uv-tools.lua             # uv.nvim
│       ├── jupyter-tools.lua        # jupytext + molten + image.nvim
│       ├── completion.lua           # Autocomplete (blink.cmp tuning)
│       ├── formatting.lua           # Conform (formatação, line-length 120)
│       ├── comments.lua             # Comentários (mini.comment + atalhos)
│       ├── surround.lua             # mini.surround
│       ├── editor-extras.lua        # Harpoon, Spectre, oil.nvim
│       ├── docker-tools.lua         # Docker support
│       ├── sql-tools.lua            # SQL (dadbod)
│       ├── markdown-tools.lua       # Markdown (Marksman, markdownlint)
│       ├── lua-tools.lua            # lua_ls para o runtime do Neovim
│       ├── git-modern.lua           # Git (Neogit, Diffview, GitSigns)
│       ├── test-runner.lua          # Neotest, Overseer, ToggleTerm, Trouble
│       ├── modern-ui.lua            # UI (Noice, Telescope, Treesitter Context)
│       ├── legendary.lua            # Paleta de comandos/keymaps
│       ├── quicknote.lua            # Notas por projeto/arquivo
│       ├── claude-code.lua          # claudecode.nvim
│       ├── themery.lua              # Troca manual de colorscheme
│       ├── colorschemes.lua         # Kanagawa, Gruvbox, Nightfox
│       ├── theme.lua                # Symlink → tema atual do Omarchy
│       ├── omarchy-themes.lua       # Colorschemes do Omarchy (lazy)
│       ├── omarchy-theme-hotreload.lua  # Reaplica tema ao trocar no Omarchy
│       └── mason-tools.lua          # Tool installation
├── tests/                           # config_spec.lua, smoke.lua, check_syntax.lua, run.sh
├── snippets/python.json             # Snippets Python
├── spell/                           # Dicionários PT-BR/EN
└── ruff-config/pyproject.toml       # Config base do Ruff
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
|--------------------|----------------------------------|
| LazyVim            | Base do setup                    |
| blink.cmp          | Autocomplete                     |
| Ruff (LSP)         | Lint + format + organize imports |
| Telescope          | Busca fuzzy                      |
| Treesitter         | Syntax highlighting              |
| Treesitter Context | Cabeçalho fixo de classe/função  |
| LSP                | Language servers (Pyright, etc.) |
| Mason              | Gerenciador de ferramentas       |
| Neotest            | Framework de testes              |
| Overseer           | Task runner (templates Django)   |
| Neogit             | Interface Git                    |
| Diffview           | Visualizador de diffs            |
| ToggleTerm         | Terminais                        |
| Noice              | UI moderna                       |
| Trouble            | Lista de diagnósticos            |
| Legendary          | Paleta de comandos/keymaps       |
| uv.nvim            | Gerenciador de projeto uv        |
| molten-nvim        | Execução de células Jupyter      |
| jupytext.nvim      | Conversão .ipynb ↔ markdown      |
| Themery            | Troca de colorscheme com preview |
| claudecode.nvim    | Bridge com o CLI Claude Code     |
| quicknote.nvim     | Notas por projeto/arquivo        |
| Harpoon 2          | Saltos rápidos entre arquivos    |
| nvim-spectre       | Search & replace no projeto      |
| oil.nvim           | Editar diretórios como buffer    |
| mini.surround      | Surround (aspas, parênteses)     |

---

## 🧪 Testes

A config tem uma suíte de testes em `tests/` (specs com plenary/busted + smoke de boot):

```bash
make test         # tudo: sintaxe + specs + smoke (boot da config completa)
make test-unit    # só sintaxe + specs (não instala todos os plugins)
make test-smoke   # só o smoke de boot
make syntax       # só validação de sintaxe Lua
```

- **Specs** (`tests/config_spec.lua`): invariantes — Ruff no conform, picker = Telescope, sem colisão de keymaps,
  plugins presentes, APIs não-deprecadas.
- **Smoke** (`tests/smoke.lua`): boota a config real e valida o estado em runtime.
- **CI**: `.github/workflows/test.yml` roda `make test-ci` (sintaxe + specs) a cada push/PR.

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

1. **Use which-key e Legendary:** `<Space>` abre o menu de atalhos; `<Space>sL` busca todos os comandos/keymaps
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

- **Plugins:** ~90 (conforme `lazy-lock.json`)
- **Keybindings:** 160+
- **LSPs:** Python, Docker, SQL, JSON, YAML, Bash, Markdown, Lua
- **Linguagens:** Python, Lua, Docker, SQL, Markdown, Shell
- **Frameworks:** Django (suporte nativo)

---

## 🎉 Versão

**2.3 - Claude Code, Jupyter & Temas**  
Data: 09/08/2026

> Destaques 2.3: claudecode.nvim integrado (`<Space>a*`), suporte a Jupyter notebooks (jupytext + molten,
> `<Space>m*`), uv.nvim para projetos Python (`<Space>U`), themery.nvim com novos colorschemes (Kanagawa,
> Gruvbox, Nightfox) e correção de colisões de keymap em `<Space>u*`.
>
> **Não lançado:** integração com o tema do Omarchy (hot reload), compatibilidade com Neovim 0.12 e
> `:checkhealth nvim_config`, extra oficial de DAP do LazyVim, which-key restaurado com Legendary como paleta
> complementar (`<Space>sL`), quicknote (`<Space>N*`), LSP auto-instalado por filetype e templates Django no
> Overseer. Ver [CHANGELOG.md](./CHANGELOG.md) para detalhes.

---

**Feito com ❤️ usando LazyVim**

🚀 **Happy Coding!**
