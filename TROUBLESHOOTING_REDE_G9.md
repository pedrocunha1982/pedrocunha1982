# Guia Definitivo de Troubleshooting - Rede do G9 (Home Assistant)

**Data:** 2025-01-02
**Autor:** Claude + Pedro Cunha
**Objetivo:** Resolver problemas de rede de forma definitiva, não paliativa

---

## Entendendo o Hardware do G9

### Portas Ethernet do GMKtec NucBox G9

O G9 tem **DUAS** portas ethernet 2.5G. Cada uma tem seu próprio MAC address:

| Porta Física | Interface Linux | MAC Address | Notas |
|--------------|-----------------|-------------|-------|
| **Porta 1** | `enp4s0` | `E0:51:D8:1A:5A:31` | Pode estar desabilitada por padrão |
| **Porta 2** | `enp5s0` | `E0:51:D8:1A:5A:32` | Porta em uso atualmente |

### WiFi (não recomendado para servidor)
| Interface | MAC Address |
|-----------|-------------|
| `wlo1` | `28:A4:4A:5D:DD:0B` |

---

## Problema #1: Home Assistant Sem Conexão de Rede

### Sintomas
- Não consegue acessar `http://192.168.0.84:8123`
- Ping para o IP não responde
- CLI do HA mostra "No address" para todas interfaces

### Causas Possíveis

#### 1. Interface de rede DESABILITADA
**Como verificar (no CLI do G9):**
```bash
network info
```

Se mostrar `enabled: false`, a interface está desabilitada.

**Solução:**
```bash
# Habilitar a porta ethernet 1 (enp4s0)
network update enp4s0 --enabled=true --ipv4-method=auto

# Habilitar a porta ethernet 2 (enp5s0)
network update enp5s0 --enabled=true --ipv4-method=auto
```

#### 2. Cabo na porta errada
O G9 tem duas portas físicas. Se você conectar o cabo em uma porta mas a reserva DHCP está configurada para o MAC da outra porta, o dispositivo vai pegar um IP diferente.

**Solução:**
- Verificar qual porta está com o cabo conectado
- Verificar o MAC dessa porta com `network info`
- Garantir que a reserva DHCP no roteador usa o MAC correto

#### 3. Cabo com mal contato
Cabos ethernet podem ter mal contato, especialmente se:
- O conector RJ45 está danificado
- O cabo foi dobrado demais
- A porta do switch/roteador está com problema

**Solução:**
- Testar com outro cabo
- Testar em outra porta do roteador
- Verificar se o LED da porta acende quando conecta

#### 4. Reserva DHCP com MAC errado
Se a reserva no roteador está configurada para um MAC diferente da porta em uso.

**Solução:**
1. Verificar MAC atual: `network info` no G9
2. Acessar roteador → Advanced → DHCP Server → Address Reservation
3. Corrigir o MAC na reserva

---

## Problema #2: IP Muda Após Reiniciar

### Sintomas
- Após reiniciar, o Home Assistant pega IP diferente (.85 em vez de .84)
- Reserva DHCP parece não funcionar

### Causas

#### 1. MAC da reserva não corresponde à porta em uso
Você reservou o IP para MAC `...5A:31` mas o cabo está na porta com MAC `...5A:32`.

**Solução:**
Atualizar a reserva para o MAC correto (ver seção de configuração abaixo).

#### 2. Interface muda após reiniciar
Se você trocou o cabo de porta, o sistema pode ter registrado a interface antiga.

**Solução:**
Habilitar AMBAS as interfaces para DHCP:
```bash
network update enp4s0 --enabled=true --ipv4-method=auto
network update enp5s0 --enabled=true --ipv4-method=auto
```

---

## Problema #3: G9 Não Aparece na Lista de Clientes do Roteador

### Sintomas
- Outros dispositivos aparecem, mas o G9 não
- O G9 está ligado mas sem rede

### Causas

#### 1. Cabo desconectado ou com defeito
**Verificar:**
- LED da porta ethernet no G9 acende?
- LED da porta no roteador acende?

#### 2. Todas as interfaces desabilitadas
**Verificar no CLI:**
```bash
network info
```

Se todas mostram `enabled: false`, habilitar:
```bash
network update enp4s0 --enabled=true --ipv4-method=auto
network update enp5s0 --enabled=true --ipv4-method=auto
```

#### 3. Problema de hardware
Raro, mas possível. Testar:
- Outro cabo
- Outra porta do roteador
- Outra porta do G9

---

## Configuração Correta (Definitiva)

### No G9 (Home Assistant CLI)

**1. Habilitar ambas as interfaces ethernet:**
```bash
network update enp4s0 --enabled=true --ipv4-method=auto
network update enp5s0 --enabled=true --ipv4-method=auto
```

**2. Verificar configuração:**
```bash
network info
```

Deve mostrar:
- `enabled: true` para as interfaces ethernet
- `ipv4: method: auto`

**3. Reiniciar se necessário:**
```bash
ha host reboot
```

