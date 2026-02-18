#!/bin/bash
# ============================================================================
# SETUP MAC STUDIO COMO SERVIDOR CENTRAL APPLE
# ============================================================================
# Executa no Mac Studio via Terminal com: sudo bash setup-mac-studio-server.sh
#
# Servicos configurados:
#   - Screen Sharing (Remote Desktop)
#   - SSH (Remote Login)
#   - File Sharing (SMB)
#   - Content Caching (updates Apple para toda a rede)
#   - Time Machine Server (backup de devices da rede)
#   - AirDrop/Handoff/Continuity (ecossistema Apple)
# ============================================================================

set -euo pipefail

# --- CORES ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERRO]${NC} $1"; }
info() { echo -e "${BLUE}[i]${NC} $1"; }

# --- PRE-FLIGHT ---
if [ "$EUID" -ne 0 ]; then
    err "Execute com sudo: sudo bash $0"
    exit 1
fi

CONSOLE_USER=$(stat -f "%Su" /dev/console 2>/dev/null)
if [ -z "$CONSOLE_USER" ]; then
    err "Nao foi possivel detectar o usuario logado"
    exit 1
fi

echo ""
echo "============================================"
echo "  MAC STUDIO - SETUP SERVIDOR CENTRAL"
echo "============================================"
echo "  Usuario: $CONSOLE_USER"
echo "  macOS:   $(sw_vers -productVersion)"
echo "  Host:    $(hostname)"
echo "============================================"
echo ""

# ============================================================================
# 1. NOME DO COMPUTADOR
# ============================================================================
info "Configurando nome do computador..."

MAC_NAME="MacStudio-Server"
SAFE_NAME="MacStudio-Server"

scutil --set ComputerName  "$MAC_NAME"
scutil --set HostName      "$MAC_NAME"
scutil --set LocalHostName "$SAFE_NAME"

log "Nome: $MAC_NAME"

# ============================================================================
# 2. SCREEN SHARING (REMOTE DESKTOP)
# ============================================================================
info "Ativando Screen Sharing..."

# Criar grupo de acesso se nao existir
dseditgroup -o create -n "/Local/Default" -r "Screen Sharing Users" -T group com.apple.access_screensharing 2>/dev/null || true
dseditgroup -o edit -n "/Local/Default" -a "$CONSOLE_USER" -t user com.apple.access_screensharing 2>/dev/null || true

# Ativar Screen Sharing via launchctl
launchctl enable system/com.apple.screensharing 2>/dev/null || true
launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist 2>/dev/null || true

# Configurar VNC para acesso de dispositivos Apple
defaults write /Library/Preferences/com.apple.RemoteManagement VNCAlwaysStartOnConsole -bool true 2>/dev/null || true

log "Screen Sharing ativado (porta 5900)"
log "Acesso restrito ao usuario: $CONSOLE_USER"

# ============================================================================
# 3. SSH (REMOTE LOGIN)
# ============================================================================
info "Ativando SSH..."

# Criar grupo de acesso SSH
dseditgroup -o create -n "/Local/Default" -r "Remote Login Users" -T group com.apple.access_ssh 2>/dev/null || true
dseditgroup -o edit -n "/Local/Default" -a "$CONSOLE_USER" -t user com.apple.access_ssh 2>/dev/null || true

# Ativar SSH
systemsetup -setremotelogin on 2>/dev/null || launchctl enable system/com.apple.sshd 2>/dev/null || true

log "SSH ativado (porta 22)"

# ============================================================================
# 4. FILE SHARING (SMB)
# ============================================================================
info "Ativando File Sharing (SMB)..."

# Ativar SMB
launchctl enable system/com.apple.smbd 2>/dev/null || true
launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist 2>/dev/null || true

# Desativar acesso de convidados (seguranca)
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Configurar nome do servidor SMB
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$SAFE_NAME"
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "Mac Studio - Servidor Central"

log "SMB ativado - Guest desativado por seguranca"

# Criar pastas compartilhadas se nao existirem
SHARE_BASE="/Users/Shared/Studio"
mkdir -p "$SHARE_BASE/Projetos"
mkdir -p "$SHARE_BASE/Recursos"
mkdir -p "$SHARE_BASE/Backups"
mkdir -p "$SHARE_BASE/Downloads"
chmod -R 770 "$SHARE_BASE"
chown -R "$CONSOLE_USER:staff" "$SHARE_BASE"

log "Pastas compartilhadas criadas em $SHARE_BASE"
info "  - $SHARE_BASE/Projetos"
info "  - $SHARE_BASE/Recursos"
info "  - $SHARE_BASE/Backups"
info "  - $SHARE_BASE/Downloads"

# Adicionar shares ao SMB (sharing command)
# Nota: Em macOS moderno, pode precisar configurar via System Settings > Sharing
sharing -a "$SHARE_BASE/Projetos" -S "Projetos" -s 001 -g 000 2>/dev/null || warn "Configure Projetos manualmente em Settings > Sharing"
sharing -a "$SHARE_BASE/Recursos" -S "Recursos" -s 001 -g 000 2>/dev/null || warn "Configure Recursos manualmente em Settings > Sharing"
sharing -a "$SHARE_BASE/Downloads" -S "Downloads" -s 001 -g 000 2>/dev/null || warn "Configure Downloads manualmente em Settings > Sharing"

