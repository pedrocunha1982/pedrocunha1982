#!/bin/bash
# ============================================================================
# MANUTENCAO E LIMPEZA - MAC STUDIO SERVIDOR
# ============================================================================
# Script de manutencao periodica. Execute semanalmente ou mensalmente.
#
# Uso: sudo bash manutencao-studio.sh
#
# Acoes:
#   - Limpa caches do sistema e aplicativos
#   - Verifica integridade do disco
#   - Verifica status dos backups
#   - Verifica servicos do servidor
#   - Mostra uso de disco
#   - Limpa logs antigos
#   - Verifica updates pendentes
# ============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERRO]${NC} $1"; }
info() { echo -e "${BLUE}[i]${NC} $1"; }
header() { echo -e "\n${BOLD}=== $1 ===${NC}"; }

if [ "$EUID" -ne 0 ]; then
    err "Execute com sudo: sudo bash $0"
    exit 1
fi

CONSOLE_USER=$(stat -f "%Su" /dev/console 2>/dev/null)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

echo ""
echo "============================================"
echo "  MANUTENCAO MAC STUDIO"
echo "  $TIMESTAMP"
echo "============================================"

# ============================================================================
# 1. VERIFICAR SERVICOS DO SERVIDOR
# ============================================================================
header "SERVICOS DO SERVIDOR"

check_service() {
    local name="$1"
    local check="$2"
    if eval "$check" > /dev/null 2>&1; then
        log "$name: ATIVO"
    else
        err "$name: INATIVO"
    fi
}

check_service "Screen Sharing" "launchctl list | grep -q screensharing"
check_service "SSH"            "launchctl list | grep -q com.apple.sshd"
check_service "SMB"            "launchctl list | grep -q smbd"
check_service "Content Cache"  "AssetCacheManagerUtil status 2>/dev/null | grep -q Activated"

# Verificar pastas compartilhadas
if [ -d "/Users/Shared/Studio" ]; then
    log "Pastas compartilhadas: OK"
else
    err "Pastas compartilhadas nao encontradas em /Users/Shared/Studio"
fi

# ============================================================================
# 2. USO DE DISCO
# ============================================================================
header "USO DE DISCO"

df -h / | tail -1 | awk '{printf "  Disco principal: %s usado de %s (%s livre)\n", $3, $2, $4}'

