# Guia para Trabalhar com Claude AI

Este guia explica como colaborar eficientemente com Claude, mantendo seu trabalho organizado e documentado.

## 🎯 Por Que Trabalhar Localmente?

Claude funciona melhor acessando arquivos no seu computador porque:

- ✅ **Acesso direto**: Claude lê e edita arquivos locais instantaneamente
- ✅ **Você tem controle**: Todas as mudanças ficam na sua máquina primeiro
- ✅ **Backup flexível**: Você decide quando enviar para GitHub
- ✅ **Sem perda de contexto**: Todo o trabalho fica visível localmente

## 📋 Fluxo de Trabalho Recomendado

### 1. Preparação Inicial

```bash
# Se ainda não tem o repositório localmente
git clone https://github.com/pedrocunha1982/pedrocunha1982.git
cd pedrocunha1982
```

### 2. Começar Nova Sessão com Claude

Quando for pedir ajuda ao Claude:

1. **Seja específico sobre localização**:
   ```
   "Claude, quero criar um projeto Python em projetos/meu-app/"
   ```

2. **Peça para documentar**:
   ```
   "Claude, documenta o que vamos fazer em sessoes-claude/"
   ```

3. **Trabalhe iterativamente**:
   - Claude cria/edita arquivos
   - Você testa localmente
   - Pede ajustes conforme necessário

### 3. Depois da Sessão

```bash
# Ver o que mudou
git status
git diff

# Salvar no GitHub
git add .
git commit -m "Descrição: o que foi feito com Claude"
git push
```

## 📝 Documentar Sessões

### Por Que Documentar?

- Você lembra o que já foi feito
- Claude pode ver trabalho anterior em futuras conversas
- Facilita retomar projetos depois de pausas

### Como Documentar

Use o template em `sessoes-claude/templates/template-sessao.md`:

```bash
# Copiar template
cp sessoes-claude/templates/template-sessao.md \
   sessoes-claude/2026-02-03-nome-descritivo.md

# Editar com o que foi feito
```

## 💡 Dicas para Comunicação Eficiente

### ✅ Boas Práticas

```
"Claude, lê o arquivo projetos/app/main.py e adiciona tratamento de erros"

"Cria uma função em scripts/backup.sh que faça backup da pasta projetos"

"Olha em sessoes-claude/ o que fizemos na última vez e continua dali"
```

### ❌ Evite

```
"Faz alguma coisa"  # Muito vago

"Cria no GitHub"    # Claude trabalha localmente, você faz push depois
```

## 🗂️ Organização de Projetos

### Estrutura Recomendada

```
projetos/
└── nome-do-projeto/
    ├── README.md           # O que é e como usar
    ├── src/                # Código fonte
    ├── tests/              # Testes
    ├── docs/               # Documentação específica
    └── .gitignore         # Arquivos a ignorar
```

### Criar Novo Projeto

```bash
# Claude pode criar isso para você
mkdir -p projetos/meu-projeto/{src,tests,docs}
```

Então peça: "Claude, cria um README.md em projetos/meu-projeto explicando [descrição]"

## 🔄 Cenários Comuns

### Retomar Projeto Antigo

```
"Claude, olha em projetos/meu-app e me diz o que tem lá.
Depois vamos adicionar [nova funcionalidade]"
```

### Revisar Código

```
"Claude, revisa o código em projetos/app/main.py e sugere melhorias"
```

### Criar Scripts Úteis

```
"Claude, cria um script em scripts/organizar.sh que organize
meus arquivos por data"
```

### Aprender Algo Novo

```
"Claude, cria um projeto exemplo em projetos/aprender-python/
com exemplos de [conceito específico]"
```

## 🔍 Ver Trabalho Anterior

### No GitHub

- Vá em: https://github.com/pedrocunha1982/pedrocunha1982
- Navegue pelas pastas
- Veja commits para histórico

### Localmente (Melhor)

```bash
# Ver estrutura
tree -L 2

# Ver últimas mudanças
git log --oneline -10

# Ver conteúdo de sessões documentadas
ls sessoes-claude/
cat sessoes-claude/2026-02-03-*.md
```

## 🚀 Workflow Completo - Exemplo

```bash
# 1. Atualizar repositório local
cd pedrocunha1982
git pull

# 2. Conversar com Claude
# "Claude, vamos criar um app Python que faz X em projetos/app-x/"

# 3. Claude cria arquivos localmente
# Você testa: python projetos/app-x/main.py

# 4. Pede ajustes se necessário
# "Claude, adiciona validação de entrada"

# 5. Quando satisfeito, salva no GitHub
git add .
git commit -m "Adiciona app-x: descrição do que faz"
git push

# 6. Documenta a sessão
# Claude pode criar automaticamente em sessoes-claude/
```

## ❓ FAQ

**P: Claude pode ver meu GitHub diretamente?**
R: Não facilmente. É melhor trabalhar localmente e fazer push depois.

**P: E se eu trabalhar em outro computador?**
R: Faça `git pull` primeiro para baixar últimas mudanças.

**P: Como Claude vê o que já foi feito?**
R: Peça: "Claude, lê sessoes-claude/ e me atualiza sobre o projeto X"

**P: Posso ter arquivos privados?**
R: Sim! Adicione em `.gitignore` para não ir para GitHub.

## 📚 Recursos

- [Git Básico](https://git-scm.com/docs)
- [Markdown Guide](https://www.markdownguide.org/)

---

**Dica Final**: Trate Claude como um par de programação. Seja claro sobre o que quer, teste o resultado, e itere até ficar bom. Documentar ajuda vocês dois!
