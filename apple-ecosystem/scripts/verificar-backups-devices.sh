#!/bin/bash
# ============================================================================
# VERIFICAR BACKUPS DE TODOS OS DEVICES
# ============================================================================
# Verifica o status dos backups de todos os dispositivos Apple
# que fazem backup no Mac Studio ou diretamente no NAS.
#
# Uso: bash verificar-backups-devices.sh
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

echo ""
echo "============================================"
echo "  VERIFICACAO DE BACKUPS"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "============================================"
echo ""

# ============================================================================
# 1. TIME MACHINE (MAC STUDIO)
# ============================================================================
echo "--- Time Machine (Mac Studio) ---"

if command -v tmutil > /dev/null 2>&1; then
    # Destinos configurados
    echo ""
    info "Destinos configurados:"
    tmutil destinationinfo 2>/dev/null || warn "Nenhum destino"

    # Ultimo backup
    LAST=$(tmutil latestbackup 2>/dev/null || echo "")
    if [ -n "$LAST" ]; then
        log "Ultimo backup: $LAST"
        # Calcular idade do backup
        BACKUP_DATE=$(basename "$LAST" | sed 's/-/:/4' | sed 's/-/:/5')
        info "Data: $BACKUP_DATE"
    else
        warn "Nenhum backup encontrado"
    fi

    # Status atual
    echo ""
    info "Status atual:"
    tmutil status 2>/dev/null || info "Idle"
else
    warn "tmutil nao disponivel (nao e macOS?)"
fi

# ============================================================================
# 2. BACKUPS DE DEVICES NA PASTA TIME MACHINE DO SERVIDOR
# ============================================================================
echo ""
echo "--- Backups na pasta do servidor ---"

TM_SERVER_DIR="/Users/Shared/Studio/Backups/TimeMachine"
if [ -d "$TM_SERVER_DIR" ]; then
    log "Pasta Time Machine servidor: $TM_SERVER_DIR"
    DEVICE_COUNT=$(find "$TM_SERVER_DIR" -maxdepth 1 -name "*.backupbundle" -o -name "*.sparsebundle" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DEVICE_COUNT" -gt 0 ]; then
        log "$DEVICE_COUNT device(s) com backup:"
        find "$TM_SERVER_DIR" -maxdepth 1 \( -name "*.backupbundle" -o -name "*.sparsebundle" \) -exec basename {} \; 2>/dev/null | while read bundle; do
            SIZE=$(du -sh "$TM_SERVER_DIR/$bundle" 2>/dev/null | awk '{print $1}')
            MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$TM_SERVER_DIR/$bundle" 2>/dev/null || echo "?")
            echo "    - $bundle ($SIZE, ultimo: $MODIFIED)"
        done
    else
        info "Nenhum device fez backup aqui ainda"
    fi
else
    warn "Pasta $TM_SERVER_DIR nao existe"
fi

# ============================================================================
# 3. VERIFICAR CONECTIVIDADE NAS
# ============================================================================
echo ""
echo "--- Conectividade NAS ---"

# Ajuste o IP do seu NAS
NAS_IP="192.168.0.100"

if ping -c 2 -W 2 "$NAS_IP" > /dev/null 2>&1; then
    log "NAS ($NAS_IP): online"

    # Verificar se share SMB responde
    if smbutil view -g "//$NAS_IP" > /dev/null 2>&1; then
        log "SMB no NAS: respondendo"
    else
        warn "SMB no NAS: nao respondeu (pode precisar autenticacao)"
    fi
else
    err "NAS ($NAS_IP): OFFLINE"
    err "Backups para o NAS estao PARADOS!"
fi

# ============================================================================
# 4. VERIFICAR iCLOUD (SE ATIVO)
# ============================================================================
echo ""
echo "--- iCloud ---"

ICLOUD_DIR="$HOME/Library/Mobile Documents"
if [ -d "$ICLOUD_DIR" ]; then
    SIZE=$(du -sh "$ICLOUD_DIR" 2>/dev/null | awk '{print $1}')
    log "iCloud Drive: $SIZE localmente"

    # Verificar se tem conflitos
    CONFLICTS=$(find "$ICLOUD_DIR" -name "* conflito *" -o -name "*(conflict)*" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CONFLICTS" -gt 0 ]; then
        warn "$CONFLICTS arquivo(s) com conflito no iCloud"
    else
        log "Sem conflitos no iCloud"
    fi
else
    info "iCloud Drive nao ativo localmente"
fi

# ============================================================================
# 5. ESPACO DISPONIVEL
# ============================================================================
echo ""
echo "--- Espaco em Disco ---"

df -h / | tail -1 | awk '{printf "  Mac Studio: %s usado de %s (%s livre, %s)\n", $3, $2, $4, $5}'

# Se o NAS estiver montado
mount | grep -i "smbfs\|nfs\|afp" 2>/dev/null | while read line; do
    MOUNT_POINT=$(echo "$line" | awk '{print $3}')
    df -h "$MOUNT_POINT" | tail -1 | awk -v mp="$MOUNT_POINT" '{printf "  NAS (%s): %s usado de %s (%s livre)\n", mp, $3, $2, $4}'
done

# ============================================================================
# RESUMO
# ============================================================================
echo ""
echo "============================================"
echo "  CHECKLIST DE BACKUPS"
echo "============================================"
echo ""
echo "  Para cada device Apple, confirme:"
echo "  [ ] MacBook  → Time Machine → Mac Studio ou NAS"
echo "  [ ] iPhone   → iCloud Backup ativado"
echo "  [ ] iPad     → iCloud Backup ativado"
echo "  [ ] Mac Studio → Time Machine → NAS"
echo ""
echo "  Verificar no iPhone/iPad:"
echo "    Settings > [seu nome] > iCloud > iCloud Backup"
echo "    -> Deve mostrar 'Last Backup: hoje'"
echo ""
echo "============================================"
