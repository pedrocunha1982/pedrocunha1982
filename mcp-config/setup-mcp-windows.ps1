# Script de Configuracao MCP para Claude Code (Windows)
# Executar como Administrador no PowerShell
#
# Uso: .\setup-mcp-windows.ps1

param(
    [string]$ProjectsPath = "$env:USERPROFILE\Projetos",
    [string]$DocumentsPath = "$env:USERPROFILE\Documents",
    [string]$SSHKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Configuracao MCP para Claude Code" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Node.js
Write-Host "[1/5] Verificando Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "OK: Node.js $nodeVersion instalado" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Node.js nao encontrado!" -ForegroundColor Red
    Write-Host "Instale em: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Verificar Claude Code
Write-Host ""
Write-Host "[2/5] Verificando Claude Code..." -ForegroundColor Yellow
try {
    $claudeVersion = claude --version
    Write-Host "OK: Claude Code instalado" -ForegroundColor Green
} catch {
    Write-Host "AVISO: Claude Code nao encontrado, a instalar..." -ForegroundColor Yellow
    npm install -g @anthropic-ai/claude-code
}

# Criar diretorios se nao existirem
Write-Host ""
Write-Host "[3/5] Verificando diretorios..." -ForegroundColor Yellow
if (!(Test-Path $ProjectsPath)) {
    New-Item -ItemType Directory -Path $ProjectsPath -Force | Out-Null
    Write-Host "Criado: $ProjectsPath" -ForegroundColor Green
} else {
    Write-Host "OK: $ProjectsPath existe" -ForegroundColor Green
}

# Configurar MCP Filesystem
Write-Host ""
Write-Host "[4/5] Configurando MCP Filesystem..." -ForegroundColor Yellow
try {
    claude mcp add --transport stdio filesystem -- cmd /c npx -y @modelcontextprotocol/server-filesystem $ProjectsPath $DocumentsPath
    Write-Host "OK: MCP Filesystem configurado" -ForegroundColor Green
} catch {
    Write-Host "AVISO: Pode ja estar configurado ou erro na configuracao" -ForegroundColor Yellow
}

# Configurar MCP SSH (se chave existir)
Write-Host ""
Write-Host "[5/5] Configurando MCP SSH..." -ForegroundColor Yellow
if (Test-Path $SSHKeyPath) {
    try {
        claude mcp add --transport stdio ssh-remote -- cmd /c npx -y @anthropic-ai/mcp-server-ssh
        Write-Host "OK: MCP SSH configurado" -ForegroundColor Green
    } catch {
        Write-Host "AVISO: Pode ja estar configurado" -ForegroundColor Yellow
    }
} else {
    Write-Host "AVISO: Chave SSH nao encontrada em $SSHKeyPath" -ForegroundColor Yellow
    Write-Host "Para gerar uma chave: ssh-keygen -t ed25519" -ForegroundColor Yellow
}

# Listar configuracoes
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Configuracao Concluida!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "MCPs configurados:" -ForegroundColor Yellow
claude mcp list

Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "1. Inicia o Claude Code: claude" -ForegroundColor White
Write-Host "2. Dentro do Claude, usa: /mcp para ver status" -ForegroundColor White
Write-Host "3. Autentica servicos que precisem (GitHub, etc.)" -ForegroundColor White
Write-Host ""
Write-Host "Caminhos configurados:" -ForegroundColor Yellow
Write-Host "  - Projetos: $ProjectsPath" -ForegroundColor White
Write-Host "  - Documentos: $DocumentsPath" -ForegroundColor White
Write-Host ""
