# Instalação — configuração LazyVim

Esta configuração usa Neovim 0.12+, LazyVim, Mason e ferramentas externas para Python/Django, Docker, SQL, Git e
Jupyter. O `install.sh` valida os pré-requisitos e prepara o provider Python, mas não instala pacotes do sistema com
privilégios administrativos.

## Dependências obrigatórias

| Executável | Motivo |
| --- | --- |
| `nvim` 0.12+ | APIs usadas pela configuração e pelos plugins atuais |
| `git` | Bootstrap e atualização do `lazy.nvim` e dos plugins |
| `curl` | Downloads do Mason, Blink e dicionário de português |
| `rg` | Busca de texto e arquivos pelo Telescope |
| `fd` | Busca padrão do `venv-selector.nvim`; sem ele, `:VenvSelect` não é registrado |
| `make`, `cc` | Compilação de extensões nativas e parsers |
| `tree-sitter` | Geração de parsers do Treesitter |
| `node`, `npm` | Instalação de servidores e ferramentas JavaScript pelo Mason |
| `python3` 3.10+ | Desenvolvimento Python e base do provider remoto |
| `uv` | Provider isolado de Python/Jupyter e gerenciamento de projetos Python |
| `unzip`, `tar`, `gzip` | Extração dos pacotes instalados pelo Mason |

O Neovim precisa ter sido compilado com LuaJIT. O `install.sh` verifica a versão e todos os executáveis acima antes
de modificar a configuração do Ruff ou o ambiente Jupyter.

## Dependências por funcionalidade

Ausências nesta seção não impedem o Neovim de iniciar; apenas desativam a integração correspondente.

| Funcionalidade | Dependência |
| --- | --- |
| Clipboard no Wayland | `wl-copy`, fornecido por `wl-clipboard` |
| Clipboard no X11 | `xclip` |
| Busca fuzzy no terminal | `fzf` |
| Interface Git em terminal | `lazygit` |
| Docker | Engine/CLI `docker` e plugin `docker compose`; `docker-compose` é aceito como fallback legado |
| Imagens e plots Jupyter | ImageMagick (`magick`) e Kitty ou terminal compatível com o protocolo gráfico Kitty |
| Claude Code | CLI `claude` instalado e autenticado |
| PostgreSQL via Dadbod | `psql` |
| SQLite via Dadbod | `sqlite3` |
| MySQL/MariaDB via Dadbod | `mysql` |
| Ícones completos | Nerd Font v3 selecionada no terminal |

O backend de imagens está configurado como `kitty` com processador `magick_cli`. Sem esses requisitos, células do
Molten ainda podem executar, mas imagens e plots inline não serão renderizados.

## Instalação no openSUSE Tumbleweed

Instale os requisitos obrigatórios:

```bash
sudo zypper install \
  neovim git curl ripgrep fd make gcc tree-sitter \
  nodejs24 npm24 python313 python313-uv unzip tar gzip
```

Os nomes versionados de Node.js e Python correspondem ao Tumbleweed atual. Se a distribuição já tiver avançado para
outra versão, escolha os pacotes que forneçam `node`, `npm`, `python3` e `uv` e confirme com `command -v`.

Instale apenas as integrações que pretende usar:

```bash
sudo zypper install fzf lazygit wl-clipboard xclip ImageMagick kitty sqlite3
```

Para Docker:

```bash
sudo zypper install docker docker-compose-switch
```

Para PostgreSQL, instale a versão do cliente compatível com seu ambiente, por exemplo `postgresql18`. Para
MySQL/MariaDB, instale o cliente correspondente ao servidor utilizado.

## Instalação da configuração

Se já existir uma configuração, mova-a para um backup antes de clonar:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone e execute o instalador:

```bash
git clone https://github.com/wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
```

O instalador:

1. valida Neovim e dependências externas obrigatórias;
2. informa quais integrações opcionais estão indisponíveis;
3. copia `ruff-config/pyproject.toml` para `~/.config/ruff/pyproject.toml`;
4. cria `~/.local/share/nvim/venvs/jupyter`;
5. instala nesse ambiente `pynvim`, `jupyter-client`, `jupytext` e `ipykernel`;
6. ajusta a permissão de execução dos scripts do repositório.

