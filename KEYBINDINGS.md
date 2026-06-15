# 🚀 LazyVim - Guia de Keybindings Modernos

## 📝 Legenda

- `<leader>` = `Space` (tecla líder)
- `<C-x>` = Ctrl + x
- `<A-x>` = Alt + x
- `<S-x>` = Shift + x

---

## 🎯 BÁSICO E ESSENCIAL

### Comentários

- `Ctrl+/` - Comentar/descomentar linha (Normal/Visual)
- `Ctrl+_` - Alternativa (alguns terminais)

### Salvar e Sair

- `Ctrl+s` - Salvar arquivo
- `<leader>qq` - Sair de tudo
- `<leader>qQ` - Sair de tudo (forçado)

### Edição Rápida

- `jk` ou `kj` - Sair do modo Insert
- `<` / `>` (Visual) - Indentar (mantém seleção)
- `Alt+j` / `Alt+k` - Mover linha/seleção para baixo/cima
- `v` depois `p` - Colar sem sobrescrever register
- `Ctrl+a` - Selecionar tudo
- `<Esc>` - Limpar highlight de busca

---

## 🪟 GERENCIAMENTO DE JANELAS

### Dividir Janelas

- `<leader>wv` - Dividir verticalmente
- `<leader>wh` - Dividir horizontalmente
- `<leader>we` - Igualar tamanho das divisões
- `<leader>wx` - Fechar janela atual

### Navegar Entre Janelas

- `Ctrl+h` - Ir para janela esquerda
- `Ctrl+j` - Ir para janela inferior
- `Ctrl+k` - Ir para janela superior
- `Ctrl+l` - Ir para janela direita

### Redimensionar Janelas

- `Ctrl+↑` - Aumentar altura
- `Ctrl+↓` - Diminuir altura
- `Ctrl+←` - Diminuir largura
- `Ctrl+→` - Aumentar largura

---

## 📄 GERENCIAMENTO DE BUFFERS

### Navegar

- `Shift+h` ou `[b` - Buffer anterior
- `Shift+l` ou `]b` - Próximo buffer
- `<leader><space>` - Listar buffers (Telescope)

### Fechar

- `<leader>bd` - Deletar buffer atual
- `<leader>bD` - Deletar todos exceto atual

---

## 🔍 TELESCOPE (BUSCA)

> **Picker unificado:** o Telescope é usado em tudo, inclusive nos internos do LazyVim (`gr`, `gd`, referências). Além
> dos atalhos abaixo, o LazyVim também expõe o esquema `<leader>s*` (ex.: `<leader>sg` grep, `<leader>sk` keymaps,
> `<leader>sw` palavra) — descubra com `<Space>` + Which-key.

### Arquivos e Navegação

- `<leader>ff` - Buscar arquivos
- `<leader>fr` - Arquivos recentes
- `<leader>fg` - Busca global (live grep)
- `<leader>fw` - Buscar palavra sob cursor
- `<leader>fh` - Buscar ajuda (help tags)
- `<leader>fk` - Buscar keybindings
- `<leader>fc` - Buscar comandos

### Símbolos e Código

- `<leader>fs` - Símbolos do documento
- `<leader>fS` - Símbolos do workspace
- `<leader>fd` - Diagnósticos

### Git (Telescope)

- `<leader>fgc` - Commits
- `<leader>fgb` - Branches
- `<leader>fgs` - Status
- `<leader>fgh` - Stash

---

## 🐍 PYTHON / DJANGO

### Python Básico

- `<leader>pr` - Python REPL
- `<leader>pf` - Executar arquivo Python
- `<leader>cv` - Selecionar virtualenv (detecta uv, Poetry, venv, etc)

### Ruff (lint + format + imports)

- `<leader>cR` - Ruff: Fix All (aplica todas as correções automáticas)
- `<leader>co` - Ruff: Organize Imports
- Formatação e organização de imports rodam automaticamente no salvar (conform)

### Django Management

- `<leader>pR` - `runserver`
- `<leader>pM` - `makemigrations`
- `<leader>pm` - `migrate`
- `<leader>ps` - `shell`
- `<leader>pt` - `test`
- `<leader>pc` - `collectstatic`
- `<leader>pC` - `createsuperuser`

