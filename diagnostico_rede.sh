#!/bin/bash

# Script de Diagnóstico de Rede - Home Assistant G9
# Execute no seu computador (não no G9)

echo "=========================================="
echo "  DIAGNÓSTICO DE REDE - HOME ASSISTANT"
echo "=========================================="
echo ""

echo "1. TESTANDO PING PARA O G9 (192.168.0.84):"
ping -c 4 192.168.0.84
echo ""

echo "2. TESTANDO PORTA 8123 (Home Assistant):"
timeout 5 bash -c 'cat < /dev/null > /dev/tcp/192.168.0.84/8123' && echo "✅ PORTA 8123 ACESSÍVEL" || echo "❌ PORTA 8123 INACESSÍVEL"
echo ""

echo "3. VERIFICANDO ROTEADOR:"
ping -c 2 192.168.0.1
echo ""

echo "4. DISPOSITIVOS NA REDE (ARP):"
arp -a | grep 192.168.0
echo ""

echo "5. TESTANDO DNS:"
nslookup homeassistant.local 2>/dev/null || echo "DNS local não resolveu"
echo ""

echo "=========================================="
echo "COPIE TODA A SAÍDA ACIMA E ME ENVIE!"
echo "=========================================="
