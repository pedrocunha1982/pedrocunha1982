# Diagnóstico de Problemas de Rede - Março 2026

## O que aconteceu?

Em sessões anteriores, o Claude configurou/recomendou várias mudanças na tua rede que, **combinadas**, podem causar que **todos os dispositivos** (computador, telefone, etc.) percam ou fiquem com internet lenta.

## Causa mais provável

### AdGuard Home como DNS da rede

O Claude recomendou instalar o **AdGuard Home** no G9 (192.168.0.84) como bloqueador de anúncios para toda a rede. Se o roteador foi configurado para usar o G9 como servidor DNS:

```
Roteador (192.168.0.1) → DNS: 192.168.0.84 (G9)
```

**Quando o G9 cai** (e ele tem histórico de problemas de rede):
- Nenhum dispositivo consegue resolver nomes DNS
- Sites não abrem (parece que a internet caiu)
- Tudo "trava"
- Afeta TODOS os dispositivos: computador, telefone, tablet

### Tailscale com accept_dns

O Claude também configurou o Tailscale no G9 com `accept_dns: true`, que pode interferir com a resolução DNS normal.

## O que verificar

### No roteador (http://192.168.0.1)
- Advanced → Network → DHCP Server
- Se o DNS primário está como `192.168.0.84` → esse é o problema
- Mudar para `8.8.8.8` (Google DNS) ou `1.1.1.1` (Cloudflare DNS)

### No G9 (se acessível)
- Verificar se o AdGuard Home está a correr
- Verificar se o Tailscale está a interferir

## Correção rápida

Executar no computador (Mac ou Linux):
```bash
sudo bash fix-rede-automatico.sh
```

Este script:
1. Detecta se o DNS aponta para o G9
2. Testa se o DNS está a funcionar
3. Corrige automaticamente mudando para DNS do Google
4. Limpa o cache de DNS

## Correção permanente no roteador

1. Aceder a http://192.168.0.1
2. Advanced → Network → DHCP Server
3. **Primary DNS**: `8.8.8.8`
4. **Secondary DNS**: `8.8.4.4`
5. Guardar

Isto garante que mesmo com o G9 offline, a internet funciona.

Se quiser manter o AdGuard Home:
- Primary DNS: `192.168.0.84` (AdGuard no G9)
- Secondary DNS: `8.8.8.8` (fallback para Google)

Assim, se o G9 cair, os dispositivos usam o Google como backup.

## Histórico de mudanças feitas pelo Claude

| Sessão | O que foi feito | Risco para rede |
|--------|----------------|-----------------|
| g9-computer-setup | Documentação de rede, recomendou AdGuard Home, configs de rede | **ALTO** - AdGuard como DNS pode derrubar toda a rede |
| fix-home-assistant-access | Tailscale com accept_dns=true, advertise_routes=local_subnets | **MÉDIO** - Pode interceptar DNS e routing |
| fix-10gig-nic-dac | Script para Intel X520 que modifica módulo ixgbe do kernel | **MÉDIO** - Pode afetar NIC 10G se executado |
| configure-bios-linux-live | Guias de BIOS e instalação do HA | **BAIXO** - Apenas documentação |
| verify-local-environment | Inventário de equipamentos | **BAIXO** - Apenas documentação |
| review-claudeflare-desktop | Removeu README template | **NENHUM** |

## Sobre diagnosticar o telefone

O Claude não tem acesso direto a dispositivos locais (computador, telefone, roteador). Mas se **ambos** computador e telefone estão com internet lenta/travada, o problema é na **rede** (DNS/roteador), não nos dispositivos individuais. A correção no roteador (mudar DNS) resolve para todos os dispositivos de uma vez.
