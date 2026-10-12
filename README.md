# 🚀 LazyVim - Configuração Moderna e Completa

**Configuração do Neovim para Python/Django, Go, Rust, Docker, SQL, Git e Jupyter.**

---

## Documentação

- **[INSTALL.md](./INSTALL.md)** - 🚀 Instalação completa (pré-requisitos + troubleshooting)
- **[KEYBINDINGS.md](./KEYBINDINGS.md)** - 📖 Guia completo de atalhos (LEIA PRIMEIRO!)
- **[CHANGELOG.md](./CHANGELOG.md)** - 📋 Todas mudanças e funcionalidades
- **[BACKUP-GUIDE.md](./BACKUP-GUIDE.md)** - 📦 Backup e restauração (`backup-config.sh` / `restore-config.sh`)

## Sumário

- [Início rápido](#início-rápido)
- [Funcionalidades](#funcionalidades-principais)
- [Estrutura](#estrutura)
- [Aprendendo Neovim](#aprendendo-neovim)
- [Plugins e ferramentas](#plugins-e-ferramentas-principais)
- [Testes da configuração](#testes-da-configuração)
- [Comandos úteis](#comandos-úteis)
- [Customização](#customização)
- [Resolução de problemas](#resolução-de-problemas)
- [Recursos externos](#recursos-externos)
- [Fluxo de trabalho](#fluxo-de-trabalho)
- [Suporte](#suporte)
- [Versão](#versão)

---

## Início rápido

O fluxo abaixo pressupõe que `~/.config/nvim` ainda não existe. Se já houver uma configuração, preserve-a antes de
clonar; veja as opções em [BACKUP-GUIDE.md](BACKUP-GUIDE.md). Em uma cópia existente deste repositório, consulte
[INSTALL.md](INSTALL.md) para reinstalar as dependências.

O `install.sh` sobrescreve `~/.config/ruff/pyproject.toml` com a configuração deste repositório e instala ou atualiza o
provider Python/Jupyter isolado. Guarde também sua configuração global do Ruff, caso já tenha personalizações.

```bash
git clone https://github.com/wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
nvim
```

Na primeira abertura, aguarde o Lazy e o Mason instalarem plugins e ferramentas. Depois execute
`:checkhealth nvim_config vim.provider mason`.

### Dependências obrigatórias do sistema

| Executável                  | Uso                                                           |
| --------------------------- | ------------------------------------------------------------- |
| `nvim` 0.12+ com LuaJIT     | Runtime da configuração e APIs utilizadas                     |
| `git`, `curl`               | Bootstrap de plugins e downloads                              |
| `rg`, `fd`                  | Telescope e descoberta de ambientes pelo `venv-selector.nvim` |
| `make`, `cc`, `tree-sitter` | Extensões nativas e parsers do Treesitter                     |
| `node`, `npm`               | Servidores e ferramentas JavaScript instalados pelo Mason     |
| `python3`, `uv`             | Projetos Python e provider isolado do Neovim/Jupyter          |
| `unzip`, `tar`, `gzip`      | Extração de pacotes pelo Mason                                |

O `install.sh` valida esses executáveis e cria o ambiente Jupyter com `pynvim`, `jupyter-client`, `jupytext` e
`ipykernel`. Os comandos de instalação para openSUSE e a matriz completa estão em [INSTALL.md](INSTALL.md).

### Dependências por funcionalidade

| Recurso                   | Dependência externa                                                                                                  |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Desenvolvimento Go        | `go` disponível no `PATH`; instalação descrita em [INSTALL.md](INSTALL.md#desenvolvimento-go)                        |
| Desenvolvimento Rust      | Toolchain rustup com Cargo, rustfmt, Clippy, rust-analyzer e rust-src; [instalação](INSTALL.md#desenvolvimento-rust) |
| Clipboard do sistema      | `wl-copy` (`wl-clipboard`) no Wayland ou `xclip` no X11                                                              |
| Busca fuzzy no terminal   | `fzf`                                                                                                                |
| Interface Git em terminal | `lazygit`                                                                                                            |
| Atalhos Docker            | Docker com `docker compose` ou o legado `docker-compose`                                                             |
| Plots e imagens inline    | ImageMagick (`magick`) e Kitty ou terminal compatível com o protocolo gráfico Kitty                                  |
| Claude Code               | CLI `claude` instalado e autenticado                                                                                 |
| Bancos via Dadbod         | Cliente do banco usado: `psql`, `sqlite3` ou `mysql`                                                                 |
| Ícones completos          | Nerd Font v3 configurada no terminal                                                                                 |

Pyright, Ruff, Mypy, debugpy, sqlfluff, Marksman, markdownlint, formatadores e servidores de linguagem são declarados
pela configuração e gerenciados pelo Mason; não devem ser instalados globalmente só para o Neovim. Para Go, isso inclui
`gopls`, `goimports`, `gofumpt`, `delve` e `golangci-lint`; o compilador Go é instalado separadamente. Para Rust,
rustup gerencia os componentes da toolchain e o Mason instala o CodeLLDB.

### Atalhos Mais Usados

| Atalho      | Ação                       |
| ----------- | -------------------------- |
| `<Space>?`  | Atalhos locais (which-key) |
| `<Space>ff` | Buscar arquivo             |
| `<Space>fg` | Buscar texto (grep)        |
| `<Space>fk` | Ver todos keybindings      |
| `Ctrl+/`    | Comentar linha             |
| `Ctrl+s`    | Salvar                     |
| `Ctrl+\`    | Terminal                   |
| `<Space>gg` | Git (Neogit)               |

### Verificar tudo

```vim
:checkhealth
:checkhealth nvim_config vim.provider mason
:LspInfo
```

---

## Funcionalidades Principais

### Desenvolvimento Go

- Extra oficial `lazyvim.plugins.extras.lang.go` habilitado em `lazyvim.json`
- **gopls** — autocomplete, navegação, diagnósticos, ações de código e dicas de tipos/parâmetros
- **Conform** — organização de imports com `goimports` e formatação com `gofumpt` ao salvar
- **Treesitter** — parsers para Go, `go.mod`, `go.work` e `go.sum`
- **golangci-lint** — lint via `nvim-lint`
- **Neotest** — adaptador `neotest-golang`, junto do adaptador Python já configurado
- **DAP** — depuração com Delve e `nvim-dap-go`, integrada ao extra `dap.core`

Abra um projeto com `go.mod` ou `go.work` e um arquivo `.go`. Confira `:LspInfo` e `:ConformInfo` para verificar o
servidor e os formatadores disponíveis.

| Atalho      | Ação em arquivos Go                 |
| ----------- | ----------------------------------- |
| `<Space>cf` | Formatar o arquivo                  |
| `<Space>tt` | Executar o teste próximo ao cursor  |
| `<Space>tf` | Executar os testes do arquivo       |
| `<Space>tT` | Executar a suíte do projeto         |
| `<Space>td` | Depurar o teste próximo ao cursor   |
| `<Space>ts` | Abrir ou fechar o resumo dos testes |

Pré-requisitos e instalação: [perfil Go em INSTALL.md](INSTALL.md#desenvolvimento-go). Referências oficiais:
[extra Go do LazyVim](https://www.lazyvim.org/extras/lang/go) e [gopls](https://go.dev/gopls/).

### Desenvolvimento Rust

- Extra oficial `lazyvim.plugins.extras.lang.rust` habilitado em `lazyvim.json`
- **rustaceanvim + rust-analyzer** — autocomplete, navegação, ações de código e diagnósticos do Clippy
- **Conform + rustfmt** — formatação ao salvar com a toolchain ativa
- **crates.nvim** — suporte a dependências em `Cargo.toml`
- **Treesitter** — parsers Rust e RON
- **Neotest** — adaptador `rustaceanvim.neotest`, preservando os adaptadores Python e Go
- **DAP + CodeLLDB** — depuração pelo extra oficial, com o adaptador instalado pelo Mason

Abra um projeto com `Cargo.toml` e um arquivo `.rs`. `<Space>cf` formata; `<Space>tt`, `<Space>tf` e `<Space>tT`
executam testes; `<Space>td` depura o teste próximo ao cursor. `<Space>cR` abre ações Rust e `<Space>dr` lista os alvos
disponíveis para depuração. A descoberta de testes aguarda a indexação do projeto pelo rust-analyzer.

Instalação e toolchain: [perfil Rust em INSTALL.md](INSTALL.md#desenvolvimento-rust). Referência:
[extra Rust do LazyVim](https://www.lazyvim.org/extras/lang/rust).

### 🐍 Python/Django

- **Ruff como ferramenta central** — lint + format + organize imports (line-length 120)
  - Formatação/imports no save via conform (`ruff_format` + `ruff_organize_imports`)
  - Code actions sob demanda: `<Space>cR` (Fix All) e `<Space>co` (Organize Imports)
  - O LSP fornece diagnósticos e ações de código; a formatação fica com o Conform
  - O Ruff usa a configuração do projeto quando presente; 120 é o padrão global instalado por `install.sh`
- Pyright (type checking + hover/completion) + Mypy (checagem profunda via nvim-lint)
- Debug (DAP) pelo extra oficial do LazyVim, com config Django pronta (`<Space>dPr` sobe o runserver)
- Neotest (testes com UI, runner pytest)
- Django management commands (`<Space>p`)
- Virtual environment selector (`<Space>cv`, fornecido pelo extra do LazyVim)
- **uv.nvim** — roda/gerencia projeto uv sem sair do editor (`<Space>U`, ver [KEYBINDINGS.md](KEYBINDINGS.md))
- **Overseer** — task runner (`<Space>r*`) com templates Django prontos: `runserver`, `migrate`, `makemigrations` e
  `shell` (via `uv run python manage.py ...`, visíveis só quando há `manage.py` no CWD)

### 🧩 LSP

- Servidores declarados nos extras do LazyVim e em `mason-tools.lua`
- **Auto-instalação por filetype** (`lua/config/lsp_autoinstall.lua`): ao abrir um arquivo cujo filetype tem servidor
  disponível no Mason e nenhum instalado, instala sozinho; com vários candidatos, apenas notifica e sugere `:LspInstall`
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
- Atalhos para Compose, logs, imagens, contêineres e execução interativa (`<Space>D`)
- Terminal para logs

### 🌿 Git

- Neogit (interface moderna)
- Diffview (visualizador de diffs)
- GitSigns (hunks inline)
- Lazygit integrado

### 🧪 Testes

- Neotest com resumo, resultados e saída dos testes
- Run/Debug testes
- Watch mode
- Atalhos: `<Space>t`

### 💻 Terminais

> Prefixo dedicado **`<Space>T`** (maiúsculo) para não colidir com testes (`<Space>t`).

- Snacks.terminal (`Ctrl+\`)
- Float / Horizontal / Vertical (`<Space>Tf` / `<Space>Th` / `<Space>Tv`)
- Python REPL (`<Space>Tp`)
- Docker logs (`<Space>Tl`)
- Lazygit (`<Space>Tg`)

### 🤖 Claude Code

- `claudecode.nvim` — bridge nativo com o CLI `claude` já autenticado (`<Space>a*`, ver
  [KEYBINDINGS.md](KEYBINDINGS.md))
- Toggle/focus do painel, seleção de modelo, envio de seleção/buffer, aceitar/recusar diffs

### 🎨 UI Moderna

- Noice (mensagens)
- Snacks.notifier (notificações)
- Telescope (busca fuzzy)
- Trouble (diagnósticos)
- Which-key (descoberta contextual de atalhos; `<Space>?` mostra os atalhos locais do buffer)
- Legendary (paleta de comandos/keymaps pesquisável — `<Space>sL`, complementa o which-key)
- Treesitter Context (cabeçalho fixo da classe/função — `<Space>ut` alterna)

### 🖌️ Temas (Omarchy + Themery)

- `lua/plugins/theme.lua` é um **symlink** para `~/.local/state/omarchy/current/theme/neovim.lua`: o tema do Omarchy
  prevalece no boot
- `omarchy-theme-hotreload.lua` reaplica o tema quando o Omarchy troca de tema (evento `LazyReload`), sem reiniciar o
  Neovim; `omarchy-themes.lua` deixa os colorschemes do Omarchy disponíveis (lazy)
- Themery (`<Space>uC`) continua disponível para troca manual durante a sessão, com Kanagawa, Gruvbox e Nightfox além de
  Tokyo Night/Catppuccin
- `<Space>uB` alterna entre Catppuccin Latte e Tokyo Night Moon durante a sessão

> Fora do Omarchy, remova o symlink quebrado antes de criar um arquivo normal em `lua/plugins/theme.lua` com o
> colorscheme desejado. Dentro do Omarchy, o symlink é gerenciado pelo sistema.

### 🧭 Navegação e Edição

- **Harpoon 2** — marcar arquivos e saltar entre eles (`<Space>h*`)
- **grug-far** (LazyVim) — search & replace no projeto com preview (`<Space>sr`)
- **oil.nvim** — editar diretórios como buffer (`-`)
- **mini.surround** — adicionar/trocar/remover aspas, parênteses e tags

### 📝 Notas (Quicknote)

- Notas gravadas em `.quicknote/` no **diretório atual do Neovim** (versionáveis): `<Space>Na` / `No` / `Nl` /
  `Nd`, e `<Space>Np` lista com preview no Telescope. Para manter as notas na raiz do projeto, abra o Neovim nessa raiz;
  confira o diretório atual com `:pwd`
- Notas por **arquivo/linha**: `<Space>Nfa` / `Nfo` / `Nfl` / `Nfd`
- Linhas com nota ganham o sinal 📝 na gutter automaticamente

---

## Estrutura

```text
~/.config/nvim/
├── init.lua                         # Entry point (delega para lua/config/lazy.lua)
├── lazy-lock.json                   # Plugin versions lock
├── lazyvim.json                     # LazyVim extras habilitados
├── Makefile                         # Testes gerais, integrações Go/Rust e sintaxe
├── install.sh / quick-install.sh    # Instalação (valida dependências, provider Python/Jupyter)
├── uninstall.sh                     # Remoção completa (com opção de backup)
├── backup-config.sh / restore-config.sh  # Backup e restauração da config
├── check-ruff.sh                    # Diagnóstico do Ruff usado pelo Neovim
├── README.md / INSTALL.md / KEYBINDINGS.md ⭐ / CHANGELOG.md / BACKUP-GUIDE.md
├── .github/workflows/test.yml       # CI: sintaxe + specs e smoke
├── lua/
│   ├── config/
│   │   ├── lazy.lua                 # Bootstrap do lazy.nvim + LazyVim
│   │   ├── options.lua              # Vim options
│   │   ├── keymaps.lua              # Keybindings ⭐
│   │   ├── autocmds.lua             # Autocommands (hot-reload, auto-reload de buffers, indentação)
│   │   ├── python.lua               # Raiz do projeto e executáveis do venv por buffer
│   │   ├── docker.lua               # Comando Docker Compose (v2 primeiro) e cwd do compose file
│   │   └── lsp_autoinstall.lua      # Instala LSP ausente por filetype
│   ├── nvim_config/
│   │   └── health.lua               # :checkhealth nvim_config
│   └── plugins/
│       ├── python-tools.lua         # Python/Django (Ruff, Pyright, Mypy, DAP)
│       ├── uv-tools.lua             # uv.nvim
│       ├── jupyter-tools.lua        # jupytext + molten + image.nvim
│       ├── completion.lua           # Autocomplete (blink.cmp tuning)
│       ├── formatting.lua           # Conform (formatação, line-length 120)
│       ├── surround.lua             # mini.surround
│       ├── editor-extras.lua        # Harpoon, oil.nvim
│       ├── sql-tools.lua            # SQL (dadbod)
│       ├── markdown-tools.lua       # Markdown (Marksman, markdownlint)
│       ├── lua-tools.lua            # lua_ls para o runtime do Neovim
│       ├── git-modern.lua           # Git (Neogit, Diffview, GitSigns)
│       ├── test-runner.lua          # Neotest, Overseer, terminais (Snacks), Trouble
│       ├── modern-ui.lua            # UI (Noice, Telescope, Treesitter Context)
│       ├── legendary.lua            # Paleta de comandos/keymaps
│       ├── quicknote.lua            # Notas por projeto/arquivo
│       ├── claude-code.lua          # claudecode.nvim
│       ├── themery.lua              # Troca manual de colorscheme
│       ├── theme.lua                # Symlink → tema atual do Omarchy
│       ├── omarchy-themes.lua       # Colorschemes do Omarchy (lazy)
│       ├── omarchy-theme-hotreload.lua  # Reaplica tema ao trocar no Omarchy
│       └── mason-tools.lua          # Tool installation
├── tests/                           # Specs, scripts, smoke, integrações Go/Rust, sintaxe e run.sh
├── snippets/python.json             # Snippets Python
├── spell/                           # Dicionários PT-BR/EN
└── ruff-config/pyproject.toml       # Config base do Ruff
```

---

## Aprendendo Neovim

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

### Comandos básicos

- `:w` - Salvar
- `:q` - Sair
- `:wq` - Salvar e sair
- `:q!` - Sair sem salvar
- `:help <termo>` - Ajuda

---

## Plugins e ferramentas principais

| Plugin             | Função                           |
| ------------------ | -------------------------------- |
| LazyVim            | Base do setup                    |
| blink.cmp          | Autocomplete                     |
| Ruff (LSP)         | Diagnósticos e ações de código   |
| Telescope          | Busca fuzzy                      |
| Treesitter         | Syntax highlighting              |
| Treesitter Context | Cabeçalho fixo de classe/função  |
| LSP                | Language servers (Pyright, etc.) |
| gopls              | Servidor de linguagem Go         |
| Conform            | Formatação por linguagem         |
| Mason              | Gerenciador de ferramentas       |
| Neotest            | Framework de testes              |
| neotest-golang     | Adaptador de testes Go           |
| nvim-dap-go        | Integração com o depurador Delve |
| rustaceanvim       | Rust LSP, testes e depuração     |
| rust-analyzer      | Servidor de linguagem Rust       |
| crates.nvim        | Dependências no Cargo.toml       |
| rustfmt / Clippy   | Formatação e diagnósticos Rust   |
| CodeLLDB           | Adaptador de depuração Rust      |
| Overseer           | Task runner (templates Django)   |
| Neogit             | Interface Git                    |
| Diffview           | Visualizador de diffs            |
| Snacks.terminal    | Terminais                        |
| Snacks.notifier    | Notificações                     |
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
| grug-far           | Search & replace no projeto      |
| oil.nvim           | Editar diretórios como buffer    |
| mini.surround      | Surround (aspas, parênteses)     |

---

## Testes da configuração

A config tem uma suíte de testes em `tests/` (specs com plenary/busted + smoke de boot):

```bash
make test         # sintaxe + specs + smoke (boot da config completa)
make test-unit    # só sintaxe + specs (não instala todos os plugins)
make test-smoke   # só o smoke de boot
make test-go      # integração real Go (toolchain e ferramentas instaladas)
make test-rust    # integração real Rust (toolchain e ferramentas instaladas)
make syntax       # só validação de sintaxe Lua
```

- **Specs** (`tests/config_spec.lua`): invariantes — Ruff no conform, picker = Telescope, sem colisão de keymaps,
  plugins presentes, APIs não-deprecadas.
- **Scripts** (`tests/scripts_spec.lua` e `tests/scripts.sh`): backup/restauração em diretórios temporários,
  preservação do lockfile, caminhos com espaços e propagação de falhas do runner e do Ruff.
- **Smoke** (`tests/smoke.lua`): boota a config real e valida o estado em runtime. Em `tests/smoke/`, pressiona os
  atalhos de terminal num projeto temporário (posição, comando e cwd) e simula o hot reload do tema; o que depende de
  ferramenta ausente (lazygit, Docker Compose, symlink do Omarchy) aparece como `[SKIP]`. Verifica também alternância
  claro/escuro, preservação de splits/buffers, exclusão com confirmação e diagnóstico com Ruff real.
  O runner isola cache/estado em diretórios temporários, soma todas as suítes e limita o tempo das integrações.
- **CI**: `.github/workflows/test.yml` roda `make test-ci` (sintaxe + specs) e, em job separado, o smoke com a config
  instalada (`install.sh` + `:Lazy! restore`) a cada push na `main` e em todo PR.

### Integração Go (execução separada)

O teste `tests/go_smoke.lua` não faz parte de `make test` nem dos jobs atuais de CI. Com Go, as ferramentas do Mason e o
parser Go já instalados, execute da raiz desta configuração:

```bash
make test-go
```

Ele cria um módulo temporário e verifica o vínculo do `gopls` com o buffer e uma resposta de hover, formatação com
`goimports`/`gofumpt`, execução de testes pelo Neotest, `go test -race` e uma sessão real de Delve via DAP. O teste
exige suporte ao detector de condições de corrida e à depuração no ambiente onde for executado.

### Integração Rust (execução separada)

Com os componentes Rust, plugins, parser Rust e CodeLLDB instalados, execute da raiz desta configuração:

```bash
make test-rust
```

O teste usa um projeto Cargo temporário sem dependências externas e verifica um único rust-analyzer, hover, rustfmt,
`cargo clippy`, `cargo test`, execução pelo Neotest e uma sessão real do CodeLLDB via DAP. O projeto temporário é
removido ao terminar. Esse teste é independente de `make test` e dos jobs atuais de CI.

---

## Comandos Úteis

```vim
" Gerenciamento
:Lazy                  " Gerenciar plugins
:Mason                 " Gerenciar ferramentas LSP
:LspInfo               " Info sobre LSPs ativos
:ConformInfo           " Formatadores disponíveis para o buffer
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
:lua Snacks.terminal()  " Toggle terminal

" Diagnósticos
:Trouble               " Lista de problemas
```

---

## Customização

### Mudar Keybindings

Edite: `~/.config/nvim/lua/config/keymaps.lua`

### Mudar Opções

Edite: `~/.config/nvim/lua/config/options.lua`

### Adicionar Plugins

Crie: `~/.config/nvim/lua/plugins/meu-plugin.lua`

### Configurar conexões SQL

`lua/plugins/sql-tools.lua` configura o dialeto do formatador e a interface Dadbod. Declare as conexões do projeto a
partir de variáveis carregadas pelo Infisical, conforme o exemplo comentado no arquivo; mantenha credenciais fora do
repositório.

---

## Resolução de problemas

### Plugins não carregam

Abra `:Lazy` e confira qual plugin falhou. Escolha a ação conforme o objetivo:

| Comando         | Uso                                                                 |
| --------------- | ------------------------------------------------------------------- |
| `:Lazy install` | Instalar plugins declarados que ainda estejam ausentes              |
| `:Lazy restore` | Restaurar plugins para os commits registrados em `lazy-lock.json`   |
| `:Lazy clean`   | Remover plugins instalados que já não fazem parte da configuração   |
| `:Lazy sync`    | Instalar, limpar e atualizar plugins; pode alterar `lazy-lock.json` |

Para recuperar as versões fixadas, prefira `:Lazy restore`. Use `:Lazy sync` quando quiser atualizar a configuração,
guardando suas alterações e revisando o novo lockfile após a atualização.

### LSP não funciona

```vim
:LspInfo
:LspRestart
:Mason
```

Confira se o servidor esperado aparece em `:LspInfo` e se a instalação terminou no Mason. Para Go e Rust, confirme
também a toolchain no PATH e os requisitos dos respectivos perfis em [INSTALL.md](INSTALL.md).

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

## Recursos Externos

### Documentação Oficial

- [Neovim](https://neovim.io/doc/)
- [LazyVim](https://www.lazyvim.org/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)

### Aprender Vim

- Tutorial integrado em uma sessão limpa: `nvim --clean`, seguido de `:Tutor`. Nesta configuração, o plugin `tutor`
  está desabilitado para reduzir o carregamento inicial
- [OpenVim Tutorial](https://www.openvim.com/)
- [Vim Adventures](https://vim-adventures.com/)

### Plugins

- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Neogit](https://github.com/NeogitOrg/neogit)
- [Neotest](https://github.com/nvim-neotest/neotest)
- [Mason](https://github.com/mason-org/mason.nvim)

---

## Fluxo de trabalho

### 1. Abrir Projeto

```bash
cd ~/workspace/meu-projeto
nvim .
```

### 2. Editar e validar

Busque arquivos e texto com Telescope, confira os diagnósticos e salve para aplicar a formatação. Execute os testes
pelo Neotest e revise o diff no Neogit ou Diffview antes do commit. Os atalhos completos, incluindo Docker e terminais,
estão em [KEYBINDINGS.md](KEYBINDINGS.md).

Para descobrir comandos durante o trabalho, use `<Space>` (which-key), `<Space>sL` (Legendary), `<Space>fk`
(mapeamentos no Telescope) e `:help <termo>`.

---

## Suporte

Se encontrar problemas:

1. Verifique `:checkhealth`
2. Leia [KEYBINDINGS.md](./KEYBINDINGS.md)
3. Leia [CHANGELOG.md](./CHANGELOG.md)
4. Consulte `:help <termo>`
5. [LazyVim Issues](https://github.com/LazyVim/LazyVim/issues)

---

## Versão

**2.3 - Claude Code, Jupyter & Temas**  
Data: 09/08/2026

> Destaques 2.3: claudecode.nvim integrado (`<Space>a*`), suporte a Jupyter notebooks (jupytext + molten, `<Space>m*`),
> uv.nvim para projetos Python (`<Space>U`), themery.nvim com novos colorschemes (Kanagawa, Gruvbox, Nightfox) e
> correção de colisões de keymap em `<Space>u*`.
>
> **Não lançado:** integração com o tema do Omarchy (hot reload), compatibilidade com Neovim 0.12 e
> `:checkhealth nvim_config`, extra oficial de DAP do LazyVim, which-key restaurado com Legendary como paleta
> complementar (`<Space>sL`), quicknote (`<Space>N*`), LSP auto-instalado por filetype, templates Django no Overseer e
> perfis Go e Rust com LSP, formatação, Neotest e depuração; melhorias em buffers, temas, backups e validação da
> configuração. Ver [CHANGELOG.md](./CHANGELOG.md) para detalhes.

---

Feito com ❤️ usando **LazyVim**

🚀 **Happy Coding!**