### No Roteador (TP-Link Archer BE700)

**1. Acessar:** http://192.168.0.1
**2. Login:** Ordep1982
**3. Ir para:** Advanced → Network → DHCP Server

**4. Criar/Atualizar Address Reservation:**

| Campo | Valor |
|-------|-------|
| Device Name | `G9-HomeAssistant` |
| MAC Address | `E0-51-D8-1A-5A-32` |
| Reserved IP | `192.168.0.84` |
| Status | Enabled (toggle ON) |

**IMPORTANTE:** Use o MAC da porta onde o cabo está conectado!

**5. (Opcional) Criar reserva para a outra porta também:**

| Campo | Valor |
|-------|-------|
| Device Name | `G9-HomeAssistant-Port2` |
| MAC Address | `E0-51-D8-1A-5A-31` |
| Reserved IP | `192.168.0.84` |
| Status | Enabled |

Assim, não importa em qual porta o cabo estiver, sempre vai pegar o mesmo IP.

---

## Comandos Úteis do Home Assistant CLI

### Ver informações de rede
```bash
network info
```

### Habilitar interface ethernet
```bash
network update <interface> --enabled=true --ipv4-method=auto
```

### Configurar IP fixo (alternativa ao DHCP)
```bash
network update enp5s0 --ipv4-method=static --ipv4-address=192.168.0.84/24 --ipv4-gateway=192.168.0.1 --ipv4-nameserver=192.168.0.1
```

### Reiniciar rede
```bash
ha network reload
```

### Reiniciar o sistema
```bash
ha host reboot
```

### Ver logs de rede
```bash
ha network info
```

### Verificar status do supervisor
```bash
ha supervisor info
```

---

## Checklist de Diagnóstico Rápido

Quando o Home Assistant não estiver acessível, siga esta ordem:

### 1. Verificação Física (30 segundos)
- [ ] G9 está ligado? (LEDs acesos)
- [ ] Cabo ethernet conectado no G9?
- [ ] LED da porta ethernet do G9 acende/pisca?
- [ ] Cabo conectado no roteador? LED acende?

### 2. Verificação no CLI do G9 (1 minuto)
```bash
network info
```
- [ ] Alguma interface mostra IP?
- [ ] Interfaces estão `enabled: true`?
- [ ] Mostra `connected: true`?

### 3. Se não tem IP
```bash
network update enp5s0 --enabled=true --ipv4-method=auto
network update enp4s0 --enabled=true --ipv4-method=auto
```
Aguarde 30 segundos e verifique novamente.

### 4. Se ainda não funciona
- Trocar cabo
- Trocar porta do roteador
- Trocar porta do G9
- Reiniciar G9: `ha host reboot`

### 5. Verificar do Mac
```bash
ping 192.168.0.84
curl http://192.168.0.84:8123
```

---

## Prevenção de Problemas Futuros

### 1. Reservar IP para AMBOS os MACs
Configure duas reservas no roteador, uma para cada porta do G9, apontando para o mesmo IP.

### 2. Usar IP Fixo no Home Assistant (mais robusto)
Em vez de depender do DHCP, configurar IP estático:
```bash
network update enp5s0 --ipv4-method=static --ipv4-address=192.168.0.84/24 --ipv4-gateway=192.168.0.1 --ipv4-nameserver=192.168.0.1
```

### 3. Documentar a porta em uso
Marque fisicamente qual porta está sendo usada (fita adesiva, etiqueta).

### 4. Cabo de qualidade
Use cabo Cat6 ou superior, de boa qualidade, sem dobras excessivas.

### 5. Testar após mudanças
Sempre que mexer na rede, testar:
```bash
ping 192.168.0.84
```

---

## Informações de Referência

### IPs da Rede
| Dispositivo | IP | MAC |
|-------------|-----|-----|
| Roteador Archer BE700 | 192.168.0.1 | 68-7F-F0-07-AD-BC |
| G9 Home Assistant | 192.168.0.84 | E0-51-D8-1A-5A-32 (porta 2) |
| G9 Home Assistant | 192.168.0.84 | E0-51-D8-1A-5A-31 (porta 1) |

### URLs Importantes
- **Home Assistant:** http://192.168.0.84:8123
- **Roteador:** http://192.168.0.1
- **Observer (HA):** http://192.168.0.84:4357

### Credenciais
- **Roteador:** Ordep1982

---

## Histórico de Problemas Resolvidos

### 2025-01-02 - Problema de conexão recorrente
**Causa raiz:**
1. Interface `enp4s0` estava com `enabled: false`
2. Reserva DHCP estava para MAC `...5A:31` mas cabo estava na porta com MAC `...5A:32`
3. Cabo de força com mal contato

**Solução:**
1. Habilitar interface: `network update enp5s0 --enabled=true --ipv4-method=auto`
2. Atualizar reserva DHCP para MAC correto
3. Verificar cabo de força

---

*Este documento deve ser atualizado sempre que um novo problema for identificado e resolvido.*
