# Scripts

Esta pasta contém scripts úteis para automatizar tarefas.

## 📜 Tipos de Scripts

### Automação
- Backup automático
- Organização de arquivos
- Processamento em lote

### Utilitários
- Conversão de formatos
- Limpeza de dados
- Helpers diversos

### Deploy e Build
- Scripts de deploy
- Configuração de ambiente
- Builds automatizados

## 🚀 Como Usar

### Criar Novo Script

Peça ao Claude:
```
"Claude, cria um script bash em scripts/ que faça backup
da pasta projetos"
```

Ou manualmente:
```bash
cd scripts
touch meu-script.sh
chmod +x meu-script.sh
```

### Executar Script

```bash
# Bash script
./scripts/meu-script.sh

# Python script
python scripts/meu-script.py
```

## 💡 Boas Práticas

1. **Nome descritivo**: `backup-projetos.sh` não `script1.sh`
2. **Comentários**: Explique o que faz
3. **Executável**: `chmod +x` para scripts bash
4. **Cabeçalho**: Inclua shebang (`#!/bin/bash`)

## 📝 Exemplo de Estrutura

```bash
#!/bin/bash
# backup-projetos.sh
# Faz backup da pasta projetos para backup/

echo "Iniciando backup..."
# seu código aqui
```

## 🔧 Scripts Úteis para Criar

- `organize-files.sh` - Organiza arquivos por tipo
- `backup.sh` - Backup automático
- `clean-cache.sh` - Limpa arquivos temporários
- `setup-env.sh` - Configura ambiente de desenvolvimento