Abra o Neovim:

```bash
nvim
```

Na primeira execução, aguarde o Lazy instalar os plugins e o Mason instalar as ferramentas declaradas. Para forçar e
inspecionar o processo:

```vim
:Lazy sync
:Mason
```

## Ferramentas gerenciadas pelo Mason

Estas ferramentas não precisam de instalação global exclusiva para o Neovim:

- Python: Pyright, Ruff, Mypy e debugpy;
- SQL: sqlfluff;
- Markdown: Marksman, markdownlint-cli2 e markdown-toc;
- JSON/YAML: json-lsp e yaml-language-server;
- Shell: bash-language-server, shfmt e shellcheck;
- TOML: Taplo;
- Docker: dockerfile-language-server, docker-compose-language-service e Hadolint;
- formatação geral: StyLua e Prettier.

Extras do LazyVim também podem solicitar servidores das linguagens ativadas em `lazyvim.json`. O Mason usa `npm` e
outros gerenciadores externos conforme o pacote, por isso `node` e `npm` fazem parte dos requisitos obrigatórios desta
configuração.

## Ambientes Python de projetos

O provider isolado do Neovim não substitui o ambiente de cada projeto. Em um projeto com `uv`:

```bash
cd /caminho/do/projeto
uv sync
source .venv/bin/activate
nvim .
```

Dentro do Neovim, `<Space>cv` ou `:VenvSelect` seleciona o interpretador. Para executar notebooks com as dependências
do projeto, inclua um kernel no próprio ambiente quando necessário:

```bash
uv add --dev ipykernel
```

`django-stubs` e `djangorestframework-stubs` já são instalados globalmente pelo `install.sh` no provider isolado.
Como Pyright/Mypy resolvem tipos a partir do venv ativo do projeto (`:VenvSelect`), projetos Django que precisem dos
stubs durante o type checking devem declará-los também como dependência de desenvolvimento:

```bash
uv add --dev django-stubs djangorestframework-stubs
```

## Verificação

Execute no Neovim:

```vim
:checkhealth nvim_config vim.provider mason
:checkhealth jupytext
:Lazy health
```

Execute no shell para validar a configuração versionada:

```bash
cd ~/.config/nvim
make test
```

Critérios de sucesso:

- `:checkhealth nvim_config` não aponta ferramenta obrigatória ausente;
- `:checkhealth vim.provider` encontra o provider Python isolado;
- `:checkhealth jupytext` encontra o executável configurado;
- `:Mason` mostra as ferramentas declaradas como instaladas;
- `make test` conclui sintaxe, specs e smoke test sem falhas.

## Problemas comuns

### `VenvSelect` não é um comando válido

Confirme que `fd` está instalado e reinicie o Neovim:

```bash
fd --version
```

### Clipboard não copia para outros aplicativos

Instale `wl-clipboard` no Wayland ou `xclip` no X11 e reinicie o Neovim.

### Imagens do Jupyter não aparecem

Confirme `magick --version`, use Kitty ou terminal compatível e execute `:checkhealth` e `:ImageReport`.

### Ferramentas LSP não são instaladas

Confirme `node --version`, `npm --version`, `unzip -v`, `tar --version` e `gzip --version`. Depois abra `:Mason` e
execute novamente a instalação que falhou.

## Fontes dos requisitos

- [Mason — requisitos externos](https://github.com/mason-org/mason.nvim#requirements)
- [venv-selector.nvim — requisitos](https://github.com/linux-cultist/venv-selector.nvim#-requirements)
- [Molten — dependências Python](https://github.com/benlubas/molten-nvim#requirements)
- [image.nvim — backends e ImageMagick](https://github.com/3rd/image.nvim#dependencies)

## Atualização

```bash
cd ~/.config/nvim
git pull
./install.sh
nvim
```

Depois execute `:Lazy sync` se o lockfile ou as especificações de plugins tiverem mudado.

## Desinstalação

O script solicita confirmação e oferece backup antes de remover a configuração:

```bash
cd ~/.config/nvim
./uninstall.sh
```
