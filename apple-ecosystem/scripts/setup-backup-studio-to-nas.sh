#!/bin/bash
# ============================================================================
# BACKUP MAC STUDIO -> NAS via Time Machine (SMB)
# ============================================================================
# Configura o backup do Mac Studio para o NAS via Time Machine
#
# Pre-requisito: NAS configurado com share SMB compativel com Time Machine
#
# Uso: sudo bash setup-backup-studio-to-nas.sh
# ============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERRO]${NC} $1"; }
info() { echo -e "${BLUE}[i]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then
    err "Execute com sudo: sudo bash $0"
    exit 1
fi

echo ""
echo "============================================"
echo "  BACKUP MAC STUDIO -> NAS"
echo "============================================"
echo ""

# ============================================================================
# CONFIGURACAO - EDITE AQUI
# ============================================================================
# Dados do NAS (ajuste conforme sua configuracao)
NAS_IP="192.168.0.100"        # IP do NAS na rede local
NAS_USER="admin"              # Usuario do NAS
NAS_SHARE="TimeMachine"       # Nome do share SMB no NAS
NAS_PROTOCOL="smb"            # smb ou afp

# ============================================================================
# 1. VERIFICAR CONECTIVIDADE COM O NAS
# ============================================================================
info "Verificando conectividade com NAS ($NAS_IP)..."

if ping -c 2 -W 2 "$NAS_IP" > /dev/null 2>&1; then
    log "NAS acessivel em $NAS_IP"
else
    err "NAS nao acessivel em $NAS_IP"
    err "Verifique: 1) NAS ligado 2) Mesmo segmento de rede 3) IP correto"
    exit 1
fi

# Verificar se share SMB esta acessivel
info "Verificando share SMB..."
if smbutil view -g "//$NAS_IP" > /dev/null 2>&1; then
    log "Servico SMB ativo no NAS"
else
    warn "Nao foi possivel listar shares SMB (pode precisar de autenticacao)"
fi

# ============================================================================
# 2. CONFIGURAR TIME MACHINE
# ============================================================================
info "Configurando Time Machine..."

# Ativar Time Machine
tmutil enable

# Adicionar destino NAS
# A flag -p pede a senha interativamente (mais seguro)
info "Sera solicitada a senha do NAS..."
tmutil setdestination -a -p "$NAS_PROTOCOL://$NAS_USER@$NAS_IP/$NAS_SHARE"

if [ $? -eq 0 ]; then
    log "Destino Time Machine configurado: $NAS_PROTOCOL://$NAS_IP/$NAS_SHARE"
else
    err "Falha ao configurar destino. Tentando metodo alternativo..."
    warn "Se o NAS nao suporta Time Machine nativo, crie um sparse bundle:"
    echo ""
    echo "  # No Terminal do Mac Studio:"
    echo "  hdiutil create -size 500g -type SPARSEBUNDLE \\"
    echo "    -fs 'HFS+J' -volname 'TMBackup' ~/TMBackup.sparsebundle"
    echo ""
    echo "  # Monte o share do NAS:"
    echo "  mkdir -p /Volumes/NAS_TM"
    echo "  mount_smbfs //$NAS_USER@$NAS_IP/$NAS_SHARE /Volumes/NAS_TM"
    echo ""
    echo "  # Mova o sparse bundle pro NAS:"
    echo "  mv ~/TMBackup.sparsebundle /Volumes/NAS_TM/"
    echo ""
    echo "  # Configure como destino:"
    echo "  hdiutil attach /Volumes/NAS_TM/TMBackup.sparsebundle"
    echo "  sudo tmutil setdestination /Volumes/TMBackup"
    echo ""
fi

# ============================================================================
# 3. CONFIGURAR EXCLUSOES (OTIMIZAR BACKUP)
# ============================================================================
info "Configurando exclusoes do Time Machine..."

# Excluir caches e arquivos temporarios grandes
EXCLUDES=(
    "/System/Volumes/VM"
    "/private/var/vm"
    "/Library/Caches"
    "$HOME/Library/Caches"
    "$HOME/.Trash"
    "/private/tmp"
    "/cores"
)

for exclude in "${EXCLUDES[@]}"; do
    tmutil addexclusion -p "$exclude" 2>/dev/null || true
done

log "Exclusoes configuradas (caches, VM, temp)"

# ============================================================================
# 4. AGENDAR E VERIFICAR
# ============================================================================
info "Configurando backup automatico..."

# Ativar backup automatico
tmutil enable

# Mostrar configuracao atual
echo ""
echo "============================================"
echo "  CONFIGURACAO TIME MACHINE"
echo "============================================"
tmutil destinationinfo 2>/dev/null || warn "Nenhum destino configurado"
echo ""

# Iniciar primeiro backup
info "Iniciando primeiro backup em background..."
tmutil startbackup --auto 2>/dev/null || warn "Inicie o backup manualmente em Time Machine preferences"

echo ""
echo "============================================"
echo "  BACKUP CONFIGURADO!"
echo "============================================"
echo ""
echo "  Destino: $NAS_PROTOCOL://$NAS_IP/$NAS_SHARE"
echo "  Modo: Automatico (a cada hora)"
echo ""
echo "  Comandos uteis:"
echo "  --------------------------------"
echo "  tmutil status              # Ver status atual"
echo "  tmutil listbackups         # Listar backups"
echo "  tmutil startbackup         # Iniciar backup manual"
echo "  tmutil destinationinfo     # Ver destinos configurados"
echo "  tmutil latestbackup        # Ver ultimo backup"
echo ""
echo "============================================"
