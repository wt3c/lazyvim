# 📦 Guia de Backup e Restauração

## 🎯 Problema

Remover `~/.config/nvim` apaga toda a configuração customizada. Esta config é um repositório Git
(`git@github.com:wt3c/lazyvim.git`), então o GitHub já é o backup principal — os scripts locais cobrem o que
ainda não foi commitado e o que fica fora do repositório.

## ✅ Solução

Existem **2 formas de backup** e **1 de reinstalação**:

1. **Git** (Recomendado) — versionamento completo, com push para o GitHub
2. **Backup em arquivo** — snapshot `.tar.gz` local via `backup-config.sh`
3. **Reinstalação** — clonar o repositório e rodar `install.sh`

---

## 📁 O Que Precisa de Backup?

### 🟢 Versionado no Git (recuperável com `git clone`)

```text
~/.config/nvim/
├── init.lua, lazyvim.json, lazy-lock.json   ⭐ Entry point, extras e versões fixadas dos plugins
├── lua/config/                              ⭐ options, keymaps, autocmds, lsp_autoinstall
├── lua/nvim_config/health.lua               ⭐ :checkhealth nvim_config
├── lua/plugins/                             ⭐ Todas as specs de plugins
├── ruff-config/pyproject.toml               ⭐ Fonte do Ruff global (copiada pelo install.sh)
├── snippets/, spell/*.add                   ⭐ Snippets e palavras customizadas do dicionário
├── tests/, Makefile, .github/               Suíte de testes e CI
├── install.sh, quick-install.sh, uninstall.sh
├── backup-config.sh, restore-config.sh, check-ruff.sh
└── *.md                                     Documentação
```

> `lazy-lock.json` aparece no `.gitignore`, mas **está versionado** — como já é rastreado, a regra não se aplica
> e as atualizações dele continuam sendo commitadas normalmente.

### 🟡 Fora do Git (recriado ou apontado para fora)

| Caminho | O que é | Como recuperar |
| --- | --- | --- |
| `~/.config/ruff/pyproject.toml` | Config global do Ruff (line-length 120) | `install.sh` recria a partir de `ruff-config/` |
| `~/.local/share/nvim/venvs/jupyter` | Provider Python/Jupyter isolado + stubs Django | `install.sh` recria com `uv` |
| `~/.local/share/nvim/` (lazy, mason) | Plugins e ferramentas baixados | `:Lazy restore` / `:Mason` baixam de novo |
| `lua/plugins/theme.lua` | **Symlink** para o tema atual do Omarchy | Recriado pelo Omarchy; fora dele, vira arquivo normal |
| `.quicknote/` | Notas do quicknote (vazio por padrão) | Só volta se tiver sido commitado ou estiver no `.tar.gz` |

---

## 🔄 Método 1: Git (RECOMENDADO)

### Fazer Backup

Fluxo manual (commits pequenos e descritivos):

```bash
cd ~/.config/nvim
git add <arquivos>
git commit -m "feat(plugins): descrição da mudança"
git push
```

Ou via script:

```bash
cd ~/.config/nvim
./backup-config.sh
```

O script irá:

1. ✅ Rodar `git add -A` e commitar **tudo** que estiver modificado ou não rastreado (pede a mensagem;
   Enter usa `Update config - <data>`)
2. ✅ Perguntar se quer fazer push
3. ✅ Criar também o backup em arquivo `.tar.gz` (Método 2)

> ⚠️ Como o script usa `git add -A`, confira `git status` antes — arquivos temporários não ignorados entram no
> commit.

### Restaurar do Git

```bash
cd ~/.config/nvim
git pull
```

Para descartar mudanças locais e voltar ao estado do GitHub (irreversível para o que não foi commitado):

```bash
git reset --hard origin/main
```

Depois, no Neovim, `:Lazy restore` volta os plugins para as versões do `lazy-lock.json`.

---

## 📦 Método 2: Backup em Arquivo

### Fazer Backup

```bash
cd ~/.config/nvim
./backup-config.sh
```

- Salvo em `~/.config/nvim-backup/nvim-backup-AAAAMMDD_HHMMSS.tar.gz`
- Inclui `~/.config/nvim` **e** `~/.config/ruff`
- **Exclui** `.git`, `.cache` e `lazy-lock.json` — o snapshot não guarda as versões fixadas dos plugins
- Mantém só os **5** backups mais recentes (os antigos são apagados)

### Restaurar

```bash
cd ~/.config/nvim
./restore-config.sh
# Escolha o backup da lista e confirme com "s"
```

Ou especificar arquivo:

```bash
./restore-config.sh ~/.config/nvim-backup/nvim-backup-20260520_220000.tar.gz
```

O que o restore faz:

1. Salva a config atual em `~/.config/nvim-backup/nvim-before-restore-AAAAMMDD_HHMMSS.tar.gz`
2. Extrai o backup **por cima** de `~/.config` — sobrescreve os arquivos do backup, mas **não remove** arquivos
   que existam só na config atual

> O snapshot `nvim-before-restore-*` não aparece no menu do `restore-config.sh` nem entra na limpeza dos 5
> mais recentes. Para voltar a ele, passe o caminho explicitamente; para liberar espaço, apague manualmente.

