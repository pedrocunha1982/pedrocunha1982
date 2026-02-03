# Sessões com Claude

Esta pasta contém documentação das sessões de trabalho com Claude AI.

## 📁 Estrutura

```
sessoes-claude/
├── templates/
│   └── template-sessao.md    # Template para novas documentações
├── 2026-02-03-exemplo.md     # Exemplo de sessão documentada
└── README.md                  # Este arquivo
```

## 🎯 Como Usar

### Documentar Nova Sessão

```bash
# 1. Copiar template
cp templates/template-sessao.md 2026-02-03-nome-descritivo.md

# 2. Editar com informações da sessão
# (Claude pode fazer isso automaticamente se você pedir)

# 3. Salvar e fazer commit
git add .
git commit -m "Documenta sessão: nome-descritivo"
```

### Naming Convention

Use o formato: `YYYY-MM-DD-descricao-curta.md`

Exemplos:
- `2026-02-03-organizacao-repo.md`
- `2026-02-04-criacao-app-python.md`
- `2026-02-05-correcao-bugs.md`

## 💡 Por Que Documentar?

1. **Memória**: Lembrar o que foi feito
2. **Contexto**: Claude pode ver trabalho anterior
3. **Aprendizado**: Registrar soluções e decisões
4. **Continuidade**: Retomar projetos facilmente

## 🔍 Buscar Sessões Antigas

```bash
# Listar todas as sessões
ls -lt

# Buscar por palavra-chave
grep -r "palavra" *.md

# Ver última sessão
cat $(ls -t *.md | head -1)
```

## ✨ Dica

Peça ao Claude para criar e preencher a documentação automaticamente:

```
"Claude, documenta o que fizemos hoje em sessoes-claude/
usando o template"
```