# Maiores consumidores
info "Top 5 pastas por tamanho:"
du -sh /Users/*/Library/Caches /Library/Caches /private/var/log /Users/Shared/Studio 2>/dev/null | sort -rh | head -5 | while read size path; do
    echo "  $size  $path"
done

# ============================================================================
# 3. LIMPEZA DE CACHES
# ============================================================================
header "LIMPEZA DE CACHES"

FREED=0

# Caches do sistema
if [ -d "/Library/Caches" ]; then
    SIZE_BEFORE=$(du -sm /Library/Caches 2>/dev/null | awk '{print $1}')
    rm -rf /Library/Caches/* 2>/dev/null || true
    SIZE_AFTER=$(du -sm /Library/Caches 2>/dev/null | awk '{print $1}')
    DIFF=$((SIZE_BEFORE - SIZE_AFTER))
    FREED=$((FREED + DIFF))
    log "Caches do sistema: ${DIFF}MB liberados"
fi

# Caches do usuario
USER_CACHE="/Users/$CONSOLE_USER/Library/Caches"
if [ -d "$USER_CACHE" ]; then
    SIZE_BEFORE=$(du -sm "$USER_CACHE" 2>/dev/null | awk '{print $1}')
    # Nao apagar caches criticos do CloudKit/Spotlight
    find "$USER_CACHE" -mindepth 1 -maxdepth 1 \
        ! -name "CloudKit" \
        ! -name "com.apple.Spotlight*" \
        ! -name "com.apple.bird" \
        -exec rm -rf {} + 2>/dev/null || true
    SIZE_AFTER=$(du -sm "$USER_CACHE" 2>/dev/null | awk '{print $1}')
    DIFF=$((SIZE_BEFORE - SIZE_AFTER))
    FREED=$((FREED + DIFF))
    log "Caches do usuario: ${DIFF}MB liberados"
fi

# Logs antigos (mais de 7 dias)
if [ -d "/private/var/log" ]; then
    find /private/var/log -name "*.log" -mtime +7 -delete 2>/dev/null || true
    find /private/var/log -name "*.gz" -mtime +7 -delete 2>/dev/null || true
    log "Logs antigos limpos (>7 dias)"
fi

# Lixeira
TRASH="/Users/$CONSOLE_USER/.Trash"
if [ -d "$TRASH" ] && [ "$(ls -A "$TRASH" 2>/dev/null)" ]; then
    SIZE=$(du -sm "$TRASH" 2>/dev/null | awk '{print $1}')
    rm -rf "$TRASH"/* 2>/dev/null || true
    FREED=$((FREED + SIZE))
    log "Lixeira esvaziada: ${SIZE}MB"
else
    log "Lixeira: vazia"
fi

# Downloads antigos (mais de 30 dias) - apenas avisar, nao apagar
OLD_DL=$(find "/Users/$CONSOLE_USER/Downloads" -mtime +30 2>/dev/null | wc -l | tr -d ' ')
if [ "$OLD_DL" -gt 0 ]; then
    warn "$OLD_DL arquivos em Downloads com mais de 30 dias"
fi

log "Total liberado: ${FREED}MB"

# ============================================================================
# 4. VERIFICAR BACKUPS
# ============================================================================
header "STATUS DOS BACKUPS"

# Time Machine
if tmutil destinationinfo > /dev/null 2>&1; then
    LAST_BACKUP=$(tmutil latestbackup 2>/dev/null || echo "Nenhum")
    log "Time Machine destino configurado"
    info "Ultimo backup: $LAST_BACKUP"
else
    warn "Time Machine: nenhum destino configurado"
fi

# Verificar conectividade com NAS (ajuste o IP)
NAS_IP="192.168.0.100"
if ping -c 1 -W 2 "$NAS_IP" > /dev/null 2>&1; then
    log "NAS ($NAS_IP): acessivel"
else
    warn "NAS ($NAS_IP): nao acessivel"
fi

# ============================================================================
# 5. VERIFICAR INTEGRIDADE DO DISCO
# ============================================================================
header "INTEGRIDADE DO DISCO"

# Verificar SMART status
SMART=$(diskutil info disk0 2>/dev/null | grep "SMART Status" | awk -F: '{print $2}' | tr -d ' ')
if [ "$SMART" = "Verified" ]; then
    log "SMART Status: Verificado"
elif [ -n "$SMART" ]; then
    err "SMART Status: $SMART"
else
    info "SMART Status: nao disponivel"
fi

# Verificar filesystem
info "Para verificacao completa do disco, execute:"
echo "  diskutil verifyVolume /"

# ============================================================================
# 6. VERIFICAR UPDATES
# ============================================================================
header "UPDATES PENDENTES"

UPDATES=$(softwareupdate -l 2>&1)
if echo "$UPDATES" | grep -q "No new software available"; then
    log "Sistema atualizado"
else
    warn "Updates disponiveis:"
    echo "$UPDATES" | grep -E "^\*|Label:|Title:" | head -10
fi

# ============================================================================
# 7. MEMORIA E CPU
# ============================================================================
header "RECURSOS DO SISTEMA"

# Uptime
UPTIME=$(uptime | awk -F'up ' '{print $2}' | awk -F', ' '{print $1}')
info "Uptime: $UPTIME"

# Memoria
vm_stat 2>/dev/null | awk '
/Pages free/ { free=$3 }
/Pages active/ { active=$3 }
/Pages inactive/ { inactive=$3 }
/Pages speculative/ { spec=$3 }
/page size of/ { pagesize=$8 }
END {
    gsub(/\./,"",free); gsub(/\./,"",active); gsub(/\./,"",inactive); gsub(/\./,"",spec)
    total = (free+active+inactive+spec) * 16384 / 1073741824
    used = (active) * 16384 / 1073741824
    printf "  Memoria: %.1fGB usado de %.1fGB total\n", used, total
}'

# Load average
info "Load average: $(sysctl -n vm.loadavg 2>/dev/null || uptime | awk -F'load average:' '{print $2}')"

# ============================================================================
# RESUMO
# ============================================================================
echo ""
echo "============================================"
echo "  MANUTENCAO COMPLETA"
echo "  $TIMESTAMP"
echo "============================================"
echo "  Espaco liberado: ${FREED}MB"
echo ""
echo "  Proxima manutencao recomendada: $(date -v+7d '+%Y-%m-%d')"
echo "============================================"
