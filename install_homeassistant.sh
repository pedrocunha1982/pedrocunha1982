#!/bin/bash

# Script de Instalação do Home Assistant OS no Computador G9
# Executar a partir de um Ubuntu Live USB

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cor
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Banner
echo "=================================================="
echo "  Instalador do Home Assistant OS - Computador G9"
echo "=================================================="
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    print_error "Por favor, execute com sudo:"
    echo "  sudo $0"
    exit 1
fi

# Verificar conexão com internet
print_info "Verificando conexão com a internet..."
if ! ping -c 1 -W 2 google.com &> /dev/null; then
    print_error "Sem conexão com a internet. Conecte-se e tente novamente."
    exit 1
fi
print_success "Conexão com internet OK"

# Verificar se wget está instalado
if ! command -v wget &> /dev/null; then
    print_info "Instalando wget..."
    apt-get update && apt-get install -y wget
fi

# Mostrar discos disponíveis
print_info "Discos disponíveis no sistema:"
echo ""
lsblk -d -o NAME,SIZE,TYPE,MODEL | grep disk
echo ""

# Solicitar disco de destino
print_warning "ATENÇÃO: Todos os dados do disco selecionado serão APAGADOS!"
echo ""
read -p "Digite o disco de destino (ex: sda, nvme0n1): " DISK_NAME

# Validar entrada
if [ -z "$DISK_NAME" ]; then
    print_error "Disco não especificado. Saindo."
    exit 1
fi

DISK_PATH="/dev/$DISK_NAME"

if [ ! -b "$DISK_PATH" ]; then
    print_error "Disco $DISK_PATH não encontrado!"
    exit 1
fi

# Mostrar informações do disco selecionado
print_info "Disco selecionado:"
lsblk "$DISK_PATH"
echo ""

# Confirmação final
print_warning "Você está prestes a APAGAR TODOS OS DADOS de $DISK_PATH"
read -p "Digite 'SIM' em MAIÚSCULAS para confirmar: " CONFIRMATION

if [ "$CONFIRMATION" != "SIM" ]; then
    print_info "Instalação cancelada pelo usuário."
    exit 0
fi

# Desmontar partições do disco se estiverem montadas
print_info "Desmontando partições do disco..."
umount ${DISK_PATH}* 2>/dev/null || true
print_success "Partições desmontadas"

# Criar diretório temporário
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
print_info "Diretório temporário: $TEMP_DIR"

# Obter a versão mais recente do Home Assistant OS
print_info "Obtendo informações da versão mais recente..."
LATEST_VERSION=$(wget -qO- https://api.github.com/repos/home-assistant/operating-system/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    print_warning "Não foi possível obter a versão mais recente automaticamente."
    LATEST_VERSION="13.2"
    print_info "Usando versão padrão: $LATEST_VERSION"
else
    print_success "Versão mais recente: $LATEST_VERSION"
fi

# URL de download
IMAGE_NAME="haos_generic-x86-64-${LATEST_VERSION}.img.xz"
DOWNLOAD_URL="https://github.com/home-assistant/operating-system/releases/download/${LATEST_VERSION}/${IMAGE_NAME}"

# Baixar imagem
print_info "Baixando Home Assistant OS ${LATEST_VERSION}..."
print_info "URL: $DOWNLOAD_URL"
print_info "Isso pode demorar alguns minutos dependendo da sua conexão..."

if ! wget --progress=bar:force "$DOWNLOAD_URL" 2>&1 | tee /tmp/wget.log; then
    print_error "Falha no download!"
    print_info "Tentando URL alternativa..."
    # Versão fallback
    LATEST_VERSION="13.2"
    IMAGE_NAME="haos_generic-x86-64-${LATEST_VERSION}.img.xz"
    DOWNLOAD_URL="https://github.com/home-assistant/operating-system/releases/download/${LATEST_VERSION}/${IMAGE_NAME}"
    wget --progress=bar:force "$DOWNLOAD_URL"
fi

print_success "Download concluído!"

# Extrair imagem
print_info "Extraindo imagem..."
unxz -v "$IMAGE_NAME"
IMAGE_FILE="${IMAGE_NAME%.xz}"
print_success "Extração concluída!"

# Gravar no disco
print_info "Gravando imagem no disco $DISK_PATH..."
print_warning "Este processo pode demorar 5-15 minutos. NÃO interrompa!"
dd if="$IMAGE_FILE" of="$DISK_PATH" bs=4M status=progress conv=fsync

print_success "Gravação concluída!"

# Sincronizar
print_info "Sincronizando dados..."
sync
print_success "Sincronização concluída!"

# Limpar arquivos temporários
print_info "Limpando arquivos temporários..."
cd ~
rm -rf "$TEMP_DIR"
print_success "Limpeza concluída!"

# Conclusão
echo ""
echo "=================================================="
print_success "INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "=================================================="
echo ""
print_info "Próximos passos:"
echo "  1. Remova o pendrive USB do Ubuntu Live"
echo "  2. Execute: sudo reboot"
echo "  3. O computador irá bootar do disco $DISK_PATH"
echo "  4. Aguarde 5-20 minutos no primeiro boot"
echo "  5. Acesse http://homeassistant.local:8123"
echo "     ou http://IP_DO_G9:8123"
echo ""
print_warning "Se não bootar, verifique a ordem de boot na BIOS"
echo ""

read -p "Deseja reiniciar agora? (s/N): " REBOOT_NOW
if [[ "$REBOOT_NOW" =~ ^[Ss]$ ]]; then
    print_info "Reiniciando em 5 segundos..."
    sleep 5
    reboot
else
    print_info "Reinicie manualmente quando estiver pronto: sudo reboot"
fi
