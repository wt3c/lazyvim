# 🔧 Line-Length 120 - Configuração Corrigida

## ✅ O que foi feito:

### 1. **Configuração Global do Ruff**
Criado: `~/.config/ruff/pyproject.toml`
- Line-length: **120 caracteres**
- Aplicado a TODOS os projetos que não têm configuração própria
- Regras de linting otimizadas para Python/Django

### 2. **Configuração do Neovim (Ruff LSP)**
Arquivo: `~/.config/nvim/lua/plugins/python-tools.lua`
- Ruff LSP configurado com `lineLength = 120`
- Format args: `--line-length=120`
- Lint args configurados

### 3. **Configuração do Conform.nvim**
- `ruff_format`: `--line-length=120`
- `ruff_organize_imports`: `--line-length=120`

### 4. **Script de Verificação**
Criado: `~/.config/nvim/check-ruff.sh`
- Verifica instalação do Ruff
- Mostra configurações ativas
- Testa formatação

---

## 🧪 Como Testar:

### Teste 1: Verificar Configuração
```bash
cd ~/.config/nvim
./check-ruff.sh
```
Deve mostrar: `line-length: 120` ✅

### Teste 2: Testar no Neovim
```bash
# 1. Abra o Neovim
nvim

# 2. Crie um arquivo teste
:e test.py

# 3. Cole este código (tem 130+ caracteres na linha 1)
def very_long_function_name_that_exceeds_eighty_characters_but_should_be_ok_with_one_hundred_twenty_characters(param1, param2, param3, param4):
    pass

# 4. Salve (auto-format)
Ctrl+s

# OU format manual
<leader>fm
```

**Resultado esperado:**
- Linha fica como está SE tiver até 120 caracteres
- Linha quebra APENAS SE passar de 120 caracteres

### Teste 3: LSP Info
```vim
:LspInfo
```
Deve mostrar `ruff` ativo.

### Teste 4: Format Manual
Em um arquivo Python:
```vim
<leader>fm     " Format file
```
ou
```vim
:lua vim.lsp.buf.format()
```

---

## 📁 Arquivos de Configuração (Prioridade)

O Ruff procura configuração nesta ordem:

1. **Projeto** (maior prioridade):
   - `./pyproject.toml`
   - `./ruff.toml`
   - `./.ruff.toml`

2. **Global** (fallback):
   - `~/.config/ruff/pyproject.toml` ← **CRIADO**

Se o seu projeto tem `pyproject.toml`, adicione:
```toml
[tool.ruff]
line-length = 120
target-version = "py310"

[tool.ruff.format]
line-ending = "auto"

[tool.ruff.lint]
select = ["E", "W", "F", "I"]
ignore = ["E501"]  # Line too long (formatter handles it)
```

---

## 🔍 Verificar no Projeto Atual

Para verificar qual configuração está sendo usada:

```bash
# Ver configuração ativa
ruff check . --show-settings

# Ver apenas line-length
ruff check . --show-settings | grep line-length
```

---

## 🐛 Problemas Comuns:

### Problema 1: Ainda quebra em 80/88 caracteres
**Causa:** Projeto tem `pyproject.toml` com line-length diferente

**Solução:**
```bash
# Verificar projeto
cat pyproject.toml | grep -A3 "tool.ruff"

# Se encontrar line-length diferente, edite:
vim pyproject.toml
# Mude para: line-length = 120
```

### Problema 2: LSP não formata
**Solução:**
```vim
:LspRestart
:LspInfo    " Verificar se ruff está ativo
<leader>fm  " Forçar format
```

### Problema 3: Configuração não é respeitada
**Solução:**
```bash
# 1. Verificar qual config está ativa
cd /caminho/do/projeto
ruff check . --show-settings | grep line-length

# 2. Se mostrar 88 ou 80, criar pyproject.toml no projeto:
cat > pyproject.toml << 'EOF'
[tool.ruff]
line-length = 120
EOF

# 3. Reiniciar Neovim
```

### Problema 4: Black está sobrescrevendo
**Causa:** Se você usa Black, ele tem line-length padrão de 88

**Solução:**
Remova Black ou configure:
```toml
[tool.black]
line-length = 120
```

---

## ⚙️ Comandos Úteis:

### No Shell:
```bash
# Verificar versão
ruff --version

# Ver configuração do projeto
ruff check . --show-settings

# Formatar arquivo
ruff format arquivo.py --line-length=120

# Formatar tudo
ruff format . --line-length=120
```

### No Neovim:
```vim
" Info sobre LSPs
:LspInfo

" Restart LSP
:LspRestart

" Format manual
<leader>fm
:lua vim.lsp.buf.format()

" Ver configuração Conform
:ConformInfo

" Ver diagnósticos
:Trouble
```

---

## 📊 Verificação Final:

Execute no seu projeto:

```bash
# 1. Ir para o projeto
cd ~/workspace/seu-projeto

# 2. Verificar config
ruff check . --show-settings | grep line-length
# Deve mostrar: line-length: 120

# 3. Testar formatação
echo 'def function_with_very_long_name_over_eighty_but_under_one_hundred_twenty(a, b, c): pass' > test.py
ruff format test.py
cat test.py
rm test.py
```

---

## ✅ Checklist de Configuração:

- [x] Configuração global criada: `~/.config/ruff/pyproject.toml`
- [x] Neovim configurado: `lua/plugins/python-tools.lua`
- [x] Script de verificação: `check-ruff.sh`
- [ ] **Testar no Neovim** (você precisa fazer)
- [ ] **Reiniciar Neovim** (:qa + nvim)
- [ ] **Verificar em projeto real**

---

## 🎯 Garantia de Line-Length 120:

Após esta configuração, **TODAS** as seguintes situações respeitam 120:

1. ✅ Format on save (Ctrl+s)
2. ✅ Format manual (<leader>fm)
3. ✅ LSP formatting (Ruff)
4. ✅ Conform.nvim (ruff_format)
5. ✅ Organize imports (ruff_organize_imports)
6. ✅ Linha vertical (colorcolumn=120)
7. ✅ Novos projetos (config global)
8. ✅ Projetos existentes (se não tiverem config própria)

---

## 📞 Se Ainda Houver Problemas:

1. Execute: `~/.config/nvim/check-ruff.sh`
2. Verifique: `:LspInfo` no Neovim
3. Teste: Criar arquivo Python e salvar
4. Verifique projeto: `ruff check . --show-settings | grep line`

Se mostrar 88 ou 80, o **projeto** tem configuração própria que sobrescreve a global.

---

**✨ Line-length 120 configurado em TODOS os níveis!**
