# 🧪 Guia de Teste - Comentários

## ⚠️ Problema com Ctrl+/

Diferentes terminais enviam `Ctrl+/` de formas diferentes:
- Alguns terminais: `<C-/>`
- Maioria: `<C-_>` (Ctrl+underscore)
- Alguns: Não capturam

## ✅ Atalhos Configurados (Teste Todos)

Abra um arquivo Python/Lua e teste na ordem:

### 1️⃣ Ctrl+/ (Tente primeiro)
```
Modo Normal: Ctrl+/
Modo Visual: Selecione linhas + Ctrl+/
```

### 2️⃣ Ctrl+_ (Funciona na maioria)
```
Modo Normal: Ctrl+_ (Ctrl+Shift+- geralmente)
Modo Visual: Selecione linhas + Ctrl+_
```

### 3️⃣ Alt+/ (Sempre funciona)
```
Modo Normal: Alt+/
Modo Visual: Selecione linhas + Alt+/
```

### 4️⃣ Leader+/ (Sempre funciona)
```
Modo Normal: <Space>/
Modo Visual: Selecione linhas + <Space>/
```

### 5️⃣ gcc (Padrão LazyVim - SEMPRE funciona)
```
Modo Normal: gcc (aperte g-c-c rapidamente)
Modo Visual: Selecione linhas + gc
```

## 🧪 Como Testar

### Passo 1: Criar arquivo de teste
```bash
nvim test.py
```

### Passo 2: Adicionar código
```python
print("linha 1")
print("linha 2")
print("linha 3")
```

### Passo 3: Testar comentários

**Modo Normal (comentar linha atual):**
1. Coloque cursor na linha 1
2. Tente: `Ctrl+/`
3. Se não funcionar, tente: `Ctrl+_`
4. Se não funcionar, tente: `Alt+/`
5. Se não funcionar, tente: `<Space>/`
6. **Sempre funciona:** `gcc`

**Modo Visual (comentar várias linhas):**
1. Pressione `V` para modo visual
2. Selecione 2-3 linhas (setas ou j/k)
3. Tente: `Ctrl+/`
4. Se não funcionar, tente: `Ctrl+_`
5. Se não funcionar, tente: `Alt+/`
6. Se não funcionar, tente: `<Space>/`
7. **Sempre funciona:** `gc`

## 🔍 Descobrir Qual Tecla Seu Terminal Envia

Execute no Neovim:
```vim
:lua vim.keymap.set('n', '<C-/>', function() print('Ctrl+/ funciona!') end)
:lua vim.keymap.set('n', '<C-_>', function() print('Ctrl+_ funciona!') end)
```

Depois teste as teclas.

## 💡 Recomendações por Terminal

### Alacritty/Kitty/WezTerm
- ✅ `Ctrl+/` deve funcionar
- ✅ `Ctrl+_` funciona

### GNOME Terminal/Konsole
- ⚠️ `Ctrl+/` pode não funcionar
- ✅ `Ctrl+_` funciona (Ctrl+Shift+-)

### tmux/screen
- ⚠️ `Ctrl+/` geralmente não funciona
- ✅ `Alt+/` funciona sempre
- ✅ `<Space>/` funciona sempre

### SSH
- ✅ `Alt+/` recomendado
- ✅ `<Space>/` recomendado

## 🎯 Melhor Solução Para Você

Depois de testar, escolha o que funciona e use sempre:

### Se Ctrl+/ funcionar:
```
Normal: Ctrl+/
Visual: Selecione + Ctrl+/
```

### Se Ctrl+_ funcionar:
```
Normal: Ctrl+_ (Ctrl+Shift+-)
Visual: Selecione + Ctrl+_
```

### Nenhum dos dois funciona? Use Alt+/:
```
Normal: Alt+/
Visual: Selecione + Alt+/
```

### Prefere algo visual? Use Space+/:
```
Normal: <Space>/
Visual: Selecione + <Space>/
```

### Gosta do Vim padrão? Use gcc:
```
Normal: gcc
Visual: Selecione + gc
```

## 🔧 Configurar Seu Favorito

Se quiser usar outro atalho (exemplo: Ctrl+k):

Edite `~/.config/nvim/lua/plugins/comments.lua` e adicione:
```lua
keymap("n", "<C-k>", "gcc", { remap = true, desc = "Comment line" })
keymap("v", "<C-k>", "gc", { remap = true, desc = "Comment selection" })
```

## 📊 Tabela de Compatibilidade

| Atalho | Terminal Normal | tmux | SSH | Sempre Funciona |
|--------|----------------|------|-----|-----------------|
| Ctrl+/ | ⚠️ Depende | ❌ | ❌ | ❌ |
| Ctrl+_ | ✅ | ✅ | ✅ | ✅ |
| Alt+/ | ✅ | ✅ | ✅ | ✅ |
| Space+/ | ✅ | ✅ | ✅ | ✅ |
| gcc | ✅ | ✅ | ✅ | ✅ |

## ✅ Resumo

**Mais Confiáveis:**
1. `gcc` (Normal) / `gc` (Visual) - Padrão Vim
2. `Alt+/` - Funciona em qualquer terminal
3. `<Space>/` - Funciona sempre

**Tente Primeiro:**
1. `Ctrl+/` - Se funcionar, é o mais intuitivo
2. `Ctrl+_` (Ctrl+Shift+-) - Funciona na maioria

**Escolha um e acostume!** 🚀
