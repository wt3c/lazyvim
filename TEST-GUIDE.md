# 🧪 Guia de Testes - Ver Tudo Acontecendo

## 🎯 Objetivo

Ver o output dos testes **EM TEMPO REAL** enquanto rodam!

---

## ⚡ Atalhos Principais (USE ESTES!)

### 🔥 Recomendados (Mostram Output Automaticamente)

```vim
<leader>tr    " Run teste + abre output panel
<leader>tF    " Run arquivo + abre output panel
```

**Use estes para VER o que está acontecendo!**

### 📝 Atalhos Básicos

```vim
<leader>tt    " Rodar teste sob cursor
<leader>tf    " Rodar todos testes do arquivo
<leader>tT    " Rodar TODOS os testes do projeto
```

### 👀 Visualizar Resultados

```vim
<leader>to    " Mostrar output do último teste (popup)
<leader>tO    " Toggle output panel (janela na parte inferior)
<leader>ts    " Toggle summary (árvore de testes lateral)
```

### 🎮 Controle

```vim
<leader>tS    " Parar testes
<leader>tw    " Watch mode (roda automaticamente ao salvar)
<leader>td    " Debug teste (com breakpoints)
```

### 🧭 Navegação

```vim
]t            " Próximo teste com falha
[t            " Teste anterior com falha
```

---

## 🎬 Como Usar (Passo a Passo)

### Opção 1: Ver Output Automaticamente (RECOMENDADO)

```bash
# 1. Abra arquivo de teste
nvim test_exemplo.py

# 2. Rode teste COM output
<Space>tr     # Roda teste sob cursor + abre output

# 3. Veja o resultado na janela inferior! 🎉
```

### Opção 2: Abrir Output Manualmente

```bash
# 1. Abra arquivo de teste
nvim test_exemplo.py

# 2. Abra output panel primeiro
<Space>tO

# 3. Rode o teste
<Space>tt

# 4. Veja o resultado aparecer em tempo real!
```

### Opção 3: Summary Tree (Visão Geral)

```bash
# 1. Abra summary
<Space>ts

# 2. Rode testes
<Space>tf

# 3. Veja status visual:
#    ✓ = passou
#    ✗ = falhou
#    ⟳ = rodando
```

---

## 📊 Janelas Disponíveis

### 1. Output Panel (Janela Inferior)

**O que mostra:**
- Print statements
- Logs
- Tracebacks
- Assertions
- Output real do pytest

**Como abrir:**
```vim
<leader>tO    " Toggle (abre/fecha)
```

**Características:**
- Atualiza em tempo real
- Mostra output completo
- Scroll automático
- Syntax highlighting

### 2. Output Popup (Janela Flutuante)

**O que mostra:**
- Resultado específico de um teste
- Erro se falhou
- Output se passou

**Como abrir:**
```vim
<leader>to    " Abre popup do último teste
```

### 3. Summary Tree (Árvore Lateral)

**O que mostra:**
- Hierarquia de testes
- Status visual (✓ ✗ ⟳)
- Estrutura do projeto

**Como abrir:**
```vim
<leader>ts    " Toggle summary
```

**Navegação na Summary:**
- `<Enter>` - Expandir/colapsar
- `r` - Rodar teste
- `o` - Ver output
- `d` - Debug
- `J` - Próximo com falha
- `K` - Anterior com falha

---

## 🎯 Fluxos de Trabalho Comuns

### Desenvolvimento TDD (Test-Driven Development)

```vim
" 1. Abra output panel
<Space>tO

" 2. Ative watch mode
<Space>tw

" 3. Escreva teste (vai falhar)
def test_soma():
    assert soma(2, 2) == 4

" 4. Veja falhar no output panel
" 5. Implemente função
def soma(a, b):
    return a + b

" 6. Salve (Ctrl+s)
" 7. Teste roda automaticamente!
" 8. Veja passar no output panel ✓
```

### Debug de Teste Falhando

```vim
" 1. Rode teste
<Space>tt

" 2. Se falhar, veja output
<Space>to

" 3. Navegue para o erro
]t

" 4. Se precisar debug:
<Space>td    " Abre debugger
```

### Rodar Suíte Completa

```vim
" 1. Abra summary e output
<Space>ts
<Space>tO

" 2. Rode tudo
<Space>tT

" 3. Veja progresso:
"    - Summary: árvore atualizando
"    - Output: logs em tempo real
```

---

## 🔍 Ver Detalhes de Um Teste

### Se passou ✓

```vim
<Space>to    " Ver output (prints, logs)
```

### Se falhou ✗

```vim
<Space>to    " Ver traceback completo
```

