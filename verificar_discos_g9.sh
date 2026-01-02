#!/bin/bash

# Script para verificar discos e partições no G9
# Execute este script NO COMPUTADOR G9 (Ubuntu Live)

echo "=================================================="
echo "  VERIFICAÇÃO DE DISCOS - COMPUTADOR G9"
echo "=================================================="
echo ""

echo "=== 1. DISCOS E PARTIÇÕES ==="
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
echo ""

echo "=== 2. INFORMAÇÕES DETALHADAS DOS DISCOS ==="
sudo fdisk -l
echo ""

echo "=== 3. PARTIÇÕES MONTADAS ATUALMENTE ==="
df -h
echo ""

echo "=== 4. TODAS AS MONTAGENS ==="
mount | grep -v "loop\|tmpfs\|udev"
echo ""

echo "=== 5. INFORMAÇÕES DE USO DO DISCO ==="
sudo lsblk -f
echo ""

echo "=================================================="
echo "COPIE A SAÍDA ACIMA E COMPARTILHE COMIGO"
echo "=================================================="
echo ""
echo "Vou te ajudar a identificar:"
echo "  - Qual disco usar para Home Assistant"
echo "  - Quais partições desmontar"
echo "  - Quais partições preservar (se houver dados importantes)"
echo ""
