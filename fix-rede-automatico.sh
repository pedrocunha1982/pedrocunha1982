#!/bin/bash
#
# SCRIPT DE CORREÇÃO AUTOMÁTICA DE REDE
# Autor: Claude (sessão fix-network-connectivity)
# Data: 2026-03-01
#
# Este script diagnostica e corrige automaticamente os problemas de rede
# causados pela configuração anterior do AdGuard Home + Tailscale
#
# USO: sudo bash fix-rede-automatico.sh
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  CORREÇÃO AUTOMÁTICA DE REDE - Pedro Cunha${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Detetar SO
OS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo -e "${YELLOW}SO não reconhecido: $OSTYPE${NC}"
    OS="linux"
fi

echo -e "${YELLOW}[1/6] Verificando DNS atual...${NC}"
echo "-------------------------------------------"

if [ "$OS" = "mac" ]; then
    DNS_SERVERS=$(scutil --dns 2>/dev/null | grep "nameserver" | head -5 || echo "Não conseguiu ler DNS")
else
    DNS_SERVERS=$(cat /etc/resolv.conf 2>/dev/null | grep nameserver || echo "Não conseguiu ler DNS")
fi

echo "$DNS_SERVERS"
echo ""

# Verificar se o DNS aponta para o G9 (192.168.0.84)
if echo "$DNS_SERVERS" | grep -q "192.168.0.84"; then
    echo -e "${RED}PROBLEMA ENCONTRADO: Teu DNS aponta para o G9 (192.168.0.84)!${NC}"
    echo -e "${RED}Se o G9 estiver offline, NADA funciona na rede.${NC}"
    DNS_PROBLEM="g9"
elif echo "$DNS_SERVERS" | grep -q "100.100.100.100"; then
    echo -e "${RED}PROBLEMA ENCONTRADO: Teu DNS aponta para o Tailscale (100.100.100.100)!${NC}"
    echo -e "${RED}Tailscale está a interceptar todo o teu tráfego DNS.${NC}"
    DNS_PROBLEM="tailscale"
else
    echo -e "${GREEN}DNS não aponta para o G9 nem para o Tailscale.${NC}"
    DNS_PROBLEM="none"
fi
echo ""

echo -e "${YELLOW}[2/6] Testando resolução DNS...${NC}"
echo "-------------------------------------------"

# Testar DNS atual
DNS_WORKS=false
if command -v nslookup &>/dev/null; then
    if timeout 5 nslookup google.com &>/dev/null; then
        echo -e "${GREEN}DNS atual funciona (google.com resolveu)${NC}"
        DNS_WORKS=true
    else
        echo -e "${RED}DNS atual NÃO funciona (google.com não resolveu)${NC}"
    fi
elif command -v dig &>/dev/null; then
    if timeout 5 dig google.com +short &>/dev/null; then
        echo -e "${GREEN}DNS atual funciona${NC}"
        DNS_WORKS=true
    else
        echo -e "${RED}DNS atual NÃO funciona${NC}"
    fi
elif command -v host &>/dev/null; then
    if timeout 5 host google.com &>/dev/null; then
        echo -e "${GREEN}DNS atual funciona${NC}"
        DNS_WORKS=true
    else
        echo -e "${RED}DNS atual NÃO funciona${NC}"
    fi
else
    # Tentar com ping
    if ping -c 1 -W 3 google.com &>/dev/null; then
        echo -e "${GREEN}DNS funciona (ping google.com resolveu)${NC}"
        DNS_WORKS=true
    else
        echo -e "${RED}DNS NÃO funciona${NC}"
    fi
fi

# Testar se DNS do Google funciona diretamente
echo ""
echo "Testando DNS alternativo (Google 8.8.8.8)..."
if command -v nslookup &>/dev/null; then
    if timeout 5 nslookup google.com 8.8.8.8 &>/dev/null; then
        echo -e "${GREEN}DNS do Google (8.8.8.8) funciona!${NC}"
        GOOGLE_DNS_WORKS=true
    else
        echo -e "${RED}DNS do Google (8.8.8.8) NÃO funciona${NC}"
        GOOGLE_DNS_WORKS=false
    fi
else
    GOOGLE_DNS_WORKS=true  # Assumir que funciona se não temos nslookup
fi
echo ""

echo -e "${YELLOW}[3/6] Testando conectividade básica...${NC}"
echo "-------------------------------------------"

# Ping ao gateway
echo -n "Gateway (192.168.0.1): "
if ping -c 2 -W 3 192.168.0.1 &>/dev/null; then
    echo -e "${GREEN}OK${NC}"
    GATEWAY_OK=true
else
    echo -e "${RED}FALHOU${NC}"
    GATEWAY_OK=false
fi

# Ping ao G9
echo -n "G9 Home Assistant (192.168.0.84): "
if ping -c 2 -W 3 192.168.0.84 &>/dev/null; then
    echo -e "${GREEN}OK (G9 está online)${NC}"
    G9_OK=true
else
    echo -e "${YELLOW}NÃO RESPONDE (G9 pode estar offline)${NC}"
    G9_OK=false
fi

# Ping externo por IP (sem precisar de DNS)
echo -n "Internet (8.8.8.8): "
if ping -c 2 -W 5 8.8.8.8 &>/dev/null; then
    echo -e "${GREEN}OK (internet funciona)${NC}"
    INTERNET_OK=true
else
    echo -e "${RED}FALHOU (sem internet)${NC}"
    INTERNET_OK=false
fi
echo ""

echo -e "${YELLOW}[4/6] Verificando Tailscale...${NC}"
echo "-------------------------------------------"

TAILSCALE_RUNNING=false
if command -v tailscale &>/dev/null; then
    TS_STATUS=$(tailscale status 2>&1 || true)
    if echo "$TS_STATUS" | grep -qi "logged in\|connected\|online"; then
        echo -e "${YELLOW}Tailscale está ATIVO neste computador!${NC}"
        echo "$TS_STATUS" | head -10
        TAILSCALE_RUNNING=true
    else
        echo -e "${GREEN}Tailscale instalado mas não está ativo${NC}"
    fi
else
    echo -e "${GREEN}Tailscale não está instalado neste computador${NC}"
fi
echo ""

echo -e "${YELLOW}[5/6] Testando velocidade básica...${NC}"
echo "-------------------------------------------"

if command -v curl &>/dev/null; then
    echo "Fazendo download de teste..."
    SPEED=$(curl -s -o /dev/null -w "%{speed_download}" --connect-timeout 10 --max-time 15 http://speedtest.tele2.net/1MB.zip 2>/dev/null || echo "0")
    if [ "$SPEED" != "0" ] && [ -n "$SPEED" ]; then
        SPEED_MB=$(echo "$SPEED" | awk '{printf "%.2f", $1/1048576}')
        echo -e "Velocidade: ${BLUE}${SPEED_MB} MB/s${NC}"
        SPEED_NUM=$(echo "$SPEED" | awk '{printf "%d", $1}')
        if [ "$SPEED_NUM" -lt 100000 ]; then
            echo -e "${RED}Velocidade MUITO BAIXA (< 100 KB/s)${NC}"
        elif [ "$SPEED_NUM" -lt 1000000 ]; then
            echo -e "${YELLOW}Velocidade BAIXA (< 1 MB/s)${NC}"
        else
            echo -e "${GREEN}Velocidade OK${NC}"
        fi
    else
        echo -e "${RED}Não conseguiu fazer download de teste${NC}"
    fi
else
    echo "curl não disponível, pulando teste de velocidade"
fi
echo ""

echo -e "${YELLOW}[6/6] DIAGNÓSTICO E CORREÇÃO${NC}"
echo "==========================================="
echo ""

# Diagnóstico principal
if [ "$INTERNET_OK" = false ] && [ "$GATEWAY_OK" = false ]; then
    echo -e "${RED}DIAGNÓSTICO: Sem conectividade de rede nenhuma.${NC}"
    echo ""
    echo "Possíveis causas:"
    echo "  - WiFi desconectado"
    echo "  - Cabo de rede desligado"
    echo "  - Roteador desligado"
    echo ""
    if [ "$OS" = "mac" ]; then
        echo "A verificar WiFi..."
        networksetup -getairportnetwork en0 2>/dev/null || echo "Não conseguiu verificar WiFi"
    else
        echo "A verificar interfaces..."
        ip link show 2>/dev/null | grep -E "state UP|state DOWN" || nmcli device status 2>/dev/null || echo "Não conseguiu verificar interfaces"
    fi

elif [ "$INTERNET_OK" = true ] && [ "$DNS_WORKS" = false ]; then
    echo -e "${RED}======================================================${NC}"
    echo -e "${RED}  DIAGNÓSTICO: Internet funciona mas DNS está partido!${NC}"
    echo -e "${RED}======================================================${NC}"
    echo ""
    echo "Isto é EXACTAMENTE o que acontece quando o AdGuard Home no G9"
    echo "está a ser usado como DNS da rede e o G9 caiu."
    echo ""
    echo -e "${GREEN}CORRIGINDO AUTOMATICAMENTE...${NC}"
    echo ""

    if [ "$OS" = "mac" ]; then
        # No macOS, mudar DNS para Google temporariamente
        WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' || echo "en0")
        echo "A mudar DNS do WiFi ($WIFI_INTERFACE) para Google (8.8.8.8, 8.8.4.4)..."
        sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4
        echo -e "${GREEN}DNS alterado para Google!${NC}"
        echo ""
        echo "A limpar cache de DNS..."
        sudo dscacheutil -flushcache 2>/dev/null || true
        sudo killall -HUP mDNSResponder 2>/dev/null || true
        echo -e "${GREEN}Cache DNS limpo!${NC}"
    else
        # No Linux
        echo "A adicionar DNS do Google ao sistema..."
        if command -v nmcli &>/dev/null; then
            # NetworkManager
            ACTIVE_CONN=$(nmcli -t -f NAME con show --active | head -1)
            if [ -n "$ACTIVE_CONN" ]; then
                sudo nmcli con mod "$ACTIVE_CONN" ipv4.dns "8.8.8.8 8.8.4.4"
                sudo nmcli con mod "$ACTIVE_CONN" ipv4.ignore-auto-dns yes
                sudo nmcli con down "$ACTIVE_CONN" && sudo nmcli con up "$ACTIVE_CONN"
                echo -e "${GREEN}DNS alterado para Google via NetworkManager!${NC}"
            fi
        else
            # Direto no resolv.conf
            sudo cp /etc/resolv.conf /etc/resolv.conf.backup.$(date +%Y%m%d%H%M%S)
            echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 192.168.0.1" | sudo tee /etc/resolv.conf
            echo -e "${GREEN}DNS alterado para Google!${NC}"
        fi
    fi
    echo ""
    echo "Testando se a internet voltou..."
    sleep 2
    if ping -c 2 -W 3 google.com &>/dev/null; then
        echo -e "${GREEN}INTERNET RESTAURADA!${NC}"
    else
        echo -e "${YELLOW}Ainda com problemas. Pode levar alguns segundos...${NC}"
    fi

elif [ "$INTERNET_OK" = true ] && [ "$DNS_WORKS" = true ]; then
    echo -e "${GREEN}Internet e DNS estão a funcionar neste momento.${NC}"
    echo ""

    if [ "$DNS_PROBLEM" = "g9" ]; then
        echo -e "${YELLOW}AVISO: O teu DNS ainda aponta para o G9 (192.168.0.84).${NC}"
        echo "Se o G9 cair, a internet vai parar novamente."
        echo ""
        echo "Recomendação: Mudar o DNS no roteador para usar"
        echo "o Google (8.8.8.8) como DNS primário e o G9 como secundário."
    fi

    if [ "$DNS_PROBLEM" = "tailscale" ]; then
        echo -e "${YELLOW}AVISO: Tailscale está a controlar o teu DNS.${NC}"
        echo "Isto pode causar lentidão. Para desativar:"
        echo "  tailscale down"
    fi

    if [ "$TAILSCALE_RUNNING" = true ]; then
        echo -e "${YELLOW}AVISO: Tailscale está ativo e pode estar a afetar${NC}"
        echo -e "${YELLOW}a velocidade e o routing da rede.${NC}"
        echo ""
        echo "Para testar se o Tailscale é o problema:"
        echo "  sudo tailscale down"
        echo "  # testar a internet"
        echo "  sudo tailscale up  # para voltar a ligar"
    fi
fi

echo ""
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}  RESUMO DO QUE FOI FEITO${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""
echo "Gateway (192.168.0.1):     $([ "$GATEWAY_OK" = true ] && echo -e "${GREEN}OK${NC}" || echo -e "${RED}FALHOU${NC}")"
echo "G9 (192.168.0.84):         $([ "$G9_OK" = true ] && echo -e "${GREEN}ONLINE${NC}" || echo -e "${YELLOW}OFFLINE${NC}")"
echo "Internet (8.8.8.8):        $([ "$INTERNET_OK" = true ] && echo -e "${GREEN}OK${NC}" || echo -e "${RED}FALHOU${NC}")"
echo "DNS:                       $([ "$DNS_WORKS" = true ] && echo -e "${GREEN}OK${NC}" || echo -e "${RED}PARTIDO${NC}")"
echo "Tailscale:                 $([ "$TAILSCALE_RUNNING" = true ] && echo -e "${YELLOW}ATIVO${NC}" || echo -e "${GREEN}Inativo${NC}")"
echo ""

if [ "$DNS_PROBLEM" != "none" ] || [ "$DNS_WORKS" = false ]; then
    echo -e "${YELLOW}PARA CORRIGIR NO ROTEADOR (correção permanente):${NC}"
    echo "1. Abrir http://192.168.0.1 no browser"
    echo "2. Advanced → Network → DHCP Server"
    echo "3. Primary DNS: 8.8.8.8"
    echo "4. Secondary DNS: 192.168.0.1"
    echo "5. NÃO usar 192.168.0.84 como DNS"
    echo ""
    echo "Isto garante que mesmo que o G9 caia, a internet continua."
fi

echo ""
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}  DIAGNÓSTICO COMPLETO${NC}"
echo -e "${BLUE}==========================================${NC}"