### Debug (DAP)

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dr` - Abrir REPL
- `<leader>dl` - Debug test method
- `<leader>dj` - Launch Django server (debug)

---

## 🐳 DOCKER / DOCKER COMPOSE

### Docker Compose

- `<leader>Du` - `docker-compose up -d`
- `<leader>Dd` - `docker-compose down`
- `<leader>Dr` - `docker-compose restart`
- `<leader>Dl` - `docker-compose logs -f` (terminal)
- `<leader>Db` - `docker-compose build`
- `<leader>DB` - `docker-compose build --no-cache`

### Docker Direto

- `<leader>Dp` - `docker ps` (listar containers)
- `<leader>Di` - `docker images` (listar imagens)
- `<leader>Ds` - `docker system prune -f`
- `<leader>De` - `docker exec -it` (entrar em container)

---

## 🧪 TESTES (NEOTEST)

### Executar Testes

- `<leader>tt` - Testar função/método sob cursor
- `<leader>tf` - Testar arquivo atual
- `<leader>tT` - Testar tudo (projeto)
- `<leader>td` - Debug teste sob cursor

### UI de Testes

- `<leader>ts` - Toggle summary (painel)
- `<leader>to` - Mostrar output
- `<leader>tO` - Toggle output panel
- `<leader>tS` - Parar testes
- `<leader>tw` - Toggle watch mode

---

## ⚙️ TASK RUNNER (OVERSEER)

- `<leader>rr` - Executar task
- `<leader>rt` - Toggle task list
- `<leader>ri` - Info sobre tasks
- `<leader>ra` - Ações de task

---

## 🎯 HARPOON (NAVEGAÇÃO RÁPIDA)

Marque arquivos e salte entre eles instantaneamente.

- `<leader>ha` - Adicionar arquivo atual à lista
- `<leader>hh` - Abrir menu rápido (quick menu)
- `<leader>hp` / `<leader>hn` - Arquivo anterior / próximo
- `<leader>h1`..`<leader>h4` - Saltar direto para o arquivo 1–4

---

## 🔁 SEARCH & REPLACE NO PROJETO (SPECTRE)

- `<leader>sr` - Abrir Spectre (substituição no projeto, com preview/regex)
- `<leader>sr` (Visual) - Substituir a palavra selecionada

---

## 📂 OIL (EDITAR DIRETÓRIO COMO BUFFER)

- `-` - Abrir o diretório pai como buffer (criar/renomear/mover arquivos)
- `q` (dentro do Oil) - Fechar

> O explorer padrão (neo-tree) continua em `<leader>e`.

---

## 💻 TERMINAL (TOGGLETERM)

> Prefixo **`<leader>T`** (maiúsculo) para não colidir com os testes em `<leader>t`.

### Abrir/Fechar

- `Ctrl+\` - Toggle terminal
- `<leader>Tf` - Terminal flutuante
- `<leader>Th` - Terminal horizontal
- `<leader>Tv` - Terminal vertical

### Terminais Especiais

- `<leader>Tp` - Python REPL (terminal)
- `<leader>Tl` - Docker logs (terminal)
- `<leader>Tg` - Lazygit (terminal)

---

## 🌿 GIT (MODERNO)

### Neogit (Interface Git)

- `<leader>gg` - Abrir Neogit
- `<leader>gc` - Commit
- `<leader>gp` - Push
- `<leader>gP` - Pull

### Diffview

- `<leader>gd` - Abrir diff
- `<leader>gD` - Fechar diff
- `<leader>gh` - Histórico do arquivo atual
- `<leader>gH` - Histórico do projeto

### GitSigns (Hunks)

- `]h` / `[h` - Próximo/anterior hunk
- `<leader>gs` - Stage/unstage hunk (alterna)
- `<leader>gr` - Reset hunk
- `<leader>gS` - Stage buffer inteiro
- `<leader>gR` - Reset buffer inteiro
- `<leader>gv` - Preview hunk
- `<leader>gb` - Blame line (full)
- `<leader>gB` - Toggle blame inline

---

## 🔧 LSP (LANGUAGE SERVER)

> Fornecidos pelo LazyVim no `LspAttach` (buffer-local, ativos só quando há LSP), usando o Telescope como picker para
> definições/referências.

### Navegação

- `gd` - Go to Definition (Telescope)
- `gD` - Go to Declaration
- `gI` - Go to Implementation
- `gr` - Go to References (Telescope)
- `gy` - Go to Type Definition
- `K` - Hover documentation

### Ações

- `<leader>ca` - Code action
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format file (conform → Ruff em Python)
- `<leader>fm` - Format file (atalho alternativo)

---

## ⌨️ AUTOCOMPLETE (BLINK.CMP)

No modo Insert, enquanto o menu de sugestões está aberto:

- `<C-Space>` - Abrir/forçar o menu de completion
- `<Tab>` / `<S-Tab>` - Próxima / anterior sugestão (e pula snippets)
- `<CR>` ou `<C-y>` - Confirmar sugestão
- `<C-e>` - Fechar o menu
- `<C-b>` / `<C-f>` - Rolar a janela de documentação
- Ghost text inline mostra a sugestão atual; docs e assinatura aparecem automaticamente

---

## 🚨 DIAGNÓSTICOS E ERROS

### Navegação

- `]d` / `[d` - Próximo/anterior diagnóstico
- `]e` / `[e` - Próximo/anterior erro
- `<leader>cd` - Mostrar diagnóstico da linha

### Trouble (Lista)

- `<leader>xx` - Diagnósticos (projeto)
- `<leader>xX` - Diagnósticos (buffer)
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list
- `<leader>xs` - Símbolos
- `<leader>xl` - LSP definitions/references

---

## 📁 ARQUIVOS

### Operações Básicas

- `<leader>fn` - Novo arquivo
- `<leader>fR` - Renomear arquivo
- `<leader>fD` - Deletar arquivo

---

## ⚡ TOGGLES E OPÇÕES

- `<leader>uw` - Toggle line wrap
- `<leader>us` - Toggle spell check
- `<leader>ul` - Toggle list chars
- `<leader>ur` - Toggle relative numbers
- `<leader>ut` - Toggle Treesitter Context (cabeçalho fixo de classe/função)
- `<leader>un` - Dismiss notifications

---

## 🎨 INTERFACE

### Noice (Messages)

- `<leader>sn` - Ver todas mensagens (Telescope)
- `<leader>sN` - Última mensagem
- `<leader>sh` - Histórico

### Illuminate (Highlight)

- `]]` - Próxima referência
- `[[` - Referência anterior

---

## 🔑 DICAS RÁPIDAS

### Modos Vim

- `i` - Insert mode
- `v` - Visual mode
- `V` - Visual line mode
- `Ctrl+v` - Visual block mode
- `:` - Command mode

### Movimentação Rápida

- `gg` - Topo do arquivo
- `G` - Final do arquivo
- `0` - Início da linha
- `$` - Fim da linha
- `w` - Próxima palavra
- `b` - Palavra anterior
- `{` / `}` - Parágrafo anterior/próximo

### Busca

- `/` - Buscar para frente
- `?` - Buscar para trás
- `n` - Próximo resultado
- `N` - Resultado anterior
- `*` - Buscar palavra sob cursor

---

## 🎓 COMANDOS ÚTEIS

### Ex Commands (modo `:`)

```vim
:Mason                  " Gerenciar LSPs/ferramentas
:Lazy                   " Gerenciar plugins
:LspInfo                " Info sobre LSPs ativos
:checkhealth            " Verificar saúde do Neovim
:so %                   " Source arquivo atual
:messages               " Ver mensagens antigas
:Telescope              " Abrir Telescope
:h <termo>              " Ajuda sobre termo
```

---

## 📚 RECURSOS

- LazyVim docs: <https://www.lazyvim.org/>
- Telescope: <https://github.com/nvim-telescope/telescope.nvim>
- Neogit: <https://github.com/NeogitOrg/neogit>
- Neotest: <https://github.com/nvim-neotest/neotest>
- Which-key: Aperte `<Space>` e espere para ver opções disponíveis!

---

**💡 Dica:** Use `<leader>fk` para buscar keybindings em tempo real no Telescope!

**🔥 Atalho Favorito:** `<Space>` + aguarde = Which-key mostra todas opções!