Como o `.tar.gz` não traz `lazy-lock.json`, após restaurar use `:Lazy sync` (versões mais recentes) ou
recupere o lockfile do Git (`git checkout lazy-lock.json`) antes de `:Lazy restore`.

---

## 🚀 Método 3: Reinstalação do Zero

### Opção A: Clonar do GitHub (padrão)

```bash
# 1. Guardar a config existente (se houver)
mv ~/.config/nvim ~/.config/nvim.old

# 2. Clonar e instalar
git clone git@github.com:wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh

# 3. Abrir o Neovim (Lazy e Mason instalam tudo na primeira abertura)
nvim
```

O `install.sh` valida as dependências (Neovim 0.12+ etc.), recria `~/.config/ruff/pyproject.toml` e o
provider Python/Jupyter. Detalhes em [INSTALL.md](INSTALL.md).

> `quick-install.sh` existe só por compatibilidade: ele apenas executa o `install.sh`. **Não** é preciso clonar
> o starter do LazyVim antes — o repositório já é a config completa.

### Opção B: Restaurar de Backup em Arquivo

Útil quando há mudanças que nunca foram para o Git:

```bash
# 1. Clonar a base (traz scripts e lazy-lock.json)
git clone git@github.com:wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim

# 2. Aplicar o snapshot por cima
./restore-config.sh ~/.config/nvim-backup/nvim-backup-AAAAMMDD_HHMMSS.tar.gz

# 3. Recriar provider Python/Jupyter
./install.sh
```

### Opção C: Backup do `uninstall.sh`

Se a config foi removida com `./uninstall.sh` e você aceitou o backup, ele está em
`~/nvim-backup-AAAAMMDD-HHMMSS/` como **cópia de diretórios** (não `.tar.gz`, portanto fora do menu do
`restore-config.sh`):

```bash
cp -r ~/nvim-backup-AAAAMMDD-HHMMSS/config-nvim ~/.config/nvim
cp -r ~/nvim-backup-AAAAMMDD-HHMMSS/config-ruff ~/.config/ruff   # se existir
```

Esse backup também guarda `share-nvim`, `state-nvim` e `cache-nvim` (plugins, Mason, histórico), que podem ser
copiados de volta para `~/.local/share/nvim`, `~/.local/state/nvim` e `~/.cache/nvim` para evitar novo download.

---

## 📋 Checklist Pós-Restauração

```bash
# 1. Arquivos de plugins presentes
ls ~/.config/nvim/lua/plugins/

# 2. Ruff global com line-length 120
grep line-length ~/.config/ruff/pyproject.toml

# 3. Diagnóstico do Ruff
cd ~/.config/nvim && ./check-ruff.sh

# 4. Suíte de testes da config (sintaxe + specs)
make test-unit
```

Dentro do Neovim:

```vim
:Lazy restore
:Mason
:checkhealth nvim_config vim.provider mason
:LspInfo
```

---

## 🔐 Estratégia de Backup Recomendada

1. **Git + push a cada mudança relevante** — é o backup real e permite voltar a qualquer versão
2. **`./backup-config.sh` antes de mudanças grandes** (atualizar LazyVim, testar plugins, reorganizar specs)
3. **Copiar `~/.config/nvim-backup/` para fora da máquina** (nuvem/disco externo) se os snapshots importarem —
   eles ficam no mesmo disco da config

---

## 🖥️ Usar em Outra Máquina

```bash
# Guardar config existente (se houver)
mv ~/.config/nvim ~/.config/nvim.bak

git clone git@github.com:wt3c/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
nvim
```

Sem Omarchy, `lua/plugins/theme.lua` fica como symlink quebrado — substitua por um arquivo normal com o
colorscheme desejado (ver README, seção de temas).

---

## 📊 Resumo dos Scripts

| Script | Função | Quando Usar |
| --- | --- | --- |
| `backup-config.sh` | `git add -A` + commit (+ push opcional) e snapshot `.tar.gz` | Antes de mudanças grandes |
| `restore-config.sh` | Extrai um `.tar.gz` por cima de `~/.config` (salva o estado atual antes) | Voltar a um snapshot |
| `install.sh` | Valida dependências, recria Ruff global e provider Python/Jupyter | Máquina nova / reinstalação |
| `quick-install.sh` | Atalho de compatibilidade para `install.sh` | Mesmo que `install.sh` |
| `uninstall.sh` | Remove config e dados do Neovim (backup opcional em `~/nvim-backup-*`) | Remoção completa |
| `check-ruff.sh` | Mostra configs do Ruff e testa line-length 120 | Após instalar/restaurar |

---

## 🎯 Quick Reference

```bash
# Backup (commit + snapshot)
./backup-config.sh

# Restaurar snapshot (menu)
./restore-config.sh

# Restaurar snapshot específico
./restore-config.sh ~/.config/nvim-backup/nvim-backup-AAAAMMDD_HHMMSS.tar.gz

# Reinstalar do zero
git clone git@github.com:wt3c/lazyvim.git ~/.config/nvim && ~/.config/nvim/install.sh

# Ver snapshots
ls -lh ~/.config/nvim-backup/
```
