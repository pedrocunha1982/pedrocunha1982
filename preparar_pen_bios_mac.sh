#!/bin/bash
# Dell BIOS Recovery - Preparar Pen USB (macOS)
# Service Tag: 7RB0XM3

echo "============================================"
echo " DELL BIOS RECOVERY - PREPARAR PEN USB"
echo " (macOS)"
echo "============================================"
echo ""

# Pedir Service Tag (com valor predefinido)
read -p "Introduz o Service Tag do Dell [7RB0XM3]: " SERVICETAG
SERVICETAG=${SERVICETAG:-7RB0XM3}
echo ""

# Listar discos externos (pens USB)
echo "Discos disponiveis (procura a tua pen USB):"
echo "--------------------------------------------"
diskutil list external
echo ""
echo "ATENCAO: Vai formatar a pen USB! Todos os dados serao apagados."
echo ""
read -p "Qual o disco da pen USB? (ex: disk2): " DISK
echo ""

# Validar que o disco existe e e externo
if ! diskutil info "/dev/$DISK" > /dev/null 2>&1; then
    echo "ERRO: Disco /dev/$DISK nao encontrado."
    exit 1
fi

# Confirmar antes de formatar
DISKSIZE=$(diskutil info "/dev/$DISK" | grep "Disk Size" | head -1)
DISKNAME=$(diskutil info "/dev/$DISK" | grep "Media Name" | head -1)
echo "Disco selecionado:"
echo "  $DISKNAME"
echo "  $DISKSIZE"
echo ""
read -p "TEM A CERTEZA que quer formatar /dev/$DISK? (sim/nao): " CONFIRMA
if [ "$CONFIRMA" != "sim" ]; then
    echo "Operacao cancelada."
    exit 0
fi

echo ""
echo "============================================"
echo " PASSO 1: Formatar pen em FAT32"
echo "============================================"
echo "A formatar /dev/$DISK em FAT32 (MS-DOS)..."
diskutil eraseDisk FAT32 DELLBIOS MBRFormat "/dev/$DISK"
if [ $? -ne 0 ]; then
    echo "ERRO: Nao foi possivel formatar. Verifica o disco."
    exit 1
fi
echo "Pen formatada com sucesso!"
echo ""

# Encontrar ponto de montagem
MOUNTPOINT="/Volumes/DELLBIOS"
if [ ! -d "$MOUNTPOINT" ]; then
    echo "ERRO: Pen nao foi montada em $MOUNTPOINT"
    echo "A procurar ponto de montagem..."
    MOUNTPOINT=$(diskutil info "/dev/${DISK}s1" 2>/dev/null | grep "Mount Point" | sed 's/.*: *//')
    if [ -z "$MOUNTPOINT" ] || [ ! -d "$MOUNTPOINT" ]; then
        echo "ERRO: Nao consegui encontrar o ponto de montagem da pen."
        exit 1
    fi
fi
echo "Pen montada em: $MOUNTPOINT"
echo ""

echo "============================================"
echo " PASSO 2: Descarregar BIOS"
echo "============================================"
echo ""
echo "A abrir a pagina de download da Dell para o Service Tag: $SERVICETAG"
echo ""
echo "INSTRUCOES:"
echo "  1. O browser vai abrir com a pagina do teu Dell"
echo "  2. Clica em 'Controladores e transferencias' (Drivers & Downloads)"
echo "  3. Filtra por categoria 'BIOS'"
echo "  4. Faz download do ficheiro .exe mais recente"
echo "  5. Quando o download terminar, volta aqui"
echo ""
open "https://www.dell.com/support/home/product-support/servicetag/${SERVICETAG}/drivers"
echo ""
echo "Quando o download terminar, arrasta o ficheiro .exe para esta janela"
echo "ou escreve o caminho completo (normalmente em ~/Downloads/):"
echo ""
read -p "Caminho do ficheiro BIOS .exe: " BIOSFILE

# Remover aspas e espacos extras do caminho
BIOSFILE=$(echo "$BIOSFILE" | sed "s/^['\"]//;s/['\"]$//;s/^ *//;s/ *$//")

# Verificar se ficheiro existe
if [ ! -f "$BIOSFILE" ]; then
    echo "ERRO: Ficheiro '$BIOSFILE' nao encontrado."
    echo ""
    echo "Dica: Procura na pasta Downloads:"
    ls -la ~/Downloads/*.exe 2>/dev/null || echo "  (nenhum .exe encontrado em Downloads)"
    exit 1
fi

echo ""
echo "============================================"
echo " PASSO 3: Copiar e renomear para a pen"
echo "============================================"
echo "A copiar e renomear para $MOUNTPOINT/BIOS_IMG.rcv ..."
cp "$BIOSFILE" "$MOUNTPOINT/BIOS_IMG.rcv"
if [ $? -ne 0 ]; then
    echo "ERRO: Nao foi possivel copiar. Verifica o caminho."
    exit 1
fi
echo ""

# Verificar
echo "============================================"
echo " TUDO PRONTO!"
echo "============================================"
echo ""
echo "Verificacao - ficheiro na pen:"
ls -la "$MOUNTPOINT/BIOS_IMG.rcv"
echo ""
echo "Agora no Dell avariado:"
echo "  1. Desliga o Dell"
echo "  2. Insere a pen USB (porta PRETA, nao azul)"
echo "  3. Usa o teclado integrado do portatil"
echo "  4. Mantem premido Ctrl + Esc"
echo "  5. Liga o computador pelo botao power"
echo "  6. Mantem premido durante 30 segundos"
echo "  7. Espera a recuperacao terminar (NAO desligues!)"
echo ""
echo "A ejetar a pen USB de forma segura..."
diskutil eject "/dev/$DISK"
echo ""
echo "Pen ejetada. Podes remover e usar no Dell avariado."
echo ""