# ============================================================================
# 5. CONTENT CACHING (UPDATES APPLE PARA TODA REDE)
# ============================================================================
info "Configurando Content Caching..."

CACHE_PLIST="/Library/Preferences/com.apple.AssetCache.plist"

# Desativar primeiro para configurar
AssetCacheManagerUtil deactivate 2>/dev/null || true

# Configurar: cache compartilhado (updates iOS/macOS), sem cache pessoal (iCloud)
sudo -u _assetcache defaults write "$CACHE_PLIST" AllowPersonalCaching -bool false
sudo -u _assetcache defaults write "$CACHE_PLIST" AllowSharedCaching -bool true

# Range da rede local (ajuste conforme sua rede)
sudo -u _assetcache defaults write "$CACHE_PLIST" ListenRanges '( { first = "192.168.0.1"; last = "192.168.0.254"; } )'
sudo -u _assetcache defaults write "$CACHE_PLIST" ListenRangesOnly -bool true

# Ativar
AssetCacheManagerUtil activate 2>/dev/null || warn "Ative Content Caching manualmente: Settings > General > Sharing > Content Caching"

log "Content Caching configurado para rede 192.168.0.x"
info "Updates de iOS/macOS serao cacheados no Mac Studio"

# ============================================================================
# 6. TIME MACHINE SERVER (BACKUP DE DEVICES DA REDE)
# ============================================================================
info "Configurando Time Machine Server..."

TM_SHARE="/Users/Shared/Studio/Backups/TimeMachine"
mkdir -p "$TM_SHARE"
chmod 770 "$TM_SHARE"
chown "$CONSOLE_USER:staff" "$TM_SHARE"

# Compartilhar como destino Time Machine
sharing -a "$TM_SHARE" -S "TimeMachine" -s 001 -g 000 2>/dev/null || true

# Marcar como destino Time Machine (Advanced Options)
# Nota: em macOS moderno, isso pode precisar ser feito via GUI:
# System Settings > General > Sharing > File Sharing > (i) em TimeMachine > Advanced > "Share as Time Machine backup destination"
defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup -bool true 2>/dev/null || true

log "Pasta TimeMachine criada em $TM_SHARE"
warn "IMPORTANTE: Va em Settings > Sharing > File Sharing > TimeMachine > Advanced"
warn "           e ative 'Share as Time Machine backup destination'"

# ============================================================================
# 7. FIREWALL
# ============================================================================
info "Configurando Firewall..."

# Ativar firewall mas permitir servicos assinados
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on 2>/dev/null || true
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned enable 2>/dev/null || true
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off 2>/dev/null || true

log "Firewall ativado (servicos assinados Apple permitidos)"

# ============================================================================
# 8. OTIMIZACOES DE SERVIDOR
# ============================================================================
info "Aplicando otimizacoes de servidor..."

# Desativar sleep (servidor precisa ficar ligado)
systemsetup -setcomputersleep Never 2>/dev/null || \
    pmset -a sleep 0 displaysleep 15 disksleep 0 2>/dev/null || true

# Desativar screensaver com senha (para acesso remoto)
# O usuario principal ja esta protegido por senha de login
defaults write /Library/Preferences/com.apple.screensaver askForPassword -int 0 2>/dev/null || true

# Ativar wake on network access
pmset -a womp 1 2>/dev/null || true

# Power failure: reiniciar automaticamente
pmset -a autorestart 1 2>/dev/null || true

log "Sleep desativado, Wake-on-LAN ativado, auto-restart em power failure"

# ============================================================================
# 9. BONJOUR / AVAHI (DESCOBERTA NA REDE)
# ============================================================================
info "Verificando Bonjour..."

# Bonjour ja vem ativado no macOS, mas garantir
defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool false 2>/dev/null || true

log "Bonjour ativo - devices Apple vao descobrir o servidor automaticamente"

# ============================================================================
# RESUMO
# ============================================================================
echo ""
echo "============================================"
echo "  SETUP COMPLETO!"
echo "============================================"
echo ""
echo "  Servicos ativos no Mac Studio:"
echo "  --------------------------------"
echo "  Screen Sharing:   vnc://$(hostname).local"
echo "  SSH:              ssh $CONSOLE_USER@$(hostname).local"
echo "  File Sharing:     smb://$(hostname).local"
echo "  Content Caching:  Automatico para rede 192.168.0.x"
echo "  Time Machine:     smb://$(hostname).local/TimeMachine"
echo ""
echo "  Pastas compartilhadas:"
echo "  --------------------------------"
echo "  smb://$(hostname).local/Projetos"
echo "  smb://$(hostname).local/Recursos"
echo "  smb://$(hostname).local/Downloads"
echo "  smb://$(hostname).local/TimeMachine"
echo ""
echo "  ACOES MANUAIS NECESSARIAS:"
echo "  --------------------------------"
echo "  1. Settings > General > Sharing > File Sharing"
echo "     -> TimeMachine -> Advanced -> 'Share as Time Machine backup'"
echo "  2. Instalar perfis .mobileconfig nos devices clientes"
echo "  3. Configurar emails nos devices (ver perfil de email)"
echo ""
echo "============================================"
