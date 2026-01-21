#!/bin/bash
#
# Script de Diagnóstico para Intel X520-DA2 com DAC
# Autor: Assistente Claude
# Uso: sudo ./diagnose-x520-dac.sh
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Diagnóstico Intel X520-DA2 com DAC${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Verificar se está a correr como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERRO: Este script deve ser executado como root (sudo)${NC}"
    exit 1
fi

# Função para verificar comandos
check_cmd() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}AVISO: $1 não encontrado, a instalar...${NC}"
        apt-get update && apt-get install -y $2
    fi
}

echo -e "${YELLOW}[1/8] Verificando sistema...${NC}"
echo "----------------------------------------"
uname -a
cat /etc/os-release | grep -E "^(NAME|VERSION)="
echo ""

echo -e "${YELLOW}[2/8] Verificando se a placa Intel X520 é detectada no PCI...${NC}"
echo "----------------------------------------"
check_cmd lspci pciutils

# Intel 82599 é o chip da X520
INTEL_NIC=$(lspci | grep -i "82599\|X520\|X540\|Intel.*10-Gigabit" || true)
if [ -z "$INTEL_NIC" ]; then
    echo -e "${RED}ERRO: Placa Intel X520/82599 NÃO detectada no barramento PCI!${NC}"
    echo ""
    echo "Possíveis causas:"
    echo "  - Placa não está bem encaixada no slot PCIe"
    echo "  - Slot PCIe com problema"
    echo "  - BIOS pode ter desativado o slot"
    echo ""
    echo "Todas as placas de rede detectadas:"
    lspci | grep -i ethernet || echo "Nenhuma placa de rede encontrada"
    exit 1
else
    echo -e "${GREEN}OK: Placa Intel detectada:${NC}"
    echo "$INTEL_NIC"
fi
echo ""

echo -e "${YELLOW}[3/8] Verificando módulo/driver ixgbe...${NC}"
echo "----------------------------------------"
IXGBE_LOADED=$(lsmod | grep ixgbe || true)
if [ -z "$IXGBE_LOADED" ]; then
    echo -e "${YELLOW}AVISO: Módulo ixgbe NÃO está carregado${NC}"
    echo "A tentar carregar o módulo..."
    modprobe ixgbe 2>&1 || echo -e "${RED}Falha ao carregar módulo ixgbe${NC}"
    IXGBE_LOADED=$(lsmod | grep ixgbe || true)
fi

if [ -n "$IXGBE_LOADED" ]; then
    echo -e "${GREEN}OK: Módulo ixgbe carregado:${NC}"
    echo "$IXGBE_LOADED"
else
    echo -e "${RED}ERRO: Módulo ixgbe não conseguiu carregar${NC}"
fi
echo ""

echo -e "${YELLOW}[4/8] Verificando interfaces de rede...${NC}"
echo "----------------------------------------"
ip link show
echo ""

# Verificar interfaces Intel
INTEL_IFACES=$(ip link show | grep -B1 "link/ether" | grep -E "^[0-9]+:" | awk -F: '{print $2}' | tr -d ' ')
echo "Interfaces disponíveis: $INTEL_IFACES"
echo ""

echo -e "${YELLOW}[5/8] Verificando estado dos transceivers SFP+/DAC...${NC}"
echo "----------------------------------------"
check_cmd ethtool ethtool

for iface in $INTEL_IFACES; do
    echo -e "${BLUE}--- Interface: $iface ---${NC}"

    # Verificar driver
    DRIVER=$(ethtool -i $iface 2>/dev/null | grep "driver:" || echo "N/A")
    echo "Driver: $DRIVER"

    # Só processar interfaces ixgbe
    if echo "$DRIVER" | grep -q "ixgbe"; then
        echo -e "${GREEN}Esta é uma interface Intel X520 (ixgbe)${NC}"

        # Estado do link
        LINK=$(ethtool $iface 2>/dev/null | grep "Link detected:" || echo "N/A")
        echo "Estado do Link: $LINK"

        # Velocidade suportada
        ethtool $iface 2>/dev/null | grep -E "Speed:|Duplex:|Auto-negotiation:" || true

        # Informação do módulo SFP/DAC
        echo ""
        echo "Informação do módulo SFP+/DAC:"
        ethtool -m $iface 2>/dev/null || echo -e "${YELLOW}Não foi possível ler informação do módulo (pode não haver DAC ligado)${NC}"
    fi
    echo ""
