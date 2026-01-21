# Configuracao MCP para Claude Code (Windows)

Este guia ajuda-te a configurar MCPs para teres acesso completo aos teus diretorios locais e servidores remotos.

## Pre-requisitos

1. **Node.js** instalado (v18+): https://nodejs.org/
2. **Claude Code** instalado: `npm install -g @anthropic-ai/claude-code`
3. **Git Bash** ou **PowerShell** para executar comandos

## Instalacao Rapida

### Passo 1: Abrir PowerShell como Administrador

```powershell
# Verificar se Node.js esta instalado
node --version

# Verificar se npm esta disponivel
npm --version
```

### Passo 2: Configurar MCPs via Linha de Comando

Execute estes comandos no PowerShell ou CMD:

```powershell
# 1. Adicionar acesso ao filesystem local (ajusta os caminhos)
claude mcp add --transport stdio filesystem -- cmd /c npx -y @modelcontextprotocol/server-filesystem C:\Users\TeuUser\Projetos C:\Users\TeuUser\Documents

# 2. Adicionar acesso SSH a servidores remotos
claude mcp add --transport stdio ssh-server -- cmd /c npx -y @anthropic-ai/mcp-server-ssh

# 3. Verificar configuracao
claude mcp list
```

### Passo 3: Configuracao Manual (Alternativa)

Se preferires configurar manualmente, edita o ficheiro:
- **Localizacao**: `%USERPROFILE%\.claude.json`

Copia o conteudo do ficheiro `claude-config-windows.json` deste repositorio para o teu `.claude.json`.

## Estrutura dos Ficheiros

```
mcp-config/
├── README.md                    # Este guia
├── claude-config-windows.json   # Config completa para Windows
├── mcp-project.json            # Config por projeto (.mcp.json)
└── ssh-config-example.json     # Exemplo de config SSH
```

## Comandos Uteis

```powershell
# Listar MCPs configurados
claude mcp list

# Ver detalhes de um MCP
claude mcp get filesystem

# Remover um MCP
claude mcp remove filesystem

# Dentro do Claude Code, ver status
/mcp
```

## Resolucao de Problemas

### Erro: "npx not found"
```powershell
# Reinstalar Node.js e adicionar ao PATH
# Ou usar caminho completo:
claude mcp add --transport stdio filesystem -- C:\Program Files\nodejs\npx.cmd -y @modelcontextprotocol/server-filesystem C:\Users\TeuUser
```

### Erro: "Permission denied"
- Executar PowerShell como Administrador
- Verificar permissoes das pastas

### MCP nao conecta
```powershell
# Testar o servidor MCP diretamente
npx -y @modelcontextprotocol/server-filesystem C:\Users\TeuUser
```

## Proximos Passos

1. Ajusta os caminhos nos ficheiros de configuracao
2. Configura as tuas chaves SSH para acesso remoto
3. Testa com `claude mcp list` e `/mcp` dentro do Claude Code