### Comparar múltiplos testes

```vim
<Space>ts    " Summary tree
# Clique em cada teste
# Aperte 'o' para ver output
```

---

## 🎨 Indicadores Visuais

### No Código (Sign Column)

```
✓ │ def test_passa():       # Passou
✗ │ def test_falha():       # Falhou
⟳ │ def test_rodando():     # Rodando
⊘ │ def test_skip():        # Pulado
? │ def test_nao_rodado():  # Não rodado
```

### No Output Panel

```python
========================= test session starts =========================
collecting ... collected 5 items

test_exemplo.py::test_soma PASSED                              [ 20%]
test_exemplo.py::test_subtrai PASSED                           [ 40%]
test_exemplo.py::test_multiplica FAILED                        [ 60%]

========================== FAILURES ===========================
______________________ test_multiplica _______________________

    def test_multiplica():
>       assert multiplica(2, 3) == 6
E       assert 5 == 6

test_exemplo.py:15: AssertionError
========================= short test summary =========================
FAILED test_exemplo.py::test_multiplica - assert 5 == 6
====================== 2 passed, 1 failed ========================
```

---

## 🐛 Debug Avançado

### Com Breakpoints

```vim
" 1. Coloque breakpoint
<Space>db

" 2. Rode com debug
<Space>td

" 3. Debugger para no breakpoint
" 4. Inspecione variáveis
" 5. Continue: <Space>dc
```

### Com Print Debugging

```python
def test_exemplo():
    print("Valor de x:", x)  # ← Este print aparece no output!
    print("Estado:", estado)
    assert x == esperado
```

```vim
" Rode com output
<Space>tr

" Veja os prints no output panel!
```

---

## ⚙️ Configurações Úteis

### Verbose Output (Já Configurado!)

Os testes rodam com `-vv --tb=short`:
- `-vv`: Output muito verboso
- `--tb=short`: Tracebacks resumidos

### Auto-detect VirtualEnv (Já Configurado!)

O Neotest detecta automaticamente `.venv/bin/python`

---

## 📋 Tabela de Atalhos Completa

| Atalho | Modo | Ação |
|--------|------|------|
| `<Space>tr` | Normal | **Run + Show Output** ⭐ |
| `<Space>tF` | Normal | **Run File + Show Output** ⭐ |
| `<Space>tt` | Normal | Run nearest test |
| `<Space>tf` | Normal | Run file |
| `<Space>tT` | Normal | Run all tests |
| `<Space>to` | Normal | Show output (popup) |
| `<Space>tO` | Normal | Toggle output panel |
| `<Space>ts` | Normal | Toggle summary |
| `<Space>tS` | Normal | Stop tests |
| `<Space>tw` | Normal | Toggle watch mode |
| `<Space>td` | Normal | Debug test |
| `]t` | Normal | Next failed test |
| `[t` | Normal | Previous failed test |

---

## 💡 Dicas

1. **Use `<Space>tr`** para ver output sempre
2. **Watch mode** (`<Space>tw`) é ótimo para TDD
3. **Summary** (`<Space>ts`) dá visão geral
4. **Print debugging funciona!** Os prints aparecem no output
5. **Output panel** pode ser scrollado normalmente (j/k)

---

## 🆘 Troubleshooting

### Não vejo output

```vim
" Abra output panel manualmente
<Space>tO

" Ou use atalho com output automático
<Space>tr
```

### Testes não rodam

```vim
" Verifique virtualenv
:lua print(vim.fn.exepath("python"))

" Ou selecione manualmente
<Space>cv
```

### Output muito rápido

```vim
" Use watch mode para rodar sempre
<Space>tw

" Ou pause no debugger
<Space>td
```

---

## 🎉 Exemplo Completo

```python
# test_calculadora.py
def soma(a, b):
    return a + b

def test_soma():
    print("Testando soma...")
    resultado = soma(2, 2)
    print(f"Resultado: {resultado}")
    assert resultado == 4
```

```vim
" 1. Abra o arquivo
:e test_calculadora.py

" 2. Rode COM output visível
<Space>tr

" 3. Veja no output panel:
"    Testando soma...
"    Resultado: 4
"    PASSED ✓

" 4. Mude para falhar
def test_soma():
    assert soma(2, 2) == 5  # ← Vai falhar

" 5. Rode novamente
<Space>tr

" 6. Veja o erro:
"    AssertionError: assert 4 == 5
"    FAILED ✗
```

---

**🚀 Agora você vê TUDO que acontece nos testes!**

Use `<Space>tr` e `<Space>tF` para sempre ter output visível!