done

echo -e "${YELLOW}[6/8] Verificando logs do kernel para erros...${NC}"
echo "----------------------------------------"
echo "Últimas mensagens relacionadas com ixgbe/intel:"
dmesg | grep -i "ixgbe\|82599\|SFP\|failed\|error" | tail -30 || echo "Nenhuma mensagem encontrada"
echo ""

echo -e "${YELLOW}[7/8] Verificando se DAC não suportado está a bloquear...${NC}"
echo "----------------------------------------"
# Intel X520 por padrão só aceita módulos Intel ou certificados
# DACs de terceiros podem ser bloqueados

UNSUPPORTED_SFP=$(dmesg | grep -i "unsupported SFP\|failed to load" || true)
if [ -n "$UNSUPPORTED_SFP" ]; then
    echo -e "${RED}PROBLEMA ENCONTRADO: DAC/SFP não suportado detectado!${NC}"
    echo "$UNSUPPORTED_SFP"
    echo ""
    echo -e "${YELLOW}SOLUÇÃO: Permitir módulos SFP de terceiros${NC}"
    echo ""
    echo "Opção 1 - Temporária (até reiniciar):"
    echo "  echo 1 > /sys/class/net/INTERFACE/device/allow_unsupported_sfp"
    echo ""
    echo "Opção 2 - Permanente (via parâmetro do módulo):"
    echo "  echo 'options ixgbe allow_unsupported_sfp=1' > /etc/modprobe.d/ixgbe.conf"
    echo "  update-initramfs -u"
    echo "  reboot"
    echo ""

    # Perguntar se quer aplicar a correção
    read -p "Deseja aplicar a correção permanente agora? (s/n): " APPLY_FIX
    if [ "$APPLY_FIX" = "s" ] || [ "$APPLY_FIX" = "S" ]; then
        echo 'options ixgbe allow_unsupported_sfp=1' > /etc/modprobe.d/ixgbe.conf
        echo -e "${GREEN}Configuração criada em /etc/modprobe.d/ixgbe.conf${NC}"

        # Aplicar temporariamente também
        for iface in $(ls /sys/class/net/); do
            if [ -f "/sys/class/net/$iface/device/allow_unsupported_sfp" ]; then
                echo 1 > /sys/class/net/$iface/device/allow_unsupported_sfp 2>/dev/null || true
                echo "Permitido SFP não suportado em $iface"
            fi
        done

        echo ""
        echo -e "${YELLOW}A recarregar módulo ixgbe...${NC}"
        rmmod ixgbe 2>/dev/null || true
        modprobe ixgbe allow_unsupported_sfp=1
        sleep 2

        echo ""
        echo "Verificando interfaces após correção:"
        ip link show | grep -A1 "ixgbe\|enp\|eth" || ip link show
    fi
else
    echo -e "${GREEN}Nenhum erro de SFP não suportado encontrado nos logs${NC}"
fi
echo ""

echo -e "${YELLOW}[8/8] Resumo e Recomendações...${NC}"
echo "----------------------------------------"

# Verificar estado final
FINAL_CHECK=$(ip link show | grep -E "UP.*10000" || true)
if [ -n "$FINAL_CHECK" ]; then
    echo -e "${GREEN}SUCESSO: Interface 10GbE parece estar UP!${NC}"
else
    echo -e "${YELLOW}Interface pode ainda não estar ativa.${NC}"
    echo ""
    echo "Próximos passos para verificar:"
    echo "1. Verificar se o DAC está bem ligado nas duas pontas"
    echo "2. Verificar se o equipamento do outro lado está ligado"
    echo "3. Tentar outro DAC se possível"
    echo "4. Executar: ip link set INTERFACE up"
    echo "5. Se usar VLAN: ip link add link INTERFACE name INTERFACE.VLAN type vlan id NUMERO"
fi

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Diagnóstico Completo${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "Se o problema persistir, partilhe a saída deste script."
